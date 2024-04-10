Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5041F17B507
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 16:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712768098; cv=none; b=f68+IzFL9SdvDd9aVxsoPnGW4zqYX3WBDcSrLNKXTke5c3Vlu1R6iTWIuppPTz5v3GQvAWuXKW/XyYTmjYsdf7VqqzzjAT0TcU2fEftsdvTNRm/y1vYo/DsJfOunkrugBO2ZRSThHVbS1iQ0GbccioUUwb1IUweSD7xzJLuDsy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712768098; c=relaxed/simple;
	bh=n/TcQYPfm6/UZ6rJXQxfLCh/AQmNhTjvnXPPsFZqbXY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LUELYXZbGqAtzP403FDfwV4qtcFEpUV2mDBY/Ek1r3UQEfenWDaTrjJbBcRWyEEyr/rxvQ1yxw/l8iEtBnQjai18M+6DETJr34IlT0oBpjPjjQyZha08lNOaOmbJ3d25PyiQORaygpi3vY1Q00yv29RKq1DTAIfapgTr4fciWR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b5b/ID1r; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b5b/ID1r"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-4daaeb7efa8so1547818e0c.2
        for <patches@lists.linux.dev>; Wed, 10 Apr 2024 09:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712768096; x=1713372896; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rZiEFA9WBXwwleYO92+UArt4+yOxriHtdTPKbUKrFmo=;
        b=b5b/ID1rA3rOQkNCDOcPOm+3xsbkNPk5lyLZTzWMFi4VKwOBP2BhV/I+WPiGxuuuSW
         6TqybUSZLqzm4f99971KdaLxniJNgTu7KOdke5Naki9U7k1DLgyBJBRECIMMBC4ZFg2G
         BE6w7IJIoOzJpAbC7Ro3tZof7jXKyDccc7Rd2z8QNYs0NMioY0s47lY2Fd+mBlWGL4kh
         zQX+RpEFMqHKP0E88OQNMtqnP4vHbR+RnOsIvOTVGaxAedQmgmNKUh6fc+twZ2+P/w2d
         oL6x4ql3Hy7PYtF3l4lcjioahgC6a/WZNhaQiNDKyt9JVajZV7chSFIylPKcZdGvByAB
         8d4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712768096; x=1713372896;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rZiEFA9WBXwwleYO92+UArt4+yOxriHtdTPKbUKrFmo=;
        b=gAE/ltfeKeuGbsX81+eCDd0bIbJqgZ4F3Tz4bbpTcJFzAH7HoEQ9Rl3o8OYMcz7FIL
         uhL0QYa0zIvH2YMpVa0wAMo3tFBD3sKH0qU6SBdWj0oBMXALInLa8MCoGDqK2DJAqVIt
         ebTsU8iYFrnTCwmvboUVOJjtA9mG5+mb6mjSiWCFa4JtxJdXH3EpPxWlzdztwuTUJ2pT
         bguFNJ09x2gWkJcF/4jzjfYaDkA6vpE4131MV3zqF+E8hlpms8kXsq+kwYnAoj99B+Lw
         ycRx3ywx/ylR9t8+HBEbZnQPta8I2cxaAEvac/MGfUHaQwn8a4k+/BxHlre9NddVRLuP
         GDgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWA+BKRJtWCzW1QiZo23ncBpt0r3pNpfULHXEeb3lNnf7KlvCynNotkRzPUhKu6+py3fl5q/gQqMW8Hr7lI8pZu3ENQvgEGpA==
X-Gm-Message-State: AOJu0YxmsUC8eCMTrrPDiE8oG7pdyRcqy/hQqIp10y3AFilNXcCssDM4
	zD0w0I17Tg0OP9tM6lMhzPNEC63ZXNm/9zImE93aEGl3lJv1s9a/RviZaz6It4G5499SrzdcFXi
	ERHq2UiGC+5w2AknqY3jikhV1LbI=
X-Google-Smtp-Source: AGHT+IFpgdk+MX3lb/xuXQycRWzWMfP+ZHuH8cpG8+mzc9SfHckTyXjkou/UiZWckDRb+NL+RF9WSDrHmlF5vOt0iFQ=
X-Received: by 2002:a05:6122:219e:b0:4d3:cff6:79dd with SMTP id
 j30-20020a056122219e00b004d3cff679ddmr3001650vkd.12.1712768096145; Wed, 10
 Apr 2024 09:54:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240409173524.517362803@linuxfoundation.org>
In-Reply-To: <20240409173524.517362803@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 10 Apr 2024 09:54:45 -0700
Message-ID: <CAOMdWSL=DzM3pSBgbELzQAeDL8Xc_mNJM+AwvdxutDMQY+BqkA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/138] 6.1.85-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.85 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Apr 2024 17:35:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.85-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
