# Ever Updated 5etools (eu5etools)

Docker image that automatically combines and keeps updated the 5etools assets (5.3GB) with the latest source code (250MB). No more manual pulling or outdated instances.

Built from:
- [5etools-img](https://github.com/5etools-mirror-3/5etools-img) - multimedia assets
- [5etools-src](https://github.com/5etools-mirror-3/5etools-src) - frontend code

## Quick start

```bash
docker run -d -p 8080:80 ghcr.io/backmind/eu5etools:latest
```

Docker compose:
```yaml
services:
  fivetools:
    image: ghcr.io/backmind/eu5etools:latest
    ports:
      - "8080:80"
```

## Tags

- `latest` - Most recent build
- `YYYYMMDD-HHMM-srcXXX-imgYYY` - Timestamped with commit hashes  
- `srcXXX-imgYYY` - Just the commit hashes

## Auto-updates

The GitHub Action runs daily at 6 AM UTC and checks both upstream repos for changes. If there are new commits, it builds a fresh image.

For your homelab, add Watchtower to pull updates automatically:

```yaml
services:
  watchtower:
    image: containrrr/watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_POLL_INTERVAL=3600
    command: --interval 3600 --cleanup
```

## Customization

Want to track a different mirror? Use workflow_dispatch on the Actions tab:
- `src_repo`: https://github.com/5etools-mirror-4/5etools-src.git
- `force_build`: true

Need a specific version? Pin to a timestamped tag:
```yaml
image: ghcr.io/backmind/eu5etools:20250922-1430-abc123f-def456g
```

## Technical details

- **Server**: lighttpd on Alpine Linux
- **Port**: 80
- **Web root**: `/var/www/localhost/htdocs/`
- **Assets**: `/var/www/localhost/htdocs/img/`

## Troubleshooting

**Build failing?** Check the Actions tab for logs.

**Updates not working?** Force a manual update:
```bash
docker compose pull && docker compose up -d
```

**Version check:**
```bash
docker inspect ghcr.io/backmind/eu5etools:latest --format='{{.Config.Labels}}'
```