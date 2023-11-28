Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC58315AC
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 10:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f1UC2wHF"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-4b0661dafeeso1086910e0c.0
        for <patches@lists.linux.dev>; Tue, 28 Nov 2023 02:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701165803; x=1701770603; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CxLKyz5l0EkmmXVlbTwykLEQhhHaJesh/izL94dzvS0=;
        b=f1UC2wHFhQXhg7vtr3NGQz6egIcPe1QGLQVqmkDcwo0GyjkdqnY5OLtVlX4qP/Zbdt
         88ebx88dKC8lgyKP/V0AFPGXO7SVNSdrKl4fJThV1Dt+L5cXYs4gBRVNSXfWbQg4ZKdv
         wndRHYhC21Qt5TBsRv2NBoV3WR3Q/xGVVszeLIW2hoqWjQZM2Aq5jhFYNUpUqExXdIk8
         RdhiKYZSAvy/OR7OaaUFpfrv3K1B3MsU9eWuf8x+qci8iH9T6lxaAIf/uC3DWPqhxwCT
         PRH0s1RwPySW7tn2auOYXznOwrA3QxOgtHXlPTGVgNfCqsW6EQpiZy7VvPmk3POJDfGa
         wbng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701165803; x=1701770603;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CxLKyz5l0EkmmXVlbTwykLEQhhHaJesh/izL94dzvS0=;
        b=A42/wQ0ZTZiisVg0Cped4rKbXMfD+0owjhZ3G4Rv7XufVyeikh7yHIT+AU+joagcP3
         SQer7MZDddV640Jc3vMS1Ja7QUPk6sKob+bv5MtMlg4/xIkB1v7nKX4U9lR2P7UgZBce
         3wHr9exEf0amPMHK/55YCAJg151ZPLIypWBKqeKNidFWfuJcuMm+Rb/nUwov/VUsVu3v
         Ska3Qgfwbu97u/lyh0X3E8H9lQqL3Vh17f3tK6qVXdA32J/LzMc/QLyr2sVVJz3+lEgV
         3g/rcfpCPPhda+RZQdCh3DWXQ5h/VQqq49+CdUWixdZ7/s+BGDTrxgwhzzgEEyfAPpTY
         FURw==
X-Gm-Message-State: AOJu0YxKZfoe0KEsr2lHDqU9hXkUwpY0E0clH6ry4q8Mp05KEZ+bs2Kg
	+mnJhDrCurCQ6Un2d7fsmnmawxduHmcDLKcZPUxAQA==
X-Google-Smtp-Source: AGHT+IH5tonKv1UsYDqBYWDyswTeTxx+8UPeRgCODMz3Wlh/FWZWFbbhZmcdRUAvQPBrIGEpFD9rWcsRX/m/Zi2ECYs=
X-Received: by 2002:a1f:fec4:0:b0:49d:120c:3c2a with SMTP id
 l187-20020a1ffec4000000b0049d120c3c2amr8653904vki.11.1701165802677; Tue, 28
 Nov 2023 02:03:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231126154329.848261327@linuxfoundation.org>
In-Reply-To: <20231126154329.848261327@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 28 Nov 2023 15:33:11 +0530
Message-ID: <CA+G9fYsXii1M=4Y6qrir8n=bgCZoGY338fbqEeE9m-TTE9AwpA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/152] 5.4.262-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Sun, 26 Nov 2023 at 21:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.262 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.262-rc4.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
1)
Perf: PMU_events_subtest_1 / 2  - fails on all qemu-armv7 and TI x15 devices
These perf failures are also noticed on the mainline / vanilla kernel on 32-bit

2)
Following kernel warning noticed on stable-rc linux-5.4.y with
clang-17 for arm64 defconfig.

WARNING: vmlinux.o(.text+0x4e2a80): Section mismatch in reference from the
 function ks_pcie_probe() to the function .init.text:ks_pcie_add_pcie_port()
The function ks_pcie_probe() references
the function __init ks_pcie_add_pcie_port().
This is often because ks_pcie_probe lacks a __init
annotation or the annotation of ks_pcie_add_pcie_port is wrong.

Link:
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2YlCuygCpZ8wNd4DS0txeyTovV4/

## Build
* kernel: 5.4.262-rc4
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: ec4ef9e1558368d6a9606ca04072d398d79a6b7a
* git describe: v5.4.261-153-gec4ef9e15583
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.261-153-gec4ef9e15583

## Test Regressions (compared to v5.4.261)

* qemu-armv7, perf
  - PMU_events_subtest_1
  - PMU_events_subtest_2

* x15, perf
  - PMU_events_subtest_1
  - PMU_events_subtest_2

## Metric Regressions (compared to v5.4.261)

## Test Fixes (compared to v5.4.261)

## Metric Fixes (compared to v5.4.261)

## Test result summary
total: 93181, pass: 72823, fail: 2493, skip: 17814, xfail: 51

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 148 total, 148 passed, 0 failed
* arm64: 47 total, 45 passed, 2 failed
* i386: 30 total, 24 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 32 total, 32 passed, 0 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
