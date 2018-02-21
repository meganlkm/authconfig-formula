import os
from subprocess import check_output
from unittest import TestCase


class ApplyDiscoveryTest(TestCase):

    def test_000_apply_discovery(self):
        state_apply_response = check_output(["salt-call", "--local", "state.apply", "authconfig.discovery"]).split('\n')
        summary = state_apply_response[-8:]
        failed = 0
        for line in summary:
            if line.startswith('Failed:'):
                failed = int(line.split(':').pop().strip())
        self.assertEqual(failed, 0)

    def test_001_srvlookup_exists(self):
        self.assertTrue(os.path.isdir('/var/tmp/srvlookup'))

    def test_002_dclocator_exists(self):
        self.assertTrue(os.path.isfile('/var/tmp/dclocator.py'))
