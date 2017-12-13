# How to mount LVM partitions from rescue mode (Fedora/CentOS/RedHat)

from http://jim-zimmerman.com/?p=587 October 25th, 2011

Boot your rescue media.

Scan for volume groups:

---
> lvm vgscan -v
---

Activate all volume groups:

---
> lvm vgchange -a y
---

List logical volumes:

---
> lvm lvs –all
---

With this information, and the volumes activated, you should be able to mount the volumes:

---
> mount /dev/volumegroup/logicalvolume /mountpoint
---

