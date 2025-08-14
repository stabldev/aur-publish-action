#!/bin/bash
set -o errexit -o pipefail -o nounset

echo "::group::Creating builder user"
useradd --create-home --shell /bin/bash builder
passwd --delete builder
mkdir -p /etc/sudoers.d/
echo "builder  ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/builder
echo "::endgroup::"

echo "::group::Initializing SSH directory"
mkdir -p /home/builder/.ssh
touch /home/builder/.ssh/known_hosts
cp /ssh_config /home/builder/.ssh/config
chown -R builder:builder /home/builder
chmod 700 /home/builder/.ssh
chmod 600 /home/builder/.ssh/config /home/builder/.ssh/known_hosts
echo "::endgroup::"

exec runuser builder --command "bash -l -c /build.sh"
