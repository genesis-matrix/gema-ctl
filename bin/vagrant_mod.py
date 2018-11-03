#!/bin/false
# -*- coding: utf-8 -*-
"""
Common Variables:
 - PACKER_URI_OUTFILE_PFX
 - PACKER_URI_OUTFILE_SFX

Unsorted Variables:
 - provider:
     ? qemu
     ? virtualbox-iso
     ? vmware-iso
     ? 
"""
from __future__ import print_function
#
import os,sys
import logging
#
logging.basicConfig(stream=sys.stdout, level=logging.INFO)
log = logging.getLogger(__name__)
#
from invoke import task, Collection
from ruamel.yaml import YAML
yaml = YAML()
#
try:
    # https://pypi.org/project/python-vagrant
    import vagrant
except:
    log.error("unable to load vagrant module")
    sys.exit(1)


v = vagrant.Vagrant()


def task_log():
    log.info("".join(["##", __name__ + ":" + sys._getframe(1).f_code.co_name, "##"]))


@task
def help(c):
    task_log()
    pass


@task
def setup(c):
    task_log()
    pass


@task
def up(c):
    task_log()
    pass


@task
def prep(c, name):
    task_log()
    pass


@task
def ssh(c, name):
    task_log()
    pass


@task
def into(c, name):
    task_log()
    pass


@task
def restart(c):
    task_log()
    pass


@task
def down(c):
    task_log()
    pass


@task
def dnsresolv_clear(c):
    task_log()
    return c.run('vagrant landrush ls | awk "{print $2}" | xargs -n1 vagrant landrush del')


@task(pre=[dnsresolv_clear])
def dnsresolv_off(c):
    task_log()
    pass


@task(pre=[down, dnsresolv_off])
def destroy(c):
    task_log()
    pass


@task(pre=[destroy])
def wipe(c):
    task_log()
    pass


@task
def purge(c):
    task_log()
    pass


@task
def boxadd(c, image, provider):
    task_log()
    pass


@task
def boxdel(c, image, provider):
    task_log()
    pass


@task
def boxchk(c, image, provider):
    task_log()
    pass


@task
def boxlst(c, image=None, provider=None):
    task_log()
    yaml.dump(dict((getattr(i, 'name'), {'provider': getattr(i, 'provider'), 'version': getattr(i, 'version')}) for i in v.box_list()), sys.stdout)


@task
def package_artifact(c, image, provider, output_type):
    task_log()
    pass



## EOF
