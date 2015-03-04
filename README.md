# GKClock
GKClock is a beautiful clock control on iOS

##How To Get Started
Download GKClock and try out the included iPhone apps

##How To Use
###Init And Use Default Style：
```objective-c
self.clock = [[GKClock alloc] init];
self.clock.frame = self.frame;
[self.view addSubview:self.clock];
[self.clock start];
 ```
 <img src="https://raw.githubusercontent.com/HelloJacky/GKClock/master/ReadmeResources/default_style.png">
 
###Use Custom Style：
 
```objective-c
self.clock.layer.borderColor = [UIColor yellowColor].CGColor;
self.clock.minuteHandColor = [UIColor yellowColor];
self.clock.hourHandColor = [UIColor yellowColor];
self.clock.secondHandColor = [UIColor yellowColor];
self.clock.clockBorderColor = [UIColor yellowColor];
self.clock.momentAttribute = @{NSFontAttributeName : [UIFont fontWithName:@"American Typewriter" size:35],
                               NSForegroundColorAttributeName : [UIColor yellowColor]};
```

<img src="https://raw.githubusercontent.com/HelloJacky/GKClock/master/ReadmeResources/custom_style.png">

##Contact
If you have any questions comments or suggestions, send me a message to hijacky00@gmail.com. If you find a bug, or want to submit a pull request, let me know.

##License
MIT License

Copyright (c) 2015 Jacky Ma

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 
