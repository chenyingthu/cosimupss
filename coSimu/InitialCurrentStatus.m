CurrentStatus = eval(Config.caseName);
CurrentStatus.gen(:, [9,10,4,5]) = Config.loadmult * CurrentStatus.gen(:, [9,10,4,5]); % deal with load mult
CurrentStatus.genControllabilty = CurrentStatus.gen(:, [9,10,4,5]);
