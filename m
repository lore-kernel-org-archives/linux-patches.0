Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B692156653
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 06:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728454837; cv=none; b=sYpL85lITYJTMqW3SYC4X0zPEVPbPNC2DyU0r/B220thO9T7CBcHqcu/axa5sMFc8JXRZLEAd70cNqPlCwVdCaR4US7wUNfHr1pOGyTrvR8H8AlNua3yOk2QtyuRDAuON+lRh/Ps4Wq6hodoaP0yk8edNkkNl0cC4tQhWp/Hjcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728454837; c=relaxed/simple;
	bh=iKguk0ZzllZtHrzXEI1aX68WWj9bLq2IVL87ZyCjB7A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eK9OFLQqJvt4duAnoCpJ4n5ILIXRZJ21awDIWxNSxyKHWMVefLarUWuSqvQCZRAYkDvvK47XSrz9/7NtosY0BULHxO85xa1AmaZmYLAyqy3fuLZGEVAz8PvJW+yaesnGlxqe4gE5UwCWnsZB5wKIwgDMvU72NmO9DIal5Rth3k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fpDT8Vj9; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fpDT8Vj9"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-4a3af44dbc9so2881434137.1
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 23:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728454835; x=1729059635; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W7Ly0xIH+T6iacS9Oc+Ut4ENz1231sKJlhXnASor1mc=;
        b=fpDT8Vj9zLbIwz+ffs3RorXZ2f53WwsY4d9LFJSLzv8RV45dpCrrtt6BnzGWTb82/a
         RLL45Ig2IqjzvaxQa0ffibkQv0duTdBM1+oRA2BM4E5aUBKbGPQRsLQkYVpB0YmPhjRk
         u477wwm8sTF21i8uRT4aqdbbXpM+U07uwoJxHoZI+lhpQpGWBryx4Er8i0hR/BPkNJkB
         3xVi+PXhJN1OJooXmcDi6j2y3h21pLquYg344KrbibNW0zuwN+L7vwlsfNMLL0LIOPAo
         d0hwN+bAeYIgXXPhdNNobNjKyjo0bFdZ3mAAHMA2P75ZLJ2rV7O09/vedMXDihzKf7dr
         ksbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728454835; x=1729059635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W7Ly0xIH+T6iacS9Oc+Ut4ENz1231sKJlhXnASor1mc=;
        b=pLjT7xYRD0KQp8ls5UJvFGN/1ZJuYp17dhgLG1pwnINJRresNV9bkNri/Y+miMYjqK
         gKeVZFHuIxkTxq/cEpaNYhBEPJen/T1Lc765dLo5FpBxs1jd6VZIqwlKwyHR042HjMUC
         Kr9W8BqBmIU1lpwzcphgavg+pVEN9LxlCIh9Ij3jh/Si2tQFMEDSltzxQmUGimtQQRQb
         mnwQjMibsnIzSGOcOfF/HcRem24u6UesaOtkj99q0i35UOymiNkL7lRQZCuwrVJv3R0R
         YuoOqyCAFy+y/toJ9zsEI5oq/gVuGlANZ+lDjIoRL0gCgeuek/TzkwBpP8RbsCDUB8s0
         GkDw==
X-Forwarded-Encrypted: i=1; AJvYcCUGSmQsoABfdwAAbWzcpWxTHW9fuCFTnbURaYXUCahxqgrcD1f1IS8QtzMKnsX6KHx4bXu63Ffh@lists.linux.dev
X-Gm-Message-State: AOJu0YwT6cKgbd315ALf8jMOM7nay8Pm1zOGf3y1naz1a4qYJyN5LyOE
	ss+qDwSSXdu8Oh41W2tKD1tBY8POwDuHmDX/ztN58/MhrQzFVGfXC276CmGZfiQaQ5cVusP4hXn
	X3wm20hSr2seXMdEAF1muobe7P6yRI4JfONqjfQ==
X-Google-Smtp-Source: AGHT+IGWTvBOtKqjQU8+Faq6+7bPkFJwyCJHcpiOSqa1Ma88XoPlF5RijSgOIxwq5QTx4vj8v9gTKSnPD9K/2hgM8xg=
X-Received: by 2002:a05:6102:4190:b0:493:e643:bed with SMTP id
 ada2fe7eead31-4a448d7d169mr975988137.13.1728454834421; Tue, 08 Oct 2024
 23:20:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241008115702.214071228@linuxfoundation.org>
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Oct 2024 11:50:22 +0530
Message-ID: <CA+G9fYuoPox1DC2TBrt7r_NeMbei2BUDJqcoZeb0jJbfBkWSaw@mail.gmail.com>
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Oct 2024 at 18:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.11.3 release.
> There are 558 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

[ Please ignore my previous email ]

The LTP syscalls fanotify22 test failed  (broken).
This regression is noticed on linux.6.11.y, linux.6.10.y and linux.6.6.y.

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

Test Log links,
--------
-  https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11.2-559-gdd3578144a91/testrun/25354454/suite/ltp-syscalls/test/fanotify22/log
 - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2n9oaAhqs4N4yQNT4kFVIbeqQlN

Test results history:
----------
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11.2-559-gdd3578144a91/testrun/25357228/suite/ltp-syscalls/test/fanotify22/history/

metadata:
--------------
* kernel: 6.11.3-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: dd3578144a91f9258e2da8e085a412adc667dba5
* git describe: v6.11.2-559-gdd3578144a91
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11.2-559-gdd3578144a91
 * build:  https://storage.tuxsuite.com/public/linaro/lkft/builds/2n9oYazowtGn93u3pa9kOWYYuH6/
* config:  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2n9oYazowtGn93u3pa9kOWYYuH6/config

Steps to reproduce:
---------
- https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2n9oaAhqs4N4yQNT4kFVIbeqQlN/reproducer
- https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2n9oaAhqs4N4yQNT4kFVIbeqQlN/tux_plan

--
Linaro LKFT
https://lkft.linaro.org


--
Linaro LKFT
https://lkft.linaro.org
