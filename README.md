DTNavigationController with DTFolderBar
==========================
![Demo](https://raw.github.com/Darktt/DTNavigationController/master/Raw/Image/Demo.png)

Like Linux file browser folder navigation view.

![Linux-file-browser](https://raw.github.com/Darktt/DTNavigationController/master/Raw/Image/Linux-file-browser.png)

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

##License##
Licensed under the Apache License, Version 2.0 (the "License");  
you may not use this file except in compliance with the License.  
You may obtain a copy of the License at

>[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)
 
Unless required by applicable law or agreed to in writing,  
software distributed under the License is distributed on an  
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,  
either express or implied.   
See the License for the specific language governing permissions  
and limitations under the License.