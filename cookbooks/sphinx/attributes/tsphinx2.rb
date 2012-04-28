# Configure the sphinx daemon's port.
sphinx_base_port( "3311" )
# How many sphinx search instances?
app_count=@attribute[:applications].size
# Where to store the indexes? There's multiple places and choices to store indexes, this is how you configure it.
# /var/log/engineyard/sphinx/
# /mnt/tmp/sphinx/
# /data/appname/shared/sphinx/
searchd_file_path( "/mnt/tmp/sphinx")
# Determine what IP Address to connect to/listen on.
# Changing this to localhost now that the instance is running on utility instance.
# if @attribute['master_app_server'].nil?
#   sphinx_ip( @attribute[:ipaddress] )
#   else
#   sphinx_ip( @attribute[:master_app_server][:public_ip] )
# end
