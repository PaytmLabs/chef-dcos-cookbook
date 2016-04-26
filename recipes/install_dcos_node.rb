include_recipe 'dcos::install_advanced_prereqs'

# Create temp install directory
directory '/tmp/dcos' do
  user 'root'
  mode '0755'
end

# Get install script from bootstrap node
remote_file '/tmp/dcos/dcos_install.sh' do
  # TODO: get bootstrap URL
  source "http://#{node['dcos']['bootstrap_url']}/dcos_install.sh"
  mode '0755'
end

# Install DC/OS on this node, specifying the role (master, slave, slave_public)
execute 'dcos_install' do
  command "/tmp/dcos/dcos_install.sh #{node['dcos']['dcos_role']}"
  user 'root'
  cwd '/tmp/dcos'
  subscribes :run, 'file[/root/genconf/serve/dcos_install.sh]', :immediately
  action :nothing
end
