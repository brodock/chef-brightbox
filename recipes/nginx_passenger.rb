include_recipe "brightbox::ruby"

# Let's remove apache2 to make sure only nginx will be running
["apache2", "apache2.2-bin"].each do |name|
  apt_package name do
    action :remove
  end
end

["ssl-cert", "passenger-common1.9.1", "nginx-full"].each do |name|
  apt_package name do
    action :install
  end
end

cookbook_file "/etc/nginx/conf.d/passenger.conf" do
  source 'passenger.conf'
  mode   '0644'
end

service "nginx" do
  # TODO: :start here fails when successive deploys have issues.
  # We need to work out a way to improve that?
  supports :status => true, :restart => true, :reload => true
  action   [:enable, :start]
end