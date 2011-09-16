
package = $(shell python setup.py --name)
extras = [test]
buildout_options = -q
test_options = --quiet --progress

bootstrap_url = svn://svn.zope.org/repos/main/zc.buildout/trunk/bootstrap/bootstrap.py
plonetest_url = http://svn.plone.org/svn/collective/buildout/plonetest
buildout_args = buildout:package-name=$(package) \
                buildout:package-extras=$(extras) \
                buildout:develop=$(PWD) \
                versions:$(package)=

versions = 4.0 4.1 4.2

all: $(versions)

tests/bootstrap.py:
	mkdir -p tests
	svn export -q $(bootstrap_url) tests/bootstrap.py

tests/%/bin/buildout: tests/bootstrap.py
	mkdir -p tests/$*
	python2.6 tests/bootstrap.py -d -c $(plonetest_url)/test-$*.x.cfg \
		buildout:directory=$(PWD)/tests/$* \
		$(buildout_args)

tests/%/bin/test: setup.py tests/%/bin/buildout
	tests/$*/bin/buildout -c $(plonetest_url)/test-$*.x.cfg \
		buildout:directory=$(PWD)/tests/$* \
		$(buildout_args) $(buildout_options)
	touch $@

setup.py:
	$(error `setup.py` is required, please run from your package directory...)

$(versions): %: tests/%/bin/test
	@echo 'testing $(package) against Plone $* ...'
	tests/$*/bin/test $(test_options)

clean:
	rm -rf tests

.PHONY: all clean %
.PRECIOUS: tests/%/bin/buildout tests/%/bin/test
