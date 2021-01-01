//launchUtils.lib.ks
//Library of functions used for launching a rocket at the launchpad

//A function intended to throttle back the engines if wanted. WIP
function getThrottleValue {
  return 1.
}

//The function that gives a pitch value that will perform a nice gravity turn
function getTargetPitch {
  //  *** first example pitch-over curve: 90 - 0.00274 * alt:radar^0.9562 ***
  local fPitch is round(90 - 0.00274 * alt:radar^0.9562, 1).
  if fPitch >= 0 {
    return fPitch.
  }
  else {
    return 0.
  }
}

//A function that should return the current g Loading of the vessel. WIP
function getGLoad {
  return "unknown".
}

//an incredibly simple function that just stages only if it can
function doSafeStage {
  if stage:ready {
    stage.
  } else {
    print "stage wasn't ready...doSafeStage did nothing".
  }
}

function doSmartStage {
  list engines in enList.
  local nextStage is stage:NUMBER - 1.
  local dontStageTwice is false.
  local enInNext is list().
  local nonSepList is list().
  // print STAGE:NUMBER.
  for en in enList {
    if not(en:NAME = "sepMotor1") {
      nonSepList:ADD(en).
    }
  }
  for engine in nonSepList {
    if engine:STAGE = nextStage {
      print "engine " + engine:NAME + " added to enInNext list".
      enInNext:ADD(engine).
    } else if engine:STAGE = stage:NUMBER and engine:DECOUPLEDIN = nextStage - 1{
      set dontStageTwice to true.
    }
  }
  if enInNext:EMPTY and dontStageTwice = false {
    wait 1.
    doSafeStage().
    wait 1.
    doSafeStage().
    print "Performed a 2 step staging sequence".
  } else {
    wait 1.
    doSafeStage().
    print "Performed a 1 step staging sequence".
  }
}

//A function which will return true if any of the engines in the current stage
//have flamed out. Untested
function stageSpent {
  list engines in eList.
  set stageEngines to list().
  for engine in eList {
    if engine:STAGE = stage:NUMBER {
      stageEngines:ADD(engine).
    }
  }
  for engine in stageEngines {
    if engine:ALLOWRESTART = false {
      if engine:RESOURCES[0]:AMOUNT <= 0.01 return true.
    } else {
      if engine:FLAMEOUT return true.
    }
  }
}

//A function which will perform the liftoff stage, unless something fucks up
function doSmartLiftOff {
  set partsList to ship:PARTS.
  set currentStage to STAGE:NUMBER.
  set launchClamps to list().
  //check if the ship even has launch clamps
  for part in partsList {
    if part:NAME = "launchClamp1" {
      set hasLaunchClamps to true.
      launchClamps:ADD(part).
    }
  }
  //check if the launch clamps will interfere, or require a two-stage liftoff
  for clamp in launchClamps {
    if not(clamp:STAGE = currentStage - 1 or clamp:STAGE = currentstage - 2) {
      set launchClampError to true.
    }
    if clamp:STAGE = currentStage - 2 {
      set twoStageLiftoff to true.
    }
  }

  //abort the function and print an error if the launch clamps were found
  //to be in a stage other than the last, or second to last stage in the stack
  if defined launchClampError and launchClampError = true {
    core:DOEVENT("open terminal").
    print "ERROR: Smart staging function failed! Launch clamps interfered!".
    return.
  }

  //do a two-stage liftoff if needed
  if defined twoStageLiftoff and twoStageLiftoff = true {
    lock steering to up.
    lock throttle to 1.
    doSafeStage().
    wait 1.
    doSafeStage().
    print "Performed a 2 step liftoff".
  } else {
    lock steering to up.
    lock throttle to 1.
    doSafeStage().
    print "Performed a 1 step liftoff".
  }
}

function doStageCheckAndExecute {
  if stageSpent() = true {
    doSmartStage().
    return true.
  } else return false.
}
