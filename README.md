DTNavigationController with DTFolderBar
==========================
![Linux-file-browser](https://raw.github.com/Darktt/DTNavigationController/master/Raw/Image/Linux-file-browser.png)<br/>
Like Linux file browser folder navigation view.

##Installation##
Drag the <code>DTNavigationController</code> folder into your project.

##Usage##
Import the header file and declare your controlle.

	#import "DTNavigationController.h"

As usual UINavigationController.
``` objective-c
DTNavigationController *navigation = [DTNavigationController navigationWithRootViewController:yourViewController];
```

You can set a folderBar style like this.
``` objective-c
DTNavigationController *navigation = [DTNavigationController navigationWithRootViewController:yourViewController folderStyle:DTFolderBarStyleNormal];
```

Reuse DTNavigationController in pushed viewController
``` objective-c
DTNavigationController *navigation = (DTNavigationController *)self.navigationController;
```

To set folder hidden
``` objective-c
[navigation setFolderBarHidden:YES animated:YES];

// check folder is hidden
[navigation isFolderBarHidden];
```

Set action on actionButton at DTFolderBarStyleActionButton & DTFolderBarStyleFixedHomeAndAtionButton style
``` objective-c
[navigation.folderBar.actionButton addTarget:yourViewController action:@selector(puth:) forControlEvents:UIControlEventTouchUpInside];
```