Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21942189B91
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743079824; cv=none; b=hPGCPrTcGxspIaDd4uz/kpd30dAOgCCS1bbYPfFov1r/wUQMwxtWbAmkfIUIjb+ms+5fTRCBWkU0JgBN1VejGcXTQ6M5+I+fSCwSv7growqDT/wWO6LB9oiF9/3M2juaipE/ieJ47rN+5mB8nAYIJ9fWJQtKsjcca2XLiE/9y+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743079824; c=relaxed/simple;
	bh=x0/E2M0F+EgLHnBAChfuUY4dPirGmTNiotD1PkORt9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kmpIR8UIgV4WbpUEbIpLGLgl6BTAdGlJn2M+NfHa72ZAohbWOzxSJH0N6knc0/ep2xYEveckIIkFB56b68p8ejZeXWMa+oiwGsdp1aJETRW176rA7jacqgFZlbWs5ESwhJ+/CaKO2uJVGhPQ8caUX+qP04PMbK+RmEJgBPr6G6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=b2D8Sdek; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b2D8Sdek"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-86feb848764so440618241.0
        for <patches@lists.linux.dev>; Thu, 27 Mar 2025 05:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743079822; x=1743684622; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YxPf82X3yEknJZahIFwtaw08CtPbnq39I71FWEqVAf8=;
        b=b2D8SdekqCvqtz96Qs9uzW2CaT618yQcyg68BcY6LsPXUWLyH9dCni0GzF6khgs+6i
         GvtIppujvg7PluvpYKbKOfJmyR6qlMV15C5NSUsc4HFw/3yQnEP0R/t2s+cSMxuV1A6e
         vFhSAj41+lI3KyvaqgcAy3mwKeT3zAQkNrgPghLgnAOxQli96m1L40tB6hYYT8bfflZB
         Fn9HiRyqR+12MBNL3T4Rrr99BQxB6ElW8Lm67d+rFR19Kscczeai75GURYuRePKtzQkp
         JKUXxVTCX5oH5Z4bZm9JaEN8i2pIiaastSIof880+O0WHE64lJA+aP598lLwm4QWssqG
         5ztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743079822; x=1743684622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YxPf82X3yEknJZahIFwtaw08CtPbnq39I71FWEqVAf8=;
        b=TFxBV4hYCljuxcRbkEW+94K+173GUDCiSYa099Kh4bhuFpm5gNliRYXBIdc2Zv4r9L
         dx79T6inx/YIE6p9dJK/+SpKCQjgq2mq3mwlz68LIKBHcy7GCGpAFkZt/lMxUfi//wcK
         13+q7DdEZGkzKvvzxvE2zPmCFYzESiLsnPo1+o0Ap8QhgoVPcZD9IedxXtbcZrHmeu8o
         eMbyk+2uDd8EQodosGFjnZibLSX4BAuEx3Vmk0EOa1TtWP716kIVdNsfSyuyRdphtAmG
         OJ2RPzJQs2ffSYErkrpXkd9J1u/Fwx85cAx/H/eRBTrx7WodYf3Pvo/Zkhzhh78X1Y/A
         7FVA==
X-Forwarded-Encrypted: i=1; AJvYcCU/FYLRaZlNDuV6tbW9/ippSfcAPU66QqUCixdy3D+Fw9TFhtephJngJvzdRXV7yIcGaetGHWnb@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2jQlLAf2RX+RWqgNikTGj3nT7CNcbx82KjklBfsI5F6M3cB5y
	huxBSj4mrd3whdNhlm+EVz4E7ATfIfxZHbuxB7okAQRk7P9Rp+rVlYYeKZqfiz7xJsFvnmDaWLO
	2YSPzMzkb1f2kI4s1Z9GUv/gcpldi/fdh6yuvWA==
X-Gm-Gg: ASbGncv8XcY/g1SmJUoiw1YWQ835p6hlo6mJkzupzdpZGt3CkAZwJdTukj7E9LHK0rc
	UDfqfrPhFazAD7J7Vah5ayKcLrDa7GTmly8PaNUNBuQyjwgN45xT919qxM8JgC7JSAWFwm54iGM
	9SVJczbwjRISqj/Jum4ETZluKLHccHtlyCjckTHsDQ/sqF7nudx+reugkqnqg=
X-Google-Smtp-Source: AGHT+IHJT4hKKSEUXlpmrmhxoV+NJpCfU27nTmRX+PSKGFNIOYp+YtuJN7H/mSdObFWYsi6xV1D2Xzz8lFMeeJw8D60=
X-Received: by 2002:a05:6102:1529:b0:4bb:b589:9d95 with SMTP id
 ada2fe7eead31-4c586ef2197mr3532762137.4.1743079821716; Thu, 27 Mar 2025
 05:50:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250326154349.272647840@linuxfoundation.org>
In-Reply-To: <20250326154349.272647840@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 27 Mar 2025 18:20:10 +0530
X-Gm-Features: AQ5f1JqzxAAFsa6xfl6ahL538LTvEz_6T0WQuL-UCtRCOoqdpwdAR2e1PKOJHcs
Message-ID: <CA+G9fYsRQub2qq0ePDs6aBAc+0qHRGwH_WPsTfhcwkviD1eH1w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, 
	Leah Rumancik <leah.rumancik@gmail.com>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, 26 Mar 2025 at 21:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.132 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 28 Mar 2025 15:43:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm, arm64, mips, powerpc builds failed with gcc-13 and
clang the stable-rc 6.1.132-rc1 and 6.1.132-rc2.

First seen on the 6.1.132-rc1
 Good: v6.1.131
 Bad: Linux 6.1.132-rc1 and Linux 6.1.132-rc2

* arm, build
  - clang-20-davinci_all_defconfig
  - clang-nightly-davinci_all_defconfig
  - gcc-13-davinci_all_defconfig
  - gcc-8-davinci_all_defconfig

* arm64, build
  - gcc-12-lkftconfig-graviton4
  - gcc-12-lkftconfig-graviton4-kselftest-frag
  - gcc-12-lkftconfig-graviton4-no-kselftest-frag

* mips, build
  - gcc-12-malta_defconfig
  - gcc-8-malta_defconfig

* powerpc, build
  - clang-20-defconfig
  - clang-20-ppc64e_defconfig
  - clang-nightly-defconfig
  - clang-nightly-ppc64e_defconfig
  - gcc-13-defconfig
  - gcc-13-ppc64e_defconfig
  - gcc-13-ppc6xx_defconfig
  - gcc-8-defconfig
  - gcc-8-ppc64e_defconfig
  - gcc-8-ppc6xx_defconfig

Regression Analysis:
 - New regression? yes
 - Reproducibility? Yes

Build regression: arm arm64 mips powerpc xfs_alloc.c 'mp' undeclared
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
fs/xfs/libxfs/xfs_alloc.c: In function '__xfs_free_extent_later':
fs/xfs/libxfs/xfs_alloc.c:2551:51: error: 'mp' undeclared (first use
in this function); did you mean 'tp'?
 2551 |         if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
      |                                                   ^~


## Source
* Kernel version: 6.1.132-rc2
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: f5ad54ef021f6fb63ac97b3dec5efa9cc1a2eb51
* Git describe: v6.1.131-198-gf5ad54ef021f
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-198-gf5ad54ef021f/

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-198-gf5ad54ef021f/testrun/27785617/suite/build/test/gcc-12-lkftconfig-graviton4-kselftest-frag/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-198-gf5ad54ef021f/testrun/27785617/suite/build/test/gcc-12-lkftconfig-graviton4-kselftest-frag/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-198-gf5ad54ef021f/testrun/27785617/suite/build/test/gcc-12-lkftconfig-graviton4-kselftest-frag/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2urSwNctsyhQzf1j7dvt6nHemP5/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2urSwNctsyhQzf1j7dvt6nHemP5/config

## Steps to reproduce
 - tuxmake --runtime podman --target-arch arm64 --toolchain gcc-12 \
    --kconfig https://storage.tuxsuite.com/public/linaro/lkft/builds/2urSwNctsyhQzf1j7dvt6nHemP5/config
debugkernel dtbs dtbs-legacy headers kernel kselftest modules
 - tuxmake --runtime podman --target-arch arm --toolchain clang-20
--kconfig davinci_all_defconfig LLVM=1 LLVM_IAS=1


--
Linaro LKFT
https://lkft.linaro.org
