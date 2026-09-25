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

More instructions:
```
# ...existing code...

## Setup after cloning (or in a new dev container)

1. Source the ROS distro:
    ```bash
    source /opt/ros/rolling/setup.zsh
    ```

2. Update rosdep's local package index (only needed once, or when rosdep sources change):
    ```bash
    rosdep update
    ```

3. Install package dependencies declared in `package.xml`:
    ```bash
    rosdep install -i --from-path src --rosdistro rolling -y
    ```

4. Build the workspace (symlink install lets you edit Python files without rebuilding, and works fine alongside C++ packages):
    ```bash
    colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ```

5. Source the freshly built workspace overlay:
    ```bash
    source install/local_setup.zsh
    ```

# ...existing code...
```