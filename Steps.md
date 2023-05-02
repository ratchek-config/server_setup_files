# Intro
**Written for my personal use. Comes with no guarantees and I am not responsible for any effects of you using this.**
A step by step process for spinning up a django environment on digital ocean from scratch.
This includes a github account, a local dev environment, ssl certificates, some basic server hardening.

# Variables
There's a bunch of stuff you'll need to keep track of or remember, so here's a space to copy/paste them.
**DO NOT SAVE THESE. DO NOT COMMIT THESE.**

YOUR_DROPLET_IP -
DJANGO_POSTGRES_PASSWORD -
DOMAIN_NAME -
GITHUB_REPO_URL -
SERVER_SUDO_PASSWORD -
PROJECT_NAME -

# Steps
## Digital Ocean
Log in to Digital Ocean.
Create project if necessary.
Create droplet using the computer's ssh keys
Save the droplet IP
(The IP shows up in a lot of commands that it would be nice to just copy/paste, so just download this file and then search and replace YOUR_DROPLET_IP with your actual IP)
(It's for this same reason that I'm not surrounding terminal commands with backticks)
## Domain ##
Register a domain or subdomain
Make sure to point the domain/subdomain to the Digital Ocean's droplet's IP address

## Github ##
Create a project repo and copy the url

## Local Machine ##
On your local/dev machine:
Navigate to wherever dir you store your projects in.
curl -O https://raw.githubusercontent.com/ratchek-config/server_setup_files/master/local_setup_script
chmod u+x local_setup_script
./local_setup_script


## Server ##
### Log in and basic setup
#### Setup users, ssh keys, and disable root
ssh root@YOUR_DROPLET_IP
adduser tomek
(make sure to remember the password!)
usermod -aG sudo tomek
rsync --archive --chown=tomek:tomek ~/.ssh /home/tomek
logout

### Run script one
#### Log back in with new user
ssh tomek@YOUR_DROPLET_IP
#### Start up Tmux session
tmux new -s setup

#### Download server setup script, modify permissions, and run it
curl -O https://raw.githubusercontent.com/ratchek-config/server_setup_files/master/server_setup_step_one
curl -O https://raw.githubusercontent.com/ratchek-config/server_setup_files/master/server_setup_step_two
chmod u+x server_setup_step_one
chmod u+x server_setup_step_two
./server_setup_step_one | tee server_setup_step_one_output

### Setup database
The first script should have finished with a reboot, so you'll need to log back in (with new port uuuuuu exciting)
ssh -p 6979 tomek@YOUR_DROPLET_IP
#### Launch psql
sudo -u postgres psql
#### Run the commands.
You can copy and paste all of the following up to (but not including) the \q in one go, just make sure to first replace the DJANGO_POSTGRES_PASSWORD variable with an actual postgres password (And make sure to remember it for later)

CREATE DATABASE PROJECT_NAME;
CREATE USER django WITH PASSWORD 'DJANGO_POSTGRES_PASSWORD';
ALTER ROLE django SET client_encoding TO 'utf8';
ALTER ROLE django SET default_transaction_isolation TO 'read committed';
ALTER ROLE django SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE PROJECT_NAME TO django;

#### Quit psql
\q
(funny that I need to include this, but I always end up googling it)

### Generate github deploy keys
#### Generate keys
ssh-keygen -t ed25519 -C 'git@ratchek.com' -f '/home/tomek/.ssh/id_ed25519' -q -N ''
#### Copy pub key to github
cat ~/.ssh/id_ed25519.pub
Copy this to DEPLOY keys in the project repo's github settings. NOT SSH KEYS!!!

### Run script two
./server_setup_step_two | tee server_setup_step_two_output


# The End
That's it! You're done.
Btw, automating this to that extent, took way more time than I expected, so I hope you appreciate this future Thomas.
