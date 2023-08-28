Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0550D20EA
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 08:03:43 +0000 (UTC)
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-48d0e332f4dso817997e0c.2
        for <patches@lists.linux.dev>; Mon, 28 Aug 2023 01:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693209822; x=1693814622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXhc2ckjjHSmkLw88l9MqVujXGlqnXakWUFu8QqVEak=;
        b=dN54oUuH/wY6Q9oA5R1ZsJezruY52D94VtYcerRYpVr/5bnJfjit/kzUHm3REAhvIQ
         hV4UQTwOafWtc/P4xPvizgmeTY3Bcrw4Il3C5Fq5SC8z5edqkmU8IMOO72pri6r/a6XD
         dd9ZjJCrg1CinICacu3aFzH+sf5uktRPMZD38Y/O/EH6ZBFrnghwSDo2iW9xz/CH9TXv
         orCIucBjET0m5iO5yCn2kaOSXyO5fbKdTN+qDP8MzZxgZogPydIvaOyyrpmyhBTQHRoT
         SbdaDC84T1Vogd0bVlRbXVEEsd82LMTiCS1MjWsq5jk/dPMHiSeyosGRFf/Zg1asNWvT
         fQQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693209822; x=1693814622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lXhc2ckjjHSmkLw88l9MqVujXGlqnXakWUFu8QqVEak=;
        b=G2mrCgIr+OY0o1rM8hipv+bj+t+dhDR9vvIgufphlURql9SUqMrRGVDvgujn2Jq016
         yBiDDoB6XlYB2uvjSQx1Ec0daZWSu5YGVJml3i6aln3Td90bT3soUx2jSDu2Vs7C7l7K
         D8a6EWZzBl4oVKzL3PjtICFN8WYV/Q9xFW/TrvK8VtQ1TvE/yGnStG5LYvY487xkBcNd
         YAHpNtVd6vxXgzOLTX89c/2F6Th6bH94H/kHsAKGu/6o16pRdcZf1mGFH1C7JxlBt57F
         lgeEl88F1kbhvlnNy8Td3utsSC66fHdU4Wf+P3KHI1jSGHpakvNJkb713disX3i1rYUX
         DhiA==
X-Gm-Message-State: AOJu0YyHPOM4e5g4eUQrFxCEcf+Iids7bm0oXKEabMjToS6rLYaBWFVr
	ArpdgyJxYQe30cRAAddjQUc8ATOGc/pxUEbWP79eZQ==
X-Google-Smtp-Source: AGHT+IHL/DjlIRID00Nnd70scSmEUPlJN8eZeHILo/LpLLzxBk481L8nn4KnGD6WWfvJlnAr5MIfoUH8fPrrSzbeDbw=
X-Received: by 2002:a1f:4d83:0:b0:48d:13be:92c3 with SMTP id
 a125-20020a1f4d83000000b0048d13be92c3mr17223202vkb.8.1693209822604; Mon, 28
 Aug 2023 01:03:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230826154625.450325166@linuxfoundation.org>
In-Reply-To: <20230826154625.450325166@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 28 Aug 2023 13:33:31 +0530
Message-ID: <CA+G9fYtsAHoRTcQdzJ9B1ftmGwkDLuDM2hCZ19X5DuEDr+XBAw@mail.gmail.com>
Subject: Re: [PATCH 6.1 0/4] 6.1.49-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 26 Aug 2023 at 21:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.49 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 28 Aug 2023 15:46:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.49-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Kernel warnings reported on previous releases have been fixed now.

[    0.531602] missing return thunk:
__alt_instructions_end+0x2f1f/0x2f70-srso_untrain_ret+0x0/0x2: e9 c2
5b 0c ff
[    0.533242] WARNING: CPU: 0 PID: 0 at
arch/x86/kernel/alternative.c:574 apply_returns+0x1c0/0x3d0


## Build
* kernel: 6.1.49-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 1d91878df63ceab6316c7c84876abc7eec08a2e4
* git describe: v6.1.48-5-g1d91878df63c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.4=
8-5-g1d91878df63c

## Test Regressions (compared to v6.1.47)

## Metric Regressions (compared to v6.1.47)

## Test Fixes (compared to v6.1.47)

* qemu-x86_64, log-parser-boot
  - check-kernel-exception
  - check-kernel-warning

* x86, log-parser-boot
  - check-kernel-warning

* x86-kasan, log-parser-boot
  - check-kernel-warning

* x86_64-clang, log-parser-boot
  - check-kernel-exception
  - check-kernel-warning


## Metric Fixes (compared to v6.1.47)

## Test result summary
total: 168275, pass: 142858, fail: 2955, skip: 22260, xfail: 202

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 149 passed, 2 failed
* arm64: 56 total, 53 passed, 3 failed
* i386: 41 total, 39 passed, 2 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 13 passed, 3 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 44 passed, 2 failed

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
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
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
