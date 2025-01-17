test: testbins
	@cp gef.py /tmp/gef.py
	python2 tests/runtests.py
	@rm -f /tmp/gef.py
	@rm -f /tmp/gef-*

Test%: testbins
	@cp gef.py /tmp/gef.py
	python2 tests/runtests.py $@
	@rm -f /tmp/gef.py
	@rm -f /tmp/gef-*

testbins: tests/binaries/*.c
	@make -C tests/binaries all

lint:
	python2 -m py_compile gef.py
	python2 -m pylint --rcfile ./.pylintrc tests/*.py
	python2 -m pylint -E gef.py
