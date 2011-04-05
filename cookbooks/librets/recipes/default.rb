execute "install_librets" do
=begin
/etc/make.conf USE='java'
package.use dev-java/antlr script
  command(" " +
          " cd portage" +
          " sudo touch package.use" +
          " " +
          " cd /usr/src" +
          " sudo wget http://www.crt.realtors.org/projects/rets/librets/files/librets-1.5.1.tar.gz" +
          " sudo tar xvfz librets-1.5.1.tar.gz" +
          " cd librets-1.5.1" +
          " sudo ./autogen.sh" +
          " sudo emerge antlr" +
          " sudo emerge dev-libs/expat" +
          " sudo emerge dev-libs/boost" +
          " sudo emerge dev-libs/boost-build" +
          " sudo emerge dev-lang/swig" +
          " sudo emerge net-misc/curl" +
          " sudo ./configure --enable-shared_dependencies --enable-depends" +
          " sudo make && sudo make install")
  not_if { FileTest.exists?("/usr/bin/librets-1.5.1 ") }
end
end