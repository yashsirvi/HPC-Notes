import sys
import os
# get first argument
package_name = sys.argv[1]

if not os.path.exists("~/rpm/" + package_name):
    os.makedirs("~/rpm/" + package_name)
try:
    os.system("yumdownloader --destdir ~/rpm --resolve " + package_name)
except:
    print("Error: package not found")
    os.rmdir("~/rpm/" + package_name)


# install all packages in the directory
for filename in os.listdir("~/rpm/" + package_name):
    os.system(f"rpm2cpio ~/rpm/{package_name}/{filename} | cpio -D ~/centos -idmv")
