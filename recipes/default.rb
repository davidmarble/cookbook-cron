#
# Cookbook Name:: cron
# Recipe:: default
#
# Copyright 2010-2012, Opscode, Inc.
# Edited 2011, David Marble <davidmarble@gmail.com>
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

cron_package = case node['platform']
                   when "redhat", "centos", "scientific", "fedora", "amazon"
                       node['platform_version'].to_f >= 6.0 ? "cronie" : "vixie-cron"
                   else
                       "cron"
               end

package cron_package do
    action :upgrade
end

service "crond" do
    case node['platform']
        when "redhat", "centos", "scientific", "fedora", "amazon"
            service_name "crond"
        when "debian", "ubuntu"
            service_name "cron"
    end
    action [:start, :enable]
end

if node[:cron]
    if node[:cron].attribute?("crontab_lines")
        template "/etc/crontab" do
            source "etc/crontab.erb"
            owner "root"
            group "root"
            mode "0644"
        end
    end

    if node[:cron].attribute?('predefined')
        node[:cron][:predefined].each do |job|
            template "/etc/cron.d/#{job}" do
                source "etc/cron.d/#{job}.erb"
                owner "root"
                group "root"
                mode "0644"
            end
        end
    end


    if node[:cron].attribute?('crond')
        node[:cron][:crond].each_pair do |name, jobinfo|
            cron_job name do
                jobinfo jobinfo
            end
        end
    end
end
