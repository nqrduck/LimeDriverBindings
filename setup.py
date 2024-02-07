from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext

import subprocess
import os

from Cython.Build import cythonize

class BuildExtCommand(build_ext):
    """Custom build_ext command to ensure that the submodule is retrieved and built."""

    def build_extensions(self):
        os.environ['CXX'] = 'h5c++'
        super().build_extensions()

    def run(self):
        if not os.path.exists('extern/limedriver'):
            self.clone_limedriver()

        self.build_limedriver()

        super().run()

    def clone_limedriver(self):
        subprocess.check_call(['git', 'submodule', 'init'])
        subprocess.check_call(['git', 'submodule', 'update'])

    def build_limedriver(self):
        subprocess.check_call(['./configure'], cwd='extern/limedriver')
        subprocess.check_call(['make'], cwd='extern/limedriver')

ext_modules = [
    Extension(
        'limedriver',
        sources=['src/limedriver/limedriver.pyx'],
        include_dirs=["extern/limedriver/src/"],
        libraries=["LimeSuite"],
    ),
]

setup(
    name='limedriver',
    
    cmdclass={
        'build_ext': BuildExtCommand,
    },

    ext_modules=cythonize(ext_modules),
)
