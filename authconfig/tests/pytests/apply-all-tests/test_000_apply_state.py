import os
import platform
from subprocess import check_output
from unittest import skipIf, TestCase

DISTRO = platform.linux_distribution()[0].split(' ')[0].lower()


class ApplyStateTest(TestCase):

    def test_000_apply(self):
        state_apply_response = check_output(["salt-call", "--local", "state.apply"])
        print('')
        print('-' * 50)
        print('state_apply_response:')
        print(state_apply_response)
        print('-' * 50)
        print('')

        state_apply_response = state_apply_response.split('\n')
        summary = state_apply_response[-8:]
        failed = 0
        for line in summary:
            if line.startswith('Failed:'):
                failed = int(line.split(':').pop().strip())

        self.assertEqual(failed, 0)

    @skipIf(DISTRO == 'centos', 'skip test on centos')
    def test_001_ntp_conf_exists(self):
        self.assertTrue(os.path.isfile('/etc/ntp.conf'))

    def test_001_nsswitch_conf_exists(self):
        self.assertTrue(os.path.isfile('/etc/nsswitch.conf'))

    def test_001_smb_conf_exists(self):
        self.assertTrue(os.path.isfile('/etc/samba/smb.conf'))

    @skipIf(DISTRO == 'centos', 'skip test on centos')
    def test_001_pam_configs_mkhomedir_exists(self):
        self.assertTrue(os.path.isfile('/usr/share/pam-configs/mkhomedir'))

    @skipIf(DISTRO == 'centos', 'skip test on centos')
    def test_001_pam_configs_access_exists(self):
        self.assertTrue(os.path.isfile('/usr/share/pam-configs/access'))
