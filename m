Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8864377
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 02:22:01 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-53d277c1834so68308197b3.10
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 19:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679019720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cU/rQjq3RhEca9wlD/dJREI/qWqiUYpv57PoCQmL1G0=;
        b=Nnf45QhlzbU2mzDMOQ7mr4Oj2K7WpUSdwwGUgPVusEeIob33z+EhzH7zRTtwSYtT2C
         RW4D1B6k9L1c7krE12UkxJd4OVGlNtmwqoqtXNe6CXCSp1qyxIJ1I4e0HN53WlL3R3G5
         pF4dcezHvdiRtLOH8eoH/LD6MFyUSowy39ifGLb6t4m7lfIigOlmn2EZOnZlpAOXjl4P
         TwL+Q8RSB3uxRow6pvYR8292qITfi3KZSB3nshd9N5/JhG9bHdXQ19vwhCYTil0QbWQ7
         q4651o2w5ypcJSOkLJ2s0bVBADY+ze4kVjBg7f20j5gv2KeShfRjb3D5RCu5bkDNCEvz
         9k4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679019720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cU/rQjq3RhEca9wlD/dJREI/qWqiUYpv57PoCQmL1G0=;
        b=P/h8ex930eF+fUaarylDqQkns8sad9c257o6vZXEcPBV20CBDIPwyHtilP+vBqv5pU
         g26LKr/XKXN2k2pxeWd7KJfmPEB8BjFSViw+ZhTSQU6rNo1Tn9VFQQYiCPmKwxvWcAQv
         ff6h63iqBcBn5d5bq1iAv4D92uS8nlSyNKIyx+jPOElS1u/q1dW9zUsTk6955PN6XRvZ
         3FUnRhl5QnueFgmBC4NSmMgBqSLRCoMo/Jjjhn3FM0PxMVSL7nmOuLGslvbWEz4rkjrC
         H2uiqzcO8YwInu7DtY6digyU/BTkuM8mPZmPplsv2yWy9Q39UAM+Xa1FNdojtdsXLyRA
         bpLg==
X-Gm-Message-State: AO0yUKVWagnquj7Le1P9nA7I5crsnCT5NGVnLYq5XGsKq6EUK9cCfI2Y
	CrCVMa0qLwQ9BgieEOnU5M3wSC6aL5wg+kTXzl5c/2dW1LbFK8EXWIA=
X-Google-Smtp-Source: AK7set9cWglT+HwPgC0CXoFDIkOfAK7xE3L2Mr0Y7sFI0j9xTIgK2ePduWEiEoF3TK+U2MOFSFvhGQ+EJUYwsJEMMqU=
X-Received: by 2002:a05:6102:15a:b0:425:b211:3671 with SMTP id
 a26-20020a056102015a00b00425b2113671mr6164901vsr.1.1679019414772; Thu, 16 Mar
 2023 19:16:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230316083443.411936182@linuxfoundation.org>
In-Reply-To: <20230316083443.411936182@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 17 Mar 2023 07:46:43 +0530
Message-ID: <CA+G9fYsejevnZZ_N9Kejtj6Cxk+Z3MNb5cma=vfD3iwPdTn-jw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Mar 2023 at 14:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.103-rc2.gz
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

## Build
* kernel: 5.15.103-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: bc64d631a29ef83d6cdf41d6285f01e3ac03feb9
* git describe: v5.15.101-142-gbc64d631a29e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.101-142-gbc64d631a29e

## Test Regressions (compared to v5.15.100)

## Metric Regressions (compared to v5.15.100)

## Test Fixes (compared to v5.15.100)

## Metric Fixes (compared to v5.15.100)

## Test result summary
total: 141652, pass: 117485, fail: 4068, skip: 19788, xfail: 311

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 42 total, 42 passed, 0 failed
* i386: 33 total, 31 passed, 2 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

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
