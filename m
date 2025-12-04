Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE7E36A002
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 18:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764871259; cv=none; b=YnBguvmV4CYpqS1Rr/8+HNOzMzoWB4aD6opCAYJeX54/PG4PrINhdhO2JET/4ftkcxEk6kOjIX5QKS5b4QyuuDeJeaRiTpE8wEkmdfqxc2dVT8gKwG1T/3KhSYsPO3OJPusq0oDAGQ6J7LvUgZUrFzr66vgInbHmAPhLlj+OVco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764871259; c=relaxed/simple;
	bh=AkT/MHdA+WbO70MEHMSPURhco0mqbbQwlaoRfxu0rrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LNWhgRPEOHxeMg5P9VZXMHhOmy8TXtukPuTZQQPQ11Cj4ZJlrlAfSXarS9/Gyy5gu+fKNsTPdbVPanuYbkxOdo5fD3vTiCJlDC8udgfwmxVdY+th0c1pnZa3NptmTzBSU0oxQbhYJeHJnn/Jwwp/0vwPVQdxMtFpfE7cLlx8Y40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qgug9ONu; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qgug9ONu"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b98a619f020so878643a12.2
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 10:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764871255; x=1765476055; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b4kaFJonuzYZVLvAuUlFCNJ5LpvqeGU0bsDP9xWjHKE=;
        b=qgug9ONurQe7HFj37zaXRpaVv2MLIpBrlbhAOojF5UPDQQ5sx5QmthP0MLq5g9oEEZ
         1QuRtwL5eOs3xkz83HZJkY75Dns/v9aDwTHIeCkPv6RtPb0eb4iUk3bUYT7tz3WYJVeB
         /YPn936EIA2fGLyt6xHpGlTm7eIEl7poBhffe0OQ84mIYjEhv2nE8UAaKoDjNJTNH+KL
         F/V2nqWsB3HgzX4sOmGnhov4oR/mSkiIgmLMPPtL4e9ZUG/S19wzWaYeRpyDojaRonbR
         DRaAeTThXqdNmE115KEHf3XT8mj/hT1A6SQnQhQGrq7ysV9sBj3SDuMd9S8qtVtfzj92
         5g6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764871255; x=1765476055;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b4kaFJonuzYZVLvAuUlFCNJ5LpvqeGU0bsDP9xWjHKE=;
        b=KOKKM9eCoZA1E/es+LVWO55J6QXf55XkASS5c+pQZAHM1jUaTSnK38lhFUiDEBajnG
         KBV8Nyl6o0EXT+zN+RM3jYOnmaQReQoTAoWkjfSs0dbw2y5kFC/wJNE/c/tggPE4WMxp
         sTYWNiX0oK12kA+TzDr84lY2M61/nWgaaoZd2o8q1hyVDdNugd0rucAE5d3/P3iYRqeL
         cJXB+Ouf8Ea2ej8ImI4Ud+fOD5tSHGQ1hjleVlSwDDh8aY/RhKgiPyppJiULkuxCEr/9
         UlIsDkIyJPvtuau2j7pEJm8j3xW76Bl2SkMI3jtm2DQc8RhqwSI6YXOy7rxK4Yspz42C
         OBNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdSWSaDIrtK025eTTOXnbe7Lj2+CERbLsVpHUJq5WPjgLbUAXwOq47HGOGjygVAbOD6Zb5xryu@lists.linux.dev
X-Gm-Message-State: AOJu0YwYgeEH8IN9vL+jmPpB0umSQmA90qjdUy8h2GGzeks9WNrjXWyb
	JSGTRSC88zlLjtHoCu6BP0R68/rG8942CzTWX0FoM5330Hddd+0p+jgkdF9PolHBnBB36Dc/VXt
	8dBCKUyein4F2Y3VJ8+IeezaDPUWoiFT6Y9d1x8wZe835Rq9nyH6eOCw=
X-Gm-Gg: ASbGnctYneh7RZmnDgLF06WwbNke3aFGPPY2D4qt0xlwGyz0h4IP1NxhAYy40IAlzSF
	AjWGsJs+0bjRmFuD6peHG+oWqckUG1Sx10hylEIRHtEeC5sXT/ZzqlzQ52zptOS7+rrWKcrIriZ
	Xz8EQ1XIwr3nd64j0CsoWmdpCmW7va3q5f6f3J2gpyr3CZh4AMB5FlmUi/EgJcKSQ7gynm6nRqW
	8iK+hgqB4tvfsuMdTDvXmIpIJM+mhEmPXF+FyvHkx3vLBSw0w9VdswWOiFb0XduKpaQ0Vh4OOav
	XiRWkLOG8C1CFEUz/0+mRPgj5ukh
X-Google-Smtp-Source: AGHT+IHMjgpsVlwYiWNNyRSKMR4UA4jvGJd9/H70NNgoJ44IQ9WNlkyfQB4M4mlZDtJnSh7vv9A2Ar6WYLGBRFfXrO0=
X-Received: by 2002:a05:7300:de42:b0:2a7:127e:bff4 with SMTP id
 5a478bee46e88-2ab92e2e0c9mr4061491eec.24.1764871253194; Thu, 04 Dec 2025
 10:00:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152343.285859633@linuxfoundation.org>
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 4 Dec 2025 23:30:39 +0530
X-Gm-Features: AWmQ_bne0EMC-y7fzl-jo7GD22l99epNjDmm1QaJlFZHFxuu7nyBRpdwv8Bdttk
Message-ID: <CA+G9fYu0LrqEAdnq7binH4vJpRdUtogTnKS8fHyw2XJ7=H0PPg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
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

On Wed, 3 Dec 2025 at 22:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.61 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.61-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.61-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 8402b87f21e8163831f70759368ad9a87192eb40
* git describe: v6.12.60-133-g8402b87f21e8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.60-133-g8402b87f21e8

## Test Regressions (compared to v6.12.59-114-g375669e5645f)

## Metric Regressions (compared to v6.12.59-114-g375669e5645f)

## Test Fixes (compared to v6.12.59-114-g375669e5645f)

## Metric Fixes (compared to v6.12.59-114-g375669e5645f)

## Test result summary
total: 121011, pass: 102647, fail: 3763, skip: 14233, xfail: 368

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 54 passed, 3 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

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
