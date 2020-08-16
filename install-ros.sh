echo "Installing ROS..."

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update
sudo apt install ros-melodic-desktop-full
sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
sudo apt-get install python-catkin-tools
cd ~
mkdir catkin_ws && cd catkin_ws
mkdir src
catkin init
cd src
echo ". /opt/ros/melodic/setup.bash" >> ~/.bashrc
echo "alias ll=\"ls\"" >> ~/.bashrc
echo "alias ci=\"catkin build\"" >> ~/.bashrc
echo "alias cd..=\"cd ..\"" >> ~/.bashrc
echo "alias st=\"git status\"" >> ~/.bashrc
echo "alias diff..=\"git diff\"" >> ~/.bashrc
echo "alias add=\"git add .\"" >> ~/.bashrc
echo "alias commit=\"git commit\"" >> ~/.bashrc
echo "alias push=\"git push\"" >> ~/.bashrc

catkin build

function install_carto {

  # Installing carto - go grab a coffee :)

  sudo apt-get update
  sudo apt-get install -y python-wstool python-rosdep ninja-build
  cd ~/catkin_ws
  wstool init src
  wstool merge -t src https://raw.githubusercontent.com/googlecartographer/cartographer_ros/master/cartographer_ros.rosinstall
  wstool update -t src
  src/cartographer/scripts/install_proto3.sh
  sudo rosdep init
  rosdep update
  rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y
  catkin build

  sudo apt-get install ros-melodic-teleop-twist-keyboard
  sudo apt-get install ros-melodic-map-server
}
while true; do
    read -p "Do you wish to install cartographer?" yn
    case $yn in
        [Yy]* ) install_carto; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
