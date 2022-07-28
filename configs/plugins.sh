#!/bin/bash
for n in {0..9}
do
    kubectl cp plugins minecraft/multipaper-lobby-$n:/data/
done
kubectl rollout restart statefulset multipaper-lobby -n minecraft