Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810FF42058
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 05:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721279736; cv=none; b=lAe1pvD0c9nXIcCAq+tF8PT7Vhg0yCQt3kl6jWoMR80I413F/jlfmQfu/LXo8x8U4GCWwyIyFRkB7VmHbilhMqm9vIRb/TO+ujkU8Mgaeup3+8w2/OFVQcH6umTzgfn9mjbRCpYSEwmXQQ7kf5HT6XFw8PYWldc5E6ayjA8BWO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721279736; c=relaxed/simple;
	bh=EoSKuZUqeSjnaf5kfIOeC3Ckwj2scTZiLDwNdkrgTO4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E+C1Zh7owwjXUCqbvWWUlxSTdhYzfaBNBO6+42BAy6a8SOJbZhtryWo/kCwKJB2//zJ4rAiQUFWGzRjXmvtxsIweTSXJs8m3t05AWZfBVIajXzn5oQi8DFqi1gi5MQ4C4YyHYjXqkPHpXxqYkwOxI7+lFDA85MqVSzFxCK5cHiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s33SSr0a; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s33SSr0a"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-80fa1509989so234614241.0
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 22:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721279733; x=1721884533; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A2X/W62oP2UENTv/RdibwUIRfmlpn1GhezLWyGqvYn8=;
        b=s33SSr0agd2PG2RU/hrhRpPSKu+9EKTK2TMtI3P6J48SIULZvuEUBdE+J/YyCB54Ad
         39Y3jav9Ma51Mi73IBaPTjdhghSXXOiAI5BuAfo7WDrY2dJyzICJ45KMg85pnMCramye
         qTxYsq6HtaQderf8BQ0r6OKNCmS4pRmolJTIcsUlMyyGQQWpM6fsvvsBIVEi610G9jz2
         iFGQKQcUX7mMdt3GqaL7RbgwlEmgDuZFPZwPR/Yfz1AgbXhJG5y6pX7FhzEw8yMr8le8
         iKPwDuC4o4dHE7Cou+ylFSMDsRQC0K9LAuAYguFuT0L8Y8B+tPMFzMMbRDRBLELa2Kgt
         luwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721279733; x=1721884533;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A2X/W62oP2UENTv/RdibwUIRfmlpn1GhezLWyGqvYn8=;
        b=n9DyCJSLKVhXfMF60LllsY2DKb7OPcAiR7XuGGXGn//LgYzWKo4iwuWkXzH3TaKxA8
         52uHMebdEhQFnPlqFSw+pEdfeAZjZMP/zP+zJcZVZN9ZOjkDNQRWEXgbUpAER7orI3cJ
         794dCHJealDIy4RvI2iB3wCTyGXj7jr2qS/BYyGghFO7Epyv81zgRbefYfPmXmt7NgDX
         YnWUziWmrJHwYFCJTkj8fc3L3VQS5vjX7LYJbzy0Ir/mBEspNyav/D527x/gp+rMNDvV
         u9spsDKl+ESZ2he6LwxeKCKq2FaCrlqEW561CUyRfqGQWVFcEjqspfv4pIeBzYyXDucc
         2q6w==
X-Forwarded-Encrypted: i=1; AJvYcCWzHUlzrV0cjJ6fU8tUshVe2P1korA3pJx8M8/rG9WuPA6WEjllI+hZPlrXD/cyb/e55HkrM+Grh8kjRxwnqXKkRSr4WGHMTQ==
X-Gm-Message-State: AOJu0YyMYaB7DgZkFfYVt7oWUA5AeEm+Tfl/f2EKbgpnpcdLF3qmjWhG
	Qmrs8zNd+IQvlyo1thOqsYySnzypvXjqUyC/2xQEvPBaITyeLhLFYd6DZhugNQL5BFD+ud5yGLO
	sBLYqcJeA8gEC1H6FiIbW9/TtOkWloaYD4tT0fQ==
X-Google-Smtp-Source: AGHT+IEOTlv4MrE+GXCOhrQ9cjudHE4BkNGnZk3JQqnG4xKdAWrXh6CV7m9Mrmc+6hQiMyVvsCwnF7hgD+st9U9UA5Q=
X-Received: by 2002:a05:6102:4b8b:b0:48f:3411:4021 with SMTP id
 ada2fe7eead31-4925c220d90mr1433323137.10.1721279733200; Wed, 17 Jul 2024
 22:15:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717063758.061781150@linuxfoundation.org>
In-Reply-To: <20240717063758.061781150@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 18 Jul 2024 10:45:22 +0530
Message-ID: <CA+G9fYtfAbfcQ9J9Hzq-e6yoBVG3t_iHZ=bS2eJbO_aiOcquXQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/109] 5.10.222-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, 17 Jul 2024 at 12:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.222 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.222-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The QEMU arm64 booting kunit enabled boot failed with clang and gcc.

Anders bisected to this as first bad commit,
# first bad commit: [c2ef31fd37ae11e89cb63c73cb7ee05bf4376455]
            arm64/bpf: Remove 128MB limit for BPF JIT programs
            commit b89ddf4cca43f1269093942cf5c4e457fd45c335 upstream.

Reverting the above patch made the boot successful on QEMU arm64.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Boot failed log link [1]
 [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.221-110-g3fac7bc30eab/testrun/24635930/suite/boot/test/gcc-12-lkftconfig-kunit/log

Links to the details of build and test [2]
 [2] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.221-110-g3fac7bc30eab/testrun/24635930/suite/boot/test/gcc-12-lkftconfig-kunit/details/

Steps to reproduce: [3]
[3] https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2jMce7XoWf551plmM9TzxxlmL4t/reproducer

## Build
* kernel: 5.10.222-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 3fac7bc30eab333862a04cd97d58564bb909e518
* git describe: v5.10.221-110-g3fac7bc30eab
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.221-110-g3fac7bc30eab

## Test Regressions (compared to v5.10.220-285-g6db6c4ec363b)

* qemu-arm64, boot
  - clang-18-defconfig-kunit
  - gcc-12-defconfig-kunit
  - gcc-12-lkftconfig-kunit
  - gcc-8-defconfig-kunit

## Metric Regressions (compared to v5.10.220-285-g6db6c4ec363b)

## Test Fixes (compared to v5.10.220-285-g6db6c4ec363b)

## Metric Fixes (compared to v5.10.220-285-g6db6c4ec363b)

## Test result summary
total: 81147, pass: 65856, fail: 1631, skip: 13601, xfail: 59

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 29 total, 29 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 23 total, 23 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 25 total, 25 passed, 0 failed

## Test suites summary
* boot
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
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* libgpiod
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
