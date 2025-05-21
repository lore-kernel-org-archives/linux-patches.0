Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3DC253B7C
	for <patches@lists.linux.dev>; Wed, 21 May 2025 10:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747824591; cv=none; b=TqGNUjq186JnmlpMcL7QAaXfnAMypfNp9KzcwBvrCZwp+2unJ5vNEDFTWeHSVe1eExVW1oS10WdeKYuF1OLgc2/xp8hXEvq7J+qkzQCZUhd+uxt2A2Al+5S+0yGrUUSBYauU5wjor9ERJBiQjwhlchQv0m1cdSBhdvyjBRAPCvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747824591; c=relaxed/simple;
	bh=L+PKxNtAqKz4d/PVyTJfhGDYmbcAOUZoZDkHRkgwMHs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cBp807ZxaNYyBWKfb6bk5Mzd3U4IFB7TLgeY+PjLvhk5Qh8Rk57WPoT9Kihy4Zsd1RXKtbiGtWaLOzk12qT2paJN8XlkVNATRNcAond9Mva9NZsGQg/U8V/z9GEcnrdTSplHNPid3C5w9tXqi7XWq+3PTWCXnCovNnE1n0jj2a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=z4texuX4; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z4texuX4"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-52ef2d6f48fso1752582e0c.0
        for <patches@lists.linux.dev>; Wed, 21 May 2025 03:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747824589; x=1748429389; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EY1zsqMJNQl1/s2ogWzn/IUr1JVs4jZNJPWvtMfHcCU=;
        b=z4texuX4eohKoDucGOGybS4aLZ9fCoxprcmvmTIqfeZn0Fo3KrWpbtZJtFU8Eyp1l+
         4wL8bDLWUMGGwExCX8oywCklQEuauMWwcAZHOMGSxhH1auVEr0b0M9C5fSiyXh0acEQa
         Krsx3FwUnCmOuPOQOZwMmIJoBUaJreGOje3qGH96HUE+o0/K5jyX1yat6ygjOr2106zB
         ddwtxaqlrcYrRIUjf9U6+4EkvWy8p16qLN+P3hyjRz0MfqNp8l4O6t1KD55n2js0fROb
         BRX1gpEnuibGfJ10k7z4rn0PxQZXC7PTBbOWoOQ8eprqnYsEkv1f+y/bDl7hCdTQrXJx
         YW4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747824589; x=1748429389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EY1zsqMJNQl1/s2ogWzn/IUr1JVs4jZNJPWvtMfHcCU=;
        b=YmFUv0dEdemBxAp2UbAddunFISPHSedA7OLBkJ63yjnwvg/1HfKRdezFzKLwF5iqpI
         HrZ4gXxR6xIec6zUgvWkhzdLFuBEQtlWBJlG3N2e7ZKrgqLMezUWXBFXYWEijIsS14vA
         mXoVbZoHyW0w2h//wtU8QtwXJVmu5Z2BaC7yvN8gTxeex3O5Y51wDis1gQCZ5xn/6HFJ
         PtHNwQvyfawtWFz/5iR6A9S0YgnxMw84ekzXFyqdZfZcB2+QMNtXSzX3SzAtt1kWySzE
         DwvmDBUY+/u/66TTRQ3Cy9MyQpwwGo59gulrfZWXzszYeXZtlmmWHFQQDro7Vv2Msae1
         OHOQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/HGsFZpy9/G2Wi3tSRokqm+EziMynIxzOMRO6mlpCE5r5eATVczu1uFD3ObdQOOG2Bw9UBaAQ@lists.linux.dev
X-Gm-Message-State: AOJu0YyIykSEYmapIN/e2TYbJ3r/gcZubw66YJoveFNVv/8lfqHmdYxs
	AORqa7rnH85AQVJOUx5vod/DeJXricEfo2nYSt6DdYWcEeoRVcM7gk8doUC2/cggClGSEbct7wE
	B6xclMcJlaM7v/7D8U7kTl3qxQxv7gWmljuv/6jOixxSG5T3iQmRICWg=
X-Gm-Gg: ASbGncsHhMHH5an92/OXLKkuR8kEDsrlNllMgnBPne+x0A5bry356jAUYwVE4ZOflfc
	54VJfKF4evT3dqRm8D4idZZI6HDOoC/wHlpIxd5Tc7tA9ocRx7U0CJ5iBzwHZl1TxgHRzvYMXrb
	z+WAgSPYzt1flCoD36mf+xXmDegv2FyCnjSWnCXyQndoh9mDT3wHwrygn0qu6fBs+LAg==
X-Google-Smtp-Source: AGHT+IHloLMePp6sWWE4Xo3eQmWI+t21lVM52+Q9AX1coxhLbG/AnIIKZEse9z+JfaZFjoBTA+i/FaH8xl/qzjJqxj4=
X-Received: by 2002:a05:6122:1d48:b0:526:2210:5b68 with SMTP id
 71dfb90a1353d-52dba80aa18mr19788493e0c.4.1747824576947; Wed, 21 May 2025
 03:49:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520125810.036375422@linuxfoundation.org>
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 21 May 2025 16:19:25 +0530
X-Gm-Features: AX0GCFu4hsLKVjzcZWhZSqXry2FJY-ngT98VU3nXK6UsgeB5lVCyUWpJ4CkM7NA
Message-ID: <CA+G9fYt_T6x8RHUwNRUvr7qkwq1OYz4v9EE63UyjGCG+1M27+Q@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/143] 6.12.30-rc1 review
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

On Tue, 20 May 2025 at 19:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.30 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.30-rc1.gz
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
* kernel: 6.12.30-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 28ceb2ca31640d8e004148ecaeeafb40c699d02b
* git describe: v6.12.29-144-g28ceb2ca3164
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.29-144-g28ceb2ca3164

## Test Regressions (compared to v6.12.28-185-gf7cb35cbafc5)

## Metric Regressions (compared to v6.12.28-185-gf7cb35cbafc5)

## Test Fixes (compared to v6.12.28-185-gf7cb35cbafc5)

## Metric Fixes (compared to v6.12.28-185-gf7cb35cbafc5)

## Test result summary
total: 232613, pass: 208395, fail: 5026, skip: 18571, xfail: 621

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 55 passed, 1 failed, 1 skipped
* i386: 18 total, 16 passed, 2 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 42 passed, 7 failed

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
* ltp-ipc
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
