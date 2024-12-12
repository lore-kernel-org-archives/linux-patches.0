Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2B01AF0B0
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 21:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734037212; cv=none; b=XtjQF1PQepM/xWokVK4q5LHQ9rKm/4pTg85fBDDvKnMcWxtzzOs/coaTZYtYtD0x8LPPiTXplBBdq2ft1kbijKYPwnnk6G7BKc/0dVFK4ukk/DigMzguPRH+PkCRAkQ7GY5BXBv7Zay1HYqI8tjXTLUuBpuOMnYfnvgB88BPVdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734037212; c=relaxed/simple;
	bh=nC4EmuVP4ntlQc9bu8GJVOZYdMhzB21vlErGfWW8W3U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gWyX2RaruVYY1QHltQmZg+F7QbmISRKaPOPtfO98I0+CP6L7S9Vlbkn1xHgGWK7rTnGjVmQO6suz87fMgUXB5F8fViuQBJBjPtN7MQxq0Lo0Vk09kHePK9zTfT8G56f/F5ZwqPR+5hYE52p5iJ5p7ykNlHQteRrJf5E+6CBeOPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GZjBF2Dh; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GZjBF2Dh"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-85c61388e68so234625241.3
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 13:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734037208; x=1734642008; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k6Y1+WixMes/8w7Qpnpmgj9E+CHS4GlCyK+GluDTf58=;
        b=GZjBF2DhtRyQi/JnzJvDB7ypnOS1NAB6EfgbdMUmr1a1xUhJf4eENux5buUEjpXowP
         R2FQxQhOALgAGevqUuDlRKlCQqWtvKbSd7Ghz7UQiFMO17Q7JkWH4+Ee2ioM0ZPHqllj
         FrGLgx5t2Al7Y9GT52vBMozHXwMpA8PRK+cosqfpgOL9bCUPWO+mQiYm6iHVNNt8GiDO
         jkls1yDyGp1ns+KjLmYsHsw2R5FlLewgW7wXZlYBv9lcCRdM6ILCbxccxpI56AYIp4hU
         eiZhsFxzfAxLl3Vrx3WVJj1QJoer8706pkYwcTGGpnkWh0TT08ONs7Bdg6yoCf/zMjaI
         zJWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734037208; x=1734642008;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6Y1+WixMes/8w7Qpnpmgj9E+CHS4GlCyK+GluDTf58=;
        b=DtsXEMmheZ7Kr8N8Z1EjtZ1IW63RRJEnb1k3dgZY4nVoUCfpc6x+gPjJRhKSU7CUl4
         v66PcukWw/Apnq7zHmtCUxsknWJ/6dJvQyZOxpTvoOUjLkyxPFK0cK0kkwTrcsL1cMHd
         axnHo3FHCX3NtFjbHgpv6a11V9sUzg6zME7vWLjaYEctawXfWBPoY7KOW+q138mU6Zld
         8uzMUzgPbj7WEkmRi2klctABrNZFc+N0OmdDUnN5YnlpdcGGGVvjaBmW3ht5XL38BzOh
         gBhABN1iUA+jVMEKRbVc9TI0vqJqVLCP4TYK/u3cRePz9938rRLvkoreEw2M+m70S5YJ
         zFxA==
X-Forwarded-Encrypted: i=1; AJvYcCXSvDq/XTTFHaRq53XDbYJc5OCB40CUuDG/G6DweD8yIUfnvvHx0ofI7u+8fidxVjZgNqgZY0cC@lists.linux.dev
X-Gm-Message-State: AOJu0YzMPua5dyqL+E+WPAmYAQPaeuo1UgqRPQnuNGewrDiny3GOaR6F
	fAFV1LQko1BODjWz4NaLIIoL4siezvwmogxeuf/OQQts6jJcPqY1IMEOjHb+TjJg74gp/JAzGqR
	hp+bQ79kHqvOhuPzd7j/2g9yUQp9pV9lm3YD7NA==
X-Gm-Gg: ASbGncsmLc43aZCt9O9QK0vZfo+WTXIZQd9JfZauFfs3MJI4BeAmHA5qVATZCwVb1lQ
	xKYx5bEUN8hfNwWiaV8u0YT098BSN2Ed2U9kK
X-Google-Smtp-Source: AGHT+IGdvT/mhowuOXBJ2aXodZzIiREIHRQvRQBno0frewBNX+LzZcApS40ykgaLhTzbQyOr7inpeeuIlg31e3nkwkQ=
X-Received: by 2002:a05:6102:1591:b0:4b2:5c2a:cc9d with SMTP id
 ada2fe7eead31-4b25d9dff21mr592214137.16.1734037208538; Thu, 12 Dec 2024
 13:00:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241212144349.797589255@linuxfoundation.org>
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 13 Dec 2024 02:29:56 +0530
Message-ID: <CA+G9fYu+u4a+63vCCeLo1LdWhvK75B9j-znx7kp2ZVtzK_H4AQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Dec 2024 at 21:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.120 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.120-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The powerpc builds failed on Linux stable-rc linux-6.1.y due to following build
warnings / errors.

powerpc:
  * build/gcc-13-tqm8xx_defconfig

First seen on Linux stable-rc v6.1.119-773-g9f320894b9c2.
  Good: v6.1.119
  Bad: v6.1.119-773-g9f320894b9c2

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
-----
/builds/linux/arch/powerpc/include/asm/page_32.h:16: error:
"ARCH_DMA_MINALIGN" redefined [-Werror]
   16 | #define ARCH_DMA_MINALIGN       L1_CACHE_BYTES
      |
In file included from /builds/linux/include/linux/slab.h:15:
/builds/linux/include/linux/cache.h:104: note: this is the location of
the previous definition
  104 | #define ARCH_DMA_MINALIGN __alignof__(unsigned long long)
      |
cc1: all warnings being treated as errors

The bisection pointed to,
   mm/slab: decouple ARCH_KMALLOC_MINALIGN from ARCH_DMA_MINALIGN
   commit 4ab5f8ec7d71aea5fe13a48248242130f84ac6bb upstream.

Links:
-------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.119-773-g9f320894b9c2/testrun/26283233/suite/build/test/gcc-13-tqm8xx_defconfig/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.119-773-g9f320894b9c2/testrun/26283233/suite/build/test/gcc-13-tqm8xx_defconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.119-773-g9f320894b9c2/testrun/26283233/suite/build/test/gcc-13-tqm8xx_defconfig/history/

Steps to reproduce:
------------
 # tuxmake --runtime podman --target-arch powerpc --toolchain gcc-13
--kconfig tqm8xx_defconfig


metadata:
----
  git describe: v6.1.119-773-g9f320894b9c2
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: 9f320894b9c2f9e21bda8aac6c57a2e6395f8eba
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2q7iTg4R40CXEIVAGM9hWTEqyjR/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2q7iTg4R40CXEIVAGM9hWTEqyjR/
  toolchain: gcc-13
  config: gcc-13-tqm8xx_defconfig
  arch: powerpc


 --
Linaro LKFT
https://lkft.linaro.org
