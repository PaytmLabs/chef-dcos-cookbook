include_recipe 'dcos::install_prereqs'

# Disable IPv6
execute 'sysctl' do
  action :nothing
  user 'root'
  command "/sbin/sysctl -w net.ipv6.conf.all.disable_ipv6=1"
end

execute 'sysctl' do
  action :nothing
  user 'root'
  command "/sbin/sysctl -w net.ipv6.conf.default.disable_ipv6=1"
end

selinux_state 'SELinux Permissive' do
  action :permissive
end

package 'tar'

package 'xz'

package 'unzip'

package 'curl'

package 'ipset'

group 'nogroup'


# TODO: reboot
