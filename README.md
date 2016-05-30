# Dots

Dots is a programmatically generated [music video](https://youtu.be/j7NIdg9mof0) to [Yosi Horikawa](https://soundcloud.com/yosi-horikawa)'s [Bubbles](https://soundcloud.com/yosi-horikawa/bubbles) using the [Processing](https://processing.org/) language.

## Intro

It's quite simple, it generates random dots on the screen, then creates effects from the music (the first 15 seconds are handwritten and the rest is created from an FFT). You can also just play around.

[![YouTube video of result](https://img.youtube.com/vi/j7NIdg9mof0/0.jpg)](https://www.youtube.com/watch?v=j7NIdg9mof0)

Thanks to Yosi Horikawa for his awesome song that inspired this, here's some links to his stuff:
* [SoundCloud](https://soundcloud.com/yosi-horikawa)
* [BandCamp](https://yosihorikawa.bandcamp.com/)
* [Original song on SoundCloud](https://soundcloud.com/yosi-horikawa/bubbles)

Made by [Aapeli Vuorinen](https://www.aapelivuorinen.com/). (c) 2016 Aapeli Vuorinen. Released under GPLv3.

## Getting it up and running

### What you need
There's a couple of things you need:
* [Processing 3](https://processing.org/download/)
* Minim by Damien Di Fede and Anderson Mills (or you can comment out everything that requires it)
* Video Export by Abe Pazos (or you can comment out everything that requires it)
* [ffmpeg](https://ffmpeg.org/download.html)
* [Bubbles mp3 file](https://yosihorikawa.bandcamp.com/track/bubbles), or any other audio file (optional)

### How to get it
1. Clone this repo
2. Download [Processing](https://processing.org/download/)
3. Install Minim and Video Export from Processing by going to Sketch > Import Library > Add Library
4. Download [ffmpeg](https://ffmpeg.org/download.html)
5. The first time you run the sketch a window will pop up asking for the location of the ffmpeg executable
6. (optional) Buy the [Bubbles mp3 file](https://yosihorikawa.bandcamp.com/track/bubbles) and place it in the Dots folder as `bubbles.mp3`
7. (optional) Set the display flag to true on [line 27 of dots.pde](https://github.com/aapeliv/Dots/blob/master/dots/dots.pde#L27) to view the Bubbles animation
8. (optional) Set the export flag to true on [line 29 of dots.pde](https://github.com/aapeliv/Dots/blob/master/dots/dots.pde#L29) to export
9. (optional) Once it has rendered, run `ffmpeg -i bubbles.mp3 -i Dots{NUMBER}.mp4 -c:v copy -c:a copy output.mp4` to join the music to the video
