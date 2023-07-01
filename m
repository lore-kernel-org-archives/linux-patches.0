Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489F53C17
	for <patches@lists.linux.dev>; Sat,  1 Jul 2023 07:32:51 +0000 (UTC)
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-793f262b6a9so975971241.1
        for <patches@lists.linux.dev>; Sat, 01 Jul 2023 00:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688196771; x=1690788771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aD+LfTs/YUVGMOZop79OlYJyRVQVHBTiplDmX5niAXE=;
        b=eomZy8tHMfRCtQSDUIWFJu4NG0JyfbRd5b+IchHOT0c7mu53+luovdsyekrgq8jIcu
         PgfloDtggpvPEO3Y4KrfahefwnEDHMb3P6X8+m3ODOm+aKSpUrQIR5RtyJC03sLlZ0i5
         ksTXZ3KeXLq/d8J6MtVrKTBJbE0qOL2yijS+ISo+UnnjQbdgbNNSYcdBto+K3RR7SeaM
         S2JXoer71I1h12vRxvQ5G5KjpebuQ2vRrsLRNz1QR3GLnhtLL31u6VM7OhUE/nQHW2cQ
         fODbaCdGYXt4nIyEmRaacqy+mq6WRMHRKCXztSqUt8HhLBdehiU3jzcxHgq6blnqVhgL
         NXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688196771; x=1690788771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aD+LfTs/YUVGMOZop79OlYJyRVQVHBTiplDmX5niAXE=;
        b=invy2vzcJ9iT3a7jsKbvNjY2vx3KFyKDlk+OMUpeQDgMoSu1dAnVfAySaYVOKoXwtT
         hRACoPrRibz4eW/A0uG+w1FFYiuFH0JfW3d5gThwTxYo19NVFjOpU/t9VTyJ0eREaAhE
         KUUDlLHR+KdJ2BEycx+AR3rNb/83aVBXoJydbtGMsCjIcY3pn04yRRh0APEd7Cp1vOgI
         Q2HLtP7Z+75Az/MWYZ85yD7ssi8M54zICkhjQQVshOSpcaOYd5YARWXrePexDdBlKyRS
         PTpQDu/3N9ZkxwniRjjFTIPqo0f5sm/9NHpCiigfSQS9ueIxHb8f4O2qYfaq9CnXFEVL
         asEw==
X-Gm-Message-State: ABy/qLZD3ey42sOXw0APFBdug/pkKT3rsYtJugsRCPpIulI7m2dGbOmn
	SBAJJ20WxW4VmvHC97vwZb1e1IuFgMYN8tXVu6TM6g==
X-Google-Smtp-Source: APBJJlF/QltIkVcclcTGxqfBAGVKo3dDm+j6KFPLRV27KQi/NXDB4ODN4rxZSjvAzwKMz/CQHapisokoeaApyOmO4l8=
X-Received: by 2002:a05:6102:2e2:b0:443:9037:d8d5 with SMTP id
 j2-20020a05610202e200b004439037d8d5mr3086615vsj.23.1688196770722; Sat, 01 Jul
 2023 00:32:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230630072120.689306958@linuxfoundation.org>
In-Reply-To: <20230630072120.689306958@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 1 Jul 2023 13:02:39 +0530
Message-ID: <CA+G9fYuXf0pv7Z0HA3auQ+BRpVrC-Z2ncBY3s71L2ZbRg3-vuQ@mail.gmail.com>
Subject: Re: [PATCH 6.3 00/32] 6.3.11-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Jun 2023 at 13:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.3.11 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Jul 2023 07:21:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.3.11-rc4.gz
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

NOTE:
Build warnings on x86 with KCSAN config enabled with clang 16 tool chain.

* x86_64, build
  - clang-16-lkftconfig-kcsan-warnings

vmlinux.o: warning: objtool: ibt_selftest+0x14: sibling call from
callable instruction with modified stack frame
vmlinux.o: warning: objtool: ibt_selftest+0x1e: return with modified stack =
frame
vmlinux.o: warning: objtool: set_ftrace_ops_ro+0x27: relocation to
!ENDBR: .text+0x1b63c6
vmlinux.o: warning: objtool: set_ftrace_ops_ro+0x3d: relocation to
!ENDBR: .text+0x1b622c


## Build
* kernel: 6.3.11-rc4
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.3.y
* git commit: 45e606c9f23d18a36b9c799e8b7d2cf5bf750021
* git describe: v6.3.10-33-g45e606c9f23d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.3.y/build/v6.3.1=
0-33-g45e606c9f23d

## Test Regressions (compared to v6.3.10)

## Metric Regressions (compared to v6.3.10)
* x86_64, build
  - clang-16-lkftconfig-kcsan-warnings
  -- https://storage.tuxsuite.com/public/linaro/lkft/builds/2RvmFs88FE1miMa=
qYXJOs8Uy8yY/

## Test Fixes (compared to v6.3.10)

## Metric Fixes (compared to v6.3.10)

## Test result summary
total: 183827, pass: 149450, fail: 2930, skip: 31289, xfail: 158

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
