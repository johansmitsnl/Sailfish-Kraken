# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.27
# 

Name:       harbour-kraken

# >> macros
# << macros

Summary:    This is a simple client for the Kraken Exchange.
Version:    0.0.4
Release:    1
Group:      Qt/Qt
License:    GNU General Public License v3.0
URL:        https://github.com/johansmitsnl/Sailfish-Kraken/
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-kraken.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   pyotherside-qml-plugin-python3-qt5
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  python3-devel
BuildRequires:  desktop-file-utils

%description
This is a simple client for the Kraken Exchange.

Functionality:

* Show current value
* Show daily high and low
* Show balance (needs token)

%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake5 

make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
# >> files
# << files
