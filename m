Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2901A01D7
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 20:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721161168; cv=none; b=ai/p/yTfLul5LJ/VLE0SuygsXztJewNFWZR6mJjHVpUMb3SYGg/6AaiDOBEGqETPQJ7QYX9vsrT+08ECaZ9dsUKTqUvPtTJ5s3nOkItyAqH67pqG1t3+c7UVFbyfZ+YgJiS2Q85vv57Mks1hU54NRl198gb6jLbWIjQL7w9uMNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721161168; c=relaxed/simple;
	bh=xRs9X/zIuhjyr4G+PAXlBtEleLmm/4QgK/3XoMAkxuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WErJba8zN3rftFBX865UrGmDHyyTh6zrUHk7bXOE3iWDsIxhKpneu89hYtLjiZtSIXh6XYyBa1OxluoxyyGukGkn7AATbmFHuhNjzoct39dB+cOIefk022Opj1M8KbGeo63MYl2sRw/0dwkN0kM6PvoCOUkmNz90UdG9gGMHm7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dosQuL9Y; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dosQuL9Y"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-4f2e147ee98so194627e0c.0
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 13:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721161165; x=1721765965; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ShLOYvKi8vsHBAFo9bp96se4Div2YHM9RNeuoNs/3KI=;
        b=dosQuL9YTCZeinCzGFHGh3BGEvfxdrjhO7v1aLWMEkwFvXa5Ad6s0/jem+bdgM96VB
         7KJv4po45Pwoa3ato64Y3aYo8lEgh3vqoBYGELE3iVk5AGtkoNSsFTQ6YvBCxb/JYTcR
         fapUNuxVt/h/0/xKk0u5U/X9Kj7QrmZP4RDf0RXLiX0qjd3q2t3dfeawXHTZKm3cBMlj
         xZ3AZd0BJyeQLRtN/Y3CFT3iIepson7qvkc4fzM4NuuuVMFb1RBBvK6mjJZBkvNLndaO
         lDmxNZqt0YmBoIlknuuvln2t9IQzj1eX1lP7NoBXgPeBI2S0u5KepJsrXkm0V+jb6EZi
         r8qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721161165; x=1721765965;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ShLOYvKi8vsHBAFo9bp96se4Div2YHM9RNeuoNs/3KI=;
        b=XHHGzLLlrD5u08DLffgYI4VYgYLDtcM9frydZz+BDGQ8ib5YGEAerWrxvDw4bTjeQl
         Ch1gVuCSyWbrxMkpqL6hhbMYh+rTQZWT1FiH5X3eFtDqT/K4IpFNyQWYltndCmBg5oSj
         zEyzTZKVOyREYBY3U0l6qRWdOt6KYKGH8j0PAQ6aZnMVOmvTTUEv80TT1o553Q61jERk
         NwcMF00RtxZsvJQmLwL91miBgzpJN2vXC0tCO7hR5IAGTBs23/cQwb2QYKK9QmJ/Tt8F
         ebJKcrvNo1aRsItql0sbakWeZCoQ+Ps2yXJRlK1YNdkSlTWzRokzy1IwQZS+76S756wb
         kWaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpouZw7WOo4QkuBsMt/YqKveOOT1YVhNmaTvXF4fOsJI3XV+UYTymUSfASTfMp5Mt7HsEzorXuFdvDoGPO0cp6Iwrp7TbXzA==
X-Gm-Message-State: AOJu0YzYZo3geyfciPcfFI/XUE1XAjuvx1IO0TYxq0Vt13P1SOQLB3Qy
	Gw5JHHZSKOd8bZ6SwpEJrlDNaZYRKpP/lNDazAeZoBIqe1ZJIyA6vzGYsUFrUGWLjL86MINHzQf
	KcgSMbXWRoii7N0sFToXWWBlxC80dHo5wK21yAw==
X-Google-Smtp-Source: AGHT+IEhFbbeQTqWecix0OTUYlT5I7+az0amKdkeLMhx7c+cOrhFs6TyPr8ulUAYZZmQ7DVatjck7YtX+wTCXehOqto=
X-Received: by 2002:a05:6122:1686:b0:4f2:f2e1:5f04 with SMTP id
 71dfb90a1353d-4f4d714aef4mr2572075e0c.8.1721161164744; Tue, 16 Jul 2024
 13:19:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240716152752.524497140@linuxfoundation.org>
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 17 Jul 2024 01:49:12 +0530
Message-ID: <CA+G9fYvVaSX9Ot2vekBOkLjUqCx=SbQqW4vWhypCnGwwBmX4xg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/144] 5.15.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Jul 2024 at 21:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.163 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The s390 builds failed on stable-rc 5.15.163-rc1 review due to following build
warnings / errors.

First time seen on stable-rc 5.15 branch.

  GOOD: ba1631e1a5cc ("Linux 5.15.162-rc1")
  BAD:  b9a293390e62 ("Linux 5.15.163-rc1")

* s390, build
  - clang-18-allnoconfig
  - clang-18-defconfig
  - clang-18-tinyconfig
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig
  - gcc-12-allnoconfig
  - gcc-12-defconfig
  - gcc-12-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig-fe40093d
  - gcc-8-tinyconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build regressions:
--------
arch/s390/include/asm/processor.h:253:11: error: expected ';' at end
of declaration
  253 |         psw_t psw __uninitialized;
      |                  ^
      |                  ;
1 error generated.

metadata:
----
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2jKu9JqgTsYkPJ9AeEnsDPajz9p/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2jKu9JqgTsYkPJ9AeEnsDPajz9p/
  git_describe: v5.15.162-145-gb9a293390e62
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_sha: b9a293390e62ec049b3795fd1538a2d2654dfd0e
  git_short_log: b9a293390e62 ("Linux 5.15.163-rc1")
  toolchain: clang-18 and gcc-12
  arch: s390

Steps to reproduce:
---
# tuxmake --runtime podman --target-arch s390 --toolchain clang-18
--kconfig defconfig LLVM_IAS=0



--
Linaro LKFT
https://lkft.linaro.org
