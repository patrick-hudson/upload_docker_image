# Scripts that upload Docker images to various repositories

## upload_ecr.sh

This script install all necessary tools to build and upload docker images to Amazon ECR.

### Usage:

*IMPORTANT* - On the first run of this script, you *MUST* pass the -f flag to indicate the first run of the script. This installs dependencies and such.

```
  -h| --help           Displays this help text
                       this is more help text.
----------------------------------------------------------------
REQUIRED
----------------------------------------------------------------
  -u| --account-id     AWS Account ID - Found in Account settings in AWS Console
  -i| --image          Name of your image to upload
  -t| --tag            Image Tag (Maximum of 1 tag per image)
----------------------------------------------------------------
Optional
----------------------------------------------------------------
  -r| --region         AWS Region to upload to (Default: us-east-1) 
  -f| --first-run      Specify this flag if this is the first run of the script (Installs dependencies like Docker/Python/AWSCLI)
```

#### Example command for first run

``` ./upload_ecr.sh -f -u accountid -i imagename -t tag -r us-east-1 ```

#### Example command to only upload image

``` ./upload_ecr.sh -u accountid -i imagename -t tag -r us-east-1 ```

## upload_dockerhub.sh

This script install all necessary tools to build and upload docker images to DockerHub.

### Usage:

*IMPORTANT* - On the first run of this script, you *MUST* pass the -f flag to indicate the first run of the script. This installs dependencies and such.

```
  -h| --help           Displays this help text
                       this is more help text.
----------------------------------------------------------------
REQUIRED
----------------------------------------------------------------
  -u| --user           DockerHub Username
  -i| --image          Name of your image to upload
  -t| --tag            Image Tag (Maximum of 1 tag per image)
----------------------------------------------------------------
Optional
----------------------------------------------------------------
  -p| --password       DockerHub Password (You can pass the password as an argument if you wish to not authenticate interactively)
  -f| --first-run      Specify this flag if this is the first run of the script (Installs dependencies like Docker)
```

#### Example command for first run

``` ./upload_dockerhub.sh -f -u user1 -i imagename -t tag -f ```

#### Example command to only upload image

``` ./upload_dockerhub.sh -u user1 -i imagename -t tag```

## upload_dockerprivate.sh

This script install all necessary tools to build and upload docker images to a Private Repo.

### Usage:

*IMPORTANT* - On the first run of this script, you *MUST* pass the -f flag to indicate the first run of the script. This installs dependencies and such.

```
  -h| --help           Displays this help text
                       this is more help text.
----------------------------------------------------------------
REQUIRED
----------------------------------------------------------------
  -u| --user           DockerHub Username
  -i| --image          Name of your image to upload
  -t| --tag            Image Tag (Maximum of 1 tag per image)
----------------------------------------------------------------
Optional
----------------------------------------------------------------
  -p| --password       DockerHub Password (You can pass the password as an argument if you wish to not authenticate interactively)
  -f| --first-run      Specify this flag if this is the first run of the script (Installs dependencies like Docker)
```

#### Example command for first run

``` ./upload_dockerprivate.sh -f -u user1 -i imagename -t tag -f ```

#### Example command to only upload image

``` ./upload_dockerprivate.sh -u user1 -i imagename -t tag```