Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086148F71
	for <patches@lists.linux.dev>; Mon, 29 May 2023 16:28:28 +0000 (UTC)
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-78676ca8435so3268370241.1
        for <patches@lists.linux.dev>; Mon, 29 May 2023 09:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685377708; x=1687969708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3mGVS8e33OBT2D+ihh0Bl0HYXVlJC6aCF3+d5a7kFn4=;
        b=MWXiGG03Q5ItKMLHhQxUjZHpdVSqG6LU6yO2fZBy6o328eEZp/llGkdYzBBZOyFYP3
         jFkchrCcyZd+JUXLWmnruXJwY0BEdFvbV5/iHr7P4yxo7fCD6iTGQOMkl7aSWqjKGAPw
         dmcXcLqa6heJBW57PorHd4+TxPbiOrro1sOyCxHTNd9E1xFoz31DCnOf3bXTBHkBhiup
         rlUWy1edFWMl7kcKuUPQV9K56niElOySDkz+ny1pB1eotK0GKlVU+NeLHhhxpHzTKy4t
         PY25cR/tjHDHKGHbbZT1BOFY01BVECCJkczwH28L+NpYa+W+wYSLEQOVjjJqrmZrIitS
         95MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685377708; x=1687969708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3mGVS8e33OBT2D+ihh0Bl0HYXVlJC6aCF3+d5a7kFn4=;
        b=Y/7rz/qifIGAuRiaFQNuvklLZK3cghRHJ96/znr3iNDPynQurshKdN4VKW8XdC/qEP
         7Ku6MSo5JY3Zl89sRroBWcYIUEHTutYAqKxox2Dig0cU3Kphg/ZG7wAKok5bYkYfKNn3
         aQ43TXdBM5Y0X9C49zROPuN28vts8f8u5n5aUQoM+OzkrY3ikZ7r/RjHhI2zv0Bd9Yc1
         yEefVSzvIss6Mhzy6SRilq8A5cK1SkJ9rfgES2j5J9H3dg8Zg+SKtFPuaRYUUkE0Ms8s
         7FL69AXHz+lOErVWP22cQ0JcIGxJw4oOQH0BzA2KXWbH7l8ZN/MGlkMT5vPa9KYQ9mns
         4CnQ==
X-Gm-Message-State: AC+VfDwvQMC86O7HCXO10iTGevRu8udkwDZR43yawRPvKy9jHxof/G0c
	xrQV3L0FFclWQwAYRlfvpxAGhqdv+n6IBnR/hcFj5Q==
X-Google-Smtp-Source: ACHHUZ6j07CFGRw3O3MdJ19GtPNyI19rJl2wlCFs1X9aIik7XosV2eaW29S378M4H9FWQ7+YB75fMAiZoxF9NSGZ8PQ=
X-Received: by 2002:a1f:60d1:0:b0:456:f578:10a1 with SMTP id
 u200-20020a1f60d1000000b00456f57810a1mr2978154vkb.0.1685377707718; Mon, 29
 May 2023 09:28:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230528190843.514829708@linuxfoundation.org>
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 29 May 2023 21:58:16 +0530
Message-ID: <CA+G9fYtxV+Vzbz2RyS-qF1edZOrTEpuoXK+ZPKN4sqrVB_NiyA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/211] 5.10.181-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 29 May 2023 at 01:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.181 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.181-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.181-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 80ae453d08c191989cbf98440279674059eca336
* git describe: v5.10.180-212-g80ae453d08c1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.180-212-g80ae453d08c1

## Test Regressions (compared to v5.10.180)

## Metric Regressions (compared to v5.10.180)

## Test Fixes (compared to v5.10.180)

## Metric Fixes (compared to v5.10.180)

## Test result summary
total: 133331, pass: 110831, fail: 3975, skip: 18332, xfail: 193

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
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
