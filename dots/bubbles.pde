
void Bubbles(float t) {
  int startEffects = effects.size();
  
  //289, 110, 99   // 100, 100
  //88,  650, 410  // 649, 414
  //134, 274, 504  // 273, 505

  float[][] firstBounces = 
    {{0.172, 0.221, 0.8}, 
    {1.009, 0.200, 0.7}, 
    {1.711, 0.184, 0.6}, 
    {2.307, 0.181, 0.7}, 
    {2.828, 0.188, 0.6}, 
    {3.276, 0.154, 0.5}, 
    {3.713, 0.126, 0.4}, 
    {4.084, 0.118, 0.3}, 
    {4.420, 0.073, 0.2}, 
    {4.721, 0.077, 0.1}, 
    {4.993, 0.032, 0.1}, 
    {5.249, 0.045, 0.1}, 
    {5.483, 0.047, 0.1}, 
    {5.699, 0.062, 0.1}, 
    {5.894, 0.029, 0.1}, 
    {6.079, 0.027, 0.1}, 
    {6.279, 0.500, 0.05}, 
    {6.579, 0.400, 0.07}};

  for (int i = 0; i < firstBounces.length; i++) {
    effects.add(new SmallDotsFlashRipple(t + firstBounces[i][0], cW - 200, cH - 312, firstBounces[i][2] * 20, firstBounces[i][2] * 10, 50, 25, maxRadius, minRadius));
  }

  float[][] secondBounces = 
    {{6.162, 0.384}, 
    {6.673, 0.351}, 
    {7.135, 0.247}, 
    {7.552, 0.250}, 
    {7.941, 0.215}, 
    {8.303, 0.188}, 
    {8.629, 0.156}, 
    {8.928, 0.149}, 
    {9.209, 0.104}, 
    {9.473, 0.111}, 
    {9.703, 0.108}, 
    {9.925, 0.087}};

  for (int i = 0; i < secondBounces.length; i++) {
    effects.add(new SmallDotsFlashRipple(t + secondBounces[i][0], 650, 410, - secondBounces[i][1] * 20, secondBounces[i][1] * 50, 100, 125, 1.2 * maxRadius, minRadius));
    effects.add(new RetractCircle(t + secondBounces[i][0], 650, 410, 2, secondBounces[i][1], secondBounces[i][1] * 2));
  }

  effects.add(new BigBallsContractRipple(t + 10, 400, 200, 0.4, 100, 100, 500, maxRadius, minRadius));
  effects.add(new SmallDotsFlashRipple(t + 10, 400, 200, 2, 100, 100, 500, maxRadius, minRadius));


  float[][] thirdBounces = 
    {{10.670, 0.204}, 
    {11.166, 0.194}, 
    {11.562, 0.165}, 
    {11.879, 0.159}, 
    {12.135, 0.120}, 
    {12.343, 0.123}, 
    {12.511, 0.078}, 
    {12.657, 0.039}, 
    {12.771, 0.036}, 
    {12.871, 0.029}, 
    {12.955, 0.010}, 
    {13.020, 0.010}};

  for (int i = 0; i < thirdBounces.length; i++) {
    effects.add(new SmallDotsFlashRipple(t + thirdBounces[i][0], 600, 800, - thirdBounces[i][1] * 30, thirdBounces[i][1] * 100, 100, 80, 1.2 * maxRadius, minRadius));
    effects.add(new RetractCircle(t + thirdBounces[i][0], 600, 800, 2, thirdBounces[i][1], thirdBounces[i][1] * 2));
  }

  float[][] fourthSound = 
    {{14.362, 0.152}, 
    {14.612, 0.075}, 
    {14.745, 0.042}, 
    {14.819, 0.032}, 
    {14.883, 0.006}, 
    {14.924, 0.006}, 
    {14.957, 0.003}, 
    {14.984, 0.002}};

  for (int i = 0; i < fourthSound.length; i++) {
    effects.add(new SmallDotsFlashRipple(t + fourthSound[i][0], cW - 300, 700, fourthSound[i][1] * 10, 100, 400, 500, maxRadius, minRadius));
  }


  /*
  float[][] deepVoice = 
   {{16.546, }, 
   {, }, 
   {, }, 
   {, }};
   */

  //effects.add(new BigBallsContractRipple(time, mouseX, mouseY, 0.2, 100, 0, 250, maxRadius, minRadius));
  //effects.add(new ContractRipple(time, mouseX, mouseY, 0.2, 100, 100, 50, 400));

  //player.play();
  
  print("Added " + (effects.size() - startEffects) + " effects.\n");
}