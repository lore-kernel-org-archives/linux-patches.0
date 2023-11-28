Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701BA101F5
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oLTJdkSs"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-7c5060a9e5bso156150241.0
        for <patches@lists.linux.dev>; Tue, 28 Nov 2023 04:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701172809; x=1701777609; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X8mw1BBxaan41I9CSKaTQssL+4Iit3B3xfGkQ2tsLjQ=;
        b=oLTJdkSsmbpBjzBZ9Q+9jGa3G/WdCNGOsRoxw+T1JjiY81NAEIDEEeUjHZE+OdlFce
         SeO8+JJ5MB3xiwOg277Q8eivZYou0TK0bGYPzR57uXSqkoUIcqSSA+AI1OywuuUpRib6
         KHo4IOFBBSBC3fKa9RRx02tgwb7T6W579/qs1q0HFDxgRrdnkwvtZOs8D/a1a6RLysPB
         2GrQ1gKpIl/bmiS8g3cf2KZcblhmo5juBtk6P1hrnL5VL1Ujyv17tT+hdHsQIK/0gsk5
         6jXvB2RrWZycF4icwOL8E39FVfimBgTnezeo+LWug4VpQ2LhMnIU12U8ykDv2SixoMC+
         3hxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701172809; x=1701777609;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X8mw1BBxaan41I9CSKaTQssL+4Iit3B3xfGkQ2tsLjQ=;
        b=UdetOrZk5VWrY7ePeh2J4nXnL7P9RskVrDcDeXZYm/cQIdND+Vf4tKMf9FborsMfaB
         PkeYA6aLyjByAxGZwad8JJLZXM87cMd3E/fNb4Go5BrpFXV4Bc7mEGyvxOHpF9f4VJMR
         xNsROkSvhaCb/l9tI+mtl4RM5H56M/NcvKYgVqGl/w0YLfzut4DA7qHyyvlssNwWi6Yd
         ZFfiEAXCqvpHEL5pSpYQB8RIjE8j4fhaRxxe3DTCZb3LO9b9YGIAkoDTvn88dQHxUtIL
         NzZb7AaPzcEty+wkoGmynjbIYj9T71iJGTIhjDZYt3baStlkJM/4Zp7hGRH82ayaCdmT
         bVaQ==
X-Gm-Message-State: AOJu0Yw1vBbj7SF0zgQh17PA34nNubmhiuYdINE8KWnv7vFXf5M0cvJE
	AD/WTitz1ESNhGQBpwvQ3r8I56bn1uIv6C8Dd3fzAA==
X-Google-Smtp-Source: AGHT+IFfqgv/3Uaurmh33ezO33O76n9Jf80DJ8xYWK8+FGfFie2AFINkJF8CYB6v9LFf/UozfxTwG+pmSmxcxoxLciw=
X-Received: by 2002:a05:6102:34f1:b0:462:8d09:93d2 with SMTP id
 bi17-20020a05610234f100b004628d0993d2mr14651660vsb.3.1701172808970; Tue, 28
 Nov 2023 04:00:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231126154348.824037389@linuxfoundation.org>
In-Reply-To: <20231126154348.824037389@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 28 Nov 2023 17:29:48 +0530
Message-ID: <CA+G9fYveNT9jVqUSrugWQ9aRq2XrCGOdEnqxoieaSiSKE_vJiw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/292] 5.15.140-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Sun, 26 Nov 2023 at 21:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.140 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.140-rc3.gz
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

NOTE:
1)
Perf: PMU_events_subtest_1 / 2  - fails on all qemu-armv7 and TI x15 device.
These perf failures are also noticed on mainline / vanila kernel on 32-bit arch.

## Build
* kernel: 5.15.140-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 659e621811001944973a85712a1f1ce31200daec
* git describe: v5.15.139-292-g659e62181100
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.139-292-g659e62181100

## Test Regressions (compared to v5.15.139)

## Metric Regressions (compared to v5.15.139)

## Test Fixes (compared to v5.15.139)

## Metric Fixes (compared to v5.15.139)

## Test result summary
total: 96041, pass: 75848, fail: 2597, skip: 17534, xfail: 62

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 117 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 34 total, 34 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
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
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
* libgpiod
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
