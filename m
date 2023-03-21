Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7A31FB8
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 07:14:28 +0000 (UTC)
Received: by mail-ed1-f43.google.com with SMTP id x3so55830243edb.10
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 00:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679382867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DMKnA20mFWi0udSf/zybjijsVLooERpPllnHaq0vSy0=;
        b=Z2tptAG0szt5WNjW2A8IMPCmHMgELon3SubWx7AKhDU0xIffe3LnFIrr5q8zLqLI+X
         Xm3dah3AqFbg0NLuY8W5bgOImwQACErjkpj1eA2mPVT9NQ7vpOFtkEnMRtap/XqaswKS
         UY4m4hbod/FsvEt0S4ZUNpDl2npVNjGQATizktgLlCRt1fraCmy+kE7/1bgQ24r9z/Cr
         hnPnxNmaLWJABKci9MgSodgUQR71McHZ5TCKadUna5Rc0FhBYvCXX3nFur8KFr8jWedI
         4qBHhIp1fn52/CcHghUui7oXEkKicjZiH887RIbL6LuEMZXWSwRfluo6vewTAKpzkWMW
         BbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679382867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DMKnA20mFWi0udSf/zybjijsVLooERpPllnHaq0vSy0=;
        b=sO1cHkrsvtRhWPg7jmU0of1pIEUQc2dOAFOuwFLieFTOu0E0oAO2ZHcoWdKKTrlboF
         QPI9WmJfsNd/OfDdUf+lXFJOomIuuglyelt7KmWB9PrStM2fCcdxpkbFeFbIGYdIGUYT
         gLvSByI8zhJ7YUkw4E8or7e8IQN4MFG6DYGDtrniiyx90QSMg4C7Dw4KIr/oMtTJ5lXk
         CYVlrD7qDqpUutl9Zayl5hvT2ZgSN1qp0YU2WVoaW+5rc+kjgEbA0o4g6gB8fQQYMh4e
         pchdjPHkwDazpFUOYLKhPzpvauEASqAqYfVSnHyD1gJX55mgSVI1aBTif5gdc37Be4ly
         asxw==
X-Gm-Message-State: AO0yUKXeME7XmVUJqmymwLM1CYNM7UZKDhLGELenDPirMnmP/4wcWY2U
	gSUdEAON2b5i7pkd5ZtdoVVkvOL2k46e79jfauv77A==
X-Google-Smtp-Source: AK7set+7Z7aazmG76t5T4UkCTOEf4hlLtWpVyZGBTI2mG3jrxtWYBAve38VvAviEerfMWdlce9pJaW8edCnz+XxY9SE=
X-Received: by 2002:a50:9fad:0:b0:4c1:6acc:ea5 with SMTP id
 c42-20020a509fad000000b004c16acc0ea5mr1104322edf.4.1679382866821; Tue, 21 Mar
 2023 00:14:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230320145420.204894191@linuxfoundation.org>
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 21 Mar 2023 12:44:14 +0530
Message-ID: <CA+G9fYsiKyJYQnRf8fJi_27bOTZZtskOQ0-=H9cf2McH5CgPOw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/30] 4.14.311-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Mar 2023 at 20:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.311 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.311-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.311-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 771f7d636cc99d7d29357a63b34dc212c76c2e16
* git describe: v4.14.310-31-g771f7d636cc9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.310-31-g771f7d636cc9

## Test Regressions (compared to v4.14.310)

## Metric Regressions (compared to v4.14.310)

## Test Fixes (compared to v4.14.310)

## Metric Fixes (compared to v4.14.310)

## Test result summary
total: 75642, pass: 64390, fail: 3110, skip: 8031, xfail: 111

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 199 total, 197 passed, 2 failed
* arm64: 37 total, 35 passed, 2 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 34 total, 33 passed, 1 failed

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
* network-basic-tests
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
