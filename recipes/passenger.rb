include_recipe 'apache2'
include_recipe 'rbenv'

apt_repository 'passenger' do
  uri          'https://oss-binaries.phusionpassenger.com/apt/passenger'
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          '561F9B9CAC40B2F7'
end

package "libapache2-mod-passenger"

template "#{node['apache']['dir']}/mods-available/passenger.conf" do
  cookbook 'instedd-common'
  source 'passenger.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :reload, 'service[apache2]', :delayed
  variables \
    passenger_root: lazy { `/usr/bin/passenger-config --root`.chomp },
    passenger_ruby: "#{node['rbenv']['root_path']}/shims/ruby"
end

apache_module 'passenger'
