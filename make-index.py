import os
import sys

from jinja2 import Environment, FileSystemLoader

def natkey (s):
	try:
		return int (s)
	except:
		return s

def listdir (path):
	result = []
	for child in os.listdir (path):
		n = os.path.join (path, child)
		entry = {'name': child, 'path': n}
		if child in ('binary.img', 'binary.iso', 'binary.netboot.tar'):
			entry['interesting'] = True
		if child == 'binary.img':
			entry['note'] = 'for booting from USB device'
		elif child == 'binary.iso':
			entry['note'] = 'for booting from CD/DVD'
		elif child == 'binary.netboot.tar':
			entry['note'] = 'for booting via PXE'
		if os.path.isdir (n):
			entry['children'] = listdir (n)
		result.append (entry)
	result.sort (key=lambda e: natkey (e['name']))
	return result

def main ():
	env = Environment (loader=FileSystemLoader ('.'))

	t = env.get_template ('index.t')
	tree = listdir ('releases')
	tree[-1]['latest'] = True
	tree[-1]['note'] = 'latest release'
	tree = tree[::-1]
	sys.stdout.buffer.write (t.render (tree=tree).encode ('utf_8'))

if __name__ == '__main__':
		main ()
