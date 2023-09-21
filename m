Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117E1B641
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 13:55:34 +0000 (UTC)
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-495c10cec8aso421705e0c.1
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 06:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695304534; x=1695909334; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9XA+JBraCda9eBva3Lypt3IJDPDw9JlxvkFOYuewBA=;
        b=kuo5Qxq8qe3k9ofdvOOY5ni+ilV80TyXU4osAXs/iN9N7ykWoV1Rz/UGdrAfSGneGE
         VT4v0pUPf7BknzJlLCEi8C8j7racnxbXnNFmYLU/TP1Kv6qNThn5xtHJWSarDhxd92wO
         DrrGmqxL+4YcmDkFdvbxnDlTNmq8h6XEptqD3PZJDl77X1nR8eacRZoMHYk5BIgT8RIQ
         1A1KcCtWpmabBTznvcITdNlNiysdV0Z6Csnpw8hPdcVh4LppVrIIE68XB/Ni4k9oZk+J
         XO9kyVfQ9HCfjizxqzwLYdJi+FheVYnIH3z4jRK6Y6FMa9r4NMNz+YAfQ/LHwVaq+RyS
         akwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695304534; x=1695909334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m9XA+JBraCda9eBva3Lypt3IJDPDw9JlxvkFOYuewBA=;
        b=u/iLW4jJB3eACTd+zo4uhQHQB4Yrg9hmQtrp9G691TqVHyFbgcLZObYTxq3zNfc/Pq
         kihVwezw9v3fpnB3/MH67SsrJtf4KKF4TPVkB67Tjx8pSRHTrKJq/z1kCA/l269bqUco
         NaXmtnO4iJA8eIfpcLkvEKjBHlA/7wD4lgD83LWJK9dxHL5hhXVf6Y/PVWJnhWHWo7Oo
         AMp+u4WifbSrLJWODOJutg+r4OFA6faRoZHTAALtQoYY0ixkmkak+SPhvt2SgEt0Yk+H
         H2Af4ENLSgQJx5Ot6fVbcuJGywW2c+aBjBIRpuOKhJGuQ0oooibxwLxSObUvzJwmVPdI
         Yoyw==
X-Gm-Message-State: AOJu0YwWBsu+3fwrxTLprJlM767ET9CUEkDkGsFTCUhN3TXAV0EoHgue
	pwYPvIn6sxebm5gdXBn/Npewn6DlVO/vpdT+l8Y88A==
X-Google-Smtp-Source: AGHT+IFyUPOELrhW7Z+XSfDYSuhUZcYQy1NdI5INSJe1W1E+2AqewKf3Am8KYOt/k3/4unEl85dxvZZ1koniljIGRFg=
X-Received: by 2002:a1f:dd44:0:b0:495:3d9d:535c with SMTP id
 u65-20020a1fdd44000000b004953d9d535cmr5450821vkg.4.1695304533825; Thu, 21 Sep
 2023 06:55:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230920112830.377666128@linuxfoundation.org>
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 21 Sep 2023 15:55:22 +0200
Message-ID: <CA+G9fYuLmUQ=f2J7vdgDM54urA7muB3NpjrnZ=PTzwkGh48zRA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/110] 5.15.133-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Sept 2023 at 14:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.133 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.133-rc1.gz
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
* kernel: 5.15.133-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 634d2466eedd8795e5251256807f08190998f237
* git describe: v5.15.132-111-g634d2466eedd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.132-111-g634d2466eedd

## Test Regressions (compared to v5.15.132)

## Metric Regressions (compared to v5.15.132)

## Test Fixes (compared to v5.15.132)

## Metric Fixes (compared to v5.15.132)

## Test result summary
total: 94047, pass: 74238, fail: 2610, skip: 17099, xfail: 100

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 117 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 35 total, 34 passed, 1 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
