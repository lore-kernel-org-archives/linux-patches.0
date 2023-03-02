Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EA010FA
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 19:25:55 +0000 (UTC)
Received: by mail-vs1-f50.google.com with SMTP id x14so289988vso.9
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 11:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/j+szbSE58dnURjLIRX6YSP1CV5xN0kQwm2Q1/e1lqk=;
        b=CECdGGxM1rboHUH4D/g7f5m+NIeUFAl+kLIGIH2mSDAVwUeimSJbi3mrqu7gr3iEtE
         peSbCyhYVbRcvRxWXxGUAaC5Qb0wX9DMcQN0IEbepfsnyDNgRVpuuSlVivBFhZstkNnU
         /UbP/Ci+Y1j6PtSQ1CFqeor+8Mh46HLbQx5YQEHXWVnWlG+SioCtar6zN8R9MutcjanC
         wbUMZQgTjBCqt2+/uC3R4rmMjJTTylf8cmwcsyHFdjS8KymiFgEMu+4cH8OTAqO95RTg
         MCzwhZ4FxMEcYpszULDMnhDXSm47ipLmGWpYRkE7+dcwWJFlUvXEYxRpSQ7V0PpV+AaK
         20cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/j+szbSE58dnURjLIRX6YSP1CV5xN0kQwm2Q1/e1lqk=;
        b=I6b5vHRy4qceb0EmbY61+jCN/pk3u4c3pHDLu2YNELT+qE0VGDadplP0vqaGrh1epv
         3//fohhJEryQgambUTddjZm5Nl8yP+NipP1lqvzcX3tn2C0GS2Z4DPXmGdFSwwhSX3ez
         xafn1P2J5ZbUlDYE+p87jQwcda4X1rc52kKlXJELGc492GOaejGmMaz83dS07+v7SdUD
         LJ4Wr6CkmAe3VyMgTyULC8kdzNgk1uUvpjMupTsnwAu6cdVrByIQto1FgFwAm5Df782z
         L1PX4TkDbp3vvtZ/dIbwjlFsWWetJ+vVbyg7PZCBLLltJ8K7X76DNqxsni5AkC8TNKRt
         Mecg==
X-Gm-Message-State: AO0yUKU/A37X69PV6pKOxWlcwWCANkukM3F6vU2CTkvpw5P6KOMqMJvH
	EAfe8ZvNsBTf805z6aa8GrhLZNwArVkgsf6+idSfxw==
X-Google-Smtp-Source: AK7set9HKSd7r8tGYGOAy2URg7KGAk19lYlMbPUBQf0TH1FFdLQpU1a9U8n6cRZjEuZXaZocsq1fa8Qwh9VUiZOPLJU=
X-Received: by 2002:a05:6102:3202:b0:412:2f46:4073 with SMTP id
 r2-20020a056102320200b004122f464073mr7212103vsf.3.1677785153830; Thu, 02 Mar
 2023 11:25:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230301180653.263532453@linuxfoundation.org>
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 3 Mar 2023 00:55:42 +0530
Message-ID: <CA+G9fYtsGyCO0cZi1MTgfHRYNqtoJBSx3UVH1VPkDgEQxe4Xpw@mail.gmail.com>
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Mar 2023 at 23:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.2.2-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: ea5e1e557437d270b79d7c4227ae1531d7feb775
* git describe: v6.2.1-17-gea5e1e557437
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.1=
-17-gea5e1e557437

## Test Regressions (compared to v6.2.1)

## Metric Regressions (compared to v6.2.1)

## Test Fixes (compared to v6.2.1)

## Metric Fixes (compared to v6.2.1)

## Test result summary
total: 195531, pass: 167650, fail: 4458, skip: 23423, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 142 passed, 3 failed
* arm64: 54 total, 53 passed, 1 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 26 total, 25 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 46 total, 46 passed, 0 failed

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
