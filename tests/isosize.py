from basetest import BaseTest
from testapi import get_var
import autotest

class IsoSizeTest(BaseTest):
    def run(self):
        iso = get_var("ISO")
        size = os.path.getsize(iso)
        result = 'ok' if size <= get_var("ISO_MAXSIZE") else 'fail'
        autotest.bmwqemu.diag(f"Check if actual ISO size {size} fits {get_var('ISO_MAXSIZE')}: {result}")
        self.result(result)

    @staticmethod
    def test_flags():
        return { 'important': 1 }

if __name__ == "__main__":
    test = IsoSizeTest()
    test.run()
