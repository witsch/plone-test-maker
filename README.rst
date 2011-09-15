plone-test-maker
================

This provides a Makefile for conveniently running tests against
different versions of Plone.  Simply go to your package under development
and run::

  $ curl -sL http://is.gd/plone_test_maker | make -sf-

This will create a Plone buildout and run all tests for your package without
the need to set anything up locally.  For convenience you might want to set
up a shell alias::

  $ alias plone-test-maker="curl -sL http://is.gd/plone_test_maker | make -sf-"
