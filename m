Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7279D7470
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 18:18:51 +0000 (UTC)
Received: by mail-vs1-f50.google.com with SMTP id h15so32307181vsh.0
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 11:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680718730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=glxfOeVSVdsNEqls63MVTsTFyn/nd1hFXz6JbbUlzZk=;
        b=EaQOBwI+Rn7KBmQNeiZHQKWx7T/0Fx4pbz/BjgEt5/p6ZRR+86ZXb1G9UmUS3aRNrn
         Wxjr0OkEKLyG0HQgUg/0lwbc4TLMlgIOAjdX2fZOSKjiKUTu/sQbZcD5ap9/oZzzMJem
         rp2FnHSDQcxo+nLGSlN+XuwBuMqSKzuA86Vikg0E+MN5JcbBylqs1LH1SKyfOQnXeBNF
         uh21q1tQh399/7INCJBR+VJ8jqhIn4QLbnPNVPN1a/abUEn1Q9pFEM6SGJkMDHyxK1PP
         pRGozVGroMkQtaRHAVLt3e9sH47ZLVmzl1dwCKCoNCLdMtSUoziJ7mxXTBFnjfH9nRpM
         KK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680718730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=glxfOeVSVdsNEqls63MVTsTFyn/nd1hFXz6JbbUlzZk=;
        b=b2qiWdgW9GvYzvY82bxJw9qKI7UjpkdHwIlLcxJ0KXHu4BGc9uf43skTxHWptwYKr/
         N4m6MG7LGhyK8LqVT+w/AgM0KBI2gdrNBfM6VT5iEqduALImRuU4MYocyBIeP8Cp5erb
         tqevnEq8EYZJPCm8OM5DbpNxcVq/mLZ8J/3mR7Mpdz0X3KU9mLs/CRy/sWwm4MN4RWaA
         bYjRxrVm+3GS0XHj3dAbuE8Ds495ProAH4Y4K67B68iE3gkD+yR8549sF5C1ulIkrgeu
         sIfq4fFKbdTp/qkjg6CCl+KHzza6jBob/kt5qjiI/HWD9HIliYKK4zUyEAJtm5Q/w7D6
         qQZQ==
X-Gm-Message-State: AAQBX9dVT/d867BcBhPIY7FYHHNiq63UH2b06THsmuei07Mz5au5zKiT
	nrzIXzPN4TxSr6IFWUNh2WpuD4v8vI2wBNeuDdOl+A==
X-Google-Smtp-Source: AKy350bwbVqEdTqjdgyrLInVXPXvu0EwkFf2vjFlV99WX+nbQQ0VdZUR3MSe9APGiZ7/OF5awDJcbvQGSWyekS2c6v4=
X-Received: by 2002:a67:d91d:0:b0:425:d4de:718a with SMTP id
 t29-20020a67d91d000000b00425d4de718amr5635554vsj.1.1680718730246; Wed, 05 Apr
 2023 11:18:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230405100302.540890806@linuxfoundation.org>
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 5 Apr 2023 23:48:38 +0530
Message-ID: <CA+G9fYvqpuktFDsCZSnoncBTNPTRydXDvTx+vUUcLs1Y9FVJ+Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 5 Apr 2023 at 15:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.23-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.23-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: f8a7fa4a96bb8970f07e44d4a26b9fb41d65d271
* git describe: v6.1.22-178-gf8a7fa4a96bb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
2-178-gf8a7fa4a96bb

## Test Regressions (compared to v6.1.22)

## Metric Regressions (compared to v6.1.22)

## Test Fixes (compared to v6.1.22)

## Metric Fixes (compared to v6.1.22)


## Test result summary
total: 163330, pass: 144637, fail: 4284, skip: 14048, xfail: 361

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 52 total, 51 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

## Test suites summary
* 2d
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
* ltpa-6333033/0/tests/1_ltp-dio
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
