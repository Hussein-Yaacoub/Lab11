Name:           myapp
Version:        1.0
Release:        1%{?dist}
Summary:        A simple Hello World application
License:        GPL
URL:            https://github.com/yourusername/myapp
Source0:        %{name}-%{version}.tar.gz
BuildArch:      x86_64

%description
A simple Hello World application that demonstrates
RPM packaging for RedHat-based Linux distributions.
Created for EECE 435L Software Engineering Lab.

%prep
%setup -q

%build
gcc -o helloworld helloworld.c

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/local/bin
mkdir -p %{buildroot}/usr/share/doc/myapp

install -m 755 helloworld %{buildroot}/usr/local/bin/
install -m 644 README.md %{buildroot}/usr/share/doc/myapp/
install -m 644 user_guide.txt %{buildroot}/usr/share/doc/myapp/

%files
/usr/local/bin/helloworld
/usr/share/doc/myapp/README.md
/usr/share/doc/myapp/user_guide.txt

%changelog
* Thu Nov 14 2025 Hussein Yaacoub <hmy03@mail.aub.edu> 1.0-1
- Initial package release
- Simple Hello World application
- Includes documentation and user guide
