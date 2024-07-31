Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25431AAE20
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 10:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722420177; cv=none; b=hl7azVlT+Vqiunj+zZF8D6LnxcBJwYrNOfNm8NkucDMUTOlL0PNGEJTrn/0Y5Gt/yOrKq8+M3zmLNPKqZX3kP/A+75ghGmzPYDajFJfCsW8R2bs/XkvzFtMsIT/ubrhLGY7rgEU0Cpl5fsnVx5/wsu6e27zBV8QLQrqx4eo3BNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722420177; c=relaxed/simple;
	bh=mL9uusADg7a9HYOd2D6NR3WfFBGUc0zEZb9LtWE1w+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hHGtoMp5NDvUW4651Uyy1pvdDPkYpR78Kqhc5MOqZXv8Cmc5R8C2mYuf2zRI/iPEZSe9S+zU+r4Kqy7NQBvR7auh4cmkV9QAWflEOqKehAvBfsVcV9GNmhQH77MFeYS7n+KUu4Pe/q8EkHaYqSP6lsO55e/sEXTTjQZX69d/6yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IjrMTuc6; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IjrMTuc6"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-704466b19c4so3366870a34.0
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 03:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722420174; x=1723024974; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SxfIjWQM1I8ejdjTf/qmRKu9OVnpN31pitQiLexFUhQ=;
        b=IjrMTuc6PeF4wDDtEHO0XW0OAxgzqlAKayr/9z5b4kZb6w04aBCV7u45oyhErwJe7n
         m4pLpHQBXH7ZrL3LRPBMr09+FGZ9a0zsN7UQioZeWqw9gXdStvK9NLo5ekFPFF7B/He+
         GgDm+eC8UAxiwD5d5/Mk6CEvek34f63IFXMVscH8wnmxarKw1ULTW6ki1t1fgLye7p8r
         N+KEn0vo5M9EwPpTMwdvPfdeWFol1s9EIqE2aXPEGszwlm8hewJBr+BQPNk+sor+QNqd
         kos+JWsQW4uFsUU5DjUjPrFVYKrDH60CKXjeL0reLLuSr09Llc+9v8bIKwiXCpU0MFfD
         2wuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722420174; x=1723024974;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SxfIjWQM1I8ejdjTf/qmRKu9OVnpN31pitQiLexFUhQ=;
        b=KtGOufQfbi72Gb5jnxbxZ144bLJDpQEmExTDUZ94krb+69Z0asn97/gYKOxVKaSaFe
         AsBd4E96lsugiO1cM424ggmsEAGIZn7h/xVlxqWkx9qAN7aqVtHGPUO9UkDYpNXwt4UM
         y2BqkAZGGRgQ+F4fHrS0evsFdykV4DtaP9SIfjk0PXyacJRPc8Zs3g7kK1ZL+1XQ2mLZ
         X9iAw2okvw4a45k40BtEpqO2JiBrui8nqKEFIdVuu4Wzcwylw9p/4JloV8q6M0vcGEUR
         /ecpnRnZhz4GzS47Ik1l/Y8f2ckJ/9cEGYc296/bZ3XiRYW9X63OpxzK7pkcVB49a1xZ
         TyPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuIBDgCZtvfjpy9ZCatYBPBoSN8ikvo0+umgzDJp8B2GpLT8iSBUbd6XEn+vKuwKmD5pV4S/4K1n4XiE+7FlRDQQf7689gRA==
X-Gm-Message-State: AOJu0Ywrp7FG5aKV3Do2ORTYnp78teLpT+JbDMkz0AM8tI04mOMxiosq
	tYg3VTmRPAll0lRmNMRUXeqBLRLEV9/WTvYjXo61hGzJJ8SOR2jZFJymEeTe9+/kF9Ig5+t3dBh
	ZpSzva7RB4ikHpEEKDfxAj9TpntvA2ppKghskSg==
X-Google-Smtp-Source: AGHT+IGcJSroVYBHJ4TkHrJZqgxfv+JaZ6KCx5vx38yAmqvwXJaQ/hKH0lewS0khMKn07cEIxbvOWLW6z7FVQF7/IT0=
X-Received: by 2002:a05:6358:5292:b0:1af:1bc9:f406 with SMTP id
 e5c5f4694b2df-1af1bca22a4mr476871055d.27.1722420174535; Wed, 31 Jul 2024
 03:02:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240731073248.306752137@linuxfoundation.org>
In-Reply-To: <20240731073248.306752137@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 31 Jul 2024 15:32:42 +0530
Message-ID: <CA+G9fYuqGMX9OQOoWOO+NbjY0W74CRzcgEXPNSGZvjutpKWM_Q@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 31 Jul 2024 at 13:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Aug 2024 07:30:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.3-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As Pavel reported the build regressions.

The stable-rc 6.10.3-rc2 all builds failed due to following build warnings /
errors.

 GOOD: 8b6d47196ca5 ("Linux 6.10.3-rc1")
  BAD: 48651c22f448 ("Linux 6.10.3-rc2")


Build log:
-------
drivers/net/virtio_net.c: In function 'virtnet_poll_cleantx':
drivers/net/virtio_net.c:2334:1: error: invalid use of void expression
 2334 | +                       free_old_xmit(sq, !!budget);
      | ^
make[5]: *** [scripts/Makefile.build:244: drivers/net/virtio_net.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Steps to reproduce:
-----
# tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13
--kconfig defconfig


Build log:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.10.y/build/v6.10.2-810-g48651c22f448/testrun/24750484/suite/build/test/gcc-13-lkftconfig-kunit/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.10.y/build/v6.10.2-810-g48651c22f448/testrun/24750484/suite/build/test/gcc-13-lkftconfig-kunit/details/

metadata:
---
  compiler: {'name': 'aarch64-linux-gnu-gcc', 'version': '13',
'version_full': 'aarch64-linux-gnu-gcc (Debian 13.2.0-12) 13.2.0'}
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2k0KjlhdvqUirHA49IbPjeyDz6R/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2k0KjlhdvqUirHA49IbPjeyDz6R/
  git_describe: v6.10.2-810-g48651c22f448
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_sha: 48651c22f44864b641cfca023d360673cc46e900
  git_short_log: 48651c22f448 ("Linux 6.10.3-rc2")


--
Linaro LKFT
https://lkft.linaro.org
