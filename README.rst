plone-test-maker
================

This provides a Makefile for conveniently running tests against
different versions of Plone.  Simply go to your package under development
and run::

  $ cd plone.app.foo
  $ curl -sL http://is.gd/plone_test_maker | make -sf-

This will create test buildouts for several versions of Plone (by default
3.3, 4.0, 4.1 and 4.2) and run all tests for your package.  Only the
appropriate versions of Python as well as a number of standard unix tools
are required for this — there is no need for any additional setup.

For convenience you might want to set up a shell alias::

  $ alias plone-test-maker="curl -sL http://is.gd/plone_test_maker | make -sf-"

All test buildouts are created inside the `test_builds` directory local to
your package unless specified otherwise (see below).  Tests for a specific
version of Plone can be run using::

  $ plone-test-maker 4.1

Of course you can also use the generated scripts directly::

  $ test_builds/4.1/bin/test -m test_foo


Options
-------

There are several command line options available to only run individual tests
or override default values:

- only test againsts specific versions::

  $ plone-test-maker 3.3 4.1

- explicitly set the package name::

  $ plone-test-maker package=plone.app.foo

- specify `buildout` options::

  $ plone-test-maker buildout_options=-v

- specify test runner options::

  $ plone-test-maker test_options=--unit

- set the directory used for the buildouts::

  $ plone-test-maker test_dir=foo

- remove all test buildouts::

  $ plone-test-maker clean
