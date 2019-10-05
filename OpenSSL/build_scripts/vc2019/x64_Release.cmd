cd /d C:\git\SE-Build-crosslib_old_win32\OpenSSL\src\build\vc2019\x64_Release

set CYGWIN=nodosfilewarning
set PATH=C:\Perl\bin;C:\ADMIN\nasm-2.11.08;%PATH%

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

perl Configure VC-WIN64A

call ms\do_win64a

sed s/defined\(stdin\)/\(0\)/g e_os.h > e_os.tmp
copy e_os.tmp e_os.h

sed s/\/MD/\/MT/g ms\nt.mak > ms\tmp.txt
sed s/advapi32.lib//g ms\tmp.txt > ms\tmp2.txt
sed s/inc32/winx64release_inc32/g ms\tmp2.txt > ms\tmp3.txt
sed s/out32/winx64release_out32/g ms\tmp3.txt > ms\tmp4.txt
sed s/\/Zl/\/Z7/g ms\tmp4.txt > ms\tmp3.txt
sed s/\/WX/\/D_USE_32BIT_TIME_T/g ms\tmp3.txt > ms\tmp5.txt
sed s/tmp32/winx64release_tmp32/g ms\tmp5.txt > ms\winx64release.mak

nmake /f ms\winx64release.mak clean
nmake /f ms\winx64release.mak

mkdir C:\git\SE-Build-crosslib_old_win32\OpenSSL\output\Library\vc2019\x64_Release

copy winx64release_out32\libeay32.lib C:\git\SE-Build-crosslib_old_win32\OpenSSL\output\Library\vc2019\x64_Release\libeay32.lib /y
copy winx64release_out32\ssleay32.lib C:\git\SE-Build-crosslib_old_win32\OpenSSL\output\Library\vc2019\x64_Release\ssleay32.lib /y

