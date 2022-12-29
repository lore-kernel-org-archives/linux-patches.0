Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990A879C3
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 16:22:12 +0000 (UTC)
Received: by mail-vs1-f41.google.com with SMTP id 128so18886901vsz.12
        for <patches@lists.linux.dev>; Thu, 29 Dec 2022 08:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQOSh25SYMN2/P2PglP6We39JwwFuMW1Z/fACD73SKY=;
        b=J/6WobU1v+s8e5z29bJ9esEMLBgYVMQmSUMb9TgVjVRXOm7oUYxI5ZEfjZWLmrVebb
         /qQGll/SVAe49l1t40CN23HNVKbOe+0XgAuzpEjD3ohLNE7dQcSZlsCwd6KkX3DA8zU2
         j94G2RwGERusZILOLo7S5IUS9xAjZwfX/zNVCQup0athfFmK+ac4j8PW6CtlgI5lTt6C
         LPruFBS8KpCLCxMhXIZOFuzmkcnyWa0zdZsanTQJP2ndXdU5Y6YMGQU4uI3ZnTUa6+HB
         VmI4iJ9ocFNh43vP30ipB16AoCxlL9KvxKjHQgYLBKeaQ5+fSVfFJeeoCv04MLVVkfi+
         LUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bQOSh25SYMN2/P2PglP6We39JwwFuMW1Z/fACD73SKY=;
        b=1DHZMeQSwTby1cEDmeQEzW2NJpIZ6P9QeosnlRwyh2wB6kcFYsZ7i+8/+zq4MEySZL
         v0wRtJn7S+rLP+5eGp+br/0yvhRSmKxCb8gOb1oRRomutx7/aBVPGVMOmhEq8UBxqjsW
         +qwT5NhE1WoShL3sAoiRZHcDTl2lD70m8jnP+eIFYjRKVAZsPm6bkFoV2iublEV1aUbS
         0pvVbsWZARfJ2vdiLzhzn139TtgQPDfxmVTgMBE1Hd7PR6I+DO8GArKB+3Z8H2caG7s6
         E/4CPR6B9+9YtjVSsoC9wiFvVdMiVe7/4pZKNsE7SvDbQEPtZFEAe3u0H3RSUYjt+KGs
         hniQ==
X-Gm-Message-State: AFqh2kp733nZfLTdPIS1yxrbtwlOV8wW7lk4eBCx/FvMk1vXdCPrhPxW
	vAcuKzQCaaELlC/M1aEmLw/5+B3Bx9gk9lGA9Q+ezA==
X-Google-Smtp-Source: AMrXdXtGwLt1Gol5wxxu86/UY71kBoCq1sZn7FJVRDs67bdPu/eoxqTbmwHM62M33VtlUGvJLy7OfKQH+//RXqEChdI=
X-Received: by 2002:a67:ec94:0:b0:3b5:32d0:edcc with SMTP id
 h20-20020a67ec94000000b003b532d0edccmr3224449vsp.24.1672330931315; Thu, 29
 Dec 2022 08:22:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221228144330.180012208@linuxfoundation.org>
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 29 Dec 2022 21:51:59 +0530
Message-ID: <CA+G9fYuZL8iMgz1XPnsTdXR7Afa=rNXiJR2C55+rZ_zu0y74xw@mail.gmail.com>
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Dec 2022 at 20:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.2-rc1.gz
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

NOTE:
Daniel D=C3=ADaz reported allmodconfig failures [1].
[1] https://lore.kernel.org/stable/c3c2ef47-b46d-b446-5475-366867954528@lin=
aro.org/

## Build
* kernel: 6.1.2-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: aa2ec258c437267ab5178442982d02c59186cf96
* git describe: v6.1.1-1147-gaa2ec258c437
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
-1147-gaa2ec258c437

## Test Regressions (compared to v6.1-26-g4478ff938eb5)

## Metric Regressions (compared to v6.1-26-g4478ff938eb5)

## Test Fixes (compared to v6.1-26-g4478ff938eb5)

## Metric Fixes (compared to v6.1-26-g4478ff938eb5)

## Test result summary
total: 164885, pass: 147138, fail: 3231, skip: 14516, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 144 passed, 7 failed
* arm64: 51 total, 47 passed, 4 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 30 total, 27 passed, 3 failed
* parisc: 8 total, 7 passed, 1 failed
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
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
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
* ltp-cv
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
* ltp-ip
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-nptl++
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
