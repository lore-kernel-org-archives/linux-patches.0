Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C923377
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 01:38:13 +0000 (UTC)
Received: by mail-vs1-f43.google.com with SMTP id y3so3211653vsl.11
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 18:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679017092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBn6JQBx1SHJKZPB8zhAUv5Fuj/NGhkfmZs2i9hUcgA=;
        b=FG1EYVYdASOEs5PEIu0lXb6o34qMOplqYGGprFQXDnyCxeLmik+TqdNAFKcbg87hTz
         daK8DPDMhSS4Oi+3xE0uH3JIsQhaqoZL1TqjyfcgUK2sijfi5Lw+Wr5kDbLpijtd/1Wh
         QTmnGVCczewvFTbfMIPTK3p1WgraxXq+VkCTrwZ6zdrtj7RbOuI73jIcYOexOFWSK8at
         JVvxK6esPsN+14+2CHOQp0Y9utSBH7nd+HZwOFU3cdpSHxprv7fKWaEgdWLdadDoJQ7u
         VpRNa+FM2/3mwCbefIQGgtKgL0jJMHvjEa2Bg8t6GoSLrd4mRSR/SlT1TFS6gnDVeAW7
         xQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679017092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bBn6JQBx1SHJKZPB8zhAUv5Fuj/NGhkfmZs2i9hUcgA=;
        b=2tDM8G47s7dHhEwh5VdKQut3waHsjCOXH+7u76hZc72rZ58SMHXvqBwsw7T/Lg6teZ
         Kt2KBzucUitcMu2uAp9TPKQF7O9pYyGvep0qlv3gAb3ATkg7MeVc85O8ieLErfl9cETZ
         uVAWiAc0Wj/qOhIBNNHoxCfgB8cqCXzLaASJ/sNOsclgS2G0kCyHOOa/n2hMGgPHZsqm
         b/S4ranJXhkMHm83uwTIpGvnDe/i4SeJKw2lVt849A0JKNdPTyI6rCE5jjoo1ZbJsqPh
         OAOarDL7yNNEoiG44BXMplmT9St1EJR7YvkqVDijXUpLXIpPHdkkjUz9bCIjnpcNF9/M
         VygA==
X-Gm-Message-State: AO0yUKXEiR+YlfpFfyI7FxIrwU7vP68ccv0OCq/0iN3LEMQQeoONqIKA
	UAjC6GcyusePDi/7gI3nPrdKrhKMpaxdrlgrcmt04w==
X-Google-Smtp-Source: AK7set8YSeusCd3ChZiDth1ZhkI6JI9Z0uq4CmeAATOagrzse4aeQHdjPRsmr+k9SuLvkMvvlZcIWBRnIAwrQievH/0=
X-Received: by 2002:a67:f8c7:0:b0:412:4e02:ba9f with SMTP id
 c7-20020a67f8c7000000b004124e02ba9fmr30451280vsp.1.1679017091998; Thu, 16 Mar
 2023 18:38:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230316083443.733397152@linuxfoundation.org>
In-Reply-To: <20230316083443.733397152@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 17 Mar 2023 07:08:00 +0530
Message-ID: <CA+G9fYuErbJtY68zb32gkggNb96GRznoLS7OLfDSqBDD6-eJBw@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/137] 6.2.7-rc2 review
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
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.7-rc2.gz
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
* kernel: 6.2.7-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: 2756d84ffc14891b590f8d8e516ee60adea3b3b8
* git describe: v6.2.5-143-g2756d84ffc14
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.5=
-143-g2756d84ffc14

## Test Regressions (compared to v6.2.5)

## Metric Regressions (compared to v6.2.5)

## Test Fixes (compared to v6.2.5)

## Metric Fixes (compared to v6.2.5)

## Test result summary
total: 190311, pass: 163849, fail: 3908, skip: 22192, xfail: 362

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
* ltpa-6278247/0/tests/4_ltp-fsx
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
