from setuptools import setup

def readme():
    with open("README.md") as f:
        return f.read()

setup(
    name="nixspamsocket",
    version="0.1",
    license="MIT",

    author="Carsten Rosenberg",
    author_email="c.rosenberg@HeinleinSupport.de",

    url = "https://github.com/HeinleinSupport/rspamd-plugins/tree/master/nixspam/nixspamsocket",
    description="Expose nixspam on a socket",
    long_description=readme(),

    py_modules=["nixspamsocket"],
    entry_points={
        "console_scripts": [
            "nixspamsocket=nixspamsocket:main",
        ],
    },
    install_requires=[
        "nixspam>=1.0.0",
    ],

    classifiers=[
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3 :: Only",
    ],
    keywords="nixspam spam",
)
