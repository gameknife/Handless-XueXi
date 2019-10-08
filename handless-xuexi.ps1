# 全局变量
$sleep_time = 2
$long_sleep_time = 5
$video_sleep_time_first = 1080
$video_sleep_time = 120

# 帮助函数
function RandomSleep {
    $random_time = Get-Random -Minimum 0.5 -Maximum 1.1
    $random_time = $random_time * $sleep_time
    Start-Sleep -Seconds $random_time
}

function RandomSwipe( [int]$start, [int]$end, [int]$range) {
    $random_delta = Get-Random -Minimum 0 -Maximum $range
    $end = [int]($end + $random_delta);
    $startstr = $start.ToString();
    $endstr = $end.ToString();
    & adb shell input swipe 500 $startstr 500 $endstr
}

function RandomTap( [int]$x, [int]$y) {
    $random_delta = Get-Random -Minimum -5 -Maximum 5
    $x = [int]($x + $random_delta);
    $y = [int]($y + $random_delta);
    & adb shell input tap $x $y
}

# 启动学习强国
& adb shell am start -n cn.xuexi.android/com.alibaba.android.rimet.biz.SplashActivity
Start-Sleep -s 10

# 密码登陆
& adb shell input tap 150 525
RandomSleep ;
& .\password.ps1
RandomSleep ;
& adb shell input tap 550 610
Start-Sleep -s 5
& adb shell input tap 1000 1855
Start-Sleep -s 5

# 重新登陆
& adb shell am force-stop cn.xuexi.android
Start-Sleep -s 5
& adb shell am start -n cn.xuexi.android/com.alibaba.android.rimet.biz.SplashActivity
Start-Sleep -s 10

# 学习主菜单
& adb shell input tap 540 1900
Write-Output "main menu"
RandomSleep ;
# 进入新思想
#& adb shell input tap 225 140
#Write-Output "new think"
# 综合
& adb shell input tap 325 140
Write-Output "news"
RandomSleep ;
RandomSleep ;
& adb shell input tap 325 140
# 进入重要活动
#& adb shell input tap 50 215
#Write-Output "important talks"
Start-Sleep -s $long_sleep_time
# 滑动-增加随机性
RandomSwipe 1750 100 200;
RandomSleep ;
RandomSwipe 1750 100 200;
RandomSleep ;

# 自动打开文章-每天6篇
for ($i = 0; $i -lt 6; $i++) {
    $y = 392 + 410 * ($i % 3);
    $ystr = $y.ToString();
    & adb shell input tap 540 $ystr
    RandomSleep ;
    # 滑动60次
    for ($f = 0; $f -lt 60; $f++) {
        if ($f % 2 -and $f -lt 10) {
            & adb shell input tap 500 850
        }
        Start-Sleep -s 1;
        RandomSwipe 1000 850 5;
        Start-Sleep -s 1;
        Write-Output "read line $f"
    }
    # 收藏
    adb shell input tap 960 1890
    RandomSleep ;
    # 返回
    & adb shell input keyevent KEYCODE_BACK
    RandomSleep ;
    # 大滑一下,增加随机性
    if( $i -eq 1 -or $i -eq 3 -or $i -eq 5)
    {
        RandomSwipe 1500 800 50;
        RandomSleep ;
    }
    Write-Output "article $i read ok."
}

# 自动播放新闻联播-每天6个
& adb shell input tap 753 1900
RandomSleep ;
& adb shell input tap 310 140
RandomSleep ;
RandomSleep ;
& adb shell input tap 310 140
Start-Sleep -s $long_sleep_time
RandomSleep ;
Write-Output "video channel."

for ($i = 0; $i -lt 6; $i++) {

    # 计算点击位置
    $y = 820 + 160 * $i;
    $ystr = $y.ToString();
    & adb shell input tap 540 $ystr
    
    if($i -eq 0)
    {
        # 新闻联播看18分钟
        Start-Sleep -s $video_sleep_time_first
    }
    else {
        # 其他节目,2分钟
        Start-Sleep -s $video_sleep_time
    }
    
    & adb shell input keyevent KEYCODE_BACK
    RandomSleep ;

    # 每个视频都划屏
    #& adb shell input swipe 500 1500 500 600
    #Start-Sleep -s $sleep_time;

    Write-Output "video $i read ok."
}

# 退出学习强国
Write-Output "learning complete, exiting..."
& adb shell am force-stop cn.xuexi.android

return;

