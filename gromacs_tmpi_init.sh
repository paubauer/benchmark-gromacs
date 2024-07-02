#!/bin/bash


OUT_DIR=$1
if [ -z "${OUT_DIR}" ]; then
    OUT_DIR=".."
fi

OUT_FILE=${OUT_DIR}/gromacs_tmpi_init.txt

# Support execution from outside root dir
_CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
cd $_CWD


cd adh_dodec/
tar zxf adh_dodec.tar.gz

cd ..
cd stmv/
tar zxf stmv.tar.gz


cd ..
cd cellulose_nve/
tar zxf cellulose_nve.tar.gz
