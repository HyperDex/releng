# Copyright (c) 2013-2014, Robert Escriva
# All rights reserved.

import os
import os.path
import re
import shutil
import subprocess
import sys
import urlparse

from bs4 import BeautifulSoup
import bs4.element as Elements

################################################################################
#################################### Filters ###################################
################################################################################

############################## remove bad classes ##############################

BAD_CLASSES = set([
    'indent',
    'noindent',
    ])

def filter_bad_classes(filename):
    soup = BeautifulSoup(open(filename).read())
    for tag in soup():
        if not tag.has_attr('class'):
            continue
        classes = [x for x in tag['class'] if x not in BAD_CLASSES]
        if not classes:
            del tag['class']
        else:
            tag['class'] = classes
    f = open(filename, 'w')
    f.write(str(soup))
    f.flush()
    f.close()

############################# remove some nav divs #############################

def filter_undesirables(filename):
    soup = BeautifulSoup(open(filename).read())
    for tag in soup.findAll('div'):
        if tag.has_attr('class') and 'crosslinks' in tag['class']:
            tag.extract()

    for tag in soup():
        if tag.has_attr('class') and 'likechapterToc' in tag['class']:
            tag = tag.extract()
        elif tag.has_attr('class') and 'likechapterHead' in tag['class']:
            tag = tag.extract()
    f = open(filename, 'w')
    f.write(str(soup))
    f.flush()
    f.close()

########################## fixup the Table of Contents #########################

def filter_contentsname(references, path, index):
    filename = os.path.join(path, 'contentsname.html')
    filter_bad_classes(filename)
    filter_undesirables(filename)
    soup = BeautifulSoup(open(filename).read())
    for a in soup.findAll('a'):
        url = a.get('href')
        if not url:
            continue
        u = urlparse.urlparse(a.get('href'))
        if u.scheme != '' or u.netloc != '':
            continue
        assert u.path.endswith('.html') or u.path == ''
        fragment = u.fragment
        if fragment and fragment not in references:
            print 'warning: unknown refid %r in %r' % (fragment, filename)
        fragment = references.get(fragment, fragment)
        if fragment != u.fragment:
            if a.has_attr('id') and a['id'] not in references:
                references[a['id']] = u.fragment
            u = ('', '', u.path, u.params, u.query, fragment)
            a['href'] = urlparse.urlunparse(u)
            a['id'] = fragment
    f = open(os.path.join(path, index + '.html'), 'w')
    f.write(str(soup))
    f.flush()
    f.close()
    os.unlink(filename)

############## Turn TeX4ht references into human-readable strings ##############

def filter_references(references, index, filename):
    soup = BeautifulSoup(open(filename).read())
    for a in soup.findAll('a'):
        url = a.get('href')
        if not url:
            continue
        u = urlparse.urlparse(url)
        if u.scheme != '' or u.netloc != '':
            continue
        assert u.path.endswith('.html') or u.path == ''
        fragment = u.fragment
        if fragment and fragment not in references:
            if u.path == index + '.html' and u.fragment.startswith('QQ') and a.has_attr('id'):
                fragment = a['id']
            else:
                print 'warning: unknown refid %r in %r' % (fragment, filename)
                continue
        if not fragment:
            continue
        while references.get(fragment, fragment) != fragment:
            fragment = references.get(fragment, fragment)
        path = u.path
        if u.path == 'contentsname.html':
            path = index + '.html'
        u = ('', '', path, u.params, u.query, fragment)
        a['href'] = urlparse.urlunparse(u)
    for tag in soup():
        if not tag.has_attr('id'):
            continue
        if tag['id'] in references:
            tag['id'] = references[tag['id']]
    f = open(filename, 'w')
    f.write(str(soup))
    f.flush()
    f.close()

########################## Change div.fancyvrb to pre ##########################

def filter_fancyvrb(filename):
    soup = BeautifulSoup(open(filename).read())
    for tag in soup.select('.fancyvrb > tspan'):
        assert(len(list(tag.children)) == 1)
        if tag.parent is not None:
            tag.replace_with(list(tag.children)[0])
    for tag in soup.select('.fancyvrb br'):
        if tag.parent is not None:
            tag.replace_with('\n')
    for tag in soup.select('div.fancyvrb'):
        tag.name = 'pre'
    f = open(filename, 'w')
    f.write(str(soup))
    f.flush()
    f.close()

################################ remove comments ###############################

def filter_comments(filename):
    soup = BeautifulSoup(open(filename).read())
    def is_comment(text):
        return isinstance(text, Elements.Comment)
    comments = soup.findAll(text=is_comment)
    [comment.extract() for comment in comments]
    f = open(filename, 'w')
    f.write(str(soup))
    f.flush()
    f.close()

############################## Firmant integration #############################

def filter_firmant(prefix, filename):
    soup = BeautifulSoup(open(filename).read())
    for a in soup.findAll('a'):
        url = a.get('href')
        if not url or not a.has_attr('href'):
            continue
        u = urlparse.urlparse(url)
        if u.scheme != '' or u.netloc != '' or not u.path.endswith('html'):
            continue
        path = '{{ url(doc="' + prefix + '/' + u.path[:-5] + '") }}'
        u = u.scheme, u.netloc, path, u.params, u.query, u.fragment
        a['href'] = urlparse.urlunparse(u)
    s = str(soup)
    assert '<body>' in s
    assert '</body>' in s
    s = s[s.index('<body>') + 6:]
    s = s[:s.index('</body>')]
    s = s.strip()
    s = '''{% extends "doc.html" %}

{% block content %}
''' + s
    s += '{% endblock %}\n'
    f = open(filename[:-5] + '.jinja2', 'w')
    f.write(s)
    f.flush()
    f.close()
    os.unlink(filename)

################################################################################
################################## Processing ##################################
################################################################################

def list_html_files(path):
    files = [os.path.join(path, x) for x in os.listdir(path)
             if x.endswith('.html')]
    for x in files:
        assert os.path.isfile(x)
    return files

def gather_references(path):
    ref_re = re.compile(r'\\newlabel\{(?P<refname>.*?)\}.*?\\rEfLiNK\{(?P<refid>.*?)\}')
    references = {}
    for aux in os.listdir(path):
        if not aux.endswith('.aux'):
            continue
        for line in open(os.path.join(path, aux)):
            if not line.startswith('\\newlabel'):
                continue
            m = ref_re.search(line)
            if m:
                gd = m.groupdict()
                references[gd['refid']] = gd['refname']
    for v in references.values():
        if v not in references:
            references[v] = v
    return references

def process(path, prefix, index):
    references = gather_references(path)
    filter_contentsname(references, path, index)
    for x in list_html_files(path):
        filter_bad_classes(x)
        filter_undesirables(x)
        filter_references(references, index, x)
        filter_fancyvrb(x)
        filter_comments(x)
        filter_firmant(prefix, x)
    for x in ('.4ct', '.4tc', '.aux', '.css', '.dvi', '.idv', '.idx', 'j.aux',
              '.lg', '.log', '.tmp', '.xref'):
        p = os.path.join(path, index + x)
        if os.path.exists(p):
            os.unlink(p)

if os.path.exists('html'):
    shutil.rmtree('html')
os.mkdir('html')
args = ['htlatex', '../hyperdex.tex',
        'xhtml,2,sec-filename,sections+,fn-in,nominitoc,TocLink,bibtex2,index=1',
        '', '', '-shell-escape']
subprocess.check_call(args, cwd='html')
process('html', sys.argv[1] if len(sys.argv) >= 2 else 'latest', 'hyperdex')
