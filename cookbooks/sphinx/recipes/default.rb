#
# Cookbook Name:: sphinx
# Recipe:: default
#
# Make variables friendly!
@app_name = 'real_estate_search'
flavor=node[:flavor]
searchd_file_path=node[:searchd_file_path]
sphinx_base_port=node[:sphinx_base_port].to_i
app_count=node[:app_count].to_i
sphinx_ip=node[:sphinx_ip]
cron_interval=node[:cron_interval]

if ['solo', 'app_master'].include?(node[:instance_role])

  enable_package "app-misc/sphinx" do
    version "1.10_beta"
  end

  package "app-misc/sphinx" do
    action :upgrade
    version "1.10_beta"
  end

  node.engineyard.apps.each do |app|
    # Setup the base directories for Sphinx.
      directory "/var/run/sphinx" do
        owner node.engineyard.environment.ssh_username
        group node.engineyard.environment.ssh_username
        mode 0755
      end

      directory "/var/log/engineyard/sphinx/#{app.name}" do
        recursive true
        owner node.engineyard.environment.ssh_username
        group node.engineyard.environment.ssh_username
        mode 0755
      end

      directory "#{searchd_file_path}" do
        action :create
        recursive true
        mode 0755
        owner node.engineyard.environment.ssh_username
        group node.engineyard.environment.ssh_username
      end

     directory "/data/#{app.name}/shared/config/#{flavor.split("_").join("")}" do
        owner node.engineyard.environment.ssh_username
        group node.engineyard.environment.ssh_username
        mode 0755
      end

     directory "/data/#{app.name}/shared/bin" do
       action :create
       mode 0755
       owner node.engineyard.environment.ssh_username
       group node.engineyard.environment.ssh_username
     end

     remote_file "/etc/logrotate.d/sphinx" do
        owner "root"
        group "root"
        mode 0755
        source "sphinx.logrotate"
        backup false
        action :create
      end

      remote_file "/data/#{app.name}/shared/bin/thinking_sphinx_searchd" do
        source "thinking_sphinx_searchd"
        owner "root"
        group "root"
        backup 0
        mode 0755
      end

    sphinx_base_port=sphinx_base_port+1

     template "/data/#{app.name}/shared/config/sphinx.yml" do
        owner node.engineyard.environment.ssh_username
        group node.engineyard.environment.ssh_username
        mode 0644
        source "sphinx.yml.erb"
        variables({
          :sphinx_ip => node[:ipaddress],
          :app_name => app.name,
          :flavor => flavor.eql?("thinking_sphinx") ? "thinkingsphinx" : flavor,
          :mem_limit => 64,
          :user => node.engineyard.environment.ssh_username,
          :searchd_file_path => searchd_file_path,
          :sphinx_port => sphinx_base_port
        })
      end

      template "/etc/monit.d/sphinx.#{app.name}.monitrc" do
        source "sphinx.monitrc.erb"
        owner node.engineyard.environment.ssh_username
        group node.engineyard.environment.ssh_username
        mode 0644
        variables({
          :app_name => app.name,
          :user => node.engineyard.environment.ssh_username,
          :flavor => flavor
        })
      end

      if cron_interval
        cron "#{app.name} index" do
          action  :create
          minute  "0-59/5"
          hour    '*'
          day     '*'
          month   '*'
          weekday '*'
          command "cd /data/#{app.name}/current && RAILS_ENV=#{node[:environment][:framework_env]} bundle exec rake #{flavor}:index >/dev/null 2>&1"
          user node.engineyard.environment.ssh_username
        end
      end
      sphinx_base_port=sphinx_base_port+1
  end
end
## this is for the other app / util instances.

if ['app', 'util'].include?(node[:instance_role])

  node.engineyard.apps.each do |app, data|
    template "/data/#{app.name}/shared/config/sphinx.yml" do
      owner node.engineyard.environment.ssh_username
      group node.engineyard.environment.ssh_username
      mode 0644
      source "sphinx.yml.erb"
      variables({
        :sphinx_ip => sphinx_ip,
        :app_name => app.name,
        :flavor => flavor.eql?("thinking_sphinx") ? "thinkingsphinx" : flavor,
        :mem_limit => 64,
        :user => node.engineyard.environment.ssh_username,
        :searchd_file_path => searchd_file_path,
        :sphinx_port => sphinx_base_port.to_i+app_count.to_i-1
        })
    end

    directory "#{searchd_file_path}" do
      action :create
      recursive true
      mode 0755
      owner node.engineyard.environment.ssh_username
      group node.engineyard.environment.ssh_username
    end
  end
end
