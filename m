Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85B07B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 06:34:40 +0000 (UTC)
Received: by mail-ua1-f54.google.com with SMTP id v48so4998920uad.6
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 22:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678516480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JPakH+auDoUb1ydDIhbuBIDdqYVJ4FXLw0TE82j034Y=;
        b=jzUTGflnxhBqTkcA1oMQtsPjAYgnh+6hak7cJTnAVGOjEMpf74K5vtONO9PG52uPOk
         Kr3z4vlG4UAfuhkvvaGuYpSQiax8xh4h+MZFxbaiJJ7MZsWXwQ8NCtniMljB2NebCWFo
         WfK+oTP8npSwssnEQas2UE3d+FtJIxh1NPZQ8kBGv00G0Uh2vrIVHaVOqv9eoN4ZREcy
         TjOgO+dt8UCpK0SZ0Q+xmBjGOb4/Qiv/ruZn6jJBum1/VG9oGR9mvhl8YIFQD5JTsts9
         zjy3MbguxH8U2WURwhns3hZXcbUy1Vd/IqcQ5ZOYe4bRfo2ANTxpr5UecvyVJW69zTyA
         ECOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678516480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JPakH+auDoUb1ydDIhbuBIDdqYVJ4FXLw0TE82j034Y=;
        b=AtTZ72e4jSSRSPolTQjyNn4ntPBcewk9BNfb7SMUwWbx72Hl2YgdOm89oKZZ7vuTcy
         j/sMo1W5qPuYNx7srXdVWKYmx5UJpY7PgQREcIgkpEMVEiGm/ieOlJH0Jp9WjpvL0BPL
         yOQp5JpMjT2ADNheOVGcyipbKDYTwivV9IVZxnx0NKH6R5/751EFai0e3zwfXnN1E7Sc
         EtgPdsNnNqVXNPIcULYkTkvh2n0sQIIRLojsp7xCkxX3jq2zwPID3yPlaFXmdAzIGW2S
         JtedG2zKdvsAJAN51O3Je3EcYsnZqfWsTTBOpe4InDQlUKHnS03VHSNQn5eh+k/atWIZ
         sqVQ==
X-Gm-Message-State: AO0yUKXZ8QSgyJoueC/F4dnpuI5MsZBISjIhd6Y9sBFMK6LWb+ZQ1MZb
	qx7bCXP5CfLKMsDUE6+qmGbBnMXgKeir8Ak7LHlhGQ==
X-Google-Smtp-Source: AK7set/ZzGTn4GCGKrunnuoJ/kWGsgB4lln5SyuX3wiHAk3A/ZTPGTv4R7DooDRrTw+h6X7KqNhFgRaKLhbeIBLuDFU=
X-Received: by 2002:a1f:4b01:0:b0:401:8898:ea44 with SMTP id
 y1-20020a1f4b01000000b004018898ea44mr16171806vka.3.1678516479571; Fri, 10 Mar
 2023 22:34:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230310133804.978589368@linuxfoundation.org>
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 11 Mar 2023 12:04:28 +0530
Message-ID: <CA+G9fYuemYyXoZ3--tDqiZmR1f10DNRf-eSDje1dvkJQpeXsGg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/529] 5.10.173-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Mar 2023 at 20:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.173-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.

As others reported, s390 build regressions are noticed.

* s390, build failures
  - clang-16-defconfig
  - gcc-12-defconfig
  - gcc-8-defconfig-fe40093d

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.173-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 420427e5b0dd499d0e1ba2ccbd30717bb5b36335
* git describe: v5.10.172-530-g420427e5b0dd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.172-530-g420427e5b0dd

## Test Regressions (compared to v5.10.172)

* s390, build
  - clang-16-defconfig
  - gcc-12-defconfig
  - gcc-8-defconfig-fe40093d

## Metric Regressions (compared to v5.10.172)

## Test Fixes (compared to v5.10.172)

## Metric Fixes (compared to v5.10.172)

## Test result summary
total: 114034, pass: 92733, fail: 3011, skip: 18038, xfail: 252

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 112 total, 111 passed, 1 failed
* arm64: 39 total, 37 passed, 2 failed
* i386: 30 total, 28 passed, 2 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 23 total, 18 passed, 5 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 6 passed, 3 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 31 passed, 2 failed

## Test suites summary
* boot
* fwts
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
