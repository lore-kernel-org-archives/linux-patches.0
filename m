Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461D8286D4A
	for <patches@lists.linux.dev>; Thu,  8 May 2025 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746727185; cv=none; b=Sr2Q4AHRvz6cGLnHzKeY54xswlVT8LhWZd8O3qPceDnjxFPGhsUpKMZUVOVOKOo8Epa40/jyxsJfZmCVkymYAH94R7kswZ/DUb8a1LgUTd5GVXkwB2xqtAIULsMs4gQ6VjYNyw+cLdVjIsvKvVMNJga72tRJH1CzsPWMHD+ZZj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746727185; c=relaxed/simple;
	bh=3MhyZFz3RPwUG1hIrr16mFUvuxQbAhzd97Xkb4CKwyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KRaTM5lmmkZ10267XYjGhe2EcT4MsQ9TRph+QX4YeD5l3E54H4KDcEXzfvSOZRhuL+JSS7CNW2TEAvNsAw8ZhlV13zTjUI6sFPG9Mv6O08zYY8BK3rP0AOk1SzVQKWSHc4U1VVdGnbtKdn9YCP7M8dJSFF51pa09CLlChJ91cBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Mx4rlHOY; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Mx4rlHOY"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-4c4d8638e07so388806137.3
        for <patches@lists.linux.dev>; Thu, 08 May 2025 10:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746727181; x=1747331981; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KZtkFfAN0vl8jUy35I7OzzCP2DYBQU7JpL1qX+0DUS0=;
        b=Mx4rlHOYVnhGTks9OUi2nW/A7Hh/rT47OHU3LDpRuA6TAvP7hJcCRWR8nrG8INqbVe
         X68kpI6SnaeKUUmRiZPtZ9KBjxlbAqXZYjR5E38p47xqUcqrh7eiMsk3EIu3W1+7KQfv
         SxU/quJm9LE/GoKuua2ZF/YJN9przqwMG8Gr6gYKNL3Z7pjm9LGt7MmsK3Lh3xGg008Q
         6Be/09AE6WUfNKTooYPHg145PFeUmWIlo4pYoqXHJ372SxS/ljVrcFAd6noQqDRJMA37
         y/6ovAOvdrcVmY9PSEEYl+z3nnkaIBLSgPeU8YuaY8ai8MGNIbV5XeQ143jjzQuUe7rC
         7FYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746727181; x=1747331981;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KZtkFfAN0vl8jUy35I7OzzCP2DYBQU7JpL1qX+0DUS0=;
        b=ACRRrCYL+aMmeAzGasFNOmLWkabG5IQgImvK5WG0zg5f/7rgSd52S2oIbzutrsjKPe
         CDhNngIC21ryOGOGOMicuhZRTCHw4eDSd46AUOawfYZzlzQu7vgW4PUpPtW3OcI7pS+7
         JTQsQg1I5ZOq/Qr505qEgnSOEVXn447bYaQyBj8psQ6pLTQuSg/xnuvA1YsEDwEz7HVa
         U2oMKnkFD5hgSDcxwBnZHXCWvVbMvdv5M2yoAKgejIakwqMHxBVpaJamldrYAsjA7ad+
         LKyM1r9V6fUEfJR+yOpRu6W7NcCZ9hdbx7U8vboH+hKVnyalbhqS/aHP0RosPX0mQr89
         J7JQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQ1BFixqzbIDLSXCwREh17/ziHKtzR56oK47A9NKlZZUa8sdAlHJnJvouxCjD+9yctsOUkWh0C@lists.linux.dev
X-Gm-Message-State: AOJu0YzG63YI9G8RmBbq1b3P2jPL3KH4JiPn57EArBwgxgF76dv7ZddF
	148AmNGiJvQoNVhUTgiyR31LeQ5CvXQHzeoVYJ+q3m0flX27A2CHMgUnQjCkJFrM2bb3vrg8m1k
	jLw54kPHSQeHshwDN6GEGqmOAJ9skJ5Dh4uoheQ==
X-Gm-Gg: ASbGncuX0htF5VneQMox/U0I5XW6JRVoqbh+UJ63pkxqGF+izBDCN/IOoj90nw/keCO
	fIMsppy6O0BZRjyepVegqop9PQBw+DPmgk1pTVeeMRN/DxzABFAf9YFjU8pfsjMOb4uRFStHXit
	Z7Q9Up33sQx2sjy/BWLmg8CQclM0qrslShyA1w3olJco7goKGpjq4EfWY=
X-Google-Smtp-Source: AGHT+IGL1fSBV0J7BqJLxv0QdVvpGIrhMehaoMDFhcoWwwdY821LMhrbKRaGwaKaZHoKtZ/K9oiHLguyCcLL3aHGlvc=
X-Received: by 2002:a05:6102:4a92:b0:4da:fc9d:f0c with SMTP id
 ada2fe7eead31-4deed35dc84mr344326137.12.1746727181139; Thu, 08 May 2025
 10:59:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250508112609.711621924@linuxfoundation.org>
In-Reply-To: <20250508112609.711621924@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 8 May 2025 23:29:29 +0530
X-Gm-Features: AX0GCFsXaCY9lxiQ73hw306wIhVQemb4BfUwdA8MR4os7OR56vZYtc-5ODIUfS8
Message-ID: <CA+G9fYuwf6QW2P5U7qjETES_KZK1b1Z5yvwTy=DZ48ej0gr2NQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 May 2025 at 17:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.138 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 10 May 2025 11:25:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.138-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Regressions on riscv with allmodconfig builds failed with clang-20
and gcc-13 toolchains on the stable-rc 6.1.138-rc1 and 6.1.138-rc2

* riscv, build
  - clang-20-allmodconfig
  - gcc-13-allmodconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: riscv uprobes.c unused variable 'start'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build error riscv
arch/riscv/kernel/probes/uprobes.c: In function 'arch_uprobe_copy_ixol':
arch/riscv/kernel/probes/uprobes.c:164:23: error: unused variable
'start' [-Werror=unused-variable]
  164 |         unsigned long start = (unsigned long)dst;
      |                       ^~~~~
cc1: all warnings being treated as errors


## Build riscv
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.136-100-g7b2996f52bc8/testrun/28376895/suite/build/test/gcc-13-allmodconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.136-100-g7b2996f52bc8/testrun/28376895/suite/build/test/gcc-13-allmodconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.136-100-g7b2996f52bc8/testrun/28376895/suite/build/test/gcc-13-allmodconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2woOEzI6voUB7CUa30K5x1JGa96/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2woOEzI6voUB7CUa30K5x1JGa96/config
* Toolchain: gcc-13 and clang-20

## Build
* kernel: 6.1.138-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 7b2996f52bc811781aab0f470461a90634eac353
* git describe: v6.1.136-100-g7b2996f52bc8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.136-100-g7b2996f52bc8/

## Test Regressions (compared to v6.1.134-451-gcc42c3189901)
* riscv, build
  - clang-20-allmodconfig
  - gcc-13-allmodconfig

## Metric Regressions (compared to v6.1.134-451-gcc42c3189901)

## Test Fixes (compared to v6.1.134-451-gcc42c3189901)

## Metric Fixes (compared to v6.1.134-451-gcc42c3189901)

## Test result summary
total: 93597, pass: 74005, fail: 4175, skip: 15107, xfail: 310

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 27 total, 20 passed, 7 failed
* mips: 26 total, 22 passed, 4 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 9 passed, 2 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 35 total, 32 passed, 3 failed

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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
