# Setup

### Compiling

**Installing Crystal**
https://crystal-lang.org/docs/installation/

**Installing git**
https://gist.github.com/derhuerst/1b15ff4652a867391f03#file-linux-md

**Compiling RotateSRV**
```
$ git clone https://github.com/Yive/RotateSRV
$ cd RotateSRV
$ shards install
$ crystal build ./src/RotateSRV.cr
```

### Pre-compiled builds
https://github.com/Yive/RotateSRV/releases

### Usage
```
$ ./RotateSRV
```
1. First off, execute the file once to generate it's config files.
2. Two folders will be generated in the base directory. One being `domains` and the other being `example-domains`.
3. `example-domains` will contain another folder within it which will have the required files for a domain.
4. Create a copy of the `mc.example.com` folder inside of the `domains` folder.
5. Edit the files in the newly made folder. Then execute the file again.

**Note: `example-domains` gets deleted & regenerated each launch so don't keep anything in it.**

_It's recommended to run the command inside of tmux or screen so it doesn't close the program when you close your ssh session_
[Tmux Tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-tmux-on-ubuntu-12-10--2)
[Screen Tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-screen-on-an-ubuntu-cloud-server)

### Files

**.env**
```
# API key for Cloudflare.
CLOUDFLARE-KEY=
# Zone ID for your domain at Cloudflare.
CLOUDFLARE-ZONE=
# The email for the account that has your domain on it.
CLOUDFLARE-EMAIL=

# The sub-domain/domain that your players join through. (MUST BE AN SRV RECORD)
DOMAIN-NAME=mc.example.com
# The port that your SRV record is pointing to.
PORT=25565
```
- `CLOUDFLARE-KEY` - Your global API key from Cloudflare.
- `CLOUDFLARE-ZONE` - The zone id for the base domain of that folder. IE, the zone id for example.com if your server is on mc.example.com or just example.com
- `CLOUDFLARE-EMAIL` - The email address that you use to log into Cloudflare with.
- `DOMAIN-NAME` - The exact domain/subdomain which is an SRV record for your players to join your server.
- `PORT` - Port used within that SRV record.

**domains.txt**
```
example1.ddns.net
example2.ddns.net
```
- List of domains which are not blacklisted. Domains are separated by new lines. You cannot have multiple domains on the same line.

**current.txt**
```
example.ddns.net
```
- The current target of the SRV record. **THIS MUST BE MANUALLY SET DURING SETUP.**

### File structure example
**This is what your file structure should look like when ready.**

_Won't 100% look the same, but the concept should match no matter how many domains you have._
```
RotateSRV/
├── domains/
│   ├── mc.example.com/
│   │   ├── .env
│   │   ├── current.txt
│   │   ├── domains.txt
│   ├── play.example.com/
│   │   ├── .env
│   │   ├── current.txt
│   │   ├── domains.txt
└── RotateSRV
```