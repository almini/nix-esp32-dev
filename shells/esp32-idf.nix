{ pkgs
, idfVersion ? "5.0"
, pythonVersionMajor ? "3"
, pythonVersionMinor ? "8"
}:

let 
  pythonVersion = "${pythonVersionMajor}.${pythonVersionMinor}";

  pythonPackages = pkgs."python${pythonVersionMajor}${pythonVersionMinor}Packages";
  espressifDir = "./.espressif";
  venvDir = "${espressifDir}/python_env/idf${idfVersion}_py${pythonVersion}_env";
in pkgs.mkShell {
  name = "esp-idf-env";

  buildInputs = with pkgs; [
    gcc-xtensa-esp32-elf-bin
    openocd-esp32-bin
    esp-idf-src
    esptool

    # Tools required to use ESP-IDF
    git
    wget
    gnumake

    flex
    bison
    gperf
    pkgconfig

    cmake

    ncurses5

    ninja

    # A Python interpreter including the 'venv' module is required to bootstrap
    # the environment.
    pythonPackages.python
  ];

  shellHook = ''
    export IDF_TOOLS_PATH=$(realpath $PWD/${espressifDir})

    unset _PYTHON_HOST_PLATFORM 
    unset _PYTHON_SYSCONFIGDATA_NAME 
    SOURCE_DATE_EPOCH=$(date +%s)

    if [ -d "${venvDir}" ]; then
      echo "Skipping venv creation, '${venvDir}' already exists"
      source "${venvDir}/bin/activate"
    else
      echo "Creating new venv environment in path: '${venvDir}'"
      # Note that the module venv was only introduced in python 3, so for 2.7
      # this needs to be replaced with a call to virtualenv
      ${pythonPackages.python.interpreter} -m venv "${venvDir}"
      source "${venvDir}/bin/activate"
      # Installs the required python packages.
      $IDF_PATH/tools/idf_tools.py install-python-env
    fi

    # Under some circumstances it might be necessary to add your virtual
    # environment to PYTHONPATH, which you can do here too;
    # PYTHONPATH=$PWD/${venvDir}/${pythonPackages.python.sitePackages}/:$PYTHONPATH
  '';
}