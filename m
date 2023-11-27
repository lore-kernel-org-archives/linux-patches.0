Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E00D32C8D
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 19:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ch3yXX0y"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-7c450055f7aso1182446241.2
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 11:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701113244; x=1701718044; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ix962m0e2ECI/JFAX0rtGgMeWo1FWQ2exAEjP9Vo4U4=;
        b=Ch3yXX0yU0nABMsb5u1CE9rpwEsKfac+NfnVFyL57UAZWxNApiL5wIyl6kSoE2gPQ1
         D7tucioFzNF3iPubeCKFOIYKwGHtgQHuCdaCLdWVft7lwHgRuWRPZbGh45rHTx69JSqy
         cB70dysDLfNDXXtJB+47jroBTC3OZ1bdVa1J38LE53YMLL/DisynerfunlPvJeLdZBWw
         /8dFNmdJltsFl9IIpIaCD5lWzQo4Xs2Q29v3oCg2g9b8wo/uOUNkUZ8wcqVnVy0zBPHR
         WXgkjV62Bcp10S6xs69p7Tsz9Jy4oQiO/6hziPKCDTG+bdZT/wWDVh5kyEfiaxVGsCSB
         Alrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701113244; x=1701718044;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ix962m0e2ECI/JFAX0rtGgMeWo1FWQ2exAEjP9Vo4U4=;
        b=Lp86nkw4m+Y3oEA2nwLOJCeIJc1P4wtlEh4koULmqUOP8LsWsvK0KQ4FpneiUMqJcx
         Lg89FJTZ/SgbYhS0qt7ChmfLEml9rrIvjybFBze79eAFi/995eBS936H95u9LESqylrT
         qI0WnjBUN5vatYQHIEPVkXqJvgqNFf6UcdE6K21itO5tqbWGDp3U+ZFvL3pVmtPdC34/
         68L/dwb0ADWxypawcEgyltE/QivfTeVDxzfA36j4GYxfo2UpKKWsCT1/cPAy7+OFAx3U
         WMd8hDSyZIgrO7eJpprHOTUmGAf4N70t+rOglT5mb6NmkWLcGou1akMNArTfUPx9OR8x
         BdlQ==
X-Gm-Message-State: AOJu0YyWyPHb/p8G7eZdxpKLDWBYHCzLchEmVxp9dA9JMAdegiwbzI58
	7TXzL6ZVOUFOo4uhcc51GQghBBaFDZB/Viei3dlXlw==
X-Google-Smtp-Source: AGHT+IHzRq8KZIuJyR03BGekvuV7bhOeMdsJa4Ee9r0MmRoSgwfmTlc3lh+3lluT0hWBxxXGL1fP2HHz4cBrvKhOgZs=
X-Received: by 2002:a67:c589:0:b0:462:e6d1:20 with SMTP id h9-20020a67c589000000b00462e6d10020mr4520510vsk.23.1701113243728;
 Mon, 27 Nov 2023 11:27:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231126154413.975493975@linuxfoundation.org> <CA+G9fYsUXnx4HWyBOGMi3Ko_jT6Y_ejp5ZhcsU+8+_8NUsd=vA@mail.gmail.com>
In-Reply-To: <CA+G9fYsUXnx4HWyBOGMi3Ko_jT6Y_ejp5ZhcsU+8+_8NUsd=vA@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 28 Nov 2023 00:57:12 +0530
Message-ID: <CA+G9fYtThAeNsbmRa1VtHYsR+0psvL5UMQFqcpsuziYTu9GC-A@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/483] 6.5.13-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Nov 2023 at 20:37, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Sun, 26 Nov 2023 at 21:17, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.5.13 release.
> > There are 483 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.13-rc4.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> Results from Linaro's test farm.
> The following regressions found on all arm64 devices.
> Both the regressions are also seen on stable-rc linux-6.1.y.

Not a regression on kernel but latest test cases are not supported
on older stable-rc kernel branches.

NOTE:
Latest kselftests and perf from latest stable-rc testing on the older
stable-rc branches are reasons for these failures.

> 1) selftests: seccomp: seccomp_bpf - fails on all arm64 devices.
> 2) Perf: PMU_events_subtest_1 / 2  - fails on all qemu-armv7 and TI x15.
>
> Test log:
> --------
> 1)
> # selftests: seccomp: seccomp_bpf
> <>
> # #  RUN           global.user_notification_sync ...
> # # seccomp_bpf.c:4294:user_notification_sync:Expected
>
> ioctl(listener, SECCOMP_IOCTL_NOTIF_SET_FLAGS,
>                SECCOMP_USER_NOTIF_FD_SYNC_WAKE_UP, 0) (-1) == 0 (0)
>
> # # user_notification_sync: Test terminated by assertion
> # #          FAIL  global.user_notification_sync
> # not ok 51 global.user_notification_sync
> <>
> # # FAILED: 95 / 96 tests passed.
> # # Totals: pass:95 fail:1 xfail:0 xpass:0 skip:0 error:0
> not ok 1 selftests: seccomp: seccomp_bpf # exit=1
>
> Links:
>  - https://lkft.validation.linaro.org/scheduler/job/7056513#L2725
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.12-484-gecc37a3a8d33/testrun/21318788/suite/kselftest-seccomp/test/seccomp_seccomp_bpf/details/
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.12-484-gecc37a3a8d33/testrun/21318263/suite/kselftest-seccomp/test/seccomp_seccomp_bpf/history/
>
>
> 2)
> perf
>   - PMU_events_subtest_1
>   - PMU_events_subtest_2
>
>  10.1: PMU event table sanity                           :
> --- start ---
> test child forked, pid 339
> perf: Segmentation fault
> Obtained 1 stack frames.
> perf(+0xdfcd9) [0x571cd9]
> test child interrupted
> ---- end ----
> PMU events subtest 1: FAILED!
>  10.2: PMU event map aliases                            :
> --- start ---
> test child forked, pid 340
> perf: Segmentation fault
> Obtained 1 stack frames.
> perf(+0xdfcd9) [0x571cd9]
> test child interrupted
> ---- end ----
> PMU events subtest 2: FAILED!
>
> Links:
>  - https://lkft.validation.linaro.org/scheduler/job/7059997#L2905
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.12-486-g1c613200bbe4/testrun/21344368/suite/perf/test/PMU_events_subtest_1/details/
>
> ## Build
> * kernel: 6.5.13-rc4
> * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> * git branch: linux-6.5.y
> * git commit: ecc37a3a8d335716260debdf063a278ea74379a4
> * git describe: v6.5.12-484-gecc37a3a8d33
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.12-484-gecc37a3a8d33
>
> ## Test Regressions (compared to v6.5.12)
>
> * bcm2711-rpi-4-b, kselftest-seccomp
>   - seccomp_seccomp_bpf
>
> * juno-r2, kselftest-seccomp
>   - seccomp_seccomp_bpf
>
> * dragonboard-410c, kselftest-seccomp
>   - seccomp_seccomp_bpf
>
> * qemu-armv7, perf
>   - PMU_events_subtest_1
>   - PMU_events_subtest_2
>
> * x15, perf
>   - PMU_events_subtest_1
>   - PMU_events_subtest_2
>
> ## Metric Regressions (compared to v6.5.12)
>
> ## Test Fixes (compared to v6.5.12)
>
> ## Metric Fixes (compared to v6.5.12)
>
> ## Test result summary
> total: 150231, pass: 128862, fail: 2428, skip: 18810, xfail: 131
>
> ## Build Summary
> * arc: 5 total, 5 passed, 0 failed
> * arm: 146 total, 146 passed, 0 failed
> * arm64: 53 total, 51 passed, 2 failed
> * i386: 42 total, 42 passed, 0 failed
> * mips: 26 total, 26 passed, 0 failed
> * parisc: 4 total, 4 passed, 0 failed
> * powerpc: 36 total, 36 passed, 0 failed
> * riscv: 25 total, 25 passed, 0 failed
> * s390: 13 total, 13 passed, 0 failed
> * sh: 10 total, 10 passed, 0 failed
> * sparc: 8 total, 8 passed, 0 failed
> * x86_64: 47 total, 47 passed, 0 failed
>
> ## Test suites summary
> * boot
> * kselftest-android
> * kselftest-arm64
> * kselftest-breakpoints
> * kselftest-capabilities
> * kselftest-cgroup
> * kselftest-clone3
> * kselftest-core
> * kselftest-cpu-hotplug
> * kselftest-cpufreq
> * kselftest-drivers-dma-buf
> * kselftest-efivarfs
> * kselftest-exec
> * kselftest-filesystems
> * kselftest-filesystems-binderfs
> * kselftest-filesystems-epoll
> * kselftest-firmware
> * kselftest-fpu
> * kselftest-ftrace
> * kselftest-futex
> * kselftest-gpio
> * kselftest-intel_pstate
> * kselftest-ipc
> * kselftest-ir
> * kselftest-kcmp
> * kselftest-kexec
> * kselftest-kvm
> * kselftest-lib
> * kselftest-livepatch
> * kselftest-membarrier
> * kselftest-memfd
> * kselftest-memory-hotplug
> * kselftest-mincore
> * kselftest-mount
> * kselftest-mqueue
> * kselftest-net
> * kselftest-net-forwarding
> * kselftest-net-mptcp
> * kselftest-netfilter
> * kselftest-nsfs
> * kselftest-openat2
> * kselftest-pid_namespace
> * kselftest-pidfd
> * kselftest-proc
> * kselftest-pstore
> * kselftest-ptrace
> * kselftest-rseq
> * kselftest-rtc
> * kselftest-seccomp
> * kselftest-sigaltstack
> * kselftest-size
> * kselftest-splice
> * kselftest-static_keys
> * kselftest-sync
> * kselftest-sysctl
> * kselftest-tc-testing
> * kselftest-timens
> * kselftest-timers
> * kselftest-tmpfs
> * kselftest-tpm2
> * kselftest-user
> * kselftest-user_events
> * kselftest-vDSO
> * kselftest-vm
> * kselftest-watchdog
> * kselftest-x86
> * kselftest-zram
> * kunit
> * libgpiod
> * libhugetlbfs
> * log-parser-boot
> * log-parser-test
> * ltp-cap_bounds
> * ltp-commands
> * ltp-containers
> * ltp-controllers
> * ltp-cpuhotplug
> * ltp-crypto
> * ltp-cve
> * ltp-dio
> * ltp-fcntl-locktests
> * ltp-filecaps
> * ltp-fs
> * ltp-fs_bind
> * ltp-fs_perms_simple
> * ltp-fsx
> * ltp-hugetlb
> * ltp-io
> * ltp-ipc
> * ltp-math
> * ltp-mm
> * ltp-nptl
> * ltp-pty
> * ltp-sched
> * ltp-securebits
> * ltp-smoke
> * ltp-syscalls
> * ltp-tracing
> * network-basic-tests
> * perf
> * rcutorture
> * v4l2-compliance
>
> --
> Linaro LKFT
> https://lkft.linaro.org
