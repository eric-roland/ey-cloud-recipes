# If you want to have scheduled reindexes in cron, enter the minute
# interval here. This is passed directly to cron via /, so you should
# only use numbers between 1 - 59.
#
# If you don't want scheduled reindexes, just leave this commented.
#
# Uncommenting this line as-is will reindex once every 10 minutes.
cron_interval( "60" )
flavor( "thinking_sphinx" )
sphinx_base_port( "3311" )
app_count=@attribute[:applications].size
# Where to store the indexes? There's multiple places and choices to store indexes, this is how you configure it.
# /var/log/engineyard/sphinx/
# /mnt/tmp/sphinx/
# /data/appname/shared/sphinx/
searchd_file_path( "/mnt/tmp/sphinx")
# Determine what IP Address to connect to/listen on.
if @attribute['master_app_server'].nil?
  sphinx_ip( @attribute[:ipaddress] )
  else
  sphinx_ip( @attribute[:master_app_server][:public_ip] )
end
