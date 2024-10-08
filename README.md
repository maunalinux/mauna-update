# Mauna Update

Mauna Update is a simple update application for debian based operating systems.

### **Dependencies**

This application is developed based on Python3 and GTK+ 3. Dependencies:
```bash
dh-python python3-all python3-setuptools
```

### **Run Application from Source**

Install dependencies
```bash
sudo apt install dh-python python3-all python3-setuptools
```
Clone the repository
```bash
git clone https://github.com/maunalinux/mauna-update.git ~/mauna-update
```
Run application
```bash
python3 ~/mauna-update/src/Main.py
```

### **Build deb package**

```bash
sudo apt install devscripts git-buildpackage
sudo mk-build-deps -ir
gbp buildpackage --git-export-dir=/tmp/build/mauna-update -us -uc
```

### **Screenshots**

![Mauna Update 1](screenshots/mauna-update-1.png)

![Mauna Update 2](screenshots/mauna-update-2.png)
