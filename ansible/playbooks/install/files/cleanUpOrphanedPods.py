import subprocess
import select
import re
import shutil

f = subprocess.Popen(['tail', '-F', '/var/log/syslog'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
p = select.poll()
p.register(f.stdout)

while True:
    if p.poll(1):
        line = f.stdout.readline().decode('utf-8')
        result = re.search('orphaned pod \\\\"([0-9a-zA-Z-]*)\\\\"', line)
        if result:
            toDelete = '/var/lib/kubelet/pods/' + result.group(1)
            try:
                shutil.rmtree(toDelete)
                print(toDelete + " was deleted")
            except:
                print(toDelete + " could not be deleted")
