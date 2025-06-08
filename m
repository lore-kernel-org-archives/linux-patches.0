Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E0A18035
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 06:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749365597; cv=none; b=bA/WswK0W81d9pB8C+btO7esOktkmywOTguUVM27Ne6DKtpFxrImuGBVKPcXmsORu9BXb7xRJF8I9cyb/n8x3rRcZTXS1Xu8fHqZtqAMR01/teda3u+U4JtL4VaKotC5BJii1xJOXI6y9VVNS3Px+OcaJTo6OSrzsmeFRkxjpf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749365597; c=relaxed/simple;
	bh=fltpmOTVj6/s+N4xDOFhIyaKZHFzGfdIvwoqzO3sESQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E/P5AEyEV/EpVr5ILw5Rl4Xmt4mBVIOuKZGdM3oOul2Yajf8Woan8in+p4MxvnaNZZJTI/0YyQeiZNz4EfhGEMzi2JMz7HGgwoK70rSdLVkK/ZdQCAyZT4G/3JaWm3RhnFXbRRy7Mwo4nIRrOd9XazjWto2Jto00RnpahIQ1qts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yyxja0IA; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yyxja0IA"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-4e6fc4b2cd3so1056910137.2
        for <patches@lists.linux.dev>; Sat, 07 Jun 2025 23:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749365594; x=1749970394; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xNwcX+iuw1rpN6EnNjGPjmJquCREC1cuVweFhZ3D+PE=;
        b=yyxja0IAlkj3cuFpBSm4k0zJqfU/85ErNlo24XDstKLkQnLmze9Nsw8TSvS/nc7BZw
         FGEVReY91g8hyWxCS+ay8CZLR98ShX+0NHI21HzHuHefc2DyC+T+tjj6Mdsg8JFyj1Sg
         WiwgP5kLpw6fLQHYEuk0JtGbv5x08YedBaxxZGq1Lx7klZkqZun/dNJh5LIepj2GBfFe
         m+OSrZZQaL+nH+61oHKVsfcd8EW9r0R9bsoPVtBp0jL3PtzuPtyfuLw6ZmJUNaySQ1YV
         +VWl3JF+jstrwR/4OquASZwTK0hhbnwakRujqUsQXdLHxO6Gvjns4BIyDQqTwS0cizjZ
         SNKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749365594; x=1749970394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xNwcX+iuw1rpN6EnNjGPjmJquCREC1cuVweFhZ3D+PE=;
        b=JWnlnclDPZdQpVvqwlwY65ACD7mcf9ouL05PkfTxSJpJ9UfQOg4BGwtNrRmpDrk+qn
         eC2nJ/vCyA0Tm4D+RFz2dnZxWrrl96it3vo34o90zh5KJrThYxpM/sFgdrCi4XbKWkmJ
         bNqE3BK07m07zl9q+2YWgc1COIB6cRrEDaVsBKajMyjA1Mw2QZNKe2kbk3usde7JTuKK
         ayUPGlCEYEJ/CXiE9UlLRfgZQL/qyDniqETPd3hymsaKxdbYG7xh3osotdiMTvmUikqG
         cjYECzU+RondMAe1oYkL1NRcgpgq37P0Jde7h5hq7apwMEIiA5IcGUAB2OB1fdbBQQlx
         SIHw==
X-Forwarded-Encrypted: i=1; AJvYcCXPirz/KKJTazp6Ljy1liqEFzkHfjQ46y3sTzUOTCWWePJVbLbkDTQVBLZcp2FkJTO6KkmCq1By@lists.linux.dev
X-Gm-Message-State: AOJu0YwG49pdoFYQkX0cWOIeue7qQJtHR0GQxVm6l6Yrat0R9oZuc639
	fLJoBH4tWyj5gSLja18nte4KyfUEcyC8Y3hxHR9zSwOZloW+krouTIYSk1FYAPn7I9+6nq3rasJ
	FPMp+13GZjOFnL5BUFWex+WfJmYVcQpf/ZipkgQIK/snNVbdgyjFWHe2lPA==
X-Gm-Gg: ASbGncv9EJf83bEKaS0CvKg3dSNOSiq5YsW288StB3wnfdkclWZYBdxFEOyHxeoH41l
	JwCTAirJDOllaouHufLW/mGFQ8oGvXMJlzeVQffcIpEyr3f1/ZYhzp8rtijKHn70yyzWjkgfdNZ
	7eOtKLJYmPiuvJtvc3b2vydlZ9Q5qKQbMUsqpoSLdoF2Z4JoLmVDFNw2ycO/kiSNCXrvhkzcWsP
	cUGKZZdNkFfiIE=
X-Google-Smtp-Source: AGHT+IFhy6gwvqP26SFAPg0/upYqeLloMafe7Q+koiMk1eAonxrLWGLo+Ayjz6xIWKvXVlmT3KOFHOuAYOJZQuH2YUw=
X-Received: by 2002:a05:6102:41a7:b0:4e6:ddd0:96ea with SMTP id
 ada2fe7eead31-4e7728badc8mr7428119137.10.1749365594500; Sat, 07 Jun 2025
 23:53:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250607100719.711372213@linuxfoundation.org>
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 8 Jun 2025 12:23:03 +0530
X-Gm-Features: AX0GCFuv5wsl2DecrYyVr5gO-RMH1Fhhv5VPgjaw7xqi6ZCYvhnLsAAHIWDZfgk
Message-ID: <CA+G9fYva8JzG5iWMuJ70Rj8sz4Kq7nX__D2JkrpHviwo+5-woA@mail.gmail.com>
Subject: Re: [PATCH 6.15 00/34] 6.15.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 7 Jun 2025 at 15:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.15.2-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 04e133874a24969592ae14d2839d4f0040da5ac1
* git describe: v6.15.1-35-g04e133874a24
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15=
.1-35-g04e133874a24

## Test Regressions (compared to v6.15-50-g86677b94d603)

## Metric Regressions (compared to v6.15-50-g86677b94d603)

## Test Fixes (compared to v6.15-50-g86677b94d603)

## Metric Fixes (compared to v6.15-50-g86677b94d603)

## Test result summary
total: 255351, pass: 233351, fail: 4991, skip: 17009, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 136 passed, 3 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 46 passed, 3 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-efivarfs
* kselftest-exec
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
* kselftest-mm
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-rust
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
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
* modules
* perf
* rcutorture
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
