# Increasing PVC/volume Size
Longhorn requires a few manual steps to achieve this.

### Steps:
1. Stop all pods the volume is attached to
2. Increase size of volume
3. Go to Longhorn UI
4. Attach the volume in maintenance mode
5. Wait for the resizing to finish
6. Start all pods
