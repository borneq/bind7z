#! /bin/sh

sure()
{
  eval $*
  if [ "$?" != "0" ]
  then
    echo "ERROR during : $*"
    echo "ERROR during : $*" > last_error
    exit 1
  fi
}

PZIP7=`pwd`"/$1"

REP=TMP_$$
echo "REP=${REP}"

chmod -R 777 ${REP} 2> /dev/null
rm -fr   ${REP}
mkdir -p ${REP}

cd ${REP}

# sure rm -fr 7za433_ref 7za433_7zip_bzip2 7za433_7zip_lzma 7za433_7zip_lzma_crypto 7za433_7zip_ppmd 7za433_tar
# sure rm -fr 7za433_7zip_bzip2.7z 7za433_7zip_lzma.7z 7za433_7zip_lzma_crypto.7z 7za433_7zip_ppmd.7z 7za433_tar.tar

echo ""
echo "# TESTING ..."
echo "#############"

sure ${PZIP7} t ../test/7za433_tar.tar
sure ${PZIP7} t ../test/7za433_7zip_lzma.7z
sure ${PZIP7} t -pqwerty ../test/7za433_7zip_lzma_crypto.7z
sure ${PZIP7} t ../test/7za433_7zip_ppmd.7z
sure ${PZIP7} t ../test/7za433_7zip_bzip2.7z

echo ""
echo "# EXTRACTING ..."
echo "################"

sure tar xf ../test/7za433_tar.tar
sure mv 7za433_tar 7za433_ref

sure ${PZIP7} x ../test/7za433_tar.tar
sure diff -r 7za433_ref 7za433_tar

sure ${PZIP7} x ../test/7za433_7zip_lzma.7z
sure diff -r 7za433_ref 7za433_7zip_lzma

sure ${PZIP7} x ../test/7za433_7zip_lzma_bcj2.7z
sure diff -r 7za433_ref 7za433_7zip_lzma_bcj2

sure ${PZIP7} x -pqwerty ../test/7za433_7zip_lzma_crypto.7z
sure diff -r 7za433_ref 7za433_7zip_lzma_crypto

sure ${PZIP7} x ../test/7za433_7zip_ppmd.7z
sure diff -r 7za433_ref 7za433_7zip_ppmd

sure ${PZIP7} x ../test/7za433_7zip_ppmd_bcj2.7z
sure diff -r 7za433_ref 7za433_7zip_ppmd_bcj2

sure ${PZIP7} x ../test/7za433_7zip_bzip2.7z
sure diff -r 7za433_ref 7za433_7zip_bzip2

sure ${PZIP7} x ../test/7za433_7zip_lzma2.7z
sure diff -r 7za433_ref 7za433_7zip_lzma2

sure ${PZIP7} x ../test/7za433_7zip_lzma2_bcj2.7z
sure diff -r 7za433_ref 7za433_7zip_lzma2_bcj2

sure ${PZIP7} x -pqwerty ../test/7za433_7zip_lzma2_crypto.7z
sure diff -r 7za433_ref 7za433_7zip_lzma2_crypto

echo ""
echo "# Archiving ..."
echo "###############"

sure ${PZIP7} a -ttar 7za433_tar.tar 7za433_tar
sure tar tvf 7za433_tar.tar

sure ${PZIP7} a 7za433_7zip_lzma.7z 7za433_7zip_lzma

sure ${PZIP7} a -sfx7zCon.sfx 7za433_7zip_lzma.x 7za433_7zip_lzma

sure ${PZIP7} a -pqwerty -mhc=on -mhe=on 7za433_7zip_lzma_crypto.7z 7za433_7zip_lzma_crypto

sure ${PZIP7} a -mx=9 -m0=ppmd:mem=64m:o=32 7za433_7zip_ppmd.7z 7za433_7zip_ppmd

sure ${PZIP7} a -m0=bzip2 7za433_7zip_bzip2.7z 7za433_7zip_bzip2

echo ""
echo "# EXTRACTING (PASS 2) ..."
echo "#########################"

sure rm -fr 7za433_7zip_bzip2 7za433_7zip_lzma 7za433_7zip_lzma_crypto 7za433_7zip_ppmd 7za433_tar

sure ${PZIP7} x 7za433_tar.tar
sure diff -r 7za433_ref 7za433_tar

sure ${PZIP7} x 7za433_7zip_lzma.7z
sure diff -r 7za433_ref 7za433_7zip_lzma

sure rm -fr 7za433_7zip_lzma
# FIXME - only for 7zG
sure chmod +x ./7za433_7zip_lzma.x
sure ./7za433_7zip_lzma.x
sure diff -r 7za433_ref 7za433_7zip_lzma

sure ${PZIP7} x -pqwerty 7za433_7zip_lzma_crypto.7z
sure diff -r 7za433_ref 7za433_7zip_lzma_crypto

sure ${PZIP7} x 7za433_7zip_ppmd.7z
sure diff -r 7za433_ref 7za433_7zip_ppmd

sure ${PZIP7} x 7za433_7zip_bzip2.7z
sure diff -r 7za433_ref 7za433_7zip_bzip2

echo ""
echo "# EXTRACTING (LZMA) ..."
echo "#######################"

rm -f 7za.exe

sure ${PZIP7} x ../test/7za.exe.lzma
sure diff 7za.exe 7za433_ref/bin/7za.exe
sure rm -f 7za.exe

sure ${PZIP7} x ../test/7za.exe.lzma86
sure diff 7za.exe 7za433_ref/bin/7za.exe
sure rm -f 7za.exe

sure ${PZIP7} x ../test/7za.exe.lzma_eos
sure diff 7za.exe 7za433_ref/bin/7za.exe
sure rm -f 7za.exe

echo ""
echo "# TESTING (XZ) ..."
echo "#######################"
sure ${PZIP7} x ../test/7za.exe.xz
sure diff 7za.exe 7za433_ref/bin/7za.exe

chmod +x 7za.exe
sure ${PZIP7} -txz a 7za.exe.xz 7za.exe
sure rm -f 7za.exe

sure ${PZIP7} x 7za.exe.xz
sure diff 7za.exe 7za433_ref/bin/7za.exe
sure rm -f 7za.exe

#####################################

cd ..

# ./clean_all.sh
chmod -R 777 ${REP} 2> /dev/null
rm -fr   ${REP}

echo ""
echo "========"
echo "ALL DONE"
echo "========"
echo ""
