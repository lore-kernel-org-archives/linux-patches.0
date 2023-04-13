Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042D762F
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 08:55:40 +0000 (UTC)
Received: by mail-ua1-f54.google.com with SMTP id k20so9875629ual.2
        for <patches@lists.linux.dev>; Thu, 13 Apr 2023 01:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681376140; x=1683968140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7PrjGClB6aBMd5jPrkLLFovctALNVXzd7tpLMl0zzO4=;
        b=y60vwBrMosjjUa5lWyKi3dJna9t5hEp6YTEeDt8R0sXW2YmWqyudV4JZf0AfvtLahj
         IfvyeBlTSKKBmjvUdckFYjgOT6n0kOhhKaDUc2nA1oxJ0xqOL1RqjEb7x/If6mJHeLB+
         ZsaH0kNwtcWlH08gsThfdQuYigJUhHFXMlIkbtHyZlBQdHoeVjHxtA+oO5AZsm3ncMq1
         96XpADM6UiaMk0978OgkI7UOc4pRsup2GcI+osduGZtJeGLY/3e3eBq/AzQSZP9M+H6O
         KcVpfWz3ORh2ZKPCw1A+duiuWyh2SmRdxYBFnRJOw1C+YM6nOvF5RsioVJHETscGsaw0
         Qr/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681376140; x=1683968140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7PrjGClB6aBMd5jPrkLLFovctALNVXzd7tpLMl0zzO4=;
        b=LB3px8biTi3RmL9ahxYWKIoNdwACybmTCGvIVtpJXIP1zTtJbSfpg2INt46ZMhWk3U
         vBbD5EFvHgvm6L/TVaiINtlvbZYDK8AJASmBOPWpVUL/581XWcFSwpMp0ExQZAVV3iIE
         4IELWBqCjWtxZCINwR8UO7AmPjj+zCshxTBR5qkvv9SgunImHY3W8nsS4UvEp3lri+Ae
         OIrE+LEwsZuYRbiQaxWYHPyQ2ds4eisl4FShGONzhJXUODhrDyUhW8qUiC8s9eN/F3KL
         iH0YUnx12T4MB0GKVLkziBl/LMGVmiGmAWXOJl/jE8T8FNNBUAMjpQupDZpmLfRENNBK
         Oz6w==
X-Gm-Message-State: AAQBX9ddcMd/m0P7AvOKf0ltRAyYVc8yJtc+nvwIyIwsEm2IOGaT/50Q
	o3gK/yXMr9aIgQoUs3reCU3Cz/xQRVzbZx6YSIKl6w==
X-Google-Smtp-Source: AKy350Z81to55BJMvhHs6QbXIb8eH6eaUTqPmN7DYMdBoFqQZcGxnpkaVC8M63nSp71akXc2AIK9BL9UAGSl8AFP/lY=
X-Received: by 2002:a9f:3012:0:b0:6cd:2038:4911 with SMTP id
 h18-20020a9f3012000000b006cd20384911mr646593uab.1.1681376139699; Thu, 13 Apr
 2023 01:55:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412082838.125271466@linuxfoundation.org>
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 13 Apr 2023 14:25:28 +0530
Message-ID: <CA+G9fYvNNULQQ809qOxfk=3jqQpSfRvNwW80zNRXXCxbzqxFbQ@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Apr 2023 at 14:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.11-rc1.gz
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
* kernel: 6.2.11-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: 5f50ce97de71b5278626756de07d906a3a4882d0
* git describe: v6.2.9-361-g5f50ce97de71
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.9=
-361-g5f50ce97de71

## Test Regressions (compared to v6.2.9)

## Metric Regressions (compared to v6.2.9)

## Test Fixes (compared to v6.2.9)

## Metric Fixes (compared to v6.2.9)

## Test result summary
total: 186207, pass: 158993, fail: 4143, skip: 22756, xfail: 315

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 142 passed, 3 failed
* arm64: 54 total, 53 passed, 1 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
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
