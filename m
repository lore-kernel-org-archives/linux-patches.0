Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1BD2DEA96
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 10:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761646833; cv=none; b=ZhQw2DjGinRQ2nIp1LRXUY1d5FzRBzqw2xXXMmYm25UxLhiHulmcgn0PLsgmxI2HrEqmMZRvWwqFX/EXemyCqHR7Pb7RYfQ4z7NV2WDtYk2ZU31ugnXefdXf5LgiNoAtWCyMlF7/xLDmwehXHiB73e8qSNrfOM4uycqM/C+MceI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761646833; c=relaxed/simple;
	bh=eSFNiXFx43S3A4d+ejmP2xbSVcwXKr0EzyNrmVQhHKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aryJOmS4xMnDUySNsJQA6iEKXSGAiAcMScLQZc74ZuIRanltYC5FjAnGVZ6X/fqRu7/R/fRJ3P/MA+YuDBIMY9OLA/Agrv0txKdyp8Hd0oxHfrsB/0A2uXUZIkvLlo/zEeHlf3LkcOmWq0Yu2BwwOiNIhOc7WHHbZO4eXwzjZu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rQ5G1Yx0; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rQ5G1Yx0"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-29292eca5dbso76502135ad.0
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 03:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761646831; x=1762251631; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zq4sVnkdiYdepHbDyI7xtiG1vW7SU8QixEUbKdub3hY=;
        b=rQ5G1Yx0IuD9A47IoSDRk3fUhjwl2nrBlV2h7z5tW1evKLT5ZNW0ncLWW3umlbOWPI
         9tdBwzUFVJpZB2ty2pfDGBzmX9hTzQgxG5mguWfwn1veHm1fxrCYJdDZMF2vIUAyCSk/
         3OONxfbF1HfEyz0+rAPkLYFsBtrq7I/9xF8IGPzVKNankvNPl3jgA50EfVeVzXg6lbMj
         +YEWSGyZRnJyM5ezFBoGn3kmMZOHgUGBmufXo9ZTNSIQ8m3Yz5dMklMDI1qFDB19M/oS
         DAJ+jddqaBtfvJSehTrGeIcHENH8DfVThECnanbMe0RqSYDNPFK7NGMUqFLlogDcV4+C
         ASvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761646831; x=1762251631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zq4sVnkdiYdepHbDyI7xtiG1vW7SU8QixEUbKdub3hY=;
        b=lOJrpc8pfrtcIOIE7gIQWI6qNBWnMz44H58Fqq5nPbQMvraqR1pl50eYDoewhAgSTJ
         PRKW8O1BoM0K0Vl6UZ84sDC/O/HFvN/YhuZXG8v3OyJfL6onETMRx/nav/JeG9Z+Rrtw
         gdmsFzlkWVNH71SwzvCiarU/0341TAc97lCbkTGGkqXbCyn4ry9VY/F03/+6XDNH22sw
         sNxaC4xrAZolPMlGJT7/60qX2EDfLZUF0p1wPLmW411sdAuabYjrrM9pps7kC7Z830jR
         1JA2LZeLOntdVFB4qGhc+rz3b9hXMy2vk5r3jS4/2Ud4hAv9pGJVpETSxQhcobMSMUkd
         HbLA==
X-Forwarded-Encrypted: i=1; AJvYcCUoHWMgyTzLVpftwG5vFpcEsxHrQKwx8j0Y/TuKGbgvjBdM5pCDFDMF8epKOU2SiptyUeHFJy1K@lists.linux.dev
X-Gm-Message-State: AOJu0YyCq2wAzro7UybRjIdyQ05tAriE9BIIZ3nVUxFA292NbyK94r58
	NcY1dV2UkL53PmK3I8ECXmYl2tqZP9ZDtr3yg/E216C4B5Xagm97iLM7DbixgWgSya1kCIggMhU
	DBWvhzmDR5UmwWIVtxL9MMd9RvzUXoMCuqAWNIiY1LYC0BFtfrg9+dTvGug==
X-Gm-Gg: ASbGncuZQAXmAm7CRp1Gn3YwQ5gRbQ7rTslq2icniavYZGmrPv9FYKDRSqlU6kjnHV0
	RcfilkfKm4LU1ptbJTDcj6e5pnGf97NCRsR/auvfZRSxU6sZ7NamgFI4+yk/jN/bjcdRF2Rnpgu
	EhWnFkhY2FpKuj7ie9DX6HHprn24sLtwnVKZyXn5+ax90ZAnkGHtVfNutec6iqXn4JMUOZ0bQ06
	YlxKv8FepRXx2luh36UwfXF7/RN3+7E1mbSCSGOzkd/1BeKaBi8szdHQ5BzJiZjiatLTDN9UCEf
	BOA7H1OAkE+4M9yLnn4ocgs50OQkNkah1A4R0MR3NCOUI4zYPQ==
X-Google-Smtp-Source: AGHT+IFldgoZnTYpegshPt3WhgAJkKOgC2UfKDSM7I9r7rEprRzETX/+HEGXS3kOWvKcTAnMGtvDYT3HmFJ22tXW93Y=
X-Received: by 2002:a17:902:eccc:b0:270:ea84:324a with SMTP id
 d9443c01a7336-294cb507cdcmr34772335ad.38.1761646831072; Tue, 28 Oct 2025
 03:20:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251027183501.227243846@linuxfoundation.org>
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 28 Oct 2025 15:50:18 +0530
X-Gm-Features: AWmQ_bmdgCG3iPCBh-32nnzF4A8j0YtwyvHQpjYBoywaDuWUqsbGxGX8tLliR6Q
Message-ID: <CA+G9fYu9EFx08rvnjceS1jNhfjB3BPDtH-ceLuXYdsPtfntibg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/157] 6.1.158-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Oct 2025 at 00:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.158 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.158-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.158-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: f6fcaf2c6b7f6ed4e6ee10532555e1e16764c435
* git describe: v6.1.157-158-gf6fcaf2c6b7f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
57-158-gf6fcaf2c6b7f

## Test Regressions (compared to v6.1.156-169-gec44a71e7948)

## Metric Regressions (compared to v6.1.156-169-gec44a71e7948)

## Test Fixes (compared to v6.1.156-169-gec44a71e7948)

## Metric Fixes (compared to v6.1.156-169-gec44a71e7948)

## Test result summary
total: 86941, pass: 72310, fail: 2561, skip: 11898, xfail: 172

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 132 passed, 1 failed
* arm64: 41 total, 38 passed, 3 failed
* i386: 21 total, 21 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 10 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 32 passed, 1 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
* kvm-unit-tests
* lava
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
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
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
