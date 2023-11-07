#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import subprocess

from setuptools import setup, find_packages


def create_mo_files():
    podir = "po"
    mo = []
    for po in os.listdir(podir):
        if po.endswith(".po"):
            os.makedirs("{}/{}/LC_MESSAGES".format(podir, po.split(".po")[0]), exist_ok=True)
            mo_file = "{}/{}/LC_MESSAGES/{}".format(podir, po.split(".po")[0], "mauna-update.mo")
            msgfmt_cmd = 'msgfmt {} -o {}'.format(podir + "/" + po, mo_file)
            subprocess.call(msgfmt_cmd, shell=True)
            mo.append(("/usr/share/locale/" + po.split(".po")[0] + "/LC_MESSAGES",
                       ["po/" + po.split(".po")[0] + "/LC_MESSAGES/mauna-update.mo"]))
    return mo


changelog = "debian/changelog"
if os.path.exists(changelog):
    head = open(changelog).readline()
    try:
        version = head.split("(")[1].split(")")[0]
    except:
        print("debian/changelog format is wrong for get version")
        version = "0.0.0"
    f = open("src/__version__", "w")
    f.write(version)
    f.close()

data_files = [
                 ("/usr/bin", ["mauna-update"]),
                 ("/usr/share/applications",
                  ["data/top.mauna.update.desktop"]),
                 ("/usr/share/mauna/mauna-update/ui",
                  ["ui/MainWindow.glade"]),
                 ("/usr/share/mauna/mauna-update/src",
                  ["src/AutoAptUpdate.py",
                   "src/Main.py",
                   "src/MainWindow.py",
                   "src/Package.py",
                   "src/RepoDistControl.py",
                   "src/SysActions.py",
                   "src/UserSettings.py",
                   "src/__version__"]),
                 ("/usr/share/mauna/mauna-update/data",
                  ["data/top.mauna.update-autostart.desktop",
                   "data/mauna-update.svg",
                   "data/mauna-update-available-symbolic.svg",
                   "data/mauna-update-error-symbolic.svg",
                   "data/mauna-update-inprogress-symbolic.svg",
                   "data/mauna-update-symbolic.svg",
                   "data/mauna-update-uptodate.svg",
                   "data/mauna-safeupgrade-template.sh",
                   "data/mauna-safeupgrade.service"]),
                 ("/usr/share/polkit-1/actions",
                  ["data/top.mauna.pkexec.mauna-update.policy"]),
                 ("/etc/skel/.config/autostart",
                  ["data/top.mauna.update-autostart.desktop"]),
                 ("/usr/share/icons/hicolor/scalable/apps/",
                  ["data/mauna-update.svg",
                   "data/mauna-update-available-symbolic.svg",
                   "data/mauna-update-error-symbolic.svg",
                   "data/mauna-update-inprogress-symbolic.svg",
                   "data/mauna-update-symbolic.svg",
                   "data/mauna-update-uptodate.svg"])
             ] + create_mo_files()

setup(
    name="mauna-update",
    version=version,
    packages=find_packages(),
    scripts=["mauna-update"],
    install_requires=["PyGObject"],
    data_files=data_files,
    author="Fatih Altun",
    author_email="dev@mauna.top",
    description="Mauna Update application",
    license="GPLv3",
    keywords="mauna-update, update, upgrade, apt",
    url="https://github.com/maunalinux/mauna-update",
)
