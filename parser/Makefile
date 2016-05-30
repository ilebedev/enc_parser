
#DEPS=*.ml *.mly *.mll
DEPS=*.ml
#COMP_DEPS=*.mly *.mll
COMP_DEPS=
#ARGS=C_INCLUDE_PATH=/opt/local/include LIBRARY_PATH=/opt/local/lib CC=gcc-mp-4.8
ARGS=
FLAGS=-use-ocamlfind -use-menhir -menhir "menhir --infer --explain"
DEBUG_FLAGS=-cflag -g
APPNAME=parser

all: ${APPNAME} ${APPNAME}.debug


${APPNAME}.debug: $(DEPS) $(COMP_DEPS)
	 $(ARGS) ocamlbuild $(DEBUG_FLAGS) $(FLAGS) Main.byte && mv Main.byte ${APPNAME}.debug
	 chmod +x ${APPNAME}.debug

${APPNAME}: $(DEPS) $(COMP_DEPS)
	  $(ARGS) ocamlbuild $(FLAGS) Main.native && mv Main.native ${APPNAME}
	 chmod +x ${APPNAME}

clean:
	ocamlbuild -clean
