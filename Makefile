
package = $(shell basename $$PWD)
extras = [test]
options =
test_options = --quiet --progress

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
	python2.6 tests/bootstrap.py -c $(plonetest_url)/test-$*.x.cfg \
		buildout:directory=$(PWD)/tests/$* \
		$(buildout_options)

tests/%/bin/test: tests/%/bin/buildout
	tests/$*/bin/buildout -c $(plonetest_url)/test-$*.x.cfg \
		buildout:directory=$(PWD)/tests/$* \
		$(buildout_options)

tests-%: tests/%/bin/test
	tests/$*/bin/test $(test_options)

clean:
	rm -rf tests

.PHONY: all clean tests-%
.PRECIOUS: tests/%/bin/buildout tests/%/bin/test
