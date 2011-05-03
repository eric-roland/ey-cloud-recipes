define :enable_package, :version => nil do
  name = params[:name]
  version = params[:version]
  full_name = name << ("-#{version}" if version)

  update_file "local portage package.keywords" do
    path "/etc/portage/package.keywords/local"
    body "=#{full_name}"
    not_if "grep '=#{full_name}' /etc/portage/package.keywords/local"
  end
  
  #enable_package "media-video/ffmpeg" do
	#  version "0.4.9_p20090201"
	#end
  
end
