valac ./Src/Main.vala \
      ./Src/OptionProcessor.vala \
      ./Src/Commands/InitCommand.vala \
      ./Src/Commands/BuildCommand.vala \
      ./Src/DependencyManager.vala \
      ./Src/Project.vala \
      ./Src/ConsoleHelper.vala \
      ./Src/Global.vala \
      ./Src/Errors.vala \
      --pkg=gio-2.0 \
      --pkg=json-glib-1.0 \
      --pkg=gee-0.8 \
      -o embrace