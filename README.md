# Astronomy Picture of the day

Notes: This is a simple application representing APOD (Astronomy Picture of the Day) released by NASA. 
Contains:
a) Two way data binding (MVVM architecture)
b) ViewModels
c) NSCaching
d) Custom Observer class 
e) No 3rd Party libraries used

Instructions to run the app
a) Download the zipped code 
b) Open xcodeproject file with XCode
c) And run it with the any desired simulator

Improvement Areas
a) Observable - Single data observer class is used, which can be further improvised to have a list of observers in the Observable class
b) Caching - For caching NSCache is used, which does't work after app kill and relaunch. User defaults can be used instead for the current data.
c) Unit testing has to be written first before starting the implementation to follow Usecase driven development

Hope it's useful!

