
# Increasing PVC/volume Size
Longhorn requires a few manual steps to achieve this.

### Steps:
1. Stop all pods the volume is attached to
1. Increase size of volume
1. Go to Longhorn UI
1. Attach the volume in maintenance mode
1. Wait for the resizing to finish
1. Start all pods