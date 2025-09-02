# Command List
#boot [HOSTS...]
#shutdown [HOSTS...]
#start-updates HOST
#status
#generate-config-file (list of hostnames?)

#update windows image
#reinstall windows






boot-hosts() {
  # Send ethernet wake-on-LAN packet to the given hostnames.

  bold "================ boot hosts ================"

  for MACHINE in "$@"; do
    doit etherwake -i $SERVER_NETWORK_INTERFACE ${HOST_TO_MACADDR[$MACHINE]}
  done
}

shutdown-hosts() {
  # Send SSH shutdown command to the given hostnames.

  bold "================ shutdown hosts ================"

  for MACHINE in "$@"; do
    # We inline doit() here so that we can let the SSH commands run in the background with &.
    # This is important because if a machine is already shut down, `ssh` will hang for a while
    # before failing. We disable "StrictHostKeyChecking" because the prompt won't work when ssh is
    # running in the background. Since we're relying on public-key authentication and will only
    # be executing one command that contains no secrets, there's no security risk from MITM. Also,
    # this should be on a private network anyway.
    #
    # While we're at it, we take the opportunity to properly quote the arguments in the console
    # output.
    COMMAND=( ssh -o "StrictHostKeyChecking no" "$SHUTDOWN_USERNAME@$IP_PREFIX.${HOST_TO_NUMBER[$MACHINE]}" -- 'shutdown /p /f' )
    echo-command "${COMMAND[@]}" "&"
    if [ $DRY_RUN == no ]; then
      "${COMMAND[@]}" &
    fi
  done

  # Wait for all ssh commands to complete.
  if [ $DRY_RUN == no ]; then
    bold wait
    wait
  else
    echo wait
  fi
}