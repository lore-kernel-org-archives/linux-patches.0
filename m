Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4407123A8
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 11:28:05 +0000 (UTC)
Received: by mail-vs1-f51.google.com with SMTP id d66so19409818vsd.9
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 03:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5aHkZccIrXG+JBu0s8LKPm+pvhsUVfldo95Vi5e7fk=;
        b=aKQDxw4KsU7nZ5z6ECcG3/bWrTGdElS19C+jwXQi4p2cmDYwxPqKWKj3FTweiNaW/2
         OPd4FVMHFiy+zxTa0a8SSKQtzfdewlYx3OwGM7wytkaA9Eo7VN37VCxHUPG8nyZEbk2k
         U5pdN3mft3EuhOhvLdh8Sn1asBgaJXcGKMJmb5QG3YklEsykgiWC9ymM0iE+SreOpb2t
         6454w/CeKnGj9dTJwM7vqiL7hC6ySbAfyD4FTVzi3MEmCiFU7sneDaJZ6K/EGX4Mxfgu
         xVVyHAU7DfyL6sTGnv7OzZ+4K1JRZvwnoLd5ix+4iuENOFouloPPTBK/QLSpC/cvoiBT
         u8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J5aHkZccIrXG+JBu0s8LKPm+pvhsUVfldo95Vi5e7fk=;
        b=FBFKTztzkehP9bftArdsYolBYcRZIMbavzMbsCCBBikKrsVlIDlaPcJzOGRHZ2+cWM
         Vvc66fat4SmVU6eRgbwCvjjCCZvDL8nONI/Iv+SzFd5dWNa4xlg/x9Mus7Gnnl3npqTw
         nQjEEWm6Q9/I6+uKWIO5rkNDmuSwcdRy84cb8EiLDd+VZwCVnPDAiF7K0ywAXerrg18+
         lT/4LPIGHIAlhgFyDMotpkXj+YrNxNOqE2Qggrukm5vMl7Rk5mWfOxvthIXETgryxJCO
         5kD3xdWD0y+FtMLzxUPez62DV6W+mVuWi6ZPwnEWqIttZvkZ1PY23++TKyvU22/07Ihs
         HMHw==
X-Gm-Message-State: AFqh2kpgJNiLcjoreUVer62mat0wBpBPAT+Q1C+llyyQrYFnOBjet0ap
	nQYydiW01+MR+GxSmOOhNjTvc2LsPyLIDBoxgE5n0Q==
X-Google-Smtp-Source: AMrXdXs4De8GAx48B8YpNJsA+KeG0L5IUKg6HQImr8KZWd8C7F/gW+kY+/rIXLx58azrnRKcrFqNPGE5X9/lC/Z8elY=
X-Received: by 2002:a67:b102:0:b0:3d3:dd2d:88d1 with SMTP id
 w2-20020a67b102000000b003d3dd2d88d1mr290582vsl.83.1673954883952; Tue, 17 Jan
 2023 03:28:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230116154747.036911298@linuxfoundation.org>
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 17 Jan 2023 16:57:52 +0530
Message-ID: <CA+G9fYtpsFtS=1gECq97PWPK8uA6-3B-NY0Vkk8Vgd04BskONQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jan 2023 at 21:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.89-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
clang-nightly build errors noticed on defconfig of arm64. arm. x86_64,
i386, riscv, s390 and powerpc.

include/trace/events/initcall.h:38:3: error: 'struct (unnamed at
include/trace/events/initcall.h:27:1)' cannot be defined in
'__builtin_offsetof'
                __field_struct(initcall_t, func)
                ^
include/trace/events/initcall.h:38:3: error: initializer element is
not a compile-time constant
                __field_struct(initcall_t, func)
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.87-101-g5bcc318cb4cd/testrun/14189747/suite/build/tests/
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.87-101-g5bcc318cb4cd/testrun/14189747/suite/build/test/clang-nightly-lkftc=
onfig/log

## Build
* kernel: 5.15.89-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 5bcc318cb4cd6b13569afdfc6d7b5c8c1f408f06
* git describe: v5.15.87-101-g5bcc318cb4cd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.87-101-g5bcc318cb4cd

## Test Regressions (compared to v5.15.86-291-g5e4a8f5e829f)

## Metric Regressions (compared to v5.15.86-291-g5e4a8f5e829f)

## Test Fixes (compared to v5.15.86-291-g5e4a8f5e829f)

## Metric Fixes (compared to v5.15.86-291-g5e4a8f5e829f)

## Test result summary
total: 146655, pass: 122718, fail: 4588, skip: 19036, xfail: 313

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 136 passed, 15 failed
* arm64: 49 total, 44 passed, 5 failed
* i386: 39 total, 30 passed, 9 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
* riscv: 14 total, 13 passed, 1 failed
* s390: 16 total, 13 passed, 3 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 34 passed, 8 failed

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
