Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5762A34CD4
	for <patches@lists.linux.dev>; Tue, 16 May 2023 17:34:01 +0000 (UTC)
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-44fd15d6824so5108095e0c.3
        for <patches@lists.linux.dev>; Tue, 16 May 2023 10:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684258440; x=1686850440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CLMEKMBrgw9RbU/hZXO4mG7XXZKQ76MkcdKnMFy+hfY=;
        b=KRatI7Sgf8h87eDFgChPOpHPWXS1V7gITx7aG7QiTTtmQF/n8Xu9un+E+c4fjBZAo/
         R5IpKpW7F0j4o8c3FLGfJ0WOQsAQyRYlBl+2/rkmCrD8pp1WR/S6v4v4mK0dTeh1tSYR
         ZNK0g/lia9RgkXpPNpoWdn3tdQEyKrpl3m7rm6x1MzAD8QmR4NVTVD5R+RkV5/GexwQF
         RRKJi895OqLqVuIFY0E0lAG0FOBIqu5MLHiojekTrSQ8ld39PNUPgcU8AYttzkUF6FLW
         gKIq3gxbrmAUZphUzfxPvXocTqwrajIAPmreMZ5UvVB/ZN7TqGxgjnrwEGFDuDPeOXfm
         t0tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684258440; x=1686850440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CLMEKMBrgw9RbU/hZXO4mG7XXZKQ76MkcdKnMFy+hfY=;
        b=AOwHzXKvrm3eSoTFDPgT9aY2vGiQ5CC1JX4A1Nx5LDqY4G7NJ5chV5JxgZR4XmF4PS
         /etTzUc0Zh9uGTmVFJfiA6E3iqAgogzdfX1FMq5eJyoeqYnaGfrhnySpxlcoUdSCIHAS
         K3sCv08A2LC69OiFFYQxFDGtTxO/rTyhXUJaX6Lo3NPsy2x91UgCgWMBXymzFkFFM29i
         A55Q8W+mPBoz+4Cce6/+hlySV+onExjiJ6BZcyXiaME2BplFK4xlI4nAZ2WNi3UQ2WcL
         yVSqlZpHra+oKwTFHyAj3FHnVLiesf1UpF/X8Sb7tjDJez32RQS833CcpLqMXBPeHVQa
         Q87w==
X-Gm-Message-State: AC+VfDyHXvH1CKHWpBTpfMFAR7ph1n7dnHIGffvj/nRppgWXk742Y43a
	st034jEW3SvYJmJUPrPfn0N0Ea8kDtGl7qjKA/7hMg==
X-Google-Smtp-Source: ACHHUZ4e2EQb1Dc1LF//Gk/kjUytnWpxK5PxZvQ52iMpvJYfWkKpTaOFisuD30qijWcxQAAEdcNgQEWkCf84UZ4EIBU=
X-Received: by 2002:a1f:62c5:0:b0:44f:acc2:1279 with SMTP id
 w188-20020a1f62c5000000b0044facc21279mr12120062vkb.8.1684258440003; Tue, 16
 May 2023 10:34:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230515161702.887638251@linuxfoundation.org>
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 16 May 2023 23:03:48 +0530
Message-ID: <CA+G9fYtS3dv8YYgK4LFZLa7H45SE2n9upY-_hTe8p+PJde5esg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/134] 5.15.112-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 15 May 2023 at 22:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.112 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.112-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
Regressions on arm64, arm, x86_64 and i386.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

We have recently upgraded our selftest sources to stable-rc 6.3 and
running on stable rc 6.2, 6.1, 5.15, 5.10, 5.4, 4.19 and 4.14 kernels.

List of test regressions:
=3D=3D=3D=3D=3D=3D=3D=3D
kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

kselftest-memfd
  - memfd_memfd_test

kselftest-rseq
  - rseq_basic_test

 kselftest-kvm
  - kvm_hyperv_features
  - kvm_xapic_state_test

ltp-commands
  - mkfs01_ntfs_sh

NOTE:
The logs are the same as reported on other email reports.

link,
https://lore.kernel.org/stable/CA+G9fYu6ZOu_We2GMP0sFnSovOsqd6waW7oKS-Y1VPr=
jdibu5Q@mail.gmail.com/

## Build
* kernel: 5.15.112-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 070cc2c270b16bbdaf1701b7ade29ab4475f9423
* git describe: v5.15.111-135-g070cc2c270b1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.111-135-g070cc2c270b1

## Test Regressions (compared to v5.15.111)
* bcm2711-rpi-4-b, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* bcm2711-rpi-4-b, kselftest-memfd
  - memfd_memfd_test

* bcm2711-rpi-4-b, kselftest-rseq
  - rseq_basic_test

* dragonboard-410c, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* dragonboard-410c, kselftest-memfd
  - memfd_memfd_test

* dragonboard-410c, kselftest-rseq
  - rseq_basic_test

* fvp-aemva, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* fvp-aemva, kselftest-memfd
  - memfd_memfd_test

* i386, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* i386, kselftest-memfd
  - memfd_memfd_test

* i386, kselftest-rseq
  - rseq_basic_test
  - rseq_run_param_test_sh

* i386, ltp-commands
  - mkfs01_ntfs_sh

* juno-r2, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* juno-r2, kselftest-memfd
  - memfd_memfd_test

* juno-r2, kselftest-rseq
  - rseq_basic_test

* qemu-arm64, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* qemu-arm64, kselftest-memfd
  - memfd_memfd_test

* qemu-armv7, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* qemu-i386, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* qemu-i386, kselftest-memfd
  - memfd_memfd_test

* qemu-i386, kselftest-rseq
  - rseq_basic_test

* qemu-x86_64, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* qemu-x86_64, kselftest-memfd
  - memfd_memfd_test

* qemu_i386, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* qemu_i386, kselftest-memfd
  - memfd_memfd_test

* qemu_i386, kselftest-rseq
  - rseq_basic_test
  - rseq_run_param_test_sh

* qemu_i386, log-parser-boot
  - check-kernel-bug
  - check-kernel-kfence

* qemu_i386, log-parser-test
  - check-kernel-warning

* qemu_x86_64, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* qemu_x86_64, kselftest-memfd
  - memfd_memfd_test

* qemu_x86_64, kselftest-rseq
  - rseq_basic_test
  - rseq_run_param_test_sh

* x15, kselftest-rseq
  - rseq_basic_test

* x15, ltp-commands
  - mkfs01_ntfs_sh

* x86, kselftest-kvm
  - kvm_hyperv_features
  - kvm_xapic_state_test

* x86, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* x86, kselftest-memfd
  - memfd_memfd_test

* x86, kselftest-rseq
  - rseq_basic_test
  - rseq_run_param_test_sh

* x86-kasan, ltp-commands
  - mkfs01_ntfs_sh

## Metric Regressions (compared to v5.15.111)

## Test Fixes (compared to v5.15.111)

## Metric Fixes (compared to v5.15.111)

## Test result summary
total: 127590, pass: 106736, fail: 3622, skip: 17042, xfail: 190

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 32 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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
