docker stop portainer
docker run --rm -v portainer_data:/data portainer/helper-reset-password --password "123"
docker start portainer
