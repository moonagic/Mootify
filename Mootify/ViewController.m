//
//  ViewController.m
//  Mootify
//
//  Created by Wu Hengmin on 16/4/15.
//  Copyright © 2016年 Wu Hengmin. All rights reserved.
//

#import "ViewController.h"
#import <Spotify/Spotify.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPRemoteCommand.h>
#import <MediaPlayer/MPRemoteCommandCenter.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<SPTAuthViewDelegate, SPTAudioStreamingDelegate, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate>
@property (atomic, readwrite) SPTAuthViewController *authViewController;
@property (nonatomic, strong) SPTAudioStreamingController *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionUpdatedNotification:) name:@"sessionUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listeningRemoteControl:) name:@"kAppDidReceiveRemoteControlNotification" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
        [self setNowPlayingInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruptionNotificationCallback) name:AVAudioSessionInterruptionNotification object:nil];
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    [commandCenter.playCommand addTarget:self action:@selector(didReceivePlayCommand)];
    [commandCenter.pauseCommand addTarget:self action:@selector(didReceivePauseCommand)];
    
    [commandCenter.nextTrackCommand addTarget:self action:@selector(didReceiveNextTrackCommand)];
    [commandCenter.previousTrackCommand addTarget:self action:@selector(didReceivePreviousTrackCommand)];
    

}

- (void)interruptionNotificationCallback {
    
}

- (void)didReceivePlayCommand {
    [self setNowPlayingInfo];
}

- (void)didReceivePauseCommand {
    [self setNowPlayingInfo];
}

- (void)didReceiveNextTrackCommand {
    
}

- (void)didReceivePreviousTrackCommand {
    
}

-(void)listeningRemoteControl:(NSNotification *)sender {
    NSDictionary *dict=sender.userInfo;
    NSInteger order=[[dict objectForKey:@"order"] integerValue];
    switch (order) {
            //暂停
        case UIEventSubtypeRemoteControlPause:
        {
//            UIButton  stateButton = (id)[self.view viewWithTag:STATE_BUTTON_TAG];
//            [self onClickChangeState:stateButton];
            break;
        }
            //播放
        case UIEventSubtypeRemoteControlPlay:
        {
//            UIButton  stateButton = (id)[self.view viewWithTag:STATE_BUTTON_TAG];
//            [self onClickChangeState:stateButton];
            break;
        }
            //暂停播放切换
        case UIEventSubtypeRemoteControlTogglePlayPause:
        {
//            UIButton  stateButton = (id)[self.view viewWithTag:STATE_BUTTON_TAG];
//            [self onClickChangeState:stateButton];
            break;
        }
            //下一首
        case UIEventSubtypeRemoteControlNextTrack:
        {
//            [self next];
            [self.player skipNext:^(NSError *error) {
                NSLog(@"error");
            }];
            break;
        }
            //上一首
        case UIEventSubtypeRemoteControlPreviousTrack:
        {
//            [self previous];
            [self.player skipPrevious:^(NSError *error) {
                
            }];
            break;
        }
        default:
            break;
    }
}

-(void)setNowPlayingInfo {
    NSLog(@"setNowPlayingInfo");
    NSMutableDictionary *songDict=[NSMutableDictionary dictionary];
    //歌名
    [songDict setObject:@"测试" forKey:MPMediaItemPropertyTitle];
    //歌手名
    [songDict setObject:@"测试" forKey:MPMediaItemPropertyArtist];
    //歌曲的总时间
    [songDict setObject:[NSNumber numberWithDouble:600] forKeyedSubscript:MPMediaItemPropertyPlaybackDuration];
    //设置歌曲图片
//    MPMediaItemArtwork imageItem=[[MPMediaItemArtwork alloc]initWithImage:_singerImageView.image];
//    [songDict setObject:imageItem forKey:MPMediaItemPropertyArtwork];
    //设置控制中心歌曲信息
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
}


-(void)sessionUpdatedNotification:(NSNotification *)notification {
    if(self.navigationController.topViewController == self) {
        SPTAuth *auth = [SPTAuth defaultInstance];
        if (auth.session && [auth.session isValid]) {
//            [self performSegueWithIdentifier:@"ShowPlayer" sender:nil];
            NSLog(@"gogogo");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPressed:(id)sender {
    [self openLoginPage];
}

- (void)authenticationViewController:(SPTAuthViewController *)viewcontroller didFailToLogin:(NSError *)error {
    NSLog(@"*** Failed to log in: %@", error);
}

- (void)authenticationViewController:(SPTAuthViewController *)viewcontroller didLoginWithSession:(SPTSession *)session {
    NSLog(@"didLoginWithSession token:%@  %@", session.accessToken, session.canonicalUsername);
//    [SPTUser requestCurrentUserWithAccessToken:session.accessToken callback:^(NSError *error, id object) {
//        SPTUser *user = object;
//        NSLog(@"%@ %@", user.displayName, user.canonicalUserName);
//        
//        [SPTUser requestUser:user.canonicalUserName withAccessToken:session.accessToken callback:^(NSError *error, id object) {
//            SPTUser *user = object;
//            NSLog(@"%@ %@ %@", user.displayName, user.canonicalUserName, user.emailAddress);
//        }];
//        
//    }];
    
//    [SPTYourMusic savedTracksForUserWithAccessToken:session.accessToken callback:^(NSError *error, id object) {
//        NSLog(@"%@", object);
//    }];
    
    // Getting the first two pages of a playlists for a user
//    NSURLRequest *playlistrequest = [SPTPlaylistList createRequestForGettingPlaylistsForUser:@"possan" withAccessToken:session.accessToken error:nil];
//    [[SPTRequest sharedHandler] performRequest:playlistrequest callback:^(NSError *error, NSURLResponse *response, NSData *data) {
//        if (error != nil) { Handle error ;}
//        SPTPlaylistList *playlists = [SPTPlaylistList playlistListFromData:data withResponse:response error:nil];
//        NSLog(@"Got possan's playlists, first page: %@", playlists.items);
//        NSURLRequest *playlistrequest2 = [playlists createRequestForNextPageWithAccessToken:session.accessToken error:nil];
//        [[SPTRequest sharedHandler] performRequest:playlistrequest2 callback:^(NSError *error2, NSURLResponse *response2, NSData *data2) {
//            if (error2 != nil) { Handle error; }
//            SPTPlaylistList *playlists2 = [SPTPlaylistList playlistListFromData:data2 withResponse:response2 error:nil];
//            NSLog(@"Got possan's playlists, second page: %@", playlists2.items);
//        }];
//    }];
    __weak __typeof__(self) weakSelf = self;
    [SPTPlaylistList playlistsForUserWithSession:session callback:^(NSError *error, id object) {
        NSLog(@"%@", object);
        SPTPlaylistList *list = object;
        NSLog(@"%@", list.items);
        for (SPTPartialPlaylist *obj in list.items) {
            
            NSLog(@"%@ url:%@", obj.name, obj.uri);
        }
        
        SPTPartialPlaylist *obj = list.items[0];
        [weakSelf handleNewSession:obj.uri];
    }];
    
}

- (void)authenticationViewControllerDidCancelLogin:(SPTAuthViewController *)authenticationViewController {
    NSLog(@"authenticationViewControllerDidCancelLogin");
}

-(void)handleNewSession:(NSURL *)url {
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    if (self.player == nil) {
        self.player = [[SPTAudioStreamingController alloc] initWithClientId:auth.clientID];
        self.player.playbackDelegate = self;
        self.player.diskCache = [[SPTDiskCache alloc] initWithCapacity:1024 * 1024 * 64];
    }
    
    [self.player loginWithSession:auth.session callback:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"*** Enabling playback got error: %@", error);
            return;
        }
        
//        [self updateUI];
        
        NSURLRequest *playlistReq = [SPTPlaylistSnapshot createRequestForPlaylistWithURI:url
                                                                             accessToken:auth.session.accessToken
                                                                                   error:nil];
        
        [[SPTRequest sharedHandler] performRequest:playlistReq callback:^(NSError *error, NSURLResponse *response, NSData *data) {
            if (error != nil) {
                NSLog(@"*** Failed to get playlist %@", error);
                return;
            }
            
            SPTPlaylistSnapshot *playlistSnapshot = [SPTPlaylistSnapshot playlistSnapshotFromData:data withResponse:response error:nil];
            
            [self.player playURIs:playlistSnapshot.firstTrackPage.items fromIndex:0 callback:nil];
        }];
    }];
}

- (void)openLoginPage {
    
    self.authViewController = [SPTAuthViewController authenticationViewController];
    self.authViewController.delegate = self;
    self.authViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.authViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.definesPresentationContext = YES;
    
    [self presentViewController:self.authViewController animated:NO completion:nil];
}

#pragma mark - Track Player Delegates
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveMessage:(NSString *)message {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message from Spotify"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didFailToPlayTrack:(NSURL *)trackUri {
    NSLog(@"failed to play track: %@", trackUri);
}

- (void) audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeToTrack:(NSDictionary *)trackMetadata {
    NSLog(@"track changed = %@", [trackMetadata valueForKey:SPTAudioStreamingMetadataTrackURI]);
//    [self updateUI];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePlaybackStatus:(BOOL)isPlaying {
    NSLog(@"is playing = %d", isPlaying);
}

-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didSeekToOffset:(NSTimeInterval)offset {
    NSLog(@"offset=%f", offset);
}

-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeVolume:(SPTVolume)volume {
    NSLog(@"volume=%f", volume);
}

-(void)audioStreamingDidLosePermissionForPlayback:(SPTAudioStreamingController *)audioStreaming {
    NSLog(@"audioStreamingDidLosePermissionForPlayback");
}

@end
