## Packet Structure

```
saslAuthRequest {
  ushort userNameLen
  byte[userNameLen] userName
  ushort passCodeLen
  byte[passCodeLen] passCode
  ushort serviceNameLen
  byte[serviceNameLen] serviceName
  ushort realmNameLen
  byte[realmNameLen] realmName
}

saslAuthResponse {
  ushort responseLen
  byte[responseLen] response
}
```

respnse must start with either "OK" or "NO"
