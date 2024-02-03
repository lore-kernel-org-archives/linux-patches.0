Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97A35D906
	for <patches@lists.linux.dev>; Sat,  3 Feb 2024 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706968141; cv=none; b=WdyVnoJmJnevfmQx+ZVQsXmlnYWBknia4VLpp6qM0k6UOz2fIP1KHHNvdL2lULrCX2lqd/YJTxNoAWyz18whiL1Ha01AeMfoY+MVYe5g+ATpJNnzCzQRO4NaNRQT9TyNU99plP0/5F9HkNAu2aAjsurYD5oL6JHjl4SjskNJblA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706968141; c=relaxed/simple;
	bh=zrF3irUwnrdNP7FMC6C5/C1TKOlChsEbui8AaDKbpBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BERY9yeksY+UsFETQGotZ2mLJPB5PW+i8vjTo3FfbvRJnV9Wy5o8V63A9ju6p3D7Oz8Lyyr5I0sdP8g5Hudb8QFHqWkZtd0O9qyT5BtEKxZh+p9VGyL50BnH6uwC2UJyLB97w12HxnYfmyp9tEG1p2H7YQnfsjBQ9DMPWdWXs30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=EBmvT866; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="EBmvT866"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2965b7bcc89so565007a91.3
        for <patches@lists.linux.dev>; Sat, 03 Feb 2024 05:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1706968139; x=1707572939; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0/nxMUqpRTi8jjAM49HCOb52nB9yGpz/fFP3sr9Ovg=;
        b=EBmvT866owk1enEIqYH+RprW7Yjn/jM7d92U/C+PjiD2k1MLyZuM5DzedhIbuXqyZF
         /Ajf3mmwfOtOF/ansjx5F02K8QjyrD1QLGYGE5ItxQ9cHQGKCGcY4TEHsKXSN8OdZgw6
         uAZTNsAMGEWPHAEOJdPMOrlziJuVKPJ2yrXi3AXfEHBa3OA3oVpn1+OgrQje1Dhcf0CF
         Tli4vt6AZpG8varFk5yVRFJzult/nP/FYBvXSWQiN1ou9Ak99+NQOXYKlfb64Bn9wBQw
         qMuWbEyHLim9CxZba7LLd5JDjKubWCsIvxkw01FHOz3TwJLRAWwG8kSfYb3FwVXB0zSB
         XfqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706968139; x=1707572939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F0/nxMUqpRTi8jjAM49HCOb52nB9yGpz/fFP3sr9Ovg=;
        b=O3YhWgCzBA0VPzAcgd9XJaVqOMBE+O0dRIy2WvN2mVV1Di40NUSiefF5nBlHF9+wG2
         URXEU1ttWWgt6x6s/v7fUK3b9Vc13WJDdHg1B4KllDZBoyDDlONNShg3e0uBSDYoK09Q
         JcyzYlxi12sJwl2IF27zXFlSwHzbSyI3Azh+9w/7hpMQG7G8qUu9JNQ0Lg9ByAswuZ3h
         F3zQsy/W/drHz2acC9RVIYS4ioPTH7x8tcHtxxEDuFe66R4rXXXKNU4IXAE50Qm3BIef
         P/CGcuakDPGFD/1Fpoe1FW8BH+73WvSR8bfPjsN3TjnzQ/mn8zMUY0UXI3FI6wa2Y3V9
         vcVg==
X-Gm-Message-State: AOJu0YyM+xfu8S41FQP5JFd4+vJyiOhNJAZ64lwZv1aNMsBQ9y1QFqfG
	Wa+EnBKSABH+aWjzZfetb7dcu7VIKC/FfMN5wb7UNWninY4dcBsrz8YJoVo25XgjUHCJ2o3YKjq
	fFC36llt3tkhkbipdqzsbN+0WyKHq84F1pt4csg==
X-Google-Smtp-Source: AGHT+IEocWB16L1EG/HpxOXkrTVWk8Pkve8M5gMV7M9fc7jLH1KbVGt2V/vu1tsLFiZmtqlSbNEGm8aLlgF3mID0lic=
X-Received: by 2002:a17:90a:d717:b0:296:5c13:6ea7 with SMTP id
 y23-20020a17090ad71700b002965c136ea7mr2095454pju.25.1706968139041; Sat, 03
 Feb 2024 05:48:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240203035359.041730947@linuxfoundation.org>
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 3 Feb 2024 22:48:48 +0900
Message-ID: <CAKL4bV59sRxqmyn33Xyh9uU8EMxytfqqNFAKxAdFALdWXzr-pQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/322] 6.6.16-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Sat, Feb 3, 2024 at 1:16=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.16 release.
> There are 322 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 05 Feb 2024 03:51:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.16-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.16-rc1 tested.

Build successfully completed.
Boot error.

After selecting the rc kernel in grub I can't proceed further

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
