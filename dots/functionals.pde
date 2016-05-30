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

// These are "linear functionals" on the frequency spectrum, so as this is just
// a finite dimensional vector space they are weighted sums of the frequency
// bands. They also store the past few weighted sums, so that you can measure
// if they peaked or not. So it stores a rolling n past weighted sums.
class LinearFunctional {
  int bufferSize;
  float sampleRate;

  // See Peaked()
  float spikeSensitivity;

  // This actually stores the weighted sums
  float[] histories;

  LinearFunctional (int bufferSizeS, float sampleRateS, float spikeSensitivityS) {
    bufferSize = bufferSizeS;
    sampleRate = sampleRateS;
    spikeSensitivity = spikeSensitivityS;
  }

  // Setup histories[]
  void InitializeHistory (int history) {
    histories = new float[history];

    for (int i = 1; i < histories.length; i++) {
      histories[i] = 0;
    }
  }

  float getBandFreq(int band) {
    return (float) band * sampleRate / bufferSize;
  }

  // Returns the number of past data poitns kept
  int NoPoints() {
    return histories.length;
  }

  // Shifts the past datapoints back to accomodate for the next point
  void Shift() {
    for (int i = 1; i < histories.length; i++) {
      histories[i - 1] = histories[i];
    }
    histories[histories.length - 1] = 0;
  }

  void ApplyFreq(int band, float freq) {
  }

  float StandardDeviation() {
    float tot = 0;
    float totSq = 0;

    for (int i = 0; i < histories.length; i++) {
      tot += histories[i];
      totSq += histories[i]*histories[i];
    }

    return (totSq - tot * tot / histories.length) / histories.length;
  }

  float Sum() {
    float tot = 0;

    for (int i = 0; i < histories.length; i++) {
      tot += histories[i];
    }

    return tot;
  }

  float Average() {
    float tot = 0;

    for (int i = 0; i < histories.length; i++) {
      tot += histories[i];
    }

    return tot / histories.length;
  }

  float LastValue() {
    return histories[histories.length - 1];
  }

  // This is a pretty rudementary peak detection algorithm, but does the job
  boolean Peaked() {
    return LastValue() > spikeSensitivity * Average();
  }
}

// This is just a plain sum
class AverageMeasure extends LinearFunctional {
  AverageMeasure(int bufferSizeS, float sampleRateS, float spikeSensitivityS, int history) {
    super(bufferSizeS, sampleRateS, spikeSensitivityS);
    InitializeHistory(history);
  }

  void ApplyFreq(int band, float freq) {
    histories[histories.length - 1] += freq;
  }
}

// Only sum the frequencies between startFreq and endFreq
class RangeMeasure extends LinearFunctional {
  float startFreq, endFreq;

  RangeMeasure(int bufferSizeS, float sampleRateS, float spikeSensitivityS, int history, float startFreqS, float endFreqS) {
    super(bufferSizeS, sampleRateS, spikeSensitivityS);
    startFreq = startFreqS;
    endFreq = endFreqS;
    InitializeHistory(history);
  }

  void ApplyFreq(int band, float freq) {
    histories[histories.length - 1] += ((getBandFreq(band) >= startFreq) && (getBandFreq(band) <= endFreq)) ? freq : 0;
  }
}

// I originally tried to perform an FFT on the sounds and then try and detect
// them by monitoring the value of the l^2 dual over time, but it turns out that
// the FFT is pretty noisy and ugly, so that didn't work out very well. This is
// supposed to be some kind of l^2 dual of given data, but because it's dB and
// I want positive functionals, it has a 180 + data[band] factor. Anyway, it's
// not in use right now since it didn't work very well.
class IndicatorMeasure extends LinearFunctional {
  float[] data;

  IndicatorMeasure(int bufferSizeS, float sampleRateS, float spikeSensitivityS, int history, float[] dataS) {
    super(bufferSizeS, sampleRateS, spikeSensitivityS);
    InitializeHistory(history);
    data = dataS;
  }

  void ApplyFreq(int band, float freq) {
    histories[histories.length - 1] += freq * (180 + data[band]);
  }
}
