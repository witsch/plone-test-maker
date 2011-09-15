
package = $(shell basename $$PWD)
extras = [test]
buildout_options = -q
test_options = --quiet --progress

bootstrap_url = svn://svn.zope.org/repos/main/zc.buildout/trunk/bootstrap/bootstrap.py
plonetest_url = http://svn.plone.org/svn/collective/buildout/plonetest
buildout_args = buildout:package-name=$(package) \
                buildout:package-extras=$(extras) \
                buildout:develop=$(PWD) \
                versions:$(package)=

all: tests-4.1 tests-4.2

tests tests/4.1 tests/4.2:
	mkdir $@

tests/bootstrap.py: tests
	svn cat $(bootstrap_url) > tests/bootstrap.py

tests/%/bin/buildout: tests/bootstrap.py tests/%
	python2.6 tests/bootstrap.py -d -c $(plonetest_url)/test-$*.x.cfg \
		buildout:directory=$(PWD)/tests/$* \
		$(buildout_args)

tests/%/bin/test: tests/%/bin/buildout
	tests/$*/bin/buildout -c $(plonetest_url)/test-$*.x.cfg \
		buildout:directory=$(PWD)/tests/$* \
		$(buildout_args) $(buildout_options)

tests-%: tests/%/bin/test
	tests/$*/bin/test $(test_options)

clean:
	rm -rf tests

.PHONY: all clean tests-%
.PRECIOUS: tests/%/bin/buildout tests/%/bin/test
