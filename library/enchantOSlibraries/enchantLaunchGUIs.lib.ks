//enchantLaunchGUIs.lib.ks
//this will hold the functions which draw guis in the Launch automation
//stack box inside EnchantOS

function createApoapsisSelectWidgets {
  local promptApoapsis is launchBox:ADDLABEL("Apoapsis of Ascent:").
  local apoapsisLayout is launchBox:ADDHLAYOUT().
  global apoapsisField is apoapsisLayout:ADDTEXTFIELD(launchDefaults:defApoapsis).
  set apoapsisField:STYLE:WIDTH to 69.
  set apoapsisField:ONCONFIRM to apoapsisConfirmed@.
  local apoapsisUpInc is apoapsisLayout:ADDBUTTON("/\").
  set apoapsisUpInc:STYLE:WIDTH to 25.
  set apoapsisUpInc:ONCLICK to apoapsisUp@.
  local apoapsisDownInc is apoapsisLayout:ADDBUTTON("\/").
  set apoapsisDownInc:STYLE:WIDTH to 25.
  set apoapsisDownInc:ONCLICK to apoapsisDown@.
  global apoapsisTargetSet is apoapsisLayout:ADDBUTTON("Set").
  set apoapsisTargetSet:STYLE:WIDTH to 45.
  set apoapsisTargetSet:ONCLICK to targetApoapsisSet@.
}

function createAscentHeadingSelectWidgets {
  local promptHeading is launchBox:ADDLABEL("Ascent Heading:").
  local headingLayout is launchBox:ADDHLAYOUT().
  global headingDropdown is headingLayout:ADDPOPUPMENU().
  set headingDropdown:TEXT to launchDefaults:defaultHeading.
  set headingDropdown:OPTIONS to headingOptions:KEYS.
  set headingDropdown:ONCHANGE to headingChosen@.
  global headingTargetSet is headingLayout:ADDBUTTON("Set").
  set headingTargetSet:STYLE:WIDTH to 45.
  set headingTargetSet:ONCLICK to targetHeadingSet@.
}

function createGLoadLimitSelectWidgets {
  local promptGLoad is launchBox:ADDLABEL("G-Load limit:").
  local gLimitLayout is launchBox:ADDHLAYOUT().
  global gLimitField is gLimitLayout:ADDLABEL(launchDefaults:defaultGLoad).
  set gLimitField:STYLE:TEXTCOLOR to RGBA(0.9921569, 0.8117647, 0, 1).
  set gLimitField:STYLE:FONTSIZE to 18.
  set gLimitField:STYLE:ALIGN to "CENTER".
  local gLimitUpInc is gLimitLayout:ADDBUTTON("/\").
  set gLimitUpInc:STYLE:WIDTH to 25.
  set gLimitUpInc:ONCLICK to gLimitUp@.
  local gLimitDownInc is gLimitLayout:ADDBUTTON("\/").
  set gLimitDownInc:STYLE:WIDTH to 25.
  set gLimitDownInc:ONCLICK to gLimitDown@.
  global gLimitSet is gLimitLayout:ADDBUTTON("Set").
  set gLimitSet:STYLE:WIDTH to 45.
  set gLimitSet:ONCLICK to gLimitSetClicked@.
}

function createResetConfirmCloseButtons {
  local resetLaunchParameters is launchBox:ADDBUTTON("Reset All").
  set resetLaunchParameters:ONCLICK to launchParametersReset@.
  local confirmAndLaunchButton is launchBox:ADDBUTTON("Confirm and Launch").
  set confirmAndLaunchButton:STYLE:VSTRETCH to true.
  set confirmAndLaunchButton:STYLE:FONTSIZE to 17.
  set confirmAndLaunchButton:ONCLICK to confirmAndLaunchClicked@.
  local closeLaunchAutomation is launchBox:ADDBUTTON("Close").
  set closeLaunchAutomation:ONCLICK to closeAutomationClicked@.
}

function createPostLiftoffReadouts {
  global trgtApReadout is launchBox:ADDLABEL("Target Apoapsis: ~").
  set trgtApReadout:TEXT to trgtApReadout:TEXT + launchDefaults:defApoapsis.
  set trgtApReadout:TEXT to trgtApReadout:TEXT:REMOVE(20,3).
  set trgtApReadout:TEXT to trgtApReadout:TEXT + " km".
  global trgtHdingReadout is launchBox:ADDLABEL("Launch Heading: ").
  local defHeadingString is headingOptions:Equatorial:TOSTRING.
  set trgtHdingReadout:TEXT to trgtHdingReadout:TEXT + defHeadingString.
  set trgtHdingReadout:TEXT to trgtHdingReadout:TEXT + " deg".
  global trgtPitchReadout is launchBox:ADDLABEL("Target Pitch: 90 deg").
  global currentGsReadout is launchBox:ADDLABEL("Current G-Force: ").
  global statusReadout is launchBox:ADDLABEL("Standing by to Launch...").
  set statusReadout:STYLE:TEXTCOLOR to YELLOW.
}

function createPostLiftoffButtons {
  local editorRevert is launchBox:ADDBUTTON("Revert to Editor").
  set editorRevert:ONCLICK to revertToEditorClicked@.
  local launchRevert is launchBox:ADDBUTTON("Revert to Launch").
  set launchRevert:ONCLICK to revertToLaunchClicked@.
  local throttOverride is launchBox:ADDBUTTON("Override Throttle").
  set throttOverride:ONCLICK to throttleOverrideClicked@.
  local launchAbortButton is launchBox:ADDBUTTON("Abort Launch").
  set launchAbortButton:STYLE:TEXTCOLOR to RGBA(1, 0, 0, 0.6).
  set launchAbortButton:STYLE:FONTSIZE to 30.
  set launchAbortButton:STYLE:WORDWRAP to true.
  set launchAbortButton:STYLE:HEIGHT to 80.
  set launchAbortButton:ONCLICK to abortLaunch@.
}
