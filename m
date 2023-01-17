Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9521FC2
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 10:05:14 +0000 (UTC)
Received: by mail-vk1-f170.google.com with SMTP id b81so14524483vkf.1
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 02:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ADUks9yTf/Q8juwK97Vgij3N+I18qwts6flIIXRuW1g=;
        b=lm8fDethUBmE2tF/S/T65mz1Ez1N98NMh+AGAVOtRxOFDTJDCrfHCAPvOr+uncTb7f
         J1h8Tepfp2StOltbKrmm6Y6mH2IsF5eWGXP5FHl/5eqpkfEpG4cxyqvbQaCgwiWEwPYV
         HCb3uv+8nD2gngtRkFHxLglPaSnrgLRcDm+FrJaUBPhX/QNGy75GFR8J0vUWVzlJcl8N
         alEUUeNAa/ThCBJ6clS84L6zjZkHTxMSkM4oyGhlyfO1gseUfhXYtrEZNZyr/RBMgZJa
         Bgwd8CG72xATJak8e5As64SZHiHg9rTM8R3HzahoYdiFmBoO1MYt/vEoC6A9WEOI5/RW
         BbxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ADUks9yTf/Q8juwK97Vgij3N+I18qwts6flIIXRuW1g=;
        b=BudCed4LzrDummc6HlPBKTkclzb3UoAQoWpfguX06eSP3sWjvBR4pA9jpA9IAi8YAH
         /EkMSJctF9WlKDu9N5ACmeCqip7SjFaAFYOqJGn0e6ezyf+zli/o7EzlwhndMqE4W5y4
         +BV73DQXGdM+DhPapcSjqTsn4zm7Fz+aEhCwUYUQkfrAF3WxXrm2By4+DoKQ8TCPfNg1
         FfkO38YIYMpKaW4l0b9hHS4cZN29iySCiiuXG+1tsf9S0DhHjX+C97V90BCKd97xAUUK
         jGUsI1iGkTyvqumFxbCbABTjxuX8yvejMwpatIXyIyuUYLszax0F9sOxupvQVTY8bT+L
         viig==
X-Gm-Message-State: AFqh2kpdzLd6khGTcGKpghDMcxgRFRkAuyWWjFG1q9RVYg/WNOoRZ7tT
	nwTv/VipVRcUARjqP4TFAjd51+Zdbime5PRMFJCxtg==
X-Google-Smtp-Source: AMrXdXuxDkr7hfChgPx7q101d17fHxJckT0Nb4qAhzmLJoxZl8D/fQo7ULfrIquYdKmPAHqIrJxVAHau/YhXB4hoiNc=
X-Received: by 2002:a1f:2e58:0:b0:3e1:5761:fdbb with SMTP id
 u85-20020a1f2e58000000b003e15761fdbbmr322938vku.7.1673949913163; Tue, 17 Jan
 2023 02:05:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230116154803.321528435@linuxfoundation.org>
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 17 Jan 2023 15:35:02 +0530
Message-ID: <CA+G9fYsyN67A8gWBUZ-Hh4mdu5xXd1OnLpvt2eLOe5QCLJinDA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jan 2023 at 21:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.7-rc1.gz
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
Following clang nightly build errors noticed:
arch/x86/kernel/fpu/init.c:175:2: error: 'struct (unnamed at
arch/x86/kernel/fpu/init.c:175:2)' cannot be defined in
'__builtin_offsetof'
        CHECK_MEMBER_AT_END_OF(struct fpu, __fpstate);
        ^

## Build
* kernel: 6.1.7-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: ffb1fddbd4d044faca0f92a51a9942cc50be62be
* git describe: v6.1.5-201-gffb1fddbd4d0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.5=
-201-gffb1fddbd4d0

## Test Regressions (compared to v6.1.5-11-g5eedeabf82ee)

## Metric Regressions (compared to v6.1.5-11-g5eedeabf82ee)

## Test Fixes (compared to v6.1.5-11-g5eedeabf82ee)

## Metric Fixes (compared to v6.1.5-11-g5eedeabf82ee)

## Test result summary
total: 153284, pass: 136295, fail: 4201, skip: 12767, xfail: 21

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 51 total, 50 passed, 1 failed
* i386: 39 total, 31 passed, 8 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 13 passed, 3 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 38 passed, 6 failed

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
* ltp-math++
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
