Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47E127990A
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 07:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761203262; cv=none; b=WACRXmnqREassFRuCEb/Tg2HXO9XAmBUNTp0TdsH2590fGpVjvICVv/BTuRs7Agy/bcpBrWitpMjnI2b4Ha5Ntemj9PrzHQ4tJwtHRtlUuN81YMRZvGBvidzfxnCJR5G6sZObwIM8pkquL8uIYDH2FBZfRkc1COZguY3SeOO0I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761203262; c=relaxed/simple;
	bh=/mxlwluWA5Lr00R11HzdOU6uUoGVTmh9rsH/zgvcFLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dLSYBoxEL/J7Q26ScThvWg+6c/Rsr4Z5zlzGFV4EaKG0jRqLt5A3BSRWkqnlK5q894GkLG8aX1oE7zwDNgLjyY+GlIJuEtGGe7TyhceifZh8JFlfrS1Oy9RXtNHourhKLp48ZLHVArnoCgqEqpLVyAOp0ULUIQIWcdq9TYywvC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NkIMTkfb; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NkIMTkfb"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-273a0aeed57so21767665ad.1
        for <patches@lists.linux.dev>; Thu, 23 Oct 2025 00:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761203260; x=1761808060; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DujqLCJmQFaZ3EINhri++XH5jZbl7g7hKcnWNYi4ETw=;
        b=NkIMTkfbWRD79KcS0tyPrRAWtrjl48hm4A/JyUOVbovSjSIsaoPHu+cnANz5UkU/PJ
         ZCDeW1v45/P5S+5KTOiffvUUDHQZkb78BMJUOvk8Fl3poRAgSSwV9dOzDUxspvnLpyFY
         8RGoTS49UF2ml1FABYCoEySd9N3k+3CRYSmCXf6LtLPW93tcOH8ZZF2a88NWdVhEWD0J
         mwdurAHP0xYUX6B2PCMhBcx+jN35nvu4u5kIq05ZY0TymCJp/4x7x0x1f2aFHR0MVkhz
         u/RbgGWBhWbhP1hllBTHPGYNFFJfUdpfR1NOUPokffPHHLzhTIN+F2y+88D2vKrO1br6
         UOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761203260; x=1761808060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DujqLCJmQFaZ3EINhri++XH5jZbl7g7hKcnWNYi4ETw=;
        b=HDUVWaPpl5xUDS5w+w3LgMg5N8A/9O7z0hPNiJmoV+RN/k9m95Irh1jMoEXQ8eAM7w
         AnqDsYDsFJsRrEMCwZ/EtNHcyY0NsQJ8A5Gbc1Ktwgb16BugrM/oYmrS0zyh+8kWEbSo
         BIsWtpQPTvVFqTCxUHLk+BlqCYB+HmkzQrxm8wmZWSRReQEFQLeAgje3B0WkSbZq3iLH
         e5u0yy+vKyZ0PDJnD7bBquVPbSzeFpoM/3pEgADs4PYcxNyvTuujX0pWf+9/m5+4vxuO
         qoWeT9GW8WTXs/l9zYAl9HBa1zCp79ixjtsWGgbzmZMmkntjJ1J40Rp61uM/hHaJiMl1
         3eTg==
X-Forwarded-Encrypted: i=1; AJvYcCVjQmhO9thMRv/brIY9J7zkDOjh2WbYTUPZDpmeqtvGtwHbC2Dvo3M21e33xNkpIzt7qz94ICA4@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3shIeDyAr+/SB3wO/UlyHpy28+JkTfZSxWTMFTatDj8S5e2at
	dQlQdlB/neLeCIoGnYtJw4Ga4ottqk8T4Z2g0yD4eCsfI8ElhC0w11SjrGfegbWZcDrgxHPAZSP
	/WEOHHZ9ugeRXtQ5iopT6yAcER/mNViAdIWvFpOwP2g==
X-Gm-Gg: ASbGncs0b8CgdvRrYdmvr+C9/pjh1wd68NrjRJiQzPuvQH8txCJiOwGOoflIcQCZGXv
	BojwPQEA20OoPd5isXjZnaRwu5osBRbMWcVYrxwiYnFfgvlBsh/xvPLiwlSIpraTsZtXlR3je1f
	MvLLdCv41MwdnIsudEcm2cQnC+gdR4ItC7ai1twKQ3zh73QpfnMT9wDkeSqFIQioLPlyFWZ8y6t
	oi9vMO09ag6hzgsc2C0bLDRXk2YztFqd3dgxk3RIqNgxhTF0qKl1IYBPWeNJVVABwBDq6LR43I1
	QqZgpgl79sYRyxRh/J6SITs/+yOPWKbkD+pVEEUT4NcQf6btK9GA0ET5fGC1
X-Google-Smtp-Source: AGHT+IEVKClhgjdibSHjHuDv8+MSTBfokXQUNOCuEMxiQ2XQOZxNtM5tq3eXuW0OJmRpgx0Z9SIU6xRbql+rNC5mX4A=
X-Received: by 2002:a17:902:dad2:b0:273:ef4c:60f3 with SMTP id
 d9443c01a7336-2935dff6634mr53232415ad.4.1761203260042; Thu, 23 Oct 2025
 00:07:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251022053328.623411246@linuxfoundation.org>
In-Reply-To: <20251022053328.623411246@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 23 Oct 2025 12:37:26 +0530
X-Gm-Features: AWmQ_bnQgdRMRzTsDLfS-gzQlMvKL6tN130z4WBOHnPtYJNjnFWNDOL8porM-KQ
Message-ID: <CA+G9fYtMUKg8uW6zefPNCU8VnHFMEy8G7Tb_WxTp2Da7uuJtDg@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/160] 6.17.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Oct 2025 at 11:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.5 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Oct 2025 05:33:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.5-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.17.5-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 3cc198d00990d2fccf1413a30fa9ecfa9a02d35d
* git describe: v6.17.4-161-g3cc198d00990
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17=
.4-161-g3cc198d00990

## Test Regressions (compared to v6.17.3-372-g396c6daa5f57)

## Metric Regressions (compared to v6.17.3-372-g396c6daa5f57)

## Test Fixes (compared to v6.17.3-372-g396c6daa5f57)

## Metric Fixes (compared to v6.17.3-372-g396c6daa5f57)

## Test result summary
total: 129304, pass: 109260, fail: 4449, skip: 15595, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 57 total, 54 passed, 3 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
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
