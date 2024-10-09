Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9999B17B4FC
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 06:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728455073; cv=none; b=mx1XFuOew1y5I68N5rn9rfxXlLC402iYccFAeCrm8SM7CHdueHW2OMXXlXy1cUaJKUhndOSeqZR+MuiCgx+Hb5nno+Xh9pUi/fqpaT6gqKmzkcZGljRZSmGPLlZ8Ib5hj7otDher06mQgdY69oeZAOoF+IaVZ6afhO6vS8vMKyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728455073; c=relaxed/simple;
	bh=qWz892YeKoJrS4nKN2pE68Uc5xhtWRYUGwhxmzGq5Os=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=APJbPl721HCRHfh7VPXd9ytQ457sDM3ekjw2NFRyiQlp4qrjo2PEMh6n0OL//IEkZcJm2lJNiS/NGnEzicq91uMcIeX+ut4O0rF5JHFvQwEQNW9uy+Yz+DaaNJ4vKCckaZEBHfaT5z09JSZxc9spdFjgv1O3L6sFgZKB+vkmp/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hPkVP62l; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hPkVP62l"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-50ca1581a1aso1093072e0c.2
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 23:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728455070; x=1729059870; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1K1fYPYOX1vHU5cmuw7GclgV31ArXw6XaL9jukhNp04=;
        b=hPkVP62lkiJxGlUYRZHNb0E/DbrHizjdwYnwrLEdjVDJAJERmmWkC5Ga3J7ZRi/Bn8
         ZcAJIJKdRwmRvhIVFJLXVs+KAgkATp0HhqrggN4Q2ZO45AkUPkJkvvKgLuo194C8M8NL
         RnTFBIDyIjJCFFSPcvQp4I8c51nNBsWtUjX/MaifVGA5nDZuI0M03N7IIqUAnTj7uBQ+
         HnJm+dIvDoV7RxrrySeTYdWwjbbU5AkrZiWM04RhRwQiauqKF08qoOpEps57GDDT7hMu
         CddmXLZBxgGXmrqQOC+Z9ara7tqBYsIg62ULG5RjBSncoFU8AU88uhlg76tgXjK15WxP
         jQqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728455070; x=1729059870;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1K1fYPYOX1vHU5cmuw7GclgV31ArXw6XaL9jukhNp04=;
        b=KvcovdqDbJ90ZEwyK5YoXoVsX8OjYHO7mb/5QyRAMsL0jGZG6ItGFMoewP1go1spIz
         Qg197Ufnr03Yo9btjdBBPdrlV+P5zcQe5SH6cBkN4Cx1d/bIENTzsqKmwwbpTdCJEjfm
         4KGslL+j/KR+A83QpsUQci1+ij9geoqCu2+HI/s3811Z7Ibt6zbiR1S07gd4ertKRcjA
         kFl3aU+uTUEVSsPO6y5vOiSqhf95U+MLwfKOHACuLZ4V/z8HMmFISjl0Yk/O0sJQk0UN
         gx8IO/VybRS9JftpeGkBSt8jDDQDDfKub15UZuPmrHOOWr7MoHPA7kDhdjYUD6Y1eHpk
         VlSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVj38wuSjmoXuY/qVDZr6z2+QEmL3JaQgQZPs8V+18Vp1orEGJXs4WHy3eHJVivtgOEPtA4t5Q3@lists.linux.dev
X-Gm-Message-State: AOJu0YwLjnkeEIhM8bneWwdUXVwM7Gt602HTqlPZMAJqtKYUgQa+hozF
	FMXazjZ8N0WU7Rgsp2IhXW/92PtS1lZ7LkOXOs9Ilk8QHqcs3dtjJJCov9DSAz7vmlb7X5BOVep
	ehzujfUhHPPQ4+XovLkG+SJmbHaj9P5u1Ngfj1w==
X-Google-Smtp-Source: AGHT+IGGefmdK2gVfzZLdksZc4v9TSdXPzCoi8o8H3xFV8DF12srdbmwB1J3Xnt0YOqBOodOsk3MJVh5Bx0b9g7lKN0=
X-Received: by 2002:a05:6122:3c54:b0:507:9137:f5a7 with SMTP id
 71dfb90a1353d-50cf09d0fc4mr641100e0c.5.1728455070465; Tue, 08 Oct 2024
 23:24:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241008115629.309157387@linuxfoundation.org>
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Oct 2024 11:54:18 +0530
Message-ID: <CA+G9fYttfwQ7s6P2RLc6QA81_DYi5WrpWtiM4gK7_RDG69=6AA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/386] 6.6.55-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Oct 2024 at 18:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.55 release.
> There are 386 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.55-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The LTP syscalls fanotify22 test failed  (broken).
This regression is noticed on linux.6.6.y, linux.6.10.y and linux.6.11.y.

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
