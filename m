Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C76E29AB
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 19:18:46 +0000 (UTC)
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-44e3a4d0a6fso1444023137.0
        for <patches@lists.linux.dev>; Mon, 28 Aug 2023 12:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693250326; x=1693855126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1I4CRX+VDsrp3jdPqqKig6LxcIe/GnR+GzwqgFEFDE=;
        b=jvWwga6HqHEHtzmZWQ4ZGAWc7As+UEkhKlDJCCNtDNpmoQNOMb4CGz3+36HeWQLNdw
         f7+tqxmrnuzjXmuTOL0UTLo/CAtNn/BYRA8SbksXhviFkDL4+MrxPL4Ha12kptvb7/Ls
         P6LvuxofS8qV1jDcv343eJSHAfVgUuMY24M0So1r5rWsvDwuNTUzWsz287OtWDIp1ysa
         6SVsGegDWzSvWFLm4g3stb/BJ5cPcJ11jUDnNyaPmEd5q9cKJABf4rfHWe82Zt8hqC1B
         jzXywARLhV1vpaq1zHvzgjP5TmlrhJ3CjXZ/r6pB1AXHcJyh97qFddoKaJaph3lDbgJo
         EH7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693250326; x=1693855126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g1I4CRX+VDsrp3jdPqqKig6LxcIe/GnR+GzwqgFEFDE=;
        b=IJbx92BRWTpL6w3JaBEHaASqLlPkHeIve4UkI5aJJWD3A5YioMQeja7re01yYSgvoq
         LNQiQvetETG+5E1g4ie1N2zZh/Jeq7pTzqi1MyW3jQ8SKJtgXnQ9aqvSF3Yk7VyYNonN
         Rf/fmY7Ww8h2Nxo3Q+kU9pU3dB1TAqqc3WekOpWuA7z+bXCel+Mh2dc63HE4LeHj5lkl
         GIKCcCE8hzxmItO2yFqm4HhOo9QbLmjIYHomLVH9NhL2YuS125Xkq3GpZn9vnkQweqK8
         9GzN/Nm40W5sxu9dqnOW94FxuiGugtI88YQdGFr1OTzZ/KhyErKHOl+5xa6Ohabp/ple
         UErA==
X-Gm-Message-State: AOJu0Yw/dnba2nEUt+hTCepleoylzhlLrl1yrOpqcXnjEcA+7mpMhsSb
	bzXEe0jFaHZOR6A736wRctl3plyCp3b1JVqE/D7/4A==
X-Google-Smtp-Source: AGHT+IEKB/UkiYbxpUMrsuafNNI026mSEy/Cntn8y9HbaWuszsOZn8JnHTbQpSJtoXgKD3HQ13ZxF8VLga/fHnHYRgg=
X-Received: by 2002:a05:6102:3665:b0:44e:8ef9:336b with SMTP id
 bg5-20020a056102366500b0044e8ef9336bmr12562509vsb.15.1693250325753; Mon, 28
 Aug 2023 12:18:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230828101156.480754469@linuxfoundation.org>
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 29 Aug 2023 00:48:34 +0530
Message-ID: <CA+G9fYtVS9SXN3u+=ahOxi8z4xgaFDTxb_fmW0ioHceBvD-TVA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/122] 6.1.50-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Aug 2023 at 16:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.50 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.50-rc1.gz
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
* kernel: 6.1.50-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 1aa86af84d82ad518de80697bddd58a9df5dee09
* git describe: v6.1.48-128-g1aa86af84d82
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.4=
8-128-g1aa86af84d82

## Test Regressions (compared to v6.1.48-5-g1d91878df63c)

## Metric Regressions (compared to v6.1.48-5-g1d91878df63c)

## Test Fixes (compared to v6.1.48-5-g1d91878df63c)

## Metric Fixes (compared to v6.1.48-5-g1d91878df63c)

## Test result summary
total: 142227, pass: 121163, fail: 2106, skip: 18789, xfail: 169

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 144 passed, 2 failed
* arm64: 54 total, 51 passed, 3 failed
* i386: 40 total, 38 passed, 2 failed
* mips: 28 total, 26 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 37 total, 35 passed, 2 failed
* riscv: 16 total, 13 passed, 3 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 40 passed, 4 failed

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
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
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

--
Linaro LKFT
https://lkft.linaro.org
