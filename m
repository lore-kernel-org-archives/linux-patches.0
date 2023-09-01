Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A34FBA58
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 13:48:22 +0000 (UTC)
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-44d426d0e05so933491137.0
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 06:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693576101; x=1694180901; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Y1pJnlcxcr9aS7U0SXtwUU5OVorqSWQ8RDiJDyTRyQ=;
        b=IgQiJHtl4yWf03fKZmAN5kIzTWa1Mnlq0UBIk56GozsrYZEolLjTy3vSDk4D0QSijV
         l78jtVW2pWwmsljL1yKYbYTXjh04mcsvzsR626Z1jDpJMeGXKykEZhpHRNjT2BDA2dzZ
         i9/XDCv9bMkSdnZexj1cDnatM8MkLT8zD1g6YZt/Fjqu1xAumQ5IwFzbcA7ReLCwsrMA
         neUcdPBLsoDGvRdoVphWylQiX/MMFdRhyJRxOA0SxOjzhV1aki8DHO3l1DoCLl7NJRXw
         3JGNsIUFNNujgjXCEa9N7hAeYSnN6VdkmHLXhC4nrxAA4xk2Vms8JYMY1TBdprFXjMmu
         wTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693576101; x=1694180901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Y1pJnlcxcr9aS7U0SXtwUU5OVorqSWQ8RDiJDyTRyQ=;
        b=QkadlXY4U2IaR9ZyZANzkUAWmXhCUxTB7FKVd1fL2XvBySrR8StRUvwFRJ3j2A2IED
         bA6mKxVpNEEXQXcYU+pJ4JSqXQ2v2Pin4Xu3/DP4o8PLWCzxFLzZLEZWL53vE9t10KsV
         8CK9/iQ3QK70r1P4kxjrVzBFGr1uICn0hVGUTuzs4I2vTC9hSPMMYYPdeR+73yAWld1p
         pYC2ikbTfpufAwgrMTQQw5VWHjRqsp1EYQz5OFAfFVrtjfeDpc/XJ/8cOKzZ97zSY9z/
         7DuJJy8YDyQAe8mLhTWVMDc1wxiN/CnGuKUdspSIxdxMWA/nFqruye52m7XTJ8IYlriS
         sVhQ==
X-Gm-Message-State: AOJu0Yy9xQePsUBCZ5JDkzyjxtI3E8TPMf0xB5jlDDRfL5k+t8OL7UGJ
	cfaNr1shV08irgwh1wgftk2m3paKDuNWETcDcwRcYg==
X-Google-Smtp-Source: AGHT+IGUhghSIkPH+ZrUUAwPdy2IjMzhegrl6FRcu2MomohR1tz66WYgyxNoVHKIoRNiKXIE/f4Pnv1UdDcmeUjM6ug=
X-Received: by 2002:a05:6102:391:b0:44e:b2a7:13ec with SMTP id
 m17-20020a056102039100b0044eb2a713ecmr2920433vsq.0.1693576100981; Fri, 01 Sep
 2023 06:48:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230831110830.817738361@linuxfoundation.org>
In-Reply-To: <20230831110830.817738361@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 1 Sep 2023 19:18:09 +0530
Message-ID: <CA+G9fYvdFwWNahpwKU44sSc6QV9OMdk8oxMESm1m2wxneZ7kUA@mail.gmail.com>
Subject: Re: [PATCH 6.5 0/8] 6.5.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Aug 2023 at 16:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.5.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.5.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.5.1-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.5.y
* git commit: c2d4e2d6c14c0bff3286f251b99c8e443a586047
* git describe: v6.5-9-gc2d4e2d6c14c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5-9=
-gc2d4e2d6c14c/

## Test Regressions (compared to v6.5.0)

## Metric Regressions (compared to v6.5.0)

## Test Fixes (compared to v6.5.0)

## Metric Fixes (compared to v6.5.0)

## Test result summary
total: 207754, pass: 181885, fail: 1701, skip: 24168

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 140 total, 138 passed, 2 failed
* arm64: 52 total, 49 passed, 3 failed
* i386: 39 total, 33 passed, 6 failed
* mips: 29 total, 27 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 24 total, 21 passed, 3 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 45 total, 40 passed, 5 failed

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
* kselftest-filesystems-epoll
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

--
Linaro LKFT
https://lkft.linaro.org
