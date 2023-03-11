Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9A17B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 06:57:33 +0000 (UTC)
Received: by mail-vs1-f48.google.com with SMTP id o32so6650478vsv.12
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 22:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678517852;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vgdPDpd/UGNlIjqFRewIYZuipZ5SZ6ADoBVeG2r1SyU=;
        b=naFt/MGAuhhivbgt/8cEyDQhBUvwpy2sl0pfhuIMCb27ptJIIm8RadFZokbMSe+pa2
         vyPtQ0zBcgyuqVQUCK4BVIAb57Pxc7HBHlwHBbLkv6P/yV6aQHdCYJLpodxdgocfX6/3
         biDsoEkAd0j9QjtVOFq17VQJM9uJ0Q4uXV5ci3b2vsYZVsy71LNLvSyQVZo0ZX1cvNL0
         RnOgldtF+e64EyF5hk3SPjbWPAdqIhWo/O5nDql4U48ewqxp3L0+qmYSWupb7hpAemsC
         2aNtqjlojZOuSeALo4YBBxhbhNsRqgwug1G4e9jAQqBePx0/FiChMYRFYJMG0W8M3wR+
         r1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678517852;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vgdPDpd/UGNlIjqFRewIYZuipZ5SZ6ADoBVeG2r1SyU=;
        b=KjkD/wQ+jFwg+0gx9BiUWYIYebTL8DYUN5tkUl4HcGSYUtbaopTWu3827GPLJgfNRB
         F6c/t7v4ITdRcsMBERMER6EOpW4wxJpmym4+LxQ2PsT2zqFy7xwBgsRPe8ajgRJa26j6
         EUXIYWq8S7VdU/HYVncODzsNw/KxldZbXaLgsssxsZMhBIim3HFFlSWSEd1agQ3021Bk
         i6Xdd76Evje32/qaweHnOI3KEGe17ojfJRdPEPufz+tV/XG2uJlsqB3e1kKXXxSdOkTr
         UyNkZFOQze6DvKVKVNjagwgsbutEzmOhOXP14MCLTxqxBOQa8aEr0YdpxQt+fQDN07f3
         dkxg==
X-Gm-Message-State: AO0yUKUGuaK4gAH4fR46GduUqwnyTMYtoUE+iHcgB0uRiO61YkA7qIg2
	Je2GbZSAlFaQQ52PMVphGABOU7hc6ShhgCdhnNCE1w==
X-Google-Smtp-Source: AK7set9l7pGapuGhKY2Ko1dHU8JGwrP82s/R7szPdich/FsdTXWES4QS8A2KIuEQsQi7Pyvw/iFJ8zl3kudK0LV9aVc=
X-Received: by 2002:a67:cfc6:0:b0:402:999f:51dd with SMTP id
 h6-20020a67cfc6000000b00402999f51ddmr18753346vsm.3.1678517851950; Fri, 10 Mar
 2023 22:57:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230310133733.973883071@linuxfoundation.org>
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 11 Mar 2023 12:27:21 +0530
Message-ID: <CA+G9fYsn6W73x+Mox3XcG9bp-eZ4URbuJ7MdwxzJyM2132VD9Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/357] 5.4.235-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Mar 2023 at 19:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.235-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.

As others reported, s390 build regressions are noticed.

* s390, build failures
  - gcc-12-defconfig
  - gcc-8-defconfig-fe40093d

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.234-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 71be0366b84f5ed2ce06bcc6feddf31053a41c73
* git describe: v5.4.233-14-g71be0366b84f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
33-14-g71be0366b84f

## Test Regressions (compared to v5.4.233)

## Metric Regressions (compared to v5.4.233)

## Test Fixes (compared to v5.4.233)

## Metric Fixes (compared to v5.4.233)

## Test result summary
total: 124659, pass: 103137, fail: 3281, skip: 17853, xfail: 388

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 144 total, 143 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 10 passed, 2 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 37 total, 35 passed, 2 failed

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
