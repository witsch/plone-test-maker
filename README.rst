plone-test-maker
================

This provides a Makefile for conveniently running tests against
different versions of Plone.  Simply clone the repository somewhere::

  $ cd ~/GitHub
  $ git clone git@github.com:witsch/plone-test-maker.git

Now you can go back to your package under development and make sure
everything is fine::

  $ cd ~/Plone/plone.app.linkintegrity
  $ plone-test-maker

For convenience you might want to set up a shell alias::

  $ alias plone-test-maker="make -f ~/GitHub/plone-test-maker/Makefile"
