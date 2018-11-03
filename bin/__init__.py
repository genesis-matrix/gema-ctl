#!/bin/false
# -*- coding: utf-8 -*-
from __future__ import print_function
#
import os,sys
from logging import Logger
log = Logger(__name__)
#
from invoke import task, Collection
#

# create variable for 'root' namespace, notably creating a 'root' namespace inhibits implicitly importing task functions
ns = Collection()


# import test_mod
try:
    import tasks.test_mod
    ns.add_collection(Collection.from_module(test_mod), name="test")
except:
    log.error("unable to load test_mod")
    sys.exit(1)

# import gema_mod
try:
    import tasks.gema_mod
    ns.add_collection(Collection.from_module(gema_mod), name="gema")
except:
    log.error("unable to load gema_mod")
    sys.exit(1)

# import platform_mod
try:
    import tasks.platform_mod
    ns.add_collection(Collection.from_module(platform_mod), name="platform")
except:
    log.error("unable to load platform_mod")
    sys.exit(1)

# import salt_mod
try:
    import tasks.salt_mod
    ns.add_collection(Collection.from_module(salt_mod), name="salt")
except:
    log.error("unable to load salt_mod")
    sys.exit(1)

# import vagrant_mod
try:
    import tasks.vagrant_mod
    ns.add_collection(Collection.from_module(vagrant_mod), name="vagrant")
except:
    log.error("unable to load vagrant_mod")
    sys.exit(1)

# import packer_mod
try:
    import tasks.packer_mod
    ns.add_collection(Collection.from_module(packer_mod), name="packer")
except:
    log.error("unable to load packer_mod")
    sys.exit(1)



## EOF
