#
# Cookbook Name:: dcos
# Recipe:: install_cli
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

# All of the following steps have been adapted from the DC/OS official
# documentation.
# https://dcos.io/docs/1.7/administration/installing/custom/cli/

# Install common DC/OS node prerequisites
include_recipe 'dcos::install_prereqs'

# Download DC/OS installer file
remote_file '/root/dcos_generate_config.sh' do
  source 'https://downloads.dcos.io/dcos/EarlyAccess/dcos_generate_config.sh'
  mode '0755'
end

# Create genconf directory
directory '/root/genconf' do
  mode '0755'
end

# Generate the config.yaml file
template '/root/genconf/config.yaml' do
  source 'config.yaml.erb'
end

# Copy SSH key
file '/root/genconf/ssh_key' do
  content IO.read(node['dcos']['ssh_key_file'])
  owner 'root'
  group 'root'
  mode '0600'
  action :create
end

# Generate the ip-detect script
include_recipe 'dcos::_ip-detect'

# Start DC/OS install process
# 1. Configuration generation
execute 'dcos-genconf' do
  command '/root/dcos_generate_config.sh --genconf'
  user 'root'
  cwd '/root'
  not_if do
    File.exist?('/root/genconf/cluster_packages.json')
  end
end

# 2. Install cluster prerequisites
execute 'dcos-prereqs' do
  command '/root/dcos_generate_config.sh --install-prereqs'
  user 'root'
  cwd '/root'
end

# 3. Pre-flight validation
execute 'dcos-preflight' do
  command '/root/dcos_generate_config.sh --preflight'
  user 'root'
  cwd '/root'
end

# 4. Install/deploy DC/OS
execute 'dcos-deploy' do
  command '/root/dcos_generate_config.sh --deploy'
  user 'root'
  cwd '/root'
end

# 5. Post-flight validation
execute 'dcos-preflight' do
  command '/root/dcos_generate_config.sh --postflight'
  user 'root'
  cwd '/root'
end

# DONE!
