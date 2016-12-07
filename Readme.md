# Crash Investigation - React Native vs. Google Mobile Ads

## About
This repository should represent the current setup I'm using for requesting custom native ads via the iOS Google Mobile Ads SDK (7.15.0) and presenting them via React Native (0.36.0) in order to help investigating a crucial crash introduced with the Google Mobile Ads SDK.

##### Related Google Developer Group Issue
[https://groups.google.com/forum/#!category-topic/google-admob-ads-sdk/ios/UNgqhjn8VjU](https://groups.google.com/forum/#!category-topic/google-admob-ads-sdk/ios/UNgqhjn8VjU)

### Why Goole Mobile Ads?
I'm already using the Google Mobile Ads SDK purely native in other apps and it works really well. Now we also want to show custom native ad campaigns within a React Native view.

### Why React Native?
I have a huge native iOS App where I introduced React Native one year ago as well to render dynamic content. The React Native instance is initialized after app start up with the first view controller. As we never had WTF crashes before and this one crash only appears when adding the Google Mobile Ads SDK to the project, it's obvious that there's a problem on how the two SDKs play together with the WebCore.

### App Structure
- large existing iOS Swift project
- single React Native view added one year ago
- added Google Mobile Ads Framework to request custom native ads content
- render received custom native ad content within the React Native view

### Versions
**OS**: > iOS 8, Swift 2.3

**React Native**: 0.36.0

**Google Mobile Ads**: 7.15.0


## Crash

### What's the actual crash reason?
**WTF::HashMap<WTF::String, WebCore::ApplicationCacheGroup*, WTF::StringHash, WTF::HashTraits<WTF::String>, WTF::HashTraits<WebCore::ApplicationCacheGroup*> >::remove(WTF::String const&)**

### When does it happen?
After a couple of seconds **only on first app install or app update** on a real device. Unfortunately it's not 100% reproduciable, I'm trying since days already to figure it out, but the only way I could reproduce it 2 out of 3 times was by creating a new build and deploy it on a real device, it only happened once in the Simulator.

### Full Crash Log

	Hardware Model:		iPhone8,1
	Code Type:			ARM-64
	Parent Process:		??? [1]
	
	Date/Time:			2016-11-25T11:24:09Z
	Launch Time:		2016-11-25T11:24:05Z
	OS Version:			iPhone OS 9.3.5 (13G36)
	
	Exception Type:  SIGSEGV
	Exception Codes: SEGV_ACCERR at 0x10
	Crashed Thread:  18
	
	Thread 0:
	0   libsystem_kernel.dylib               0x00000001818fcfd8 mach_msg_trap + 8
	1   CoreFoundation                       0x0000000181d34c60 __CFRunLoopServiceMachPort + 192
	2   CoreFoundation                       0x0000000181d32964 __CFRunLoopRun + 1028
	3   CoreFoundation                       0x0000000181c5cc50 CFRunLoopRunSpecific + 380
	4   GraphicsServices                     0x0000000183544088 GSEventRunModal + 176
	5   UIKit                                0x0000000186f4a088 UIApplicationMain + 200
	6   MY_APP                               0x0000000100056680 main (AppDelegate.swift:15)
	7   ???                                  0x00000001817fa8b8 0x0 + 0
	
	Thread 1:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 2:
	0   libsystem_kernel.dylib               0x00000001819194d8 kevent_qos + 8
	1   libdispatch.dylib                    0x00000001817cb648 _dispatch_mgr_thread + 48
	
	Thread 3:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 4:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 5:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 6:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 7:
	0   libsystem_kernel.dylib               0x00000001818fcfd8 mach_msg_trap + 8
	1   CoreFoundation                       0x0000000181d34c60 __CFRunLoopServiceMachPort + 192
	2   CoreFoundation                       0x0000000181d32964 __CFRunLoopRun + 1028
	3   CoreFoundation                       0x0000000181c5cc50 CFRunLoopRunSpecific + 380
	4   Foundation                           0x000000018266ccfc -[NSRunLoop(NSRunLoop) runMode:beforeDate:] + 304
	5   Foundation                           0x00000001826c2030 -[NSRunLoop(NSRunLoop) run] + 84
	6   MY_APP                               0x0000000100642438 +[GAI threadMain:] + 60
	7   Foundation                           0x0000000182753e4c __NSThread__start__ + 996
	8   libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	9   libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	10  libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 8:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 9:
	0   libsystem_kernel.dylib               0x00000001818fcfd8 mach_msg_trap + 8
	1   CoreFoundation                       0x0000000181d34c60 __CFRunLoopServiceMachPort + 192
	2   CoreFoundation                       0x0000000181d32964 __CFRunLoopRun + 1028
	3   CoreFoundation                       0x0000000181c5cc50 CFRunLoopRunSpecific + 380
	4   libAVFAudio.dylib                    0x00000001883d99e0 GenericRunLoopThread::Entry(void*) + 160
	5   libAVFAudio.dylib                    0x00000001883ae75c CAPThread::Entry(CAPThread*) + 80
	6   libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	7   libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	8   libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 10:
	0   libsystem_kernel.dylib               0x00000001818fcfd8 mach_msg_trap + 8
	1   CoreFoundation                       0x0000000181d34c60 __CFRunLoopServiceMachPort + 192
	2   CoreFoundation                       0x0000000181d32964 __CFRunLoopRun + 1028
	3   CoreFoundation                       0x0000000181c5cc50 CFRunLoopRunSpecific + 380
	4   CFNetwork                            0x00000001823ddbcc +[NSURLConnection(Loader) _resourceLoadLoop:] + 408
	5   Foundation                           0x0000000182753e4c __NSThread__start__ + 996
	6   libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	7   libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	8   libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 11:
	0   libsystem_kernel.dylib               0x00000001818fcfd8 mach_msg_trap + 8
	1   CoreFoundation                       0x0000000181d34c60 __CFRunLoopServiceMachPort + 192
	2   CoreFoundation                       0x0000000181d32964 __CFRunLoopRun + 1028
	3   CoreFoundation                       0x0000000181c5cc50 CFRunLoopRunSpecific + 380
	4   Foundation                           0x000000018266ccfc -[NSRunLoop(NSRunLoop) runMode:beforeDate:] + 304
	5   MY_APP                               0x0000000100ab55a4 -[_ABT_SRRunLoopThread main] (SRWebSocket.m:1768)
	6   Foundation                           0x0000000182753e4c __NSThread__start__ + 996
	7   libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	8   libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	9   libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 12:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 13:
	0   libsystem_kernel.dylib               0x0000000181918344 __select + 8
	1   libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	2   libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	3   libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 14:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 15:
	0   libsystem_kernel.dylib               0x000000018191841c __semwait_signal + 8
	1   libc++.1.dylib                       0x00000001813ad3b4 std::__1::this_thread::sleep_for(std::__1::chrono::duration<long long, std::__1::ratio<1l, 1000000000l> > const&) + 80
	2   JavaScriptCore                       0x0000000185982690 bmalloc::Heap::scavenge(std::__1::unique_lock<bmalloc::StaticMutex>&, std::__1::chrono::duration<long long, std::__1::ratio<1l, 1000l> >) + 184
	3   JavaScriptCore                       0x0000000185982340 bmalloc::Heap::concurrentScavenge() + 80
	4   JavaScriptCore                       0x0000000185984ad8 bmalloc::AsyncTask<bmalloc::Heap, void (bmalloc::Heap::*)()>::entryPoint() + 96
	5   JavaScriptCore                       0x0000000185984a68 bmalloc::AsyncTask<bmalloc::Heap, void (bmalloc::Heap::*)()>::pthreadEntryPoint(void*) + 8
	6   libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	7   libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	8   libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 16:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 17:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 18 Crashed:
	0   WebCore                              0x0000000185dfe47c WTF::HashMap<WTF::String, WebCore::ApplicationCacheGroup*, WTF::StringHash, WTF::HashTraits<WTF::String>, WTF::HashTraits<WebCore::ApplicationCacheGroup*> >::remove(WTF::String const&) + 48
	1   WebCore                              0x0000000185dfabbc WebCore::ApplicationCacheStorage::cacheGroupDestroyed(WebCore::ApplicationCacheGroup*) + 48
	2   WebCore                              0x0000000185df0628 WebCore::ApplicationCacheGroup::~ApplicationCacheGroup() + 52
	3   WebCore                              0x0000000185df0b10 WebCore::ApplicationCacheGroup::~ApplicationCacheGroup() + 8
	4   WebCore                              0x0000000185df2334 WebCore::ApplicationCacheGroup::disassociateDocumentLoader(WebCore::DocumentLoader*) + 180
	5   WebCore                              0x0000000185c824a0 WebCore::ApplicationCacheHost::~ApplicationCacheHost() + 44
	6   WebCore                              0x0000000185c81ad0 WebCore::DocumentLoader::~DocumentLoader() + 164
	7   WebKitLegacy                         0x0000000186bf6ba8 WebDocumentLoaderMac::~WebDocumentLoaderMac() + 80
	8   WebCore                              0x00000001860b0a78 WebCore::FrameLoader::detachFromParent() + 320
	9   WebKitLegacy                         0x0000000186c60b08 __29-[WebView(WebPrivate) _close]_block_invoke + 344
	10  WebCore                              0x0000000186a042c4 HandleRunSource(void*) + 364
	11  CoreFoundation                       0x0000000181d3509c __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 20
	12  CoreFoundation                       0x0000000181d34ab0 __CFRunLoopDoSources0 + 408
	13  CoreFoundation                       0x0000000181d32830 __CFRunLoopRun + 720
	14  CoreFoundation                       0x0000000181c5cc50 CFRunLoopRunSpecific + 380
	15  WebCore                              0x0000000185c4e108 RunWebThread(void*) + 452
	16  libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	17  libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	18  libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 19:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 20:
	0   libsystem_kernel.dylib               0x0000000181917f24 __psynch_cvwait + 8
	1   libc++.1.dylib                       0x000000018136f42c std::__1::condition_variable::wait(std::__1::unique_lock<std::__1::mutex>&) + 52
	2   JavaScriptCore                       0x0000000185734d5c JSC::GCThread::waitForNextPhase() + 140
	3   JavaScriptCore                       0x0000000185734df4 JSC::GCThread::gcThreadMain() + 80
	4   JavaScriptCore                       0x000000018540a614 WTF::threadEntryPoint(void*) + 208
	5   JavaScriptCore                       0x000000018540a524 WTF::wtfThreadEntryPoint(void*) + 20
	6   libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	7   libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	8   libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 21:
	0   libsystem_kernel.dylib               0x00000001818fcfd8 mach_msg_trap + 8
	1   CoreFoundation                       0x0000000181d34c60 __CFRunLoopServiceMachPort + 192
	2   CoreFoundation                       0x0000000181d32964 __CFRunLoopRun + 1028
	3   CoreFoundation                       0x0000000181c5cc50 CFRunLoopRunSpecific + 380
	4   WebCore                              0x0000000185c7b950 WebCore::runLoaderThread(void*) + 268
	5   JavaScriptCore                       0x000000018540a614 WTF::threadEntryPoint(void*) + 208
	6   JavaScriptCore                       0x000000018540a524 WTF::wtfThreadEntryPoint(void*) + 20
	7   libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	8   libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	9   libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 22:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 23:
	0   libsystem_kernel.dylib               0x00000001818fcfd8 mach_msg_trap + 8
	1   CoreFoundation                       0x0000000181d34c60 __CFRunLoopServiceMachPort + 192
	2   CoreFoundation                       0x0000000181d32964 __CFRunLoopRun + 1028
	3   CoreFoundation                       0x0000000181c5cc50 CFRunLoopRunSpecific + 380
	4   CoreFoundation                       0x0000000181caa3a4 CFRunLoopRun + 108
	5   CoreMotion                           0x0000000187c2f41c 0x187bdc000 + 341020
	6   libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	7   libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	8   libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 24:
	0   libsystem_kernel.dylib               0x00000001818fcfd8 mach_msg_trap + 8
	1   CoreFoundation                       0x0000000181d34c60 __CFRunLoopServiceMachPort + 192
	2   CoreFoundation                       0x0000000181d32964 __CFRunLoopRun + 1028
	3   CoreFoundation                       0x0000000181c5cc50 CFRunLoopRunSpecific + 380
	4   MY_APP                               0x0000000100774904 +[RCTJSCExecutor runRunLoopThread] (RCTJSCExecutor.mm:202)
	5   Foundation                           0x0000000182753e4c __NSThread__start__ + 996
	6   libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	7   libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	8   libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 25:
	0   libsystem_kernel.dylib               0x0000000181917f24 __psynch_cvwait + 8
	1   libc++.1.dylib                       0x000000018136f42c std::__1::condition_variable::wait(std::__1::unique_lock<std::__1::mutex>&) + 52
	2   JavaScriptCore                       0x0000000185734d5c JSC::GCThread::waitForNextPhase() + 140
	3   JavaScriptCore                       0x0000000185734df4 JSC::GCThread::gcThreadMain() + 80
	4   JavaScriptCore                       0x000000018540a614 WTF::threadEntryPoint(void*) + 208
	5   JavaScriptCore                       0x000000018540a524 WTF::wtfThreadEntryPoint(void*) + 20
	6   libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	7   libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	8   libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 26:
	0   libsystem_kernel.dylib               0x0000000181917f24 __psynch_cvwait + 8
	1   JavaScriptCore                       0x000000018540db80 WTF::ThreadCondition::timedWait(WTF::Mutex&, double) + 76
	2   WebKitLegacy                         0x0000000186c4d4a4 std::__1::unique_ptr<std::__1::function<void ()>, std::__1::default_delete<std::__1::function<void ()> > > WTF::MessageQueue<std::__1::function<void ()> >::waitForMessageFilteredWithTimeout<WTF::MessageQueue<std::__1::function<void ()> >::waitForMessage()::'lambda'(std::__1::function<void ()> const&)>(WTF::MessageQueueWaitResult&, WTF::MessageQueue<std::__1::function<void ()> >::waitForMessage()::'lambda'(std::__1::function<void ()> const&)&&, double) + 84
	3   WebKitLegacy                         0x0000000186c4cb60 WebCore::StorageThread::threadEntryPoint() + 64
	4   JavaScriptCore                       0x000000018540a614 WTF::threadEntryPoint(void*) + 208
	5   JavaScriptCore                       0x000000018540a524 WTF::wtfThreadEntryPoint(void*) + 20
	6   libsystem_pthread.dylib              0x00000001819e3b28 _pthread_body + 152
	7   libsystem_pthread.dylib              0x00000001819e3a8c _pthread_start + 152
	8   libsystem_pthread.dylib              0x00000001819e1028 thread_start + 0
	
	Thread 27:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 28:
	0   libsystem_kernel.dylib               0x0000000181918b48 __workq_kernreturn + 8
	1   libsystem_pthread.dylib              0x00000001819e1020 start_wqthread + 0
	
	Thread 18 crashed with ARM-64 Thread State:
	    pc: 0x0000000185dfe47c     fp: 0x000000016eac1da0     sp: 0x000000016eac1d60     x0: 0x0000000000000000 
	    x1: 0x000000010c2ecf18     x2: 0x000000012ef78e10     x3: 0x0000000000000002     x4: 0x0000000000000001 
	    x5: 0x0000000000000001     x6: 0x000000012eb585c0     x7: 0x0000000000000c30     x8: 0x0000000000000000 
	    x9: 0x0000000000000000    x10: 0x0000000000000000    x11: 0x0000000000000000    x12: 0x0000000000000007 
	   x13: 0x0000000000000000    x14: 0x0000000000000000    x15: 0x000000001fb31e71    x16: 0x0000000181944168 
	   x17: 0x00000001813fea74    x18: 0x0000000000000000    x19: 0x0000000109e48148    x20: 0x000000010c2ecf18 
	   x21: 0x0000000108f34b80    x22: 0x0000000000000007    x23: 0x000000019faed000    x24: 0x0000000000000001 
	   x25: 0x000000012eaf7ee8    x26: 0x00000001a0797002    x27: 0x000000019f7aa5e4    x28: 0x0000000000000000 
	    lr: 0x0000000185dfabbc   cpsr: 0x0000000060000000 