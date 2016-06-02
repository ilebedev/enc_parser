
STATIC_LIB=iso8211
LIB_DIR=iso8211lib-1.4
CURR_DIR=$(pwd)
BIN=s57parser

all: ${BIN}

${LIB_DIR}/lib${STATIC_LIB}.a:
	cd ${LIB_DIR}; \
		./configure && make 
	cd ${CURR_DIR}

${BIN}: ${LIB_DIR}/lib${STATIC_LIB}.a
	g++ -o s57parse -I ${LIB_DIR} -L ${LIB_DIR} S57Parser.cpp -l ${STATIC_LIB}
