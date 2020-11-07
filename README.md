# TOAST

Hey there!

I'm Rakesha

So we made a plugin for toast messages and here are some of the interesting things it does.

 -	Templates for normal, banner, action and progress indicator toasts. (All easily tweak-able.)
 
 -	Swipe to dismiss (comes with customizable threshold for swipe)
 
 -	Timed and untimed toasts. (Timed toasts dismiss themselves after the duration)
 
 -	Countdown timer which you can use for other things as well. (Go through the documentation to get a better idea. They are really small and well documented.)
 
 - 	Pretty much everything in the toast is easily modifiable without much effort. :D


The files are all well documented. You'll prolly get it if you just go through the comments. But still for the lazy asses here you go :P

Ok so'll i'll walk you through on how to use this ~~bad boy~~... toast ! :s

- Creating a default toast

    -	Use the class function 'getToast' from the class ToastProfiles.swift to get the instance of the toast. (Read the comments on the function to get a clearer idea of what the parameters are for. They are self-explanatory tbh. :/ )
			
			let toast = ToastProfiles.getToast(titleStrings: ["<Title>"], type: .normal, view: view, target: nil, selector: nil)


- Creating custom toast

    -	If you want minute changes to the default toast, just make them in the respective 'designConfig' or 'animationConfig' variables after you create a default toast. eg: You want the toast label to have a different color. All you need to do is change, before you call 'showToast'  method.
			
			let toast = ToastProfiles.getToast(titleStrings: ["Title"], type: .normal, view: view, target: nil, selector: nil)
        			 toast.designConfig.labelTextColor = .black // Desired color
        			 toast.showToast()

    -	However if you want a completely custom toast. Create the 'animationConfig' and 'designConfig' separately and call the custom initializer in ToastView.
			
			let designConfig = ToastDesignConfig()
        			 // Set the variables to what you need. Check 'ToastDesignConfig.swift to find the possible customisations you can make
        			 designConfig.backgroundColor = .white
        			 .
        			 .
        			 .
        
        			 let animationConfig = ToastAnimationConfig()
        			 // Set the variables to what you need. Check ToastAnimationConfig.swift to find the possible customisations you can make
        			 animationConfig.entryDirection = .center
        			 .
        			 .
        			 .
        
        			 let toast = ToastView(view: nil, type: .custom, animationConfig: animationConfig, designConfig: designConfig)
        			 toast.showToast()


Finally, i'll tell you how to use it as a pod.

- Open terminal

- Go to the parent folder (By parent folder i mean the folder that holds the .xcodeproj file)

- Run 'pod init'. (This creates a pod file inside the parent folder)

- Add "source 'https://github.com/rakeshashastri/Toast.git' to the beginning of the file.

- Add "pod 'Toast'" inside the target. (There will be a comment which states where you have to add this line)

Note: Make sure you have use_frameworks! in your podfile for this pod to work.


Yep that's all you need to get this toast to work. Good luck. :D

Shout out to my team, Thapa and Rahul for all their help and support. :D
