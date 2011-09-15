
package = $(shell basename $$PWD)
extras = [test]
options =

bootstrap_url = svn://svn.zope.org/repos/main/zc.buildout/trunk/bootstrap/bootstrap.py
plonetest_url = http://svn.plone.org/svn/collective/buildout/plonetest
buildout_options = buildout:package-name=$(package) \
                   buildout:package-extras=$(extras) \
                   buildout:develop=$(PWD) \
                   versions:$(package)= \
                   $(options)

all: tests-4.1 tests-4.2

tests tests/4.1 tests/4.2:
	mkdir $@

tests/bootstrap.py: tests
	svn cat $(bootstrap_url) > tests/bootstrap.py

tests/%/bin/buildout: tests/bootstrap.py tests/%
	python2.6 tests/bootstrap.py -c $(plonetest_url)/test-$*.x.cfg $(buildout_options) buildout:directory=$(PWD)/tests/$*

tests/%/bin/test: tests/%/bin/buildout
	tests/$*/bin/buildout -c $(plonetest_url)/test-$*.x.cfg $(buildout_options) buildout:directory=$(PWD)/tests/$*

tests-%: tests/%/bin/test
	tests/$*/bin/test -v

clean:
	rm -rf tests

.PHONY: all clean tests-%
.PRECIOUS: tests/%/bin/buildout tests/%/bin/test
