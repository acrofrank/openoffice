::
:: COMMAND FILE TO BUILD XALANC WITH MICROSOFT VC++ {6, 7.1, 8, 9, 10}
:: Studio .NET Command Line Build Architetures "Win32" and "Win64"
:: 

:: -- The directory where we script build the XERCES-C and XALAN-C sources

:: SET APACHEHOME=C:\Apache\xalan-builds
SET APACHEHOME=.

:: -- The Xalan-C Version {1.10=10, 1.11=11}

SET XALANC_VER=10
:: SET XALANC_VER=11

:: -- The Xerces-C Version {2.7.0=27, 2.8.0=28, 3.1.1=31}

:: SET XERCESC_VER=27
SET XERCESC_VER=28
:: SET XERCESC_VER=31

:: -- The Architecture {X86=Win32, X64=Win64}

:: SET ARCH=Win32
SET Arch=Win64

:: -- The Microsoft Visual Studio C++ Version

:: SET VCVER=VC6
:: SET VCVER=VC7.1
SET VCVER=VC8
:: SET VCVER=VC9
:: SET VCVER=VC10

:: -- THE ITEMS BELOW CONFIGURE THE BUILD ENVIRONMENT SELECTED ABOVE

:: -- The Xalan Sources {xalan-src-10, xalan-src-11}

SET XALANCROOT=%APACHEHOME%\xalan-src-%XALANC_VER%\c

:: -- The Xalan Solution minus .dlw and .sln extension

SET XSOLUTIONDIR=%XALANCROOT%\Projects\Win32\%VCVER%
SET XSOLUTIONFILE=Xalan

:: -- The Xerces Binary Installation and Headers

IF NOT "%VCVER%" == "VC6" GOTO tag_vc7
SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-%XERCESC_VER%-VC60
GOTO set_env

:tag_vc7
IF NOT "%VCVER%" == "VC7.1" GOTO tag_vc8
SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-%XERCESC_VER%-VC71
GOTO set_env

:tag_vc8
IF NOT "%VCVER%" == "VC8" GOTO tag_vc9 
IF "%ARCH%" == "Win64" (
  SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-%XERCESC_VER%-X64-VC80
) ELSE (
  SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-%XERCESC_VER%-VC80
)
GOTO set_env

:tag_vc9
IF NOT "%VCVER%" == "VC9" GOTO tag_vc10
IF "%ARCH%" == "Win64" (
  SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-%XERCESC_VER%-X64-VC90
) ELSE (
  SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-%XERCESC_VER%-VC90
)
GOTO set_env

:tag_vc10
IF NOT "%VCVER%" == "VC10" GOTO finish
IF "%ARCH%" == "Win64" (
  SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-%XERCESC_VER%-X64-VC100
) ELSE (
  SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-%XERCESC_VER%-VC100
)
GOTO set_env

:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-27-VC60
:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-27-VC71
:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-28-VC60
:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-28-VC71
:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-28-VC80
:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-28-X64-VC80
:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-31-VC71
:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-31-VC80
:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-31-VC90
:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-31-VC100
:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-31-X64-VC80
:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-31-X64-VC90
:: SET XERCESCROOT=%APACHEHOME%\XERCESCPKG-31-X64-VC100

:: -- PREPARE DEFAULT ENVIRONMENT - Including Xerces Binary Pkg

:set_env
SET PATH=%WINDIR%\system32;%WINDIR%;%WINDIR%\system32\Wbem
SET PATH=%PATH%;%XERCESCROOT%\bin
SET INCLUDE=%XERCESCROOT%\include
SET LIB=%XERCESCROOT%\lib
SET LIBPATH=
SET SOURCE=

:: -- SET ENVIRONMENTS FOR MICROSOFT SPECIFIC COMPILER

IF NOT "%VCVER%" == "VC6" GOTO vs_vc7
CALL "C:\Program Files\Microsoft Visual Studio\VC98\Bin\VCVARS32.BAT"
GOTO do_build

:vs_vc7
IF NOT "%VCVER%" == "VC7.1" GOTO vs_vc8
CALL "%VS71COMNTOOLS%\vsvars32.bat"
GOTO do_build

:vs_vc8
IF NOT "%VCVER%" == "VC8" GOTO vs_vc9
IF "%ARCH%" == "Win64" (
  CALL "%VS80COMNTOOLS%\..\..\VC\vcvarsall.bat" x86_amd64
) ELSE (
  CALL "%VS80COMNTOOLS%\vsvars32.bat"
)
GOTO do_build

:vs_vc9
IF NOT "%VCVER%" == "VC9" GOTO vs_vc10
IF "%ARCH%" == "Win64" (
  CALL "%VS90COMNTOOLS%\..\..\VC\vcvarsall.bat" x86_amd64
) ELSE (
  CALL "%VS90COMNTOOLS%\vsvars32.bat"
)
GOTO do_build

:vs_vc10
IF NOT "%VCVER%" == "VC10" GOTO finish
IF "%ARCH%" == "Win64" (
  CALL "%VS100COMNTOOLS%\..\..\VC\vcvarsall.bat" x86_amd64
) ELSE (
  CALL "%VS100COMNTOOLS%\vsvars32.bat"
)
GOTO do_build

:: -- ENTER THE MICROSOFT DEVELOPER STUDIO OR .NET FOR SPECIFIC COMPILER

:do_build

IF "%VCVER%" == "VC6" (
  msdev "%XSOLUTIONDIR%\%XSOLUTIONFILE%.dsw" /useenv
) ELSE (
  devenv "%XSOLUTIONDIR%\%XSOLUTIONFILE%.sln" /useenv
)

:finish
