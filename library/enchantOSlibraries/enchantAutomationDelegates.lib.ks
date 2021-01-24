//enchantAutomationDelegates.lib.ks
//this will hold the delegates that are called when enchantOS internal
//automation buttons are pressed

//include the needed library scripts
runoncepath("1:/library/guiTools.lib.ks").

function enchantMnvLock {
  parameter buttonCalledFrom.
  set consoleGUI:WIDGETS[1]:WIDGETS[1]:ENABLED to false.
  set consoleGUI:WIDGETS[1]:WIDGETS[2]:ENABLED to false.
  set consoleGUI:WIDGETS[2]:WIDGETS[1]:ENABLED to false.
  set consoleGUI:WIDGETS[2]:WIDGETS[2]:ENABLED to false.
  set consoleGUI:WIDGETS[3]:WIDGETS[1]:ENABLED to false.
  set consoleGUI:WIDGETS[3]:WIDGETS[2]:ENABLED to false.
  set consoleGUI:WIDGETS[4]:WIDGETS[2]:ENABLED to false.
  switchStackTo(//from guiTools.lib.ks
    consoleGUI:
    WIDGETS[5]:
    WIDGETS[1]:
    WIDGETS[1]
  ).
}

function enchantLaunch {
  parameter buttonCalledFrom.
  set consoleGUI:WIDGETS[1]:WIDGETS[1]:ENABLED to false.
  set consoleGUI:WIDGETS[1]:WIDGETS[2]:ENABLED to false.
  set consoleGUI:WIDGETS[2]:WIDGETS[1]:ENABLED to false.
  set consoleGUI:WIDGETS[2]:WIDGETS[2]:ENABLED to false.
  set consoleGUI:WIDGETS[3]:WIDGETS[1]:ENABLED to false.
  set consoleGUI:WIDGETS[3]:WIDGETS[2]:ENABLED to false.
  set consoleGUI:WIDGETS[4]:WIDGETS[2]:ENABLED to false.
  switchStackTo(//from guiTools.lib.ks
    consoleGUI:
    WIDGETS[5]:
    WIDGETS[1]:
    WIDGETS[2]
  ).
}

function enchantHoverslam {
  parameter buttonCalledFrom.
  set consoleGUI:WIDGETS[1]:WIDGETS[1]:ENABLED to false.
  set consoleGUI:WIDGETS[1]:WIDGETS[2]:ENABLED to false.
  set consoleGUI:WIDGETS[2]:WIDGETS[1]:ENABLED to false.
  set consoleGUI:WIDGETS[2]:WIDGETS[2]:ENABLED to false.
  set consoleGUI:WIDGETS[3]:WIDGETS[1]:ENABLED to false.
  set consoleGUI:WIDGETS[3]:WIDGETS[2]:ENABLED to false.
  set consoleGUI:WIDGETS[4]:WIDGETS[2]:ENABLED to false.
  switchStackTo(//from guiTools.lib.ks
    consoleGUI:
    WIDGETS[5]:
    WIDGETS[1]:
    WIDGETS[3]
  ).
}
