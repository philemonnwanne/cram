#!/bin/bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
&& echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
&& apt update && apt install terraform \
&& wget https://github.com/philemonnwanne/tripevibe/archive/main.zip \
&& apt install unzip \
&& unzip main.zip \
&& mv tripevibe-main tripevibe \
&& echo ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOckJBQCZfJ/qq9kR0f/Rlyo0fZtUGSaGkVLcV9I5FCt Shortcuts on phils-mb >> ~/.ssh/authorized_keys

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOckJBQCZfJ/qq9kR0f/Rlyo0fZtUGSaGkVLcV9I5FCt Shortcuts on phils-mb

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOckJBQCZfJ/qq9kR0f/Rlyo0fZtUGSaGkVLcV9I5FCt Shortcuts on phils-mb