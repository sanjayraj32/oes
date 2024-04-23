import sys

# Import necessary modules
from testapi import *
import autotest

def load_boot_tests_oes():
    if get_var("ISO_MAXSIZE"):
        autotest.loadtest('tests/isosize.py')

#def load_inst_tests_oes():
    #autotest.loadtest('tests/welcome.py')

if get_var("INSTALL"):
    if not get_var("AUTOYAST"):
        # Default Installation
        load_boot_tests_oes()
        #load_inst_tests_oes()

sys.exit(0)
