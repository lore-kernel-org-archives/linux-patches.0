Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58026FA6
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 20:29:25 +0000 (UTC)
Received: by mail-ua1-f43.google.com with SMTP id e12so3936113uaa.3
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 13:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679344164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+tlr1idqzRi/wCdSb3D5E7lSTPycdR7KCdfffjUJpjs=;
        b=Fa/45uHkNHIX/RSw3ukUrjM7LTI2eyGV3o+uRXMdTao5bnyP6WtNZ55HhYp/WV7sER
         Yxx1RVFbQiBSXetaQaBfso4dkqa79EGhJF+xTy9e9O54fN/xiVd+cfTWmORI5IjKA8IE
         OrgCL/i0bh0a+HZ69Km3Ct5JNUFERCkfKXMCG01XN2e1Mkmk8xFANAERJJnhAQ2PQ1ir
         /AbvJ3iiz6BO38fLbkJ0iFeMtbYXoJ0Y+kms7YzDZHb2RSvZY3ufgUgw0HhN4NQw8Uai
         1ehUjc2XjcQBLNQq7Yaotmr4Ghhk/1IdjfiLOCToU81/QAXF2YcwKrzqMQRhsozaqt3y
         QMqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679344164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+tlr1idqzRi/wCdSb3D5E7lSTPycdR7KCdfffjUJpjs=;
        b=4ATEW5vj7rI+Iy6GCYN79kZhuoaPe+13RbJSUJ7+j7/HkYVhkzbYZ4CcTbGkOV2ago
         s0FnE6KZ1IdL3JTBiaiLKCKnuBnIJq+/P4rnn4+0IOLMOxvzmdKpLD9CW1DA/qRGHPuo
         7aiJDObEE/fwSi2X7qeFB2UKE6Fl7+RGrpKo3qABFDKFNIGP0Iy0yNXQCOHHJQMJ10UO
         4r1CqgVQpv7GKZ9Nai1pYy7+MNO8wiBW1t/htBIg+X1p7ulYd18RT8vuYBC9MfXTbPjx
         D3oln6/T7x/4IY33zZ5eK6c0+ENoIGogf/AXwAf7nnyEn3c0Kd7ob117rEYs5Ke2nS/i
         YWxw==
X-Gm-Message-State: AO0yUKWHSlmxe9uqjNuF/Cow1y4gnx6bz9StEGKs+aK2B5tpTat/FF1+
	gYzG2K1HLmAnVyKphklFaQKeVAuL/qjauFeqVROtSQ==
X-Google-Smtp-Source: AK7set+0+NNpokaepDCqEjbk+GJ5gaqsb3MpA4YxjKHniZL81o1MptBl4JXir3ofCEN7YLkZALTDTbOtEky9FiAs0l0=
X-Received: by 2002:a1f:2e8a:0:b0:435:bf4b:848b with SMTP id
 u132-20020a1f2e8a000000b00435bf4b848bmr12159vku.0.1679344164423; Mon, 20 Mar
 2023 13:29:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230320145443.333824603@linuxfoundation.org>
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 21 Mar 2023 01:59:13 +0530
Message-ID: <CA+G9fYuTruS_5k1RcaRCxkcTE6Tzc69bGcSHHifCOfJNt418fA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/99] 5.10.176-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Mar 2023 at 20:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.176 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.176-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.176-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 1686e1df652191033a9fc46dc7cf43cd169baa1a
* git describe: v5.10.175-100-g1686e1df6521
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.175-100-g1686e1df6521

## Test Regressions (compared to v5.10.175)

## Metric Regressions (compared to v5.10.175)

## Test Fixes (compared to v5.10.175)

## Metric Fixes (compared to v5.10.175)

## Test result summary
total: 92521, pass: 75087, fail: 2264, skip: 14957, xfail: 213

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 42 total, 39 passed, 3 failed
* i386: 33 total, 31 passed, 2 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 26 total, 20 passed, 6 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 36 total, 34 passed, 2 failed

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
* packetdrill
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
