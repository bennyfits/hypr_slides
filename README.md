# Hypr_slides

Rudimentary slide/hide functionality for application windows.


## Create a slide config JSON file

```json
{
  "name": "Spotify",
  "selector": "select((.class==\"Spotify\"))",
  "position": {
      "home": {
        "x": 30,
        "y": -1100
      },
      "active": {
        "y": 30
      }
  },
  "size": {
    "width": 1860,
    "height": 1000
  },
  "command": "spotify-launcher"
}
```