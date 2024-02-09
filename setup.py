from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext

import subprocess
import os

from Cython.Build import cythonize

os.environ['CXX'] = 'h5c++'

class BuildExtCommand(build_ext):
    """Custom build_ext command to ensure that the submodule is retrieved and built."""

    def build_extensions(self):
        super().build_extensions()

    def run(self):
        if not os.path.exists('extern/limedriver/src'):
            self.clone_limedriver()

        super().run()

    def clone_limedriver(self):
        subprocess.check_call(['git', 'submodule', 'init'])
        subprocess.check_call(['git', 'submodule', 'update'])

    def build_limedriver(self):
        subprocess.check_call(['./configure'], cwd='extern/limedriver')
        subprocess.check_call(['make'], cwd='extern/limedriver')

ext_modules = [
    Extension(
        'limedriver.binding',
        sources=['src/limedriver/limedriver.pyx', 'extern/limedriver/src/limedriver.cpp'],
        include_dirs=["extern/limedriver/src/"],
        libraries=["LimeSuite"],
        language="c++",
    ),
]

setup(
    name='limedriver',
    
    cmdclass={
        'build_ext': BuildExtCommand,
    },

    ext_modules=cythonize(ext_modules),
)
