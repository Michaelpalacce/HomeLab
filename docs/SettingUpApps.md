# Setting up apps

### Setting up any app:
- Run `ansible-playbook -i inventory playbooks/apps/app/main.yml --extra-vars "appName=APP_NAME_HERE"`

### Setting up n8n
- Setup app postgresql
- Wait for pgAdmin to be up and running, login with credentials specific in values.
- Add server. Hostname: `postgresql.postgresql`. Username: `postgresql`. Password: `postgresql`
- Create new database n8n
- Create a new user n8n and give it permissions to the n8n db
- Run `ansible-playbook -i inventory playbooks/apps/app/main.yml --extra-vars "appName=n8n"`

### Setting up wikijs
- Setup app postgresql
- Wait for pgAdmin to be up and running, login with credentials specific in values.
- Add server. Hostname: `postgresql.postgresql`. Username: `postgresql`. Password: `postgresql`
- Create new database wikijs
- Create a new user wikijs and give it permissions to the wikijs db
- Run `ansible-playbook -i inventory playbooks/apps/app/main.yml --extra-vars "appName=wikijs"`

### Setting up freshrss
- Setup app postgresql
- Wait for pgAdmin to be up and running, login with credentials specific in values.
- Add server. Hostname: `postgresql.postgresql`. Username: `postgresql`. Password: `postgresql`
- Create new database freshrss
- Create a new user freshrss and give it permissions to the freshrss db
- Run `ansible-playbook -i inventory playbooks/apps/app/main.yml --extra-vars "appName=freshrss"`

### Setting up storage ( syncthing + ServerEmulator )
- Run `ansible-playbook -i inventory playbooks/apps/app/main.yml --extra-vars "appName=storage"`
- Go to your other device and add this one for syncthing :)
- For ServerEmulator you can use the root:toor credentials

### Setting up Vikunja
- Setup app postgresql
- Wait for pgAdmin to be up and running, login with credentials specific in values.
- Add server. Hostname: `postgresql.postgresql`. Username: `postgresql`. Password: `postgresql`
- Create new database vikunja
- Create a new user vikunja with pass vikunja and give it permissions to the vikunja db
- IF YOU WANT SMTP: Go to the vikunja Helm values and modify the smtp settings. Change enabled to true and enter your
  email details ( please use an app password instead of your actual password to your mail client ). Note that gmail settings
  are entered but you can choose to use any smtp client you wish
- Run `ansible-playbook -i inventory playbooks/apps/app/main.yml --extra-vars "appName=vikunja"`
-
### Setting up Wallabag
- Setup app postgresql
- Wait for pgAdmin to be up and running, login with credentials specific in values.
- Add server. Hostname: `postgresql.postgresql`. Username: `postgresql`. Password: `postgresql`
- The wallabag docker image creates a postgresql user and db itself
- Make sure to edit the values.yaml and change the `domainName` to your own one.
- Run `ansible-playbook -i inventory playbooks/apps/app/main.yml --extra-vars "appName=wallabag"`

### Setting up Media Services
- Read `Helm/apps/media/README.md` on some of the decisions taken
- I have decided I will use a pi called `ubunutu-1` for this purpose
- Run `kubectl label no PI48-ubuntu-3 type=media`
- Run `ansible-playbook -i inventory playbooks/apps/app/main.yml --extra-vars "appName=media"`

### Setting up monitoring
- Run `ansible-playbook -i inventory playbooks/apps/app/main.yml --extra-vars "appName=monitoring"` Initialize Prometheus and Grafana
- Go to http://{{CLUSTER_URI}}:30010
- Username: admin  Password: admin
- It will prompt you to change the password
- Go to Settings/DataSources and add a Prometheus Datasource
- Set URL to prometheus:9090
- Import the dashboard located in ./config/ by clicking on the plus and then import
- Go to the dashboard :) It will take a few minutes to populate data

### Setting up Jenkins
- Run `ansible-playbook -i inventory playbooks/apps/jenkins/main.yml` Install Jenkins CI/CD.
- Go to http://{{CLUSTER_URI}}:31100
- Install all the kubernetes pluguins and any other plugins you may need.
- How to configure:
~~~
Name: Kubernetes
Kubernetes URL: <blank>
Kubernetes Namespace: jenkins-pi
Credentials: {{ADD new with Service Account}}
WebSocket: yes
Direct: no
Jenkins URL: http://{{CLUSTER_IP}}:31100 # had to put in my whole ip here, service name did not work
Jenkins tunnel: <blank>
# Add new pod template
name: whatever
namespace: jenkins-pi
labels: SomeLabel

#Add container template
name: jnlp
Docker Image: stefangenov/jenkins-agent-node:node-16.7 # I have made a custom Node image that runs for arm processors, but you can check my docker repo and make your own
Working directory: /home/jenkins/agent
Command to run: <blank>
arguments passed: <blank>
Allocate pseudo TTY: yes

#Scroll down and search for Service account
Service account: jenkins

# That should be all, but if you have different requirements you can set them up
~~~
