Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E054246BF
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 11:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738841313; cv=none; b=Ml2SR+Sa978dEGQ3v1v77J5qiLwm6J1FKBVmso9Xvro+3wtUN5YOsdxs1uzTIvdoNoO8zMvHooon81KlDK6XJkHWNg2DGtlXIFG6nogK8k2EP48CoqMju4K8xMQQOKbgdG3BGuyzhnBCZOxWUOFm/fKZeJ68WsMNzBXGisy0bKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738841313; c=relaxed/simple;
	bh=gkvL/tIQOpjbV+IEHUwsroudtsX79+gQy7ra+TBn9ms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V2koaeFC0elRnPyaLPiixo/V8W4HvTShaxA2JCmxb+c7f+flLCtk1x4Kh4x7YMJTzZTHSbkq+zA8dhV4fMEcFy8sFr9pqExqH/yrDT4z2ixj5rwKfokAXvcAh7xdTq2JTF6UVPRQOPBq4e8NZdopRmGOVmc5Vj0+YJRc+O2FcHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zjQXfDbZ; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zjQXfDbZ"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5174d53437eso503629e0c.2
        for <patches@lists.linux.dev>; Thu, 06 Feb 2025 03:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738841310; x=1739446110; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xdTDdTuLvbbZnRC35I/8pWi+JuCtYdxpx4t0NnXNk6g=;
        b=zjQXfDbZAZnCQQ+D7sPUlIXeOlWuAYU0HmU/V04JFMXgoYAzmKX+FubyRJ0L6XLcin
         gYfbDK5yVzya5sIbmLQkyWxKlTETv55z6AOk8X2huBlfhKqhBcfLf6xJrVsbwR989Dvq
         TlBh4EMoN2sa75I9g2qTFaj1ShuysoUJ7/dFNqCaIuGjbFP/VX/DdzvsZzNu5cjuRPfx
         2IOUB+mLEkcS9fCGd1wMeYK1BVdoJFNQIZzZunf9JNW8lM3+NnRTxFqIDVG5/Ergo6cd
         XWYgfQd6UF+CpNG4nAJBWpxRlpsfAVqXCO6gTaA6B+1nutvMLiH1zGVppJ3IygO/IzRy
         8Egw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738841310; x=1739446110;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xdTDdTuLvbbZnRC35I/8pWi+JuCtYdxpx4t0NnXNk6g=;
        b=TMAfZcdB1/hx+wRYj/dGKtY2MCI/2Up4WHzsYPeHwImmZnTRs6EBK6RfPE+0FrD0Qr
         3XWwwXXx7cYTfiq1AQh22L56VpNN3yrIWDZ4WSs7lN5dbkfsuHBWJmN1/9z0yhO9cXEp
         JWZu1SobrE+ihK0IOoZh1QIlf0oDWYU5i8It5XCXWprw9UoAN25WaaehZf7TgZ/p0HTl
         +bhQ5XaUSyz9NtaR/pTB10sTMTMnr+Xhp8tkJ85XQq8t/ZPh92Oi8LdLLtE0SxYL0fFi
         6aSWiqFjg7kYU4trcTbZzVeFytJLXMa0ZJzM59iGX/2hDic9+8+K7HGT82YVFKaoboLh
         h3Jg==
X-Forwarded-Encrypted: i=1; AJvYcCV2REvwxleuXog26HxPVxKDics7V25saJtvblXXuSG5sis6n6Czj/Y7R4mQZuuuXm7j3NyCHvIf@lists.linux.dev
X-Gm-Message-State: AOJu0YyYu3TsJPJYPjTsjFyB2ccYlEbZENftLL4IKRfilADU7pbaUCUN
	/fj0VUFs/i8hFWYpRpY9VGButFUYhPb7mYL356oVKxKZgKKGzpNGkrNUkgpDqQ2DDWqm9kgAZ+d
	cZOdlfigtGOpeyWwds6lXr5Nsmo5CTTxSCa0GTw==
X-Gm-Gg: ASbGnctapz9VjPy2hh8+/R6xGiL/Mpw6h0m6ZL+OSLbXeqh6cczG2wgsZTxsb+QNOoH
	ei1kxjQaGfOPoRxV83fAKjbTSJ6gKuwaWwATfTFCHuXfk7XfWONuwvjO91M4ptpysvHQ6ZdxY1A
	==
X-Google-Smtp-Source: AGHT+IFVhSbR4SlXlIdBGR5/DW3hEWOyZBmOavtvcjBArrMJE2u+LJyOt+XjqQ6Rij82LJes4ZkKzTbmgfRma58x7Ns=
X-Received: by 2002:a05:6122:3409:b0:51e:f800:f7cf with SMTP id
 71dfb90a1353d-51f0c519723mr4006718e0c.10.1738841309685; Thu, 06 Feb 2025
 03:28:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250205134455.220373560@linuxfoundation.org>
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 6 Feb 2025 16:58:18 +0530
X-Gm-Features: AWEUYZkLyxExF5EDZlJh2dRl_k_H3fRPFlRe5hOC4Smd0GjRAWK4R6ruu_jcYyU
Message-ID: <CA+G9fYsREyVPJYFeVYK1yu1NxUdcLrLNcNtiP2Drjaczr4LgMg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/590] 6.12.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Anders Roxell <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	David Laight <david.laight.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Feb 2025 at 19:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 590 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Feb 2025 13:43:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on the arm64, builds failed with gcc-8 on Linux stable-rc
6.12.13-rc1. But the gcc-13 and clang builds pass.

This was also reported on Linus tree a few weeks back [1] and also seen on
the stable-rc 6.13.2-rc1

Build regression: arm64, gcc-8 phy-fsl-samsung-hdmi.c __compiletime_assert_537

Good: v6.12.11
Bad: 6.12.13-rc1 (v6.12.11-634-g9ca4cdc5e984)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

* arm64:
    build:
     * gcc-8-defconfig
     * gcc-8-defconfig-40bc7ee5
     * gcc-8-lkftconfig-hardening

## Build log
n function 'fsl_samsung_hdmi_phy_configure_pll_lock_det.isra.10',
    inlined from 'fsl_samsung_hdmi_phy_configure' at
drivers/phy/freescale/phy-fsl-samsung-hdmi.c:523:2:
include/linux/compiler_types.h:536:38: error: call to
'__compiletime_assert_478' declared with attribute error: FIELD_PREP:
value too large for the field
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                      ^
include/linux/compiler_types.h:517:4: note: in definition of macro
'__compiletime_assert'
    prefix ## suffix();    \
    ^~~~~~
include/linux/compiler_types.h:536:2: note: in expansion of macro
'_compiletime_assert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
  ^~~~~~~~~~~~~~~~~~~
include/linux/build_bug.h:39:37: note: in expansion of macro
'compiletime_assert'
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^~~~~~~~~~~~~~~~~~
include/linux/bitfield.h:68:3: note: in expansion of macro 'BUILD_BUG_ON_MSG'
   BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?  \
   ^~~~~~~~~~~~~~~~
include/linux/bitfield.h:115:3: note: in expansion of macro '__BF_FIELD_CHECK'
   __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: "); \
   ^~~~~~~~~~~~~~~~
drivers/phy/freescale/phy-fsl-samsung-hdmi.c:401:9: note: in expansion
of macro 'FIELD_PREP'
  writeb(FIELD_PREP(REG12_CK_DIV_MASK, div), phy->regs + PHY_REG(12));
         ^~~~~~~~~~
make[6]: *** [scripts/Makefile.build:229:
drivers/phy/freescale/phy-fsl-samsung-hdmi.o] Error 1


## Source
* kernel version: 6.12.13-rc1
* git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git sha: 9ca4cdc5e9841a39adf2ea1fc8ae45d28b4c85ea
* git describe: v6.12.11-634-g9ca4cdc5e984
* project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.11-634-g9ca4cdc5e984

## Build
* build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.11-634-g9ca4cdc5e984/testrun/27199296/suite/build/test/gcc-8-defconfig/
* build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.11-634-g9ca4cdc5e984/testrun/27199296/suite/build/test/gcc-8-defconfig/history/
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.11-634-g9ca4cdc5e984/testrun/27199296/suite/build/test/gcc-8-defconfig/
* kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2scp7S3yK4hl95VryTZn5t3cUVh/config
* architectures: arm64
* toolchain version: gcc-8

## Steps to reproduce
tuxmake --runtime podman --target-arch arm64 --toolchain gcc-8
--kconfig defconfig

## Links
 [1] https://lore.kernel.org/all/CA+G9fYsHGrgZsEEVvP0XMcAhLyCYnrCPgZJ1puT6cfQBCGUB9g@mail.gmail.com/

--
Linaro LKFT
https://lkft.linaro.org
