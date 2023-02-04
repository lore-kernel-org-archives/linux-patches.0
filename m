Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA317F
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 09:36:51 +0000 (UTC)
Received: by mail-vs1-f52.google.com with SMTP id 187so7820473vsv.10
        for <patches@lists.linux.dev>; Sat, 04 Feb 2023 01:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XyoKiQ7zeC9iLhE6WOuhw6cWFuYLyGHZEkrfQLzhroc=;
        b=mYhN8sPaOx7ArX81ubvoDo8WWoKL5Y3kj1U7wnjI7vJKHzWmYSC3CW+takqwsx0oXS
         84/AE8mfHbRtcHKkq28mWSc0gNCFD/o5o/gvh4zfplfofXrd/+yahBCvArbrse+NnDLd
         FrRdQALPJkuwf9DKAWNnHjMTKeT4k2EBDjwjAmQilxttmO+QWPEM8B4vrcVt51PBNj4W
         yfqpZ8Zil9LCG4rh3V3XFO3ZM+bMqLOTxFESqt7S55ye9wMac+UEC1RFY+DCUk/Yq89v
         b4qhDYD21BOlypF8IYxX5BgYfUQCtXEwaQV5x9rduGvkP/TQxFcwNXYZYfOW28yT9ExL
         Eycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XyoKiQ7zeC9iLhE6WOuhw6cWFuYLyGHZEkrfQLzhroc=;
        b=EAYpcLFRlScgSLSSM63MsJLyvDgB4Mod+dGnLVlDgnoMtRw7auuCvReHfFpzcDTQ5S
         UIXXSM0DMWWUSirnA5hfi/QYSIjUALCgABSAsZmshKYP6NiBGyHBG8cmgERKmNyRqLiO
         DHulGCe8pS1PC5+UwUFKWEw6YFywg3SDLSbRF0UTb28r/epz1AmnEuSGa31DNNL0CyqW
         SKytoLHEPgvuZUVgJsbVSSAPAd3fKlHF90PJXcEWAY+s61T2zoNW7jPdIHVrAjI1IN1c
         5GarPhYiJ+6QkdpQVk1Z2GolvwoVloC4OhLJ1FlQHy3Q1UM3jnTlqldQ61P4vr30wRxR
         VjUQ==
X-Gm-Message-State: AO0yUKW2pSfmsYM4YmWBqj6AMGa3oYtnnkGB0FehIN8iHEk79vOoxLqA
	ZTrMxSo/47DrxV249eiNGgKXJVG4RKlCBLJ1fi6iVw==
X-Google-Smtp-Source: AK7set+fjvCQQ/rq4Vudh9xe09bpSjdm95pV6GiaBLXbbEPh3SJM1xLwDHkX151ez658u6eBcK6cuGO2TgDc+2tu5LI=
X-Received: by 2002:a67:e19a:0:b0:3f7:528b:d25f with SMTP id
 e26-20020a67e19a000000b003f7528bd25fmr2142314vsl.9.1675503410280; Sat, 04 Feb
 2023 01:36:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230203101012.959398849@linuxfoundation.org>
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 4 Feb 2023 15:06:39 +0530
Message-ID: <CA+G9fYvDk2QKX9iJQy_GMrntYqSqbf_HHaTO2cLsMSvsKuT6iQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/62] 4.14.305-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Feb 2023 at 15:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.305 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.305-rc1.gz
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
* kernel: 4.14.305-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 001d96b34795b15b9037ba2fb3c63dffcfc0566e
* git describe: v4.14.304-63-g001d96b34795
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.304-63-g001d96b34795

## Test Regressions (compared to v4.14.304)

## Metric Regressions (compared to v4.14.304)

## Test Fixes (compared to v4.14.304)

## Metric Fixes (compared to v4.14.304)

## Test result summary
total: 92228, pass: 79865, fail: 2880, skip: 9186, xfail: 297

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 311 total, 306 passed, 5 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 51 total, 50 passed, 1 failed

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
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
