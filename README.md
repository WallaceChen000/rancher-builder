## How to create base image: `wallacechendockerhub/rancher:release-v2-6-4`?  
+ git clone rancher sourcecode from github.  
+ switch branch to release/v2.6.4.  
+ download dapper & run dapper to create base image `rancher:release-v2-6-4`.  
+ retag `rancher:release-v2-6-4` to `wallacechendockerhub/rancher:release-v2-6-4` as a backup base image.  
```sh  
rancher                                                    release-v2-6-4          0f430bdf3d7e   13 days ago      2.4GB
wallacechendockerhub/rancher                               release-v2-6-4          0f430bdf3d7e   13 days ago      2.4GB
```  
---
## How to use?  
+ run command `./rancher-builder-cmd.sh build` to create your rancher builder image.  