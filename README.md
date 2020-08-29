# Locksmith

This plugin performs a threat analysis on all game scripts to locate potential security flaws and backdoors. A report will be generated that may be utilized by the user to review specific lines of code that may help lead to such threats. This tool does not perform any automatic code changes on behalf of the user, nor do the reports indicate that findings are indeed backdoors. The tool simply provides a more streamlined process of reviewing game scripts for security threats. The final determination on whether the findings are a security flaw or not is for the user to decide.

# How to contribute

You can contribute by optimizing or fixing bugs!
The part that needs most contributing is the `isBackdoor.lua` module, which returns a probability of being a backdoor, when given a script.
