Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C4125E817
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 17:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746035052; cv=none; b=uaRTxwwecgJ4y4Lq9qY1w1mqSL2v1gKpW/gPtm3cuusKHTEreWb0s/nOtuX7MJve8tBbUhGWJUfR9iHPhIzbxJSHXV3YeIziwI/3cq9ub3eWmV/nnLvomlrJ4jOYTgMhB7hzLkCYG4Yf3cbU6S0ZfbL+3SgDch20CyoZVmLvTQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746035052; c=relaxed/simple;
	bh=98U64Grm/yrPvUTaqeoMb8TwzYAopriQxXuVRwQYLQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RcYfmkQ9bSVTbe0SCsMavc2wwJ/RCmN/rXh0uVDPlw5FZkPusdt2QVYg9XcwSUJOr0ZCpUJMPizpfCpj8mHYPG4iDgwz6U42Z7s5JKLKpNCBkW/STJYGGBvmsxEk2CKRDESAtkIX8OFH4tSz+oRQfSKWE2K67PKf5fblAP9Olow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Qv9qmjXC; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qv9qmjXC"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-4c3183ec801so37280137.1
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 10:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746035049; x=1746639849; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j0EGPd0bx3Qyx0iqcW31yxmVunTw8AalnKO1lkcSNSs=;
        b=Qv9qmjXCPlw8H75Aeqn/NxO37SHzBGakvwyw8NAzVfHpcV1ilnWtuCX1eFa71hxAo8
         GCdBgKhLo6IqdL6mz7h9nAQcmQ2Zr8qUaYz65fL9dGA3sYlMM8AjY5L4DTPh6pd7VapG
         PMy2ZUO+DYfCNp3i67Ok8sSB/Wsc0h8ys2X9ZTcdd5Pw1fz6ia/do8XszE1LO1kfaJ4N
         sMzG0z8b6Ukzxi9AVTfXu4OzOMxrX78NSHzQNZLuoo75bAXs97+UOXeew6qC7x8cm5bm
         jU7bxcuWRGBbu3XsqjyoZn7kSzH+lO7SgAllqB9YEfi+W6V+iqg0NbRoXkUwGbCBhCUR
         AzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746035049; x=1746639849;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j0EGPd0bx3Qyx0iqcW31yxmVunTw8AalnKO1lkcSNSs=;
        b=v03FoSM8nIS5jk4S6CkMypPIs6b5it3lijTlqYwQi7qrsYnfJSbF3snw7RGjfevlg5
         /7mwhEkb9f/UmhgVOrL4kJ7RYfO2GklvCtPCFyEeyAEw+Su0ixPd2a26CUryq8PdCuIt
         +fknnmrXtvX8gZAnA6nvs8lXwKSFKDMpVx1TwHIRR4rkvfB1DvRkK9xKLu9YQv7iHEcJ
         SZ28lAOyuuW+00FNGHxPZ/5Y+hsLegXCSDb3q0HFeY/idVfYOnthsjaVNS4IWlMVr6Np
         PZonUWq5c4loX2VfuhSPgroUZ11cctvH5TfJdCUfIyTQItBdgzCRQebfp7T1BqNLebvW
         snrw==
X-Forwarded-Encrypted: i=1; AJvYcCUpOb1EvuamBj/nkvOxtKMcqIQOvFYeL604mdWajMx3E4OTL9WIKmKferRDfv34S7WORvlrbjuT@lists.linux.dev
X-Gm-Message-State: AOJu0YyLGREKihUBae1sMFogJncW/Osg7TUHgsPCY1sJ5Qs9ob4OOGLd
	5lfSiCn9yJQ9aV2u9EdVMmextdcWzBI0TXUL8YCYqn+zR/nmpu893lcbDSMeb/jzmoLxGHIedpX
	Q+th6h0Jmvrijz4+2Ld0FhvU/POHFS4/oaeZHAg==
X-Gm-Gg: ASbGncsOjeSrGXGVEMpu1kL+dthTPhh02VdzwV5wmjFmw+kHmvc2W8fsk1Pu9/4fIdC
	0SpoSzVSi3faZCNWsv86IPuFEMN/UiWdSzJt9NniuOL1aayhBq9RfSFRAsf0NNYAlfoJGvjl/qE
	n/cTYnNUSIby7KAl3BWaPP/jYAbZo+bHBRWjZJ8GZuDORqGeTKwMM/3VgOZbjKYDmUHA==
X-Google-Smtp-Source: AGHT+IFqfUc1pcwolXCaUbtGWanVBKAAOGRenboDZtE8z60ZROWu+enbwYehGvy9UsmQY3aYsHt3dj7fsi1owF/BH70=
X-Received: by 2002:a05:6102:5493:b0:4c4:e0cc:fb39 with SMTP id
 ada2fe7eead31-4dad35d6a7dmr3579872137.12.1746035048797; Wed, 30 Apr 2025
 10:44:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429161121.011111832@linuxfoundation.org>
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 30 Apr 2025 23:13:55 +0530
X-Gm-Features: ATxdqUHC4HNGKGw7Quv73JBpUO9fXivptBKPlx5ATrPum9Ct6uDGvBKkWWTPiJk
Message-ID: <CA+G9fYts+XiQo1fG+306d89p7NXgHLURq2PenKdcx3TVWbau+A@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Apr 2025 at 22:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.5 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on s390 build regressions with defconfig with gcc-13/8 and
clang-20/clang-nightly on the stable-rc 6.14.5-rc1.

* s390, build
  - clang-20-allmodconfig
  - clang-20-defconfig
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig-hardening
  - clang-nightly-lkftconfig-lto-full
  - clang-nightly-lkftconfig-lto-thing
  - gcc-13-allmodconfig
  - gcc-13-defconfig
  - gcc-13-lkftconfig-hardening
  - gcc-8-defconfig-fe40093d
  - gcc-8-lkftconfig-hardening
  - korg-clang-20-lkftconfig-hardening
  - korg-clang-20-lkftconfig-lto-full
  - korg-clang-20-lkftconfig-lto-thing

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: s390 pci_fixup.c 'struct pci_dev' has no member
named 'non_mappable_bars'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build s390
arch/s390/pci/pci_fixup.c: In function 'zpci_ism_bar_no_mmap':
arch/s390/pci/pci_fixup.c:19:13: error: 'struct pci_dev' has no member
named 'non_mappable_bars'
   19 |         pdev->non_mappable_bars = 1;
      |             ^~

## Build s390
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.3-550-g25b40e24731f/testrun/28260682/suite/build/test/gcc-13-defconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.3-550-g25b40e24731f/testrun/28260682/suite/build/test/gcc-13-defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.3-550-g25b40e24731f/testrun/28260682/suite/build/test/gcc-13-defconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPcixbnyrWJFLHOcPITycGUE5C/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPcixbnyrWJFLHOcPITycGUE5C/config
* Toolchain: gcc-13 and clang-20

NOTE:

### Clang-nightly build warnings
* arm64, build
  - clang-nightly-allyesconfig

* x86, i386, build
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig-kselftest

## Build warnings
include/linux/fs.h:3911:15: warning: default initialization of an
object of type 'union (unnamed union at include/linux/fs.h:3911:6)'
with const member leaves the object uninitialized and is incompatible
with C++ [-Wdefault-const-init-unsafe]
 3911 |         if (unlikely(get_user(c, path)))
      |                      ^

Links:
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPciVppbD5RzfHEvVZtbFTHapf/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPchxeZeZBSVjD4AtsK7UIen0t/

## Build
* kernel: 6.14.5-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 25b40e24731f2dbaad24bd56b2b25e6714783538
* git describe: v6.14.3-550-g25b40e24731f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.3-550-g25b40e24731f

## Test Regressions (compared to v6.14.3-242-g86c135e93323)
* s390, build
  - clang-20-allmodconfig
  - clang-20-defconfig
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig-hardening
  - clang-nightly-lkftconfig-lto-full
  - clang-nightly-lkftconfig-lto-thing
  - gcc-13-allmodconfig
  - gcc-13-defconfig
  - gcc-13-lkftconfig-hardening
  - gcc-8-defconfig-fe40093d
  - gcc-8-lkftconfig-hardening
  - korg-clang-20-lkftconfig-hardening
  - korg-clang-20-lkftconfig-lto-full
  - korg-clang-20-lkftconfig-lto-thing

## Metric Regressions (compared to v6.14.3-242-g86c135e93323)

## Test Fixes (compared to v6.14.3-242-g86c135e93323)

## Metric Fixes (compared to v6.14.3-242-g86c135e93323)

## Test result summary
total: 129647, pass: 105960, fail: 5381, skip: 17905, xfail: 401

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 56 total, 55 passed, 1 failed
* i386: 18 total, 16 passed, 2 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 22 total, 8 passed, 14 failed
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
* ltp-ca[
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
