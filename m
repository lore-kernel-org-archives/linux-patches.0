Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907E2156E1
	for <patches@lists.linux.dev>; Tue, 16 May 2023 09:51:26 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-43278f6d551so4547656137.1
        for <patches@lists.linux.dev>; Tue, 16 May 2023 02:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684230685; x=1686822685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n2e2aRQTpSE5fZJpALXSGEp9ZMam9rQI/gFfLnRQbZ4=;
        b=W2n5N6xceU9E6DMetebRhb2A9hvIIBU1CGqi1slMPSuuzedKCcNze+b0SzicqfQ41T
         Zkwm+qlOHgvxUnMBK+TOFnz1FjT8A0bgY4RoLdjw+6jKZ9at5hK4dNGv+bflLagkSGiC
         SVBAYEDYfxv4SyXpm/rjkb57C0uIE8YjnWYLt38gvuz1oFaicB/jv+rz8a0E8g/ofpXX
         wzRzHEKcRL2mUIHx3vj6i87/X2qBvFSOfIYtNi5luD9du8ETX8OtRdaEFlTQ/DdUKzH+
         koLlCa2crHoU2nvO7VYuUIVfX1cBlMowp05oCbomlp1Libfe0CQMktjWpCGjJrYhFkT1
         IxVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684230685; x=1686822685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n2e2aRQTpSE5fZJpALXSGEp9ZMam9rQI/gFfLnRQbZ4=;
        b=BwnbFv+mgrDjDKvvMM7oxnHNN/7VaKRWt+b2mv6lfL6ZTxezDTUtbXMCGwVAMu3tzr
         U2BqQrYLf+9i8I10/W8xJzsd6jc0VuN7kC8QUH6JY2lqj2mOkO0l0o2b6Zrd49341A0Y
         VQK22fXm/wDei3EZMytmWFGDxYfKnCcIhJY1GT1ihZho6XmZocGnooWA/VXBCsWqojUd
         ejEnivx1FDk8c5YGIsGYokguzJl0pYxEMeaS0nkABt6celdKO/VK0M80dCdjPfio3AOH
         Rb+rJnvf9lsvR8xz3hjd+2Mznj9YbVJ7O64RTx3ryBVv+Wl3hwYFmQJsnbtgbsMk0N8k
         oN5A==
X-Gm-Message-State: AC+VfDxQwO1tPDflYd5CBS8xyB/xbiR0tqKIp+HqEl9UnSAT3tn3asJN
	5nJKqSihndeV9DJ+kg1NMn3Uk36p6qIAGUh+BVz1Ew==
X-Google-Smtp-Source: ACHHUZ7hs/hMaUaznEhI5WQgqjO5glq1y/5QRDPduABfuhohS4CW+zI/cHuoWmN5WNyxBtCLJO2jzfoAfJpwkDVXL2U=
X-Received: by 2002:a05:6102:303a:b0:434:50e9:164d with SMTP id
 v26-20020a056102303a00b0043450e9164dmr13449095vsa.17.1684230685289; Tue, 16
 May 2023 02:51:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230515161722.610123835@linuxfoundation.org>
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 16 May 2023 15:21:14 +0530
Message-ID: <CA+G9fYsZSjQcyUQGS_dT_P3gj3VNZd4de9+6O6VK5+RTkcaa1w@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/246] 6.3.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 15 May 2023 at 22:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.3.3 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.3.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.3.3-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.3.y
* git commit: 5a952cfef67ce264699425e499ad25cc5fb16730
* git describe: v6.3.2-247-g5a952cfef67c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.3.y/build/v6.3.2=
-247-g5a952cfef67c

## Test Regressions (compared to v6.3.2)

## Metric Regressions (compared to v6.3.2)

## Test Fixes (compared to v6.3.2)

## Metric Fixes (compared to v6.3.2)

## Test result summary
total: 139910, pass: 123164, fail: 1983, skip: 14532, xfail: 231

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 144 passed, 1 failed
* arm64: 54 total, 53 passed, 1 failed
* i386: 41 total, 40 passed, 1 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 26 total, 25 passed, 1 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
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
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
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
