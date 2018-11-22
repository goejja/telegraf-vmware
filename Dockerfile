FROM telegraf:1.8.3

ARG VSPHERE_SDK_PERL=VMware-vSphere-Perl-SDK-6.7.0-8156551.x86_64.tar.gz

COPY vmware-sdk/${VSPHERE_SDK_PERL} /tmp/

RUN apt-get -q update && apt-get install -yq --no-install-recommends python3 wget \
  python3-pip python3-requests kmod iputils-ping make gcc \
  perl e2fsprogs libcrypt-ssleay-perl libxml-libxml-perl \
  libextutils-makemaker-cpanfile-perl libmodule-build-perl liblwp-protocol-https-perl \
  libtry-tiny-perl libdevel-stacktrace-perl libclass-data-inheritable-perl \
  libconvert-asn1-perl libcrypt-openssl-rsa-perl libcrypt-openssl-x509-perl \
  libexception-class-perl libarchive-zip-perl libdevel-checklib-perl \
  libclass-methodmaker-perl libdata-dump-perl libcrypt-x509-perl librest-client-perl \
  liblist-moreutils-perl uuid-dev libossp-uuid-perl libsoap-lite-perl \
  libdata-uuid-libuuid-perl libjson-perl librest-client-perl libjson-perl \
  && perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit' \
  && cpan install Path::Class \
  && cpan install Object::InsideOut \
  && echo "Ubuntu" > /etc/fake-release \
  && tar -C /tmp -xzf /tmp/${VSPHERE_SDK_PERL} \
  && sed -i '2581,2595d' /tmp/vmware-vsphere-cli-distrib/vmware-install.pl \
  && /tmp/vmware-vsphere-cli-distrib/vmware-install.pl -d EULA_AGREED=yes \
  && rm -fr /tmp/vmware-vsphere-cli-distrib && rm -fr /tmp/VMware-* \
  && cpan install JSON::Parse \
  && pip3 install --upgrade setuptools \
  && pip3 install --upgrade pyvmomi \
  && echo "Ubuntu" > /etc/fake-release \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*

CMD telegraf
