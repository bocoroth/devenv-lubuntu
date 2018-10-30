sudo apt install qt5-qmake qtcreator qtchooser libqt5websockets5-dev libqt5svg5-dev
hub clone traxtech/subtivals
cd subtivals/src
qmake -qt=qt5
make
cd ~
ln subtivals/src/subtivals supertitles
