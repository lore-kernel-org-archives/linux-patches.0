Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140A715B9
	for <patches@lists.linux.dev>; Wed, 24 May 2023 06:53:21 +0000 (UTC)
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4572a528cefso441581e0c.0
        for <patches@lists.linux.dev>; Tue, 23 May 2023 23:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684911201; x=1687503201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JO87M/SJhovAggTv+SZMv/UEkxC893mdoY4ZmtFqCiM=;
        b=rfQ7bSP2vE7mJKsJC4cAWkHJ/cLEDIQJVeErbHBkoaK3JPALG9MrILncV9y83nqlEk
         yuITnM5++sV2wowMHpRnbzrsoR45eaNVVxGuKuHeuSGjCxTzXCBQasOeX4aFDIUGe21C
         FYyq22JGvDaxRdI/Rr7BZrpOtwsdRqBr+VAxT6eRYCGvSTyLX9Ebb6wE1DEEArTTUEPi
         yXywhhzjoCUlNtuMT/vz+Qp73x2wc+cZNpVKWNQNU+QwZi402iNNmp+fsZ8KjYroHUzC
         ZEp1f6xOjghQ9UjEkcnO61uQ/ms5/1e59RVQlKSwqhsqarbsbdHq++1iWYvOq+Mp2sBG
         TI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684911201; x=1687503201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JO87M/SJhovAggTv+SZMv/UEkxC893mdoY4ZmtFqCiM=;
        b=ZTcxrhKXI//JYKSthbIU3bTfpMDVTgS27zdxa4SGpoENy8/03Jgc8BU5SHsFscBU1f
         3sVKOD6+EjWuQkocStOvaKiJHUZTDvaLvIxxYb5UVqdjW1NEcS4BqgPEENKpwK1a0pwP
         N/xmVNmsl3ziE2JuGuuIGm3N1r8ZsZ8AtoD/tQQcwlgGiZjTO8PtjxLxRpgDFP+mgFEH
         u47lB67AxBjkw9XzYs0MB1hYSSlsX9DF4JHt460Nbv5awAwwFkKrNVecgrwEXJEAMG8D
         pZN+6fxhqTiCHA9TtHDZim4egi4cR1PhcQ41ZwLeMnrHBZnJrkawBo99iszCl8jx06fp
         4yqw==
X-Gm-Message-State: AC+VfDwpwZSMZqwWsWrIx3oAkkERbFzHKmrzGPAzKe8X+40dgQ2Zp2Pq
	z0fBdrwq4dzFJwIceFUbXf4kwjVHyiPWaiQw3rTqzQ==
X-Google-Smtp-Source: ACHHUZ50MQjnVQqFvLZLa4pXsE5ODRH7KIMjO/rsm9DDDSnGx3AZ8r/oCWy2VtFRm7AgjClyg4HJ9OCW8zhPFdHDGmM=
X-Received: by 2002:a1f:3d81:0:b0:44f:e192:d407 with SMTP id
 k123-20020a1f3d81000000b0044fe192d407mr6119073vka.9.1684911200780; Tue, 23
 May 2023 23:53:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230523164950.435226211@linuxfoundation.org>
In-Reply-To: <20230523164950.435226211@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 24 May 2023 12:23:09 +0530
Message-ID: <CA+G9fYtu2VeQfsjbLngwEnV9rEP3oBiuyaJjMSOe7z+ys5hdig@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/363] 6.3.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 23 May 2023 at 22:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.3.4 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 May 2023 16:48:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.3.4-rc2.gz
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
* kernel: 6.3.4-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.3.y
* git commit: a37c304c022dd76ffb05897280b5a45da06cb119
* git describe: v6.3.3-364-ga37c304c022d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.3.y/build/v6.3.3=
-364-ga37c304c022d

## Test Regressions (compared to v6.3.3)

## Metric Regressions (compared to v6.3.3)

## Test Fixes (compared to v6.3.3)

## Metric Fixes (compared to v6.3.3)

## Test result summary
total: 182851, pass: 158943, fail: 3522, skip: 20124, xfail: 262

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
* sparc: 8 total, 8 passed, 0 failed
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
