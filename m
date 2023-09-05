Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A834430
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 08:28:43 +0000 (UTC)
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-44d3e4ad403so962934137.0
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 01:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693902522; x=1694507322; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eLVlLYXm43et59ODiKK6ekSSR9heDIXhgIR04XcWgxo=;
        b=eZlyhU4DWYXQGCFGsnxXYfobgXK+4XSV5favwtp0N6IxfuKktb3FYYIkJqC+KS/LRD
         q7Z8GppjYtxZdldQ3sub7l6MyF1T18q/RHFKI/N/+M3NGQG62p3LdfR3TeYYOM/mw0/w
         wFD94jziL1yrzfUXhHqwUARMx2rzXNw4mk6fgMbHHVdXBlwiakYDqPoMt90DG4WDIxTZ
         QV4VpcgtjoiI5Z6o2sfUMQ7lB0WqoBPQVSfECuUQgPjz6u5koxpxZN6dsa1hAW/FMT1D
         MB3mebHgpLrRDwAOBi53N/In+qUz2JBfJwyR4/9lScPu2Jl0Va9+/HhytZSPCCrATCC6
         MoPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693902522; x=1694507322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eLVlLYXm43et59ODiKK6ekSSR9heDIXhgIR04XcWgxo=;
        b=gmDqgtTiq2vjgPBQ60TWdeUUHJgTb7JBRwmr1AIUtgM0wPX68AzckmJ018P5xresqm
         rFfLoMf/SFajcTjRRx7RX0wlT7U8fbPyomloek+lR+W1UZILBSm/oZ4O8NWedDr0hwUU
         GQ808golIP4ONTTe9GKsPM3RxrYft5Fg8x27TxhGBrHlgoTPTDLMViUujnO1yMnF4y9j
         cw4ECNFzL/Yb3fIakrWoI2ycwcayl0s6YpWNxaLThi5oDfomuatd/tY3tVpiopSFThjc
         pYE+7JtqOLA3nIdBOOu6KpE9UY6rntUNTnOvCGQ6/ltQJa1/DvKNliSpJ56nfh6eUoc3
         4aZA==
X-Gm-Message-State: AOJu0YxRjriW9M8TD1whzPN42XpclJq6irh6DKsgGzCbrgOYFezJ354H
	daoCosr8YmTv5vPOgu+E6YRmXHWSb0qjxZdCRxpfmA==
X-Google-Smtp-Source: AGHT+IGL8pgqFDTwFbkEIpOfSyXCLO20l9z11J7mChyhzMGqbFg7zCWL1ivXwG5Mf6e7Mq08MS4vXaERVY/M67z3K6E=
X-Received: by 2002:a67:e9da:0:b0:44e:a558:5ec4 with SMTP id
 q26-20020a67e9da000000b0044ea5585ec4mr10817714vso.9.1693902522605; Tue, 05
 Sep 2023 01:28:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230904182947.899158313@linuxfoundation.org>
In-Reply-To: <20230904182947.899158313@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 5 Sep 2023 13:58:31 +0530
Message-ID: <CA+G9fYteSobTv4ASoYX=1Z=V1B4grPpeYSkJq+1WDFBeQP4nyg@mail.gmail.com>
Subject: Re: [PATCH 6.4 00/32] 6.4.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Sept 2023 at 00:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.4.15 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.4.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.4.15-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.4.y
* git commit: 9d9f43e3652f3df0f5a4b81d201bbcc97b88c7d5
* git describe: v6.4.14-33-g9d9f43e3652f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.4.y/build/v6.4.1=
4-33-g9d9f43e3652f

## Test Regressions (compared to v6.4.14)

## Metric Regressions (compared to v6.4.14)

## Test Fixes (compared to v6.4.14)

## Metric Fixes (compared to v6.4.14)

## Test result summary
total: 142519, pass: 123130, fail: 2060, skip: 17149, xfail: 180

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 141 total, 139 passed, 2 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 41 total, 39 passed, 2 failed
* mips: 28 total, 26 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 40 passed, 4 failed

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
* kselftest-livepatch
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
* libhugetlbfs
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
