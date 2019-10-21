import os
import pexpect
from pexpect import *

try:
    print(os.environ['target_db_schema'])
    print(os.environ['wc1_home'])
except KeyError:
    print ("Please set ugm env vars before proceeding")
    sys.exit(1)
child = pexpect.spawn('./$wc1_home/Windchill/bin/UpgradeManager.sh -noui')
child.expect ('*Next')
child.sendline ('\n')
child.expect ('*Next')
child.sendline ('\n')
child.expect ('Gather System Properties and set framework logger')
child.sendline ('$target_db_schema')