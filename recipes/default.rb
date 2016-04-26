#
# Cookbook Name:: dcos
# Recipe:: default
#
# Copyright 2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Prereqs
selinux_state 'SELinux Permissive' do
  action :permissive
end

service 'firewalld' do
  action [:stop, :disable]
end

package 'unzip'

package 'ipset'

group 'nogroup'

# Install docker with overlayfs
docker_service 'default' do
  storage_driver 'overlay'
  action [:create, :start]
end

# Note this link does not have versioning, so using it will always be the latest
# DCOS from 'testing' and this URL might change in the future.
# https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/dcos_generate_config.sh
remote_file '/root/dcos_generate_config.sh' do
  source 'https://downloads.dcos.io/dcos/EarlyAccess/dcos_generate_config.sh'
  mode '0755'
end

directory '/root/genconf' do
  mode '0755'
end

template '/root/genconf/config.yaml' do
  source 'config.yaml.erb'
end

# generate the /root/genconf/ip-detect script
include_recipe 'dcos::_ip-detect'

execute 'dcos-genconf' do
  command '/root/dcos_generate_config.sh --genconf'
  user 'root'
  cwd '/root'
  not_if do
    File.exist?('/root/genconf/cluster_packages.json')
  end
end

file '/root/genconf/serve/dcos_install.sh' do
  mode '0755'
  subscribes :create, 'execute[dcos-genconf]', :immediately
  action :nothing
end

execute 'dcos_install' do
  command "/root/genconf/serve/dcos_install.sh #{node['dcos']['dcos_role']}"
  user 'root'
  cwd '/root'
  subscribes :run, 'file[/root/genconf/serve/dcos_install.sh]', :immediately
  action :nothing
end
