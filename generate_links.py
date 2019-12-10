import sys
import os

def find_html(directory):
    for filename in os.listdir(directory):
        path = os.path.join(directory, filename)
        if path.endswith('.html'):
            yield path


def get_links(paths):
    links = []
    for path in paths:
        name, _ = os.path.splitext(path)
        links.append(f'<a href="/wasm-fuzzing-demo/{path}">{name}</a><br>')
    return links

def main():
    directory = sys.argv[1]
    paths = find_html(directory)
    print('\n'.join(get_links(paths)))


if __name__ == '__main__':
    main()
