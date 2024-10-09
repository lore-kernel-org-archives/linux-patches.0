Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491F413AA27
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 06:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728454972; cv=none; b=taXIxc9xPNCfI+Z5gZgfFCa138gWz/tc4hG92DyffWlUMjIfqLIbtFGn3vyCUPxhKIvI/Fc5bM9ZoUWRMNO+OZPAim2cSafkc7op6t+iGSIWua/qXARZGTkneK4vb+iR9jm6SgWZEI3XTSfip+sfm9QvL7sQMRxdHm893OJX5qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728454972; c=relaxed/simple;
	bh=70XTPMcMP2KIi3tLbcqxxoESA7Ui9Epoi5qeJRsiekQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LOIw2+TgKZnMS6WCyRW1xzgaQX85LF7+UUSnB3dqybQ+YPa6mIe42w/Q+8xWnkZgm5PjscVSmAWE6iOZ80whPJJgfQGztgYjvYJAjGZXgwygCiPDVcDRLrUr/rmhrSnZ4BE1c3vJnkkgcp3csLXHfBoeDJxvGh61T3jkeWMn/E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iu0gkxdu; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iu0gkxdu"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-84ea6ddb972so1632733241.1
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 23:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728454970; x=1729059770; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RopoYYi2hlVFFuKNg1HoN6+xeEu++B4y+INQW7poSdo=;
        b=iu0gkxdu/xonqLv+Pe5gg//h0NYTtgaER+/oIY289FcDJbEhHxFpSkMkTrB7i3eZsZ
         eYbQBsyXwVuAGIVWEUl/glyv/yuqWFnrt+aTLjeM0KKFCdz0ezLupDPvnMLtsDVWF1B/
         sX4CSbr57bjmb5zOAucF5Zf+Qx0LnwKlXFVadqvNCeP2aIl27iKTDMcbitolbFT0JfqY
         HTVFLH61fsgADPu4YDBiOT7Q4OtGvtpVREWgK86QiXxFfmhmaxtzRNzzWAAKQodHrgVG
         JulRvFm6K0dkdKUFJCq6NIFIfgX76v8EMZmuVIbwU2HCRH/P5Plg+LYt6c3Kf7VL17Lx
         uZ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728454970; x=1729059770;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RopoYYi2hlVFFuKNg1HoN6+xeEu++B4y+INQW7poSdo=;
        b=cADM0NEPBTBPDI82il0lxygofafFNDawfbNPaV0qT4jn2CKM+VTWgc8nnPj1Pqq6IF
         gYsmSzA+iNSwOS3vaC/Qkqf1ed9L+NBlDvh0Stp7u+XPnjftIjK8gtNOBE2JNt6zWiON
         S4322kv0i+yE7gXYFUFpFJMDdZmy6Y5g/xOks6l7992R/2i6Kp5hajgLPj1zWfh6ZdbE
         uG6FU7d3cyS3BB7cK26QUppwpeW4KeK8HH5hsn9eYLp8BmsjgMaA1ngaMu5lfw+sKPW6
         vbn5dE1qAX2v6mHEepl6K0PAHVJIgQMUtzkl7i2wShX7t+AdiYX59qXQgdB4vFKuC452
         ZDCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuCJD9+NQGrZofQxZ36tpmkbkhSab8DT8T9M9iCD2FuyxnV6YzrEowGfLi/hb3FeWmSXW+V/83@lists.linux.dev
X-Gm-Message-State: AOJu0YxFYLc2nuCJmw39VqATi6PNYb2RthZDMH5rf1LdxClpbP/93Zfn
	gv1+a3Ny0KKfKtHtKicFjcoP8EGgsdsYPkKIYR/ihaGjixmM+ixoBO/FQJiJRlgPSY24EZ3+zyh
	hBbp8sNq3UyJYpnSXewgEo/0yZlk9fb+uFxBbBQ==
X-Google-Smtp-Source: AGHT+IEAUqkOgdIyJ+oc3tAQuAWemtC8mERexWMYrIgvafEvJqHf5S3kt2FSt5RKqD7Xtn9v+WxuHwBHNNsPLb6nxAw=
X-Received: by 2002:a05:6102:c48:b0:4a3:e55d:eff5 with SMTP id
 ada2fe7eead31-4a448d66a20mr868134137.9.1728454970015; Tue, 08 Oct 2024
 23:22:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241008115648.280954295@linuxfoundation.org>
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Oct 2024 11:52:38 +0530
Message-ID: <CA+G9fYv=Ld-YCpWaV2X=ErcyfEQC8DA1jy+cOhmviEHGS9mh-w@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/482] 6.10.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Oct 2024 at 17:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.14 release.
> There are 482 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The LTP syscalls fanotify22 test failed  (broken).
This regression is noticed on linux.6.10.y, linux.6.11.y and linux.6.6.y.

We are bisecting this issue.

 ltp-syscalls
  - fanotify22

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Test log,
-----------
fanotify16.c:751[  452.527701] EXT4-fs error (device loop0):
__ext4_remount:6522: comm fanotify22: Abort forced by user
tst_device.c:96: TINFO: Found free device 0 '/dev/loop0'
tst_test.c:1106: TINFO: Formatting /dev/loop0 with ext4 opts='' extra opts=''
mke2fs 1.47.1 (20-May-2024)
tst_test.c:1120: TINFO: Mounting /dev/loop0 to
/scratch/ltp-6nPLv2EGcV/LTP_fanbDvQcT/test_mnt fstyp=ext4 flags=0
tst_test.c:1733: TINFO: LTP version: 20240524
tst_test.c:1617: TINFO: Timeout per run is 0h 02m 30s
fanotify.h:122: TINFO: fid(test_mnt/internal_dir/bad_dir) =
6bd2dab9.86fe4716.7e82.df82837f.0...
fanotify.h:122: TINFO: fid(test_mnt/internal_dir) =
6bd2dab9.86fe4716.7e81.beaa198d.0...
fanotify22.c:278: TINFO: Umounting
/scratch/ltp-6nPLv2EGcV/LTP_fanbDvQcT/test_mnt
debugfs 1.47.1 (20-May-2024)
debugfs 1.47.1 (20-May-2024)
fanotify22.c:281: TINFO: Mounting /dev/loop0 to
/scratch/ltp-6nPLv2EGcV/LTP_fanbDvQcT/test_mnt fstyp=ext4 flags=0
fanotify.h:122: TINFO: fid(test_mnt) = 6bd2dab9.86fe4716.2.0.0...
fanotify22.c:59: TINFO: Mounting /dev/loop0 to
/scratch/ltp-6nPLv2EGcV/LTP_fanbDvQcT/test_mnt fstyp=ext4 flags=21
fanotify22.c:59: TBROK: mount(/dev/loop0, test_mnt, ext4, 33,
0x5659a1d5) failed: EROFS (30)

HINT: You _MAY_ be missing kernel fixes:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=124e7c61deb2

Summary:
passed   0
failed   0
broken   1

--
Linaro LKFT
https://lkft.linaro.org
