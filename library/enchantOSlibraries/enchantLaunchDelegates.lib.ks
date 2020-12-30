//enchantLaunchDelegates.lib.ks

function initLaunchDefaults {
  set launchDefaults to lexicon(
  "defApoapsis", "85000",
  "defaultHeading", "Equatorial",
  "defaultGLoad", "3"
  ).
}

function initHeadingOptions {
  set headingOptions to lexicon(
    "Equatorial", 90,
    "Minmus-North", 83.67,
    "Minmus-South", 96.33,
    "Polar-South", 183,
    "Polar-North", 358,
    "Retrograde", 270
  ).
}

function apoapsisUp {
  set currentScalar to apoapsisField:TEXT:TONUMBER(0).
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
  set currentScalar to apoapsisField:TEXT:TONUMBER(0).
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
  set chosenApoapsisScalar to chosenApoapsisString:TONUMBER(0).
  if chosenApoapsisScalar < 71500 {
    userAlert("That value is too low. Launch only works to above").
    userAlert("the karman line").
    set refreshedApoapsis to 71500.
  } else if chosenApoapsisScalar > 84155000 {
    userAlert("That value is too high. Launch only works to").
    userAlert("altitudes below the Kerbin sphere of influence.").
    set refreshedApoapsis to 84155000.
  } else {
    set moduloOfApoapsis to mod(chosenApoapsisScalar, 500).
    set refreshedApoapsis to round(chosenApoapsisScalar - moduloOfApoapsis).
  }
  set apoapsisField:TEXT to refreshedApoapsis:TOSTRING.
  targetApoapsisSet().
}

function targetApoapsisSet {
  set targetApoapsis to apoapsisField:TEXT:TONUMBER(0).
  set apoapsisTargetSet:STYLE:TEXTCOLOR to GREEN.
  // print "targetApoapsisSet".
  // print targetApoapsis.
}

function headingChosen {
  parameter choice.
  set headingTargetSet:STYLE:TEXTCOLOR to GREEN.
}

function targetHeadingSet {
  set targetHeading to headingOptions[headingDropdown:TEXT].
}

function gLimitUp {
  set gLimitScalar to gLimitField:TEXT:TONUMBER(0).
  if gLimitScalar = 10 {
    userAlert("Good luck making your launch pull more than 10 g!").
  } else {
    set gLimitRefreshed to gLimitScalar + 0.25.
    set gLimitField:TEXT to gLimitRefreshed:TOSTRING.
  }
}

function gLimitDown {
  set gLimitScalar to gLimitField:TEXT:TONUMBER(0).
  if gLimitScalar = 1.25 {
    userAlert("Ascending with a lower G Load limit will be too").
    userAlert("difficult. 1.25 is the minimum, sorry!").
  } else {
    set gLimitRefreshed to gLimitScalar - 0.25.
    set gLimitField:TEXT to gLimitRefreshed:TOSTRING.
  }
}

function gLimitSetClicked {
  set gLimitSet:STYLE:TEXTCOLOR to GREEN.
}

function launchParametersReset {
  set originalTextColor to RGBA(0.8295634, 0.9583512, 0.9925373, 1).
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
    set myAlertString to "This automation option is for launching only. It".
    set myAlertString to myAlertString + " will not run again after liftoff".
    set myAlertString to myAlertString + " has occured.".
    userAlert(myAlertString).
  }
}

function updateStaticReadouts {
  //update the target apoapsis readout to reflect what was chosen prelaunch
  set trgtApReadout:TEXT to "Target Apoapsis: " + apoapsisField:TEXT.
  set backspacingList to list("1stBackspace","2ndBackspace").
  for backspace in backspacingList {
    if backspace = "1stBackspace" {
      set stringLength to trgtApReadout:TEXT:LENGTH.
      set trgtApReadout:TEXT to trgtApReadout:TEXT:REMOVE(stringLength - 2, 2).
    } else {
      set stringLen to trgtApReadout:TEXT:LENGTH.
      if trgtApReadout:TEXT:ENDSWITH("5") {
        set trgtApReadout:TEXT to trgtApReadout:TEXT:INSERT(stringLen - 1,".").
      } else {
        set trgtApReadout:TEXT to trgtApReadout:TEXT:REMOVE(stringLen -1, 1).
      }
    }
  }
  set trgtApReadout:TEXT to trgtApReadout:TEXT + " km".

  //update the launch heading readout to reflect what was chosen prelaunch
  set headingNumber to targetHeading. //headingOptions[headingDropdown:TEXT].
  set trgtHdingReadout:TEXT to "Launch Heading: " + headingNumber + " deg".
}

function updateDynamicReadouts {
  //update the target pitch to reflect where the ship wants to pitch to at
  //the current altitude.
  set trgtPitchReadout:TEXT to "Target Pitch: " + getTargetPitch().
  set currentGsReadout:TEXT to "Current G-Force: " + getGLoad().
  if ship:STATUS = "PRELAUNCH" {
    set statusReadout:TEXT to "Standing by to Launch...".
  }
}

function doLaunchTasks {
  updateDynamicReadouts().
  if ship:STATUS = "PRELAUNCH" {
    doSmartLiftoff().
    wait 1.
  }
  if ship:APOAPSIS >= targetApoapsis {
    set ascentCompleted to true.
    set launchUnderway to false.
  }
  if ship:STATUS = "FLYING" or ship:STATUS = "SUB_ORBITAL" {
    // print "Flying or suborbital condition entered".
    lock throttle to getThrottleValue().
    set targetPitch to getTargetPitch().
    lock steering to heading(targetHeading, targetPitch).
    doStageCheckAndExecute().
  } else {
    print " ".
    print "An error occured. Liftoff probably failed".
    set launchUnderway to false.
  }
}

function doReleaseTasks {
  if not(defined beenOverridden) {
    set PILOTMAINTHROTTLE to getThrottleValue().
  }
  unlock throttle.
  unlock steering.
}

function presentAbortWarningUI {
  set abortWarningGUI to gui(400, 50).
  set abortWarningPrompt to abortWarningGUI:ADDLABEL("Are you sure?").
  set abortWarningPrompt:STYLE:ALIGN to "CENTER".
  set abortWarningPrompt:STYLE:FONTSIZE to 45.
  set abortWarningPrompt:STYLE:TEXTCOLOR to YELLOW.
  set abortDisabiguation to "This will release all controls over to manual".
  set abortDisabiguation2 to " control, and leave the throttle where it is.".
  set abortDisabiguationFinal to abortDisabiguation + abortDisabiguation2.
  set abortWarningPrompt2 to abortWarningGUI:ADDLABEL(abortDisabiguationFinal).
  set choiceLayout to abortWarningGUI:ADDHLAYOUT().
  set yesButton to choiceLayout:ADDBUTTON("YES").
  set yesButton:STYLE:HEIGHT to 50.
  set yesButton:ONCLICK to yesClicked@.
  set noButton to choiceLayout:ADDBUTTON("NO").
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
  set fullLaunchWidgetList to launchBox:WIDGETS.
  set numberOfLaunchWidgets to launchBox:WIDGETS:LENGTH.
  set listToHide to fullLaunchWidgetList:SUBLIST(9, numberOfLaunchWidgets - 9).
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
  set fullLaunchWidgetList to launchBox:WIDGETS.
  set listToHide to fullLaunchWidgetList:SUBLIST(0,9).
  for widgetToHide in listToHide {
    widgetToHide:HIDE.
  }
  for widgetToShow in fullLaunchWidgetList {
    if not(listToHide:CONTAINS(widgetToShow)) {
      widgetToShow:SHOW.
    }
  }
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
  if not(defined beenOverridden) {
    set beenOverridden to true.
    set SHIP:CONTROL:PILOTMAINTHROTTLE to getThrottleValue(). 
  }
  unlock throttle.
}

