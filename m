Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC5817FE0
	for <patches@lists.linux.dev>; Tue,  9 May 2023 17:50:15 +0000 (UTC)
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-77d171a7a71so3530034241.1
        for <patches@lists.linux.dev>; Tue, 09 May 2023 10:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683654614; x=1686246614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4aNOaTI8HiaBrpvAYz/uvXyLMZm5BRoMqS/hObU+XE=;
        b=SXWFRvj6GM+4X5hIZsN1P46oQ/o6sYM/TzLa0dX/TKmILWG4Dh/2bWieF+u4eJEdw6
         9VBVyz94opxC1fRm7PrLMdCVFAN7zRaLZ5TqJYG7RZtQ/6IS0M1ymqEkDOhmvPSqg1AC
         kjS9HuUjvMcBa2If6aict7y/xjj7mLsbybrYzSeL0jnwvn1j7WEzOxDUjePusMWEayRO
         LShXcSL1sBj3aioz4He3xsBbD3X1cSHzoOIyOssNi4H9m2xZzvMvELSOwWSH4NuzvmHZ
         HtveXtYCRJJt4Q5W3da9oYkr0N0VCi9R3KrcUxx4Y2t1e/RnD3vsgsDJBP+VKERlkVzQ
         nNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683654614; x=1686246614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4aNOaTI8HiaBrpvAYz/uvXyLMZm5BRoMqS/hObU+XE=;
        b=RI+GyM0Q+f5HIyRaueH23G+TIbTmtbL6J8Xf8mZXadjzhBX3W04rRYtY75VA3kWt/C
         LW2vPC5jeQQBHxLGM7dUcD2snwnWNxExn42fPMtVNw3PxnXLfSiPFQgWCsUOSDbOfbTS
         Y5hHGlZ9GfjbpJT/BUizqt/ml+rhpcP6E38QUGn+dhxWJsFQtRsRlVU8dg14yAvVh041
         N+3i8CzdXPhmuDpkVeRwGn1ii7+0rJIoFRr0lNHV70cx5aHRFb+mLa/46ToGvwyI42WQ
         ksNGjuT3qsnENlscTtXtvWhcKiy8wOI4XZUgXsQ2DecyhK5FUECm+3xOMA2/xKC377Ur
         RNDg==
X-Gm-Message-State: AC+VfDzMqoJRP3XPsgQ205EWHrsVE+u2hhrUCa8YiXcvhwNJ0EcimC5G
	qFqgpAuqSOycPeWykh1hCGHrxypEYFwUETAQSUIjXQ==
X-Google-Smtp-Source: ACHHUZ4stgvON85kZzf7mBh1ADWZQPAzzLfTGueFSGoY4xHrKTmxyknnwwnoA+zMTop4ntucSfSTceleXS1WPRE3NM0=
X-Received: by 2002:a67:e3bc:0:b0:42f:78d5:d987 with SMTP id
 j28-20020a67e3bc000000b0042f78d5d987mr4749675vsm.1.1683654614028; Tue, 09 May
 2023 10:50:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030653.039732630@linuxfoundation.org>
In-Reply-To: <20230509030653.039732630@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 9 May 2023 23:20:02 +0530
Message-ID: <CA+G9fYtHRB8n_TxA6CrPfkP7FwL6N5Umg1ate_HA+PeLeoqw1A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/610] 6.1.28-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 9 May 2023 at 08:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.28 release.
> There are 610 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.28-rc2.gz
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

## Build
* kernel: 6.1.28-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-6.1.y
* git commit: 2b7e1f92aa55cac65688b3de87716bbd0cbfb88d
* git describe: v6.1.22-1202-g2b7e1f92aa55
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
2-1202-g2b7e1f92aa55

## Test Regressions (compared to v6.1.22-591-g58b654bf36db)

## Metric Regressions (compared to v6.1.22-591-g58b654bf36db)

## Test Fixes (compared to v6.1.22-591-g58b654bf36db)

## Metric Fixes (compared to v6.1.22-591-g58b654bf36db)

## Test result summary
total: 326453, pass: 278244, fail: 7551, skip: 40056, xfail: 602

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 297 total, 295 passed, 2 failed
* arm64: 104 total, 103 passed, 1 failed
* i386: 78 total, 74 passed, 4 failed
* mips: 56 total, 54 passed, 2 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 72 total, 70 passed, 2 failed
* riscv: 28 total, 27 passed, 1 failed
* s390: 28 total, 28 passed, 0 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 88 total, 88 passed, 0 failed

## Test suites summary
* boot
* fwts
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
