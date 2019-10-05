cd /d C:\git\SE-Build-crosslib_old_win32\OpenSSL\src\build\vc2008\Win32_Release

set CYGWIN=nodosfilewarning
set PATH=C:\Perl\bin;C:\ADMIN\nasm-2.11.08;%PATH%

call "c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" x86

perl Configure VC-WIN32

call ms\do_masm

sed s/\/MD/\/MT/g ms\nt.mak > ms\tmp.txt
sed s/advapi32.lib//g ms\tmp.txt > ms\tmp2.txt
sed s/inc32/win32release_inc32/g ms\tmp2.txt > ms\tmp3.txt
sed s/out32/win32release_out32/g ms\tmp3.txt > ms\tmp4.txt
sed s/\/Zl/\/Z7/g ms\tmp4.txt > ms\tmp3.txt
sed s/\/WX/\/D_USE_32BIT_TIME_T/g ms\tmp3.txt > ms\tmp5.txt
sed s/tmp32/win32release_tmp32/g ms\tmp5.txt > ms\win32release.mak

nmake /f ms\win32release.mak clean
nmake /f ms\win32release.mak

mkdir C:\git\SE-Build-crosslib_old_win32\OpenSSL\output\Library\vc2008\Win32_Release

copy win32release_out32\libeay32.lib C:\git\SE-Build-crosslib_old_win32\OpenSSL\output\Library\vc2008\Win32_Release\libeay32.lib /y
copy win32release_out32\ssleay32.lib C:\git\SE-Build-crosslib_old_win32\OpenSSL\output\Library\vc2008\Win32_Release\ssleay32.lib /y

mkdir C:\git\SE-Build-crosslib_old_win32\OpenSSL\output\Include\vc2008\
copy C:\git\SE-Build-crosslib_old_win32\OpenSSL\src\build\vc2008\Win32_Release\win32release_inc32\openssl\* C:\git\SE-Build-crosslib_old_win32\OpenSSL\output\Include\vc2008\ /y


