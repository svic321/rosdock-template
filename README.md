# README



After cloning a sample ros2 repo, the steps to follow are (while in the ros ws dir):

```
rosbuild update
rosdep install -i --from-path src --rosdistro rolling -y
source /opt/ros/...
colcon build
colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
source install/local_setup.zsh
```


For the intelisense check in the file `.vscode/settings.json` for the line:

```
    "C_Cpp.default.compilerPath": "/usr/bin/g++",
    "C_Cpp.default.compileCommands": "/home/ws/build/turtlesim/compile_commands.json"
```

Visit the link:
https://docs.ros.org/en/rolling/ROS-Framework/client-libraries/Working-with-Client-Libraries/Creating-A-Workspace/Creating-A-Workspace.html
to follow the tut