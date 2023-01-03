Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5103D62F
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:34:10 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id o63so26249774vsc.10
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 00:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0LRzaF4/eAHl8TOiwxl4NBIKM++7t47+klDG5YxwLE=;
        b=fnT59MiryMAYp0O8jmgcwbPbaobGE32AFR+KpPHkGFbsJ8FkMuDJsg/AFohviUbq9+
         8TsUmScZMvFqdccMQI+A7HIiPyl4o+wyvBbAgxq2s37iJZRVNLPHjc4LMoAixKDnlEYA
         2Qo8Z9uXG0lJiGQ1GEw10CcYpzcSRtSEBnbx8qJIjLYz46wTYIneUUHBCSCbSKdO9Cyx
         /yzqXlLP+kdE0lF4/zfiYQxyHsPQ87APfo2vKxQJ3jSCGWzVjwkcIN6xlcVeokmCyPOc
         JE3SvNH2+jiCaY1XiKiEDolPadoIkrz/LX7bW6rlL2SjptuAf5GJdvfkheFFLVibR/Xl
         MPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0LRzaF4/eAHl8TOiwxl4NBIKM++7t47+klDG5YxwLE=;
        b=ygI5wU6bYeM56ag6X0MdRixdl7wuuzEM2iWkQYxO34jwGTZmorMr8t2fvxWjI8Hsrr
         uECBaJfN29hFxfaNsiCUmOMvctAggzeVkW+vbCaI3EETx5nGhgg+ky90rB7fM4jCoJow
         mxAv7Z3AsZ0fHYPyN5BfHFn78VNoU/gLiq/EoZKM1bEMzln3DyrLOSQQ0RO8wW1zwfhy
         jivQj17bBG8XboEA9FPWyzEgehXaWc3Z+G2rQhqpn0wDBjfNgCE6FfK5ZFNrAyi8EoHU
         mpD2qkZ8fKEvTq3BCefXipBo5VXliglft9FOuZe4Ex/CAlETFDykx9p6kR+Lt7Gk1vsc
         LQZA==
X-Gm-Message-State: AFqh2krbfF+A/LWH0obtdzUjwhbOS34RSsfTVJYgyL8CGlVNi2Yj5WxP
	SrzZyvNrdB6ENTwk4pWchlCRtbkBt9+tpMFIlP79GQ==
X-Google-Smtp-Source: AMrXdXuciQboi6XVi++eNEEmorcFjhwmSXVig2GCgBHpcRFA34Dd6NWZp0egXm/aJE33u2Po7Mh+CoF5UHCKLKTcXzA=
X-Received: by 2002:a67:ec94:0:b0:3b5:32d0:edcc with SMTP id
 h20-20020a67ec94000000b003b532d0edccmr4702598vsp.24.1672734848954; Tue, 03
 Jan 2023 00:34:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230102110552.061937047@linuxfoundation.org>
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 3 Jan 2023 14:03:57 +0530
Message-ID: <CA+G9fYvEOcOrPROaDWXpuuyNFh1apk_-hiRZpZbFQJYXR4Hu4Q@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Jan 2023 at 16:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.0.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.0.17-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-6.0.y
* git commit: 9c0ac88985a8f62726941213c92ff8eddf500f72
* git describe: v6.0.16-75-g9c0ac88985a8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.1=
6-75-g9c0ac88985a8

## Test Regressions (compared to v6.0.15-1067-gf54b936f8ec7)

## Metric Regressions (compared to v6.0.15-1067-gf54b936f8ec7)

## Test Fixes (compared to v6.0.15-1067-gf54b936f8ec7)

## Metric Fixes (compared to v6.0.15-1067-gf54b936f8ec7)

## Test result summary
total: 143234, pass: 127347, fail: 2737, skip: 12854, xfail: 296

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 146 passed, 5 failed
* arm64: 49 total, 49 passed, 0 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 41 passed, 1 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
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
* kselftest-vm
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
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
