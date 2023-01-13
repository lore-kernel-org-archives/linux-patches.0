Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F33AD4A
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 17:32:58 +0000 (UTC)
Received: by mail-vk1-f181.google.com with SMTP id q21so2241099vka.3
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 09:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3d0L9EXeSI2xa3z2QyuDWU/GW2S6z4vkLQnF3O+530=;
        b=OnIoo9VUst637PaD3GIGw+8rqKwnkQLsUdbTvqYBTm4qQSS43PvGy96ENnv07t7th9
         xuw99hglKZn282xWmPZ8NLUPi0eeog0mBAouU8QIjMzhcKJwdeQg1x9pq7Z9sDyvRh+X
         B/T4naIBWhijaV1Z9nqPex9nz221WvdDsLkjyHvOjPxlITEPSM5vOtKSU++6UI8qTcEy
         p53PYTGQOLK1Yda9yfp+DFHADAEl9aPTTUgVFvFJ9g53XXTQehKJmunG+gay+ZHnUAhv
         ELxHmy37t/N3j8K3UW3/SMnN8dKSdWGA0f+3dmA4wJR5bGTuYBmupLM2mef25oYMFoti
         eUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3d0L9EXeSI2xa3z2QyuDWU/GW2S6z4vkLQnF3O+530=;
        b=Ph7t2+4IIRh56aXiZ7GxmJcV1K9ubKNhlTCagl4m3YvoK7LfsSmSmXLMPxUV4DLjAh
         Nuui3DkJXzrYJoVXlzP2QfS4PySolx+b12RxOI5TamoQjBtqpVtaeb8W3btlMrTb57o6
         CZOqyssBuun/E+Pxflh1sqmpi28pzU94vooN15TTSAB6OgN+lM7EwqJjdWYEJDHVA20h
         K5MvyjsdlMrhjCn1ylIz5QMgN/WeHo8BJsMDrGaw1I1A9XXq103tEtCYRU4l7bo0AxnJ
         7Pw068Je5E/hITYF7mVNFvwdhwwQQQFiEFY658StigzMSY7qRYqHLJZ8pzL7eRMc8VXw
         FuDw==
X-Gm-Message-State: AFqh2kr2FnsGnfMBDH4zYHcLWwOVh1mHUPwo4aEqkeBL8h5jw9liRWs6
	sayD5BUbmmajDCJiLluWpVKcTLs97tVgkjYO1Z1ZUQ==
X-Google-Smtp-Source: AMrXdXstM05aG5ZJ1+4SwdzPR7faL+HVwyRkbnLgjVAkWQ3RO1tj8uFpevrmAq5Yn0yPIfIA1D9zoiwHkDdEjzqcwF0=
X-Received: by 2002:a1f:3215:0:b0:3d5:86ff:6638 with SMTP id
 y21-20020a1f3215000000b003d586ff6638mr8249719vky.30.1673631177317; Fri, 13
 Jan 2023 09:32:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230112135326.981869724@linuxfoundation.org>
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 13 Jan 2023 23:02:45 +0530
Message-ID: <CA+G9fYukcyTgt2xavZqcxv55vC5vn2havo9A+wCjo9aVBpzR6g@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jan 2023 at 19:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.6-rc1.gz
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
* kernel: 6.1.6-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 5eedeabf82ee83045c63fd32b2473e1d61885204
* git describe: v6.1.5-11-g5eedeabf82ee
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.5=
-11-g5eedeabf82ee

## Test Regressions (compared to v6.1.4-160-g06bcfb15cd3b)

## Metric Regressions (compared to v6.1.4-160-g06bcfb15cd3b)

## Test Fixes (compared to v6.1.4-160-g06bcfb15cd3b)

## Metric Fixes (compared to v6.1.4-160-g06bcfb15cd3b)

## Test result summary
total: 183886, pass: 153292, fail: 5185, skip: 25382, xfail: 27

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 51 total, 50 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
