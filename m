Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F58C1CCB34
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 13:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725629943; cv=none; b=rFJNq3pdVOzfXLzvIAoorHK1iI3dgfv1IsRJst8Wx+5bdzRho9paadvpVasgIEvMIa/6Ghh0ptZETQXqvFwZEI/YGa4I7WuyRUr3s72ZWmtNH2xYsRRiylR9IWHmw6V1Vra5MTCz60PENrrl5w6W0lfIrts1ATscfNdGlvWfoXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725629943; c=relaxed/simple;
	bh=QVsf0P+mtHtWmnrlhDzcepBHBPQIrcMSAMHPNfjf9QU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M7enYfgxXjGTFKKd7i8FFtWb2IS6jrxyftDRT7tgR3nmya2LIkxU/ePmBY7FoH5QCX/7x3OMqSf22QOcLlg6fUy9KD/7iAg4t6ryG0tPtkVY12nh5//VQ7rHhrCvU2jF81RZBoNECkmKpmnVH07fLBefbospG2JFUhh9plkghAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=2J+dmQlG; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="2J+dmQlG"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-374c84dcc90so1138972f8f.1
        for <patches@lists.linux.dev>; Fri, 06 Sep 2024 06:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1725629940; x=1726234740; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K+AqCSr8HoChcAFGwGiSrmlNcV3RopcVFPKN/wyqjkU=;
        b=2J+dmQlGK+O/tKElfclaX400EZ0bkeGAX2woww8m1WmRNUlm4cxw/e/b7apx+iZaUr
         aQfy3MFHgC0y0CcERXdtDck24hJyIQWE5Gfi549w3VFmb3/e7JOe4y0nZk3rpSfumm/7
         lhsqYiIMgy4ocGPde4N2eYxrX6UAerGBH5hluZ8gYiKA9yzhtY8G64k4onV12SEWl7kZ
         +Z2SUJy3535/KC6FD/EzWtkXUluyIzsVfj0dHHW1A7UsdtmHERGlLL+IoW7CdO0brgrM
         z3yD+S8mpDTD+nhDACBvhtfAL4KNdoPBnpfUmBVT0Vn6NUI2HSdmTlcVtBTMNn1A58W4
         eYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725629940; x=1726234740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K+AqCSr8HoChcAFGwGiSrmlNcV3RopcVFPKN/wyqjkU=;
        b=DJfRGa/frLeBAslzOuSIrFQrY5PxQbaRj938KFeqZgQXo7n5KNmnG53hMeL/u1hdFJ
         eaXm3ZfG2BaApLdX+kFx4k2gsUdxcA6fAr8Mk24vtw2U8e7ZncCfp5AF6HRdhgZhypSE
         ABV9vSwprj3DdOXmUXkaseBR5VUR8G04yXayC0lyvfuaEUzQ6kn7z+6anw8c08OEPhK7
         F5Wpzs69gpr4xTEIN2zNzd3Xn2hsUy1YEjtlJq6/L6je28Y+IKH89H9ksBUrMOQrYz5s
         1SxfN25QropSDRDj8o/xXEOsCXfXcWxJydTf3Wvq3Fq70g/DZakKV0p1QFqsQmYbDuvP
         54RQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+CschzWuCtzsnm5OqQd76hweBRFhOwI+yU7kp8ItmJg5EkSqOycGwkx6EHNB4iyayPOuAMK+W@lists.linux.dev
X-Gm-Message-State: AOJu0YwUV8A44W1q/AIdBF/7aPNfIi1t56NeI1MpYdRELxntY9xWd1GV
	K7+aDbnOfthSxp95VvEGr7C4dtcJmMdC+IKAcELs2LroNqIRr596VKTPsPD5gw8V8HkXSwSSK0H
	aygnlyHKLCc1UNzeys1XV2GGJJ+6/JztztmXe4g==
X-Google-Smtp-Source: AGHT+IEs0TymDN0qb1H6KzoG9uLNWYfnTI5aRT0d/XNeG7DXuzTNxv/klqY7eBy6ztM2Bw2F4aZOLOo9bzWg7LFprN0=
X-Received: by 2002:a5d:69cf:0:b0:374:b71f:72c9 with SMTP id
 ffacd0b85a97d-378895ca1a2mr1946306f8f.16.1725629939583; Fri, 06 Sep 2024
 06:38:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240905163540.863769972@linuxfoundation.org>
In-Reply-To: <20240905163540.863769972@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 6 Sep 2024 22:38:48 +0900
Message-ID: <CAKL4bV4GT2R5WZqzTXkAkY6d8eL5PLnnTKoDK-XXL9pCzj5nbQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/131] 6.6.50-rc2 review
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

On Fri, Sep 6, 2024 at 1:36=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.50 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 07 Sep 2024 16:35:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.50-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.50-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.50-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240805, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Fri Sep  6 21:24:14 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
