Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FFA29B0
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 13:38:13 +0000 (UTC)
Received: by mail-vs1-f45.google.com with SMTP id o6so22368376vsq.10
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 05:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOEEtslPUkXBnAZ4G8QHTVVmCfs3+xDdc9qKPeUwmBY=;
        b=Rp+6IjakE3xl4YEMRy9Q/Ldl35S6qCk/X8Hq1IvebTG9vVx991nSc/HUwWSL44kqmt
         Ql/Nob4paBUDZ0tjVxV6TmG5ricBasUOoW5quWr5oeStBBI5VEqjXhHSXzUu5WRpirhn
         jCEj3aIGLIW+DngJ4O1euHZ1+2whkdga+CRixjgc5iJ7Ff/sJTzUZAxNkpN4Huf5ZcOd
         RKBxMTx4TYk653UHh8mJcS0zIxcOXIXBQfhY7PmTx1tDbs0sDY1fUJvJRABv9I5zbTK7
         cixL+dAuren1DjZ2orR6LWKIQXkX1ko2QI3mmU6b8cji135UWlp2Fd6ey5PGskoIpDmT
         vENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOEEtslPUkXBnAZ4G8QHTVVmCfs3+xDdc9qKPeUwmBY=;
        b=41Jxzg+H8A8KP++5J2hde/B3Mz/Zem62c1ljbZrYdDSAeDf4bYMxTj+YDXdtRmRTuR
         YJgDYRFJxiwIYrGTfyzgY8R6PFilRtRUK/eECTds8cTLAXgKaJNukYA+7QuNiaTx2cB4
         VzBasOxUFoDxMOFuq3QjgFkP3ko8yPim3f2V3pd+UV383Or77myBgrwLwdjFoVltElir
         OFk06K/JYzMFAkBg9LBxLTWCYTCeV3TWKXe8IV8iQfyBOwFPr8VBsiKfvj/hxtlWARSA
         b8zRsOK/mxkdLflqbBHPou+BJNRdBQzqtxKTVeteB5dSxgz2YsHbSgxlWer59sx0zILU
         LPXQ==
X-Gm-Message-State: AO0yUKW7mqSKthDTtUfO75gom87sgcHegG6cWCSnMwGA7szCTBIeL9sc
	XAWjM1hhK8antJkPB6qf77qv4YsNR+jVUIMVZFgb+A==
X-Google-Smtp-Source: AK7set/IIrp2otjUC2O0wlh3ZAloIYXoL8bth5vYbe8l/Enz35s/6D0CTFf9y+4mq/yctG/aDHa3ofsq70FJdRLYZao=
X-Received: by 2002:a05:6102:21b6:b0:421:7f84:f3d9 with SMTP id
 i22-20020a05610221b600b004217f84f3d9mr1316449vsb.3.1677764292073; Thu, 02 Mar
 2023 05:38:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230301180651.177668495@linuxfoundation.org>
In-Reply-To: <20230301180651.177668495@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 2 Mar 2023 19:08:01 +0530
Message-ID: <CA+G9fYtdkp842ZUcv+Bp-4NfUB+33b7h94Jxi3mrbZ6GbUXcGA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/13] 5.4.234-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Mar 2023 at 23:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.234 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.234-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.234-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 71be0366b84f5ed2ce06bcc6feddf31053a41c73
* git describe: v5.4.233-14-g71be0366b84f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
33-14-g71be0366b84f

## Test Regressions (compared to v5.4.233)

## Metric Regressions (compared to v5.4.233)

## Test Fixes (compared to v5.4.233)

## Metric Fixes (compared to v5.4.233)

## Test result summary
total: 124659, pass: 103137, fail: 3281, skip: 17853, xfail: 388

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 144 total, 143 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 10 passed, 2 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 37 total, 35 passed, 2 failed

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
