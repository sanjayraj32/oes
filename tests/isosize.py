import os
from testapi import *


def run(self):
    iso = get_var("ISO")
    size = os.path.getsize(iso)
    iso_maxsize = int(get_var("ISO_MAXSIZE"))
    result = 'ok' if size <= iso_maxsize else 'fail'

        # autotest.bmwqemu.diag(f"Check if actual ISO size {size} fits {get_var('ISO_MAXSIZE')}: {result}")

def test_flags(self):
    return { 'important': 1 }
