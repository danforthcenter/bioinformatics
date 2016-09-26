# Infrastructure activity summary

![cluster load average](http://bioinformatics.danforthcenter.org/ganglia/stacked.php?m=load_one&c=Bioinformatics&r=hour&st=1460067771&host_regex=)
A detailed view of the current and historical Danforth Center Bioinformatics infrastructure usage can be viewed on [ganglia](http://bioinformatics.danforthcenter.org/ganglia/?c=Bioinformatics).

# Server summary

| Server   | CPUs | Threads | RAM (GB) | Scratch (GB) | Function                                  |
| -------- | ---- | ------- | -------- | ------------ | ----------------------------------------- |
| apollo   | 4    | 4       | 4        | 0            | Login, Globus FTP                         |
| basestar | 4    | 4       | 4        | 218          | HTCondor central manager                  |
| aerilon  | 40   | 80      | 256      | 1024         | HTCondor job execution                    |
| pacifica | 40   | 80      | 1024     | 411          | HTCondor job execution                    |
| pallas   | 56   | 112     | 512      | 318          | HTCondor job execution                    |
| pegasus  | 40   | 80      | 256      | 1024         | HTCondor job execution                    |
| tauron   | 40   | 80      | 256      | 1024         | HTCondor job execution                    |
| thanatos | 56   | 112     | 512      | 318          | HTCondor job execution                    |
| scorpia  | 40   | 80      | 256      | 0            | HTCondor job execution                    |
| chronos  | 4    | 4       | 4        | 0            | Cron scheduler, File transfers            |
| jupyter  | 8    | 8       | 16       | 0            | Small interactive jobs, Jupyter notebook  |
| adama    | 8    | 8       | 16       | 0            | File server (NFS)                         |
| cavil    | 8    | 8       | 16       | 0            | File server (NFS)                         |
| roslin   | 8    | 8       | 16       | 0            | File server (NFS)                         |
| dradis   | 1    | 1       | 2        | 0            | User authentication (LDAP)                |
| tyrol    | 2    | 2       | 2        | 0            | Web server                                |
| viper    | 40   | 80      | 512      | 558          | GiA Roots                                 |
