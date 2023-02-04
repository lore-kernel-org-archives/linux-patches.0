Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2863C1C27
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 07:25:23 +0000 (UTC)
Received: by mail-ua1-f43.google.com with SMTP id u16so529621uaa.3
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 23:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0GCIL+NITHomZ4ifseBSt0S1EJNccap+I9VoJ92QS0=;
        b=g+Fgtq8z0NI6rMy/Pzu+M/XN/mafLaNAf90VuMeVOl6uyYXnYhdunxSrLtTCFfc8oB
         xLZj+rf6f4ctGoeEAJ8aLmi8DEbENtAfPD84PjyNIpdEUzdeppgvtwZblPgTbGYr0yoV
         rirnhZCIn5aZiQ7hb7ohqOviPvlzSIQWklXMOyGVqXMJcQCDgMXkqgl6CE581H5k3+4X
         2VrWdqEJYcyzDrAS0qXqy7BysHj1UgLYc4q+pdMqbUUtGX1LGMS12UE5eovM8k6pqsWX
         PPg8Szg/i91bpAaabOW7TxiR5O4VFcND0sCrjqw27sDcLS6KYfOGrwPFj6r2JYwsmkIg
         xI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0GCIL+NITHomZ4ifseBSt0S1EJNccap+I9VoJ92QS0=;
        b=GNP2eilxkkYOO5ulM7ml7eb5v736gaALvf2+qz89a0CUgspIadDXp87m6JfW7Ie53T
         GCTYkKnsJB+FYv04dg+Y7Ta6jJT/u1+aaMWFnrhZAyhwV2j5gWS1+Y06MxVPINl8Gi86
         YMglfS5kidmd/DL1wSmVtbBSExN6D5k3lTlXPWjUfm3xj56XFe1ChyuAERqXoqIRVO17
         7Z0/wnc+HM/3aIylQ9zoGW+wlvQnoDUTHND6KZoK2RaRAMsNeoZuutSk7SruMvE1pWyw
         FmaVyARii4Z1mnG8JOFC5SHbn2gJ3VBkXzfzcZZhQTWrA0qz4mZfM5duEjzncIhlpy5Q
         AEmQ==
X-Gm-Message-State: AO0yUKV9xGv2R3+Zujf7o2cGOdkrBydYZSBeh71d0MqB/KwEIeUGqEbA
	iK1nJOtga9ijnxF64teIwPoXCEQvZc3lND0h2I+XuQ==
X-Google-Smtp-Source: AK7set/xSW2zRR2PR4QfeEO1a6Uk7XNZ0F71ScF0aNCpiJogJXU6Cw96aZxq+7OskUCP8G4TWc4dL0dqssZ76wCaf6M=
X-Received: by 2002:ab0:134c:0:b0:419:5b8b:4cda with SMTP id
 h12-20020ab0134c000000b004195b8b4cdamr2017934uae.8.1675495521822; Fri, 03 Feb
 2023 23:25:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230203101009.946745030@linuxfoundation.org>
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 4 Feb 2023 12:55:10 +0530
Message-ID: <CA+G9fYtsSuw=W0LSpzJRzsXB6qGYS3og1v=FOrvPHSAdRPCDPA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Feb 2023 at 15:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.10-rc1.gz
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

clang-nightly-allmodconfig - Failed

Build error:
-----------
  include/linux/fortify-string.h:430:4: error: call to '__write_overflow_fi=
eld'
   declared with 'warning' attribute: detected write beyond size of field
   (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]

This is already reported upstream,
https://lore.kernel.org/llvm/63d0c141.050a0220.c848b.4e93@mx.google.com/

Test results comparison:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.9=
-29-g52d447db92f6/testrun/14545824/suite/build/test/clang-nightly-allmodcon=
fig/history/

## Build
* kernel: 6.1.10-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 52d447db92f6b22e04e7b12c736bf1700de4bbf7
* git describe: v6.1.9-29-g52d447db92f6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.9=
-29-g52d447db92f6

## Test Regressions (compared to v6.1.8-307-gabbe4e7b6342)

## Metric Regressions (compared to v6.1.8-307-gabbe4e7b6342)

## Test Fixes (compared to v6.1.8-307-gabbe4e7b6342)

## Metric Fixes (compared to v6.1.8-307-gabbe4e7b6342)

## Test result summary
total: 163841, pass: 145266, fail: 4409, skip: 14140, xfail: 26

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 147 passed, 2 failed
* arm64: 51 total, 49 passed, 2 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 43 passed, 1 failed

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
* ltp-s
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* ltpa-6124632/0/tests/1_ltp-dio
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
