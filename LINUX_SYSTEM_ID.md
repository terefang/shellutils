# Get Linux System Ids

```
dmidecode -t 1|fgrep UUID:|cut -f2 -d:|tr -d ' '

uuidgen -s -n '@dns' -N "$(sudo dmidecode -t 2 -t 4| grep -E 'Serial Number|ID:')"

uuidgen -s -n '@x500' -N "$(sudo dmidecode -t 2 -t 4| grep -E 'Serial Number|ID:')"
```
