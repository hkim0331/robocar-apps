all: robocar-apps

robocar-apps:
	sbcl \
		--eval "(ql:quickload :robocar-apps)" \
		--eval "(in-package :robocar-apps)" \
		--eval "(sb-ext:save-lisp-and-die \"robocar-apps\" :executable t :toplevel 'main)" &&
	install -m 0755 robocar-apps /srv/robocar-apps/

start: robocar-apps
	sudo systemtl start robocar-apps

stop:
	sudo systemctl stop robocar-apps

restart:
	sudo systemctl restart roboar-apps

clean:
	${RM} ./robocar-apps
	find ./ -name \*.bak -exec rm {} \;

# no use. 2018-10-06.
#ssh:
#	ssh -f -N -L 27017:localhost:27017 ubuntu@db.melt.kyutech.ac.jp

# isc:
# 	install -m 0700 src/seats-isc.sh ${HOME}/bin/seats-start

