Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C058482
	for <patches@lists.linux.dev>; Tue, 16 May 2023 19:10:55 +0000 (UTC)
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-45682803452so6950e0c.2
        for <patches@lists.linux.dev>; Tue, 16 May 2023 12:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684264254; x=1686856254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V8x8LxGklgASWXZfIUthjDXUkwKPEritGvTuKqAgnQ0=;
        b=rz08wUqcXD8OcEBKedTtkVBhAppQzz0VK+GCNxbHThHVOIRTsMYRL1MHxURw/W83Q0
         F4SrKTApeZZAms45OIqzawbeo9YDium1biqIPXbvvk4kOos7ZnUesA2cIr2NsUM0em+P
         4tKwJ/jNzZvYwksMA4rXMGtSUEIhvsK/KUz2BtooZ3fOKggdH3SCcz8cf3vOxOdejLPV
         vG5F4pW5InAGmbhNbVm80ANfjfqngP72I25Rv8waFPlOvGt7f6HzT8hPO562ejb1ZKQR
         FKpbQnsGkyH63Da/a3y/koig1lujZt2Zk8/sLpGofC/LhGpGGemNR7nPedZS69NAJKcf
         8j4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684264254; x=1686856254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V8x8LxGklgASWXZfIUthjDXUkwKPEritGvTuKqAgnQ0=;
        b=ZV1zvnqaIu99AQ5Ju+OlulxYhU2JccxHRMMvMXt5IqAxGgA9g4mjVejJjmW44PSf7e
         bBPHFzTnpPsIkpLn5cERd5T+ejv5p7RnHWWEpLwGeOnTU4VwbcL/Ie27TTL1hH/PXoYD
         x1xYDetBACPtLJ0bLvWA1OcNalU+PUnv9BXZUIU+vj/xsflyigNSf2Z1cI+us5oWnuJm
         AU8grG3TDynyZ1kHVv00hf1uAi4xpameN3M+nYDqS0PQfwgkdfkLjOPWVDx7L9D08wZa
         4taTn+2sgBijnaUOWT5AA0ujZ9rjQSSc1p2RdLDsUte8KQzvROKOEgCoxpcp3dUV3D6K
         AFJA==
X-Gm-Message-State: AC+VfDxe9m0XfN9eXxAfDnAMFZyditn1LiP6SciKAnI1nvthAz7WK4ep
	C1AalZCqNQh/uxpYPGZLVhND8tSr8TlnIy5CDRVdHw==
X-Google-Smtp-Source: ACHHUZ6dGkU+ycU8IPZ+Acm/4+36px6HNGpUVUCJH2Zo0BZ4QFgRC7w8fTc46inQ4m60BrVWOuQBG/kmEohIUsgwlso=
X-Received: by 2002:a1f:e601:0:b0:3ea:7af1:9ea4 with SMTP id
 d1-20020a1fe601000000b003ea7af19ea4mr12398365vkh.12.1684264254241; Tue, 16
 May 2023 12:10:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230515161722.146344674@linuxfoundation.org>
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 17 May 2023 00:40:42 +0530
Message-ID: <CA+G9fYv8K9D-fYghwQxLUZKJ1B3=+HC+u5zy3nrNWUN5sMwtZw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/282] 5.4.243-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, Tobias Klauser <tklauser@distanz.ch>, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 15 May 2023 at 23:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.243 release.
> There are 282 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.243-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kselftest-clone3
  - clone3_clone3

kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

kselftest-memfd
  - memfd_memfd_test

kselftest-rseq
  - rseq_basic_test

 kselftest-kvm
  - kvm_xapic_state_test


Test log:
-------
kselftest-clone3
  - clone3_clone3

# selftests: clone3: clone3
# TAP version 13
# 1..18
# # clone3() syscall supported
...
# # [1352] Trying clone3() with flags 0x80 (size 0)
# # Invalid argument - Failed to create new process
# # [1352] clone3() with flags says: -22 expected 0
# not ok 18 [1352] Result (-22) is different than expected (0)
# # Totals: pass:17 fail:1 xfail:0 xpass:0 skip:0 error:0
not ok 1 selftests: clone3: clone3 # exit=3D1

links,
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.=
4.242-283-gb6ac0ac1f533/testrun/17021938/suite/kselftest-clone3/test/clone3=
_clone3/history/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.=
4.242-283-gb6ac0ac1f533/testrun/17021938/suite/kselftest-clone3/test/clone3=
_clone3/log

NOTE:
The logs are the same as reported on other email reports.
link,
 - https://lore.kernel.org/stable/CA+G9fYu6ZOu_We2GMP0sFnSovOsqd6waW7oKS-Y1=
VPrjdibu5Q@mail.gmail.com/


## Build
* kernel: 5.4.243-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: b6ac0ac1f533c625d5f4a295133abc8c9e4635ea
* git describe: v5.4.242-283-gb6ac0ac1f533
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
42-283-gb6ac0ac1f533

## Test Regressions (compared to v5.4.238-245-g41e24252f52b)

* dragonboard-410c, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* dragonboard-410c, kselftest-memfd
  - memfd_memfd_test

* dragonboard-410c, kselftest-rseq
  - rseq_basic_test

* i386, kselftest-membarrier
  - membarrier_membarrier_test_single_thread

* i386, kselftest-memfd
  - memfd_memfd_test

* i386, kselftest-rseq
  - rseq_basic_test
  - rseq_run_param_test_sh

* juno-r2, kselftest-clone3
  - clone3_clone3

* juno-r2, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* juno-r2, kselftest-memfd
  - memfd_memfd_test

* juno-r2, kselftest-rseq
  - rseq_basic_test

* qemu_i386, kselftest-clone3
  - clone3_clone3

* qemu_i386, kselftest-rseq
  - rseq_basic_test
  - rseq_run_param_test_sh

* qemu_x86_64, kselftest-clone3
  - clone3_clone3

* qemu_x86_64, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* qemu_x86_64, kselftest-memfd
  - memfd_memfd_test

* qemu_x86_64, kselftest-rseq
  - rseq_basic_test

* x15, kselftest-clone3
  - clone3_clone3

* x15, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* x15, kselftest-rseq
  - rseq_basic_test

* x86, kselftest-clone3
  - clone3_clone3

* x86, kselftest-kvm
  - kvm_xapic_state_test

* x86, kselftest-membarrier
  - membarrier_membarrier_test_multi_thread
  - membarrier_membarrier_test_single_thread

* x86, kselftest-memfd
  - memfd_memfd_test

* x86, kselftest-rseq
  - rseq_basic_test

## Metric Regressions (compared to v5.4.238-245-g41e24252f52b)

## Test Fixes (compared to v5.4.238-245-g41e24252f52b)

## Metric Fixes (compared to v5.4.238-245-g41e24252f52b)

## Test result summary
total: 129092, pass: 109664, fail: 3182, skip: 16058, xfail: 188

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 148 total, 147 passed, 1 failed
* arm64: 48 total, 42 passed, 6 failed
* i386: 30 total, 22 passed, 8 failed
* mips: 30 total, 29 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 33 total, 32 passed, 1 failed
* riscv: 15 total, 12 passed, 3 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 39 passed, 2 failed

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
