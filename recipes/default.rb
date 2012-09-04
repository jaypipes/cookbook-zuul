#
# Cookbook Name:: zuul
# Recipe:: default
#
# Copyright 2012, Jay Pipes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

pkey = "#{node[:zuul][:home]}/.ssh/id_rsa"
conf_path = node[:zuul][:conf_path]
layout_conf_path = node[:zuul][:layout_conf_path]
logging_conf_path = node[:zuul][:logging_conf_path]

user node[:zuul][:user] do
  home node[:zuul][:home]
end

directory node[:zuul][:home] do
  recursive true
  owner node[:zuul][:user]
  group node[:zuul][:group]
end

directory "#{node[:zuul][:home]}/.ssh" do
  mode 0700
  owner node[:zuul][:user]
  group node[:zuul][:group]
end

execute "ssh-keygen -f #{pkey} -N ''" do
  user node[:zuul][:user]
  group node[:zuul][:group]
  not_if { File.exists?(pkey) }
end

ruby_block "store zuul ssh pubkey" do
  block do
    node.set[:zuul][:pubkey] = File.open("#{pkey}.pub") { |f| f.gets }
  end
end

python_pip "zuul" do
  action [:install]
end

template "#{conf_path}" do
  source "zuul.conf.erb"
  notifies :restart, "service[zuul]"
  variables({
    :jenkins_url => node[:zuul][:jenkins][:url],
    :jenkins_user => node[:zuul][:jenkins][:user]
    :jenkins_apikey => node[:zuul][:jenkins][:apikey],
    :gerrit_url => node[:zuul][:gerrit][:url],
    :gerrit_user => node[:zuul][:gerrit][:user]
    :gerrit_sshkey => node[:zuul][:gerrit][:sshkey],
    :zuul_layout_conf_path => layout_conf_path,
    :zuul_logging_conf_path => logging_conf_path,
    :zuul_pidfile => pid_file,
    :zuul_state_dir => node[:zuul][:state_dir] 
  })
end

template "#{logging_conf_path}" do
  source "logging.conf.erb"
  notifies :restart, "service[zuul]"
  variables({
    :zuul_log_dir => node[:zuul][:log_dir]
  })
end

template "#{layout_conf_path}" do
  source "layout.yaml.erb"
  notifies :restart, "service[zuul]"
end

case node.platform
when "ubuntu", "debian"
  pid_file = "/var/run/zuul/zuul.pid"
  install_starts_service = true
when "centos", "redhat"
  pid_file = "/var/run/zuul.pid"
  install_starts_service = false
end

service "zuul" do
  supports [ :stop, :start, :restart, :status ]
  status_command "test -f #{pid_file} && kill -0 `cat #{pid_file}`"
  action :nothing
end
