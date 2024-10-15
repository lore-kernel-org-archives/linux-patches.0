Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE35147C91
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 13:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728999197; cv=none; b=Hc2WOIjaBEijXeDurKNLjWBR68wzcGc+nI1fx9yPmEy8PWrsgEeBm8FgKzLrEGGv3U21EKJ7MpivnunNyNFkLObyebqEi4v9VE2/6WxEdi0hK5+0TVfFD430IwQVYFX/NvvX3BBlLr3h2YdpTUDz0GwJJAVpqHsMGfk48O0RIJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728999197; c=relaxed/simple;
	bh=UJEXxmod9hwkTENeMk5+2g6dtyvgZ2h1Duc4mV+05xs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hL4eTtwkmtS+XhO5QYh9Iytv7uBP4vgwAqPIsCwBkz11ipAK3Ual+ATriJ7edUDDalbX/0C1vp7TxYqCENNFQZaDAJrTYXFoPmEDtW/CqfweJlYVs8CuryZktg3AnBeVFfjKA1FJEEAX5wtn6cOUdqnaUXlZnfmrvRn1KhFOAD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=BcJcqTAr; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="BcJcqTAr"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37d51055097so3214101f8f.3
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 06:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1728999194; x=1729603994; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QS14/1rLrV66qDBatRYaujSeYfhdUS/QKbwUq4VPEjM=;
        b=BcJcqTArr9zzRqaB/21+vynmFXBMebhhb2uEDZuf8lPVnohORanM6j4ghzmXdH+l+A
         toWCWPNgLhakuPKE/irI10/b8pMf3A256ATF0NuWQQciMjQzaoBLeM6KPEBohFPniR3u
         yd1Ps+WBMg9bSyAUpfGAeKkznrVzKVBlO4g4ZhLHkFyVTg8jhBC/58jPTsZd/GnCZxCW
         Ns68KY6Vz4Slej1egiGIp/tuduIzFYtHqSuL5FeWq9zIOphJG41CJfhiWXPdFySpEu4F
         xYDBRK5cGw8wvaGsdb+1dqgPF5U/DFkQRa9QQbaY96wJo/r+1JBMc//zVTSxJmUqJ8CH
         uVcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728999194; x=1729603994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QS14/1rLrV66qDBatRYaujSeYfhdUS/QKbwUq4VPEjM=;
        b=O144I473b0uCWN974IfRDWjk47DI/7YF48yd7OmWpGakmvMjKZV2FfpJY+YO3v+IHx
         8H3QeViAKOuI3pGqxnA7LcT/kMZrUyVOmkl4q9ba0EBoL6BJDBI2ijGMIpSB37QGjTN/
         M81SutWI2rOrmM9MlwInOU+r575YF55HqAfB73no47aCP5EyFOn2szpA1V6w0Wv71iod
         K0MFAI16ZzKSqlP0uxIhnyuREV/0xj4FVtsJHTrvVw95jv8Ovb/stxMHHCrdoA1nALNa
         n6l5cnONViQZt+NMaqLBnCvg6OAXICvVAt3LOR7lcA6smhY/ELn9cQRPVdVtVNDtGT9p
         oQ5A==
X-Forwarded-Encrypted: i=1; AJvYcCXfK1s2GjFVghEdeS7nr3zMc540ASurgCxiUy9DqcEDSN9ewltKwQhEZYjiXK7XFeimrTrwtJUa@lists.linux.dev
X-Gm-Message-State: AOJu0YyO102qPeNjSKUoC7MkClkrf2LbfyrppSmsIz/YkjTTCxKR7gCg
	0TVkdq0GXKyF5pRkoE5Rf2P5sxj9A23Y+6kTOgpuKXKXVZcjo/D3a1zGH0kzGF+BKaS8FWzXVqe
	Zn23WWTjqCBKL2kTwdX0+Sd91fXIxvHqgzytmhA==
X-Google-Smtp-Source: AGHT+IGNradBs7hA6tXJ03WnMFyglMyY4jCHENeRjpb48YC3HbpmmRPnxpuAwooOcuGkZlLWRPIWTDx0C/YHIDf8Dy4=
X-Received: by 2002:adf:f304:0:b0:37d:4fb1:4fab with SMTP id
 ffacd0b85a97d-37d601d21bemr6228186f8f.57.1728999194068; Tue, 15 Oct 2024
 06:33:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241015112327.341300635@linuxfoundation.org>
In-Reply-To: <20241015112327.341300635@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 15 Oct 2024 22:33:02 +0900
Message-ID: <CAKL4bV7WGcKbkCkfG-J8UtrKt5MM5dObr1c5RoKmm-TxfAVVkQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/211] 6.6.57-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Oct 15, 2024 at 8:26=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.57 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.57-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.57-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.57-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Tue Oct 15 22:09:26 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
