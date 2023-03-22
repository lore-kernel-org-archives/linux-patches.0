Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620B723D4
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 10:43:02 +0000 (UTC)
Received: by mail-ua1-f53.google.com with SMTP id v48so12265854uad.6
        for <patches@lists.linux.dev>; Wed, 22 Mar 2023 03:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679481781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zWIfm8SVDkTKI9ViVU3tx16H6A9LBzPzgrDU3mJSn9I=;
        b=aoud6el4BR9ejtkWiXguKp6tnrawQLb18JKrETfYB9OKoY8aunkiEZ2poeM88qn77v
         BPEJsbFSUzDg2eulI4WgG7lMKpskFVbu0QqGX0/8snR8Hj/9SDOG5r648sKSM4ncLAui
         ZdIC4OtyuFONaRPETZI2JTA7Au5c8gN+JaSjuvvygdhOOkRCzeBRweaLKm9i1AT6U/bY
         xI9I2NRhmJ1ko3BxyqBT6OuLm8PEbKDpFiJJTVqwtBhMgEKEQ83fdEIjuQ4XJjTFtxt2
         urgAayzSkYL+LJmHshE2TiRCn1GT+0jh4WMcA+q2AjwXA69c6XbzlUgHxpIUb17tniiv
         7gUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679481781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zWIfm8SVDkTKI9ViVU3tx16H6A9LBzPzgrDU3mJSn9I=;
        b=zm6W9v7CV2PQKgLAPRVJ/whn9KpoLnEEHFfPt2iOy7i4bYMYqImR1yQBgp0RbyUZME
         EL5zw9Xh+hlGYOJIz1We1SnqFUryVvZcdQHYI+eHxt+QyMhFQ/gN2sEYlKhR2BsNIq8v
         yp8njFPacYB4Lcbb/dxN3qcz4H8rvB3aqlJO1xPt2RsbpqLisulPJeK3+ccq5mEkczFp
         4Ya9kbgdk+L3jnhgj23AzjKMIjWiT0DAk2nQiuX8BTM0wHEgECT7PHULHpwj60d3AgS2
         wgy31cAy3yfiPYV4mQh2T8nzUlFrGSQkWsRR6unOSrNZnMfzwdKyZ0sdGd4yhat7PhMx
         N2yA==
X-Gm-Message-State: AAQBX9dXG2JmMpRyrUt3yTG97p+neWdNBsDFABvqlaN9OhLBXWUSfJK4
	nHvG8CltpIZd+p9KrviSDwn3muUfkhbfG3cVDiYLNg==
X-Google-Smtp-Source: AK7set8Pu4zFLx2g7Ys7jY0o+nIVqPLyI6iOmqkGLBZOkHO6gNL/N3MVY2qi6f3tHPfHC7qz3jijZ7e0ra7UIq9NJ+E=
X-Received: by 2002:a05:6130:c0b:b0:755:9b3:fef8 with SMTP id
 cg11-20020a0561300c0b00b0075509b3fef8mr2412705uab.2.1679481781023; Wed, 22
 Mar 2023 03:43:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230321180747.474321236@linuxfoundation.org>
In-Reply-To: <20230321180747.474321236@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 22 Mar 2023 16:12:49 +0530
Message-ID: <CA+G9fYv1eB4JuhhSJORopQ2mUkXESuZMdEeYyypPLSKbdjYxgQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/199] 6.1.21-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Mar 2023 at 23:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 18:07:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.21-rc3.gz
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
* kernel: 6.1.21-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 2152cefff654f81f4c754469a07ac3c6105ed4b3
* git describe: v6.1.20-200-g2152cefff654
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
0-200-g2152cefff654

## Test Regressions (compared to v6.1.20)

## Metric Regressions (compared to v6.1.20)

## Test Fixes (compared to v6.1.20)

## Metric Fixes (compared to v6.1.20)

## Test result summary
total: 174778, pass: 151098, fail: 4548, skip: 18729, xfail: 403

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 153 total, 150 passed, 3 failed
* arm64: 55 total, 51 passed, 4 failed
* i386: 43 total, 38 passed, 5 failed
* mips: 34 total, 32 passed, 2 failed
* parisc: 10 total, 9 passed, 1 failed
* powerpc: 42 total, 38 passed, 4 failed
* riscv: 20 total, 17 passed, 3 failed
* s390: 20 total, 17 passed, 3 failed
* sh: 16 total, 13 passed, 3 failed
* sparc: 10 total, 9 passed, 1 failed
* x86_64: 48 total, 47 passed, 1 failed

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
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controll-controllers
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
