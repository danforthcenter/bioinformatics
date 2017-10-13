# Infrastructure activity summary

![cluster load average](http://bioinformatics.danforthcenter.org/ganglia/stacked.php?m=load_one&c=Bioinformatics&r=hour&st=1460067771&host_regex=)
A detailed view of the current and historical Danforth Center Bioinformatics infrastructure usage can be viewed on [ganglia](http://bioinformatics.danforthcenter.org/ganglia/?c=Bioinformatics).

# Server summary

| Server   | CPUs | RAM (GB) | Scratch (GB) | Function                                   |
| -------- | ---- | -------- | ------------ | ------------------------------------------ |
| adama    | 8    | 16       | 0            | File server (NFS)                          |
| aerilon  | 40   | 256      | 1024         | HTCondor job execution                     |
| apollo   | 4    | 4        | 0            | Login (SSH)                                |
| basestar | 4    | 4        | 218          | HTCondor central manager                   |
| blast    | 1    | 1        | 0            | BLAST webserver                            |
| cavil    | 8    | 16       | 0            | File server (NFS)                          |
| chronos  | 4    | 4        | 0            | Cron scheduler, File transfers, Globus FTP |
| dradis   | 1    | 2        | 0            | User authentication (LDAP)                 |
| hopper   | 2    | 4        | 0            | Grace/HyperBot FTP server                  |
| hyperion | 8    | 16       | 0            | HTCondor job scheduler (Open Science Grid) |
| jbrowse  | 1    | 2        | 0            | JBrowse webserver                          |
| jupyter  | 8    | 16       | 0            | Small interactive jobs, Jupyter notebook   |
| leda     | 12   | 32       | 838          | HTCondor job execution, NVIDIA Tesla K20X  |
| pacifica | 40   | 1024     | 1024         | HTCondor job execution                     |
| pallas   | 56   | 512      | 1024         | HTCondor job execution                     |
| pegasus  | 40   | 256      | 1024         | HTCondor job execution                     |
| roslin   | 8    | 16       | 0            | File server (NFS)                          |
| shiny    | 1    | 2        | 0            | Shiny webserver                            |
| six      | 8    | 16       | 0            | HTCondor job scheduler (Danforth Center)   |
| scorpia  | 40   | 256      | 0            | HTCondor job execution                     |
| tauron   | 40   | 256      | 1024         | HTCondor job execution                     |
| thanatos | 56   | 512      | 1024         | HTCondor job execution                     |
| tyrol    | 2    | 2        | 0            | Web server                                 |
| viper    | 40   | 512      | 558          | GiA Roots                                  |
| zephyr   | 2    | 8        | 0            | Bionano Access webserver                   |
