Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D6F174F7
	for <patches@lists.linux.dev>; Tue,  9 May 2023 19:36:06 +0000 (UTC)
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-44f98c344d3so2248838e0c.1
        for <patches@lists.linux.dev>; Tue, 09 May 2023 12:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683660966; x=1686252966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1JzHU31dhfnfRZR2/FQf7bu8zvJKQqZ8EMFaLj39LDs=;
        b=vbWBvr2B97JO3VdxTOInjVrU9C2NM9VIHj2XS9SzGPKJTl8xFGvstZUaYpSDKNUj5D
         m6GItldVrfGb27akwHgTkcgKajBniOYqp0jU+iwmA5Y5DJivnbRxOLXjGcnBZrWVOFzr
         y7YMthHFo4rsXKjL+TVmB7T4RcLF33V3VpFpBmh+A1ocliAhZaVX74zOd7uFiQ8H4iBi
         yMKfvFGt3xhxR3Mvp0VVdwACM1lfapRSlqm48UyuCP4giGOYBTgKK4OXHiS4CQ0/yBPg
         7f99xKse89y/Fskv54ImXT5vUjuWSSD2S1zyLq+Ezf2jkkLqk2zu4ua6wkHJJkMiz5bW
         EouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683660966; x=1686252966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1JzHU31dhfnfRZR2/FQf7bu8zvJKQqZ8EMFaLj39LDs=;
        b=WHiPvrChKPg0Ab/WvxXVNTnAS/gSnKqwDl//JqX04tKbOe5bdOxt3nUFmiRceivFhH
         lb7tzWBgbfz/dZOUizlEYvsWzPHf50vy0NgoEzkZKB5fN/86O0W2oZ25478CgUGj9TWZ
         gYYoaTWNz2zU9DIM1ByaGfFLQLH0FCfnE32WWEFU+qE8hxvXWimGc55XdOwPjoKZM3zL
         IyrGe/vAlcQ5+dfLpzFjXzQtlCVchoPcVoXF4Y4C+eVMjDgB3CwB5WJAEZMAf9MaPxCL
         483PqN3QwWmT1lmjQf+zrJAoeIuKTXGOWT1crFFout2ljD1O/MK4jTfL7sStBruowM5k
         N8jA==
X-Gm-Message-State: AC+VfDw+IcwfaSJX67CVLTWTlipZjc5KxMSbA7TkpeAb6mEuDSeYbW9x
	WtW6vWT4bmhI5iwmkDCvlmdSzsx6jbGm4AMk02L2Jw==
X-Google-Smtp-Source: ACHHUZ67nDx9OYCGGcUff+41Bfw+JyHkSj+EaeFCVUDqb64MkHOWBMNrvEZUidvVNfUcH0e/AEROWKaWereHOBu5430=
X-Received: by 2002:a1f:3dd1:0:b0:440:8a24:e716 with SMTP id
 k200-20020a1f3dd1000000b004408a24e716mr4455519vka.6.1683660965681; Tue, 09
 May 2023 12:36:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030701.507375024@linuxfoundation.org>
In-Reply-To: <20230509030701.507375024@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 10 May 2023 01:05:54 +0530
Message-ID: <CA+G9fYvyfa6c4wRf6YY=fYpQ-TmHTK2668_BpQDXABcVHsf0UQ@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/662] 6.2.15-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 9 May 2023 at 08:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.15 release.
> There are 662 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.15-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.2.15-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-6.2.y
* git commit: 8336a7c02b6ca37f67e3063837ab5c7674bb2b0a
* git describe: v6.2.9-1287-g8336a7c02b6c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.9=
-1287-g8336a7c02b6c

## Test Regressions (compared to v6.2.9-624-ga451b003c306)

## Metric Regressions (compared to v6.2.9-624-ga451b003c306)

## Test Fixes (compared to v6.2.9-624-ga451b003c306)

## Metric Fixes (compared to v6.2.9-624-ga451b003c306)

## Test result summary
total: 362124, pass: 310742, fail: 6821, skip: 43968, xfail: 593

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 282 total, 280 passed, 2 failed
* arm64: 100 total, 100 passed, 0 failed
* i386: 74 total, 72 passed, 2 failed
* mips: 52 total, 52 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 68 total, 68 passed, 0 failed
* riscv: 44 total, 44 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 84 total, 84 passed, 0 failed

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
