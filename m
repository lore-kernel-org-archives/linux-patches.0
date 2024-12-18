Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4631D1B0405
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734531198; cv=none; b=YSiPBUTchII9myu17FgxpQa2u0pHeLQ7ReIFtXq/pp20ItQ8kGE6RWOmDhygnBvGcTatMvHSI7zB+P/2nLlNLicgZViu23p0glPXhTFP2zd6oLWhVtrKJRakeuhXnX+XM13T7IxaPV/PxwY2IImtJHGj3X/evqWSyF5a5DAbuoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734531198; c=relaxed/simple;
	bh=SRwjq7+oKgfK9CVktolHoTbl+zUpZqxeVJ3oPVQshXk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kxmgrf1avj3AbAimG5ansYGXpZ/yGBUnMLwYNhhFZd8/Uxh9n2qjc8+AkBauDCEaBXBquqQp0mBjzfty+rAXfZbjLw4USXX+VG2Fyj8vW9RzzoyOTBxiY6rV8gpQ42jzTCJYclmT3pCCDCXRWlg1RUVMVT8iKn/7yKIuexajBVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H7sjU2GZ; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H7sjU2GZ"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-4afecb2731dso1869025137.3
        for <patches@lists.linux.dev>; Wed, 18 Dec 2024 06:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734531195; x=1735135995; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YR8+4bOVm+nOiHpwN4v5hhdNDTruc01Xviq5h2eQRcQ=;
        b=H7sjU2GZtml8p1Uv3Ixb+ZKl28YlU8bZTaBt2hD/TL5H72vnm+ujd3kVoB8042KghM
         buxK6eC4pX1eQTcIhTGiDy2c1FNJrG+cNT85cPCFQXvY/uRi/u4TnEUFZq1DBE+CjYv8
         7rwYq1IUl29aVWKqTWRzA/RVzW0Hrr+V8l3A6xqAO+26x9061l5wBdcjDvY6HlfEFwgu
         bIHssbPCJAi4YumUxnLo2PH8T06R2GC7WcNZAHGvm9HWG90YTOZFrV+BLwTsTu1pZzui
         O049eUyxPWNm0kBy358hFjUKvx2wDNWU7/Y8wXC/wL18002oWo1suH0mxN7cJVHnph/a
         0Xkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734531195; x=1735135995;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YR8+4bOVm+nOiHpwN4v5hhdNDTruc01Xviq5h2eQRcQ=;
        b=lYmpVbe+gdnhVt47xySf99ZV4pWoCtj8ZqbBMgUXKFOGuiYsyN0xCkyrN7zml0jAoS
         1sGR5wg8T26UE9Yq8ORRURnRUzpUNzBiMk+S0jFDYRpopTMAMJ6+FdGjgGSsX6ANsdnU
         Nge09OBNGcsxbtQxBlq92ZZi8pIRa7RJrmuhf9ozFz2ZBj9tKPEJaB+GTq4+/kw8tf0t
         KK6raZOvJzFgtQzFWs7gZtG6/WbYHjsMrx7YgMNNTckonWHI57S4MV2Q+dXo3q286TMk
         +HN4J+DuX3xRaGwFxD67swLYW6e6X/OJYkw8ywOAIPJh+WWaJQaLFuLUmh9AL3wL+3SG
         m/BA==
X-Forwarded-Encrypted: i=1; AJvYcCWhXATaezNfLKPfsprXKLqG+BBt0ub1CK7s/Saf7I86sovZ5C3HV1PJZJifV6gy4jkvjc0vfbD0@lists.linux.dev
X-Gm-Message-State: AOJu0YxzJ2hP6W8tr0Eiwpcfzej+tWEuCTiWECYXWTvqE7P2uErGckPH
	LqnX8wBbNmoH/B8ORLxnE/r+nIYMYz0Ql3UhSlTXtNA0SM2lDksEmScGniSZFK82JTS2R+nZsro
	x32rMs6td3+yo7bAcBqYtHnaeJpE2YH6fGn3nVQ5N8yDoxuWry08=
X-Gm-Gg: ASbGncu1r9RcS9+epJT/nkW4fKLQpr3xoFfIM0hKDy6sPpoJT+G6U1C2VjqO/2W4Zo6
	uuwrW9glPTjQRY6OAvuz0KuFKru83+jWEZPCDQDw=
X-Google-Smtp-Source: AGHT+IF7+JqklySWY7eBkWlm38hehD4UeLlyHHGa5rgogY5Geo+vsMDbTA9nzVcqhWmDjgexO1iYOFDcIRkhKGpwVY0=
X-Received: by 2002:a05:6122:1ac7:b0:518:d26a:a819 with SMTP id
 71dfb90a1353d-51a36b2d6abmr2697612e0c.0.1734531195127; Wed, 18 Dec 2024
 06:13:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241217170533.329523616@linuxfoundation.org>
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 18 Dec 2024 19:43:03 +0530
Message-ID: <CA+G9fYsjdC1hV5f6Mei=46D0Fe5_jsjujxq7pGjvDPZ1ij7d1g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/109] 6.6.67-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Dec 2024 at 22:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.67 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.67-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The all i386 builds failed with the gcc-13 and clang-19
toolchain builds on following branches,
 - linux-6.12.y
 - linux-6.6.y
 - linux-6.1.y
 - linux-5.15.y
 - linux-5.10.y

* i386, build
  - clang-19-defconfig
  - gcc-13-defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
-------------
i686-linux-gnu-ld: arch/x86/kernel/static_call.o: in function
`__static_call_update_early':
static_call.c:(.noinstr.text+0x15): undefined reference to
`static_call_initialized'

The recent commit on this file is,
  x86/static-call: provide a way to do very early static-call updates
  commit 0ef8047b737d7480a5d4c46d956e97c190f13050 upstream.

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.66-110-g584b6d5f2ac7/testrun/26374041/suite/build/test/gcc-13-allnoconfig/log

## Build
* kernel: 6.6.67-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 584b6d5f2ac73fe77fccd81f9a56dc144dc143ef
* git describe: v6.6.66-110-g584b6d5f2ac7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.66-110-g584b6d5f2ac7

## Test Regressions (compared to v6.6.65-357-gae86bb742fa8)

* i386, build
  - clang-19-allnoconfig
  - clang-19-defconfig
  - clang-19-lkftconfig
  - clang-19-lkftconfig-no-kselftest-frag
  - clang-19-tinyconfig
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig
  - clang-nightly-lkftconfig-kselftest
  - gcc-13-allmodconfig
  - gcc-13-allnoconfig
  - gcc-13-defconfig
  - gcc-13-lkftconfig
  - gcc-13-lkftconfig-debug
  - gcc-13-lkftconfig-kselftest
  - gcc-13-lkftconfig-kunit
  - gcc-13-lkftconfig-libgpiod
  - gcc-13-lkftconfig-no-kselftest-frag
  - gcc-13-lkftconfig-perf
  - gcc-13-lkftconfig-rcutorture
  - gcc-13-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-i386_defconfig
  - gcc-8-tinyconfig

## Metric Regressions (compared to v6.6.65-357-gae86bb742fa8)

## Test Fixes (compared to v6.6.65-357-gae86bb742fa8)

## Metric Fixes (compared to v6.6.65-357-gae86bb742fa8)

## Test result summary
total: 131803, pass: 107195, fail: 3174, skip: 21379, xfail: 55

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 128 total, 128 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* i386: 27 total, 0 passed, 27 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
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
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
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
* ltp-sm[
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
