%define _topdir	%{getenv:RPM_FOLDER}
%define name         webserver-deployer


Name:           webserver-deployer
Version:        1.0
Release:        0
Summary:        Deploy a webserver
Group:          Applications/Development
BuildArch:      noarch
License:        MIT
URL:            http://github.com/demmonx/webserver-deployer
Vendor:         Cyril Démery cyril.demery.pro@gmail.com
Packager: 		Cyril Démery
Source:         build.tar.gz
Requires:	vagrant >= 2.0, ansible >= 2.3, bash >= 4.0

%description
Vagrant and VirtualBox are used to quickly build or rebuild virtual servers.
Those scripts use Vagrant profile to deploy a new server and install Nginx, PostgreSQL, SMTP and PHP using the Ansible provisioner.
It's based on https://github.com/demmonx/webserver-deployer standalone project, and provide tools to generate .deb and .rpm without modifiying any line of the initial project.

%prep
tar -zxvf %{_topdir}/SOURCES/build.tar.gz 
mv "build/"* .
rm -r build

%build


%install
cp -R * %{buildroot}

%post
directory="/etc/ansible/roles" 
if [ ! -d "$directory" ]; then
    mkdir "$directory"
fi
cd "$directory"
for f in $(find /etc/webserver-deployer/ansible/roles/ -maxdepth 1); do
    ln -s "$f" . 2>/dev/null
done
rm roles 2>/dev/null

%preun
cd /etc/ansible/roles 
for f in $(find /etc/webserver-deployer/ansible/roles/ -maxdepth 1); do
    rm $(basename "$f") 2>/dev/null
done

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "$RPM_BUILD_ROOT"

%files
%defattr(755,root,root)
%{_sysconfdir}/%{name}/*
%{_bindir}/%{name}*
%{_sbindir}/%{name}*
%{_sbindir}/%{name}*
%{_datadir}/man/*
