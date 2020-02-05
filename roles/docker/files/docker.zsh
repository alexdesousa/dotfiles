###############################################################################
# BEGIN: Docker aliases

function docker_clean_all {
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -q)
  docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
  docker volume rm $(docker volume ls -qf dangling=true)
}

docker_clean_all='docker_clean_all'

# END: Docker aliases
###############################################################################
