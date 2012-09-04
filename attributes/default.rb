#
# Cookbook Name:: zuul
# Attributes:: default
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

default[:zuul][:conf_path] = "/etc/zuul/zuul.conf"
default[:zuul][:layout_conf_path] = "/etc/zuul/layout.yaml"
default[:zuul][:logging_conf_path] = "/etc/zuul/logging.conf"
default[:zuul][:user] = "zuul"
default[:zuul][:group] = "zuul"
# Do not add trailing slashes to these paths
default[:zuul][:state_dir] = "/var/lib/zuul"
default[:zuul][:log_dir] = "/var/log/zuul"
default[:zuul][:home] = default[:zuul][:state_dir]
default[:zuul][:jenkins][:url] = node[:jenkins][:server][:url]
default[:zuul][:jenkins][:user] = "zuul"
default[:zuul][:jenkins][:apikey] = "1234567890abcdef1234567890abcdef"
# No Gerrit cookbook exists. When it does, replace these hardcoded
# values with defaults from the Gerrit default attributes
default[:zuul][:gerrit][:url] = "review.example.com"
default[:zuul][:gerrit][:user] = "zuul"
default[:zuul][:gerrit][:sshkey] = "#{node[:zuul][:home]}/.ssh/id_rsa"
