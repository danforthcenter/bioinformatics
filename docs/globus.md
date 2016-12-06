# Accessing shared data with Globus

[Globus Connect](https://www.globus.org/) is a service for file transfer
and sharing. The Globus file transfer service can transfer data between
two endpoints, automatically ensuring that file integrity is maintained.
Users initiate the transfer process, which runs in the background, and
will be notified via email when the transfer is complete.

The Bioinformatics Core Facility at the Danforth Center provides a
Globus Endpoint for system users and a public account for read-only
access to shared data sets.

## Accessing the Bioinformatics Endpoint

Users wanting to access shared data via Globus will need a 
[Globus](https://www.globus.org/) account and a destination endpoint
(either a [Globus Connect](https://www.globus.org/globus-connect)
Personal or Server endpoint).

After logging in to your Globus account, connect to the Danforth Center
Endpoint by clicking on one of the Endpoint boxes on the Transfer Files
page, then search for the `Danforth Center Bioinformatics` endpoint.

The endpoint requires additional authentication. If you have a
Bioinformatics user account, use your server username and password
credentials to log in. If you are accessing community data sets, use the
following credentials to log in:

```
Username: ddpscglobus
Password: Yb11&rDA%T
```

Once connected, connect to the source or destination endpoint and 
initiate the desired file transfers.
