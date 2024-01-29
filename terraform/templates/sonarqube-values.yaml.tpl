postgresql:
  # Do not deploy separate PostgreSQL chart
  enabled: false

  # DB Connection params
  postgresqlServer: ${db_host}
  postgresqlUsername: ${db_user}
  postgresqlPassword: ${db_password}
  postgresqlDatabase: ${db_name}

persistence:
  enabled: true
  existingClaim: ${app_persistent_volume_claim_name}

ingress:
  enabled: true
  # Used to create an Ingress record.
  hosts:
    - name: ${app_url}
      path: /
      pathType: Prefix
