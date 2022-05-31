function(request) {
  local statefulset = request.object,
  local labelKey = statefulset.metadata.annotations["service-per-pod-label"],
  local ports = statefulset.metadata.annotations["service-per-pod-ports"],
  local port_type = statefulset.metadata.annotations["service-per-pod-type"],

  // Create a service for each Pod, with a selector on the given label key.
  attachments: [
    {
      apiVersion: "v1",
      kind: "Service",
      metadata: {
        name: statefulset.metadata.name + "-" + index,
        labels: {app: "service-per-pod"},
        namespace: statefulset.metadata.namespace
      },
      spec: {
        type: port_type,
        selector: {
          [labelKey]: statefulset.metadata.name + "-" + index
        },
        ports: [
          {
            local parts = std.split(portnums, ":"),
            name: "port-" + std.parseInt(parts[0]),
            port: std.parseInt(parts[0] + index),
            nodePort: std.parseInt(parts[1] + index),
          }
          for portnums in std.split(ports, ",")
        ]
      }
    }
    for index in std.range(0, statefulset.spec.replicas - 1)
  ]
}
