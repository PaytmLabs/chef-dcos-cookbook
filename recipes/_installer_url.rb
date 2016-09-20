#
# Cookbook Name:: dcos
# Recipe:: _installer_url.rb
#

if node['dcos']['dcos_edition'].eql? 'open'
  node.default['dcos']['installer_url'] = 'https://downloads.dcos.io/dcos/' + node['dcos']['dcos_version'] + '/dcos_generate_config.sh'
else
  node.default['dcos']['installer_url'] = 'https://downloads.mesosphere.io/dcos-enterprise/' + node['dcos']['dcos_version'] + '/dcos_generate_config.ee.sh'
end

