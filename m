Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0F0278768
	for <patches@lists.linux.dev>; Wed, 27 Aug 2025 09:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756286593; cv=none; b=Z9F1JIftbIsC/aFcBZHCYYSoOc7Eq3d6E5xrDmiTTHOfwVsf+fFKUyOiGNj94iDafKl2p0rWrPUXGGqCtR0YKleL1y+N+Ijigv/tMPi6dPn3H5Oxe/nc74/IdLDh3c7eBsUgknSPXGLaQth8pmk+/jpBOiPps+ruSWEFM5U5rT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756286593; c=relaxed/simple;
	bh=bwgOcihveHo1IHnUEhXEtpdi3wHT9QoUfXh1TGK/7DY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rlgc6aB1+bFvIg85SBEwcAqFBZfqgFxX/X/1aAbJZaxTRMb2jeV+XmPmVPGOz6FAPibotL3T+nnxihY3ELSJK8r9CtDFPfbZFky/Eg/ja/zwE9cxdZ2k+paj32/ZEOY5r4FUIj3Z+pJS8pfoG+CRkeo95noEBof4XoQSInx+ki8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RmuL/Xd4; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RmuL/Xd4"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-70d9b07e163so13146286d6.2
        for <patches@lists.linux.dev>; Wed, 27 Aug 2025 02:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756286591; x=1756891391; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Gy53dfjoHVrP8RNMRiWCawaGbeGl47u9vCoywHsRB4o=;
        b=RmuL/Xd4ybVG39niVBmxnFV6XM6iiJY2hH16KlJ0aekVoXXdKBOKJmSPy+W3xZdFkH
         z8qOK3FOgLke8mL96IOyAiwMoo5Bg9DYZRtorocl572xOg3YJFZBupGwCNQchBKH2b85
         CoOTCBXgvjhN2oF0jYLdq7sFVftzZ5X5CqQsSGrNY4qrReqlqfTiVeDJ7oLbb0/rhk34
         yVPK1f50gKn0LMVwVz/U+3LH9Ac7bjA3jlGcwDlTV1Ib6Gnqf0dt0gdxe5m5tcOwmzXP
         xrPXRgNB8/BzU9PIwc0q59p0xhH3uhgae/Ra2T3bq0vhc9LChGvYFdI12PihWegRBHS3
         lnEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756286591; x=1756891391;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gy53dfjoHVrP8RNMRiWCawaGbeGl47u9vCoywHsRB4o=;
        b=fEC4T7mYLABOTUwJeY8b/1mmZK1bhLzs6ixI1KJez+97Vm92cuvbYCtg1nDa3Rbk1A
         cch8QFnyJ9r1mw+7eq8pasHT/SqAzy+Q1YjIZfFXXjiyN7Sk4iG+qoCQ0xb5G8OjxscO
         r5PelGHaMrJboRp6/FGbI8b+FphC4jcxdOh9PxaM83MffA0doj+85Q1tmj1B7Q0IsCfC
         YqrnwiUu5wslstdKegxq6kEgGHlwIT4YBnbfv0MhjKJKcX/w2NqGrhaAi+Nto9i5LF/a
         8Qk0pPPPAbEDtCuqLXPzPJQEwz1Gp9eW4vAFgKeEFcWcrkS9iHaIZ4aGzOEQdnB+E50/
         /COA==
X-Forwarded-Encrypted: i=1; AJvYcCXqHk7RQoA+ZGUgxErUW/R4v6c71MCwBLb7gqL0xxJR6Q94FER/Md9Itp6iPLQxFW8r62jfWTuE@lists.linux.dev
X-Gm-Message-State: AOJu0Yzs9HAvL775k+KXaIDUEBQAirb62ZjKL46duL2Y/sWOHE6g5PI4
	AbR0EA6EogTB6WGbeAsN2jgSwQOy/pmt5pfmvbAiY6ZVYHyVpEV49xbbiHnGN1zztw0wjtbHJPO
	movYJNamb+6VtTswGOX3rCYlbVyKNGHxfGtjGid8kx6+Adb3giuBJAQzwiQ==
X-Gm-Gg: ASbGncvgs6F9RMH83TyMt2HVZ3rGVBqpG4U6/Ig04KWEaDfUUcy42jJK0PlyR7dOpCv
	5+mKyELbcVvUlEJ6Pt/tlcRyw1ayZAInHvPYO96251iNOshr+4/BdVS9Qe0yt4JdYAYzO0jSI+W
	wnbcx31HZn/e0e8eg9IlR/iRX1s076luz+yD4ZeFeUnF0nic7k83K6RpjoW7XSflYSuy2onR+Tr
	jt4mqgT0ivmytQ+
X-Google-Smtp-Source: AGHT+IEfOA450mJxRrc99VUf+eR6gCbzMwJPgmzNiqytpGVEC9y17SY44iovOMWF7glIDdN/1KXkJR5caySfB5IZEx0=
X-Received: by 2002:a0c:e34c:0:b0:70d:e501:1f90 with SMTP id
 6a1803df08f44-70de5012309mr4016716d6.6.1756286590954; Wed, 27 Aug 2025
 02:23:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826110946.507083938@linuxfoundation.org>
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Wed, 27 Aug 2025 11:22:59 +0200
X-Gm-Features: Ac12FXw6Z8mjq6c5HZ8ZGdhYEx3nZq7WNG2ZP8naHTGP5anPZsnrFM6a1FWSUIY
Message-ID: <CADYN=9JKN_r=wHa_OPCENT3zW2AFe0ana8dP88fowgjh4-NqqQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/644] 5.15.190-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 26 Aug 2025 at 13:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.190 release.
> There are 644 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Aug 2025 11:08:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.190-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Build
* kernel: 5.15.190-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: e09f9302f92d6e366e40ce66054adc57d2bada85
* git describe: v5.15.189-645-ge09f9302f92d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.189-645-ge09f9302f92d

## Test Regressions (compared to v5.15.187-81-gd21affcc10e6)

## Metric Regressions (compared to v5.15.187-81-gd21affcc10e6)

## Test Fixes (compared to v5.15.187-81-gd21affcc10e6)

## Metric Fixes (compared to v5.15.187-81-gd21affcc10e6)

## Test result summary
total: 52799, pass: 43384, fail: 2145, skip: 6975, xfail: 295

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

## Test suites summary
* boot
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
* kselftest-livepatch
* kselftest-membarrier
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

--
Linaro LKFT
https://lkft.linaro.org
