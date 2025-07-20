# WordPress Docker Setup Instructions

## Setup Process

1. **Copy Template Files**
    - Copy all contents from `@instructions/inc/wordpress-docker-setup` to the project root including hidden `.env.example` file
    - Rename any copied file if they include `example` in their name (e.g., `.env.example` to `.env`)

2. **Environment Configuration**
    - Read the `.env` file to identify all required variables
    - Read `docker-compose.yml` to understand how these variables are used
    - Ask for each variable's value one by one (not all at once) and give clear instructions on what each variable is for
    - For any values containing spaces, wrap them in quotes

3. **Update Docker Configuration**
    - After `.env` is complete, update `docker-compose.yml`:
        - Replace generic volume and network names with project-specific names (using the project name from `.env`)
    - Ensure all references use the same naming pattern

4. **Docker Information**
   - Provide the server url to access the WordPress site
   - Provide admin username and password for WordPress
