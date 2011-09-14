
package = plone.app.linkintegrity
extras = [test]

bootstrap_url = svn://svn.zope.org/repos/main/zc.buildout/trunk/bootstrap/bootstrap.py
plonetest_url = http://svn.plone.org/svn/collective/buildout/plonetest
buildout_options = buildout:package-name=$(package) \
                   buildout:package-extras=$(extras) \
                   buildout:develop=$(PWD) \
                   versions:$(package)=

all: tests-4.1

tests tests/4.1:
	mkdir $@

tests/bootstrap.py: tests
	svn cat $(bootstrap_url) > tests/bootstrap.py

tests/4.1/bin/buildout: tests/bootstrap.py tests/4.1
	python2.6 tests/bootstrap.py -c $(plonetest_url)/test-4.1.x.cfg $(buildout_options) buildout:directory=$(PWD)/tests/4.1

tests/4.1/bin/test: tests/4.1/bin/buildout
	tests/4.1/bin/buildout -c $(plonetest_url)/test-4.1.x.cfg $(buildout_options) buildout:directory=$(PWD)/tests/4.1

tests-4.1: tests/4.1/bin/test
	tests/4.1/bin/test -v

clean:
	rm -rf tests

.PHONY: all tests-4.1 clean
