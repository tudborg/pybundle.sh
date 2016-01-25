#---pybundle.sh---
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), 'lib', 'python%d.%d' % (sys.version_info.major, sys.version_info.minor), 'site-packages'))
#---end---
import click

@click.command()
@click.option('--count', default=1, help='Number of greetings.')
@click.option('--name', prompt='Your name',
              help='The person to greet.')
def hello(count, name):
    """Simple program that greets NAME for a total of COUNT times."""
    for x in range(count):
        click.echo('Hello %s!' % name)
hello()
