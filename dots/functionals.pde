
class LinearFunctional {
  int bufferSize;
  float sampleRate;

  float spikeSensitivity;

  float[] histories;

  LinearFunctional (int bufferSizeS, float sampleRateS, float spikeSensitivityS) {
    bufferSize = bufferSizeS;
    sampleRate = sampleRateS;
    spikeSensitivity = spikeSensitivityS;
  }

  void InitializeHistory (int history) {
    histories = new float[history];

    for (int i = 1; i < histories.length; i++) {
      histories[i] = 0;
    }
  }

  float getBandFreq(int band) {
    return (float) band * sampleRate / bufferSize;
  }

  int NoPoints() {
    return histories.length;
  }

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

  boolean Peaked() {
    return LastValue() > spikeSensitivity * Average();
  }
}

class AverageMeasure extends LinearFunctional {
  AverageMeasure(int bufferSizeS, float sampleRateS, float spikeSensitivityS, int history) {
    super(bufferSizeS, sampleRateS, spikeSensitivityS);
    InitializeHistory(history);
  }

  void ApplyFreq(int band, float freq) {
    histories[histories.length - 1] += freq;
  }
}

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