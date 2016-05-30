/* Copyright (C) 2016  Aapeli Vuorinen

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>. */

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim analyzer;
FFT fft;

LinearFunctional bottom;
LinearFunctional second;
LinearFunctional middle;
LinearFunctional high;

// This programmatically generates effects from the music
void createEffectsFromMusic(String filename, float startTime) {
  // Just for counting how many we added
  int startEffects = effects.size();
  
  float startAutoTime = startTime;

  // Load the left channel of the audio (should probably combine both channels)
  analyzer = new Minim(this);
  AudioSample song = analyzer.loadSample(filename, 2048);
  float[] leftChannel = song.getChannel(AudioSample.LEFT);

  // Buffer size and sample rate
  int bSize = 2048;
  float sRate = song.sampleRate();

  // FFT buffer size
  int fftSize = 2048;

  fft = new FFT(bSize, sRate);

  // These are linear functionals on the frequency spectrum (basicaly just
  // weighted integrals of the fequency bands, nothing fancy), see
  // functionals.pde for detailed explanation of how they work
  bottom = new RangeMeasure(bSize, sRate, 2.5, 20, 0, 80);
  second = new RangeMeasure(bSize, sRate, 1.8, 10, 80, 300);
  middle = new RangeMeasure(bSize, sRate, 1.8, 10, 300, 700);
  high = new RangeMeasure(bSize, sRate, 1.5, 10, 700, 5000);

  float[] fftSamples = new float[fftSize];
  fft = new FFT(fftSize, sRate);

  int totalChunks = (leftChannel.length / fftSize) + 1;

  float[][] spectra = new float[totalChunks][fftSize];

  for (int chunkIdx = 0; chunkIdx < totalChunks; ++chunkIdx) {
    int chunkStartIndex = chunkIdx * fftSize;
    int chunkSize = min(leftChannel.length - chunkStartIndex, fftSize);
    System.arraycopy(leftChannel, chunkStartIndex, fftSamples, 0, chunkSize);

    if (chunkSize < fftSize) {
      java.util.Arrays.fill(fftSamples, chunkSize, fftSamples.length - 1, 0.0);
    }

    fft.forward(fftSamples);

    bottom.Shift();
    second.Shift();
    middle.Shift();
    high.Shift();

    for (int i = 0; i < fft.specSize(); i++) {
      spectra[chunkIdx][i] = fft.getBand(i);
    }

    for (int i = 0; i < fft.specSize(); i++) {
      bottom.ApplyFreq(i, fft.getBand(i));
      second.ApplyFreq(i, fft.getBand(i));
      middle.ApplyFreq(i, fft.getBand(i));
      high.ApplyFreq(i, fft.getBand(i));
    }

    float t = chunkIdx * bSize / sRate;

    // Pretty obvious
    if (t > startAutoTime) {
      if (bottom.Peaked()) {
        effects.add(new ContractRipple(t, cW - 100, cH - 50, bottom.LastValue() / 2500, 100, 100, 500));
      }
      if (second.Peaked()) {
        effects.add(new BigBallsContractRipple(t, 30, cH - 58, second.LastValue() / 1000, 50, 500, 250, maxRadius, minRadius));
      }
      if (middle.Peaked()) {
        effects.add(new FlashRipple(t, cW / 2, 130, middle.LastValue() / 1000, 50, 250, 200));
      }
      if (high.Peaked()) {
        effects.add(new BigBallsContractRipple(t, 500, 500, high.LastValue() / 5000, 150, 300, 500, maxRadius, minRadius));
        effects.add(new SmallDotsFlashRipple(t, 500, 500, high.LastValue() / 5000, 150, 300, 500, maxRadius, minRadius));
      }
    }
  }

  print("Added " + (effects.size() - startEffects) + " effects.\n");

  song.close();
}