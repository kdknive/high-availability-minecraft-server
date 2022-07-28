#!/bin/bash
kubectl patch hpa multipaper-lobby-hpa -n minecraft -p '{"spec":{"minReplicas": 10}}'
sleep 10m
for n in {0..9}
do
    kubectl cp multipaper.yml minecraft/multipaper-lobby-$n:/data
    kubectl cp bukkit.yml minecraft/multipaper-lobby-$n:/data
    kubectl cp server.properties minecraft/multipaper-lobby-$n:/data
    kubectl cp plugins minecraft/multipaper-lobby-$n:/data/
    sed -i "s/lobby-$n/lobby-$(($n+1))/" multipaper.yml
    sed -i "s/3212$n/3212$(($n+1))/" server.properties
done
kubectl patch hpa multipaper-lobby-hpa -n minecraft -p '{"spec":{"minReplicas": 3}}'
kubectl rollout restart statefulset multipaper-lobby -n minecraft