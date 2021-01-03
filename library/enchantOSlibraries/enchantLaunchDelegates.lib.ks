//enchantLaunchDelegates.lib.ks

function initLaunchDefaults {
  global launchDefaults is lexicon(
  "defApoapsis", "85000",
  "defaultHeading", "Equatorial",
  "defaultGLoad", "3"
  ).
}

function initHeadingOptions {
  global headingOptions is lexicon(
    "Equatorial", 90,
    "Minmus-North", 83.67,
    "Minmus-South", 96.33,
    "Polar-South", 183,
    "Polar-North", 358,
    "Retrograde", 270
  ).
}

function apoapsisUp {
  local currentScalar is apoapsisField:TEXT:TONUMBER(0).
  local incrementedApoapsis is currentScalar.
  if currentScalar <= 75000 {
    set incrementedApoapsis to round(currentScalar) + 500.
  } else if currentScalar >= 84155000 {
    set incrementedApoapsis to 84155000.
    userAlert("Can't increment you out of the kerbin").
    userAlert("sphere of influence. It's too high").
  } else {
    set incrementedApoapsis to round(currentScalar) + 5000.
  }
  // print incrementedApoapsis:TYPENAME.
  // print incrementedApoapsis.
  // print " ".
  set apoapsisField:TEXT to incrementedApoapsis:TOSTRING.
}

function apoapsisDown {
  local currentScalar is apoapsisField:TEXT:TONUMBER(0).
  local decrementedApoapsis is currentScalar.
  if currentScalar <= 71500 {
    set decrementedApoapsis to 71500.
    userAlert("Launch will fail if ascent doesn't pass the karman").
    userAlert("line. 71.5 km is the minimum, sorry!").
  } else if currentScalar > 71500 and currentScalar <= 75000 {
    set decrementedApoapsis to round(currentScalar) - 500.
  } else {
    set decrementedApoapsis to apoapsisField:TEXT:TONUMBER(0) - 5000.
  }
  // print decrementedApoapsis:TYPENAME.
  // print decrementedApoapsis.
  // print " ".
  set apoapsisField:TEXT to decrementedApoapsis:TOSTRING.
}

function apoapsisConfirmed {
  parameter chosenApoapsisString.
  local chosenApoapsisScalar is chosenApoapsisString:TONUMBER(0).
  local refreshedApoapsis is chosenApoapsisScalar.
  if chosenApoapsisScalar < 71500 {
    userAlert("That value is too low. Launch only works to above").
    userAlert("the karman line").
    set refreshedApoapsis to 71500.
  } else if chosenApoapsisScalar > 84155000 {
    userAlert("That value is too high. Launch only works to").
    userAlert("altitudes below the Kerbin sphere of influence.").
    set refreshedApoapsis to 84155000.
  } else {
    local moduloOfApoapsis is mod(chosenApoapsisScalar, 500).
    set refreshedApoapsis to round(chosenApoapsisScalar - moduloOfApoapsis).
  }
  set apoapsisField:TEXT to refreshedApoapsis:TOSTRING.
  targetApoapsisSet().
}

function targetApoapsisSet {
  global targetApoapsis is apoapsisField:TEXT:TONUMBER(0).
  set apoapsisTargetSet:STYLE:TEXTCOLOR to GREEN.
  // print "targetApoapsisSet".
  // print targetApoapsis.
}

function headingChosen {
  parameter choice.
  set headingTargetSet:STYLE:TEXTCOLOR to GREEN.
}

function targetHeadingSet {
  global targetHeading is headingOptions[headingDropdown:TEXT].
}

function gLimitUp {
  locaL gLimitScalar is gLimitField:TEXT:TONUMBER(0).
  if gLimitScalar = 10 {
    userAlert("Good luck making your launch pull more than 10 g!").
  } else {
    local gLimitRefreshed is gLimitScalar + 0.25.
    set gLimitField:TEXT to gLimitRefreshed:TOSTRING.
  }
}

function gLimitDown {
  local gLimitScalar is gLimitField:TEXT:TONUMBER(0).
  if gLimitScalar = 1.25 {
    userAlert("Ascending with a lower G Load limit will be too").
    userAlert("difficult. 1.25 is the minimum, sorry!").
  } else {
    local gLimitRefreshed is gLimitScalar - 0.25.
    set gLimitField:TEXT to gLimitRefreshed:TOSTRING.
  }
}

function gLimitSetClicked {
  set gLimitSet:STYLE:TEXTCOLOR to GREEN.
}

function launchParametersReset {
  local originalTextColor is RGBA(0.8295634, 0.9583512, 0.9925373, 1).
  set apoapsisTargetSet:STYLE:TEXTCOLOR to originalTextColor.
  set headingTargetSet:STYLE:TEXTCOLOR to originalTextColor.
  set gLimitSet:STYLE:TEXTCOLOR to originalTextColor.
  set apoapsisField:TEXT to launchDefaults:defApoapsis.
  set headingDropdown:TEXT to launchDefaults:defaultHeading.
  set gLimitField:TEXT to launchDefaults:defaultGLoad.
}

function abortLaunch {
  presentAbortWarningUI().
}

function confirmAndLaunchClicked {
  if ship:STATUS = "PRELAUNCH" or launchAbortedDuringSession {
    switchToPostLiftoff().
    targetApoapsisSet().
    targetHeadingSet().
    updateStaticReadouts().
    set ascentCompleted to false.
    set launchUnderway to true.
  } else {
    local myAlertString is "This automation option is for launching only. It".
    local myAlertString is myAlertString + " will not run again after liftoff".
    local myAlertString is myAlertString + " has occured.".
    userAlert(myAlertString).
  }
}

function updateStaticReadouts {
  //update the target apoapsis readout to reflect what was chosen prelaunch
  set trgtApReadout:TEXT to "Target Apoapsis: " + apoapsisField:TEXT.
  local backspacingList is list("1stBackspace","2ndBackspace").
  for backspace in backspacingList {
    if backspace = "1stBackspace" {
      set stringLength to trgtApReadout:TEXT:LENGTH.
      set trgtApReadout:TEXT to trgtApReadout:TEXT:REMOVE(stringLength - 2, 2).
    } else {
      local stringLen is trgtApReadout:TEXT:LENGTH.
      if trgtApReadout:TEXT:ENDSWITH("5") {
        set trgtApReadout:TEXT to trgtApReadout:TEXT:INSERT(stringLen - 1,".").
      } else {
        set trgtApReadout:TEXT to trgtApReadout:TEXT:REMOVE(stringLen -1, 1).
      }
    }
  }
  set trgtApReadout:TEXT to trgtApReadout:TEXT + " km".

  //update the launch heading readout to reflect what was chosen prelaunch
  set trgtHdingReadout:TEXT to "Launch Heading: " + targetHeading + " deg".
}

function updateDynamicReadouts {
  //update the target pitch to reflect where the ship wants to pitch to at
  //the current altitude.
  set trgtPitchReadout:TEXT to "Target Pitch: " + getTargetPitch() + " deg".
  set currentGsReadout:TEXT to "Current G-Force: " + getGLoad().
  if ship:STATUS = "PRELAUNCH" {
    set statusReadout:TEXT to "Standing by to Launch...".
  } else if defined stageTime and time:SECONDS <= stageTime + 5 {
    return.
  } else if ship:STATUS = "FLYING" and time:SECONDS >= liftoffTime + 3 {
    set statusReadout:TEXT to "Burning stage number " + stage:NUMBER.
  }
}

function doLaunchTasks {
  updateDynamicReadouts().
  if ship:STATUS = "PRELAUNCH" {
    set statusReadout:TEXT to "Ignition and...".
    global liftoffTime is time:SECONDS.
    doSmartLiftoff().
    set statusReadout:TEXT to "Liftoff!...".
    wait 1.
  }
  if ship:APOAPSIS >= targetApoapsis {
    launchAbortButton:HIDE.
    launchConcludeButton:SHOW.
    set ascentCompleted to true.
    set launchUnderway to false.
    set statusReadout:TEXT to "Ascent Complete!...".
  }
  if ship:STATUS = "FLYING" or ship:STATUS = "SUB_ORBITAL" {
    // print "Flying or suborbital condition entered".
    if not(defined beenOverridden) or beenOverridden = false {
      lock throttle to getThrottleValue().
    }
    set targetPitch to getTargetPitch().
    lock steering to heading(targetHeading, targetPitch).
    for part in ship:PARTS {
      if part:NAME:CONTAINS("fairing") and part:STAGE = stage:NUMBER - 1 {
        if ship:ALTITUDE >= 70000 {
        declare global stageTime to time:SECONDS.
        set statusReadout:TEXT to "Fairing Jettisoned...".
        doSafeStage().
        print "performed a 1 step staging event".
        wait 1.
        }
      }
    }
    if stageSpent() {
      declare global stageTime to time:SECONDS.
      set statusReadout:TEXT to "Staging...".
    }
    doStageCheckAndExecute().
  } else {
    print " ".
    print "An error occured. Liftoff probably failed".
    set launchUnderway to false.
  }
}

function doReleaseTasks {
  if not(launchAbortedDuringSession) {
    set ship:CONTROL:PILOTMAINTHROTTLE to 0.
  }
  set throttOverride:ENABLED to false.
  unlock throttle.
  unlock steering.
}

function presentAbortWarningUI {
  local abortWarningGUI is gui(400, 50).
  local abortWarningPrompt is abortWarningGUI:ADDLABEL("Are you sure?").
  set abortWarningPrompt:STYLE:ALIGN to "CENTER".
  set abortWarningPrompt:STYLE:FONTSIZE to 45.
  set abortWarningPrompt:STYLE:TEXTCOLOR to YELLOW.
  local abortDisabiguation is "This will release all controls over to manual".
  local abortDisabiguation2 is " control, and leave the throttle where it is.".
  local abortDisabiguationFinal is abortDisabiguation + abortDisabiguation2.
  local abortWarningPrompt2 is abortWarningGUI:ADDLABEL(abortDisabiguationFinal).
  local choiceLayout is abortWarningGUI:ADDHLAYOUT().
  local yesButton is choiceLayout:ADDBUTTON("YES").
  set yesButton:STYLE:HEIGHT to 50.
  set yesButton:ONCLICK to yesClicked@.
  local noButton is choiceLayout:ADDBUTTON("NO").
  set noButton:STYLE:HEIGHT to 50.
  set noButton:ONCLICK to noClicked@.
  abortWarningGUI:SHOW.

  function yesClicked {
    abortWarningGUI:DISPOSE.
    set launchAbortedDuringSession to true.
    set launchUnderway to false.
    switchToPrelaunch().
  }

  function noClicked {
    abortWarningGUI:DISPOSE.
  }
}

function switchToPrelaunch {
  local fullLaunchWidgetList is launchBox:WIDGETS.
  local numLaunchWidgets is launchBox:WIDGETS:LENGTH.
  local listToHide is fullLaunchWidgetList:SUBLIST(9, numLaunchWidgets - 9).
  for widgetToHide in listToHide {
    widgetToHide:HIDE.
  }
  for widgetToShow in fullLaunchWidgetList {
    if not(listToHide:CONTAINS(widgetToShow)) {
      widgetToShow:SHOW.
    }
  }
}

function switchToPostLiftoff {
  local fullLaunchWidgetList is launchBox:WIDGETS.
  local listToHide is fullLaunchWidgetList:SUBLIST(0, 9).
  for widgetToHide in listToHide {
    widgetToHide:HIDE.
  }
  for widgetToShow in fullLaunchWidgetList {
    if not(listToHide:CONTAINS(widgetToShow)) {
      widgetToShow:SHOW.
    }
  }
  launchConcludeButton:HIDE.
}

function revertToEditorClicked {
  if KUniverse:CANREVERTTOEDITOR {
    KUniverse:REVERTTOEDITOR().
  } else {
    userAlert("Unable to revert back to editor.").
  }
}

function revertToLaunchClicked {
  if KUniverse:CANREVERTTOLAUNCH {
    KUniverse:REVERTTOLAUNCH().
  } else {
    userAlert("Unable to revert back to launch").
  }
}

function throttleOverrideClicked {
  if throttOverride:TEXT = "Override Throttle" {
    if not(defined beenOverridden) {
      declare global beenOverridden to true.
      set SHIP:CONTROL:PILOTMAINTHROTTLE to getThrottleValue(). 
    } else {
      set beenOverridden to true.
    }
    unlock throttle.
    set throttOverride:TEXT to "Return Throttle Control".
  } else {
    set beenOverridden to false.
    set throttOverride:TEXT to "Override Throttle".
  }  
}
