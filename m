Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881C6101CF
	for <patches@lists.linux.dev>; Tue, 16 May 2023 18:04:08 +0000 (UTC)
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-4363ba01c0dso3761419137.0
        for <patches@lists.linux.dev>; Tue, 16 May 2023 11:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684260247; x=1686852247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vvzg25v2oIEfNdNdkr9ntW85A+SET9yRI5a0pRi7L/0=;
        b=sEdkWnYfz1zslsG4WM18jSxyezgQrNq463fZoa8yCdWUxYbfMTl0vdCbxMmpaTSNub
         u6qn2ZO84qSn6oRYdupCOT6b2cNJSzhwxup1lB4OIFwpwUJPfgXrRwQa32vpPgTPpDSH
         bH6XrJinPH8xYTT8EW6qgBaCo2RYV+gQ1es7P6Xn6mgUZpK6fAAoqDlqe0IeCd4Ty8C1
         kdIDNyMqLmVdhvImg8TMZNqpDQozc1sma2EyiW2XUpcxH65NLDr6+GHP8ZKFYyWEricc
         FnH1efXODtqTImOEADh97BKcJvJlJPNw3+eMqQwWeCuAME/rHjTZ9QSJ06rBndqllLn7
         3TKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684260247; x=1686852247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vvzg25v2oIEfNdNdkr9ntW85A+SET9yRI5a0pRi7L/0=;
        b=fTjBbWVvMlBIbs55zY7Od2SYdBGT6L9UF/RTJSVLclvrvV4+tZ3Sc3y5UgItB+4dK7
         qzuG3vySTxtAmC6Ze0KfKK/wPgDfK8lXLNfccgS4ht3xeEaevwhzBFrRTf67Ku6k8BQl
         6UqhLIALsygIEpE3Sl1rT1Q0Xp97EE1l6xLS+Cg09B4KsG9gmgHhDqs2I3falKpuE/bG
         Q90m8Ly1rJgaG/mCjlFBaJC85MLX2qXyJ7w0YUvWu9rpqjKOyed8iRbD/P27Vq6RTtHH
         eEgiGVHZhRXkaulHQKtOsjRfuJ6qtPpC9+wlP4go5AoljktZE+NXMFJzLAi4EtHSLB2/
         +BaA==
X-Gm-Message-State: AC+VfDwkSpfku7glnlbBkuSnOhwuy0Ijra80JAltTYXyxygBt1zcokqy
	Ly3Xv5ZDm4E/i7Zgs4G78zES/f4D8zFSqqM+xkI2Z9kzjpixskXp95w=
X-Google-Smtp-Source: ACHHUZ4dCOV4LauCVxAwh+D6cPCaNzdjf9tHbKfIBWRaLaT+SOP3CuFj1esRSO97triBxPPZXU/cNH8fWdGrpVBvIVQ=
X-Received: by 2002:a05:6102:3cd:b0:42e:63a5:b711 with SMTP id
 n13-20020a05610203cd00b0042e63a5b711mr16338138vsq.10.1684260247144; Tue, 16
 May 2023 11:04:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230515161736.775969473@linuxfoundation.org>
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 16 May 2023 23:33:55 +0530
Message-ID: <CA+G9fYsCjQPQxde3-vw6SKmPPr16Gy4-P4uOCh7r6iEDwDpf9w@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/381] 5.10.180-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 15 May 2023 at 23:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.180 release.
> There are 381 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.180-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
Regressions on arm64, arm, x86_64 and i386.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

We have recently upgraded our selftest sources to stable-rc 6.3 and
running on stable rc 6.1, 5.15, 5.10, 5.4, 4.19 and 4.14 kernels.

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
  - kvm_xapic_state_test


NOTE:
The logs are the same as reported on other email reports.
link,
 - https://lore.kernel.org/stable/CA+G9fYu6ZOu_We2GMP0sFnSovOsqd6waW7oKS-Y1=
VPrjdibu5Q@mail.gmail.com/

## Build
* kernel: 5.10.180-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 065b6901e6dab7dcc7c8884779b96269724c7201
* git describe: v5.10.179-382-g065b6901e6da
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.179-382-g065b6901e6da

## Test Regressions (compared to v5.10.176-363-g1ef2000b94cb)
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

* i386, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* i386, kselftest-memfd
  - memfd_memfd_test

* i386, kselftest-rseq
  - rseq_basic_test
  - rseq_run_param_test_sh

* juno-r2, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* juno-r2, kselftest-memfd
  - memfd_memfd_test

* juno-r2, kselftest-rseq
  - rseq_basic_test

* qemu_i386, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* qemu_i386, kselftest-memfd
  - memfd_memfd_test

* qemu_i386, kselftest-rseq
  - rseq_basic_test
  - rseq_run_param_test_sh

* qemu_x86_64, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* qemu_x86_64, kselftest-memfd
  - memfd_memfd_test

* qemu_x86_64, kselftest-rseq
  - rseq_basic_test
  - rseq_run_param_test_sh

* x15, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* x15, kselftest-rseq
  - rseq_basic_test

* x86, kselftest-kvm
  - kvm_xapic_state_test

* x86, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* x86, kselftest-memfd
  - memfd_memfd_test

* x86, kselftest-rseq
  - rseq_basic_test
  - rseq_run_param_test_sh

## Metric Regressions (compared to v5.10.176-363-g1ef2000b94cb)

## Test Fixes (compared to v5.10.176-363-g1ef2000b94cb)

## Metric Fixes (compared to v5.10.176-363-g1ef2000b94cb)

## Test result summary
total: 126856, pass: 105919, fail: 3576, skip: 17174, xfail: 187

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 45 total, 42 passed, 3 failed
* i386: 35 total, 33 passed, 2 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 26 total, 20 passed, 6 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
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
* kselftest-sigaltstack
* kselftest-size
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
