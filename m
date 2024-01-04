Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2B220DCD
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 10:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NsfMRNwB"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-7cd861086a7so137458241.1
        for <patches@lists.linux.dev>; Thu, 04 Jan 2024 02:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704365382; x=1704970182; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7lSLAgF3yzZ+WL+iGneL5odyxIGJYYIwjdlJ0e++vws=;
        b=NsfMRNwBbUKL/sY9B0Wg8tlh5C+cSpyrYJzVlHZlT22ulGgPbwifiaO7olEHOA96aa
         coKb2Kx6VJNIR3PCTMS1RI6ewKrZ2Y3+VoBCkbuxP13zuFEem32BTdmLvE/AMcdQjRlA
         UYvarhEAZzZiKwnOzbQ3duxeESNBg832Ku0D9DsrQXyJqVPrih+OrKH+hi4qNdZY5QmZ
         FpKh26ijYAQM4wIhJ2ImAxY37WlJDaa4V4fQmexjBicOsWxLD8gjPfdW7NMPXHeJB0YS
         gI4iEvMpnGxmCaEM0Dzloy0p/xbA7bi9qfLCwnlEnoXyp//Da1iE8eW5pEhhQFnqLO5r
         AEuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704365382; x=1704970182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7lSLAgF3yzZ+WL+iGneL5odyxIGJYYIwjdlJ0e++vws=;
        b=gM4nXZ0/8Hb39oW1y31PcVzZx6UmY6WbnRXvN0AOkKepfADU8iO55wGq8sox67Ymzu
         seTrKpOVCpXx59dhTSDE5voBr1mgVqbUNzIVmQs07kYJA02QtUt33w5G+lSXeYqgklP9
         l5BRM0maqHglCyj+uodTI6F5hR7mDORTc5Cf9eknysEzyCKE4nCWxyIuVkyKK+40tUNZ
         r+kAY3TQd/HQuh+kSiJcsBe6m2oYSCdAzoQ5HPbMMGC0ooFbCOjF/GLt4SySGBNMBYoo
         RD5Vf8Llh7gECsVtSe0Cx2y4hZEwXJvqYzDfhMiA7hG2d42+gDVaQgo98OVhB58tdRv0
         W4XQ==
X-Gm-Message-State: AOJu0Ywu7NWEoQjLp/o1Mc5dhxVjACLWUlMPmYdgAa2yNsXnormnIRbt
	Bk9bOZysTnHqT06dTukeBcMoSlb1IlLpK2tpsdbVsU61DV4XJg==
X-Google-Smtp-Source: AGHT+IElE9BQNCHr+NMpaysmcqMv4FPD0he8YGgzI2o6aRtB456DjHJJIAPJLVTyLJl4DWpI9fVmsbCU2bBmO+Lb3Z4=
X-Received: by 2002:a05:6102:15a8:b0:467:a64f:aa27 with SMTP id
 g40-20020a05610215a800b00467a64faa27mr217036vsv.15.1704365382054; Thu, 04 Jan
 2024 02:49:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240103164856.169912722@linuxfoundation.org>
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 4 Jan 2024 16:19:30 +0530
Message-ID: <CA+G9fYsf1SDHMk+Aq=QZZAOOih1F2LoSb+abEXP0WQ6u8maxog@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/100] 6.1.71-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Jan 2024 at 22:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.71 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.71-rc1.gz
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
* kernel: 6.1.71-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 55d8c3a7d7448a75a541c078fd8e7b6abcbbac95
* git describe: v6.1.70-101-g55d8c3a7d744
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.7=
0-101-g55d8c3a7d744

## Test Regressions (compared to v6.1.70)

## Metric Regressions (compared to v6.1.70)

## Test Fixes (compared to v6.1.70)

## Metric Fixes (compared to v6.1.70)

## Test result summary
total: 135389, pass: 114436, fail: 2678, skip: 18148, xfail: 127

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 145 passed, 0 failed
* arm64: 49 total, 49 passed, 0 failed
* i386: 37 total, 37 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

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
* kselftest-timers
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
