# Build Scripts 
I had a full time job fixing an automated system. It sounds like a joke, but no. In my mind, the system I inherited looks like this:
![old system](http://weburbanist.com/wp-content/uploads/2009/10/car-hood-trailer-on-motorcycle.jpg)  
- Everything was delicate. 
- The front end of development looked nothing like the back end. 
- Even though the controls were all together, it was quite difficult to control.
- Too much complexity for the task.  

My company transitioned from Team Foundation Server 2012 to Visual Studio Team Services \(continuously deployed cloud service\). The build systems are incompatable, so I had to start from scratch. These two scripts are my work to revamp and improve the build system. Both documents are out of my head + a lot of searching stack overflow. I replaced the name of the company with *Some Software Company* \(*SSC*\).  
The central idea of overhauling the build system :
> Make the server builds work the same way as the developer's desktop builds.  

## Key ways these scripts accomplish that goal
- **Control *nearly* all variables in source control** Previously, build configurations lived in a database and needed a lot of love. Now, everything but the version number is stored in files in source control. They happen to be the same files that drive local builds on a dev box. This was a huge cutback in build script responsibility. 
- **Script changes to config files before building**. No variables \(like version number\) come from the ether to get injected to a command line argument. The build configuration changes in files before it builds. These changes the same result as a developer a doing so on their IDE.
- **Use relative file paths**. Anything placed into the file system of the build agent mimics exactly the same file structure as the dev boxes and source control. No need for weird remapping. 
  
I think the present result resembles this:
![new system](https://s-media-cache-ak0.pinimg.com/236x/cd/e8/60/cde8604640f541b4724259511f44a34d.jpg)
- Strength in best practices.
- Dev and CI workflows have unity.
- Control is more intuitive.
- Performance increased after cutting the dead weight.

## But Patick, this isn't BASh
One is a PowerShell Script the other is a module. Unfortunately I don't have BASh scripts laying around. My time as a student and IT professoinal was spent working with Windows systems.  
> To be clear: I don't want to drink the cool-aid any more. "All \*nix, all the time" is what I want.

There are some aspects of these scripts that are what you seek in this exercise. \(I think\).  
### Documentation
I want my successors to have a good handle of the process so the future is a little less risky. The format is parsed by Powershell and consumed by the Get-Help cmdlet. 
> Patrick, this uh... uh well... you documented it. We're not quite sure what to do with that.  
  
### Clean Code
I'm not an expert at this yet, but I'm trying to write the code so that it needs no explanation to those with a grasp of the language. Main ideas:
- Another developer can read it and understand it. Commenting should be unnecessary.
- Methods and functions should do one thing. While looking at the documentation blurbs for these scripts, notice most of the synopsis blocks don't require the word "and". I certainly need to make some improvement, though.
- Variables, functions, objects, etc should have descriptive names. Obfuscation and minification are useful for saving bandwidth, but I want my colleagues to know what they're reading when they see it.
- Nothing needless remains. If the code isn't used, I delete it. Source control makes it easy to delete because I can roll back if it becomes useful again.  

### It's a useful script
I may need to refresh my BASh language familiarity, but the concepts of writing and maintaining scripts are in my repertoire now. I know how to write loops, test boolean statements, use data types, etc. I hope you can look past the language to see underlying concepts.