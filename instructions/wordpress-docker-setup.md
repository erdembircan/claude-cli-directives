# WordPress Docker Setup Instructions

## Guidelines

Follow these steps in order:
- copy the content of `@instructions/inc/wordpress-docker-setup` folder to root of the project
- ask for each of the key values that are required in the `.env` file one by one instead of asking for all at once
- use quotes for the values in the `.env` file which has spaces in it
- change the volume and network names in `docker-composer.yml` to match the project name after creation of the `.env` file
