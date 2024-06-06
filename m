Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281C6195B11
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 14:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717684282; cv=none; b=uP0lunRU3WQIjB6GHHkbSGQiHfywYuJV3k9bX9GWudKMM0c80pugvYYqbV6pbPLEeQVAtyH49vL1v0icXqFsdjM0M+w2l2+SLqLwdEvtRh52CPhHYqFjGUkMWcvVceh5xHHd9rM4GFzY59wim+p+s6TmqEjGuwGhntZ71nbFV00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717684282; c=relaxed/simple;
	bh=rmmMpzdyFfWteamtgVIF5tn4EX415jCjZRCHwTpxgvE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NyCKYnGJ5v+B0QHMP79UQBIYv5maED3+JDVABGXN3wjZ4hdZaz+dQLgO8EhcRTIeRx10lIjgR4xDHclIfr0yETpRYzm4E6EFBHi+1wgqk5Z7DcN+tIxW9EZRx5OXbawW3FcR/tqgOxWu75F1tZE2jZoMIe6+YJipawieNPGTFa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bfQyRT/e; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bfQyRT/e"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2e724bc46c4so11423101fa.2
        for <patches@lists.linux.dev>; Thu, 06 Jun 2024 07:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717684279; x=1718289079; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LC4tRTIHi//VBdNQZVHv125hh2tQ2QXg5+VbtzAPUpE=;
        b=bfQyRT/e2PoIEvfxwswYY0RtPoXnvIRw6nYWheJMiEQ922xZjItFeVdUmvtL8crIQn
         WX2VTEq1RoVZCbweFhASVtKUq91eDy1sBsaHgI3ocrAgLR0KHcAzUXZWlcbR4ebormPe
         /O6eA1eWl1Zi3vwmd+aORMItNnzsrapak5gcXv39itQvnJ5b35VJeDQrp0Yw+viYd3Is
         m6jhRVDjDnQWlEEn7PWzNb0KY4O99Ww2BgslBUQCHNC2uTiWOeB1YkWuskHqq6acwSaI
         S8yppwwWS9PkaP32QALBoJ6ytXN7HBTTv2dKQf12a5tVsKpy2wk9fMlIWyIoQmMaRqj4
         3QkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717684279; x=1718289079;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LC4tRTIHi//VBdNQZVHv125hh2tQ2QXg5+VbtzAPUpE=;
        b=O77AlPHaC70fusQ9dBEfgcEgNzulpt45QBIk/ZCLVzEiPL7fnmxIPgAaf4rvweSjoO
         PR9xoWGNuNtARWaLE5796NgrQrNxjxXU9AS7fAThDOPOnhkfZ6ifwWd2WKlzjlNQG/PS
         5/OMHetzNDTkrHbVrng62OXdfjnSbhuGrGbePRE9EiLw17v0Uu3LxRrQZ8KehX/HwpSz
         Iu5vAK3WGgo+kXjvkiJBXZbWPmRB01+gr87/3pW1opU1IBnd0mdu1XhvOgut2Q8TxKcE
         qrgcn2/f0R3CaGP5/GOWCJcHPwu5Ts+HR5cAUUN1xQn1ebLjtM1E2/lm1RAvRN5e3p6I
         hWog==
X-Forwarded-Encrypted: i=1; AJvYcCVR/NSB1ITNFfTvOdylYrR0Ty9dCF/gRK8c9D7kzrcp+zN3Gsl1CuDGQ3iJ43SvtYtgeQjlREgN9jy6OC8f3uwJJFEZDkE1wQ==
X-Gm-Message-State: AOJu0YwMq05GSpbOCSsoQIWfLagRjq3BwJTIF4KJG2618QOWM3dTSfv4
	QKeFvjMuntX12NH3OFwR/lfJX/6r2EuR3d904ns44bq2NiKZERkXRR8YuXX6eP/gbeOD47rsb5k
	IbrxQwNpi+qouqOBQkJ4ozXj0oU41w3dk2HZtUQ==
X-Google-Smtp-Source: AGHT+IHMLnBPcN3irSS+eA2p+kw7vDvQ9FAixpR7MCh8sCi1r1oCN3gjs7NJKZlOVqI7Ebk24TeiFHvs2oANd1cDbag=
X-Received: by 2002:a05:651c:1504:b0:2ea:7a0b:7935 with SMTP id
 38308e7fff4ca-2eac7a08d3emr36700041fa.24.1717684279295; Thu, 06 Jun 2024
 07:31:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131659.786180261@linuxfoundation.org>
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 6 Jun 2024 20:01:05 +0530
Message-ID: <CA+G9fYtMCm-iRDfhq-H5nENO=OyH+wN+HfwHUhandK0JKV_nnw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/473] 6.1.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Jun 2024 at 19:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.93 release.
> There are 473 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.93-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The Powerpc build failures were noticed on stable-rc 6.9, 6.6 and 6.1.

Powerpc:
 - maple_defconfig - gcc-13 - failed

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

arch/powerpc/include/asm/inst.h: In function '__copy_inst_from_kernel_nofault':
arch/powerpc/include/asm/uaccess.h:177:19: error: expected string
literal before 'DS_FORM_CONSTRAINT'
  177 |                 : DS_FORM_CONSTRAINT (*addr)                    \
      |                   ^~~~~~~~~~~~~~~~~~

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.92-474-gd2106b62e226/testrun/24218239/suite/build/test/gcc-13-maple_defconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.92-469-g50926b327d43/testrun/24206687/suite/build/test/gcc-13-maple_defconfig/history/
- https://storage.tuxsuite.com/public/linaro/lkft/builds/2hVb12s1n1cz2MGh802HcC7iWkd/

--
Linaro LKFT
https://lkft.linaro.org
