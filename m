Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B27B944D
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 11:50:27 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id o2so1331818vss.8
        for <patches@lists.linux.dev>; Thu, 09 Mar 2023 03:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678362626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HiYZzwXd4jtoSzThZQPKSQxGIapRPCL9zH5yq/Shf0M=;
        b=YiRM8YJH6aJ2n64d4YL25ODZVcXkN1HF02cA2PipZrqEnc+F/wAh82TRVzHRVU4zoY
         qsIsVorBFCAXJHDHZaBc+geUe1sgynoGRy1HCdyerXZwNALeSxOz50A1N6/UpmuyR65i
         96NdseMM7UYh0QIe10D3Ko18A97ZNce/YBpVEBtNcKQSUmBZiXaiuwSNjyCDq4o2uyPW
         Dd1o4PADjmdjtwI123PlGVsnWvGCTIJS9g9w5obggWc9CGwHvp3xwZk/HRmcC6o7Z1aL
         99tFx0gXUHuUYw9WerA/cRHFxchKd7rcN+vB0OdJS9fqLO8UhhhvBcmSASL93EGPeVOx
         MLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678362626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HiYZzwXd4jtoSzThZQPKSQxGIapRPCL9zH5yq/Shf0M=;
        b=ciQe2SbT47IeLNpZLc8aJKYXx4erxC1frjbf330ME5ZhMD4dc9rm5iCYFtTAN+GO00
         wtUHqdy8yOeUh63sPd1OFtyzEe9GdvwPqNqD4Ll182SoihrKxWLSyKuAuk+gfPQdP/MI
         a5BMXv4DP8vtON8D3AfkuDwRr3GmZ0uuA/wwYANdmjWC/MCh7KjpUUkhhIHfti0S93PJ
         rAy4eWAtJ4TKm9YfvC5nqWbURVi6w+lW+WxL4ZwWnEjw0PxWZAC1T1ZuI3pgfZTLVKdH
         XGLppcY3lO3Vf67i57nEQmJIdzluuytX/OaID7Z4dKPlvIt19/FVv+05iE/JhOa9BcuG
         +XPA==
X-Gm-Message-State: AO0yUKXoJXzn513OpsNCbSyVdRFt0ugC1DPYBZKlzOtiquuw5gqesI7X
	+/ybRb3NG+9rLOEPpj/YdaQHxJ5wa4+elUxQ6i4w3w==
X-Google-Smtp-Source: AK7set+ckfVi4sH4kFYU88j8MVo7KGl04SpGQdxUqBTSjr0HT2/3p81USQ4erk/mbUXzgEg5nUJTBteC6Ve1oJa3TCE=
X-Received: by 2002:a05:6102:3e10:b0:421:c926:4b6d with SMTP id
 j16-20020a0561023e1000b00421c9264b6dmr14291413vsv.0.1678362626175; Thu, 09
 Mar 2023 03:50:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230308091759.112425121@linuxfoundation.org>
In-Reply-To: <20230308091759.112425121@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 9 Mar 2023 17:20:14 +0530
Message-ID: <CA+G9fYv=uYWAX=fCGZ7ENwAshgFUhVZi6YMJiHsqoTKJMCrLiA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/570] 5.15.99-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Mar 2023 at 14:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.99-rc2.gz
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
* kernel: 5.15.99-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 95417703d86d2be28dc9d740163b8f48b7869ca1
* git describe: v5.15.98-572-g95417703d86d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.98-572-g95417703d86d

## Test Regressions (compared to v5.15.98)

## Metric Regressions (compared to v5.15.98)

## Test Fixes (compared to v5.15.98)

## Metric Fixes (compared to v5.15.98)

## Test result summary
total: 138674, pass: 115790, fail: 4504, skip: 18075, xfail: 305

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 42 total, 40 passed, 2 failed
* i386: 33 total, 30 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 36 total, 34 passed, 2 failed

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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
