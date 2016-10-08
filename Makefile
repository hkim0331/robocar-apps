all: robocar-apps

robocar-apps:
	sbcl \
		--eval "(ql:quickload :robocar-apps)" \
		--eval "(in-package :robocar-apps)" \
		--eval "(sb-ext:save-lisp-and-die \"robocar-apps\" :executable t :toplevel 'main)"

start: robocar-apps
	@echo check the location of static folder.
	nohup ./robocar-apps &

stop:
	pkill robocar-apps
	mv nohup.out nohup.out.`date +%F_%T`

restart:
	make stop
	make clean
	make start

clean:
	${RM} ./robocar-apps
	find ./ -name \*.bak -exec rm {} \;

# isc:
# 	install -m 0700 src/seats-isc.sh ${HOME}/bin/seats-start

