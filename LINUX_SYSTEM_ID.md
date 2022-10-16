# Get Linux System Ids

```
uuidgen -s -n '@dns' -N "$(sudo dmidecode -t 2 -t 4| grep -E 'Serial Number|ID:')"
```
