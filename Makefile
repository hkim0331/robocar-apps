ROBOCAR_APP_DB=db.melt.kyutech.ac.jp

all: robocar-apps

install: robocar-apps
	install -m 0755 robocar-apps /srv/robocar-apps/

robocar-apps:
	sbcl \
		--eval "(ql:quickload :robocar-apps)" \
		--eval "(in-package :robocar-apps)" \
		--eval "(sb-ext:save-lisp-and-die \"robocar-apps\" :executable t :toplevel 'main)"

start: robocar-apps
	sudo systemtl start robocar-apps

stop:
	sudo systemctl stop robocar-apps

restart:
	sudo systemctl restart roboar-apps

clean:
	${RM} ./robocar-apps
	find ./ -name \*.bak -exec rm {} \;

test:
	@echo ${ROBOCAR_APP_DB}

