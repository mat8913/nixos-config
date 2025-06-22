#!/usr/bin/env python3
from setuptools import setup

setup(
    name='nmwgrefresh',
    version='1',
    packages=['nmwgrefreshlib'],
    entry_points={
        'console_scripts': [
            'nmwgrefresh = nmwgrefreshlib.lib:main',
        ],
    },
)
