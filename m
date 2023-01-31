Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B67659
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 07:12:45 +0000 (UTC)
Received: by mail-vk1-f182.google.com with SMTP id v5so6877894vkc.10
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 23:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5//sUDN7aAa+/fdAa54DT1YY07Np/vQiCEXU20HW7A8=;
        b=mp5Sv6Mm56vPapy+tjZGh3nfS/GG1pk5KRXs4RHrdXQKmMyifRidlaN5LS2Z994ec1
         bENSN1Ztt56ZOpibf/EraXbQvDF+tXBOY6yLj1ZxQDVy3zyZYs0Jof8T92/hxDyFn7Fa
         W3Vau43jZKssGvJEUrOekJPF8gPn7/MpPjeix5hVCSiWyeUlzZ1BBcLIAIlIPYbu9fr1
         jN5Nftzmnq3QF7VHhsAJeG9AvZUnFWSG/JkKnS1IQmgEc1Eqbw+QtfzpvkzTUYdJYTKT
         5Fy+CLYwRZgasA+QhO41c7MVEmt+vV8CNumdTggcuBp3T3/1CXqv6K146hFbLsLbS6i9
         FJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5//sUDN7aAa+/fdAa54DT1YY07Np/vQiCEXU20HW7A8=;
        b=xvpY2HIbNRan8RWDkh594cAwv3RQkxTM9mYyLcN5+mgKjwv6327nPYi7gxn1VWaolb
         vtuwzJoe7hYwvgnGWihnzHltcYuxJZgsIn5CgM2PEI36j3To71d7FE7+ZqxSpHVSBUUZ
         YGMYo9zbgaBhFdlKY431w5i2BYYreERMwMdsFZDkDu1xalWALRoXNW/tJYRZBJ/ofX1j
         zEulDQ367pIhXgGck2KF82A5lOrIMkL7eOPXt/218Hh6o8YYDBBLPsTxy6UEruiJSix6
         72ki4xnGqpUJd0zm/s+tOZci7k8L1uCs/RZo6/B/FtoIeSOcgWAv045Y9doC9FZ6jodJ
         T6nQ==
X-Gm-Message-State: AFqh2kqmId7fIBAT74AW0wnexCLXFz42lQjgPYKz0xCZOtV1Dss6b9zP
	zO0jprHWr8FGEYlabpWE3Sy7R7j3XVvUa7G/sZE4zQ==
X-Google-Smtp-Source: AMrXdXvjqVMGMbYiTFtTDld6AddwuPV8R5YGhW/eXTCuAwdkRC/HVJ98OdA1IRSeM3saP5w1wvmGnhbD7/CyoLbP1R0=
X-Received: by 2002:a1f:ab92:0:b0:3d5:63ee:dae1 with SMTP id
 u140-20020a1fab92000000b003d563eedae1mr7199589vke.9.1675149164506; Mon, 30
 Jan 2023 23:12:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230130134316.327556078@linuxfoundation.org>
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 31 Jan 2023 12:42:33 +0530
Message-ID: <CA+G9fYvGio_rUOQPemEB-jTryPaP=nsfzkCRQY60d=-QoipwAQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jan 2023 at 19:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.91-rc1.gz
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
* kernel: 5.15.91-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 5605d15db0225e49efaa8f83e03f78a8bee3bb5d
* git describe: v5.15.90-205-g5605d15db022
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.90-205-g5605d15db022

## Test Regressions (compared to v5.15.90)

## Metric Regressions (compared to v5.15.90)

## Test Fixes (compared to v5.15.90)

## Metric Fixes (compared to v5.15.90)

## Test result summary
total: 154391, pass: 127547, fail: 4115, skip: 22498, xfail: 231

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 150 passed, 1 failed
* arm64: 49 total, 47 passed, 2 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
