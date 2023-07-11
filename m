Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7545D3D81
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 06:32:56 +0000 (UTC)
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-47e35eba3e9so1621156e0c.2
        for <patches@lists.linux.dev>; Mon, 10 Jul 2023 23:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689057175; x=1691649175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OoV7wHi0BKt48VDU7rudRkLkDSl0F6bArKQxs2XKWH8=;
        b=t6X/P1fRgTle6kOoOp6BFmV2Tp4ee4Navqh9Fi4PptgcwbjmwqvhH3XKL7/XH1JxWW
         krc6U5rFqYashM2zrHOOY6ogMLeV/wBdP1xgXFR4mJHp/nSWSJG5Y/EKDFZ+eg0Ieqfk
         9mlqoZUxOMgl/bie9Kir9E016+4OYIaHAbiOKiVhuVP+79y8jxdFSdPQW/2HAebuT303
         RZbyOfF9H8xyVUUdCmlq8dU8TC1FUF4CN0G/YpClxoEz3cGFzN4lo1f9rLT4mPLzb7ek
         OGKo46Lg713VIqF0x+OzwYM1o6TRSMsRo/vKuQc4jF1EbD8to7bA6eLcr4Cpz5kyCMtu
         jSEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689057175; x=1691649175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OoV7wHi0BKt48VDU7rudRkLkDSl0F6bArKQxs2XKWH8=;
        b=liZLVfFV7V0J8yqBJ2ZVepYGqQVak/ET3dAH5mEbRlyQP7cyvx20UiJ8wNHw2BImst
         JgfDwChIRGv/57BnNqy0OkXwrzFwFQY/ohhIp3XpmrZjBwmuKDTByGeJRvsI+O6W61O/
         4CDZekkZuAkSKc54PclYYJaujjmH9lCnEH4bi1Kr+8JvOXnZ0z9hYH6Tz5MGyQvC6jV6
         3rgpj6hfVtvwticFPgdf0jFf40VeaaI06jmN0u35fQhX4JKubBdArbw4sKB38kxNcMUK
         DZU8NrhkQxckt3tgi4Ngr58PVNtNDOpTGAXy2sjiZ917ew3QXy2KsFooNs+peZ1Z+DC5
         UUSw==
X-Gm-Message-State: ABy/qLbPifIK8xycbGD9tltuNLIjXdAILuf/Ifblp+4MpxkMhs9hrInw
	MAVWLiPSyqYjxkopUrYEzwkNhyozsNW7xTfAClbgrQ==
X-Google-Smtp-Source: APBJJlEqsJAqUnLJm2yvVaj5bm+mRbslSMN2Dmhfo0eGS5oS8hTszDthHaChlPLhBHw6B/4JE61l+mkeCA1SizfzCZg=
X-Received: by 2002:a1f:6041:0:b0:471:b14a:fc48 with SMTP id
 u62-20020a1f6041000000b00471b14afc48mr7107050vkb.13.1689057174951; Mon, 10
 Jul 2023 23:32:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230710142227.965586663@linuxfoundation.org>
In-Reply-To: <20230710142227.965586663@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 11 Jul 2023 12:02:43 +0530
Message-ID: <CA+G9fYtokiZUYJr9RZth_iEfhrJhYv5=53G7Gxds8jWhxRfEyQ@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/424] 6.3.13-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Jul 2023 at 19:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.3.13 release.
> There are 424 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Jul 2023 14:21:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.3.13-rc4.gz
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
* kernel: 6.3.13-rc4
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.3.y
* git commit: 4882b85b0b1dc42e2ee6554fdb1eb956bd2c6015
* git describe: v6.3.11-439-g4882b85b0b1d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.3.y/build/v6.3.1=
1-439-g4882b85b0b1d

## Test Regressions (compared to v6.3.11)

## Metric Regressions (compared to v6.3.11)

## Test Fixes (compared to v6.3.11)

## Metric Fixes (compared to v6.3.11)

## Test result summary
total: 170788, pass: 146856, fail: 1976, skip: 21790, xfail: 166

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 144 passed, 1 failed
* arm64: 54 total, 53 passed, 1 failed
* i386: 41 total, 40 passed, 1 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 26 total, 25 passed, 1 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

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
