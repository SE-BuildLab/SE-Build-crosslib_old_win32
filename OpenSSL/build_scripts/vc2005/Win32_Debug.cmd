cd /d C:\git\SE-Build-crosslib_old_win32\OpenSSL\src\build\vc2005\Win32_Debug

set CYGWIN=nodosfilewarning
set PATH=C:\Perl\bin;C:\ADMIN\nasm-2.11.08;%PATH%

call "C:\Program Files (x86)\Microsoft Visual Studio 8\VC\vcvarsall.bat" x86

perl Configure VC-WIN32

call ms\do_masm

sed s/\/MD/\/MTd/g ms\nt.mak > ms\tmp2.txt
sed s/\/MT/\/MTd/g ms\tmp2.txt > ms\tmp3.txt
sed s/\/Zl/\/Z7/g ms\tmp3.txt > ms\tmp4.txt
sed "s/\/Ox \/O2\ \/Ob2/\/Od/g" ms\tmp4.txt > ms\tmp.txt
sed s/advapi32.lib//g ms\tmp.txt > ms\tmp2.txt
sed s/inc32/win32debug_inc32/g ms\tmp2.txt > ms\tmp3.txt
sed s/out32/win32debug_out32/g ms\tmp3.txt > ms\tmp4.txt
sed s/\/WX/\/D_USE_32BIT_TIME_T/g ms\tmp4.txt > ms\tmp5.txt
sed s/tmp32/win32debug_tmp32/g ms\tmp5.txt > ms\win32debug.mak

nmake /f ms\win32debug.mak clean
nmake /f ms\win32debug.mak

mkdir C:\git\SE-Build-crosslib_old_win32\OpenSSL\output\Library\vc2005\Win32_Debug

copy win32debug_out32\libeay32.lib C:\git\SE-Build-crosslib_old_win32\OpenSSL\output\Library\vc2005\Win32_Debug\libeay32.lib /y
copy win32debug_out32\ssleay32.lib C:\git\SE-Build-crosslib_old_win32\OpenSSL\output\Library\vc2005\Win32_Debug\ssleay32.lib /y


