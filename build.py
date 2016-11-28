from jinja2 import Environment, FileSystemLoader
import os
import random
import sys

PATH = os.path.dirname(os.path.abspath(__file__))
TEMPLATE_ENVIRONMENT = Environment(
    autoescape=False,
    loader=FileSystemLoader(os.path.join(PATH, 'templates')),
    trim_blocks=False)


def render_template(template_filename, context):
    return TEMPLATE_ENVIRONMENT.get_template(template_filename).render(context)


def main():
    with open('contracts/Raffle.sol', 'w') as f:
        context = {
            "first": random.randint(1, 69),
            "second": random.randint(1, 69),
            "third": random.randint(1, 69),
            "fourth": random.randint(1, 69),
            "fifth": random.randint(1, 69),
            "sixth": random.randint(1, 26),
        }
        output = render_template('Raffle.sol', context)
        f.write(output)


if __name__ == "__main__":
    sys.exit(main())
