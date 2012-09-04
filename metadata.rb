maintainer          "Jay Pipes"
maintainer_email    "jaypipes@gmail.com"
license             "Apache 2.0"
description         "Installs the Zuul Gerrit/Jenkins job management service"
long_description    IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version             "0.1.1"

%w{ fedora redhat centos ubuntu debian amazon }.each do |os|
  supports os
end

depends             "jenkins"
# Not currently any good Gerrit cookbook :(
# depends             "gerrit"
