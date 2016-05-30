import ddf.minim.analysis.*;
import ddf.minim.*;

Minim analyzer;
FFT fft;

float startAutoTime = 16.5;

LinearFunctional bottom;
LinearFunctional second;
LinearFunctional middle;
LinearFunctional high;

float sM;

void createEffectsFromMusic(String filename) {
  int startEffects = effects.size();

  analyzer = new Minim(this);

  AudioSample song = analyzer.loadSample(filename, 2048);

  float[] leftChannel = song.getChannel(AudioSample.LEFT);

  int bSize = 2048;
  float sRate = song.sampleRate();
  int fftSize = 2048;

  fft = new FFT(bSize, sRate);

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
    System.arraycopy(leftChannel, // source of the copy
      chunkStartIndex, // index to start in the source
      fftSamples, // destination of the copy
      0, // index to copy to
      chunkSize // how many samples to copy
      );

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