Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2667B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 13:41:49 +0000 (UTC)
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-7720fa201caso1654320241.0
        for <patches@lists.linux.dev>; Tue, 25 Apr 2023 06:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682430108; x=1685022108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZuiRCDNTR+aslqONRhJM2+3tVJRD1pBuBmPqOctwH0=;
        b=dTrJ2sW03vohY+xPTnk9IXzYMmHf6tMmeKN6fa4zo/9MrBmVLhQqhPTbA64QzYjMsd
         HBd2FXDTllIw/PVG+qNEIIF/k0JQVRSVgNMjFQAqDqk4qNhYzk06uBdX1QwmF9BjulTu
         IRe78xBm34LSHdq5ugHbonkweOI6STc4e4TGSv3d2sHHMxjdCIm5/Divhn92F2jBElv8
         xYCPUoa3gxl+1z+4z3JTnKwhUaTKaEcLH21/vkunomZ6hk7ycBe512LV/JLfjsuAl5a6
         NcDhBzKFKSEeAaoA4m5hbUhznE5zCqYQTA63EBMH+DjGtJTERtqx3eUuewnhe+uHanx1
         /6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682430108; x=1685022108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wZuiRCDNTR+aslqONRhJM2+3tVJRD1pBuBmPqOctwH0=;
        b=imZorUU0O56zwQsm5DCENsSOWuyc936csPETZKBwBE/m/9kN/p7LWu+O+TxcWNJ6jv
         hKXQw43ELStyZMQoOJ34oB2uZiNfd0vQn0L3xsXXsL4lsLs1d1US5VZarb34rZ7ncy6p
         Ue0QUb+TlvwHMpjHNxjctrDQuHlmwSF8IhlPHFfj/LXcLTuD+YKQq/bOGYCSCoYnwpXK
         +7E20GX4E+IWl4ts2W9LcKULPc4nV1aZFMR9HGTX1D9Y6JTJ0qoR23LwQMNiMlrETHyY
         C8Wxpnek8SkZJbPzNFj/FVUjeS+VL1IOX+/Ta0MSX0GaEVPplLVaOs7C6CKl8QS4+32p
         qqUA==
X-Gm-Message-State: AAQBX9fBhCAh+M+7uxpEhdxLgf9y4aqTDAki9waorIMWlKLbfzDz2kei
	+vAA9Ij7USrDu3+9WlYzddrZDaaFAtmYc4Rfl8HLqQ==
X-Google-Smtp-Source: AKy350aRh09p/evkXeY2LbD5ZR4ia/UB/oOwO6J6YtR4XiOEgf35qT2Sjvi3e1UsydNYGeI3pGQpqFZCLK3oIE3PRtc=
X-Received: by 2002:a1f:4114:0:b0:401:4d32:2bbf with SMTP id
 o20-20020a1f4114000000b004014d322bbfmr4371426vka.14.1682430107988; Tue, 25
 Apr 2023 06:41:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230424131129.040707961@linuxfoundation.org>
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 25 Apr 2023 14:41:36 +0100
Message-ID: <CA+G9fYscX+P=Mo2J1k+-oyawdFzsVUiKAiwfiNyz6NTUfZL0Nw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/73] 5.15.109-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Apr 2023 at 14:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.109 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.109-rc1.gz
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
* kernel: 5.15.109-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 579deb859f242ad9458861ca39034d5dbd3b885b
* git describe: v5.15.105-347-g579deb859f24
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.105-347-g579deb859f24

## Test Regressions (compared to v5.15.105-273-gdf26c2ac7eda)

## Metric Regressions (compared to v5.15.105-273-gdf26c2ac7eda)

## Test Fixes (compared to v5.15.105-273-gdf26c2ac7eda)

## Metric Fixes (compared to v5.15.105-273-gdf26c2ac7eda)

## Test result summary
total: 131539, pass: 105712, fail: 3771, skip: 21809, xfail: 247

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 43 total, 41 passed, 2 failed
* i386: 33 total, 30 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 36 total, 34 passed, 2 failed

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
