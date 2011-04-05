execute "install_ftp" do
  command "sudo emerge ftp"
  not_if { FileTest.exists?("/usr/bin/ftp") }
end