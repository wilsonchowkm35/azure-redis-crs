# Welcome to redis-data-sync 👋
![Version](https://img.shields.io/badge/version-1.0-blue.svg?cacheSeconds=2592000)

> POC project for cloning Azure Redis to another subscription and region

## Prerequisite

### Download AzCopy
[AzCopy] (https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)

### SAS 
Generate [SAS Token] (https://docs.microsoft.com/en-us/azure/storage/common/storage-sas-overview)

### Blob storage
Create a configuration file from `config/sample.yaml`

## Steps

### Export Redis 
1. Login to source Azure account
``` ./login.sh source ```
1. Export the Redis DB to source blob storage
``` ./export.sh [your configuration yaml file]```
1. Check your `.rdb` file are generated from Redis to your blob storage

### Cross region and subscription blob copy
1.  
  



## Show your support

Give a ⭐️ if this project helped you!


***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
