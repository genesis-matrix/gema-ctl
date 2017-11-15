#!/bin/env python
from __future__ import print_function
import os,sys
from invoke import task



@task
def build(ctx):
    print("Build")



@task
def testing(ctx):
    print(sys.cwd)
