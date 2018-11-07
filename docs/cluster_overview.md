# Infrastructure activity summary

![cluster load average](http://bioinformatics.danforthcenter.org/ganglia/stacked.php?m=load_one&c=Bioinformatics&r=hour&st=1460067771&host_regex=)
A detailed view of the current and historical Danforth Center Bioinformatics infrastructure usage can be viewed on [ganglia](http://bioinformatics.danforthcenter.org/ganglia/?c=Bioinformatics).

# Server summary

| Server   | CPUs | RAM (GB) | Scratch (GB) | Function                                   |
| -------- | ---- | -------- | ------------ | ------------------------------------------ |
| aerilon  | 40   | 256      | 1024         | HTCondor job execution                     |
| aquaria  | 12   | 64       | 0            | File server (NFS)                          |
| artemis  | 2    | 2        | 0            | X-ray CT file transfer server              |
| basestar | 4    | 4        | 218          | HTCondor central manager                   |
| blast    | 1    | 1        | 0            | BLAST webserver                            |
| chronos  | 4    | 4        | 0            | Cron scheduler, File transfers, Globus FTP |
| dradis   | 1    | 2        | 0            | User authentication (LDAP)                 |
| galactica| 40   | 1024     | 0            | Server                                     |
| hopper   | 2    | 4        | 0            | Grace/HyperBot FTP server                  |
| hyperion | 8    | 16       | 0            | HTCondor job scheduler (Open Science Grid) |
| jbrowse  | 1    | 2        | 0            | JBrowse webserver                          |
| jupyter  | 8    | 16       | 0            | Small interactive jobs, Jupyter notebook   |
| leda     | 12   | 32       | 838          | HTCondor job execution, NVIDIA Tesla K20X  |
| leonis   | 12   | 64       | 0            | File server (NFS)                          |
| libran   | 12   | 64       | 0            | File server (NFS)                          |
| pacifica | 40   | 1024     | 1024         | HTCondor job execution                     |
| pallas   | 56   | 512      | 1024         | HTCondor job execution                     |
| pegasus  | 40   | 256      | 1024         | HTCondor job execution                     |
| racetrack| 8    | 16       | 0            | MariaDB server                             |
| shiny    | 1    | 2        | 0            | Shiny webserver                            |
| scorpia  | 40   | 256      | 0            | HTCondor job execution                     |
| stargate | 16   | 128      | 0            | Login (ssh), HTCondor job scheduler        |
| tauron   | 40   | 256      | 1024         | HTCondor job execution                     |
| thanatos | 56   | 512      | 1024         | HTCondor job execution                     |
| tyrol    | 2    | 2        | 0            | Web server                                 |
| viper    | 40   | 512      | 558          | GiA Roots                                  |
| zephyr   | 2    | 8        | 0            | Bionano Access webserver                   |
