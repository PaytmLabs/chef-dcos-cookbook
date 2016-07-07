# This is only necessary for the bootstrap node
# See https://dcos.io/docs/1.7/administration/installing/custom/system-requirements/
# Section: Bootstrap node

include_recipe 'dcos::install_advanced_prereqs'

docker_image 'nginx' do
  action :pull
  notifies :redeploy, 'docker_container[dcos_nginx]'
end

# Create genconf directory
directory '/root/genconf' do
  mode '0755'
end

# Generate the config.yaml
template '/root/genconf/config.yaml' do
  source 'config.yaml.erb'
end

# Generate the /root/genconf/ip-detect script
include_recipe 'dcos::_ip-detect'

# Download DC/OS installer
remote_file '/root/dcos_generate_config.sh' do
  source 'https://downloads.dcos.io/dcos/EarlyAccess/dcos_generate_config.sh'
  mode '0755'
end

# Generate DC/OS customized build file
execute 'dcos-genconf' do
  command '/root/dcos_generate_config.sh'
  user 'root'
  cwd '/root'
end

# Host the DC/OS install in an nginx Docker container
docker_container 'dcos_nginx' do
  repo 'nginx'
  port '80:80' # TODO: get port from bootstrap_url
  volumes [ '/root/genconf/serve:/usr/share/nginx/html:ro' ]
end

