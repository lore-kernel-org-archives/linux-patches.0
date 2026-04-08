Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3823F35F60F
	for <patches@lists.linux.dev>; Wed,  8 Apr 2026 22:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775687565; cv=pass; b=i/lQcwSuDKAcoN9ZHvmfE8iQRaB9ZGysw7W2LQiZRujqZWp6pdlK8CP6dNcmBdKthN4MBulsP6YYB+KKs7RURk63Eh3+5UbyfHQc2/xmiNgnG5HeDFC7d1izowVTSZePqoR0EZ3HcKSKrhaScyCxxC9DEd53UyHB8j9CK3fbj5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775687565; c=relaxed/simple;
	bh=4hVu5AMFx74Du4EKUXeyAzM1O3Hk+cEhA3SjQYkryjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HGw8/sva3bJh14laUFDt6eTGnfrjeA+7YXsLcW7T/YabkMvT59R2nVwYrtK913a/pwm3rpdWkXM1Kl0tXT/zuG4vk9uCDGgTvvtoxGvjOcsiVALrshu9p1Hy+oJKaWN3Q+xHKFYWpzsTQMLP43ptMo9+/b08hxz4vZQV+SKgRYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jXZBo8Ci; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jXZBo8Ci"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a2c500750dso233922e87.1
        for <patches@lists.linux.dev>; Wed, 08 Apr 2026 15:32:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775687561; cv=none;
        d=google.com; s=arc-20240605;
        b=XA89BkWeXYebcc2cUih1wQbC9nkadX8nS/TwKTvruzwPX8DzJ5+fpLE83L4GLbQnTh
         e9HH3SHqLswJgzylSM1wL1HgxMwCaj7y/wVwqAN9bLMmUHkugb1AOxjhy6B7XUY1Md01
         bSydUytrBL/WXJXHTlq9VavzmK9V0qSYicgZIQ4s5cUAKL9GYbbJwGIqP6CXiCYE6WfW
         8cs2KLehvtMBh+Vfr0NX3iG+iRU/295YJ6AvnPpPEfpDAIa14Cx8WdesyTzX1+Sl2ntU
         0sr3TXsQMiS3JANBG+nQQ2xUAst/78XiuI6pp0Ba/DdwQDjUGk6oDanwEZ87C32DrIsc
         UUYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ByzcZBfhzWS3WwjWKkRG3T4PJ/8xweSH4/lUBfwIOPE=;
        fh=CJguExcL6I+jgeGoCd/DzbY1kxZMXXd1EBLD8irIdp8=;
        b=TP7+enBN8JPhXJB6zPAnpkkV7z7sPA8jj3U5YOSvc9ni1AjX+b7lZXSZDX2L47Atzp
         Z4V3Agwj7HCRdbOBMt2s1+IRdpV/zKm8nRk0Uas7Dih9YJlx7uNPZriV6gePNrtAIl73
         KdWN4f5uhf6NYKjUMvsNOW5BIXxUcwFvk2NiWnqY8LMEdsDx5KMnEgLMSuuXbk8C2L3s
         xn4fc08/heM8nQ4YhN+zF5V6AzB8DoligOTV3tQV7Xu0w0AHCI+l/Bxod2X7ql2aj1Cp
         M+vCXoHC75XkPRjacEGB4SV8Dhzj8S9DSFqf0tnOTiU95kgh6KmkKl2rG1wxeCSsm9um
         2OfA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775687561; x=1776292361; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ByzcZBfhzWS3WwjWKkRG3T4PJ/8xweSH4/lUBfwIOPE=;
        b=jXZBo8CicoyXUUYllGxDqrdDzXsftLZEMRX2yPIuY7vKwyNuV3vKrkN57xOD4p5we0
         9SSyOg6h7kwl2rzuofpAteittmJCtcMM1lMDR5MnoO4aG/oCvQxfGJ1DAGdsGf9Lw5cD
         kZocGSpRSiPPEdNsw+nIP03w3449BU1NLt8IpYurHincFlqvlYpzjdYf60FdEI4MJkON
         FTR9/idSEzaee4Bc0h7svwqrVOagU7QBSR6YkQnPDJ2usbgXW2a9JLxRx/y84K23bO3f
         opnDH6d8DvTLXRdB+wUrYGjYVDEOjSPClj1mjL/ybxUbT+6fQIJ+MQrEDSLDfNhMzCza
         0yZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775687561; x=1776292361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ByzcZBfhzWS3WwjWKkRG3T4PJ/8xweSH4/lUBfwIOPE=;
        b=G6S/cATQye4eZ3wGhdHqgT7/gHFi9ICTVOCRDpObmD5TLqO8DInBqeR6h/5OtJgcaA
         v3DF7mWzZX++L1KYq8bbB9aiNpaqUxchqSJLXpK2UqcqVRcGoFZWC0j9Znaiv1dMivJ0
         9ctxtf4FTQvqLvswd8qrK/T1djELZUs5yrAKt+9dWixaT2IZTAyMfvWr56gNA6RwH1xr
         IDrCC3gsKhBqO7Utb74dNExS1BZI5zufXe9lYV3Dx20MRf+5R7gAR/vnDE85DJCCQ1ry
         lGHI7YJ+3OIUJrv2goCcQdaxIopV6BX6Vkb882RNX/dKl81o3qxL6EG7/xHszHC51rM3
         cJRg==
X-Forwarded-Encrypted: i=1; AJvYcCX1QvtgwHtfX8N2/GUGe/kf5XX93THyiya1LNlMzdzSGvb2plJfvIR9qJt9buaq8vTNnS32jP5m@lists.linux.dev
X-Gm-Message-State: AOJu0YxFARhC/rRF+QWdUX46mnt4Xkd0t/ujm8IKOu6TXOfNUh5r1NrJ
	BHIYJFRsHAN2fHXlSfG8oqivEQ7ruXD9wVNfAQbLXHThgHD9rWosLhqjhF0WMknPpBffsiZbbn/
	ihWFzoC3cO0q9k85Ps9gjJW+O8iuf6GU=
X-Gm-Gg: AeBDiesKD/wdflT/O2i+BnbmRIY+x127ZA/GJoQgaPivI6PKrGqTBq5B/wYItnSI4f/
	A/HZo/i5h90MwtAb2Tl8OgOH0zXpozzIhHTy7ZcUYpDfTTi0bmVwXVOI9gLzqEU1z6egXGJmDKn
	CT5zlkR+oKn3t2t+hqjyLjULKepbXSCiFP8hwcfUdpBluedHWP6SGgDvdoiH03Uquj2LTsa84R3
	jJh6FouCta5BcGb9sQ+GZRxhUuDYBOUCR+DQ/dLum2X0x5zCkTweZZlXufJfK7zJl9NqUBgDQdk
	DEmsrTRpRyiqZk8TtSV2bHQdv2YnrsL613mn9SSK
X-Received: by 2002:a05:6512:33d3:b0:5a2:7b74:3c60 with SMTP id
 2adb3069b0e04-5a3e7c46a50mr537524e87.33.1775687561218; Wed, 08 Apr 2026
 15:32:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260408175927.064985309@linuxfoundation.org>
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 9 Apr 2026 04:02:29 +0530
X-Gm-Features: AQROBzAtEbogomq4KyKNIbCpugVE-wqtw3b7mUoqya-hRf7ALQRyeOjieC_Muto
Message-ID: <CAC-m1rreAyZMXrJ5p1pR27Nwsiw_UEo6u-=OkOT77MqPYCgr-g@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/242] 6.12.81-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 9, 2026 at 12:12=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.81 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.81-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and Boot Report for 6.12.81-rc1

Build and boot testing was performed on version 6.12.81-rc1 using the
default configuration on both x86_64 and arm64 architectures in
a virtual environment. The kernel built and booted successfully,
and no dmesg regressions were observed.

kernel version: 6.12.81-rc1
Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 725a3d57414632c8d5a9c12e066813909965d1c8

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
