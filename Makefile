
package = $(shell python setup.py --name)
requires = $(package).egg-info/requires.txt
extras = $(shell python setup.py --quiet egg_info && grep '^\[tests*\]' $(requires))
buildout_options = -q
test_options = --quiet --progress
test_dir = tests

bootstrap_url = svn://svn.zope.org/repos/main/zc.buildout/trunk/bootstrap/bootstrap.py
plonetest_url = http://svn.plone.org/svn/collective/buildout/plonetest
buildout_args = buildout:package-name=$(package) \
                buildout:package-extras=$(extras) \
                buildout:develop=$(PWD) \
                versions:$(package)=

versions = 4.0 4.1 4.2

all: $(versions)

$(test_dir)/bootstrap.py:
	mkdir -p $(test_dir)
	svn export -q $(bootstrap_url) $(test_dir)/bootstrap.py

$(test_dir)/%/bin/buildout: $(test_dir)/bootstrap.py
	mkdir -p $(test_dir)/$*
	python2.6 $(test_dir)/bootstrap.py -d -c $(plonetest_url)/test-$*.x.cfg \
		buildout:directory=$(PWD)/$(test_dir)/$* \
		$(buildout_args)

$(test_dir)/%/bin/test: setup.py $(test_dir)/%/bin/buildout
	$(test_dir)/$*/bin/buildout -c $(plonetest_url)/test-$*.x.cfg \
		buildout:directory=$(PWD)/$(test_dir)/$* \
		$(buildout_args) $(buildout_options)
	touch $@

setup.py:
	$(error `setup.py` is required, please run from your package directory...)

$(versions): %: $(test_dir)/%/bin/test
	@echo 'testing $(package) against Plone $* ...'
	$(test_dir)/$*/bin/test $(test_options)

clean:
	rm -rf $(test_dir)

.PHONY: all clean %
.PRECIOUS: $(test_dir)/%/bin/buildout $(test_dir)/%/bin/test
