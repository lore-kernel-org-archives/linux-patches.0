Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AEC1FCFEE
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733320486; cv=none; b=OAyORuY54FPtINGzIW9NhAZxGHlMS6/IPaEX0Ix84r1POrX3POmkRmi3z33CXShNdeXE9FhJCE4o9EX7ji3Ph+h1LVdhvG6eo+5NBBu54xosKF0eEiOMijYdQI1kTDK7ytenZN9KZj/AZdQQ3TpLeUfU6OC9Pyj33rutM09SHlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733320486; c=relaxed/simple;
	bh=9MFcB0mt+YP02nI8+TN97YFKOZ4xMNdsGYzMyXBbU00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cOzRBVWdq+nuZK9azAGyZ5UsdzA73Y054CdWTY4865wYLlKcgmzNqWwhwZo8FP+FyYQjEtEZ6YCr7JttPka0IgHrmMuaQZ8CgXUH3fh6GULq+8zw/2Y0dnzDEo67wb/Eox5+pBtslzILBVBkXFy6jzO/k9mUB1NTUv2bL9+mBBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UZSwy4Zn; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UZSwy4Zn"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-85ba8b1c7b9so509251241.1
        for <patches@lists.linux.dev>; Wed, 04 Dec 2024 05:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733320484; x=1733925284; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TF0Nwn/uxbQ0jRBIOm8Y4E/+CokY8zgI5N0QMm7aiY=;
        b=UZSwy4Znn6yhsPd+JOcXl72BZ84okTvkQD3smcjgr/lAEm9RujK/Ca6xNpI2mh5YD7
         AT+4hF3vQIPRwYA1ekXcQSKJGyqUfT+JRa0HJBc+eripfJLnLWWMwez7Wlv5YONttC1H
         RnuSgx8QpYI8g/2mjs1upAdeE+gz4HHnpzEBH87ziwikLlpp+nn0mN11IdYuxkzr251y
         6l5KPWdZEe8R80b1OOtVVdZ8oSAZ1owPU4rQxEJ4JDuArPdJhKqtBKIx//1oXbZLThic
         4AWEU9ktUBCATUgwf8Vxk63Cup2mVUynR912HpJh9dohM7bICFZOEAb77XB8Vgxdh4WX
         MPyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733320484; x=1733925284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/TF0Nwn/uxbQ0jRBIOm8Y4E/+CokY8zgI5N0QMm7aiY=;
        b=ATdy3yVLO2isfMCV5NA/cWubTMKkRoXdzyjW0i7nh1env75yE9/sdummiNNjYD7QHQ
         L0q9CPskuP/co2t77RBpuT8qUpxuM9JM/v/ptlQoY/8pQ98xoYHRqcC7GeK0ZmNdjFiD
         hMEHE248w0Crc5rTbQt89OUduqZk3x77LaKSkXnT37RHf1bO1YrfCRgsECeiS0yw0RwS
         NF4vYnLwHVPsyScywvdMvug00k17wcAy20CE36vHqFjiF7Wtir9SikFrMC8egkBeSaWA
         P2yXRg9I9yq9PlORgM3Wll+prOvxizjuTAJZo9ITX/ctyMBHZNq/1osjH/AqJoNGUn1w
         JG7A==
X-Forwarded-Encrypted: i=1; AJvYcCWg7bgdUHalwWKs3VhZ6iQZymvP5oJoiK8AhGFpFBxq+rXmSL67F7vI+rfV1QZPSJttqKMdiTbE@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4yyRzT6FlueElWz0b1DfHGp+2gUlQ+qTn7oKi2GU4yBYAoe2V
	M14xoXGkqie455R8N0vPrJ0LNdnVYRmTPFU2xi/93JYTNX3R/LrCbR58NCJjWNjR8zCOuUlwl6I
	nX2tZHDGdMRJO9a9pV4EfmtZXkBw3YxVytBBfJw==
X-Gm-Gg: ASbGncv8SYXeE3OV+31GfqTkzrRySJ8hT+qKUVhQ1Z2PbpBbBWPrOue3rWCjiRf+8uS
	1Td4G17nBwQ7ApNTP1Bsi7aB111QIGq/d
X-Google-Smtp-Source: AGHT+IG+Art1DPLFfgwUGb/naey5bBX8ZjccqsZMWtS4P6ycFMuMbOku965u7UTYzIZeMUUL9MgjB0Okz9w4fvlkr/4=
X-Received: by 2002:a05:6102:836:b0:4af:456e:5427 with SMTP id
 ada2fe7eead31-4af555d7c00mr30536547137.4.1733320483835; Wed, 04 Dec 2024
 05:54:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203141923.524658091@linuxfoundation.org>
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 4 Dec 2024 19:24:32 +0530
Message-ID: <CA+G9fYtXS+Ze5Y8ddtOjZPiYP1NEDhArQhEJYfS3n5pcLdn9Hw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/138] 4.19.325-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Matthias Schiffer <matthias.schiffer@tq-group.com>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Daniel Vetter <daniel.vetter@ffwll.ch>, noralf@tronnes.org, 
	Sam Ravnborg <sam@ravnborg.org>, simona@ffwll.ch, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Dec 2024 at 20:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> ------------------
> Note, this is the LAST 4.19.y kernel to be released.  After this one, it
> is end-of-life.  It's been 6 years, everyone should have moved off of it
> by now.
> ------------------
>
> This is the start of the stable review cycle for the 4.19.325 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Dec 2024 14:18:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.325-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions on arm.

The arm builds failed with gcc-12 and clang-19 due to following
build warnings / errors.

Build log:
---------
drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c:177:9: error:
'DRM_GEM_CMA_DRIVER_OPS' undeclared here (not in a function)
  177 |         DRM_GEM_CMA_DRIVER_OPS,
      |         ^~~~~~~~~~~~~~~~~~~~~~
make[5]: *** [scripts/Makefile.build:303:
drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.o] Error 1

Build link:
---------
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2piB6D5prhWVm3slY=
YXWoIGa8Rl/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4=
.19.324-139-g1efbea5bef00/testrun/26176978/suite/build/test/gcc-12-defconfi=
g/log

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.325-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 1efbea5bef007cc0efd372763792996843054d7c
* git describe: v4.19.324-139-g1efbea5bef00
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.324-139-g1efbea5bef00

## Test Regressions (compared to v4.19.323-53-g3b4d1c2cc314)
* arm, build
  - clang-19-defconfig
  - clang-19-imx_v6_v7_defconfig
  - clang-19-omap2plus_defconfig
  - gcc-12-defconfig
  - gcc-12-imx_v6_v7_defconfig
  - gcc-12-lkftconfig
  - gcc-12-lkftconfig-debug
  - gcc-12-lkftconfig-kasan
  - gcc-12-lkftconfig-kunit
  - gcc-12-lkftconfig-libgpiod
  - gcc-12-lkftconfig-rcutorture
  - gcc-12-omap2plus_defconfig
  - gcc-8-defconfig
  - gcc-8-imx_v6_v7_defconfig
  - gcc-8-omap2plus_defconfig

## Metric Regressions (compared to v4.19.323-53-g3b4d1c2cc314)

## Test Fixes (compared to v4.19.323-53-g3b4d1c2cc314)

## Metric Fixes (compared to v4.19.323-53-g3b4d1c2cc314)

## Test result summary
total: 27904, pass: 22045, fail: 211, skip: 5623, xfail: 25

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 101 total, 80 passed, 21 failed
* arm64: 26 total, 21 passed, 5 failed
* i386: 14 total, 11 passed, 3 failed
* mips: 20 total, 20 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 21 total, 21 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 22 total, 16 passed, 6 failed

## Test suites summary
* boot
* kunit
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
