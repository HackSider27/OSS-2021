%global selinuxtype	targeted
%global moduletype	services
%global modulenames	swap-monitor

# Usage: _format var format
#   Expand 'modulenames' into various formats as needed
#   Format must contain '$x' somewhere to do anything useful
%global _format() export %1=""; for x in %{modulenames}; do %1+=%2; %1+=" "; done;

# Relabel files
%global relabel_files() \ # ADD files in *.fc file


# Version of distribution SELinux policy package 
%global selinux_policyver 3.13.1-128.6.fc22

Name:		swap-monitor	
Version: 	1.0	
Release:	1%{?dist}
Summary:	Program by student Mephi 2022
Group:		Testing
License:	GPL
URL:		https://github.com/HackSider27/OSS-2021
Source0:	%{name}-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-root-%(%{__id_u} -n)
BuildRequires:	/bin/rm, /bin/mkdir, /bin/cp, /bin/sudo, selinux-policy, selinux-policy-devel
Requires:	/bin/bash
Requires(post): selinux-policy-base >= %{selinux_policyver}, selinux-policy-targeted >= %{selinux_policyver}, policycoreutils, policycoreutils-python libselinux-utils
BuildArch:      noarch

%description
Service create new swap partion when RAM is over half.
Working in a custom domain policy

%prep
%setup -q

%build
make SHARE="%{_datadir}" TARGETS="%{modulenames}"

%install
sudo cp swap-monitor.8.gz %{_mandir}/man8
sudo cp swap-monitor.service %{_unitdir}
mkdir -p %{buildroot}%{_bindir}
install -m 0755 swap-monitor.sh %{buildroot}%{_bindir}
# Install policy modules
%_format MODULES $x.pp.bz2
install -d %{buildroot}%{_datadir}/selinux/packages
install -m 0644 $MODULES \
	%{buildroot}%{_datadir}/selinux/packages

%post
# Install all modules in a single transaction
%_format MODULES %{_datadir}/selinux/packages/$x.pp.bz2
%{_sbindir}/semodule -n -s %{selinuxtype} -i $MODULES
if %{_sbindir}/selinuxenabled ; then
    %{_sbindir}/load_policy
    %relabel_files
fi

%postun
if [ $1 -eq 0 ]; then
	%{_sbindir}/semodule -n -r %{modulenames} &> /dev/null || :
	if %{_sbindir}/selinuxenabled ; then
		%{_sbindir}/load_policy
		%relabel_files
	fi
fi

%files
%{_bindir}/swap-monitor.sh

%defattr(-,root,root,0755)
%attr(0644,root,root) %{_datadir}/selinux/packages/*.pp.bz2



%changelog
* Fri May 20 2022 <Daniil>
- Added module SELinux


