Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541AE8C0A
	for <patches@lists.linux.dev>; Mon, 29 May 2023 15:52:42 +0000 (UTC)
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-456f7ea8694so942459e0c.0
        for <patches@lists.linux.dev>; Mon, 29 May 2023 08:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685375561; x=1687967561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGaKnkSY6KauhCFSazmEUL/Bq+G0y7m3m3aFs5ZleIs=;
        b=Dxelwj2lHv1Ym9KWoinFzV/DSsT2+sKqw9RvU0KUv64qrdoHkuLpZ4hY1TtVSepYVM
         1sHO5361oiSjspGNHm/AOPqxorO6i1V6H2E+QigfuHMjkh8Wfxmc9l/9J+lHloClmSCH
         Fy68wEC6brJGg7NCZpLfk9zts6aIrNpQXvPA3Y9BsbhKjVwC3ps+FVij7a6jZsDGXvZb
         bKn/nfz02j0f8RMHqlPGK9gEtQLulk8QtQdYvSJ/b/ygWFeXcJKPXGdmJL8BQ0hU96WI
         rtuGJWjI44gsKhedH/i/VVoJDLfyr/YKjrf6PplvhjtZz+hxyuaxRMgRrUf7h1sCqe8X
         xvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685375561; x=1687967561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rGaKnkSY6KauhCFSazmEUL/Bq+G0y7m3m3aFs5ZleIs=;
        b=fYf/3bioBrS/+dpbf9BnxrDOcawoovuGMlPARyX4vpNVqhu3JtFNPoif0XL0mrIxvk
         yX7QHJSu8mBv5wSBsoGiwEwnB1wFDBp79HBrLo3PGacOdqqXTNcK+OOaShEF3BaxBqHo
         oo2M8S51e3GlFmcahO1FYC8WndkEQQt2QiHGv0xb9+qEDYLKkYyR75Ie6lMlRxFQOMRK
         jJy6NSbn4Z23+3eN2racrqSawq/p3kYRV9i/GPgqRg8bcuK1VHyPqiSEcR1LRIA9ewXa
         Q3Pwdrlqa5J8ccNBbHHO+m62wXylJsQNHIEDvtFODsznb6G9xkC5uvvrBDIO87N5gKLW
         T+cQ==
X-Gm-Message-State: AC+VfDy9zETIUiUPRnTDV42xXN8r8Mxv1PJCX/WpSqZilT9KGfOysJnO
	7jrui4xax22oBYLPtpPYN0AzVVZ+JFwGiHjzmoq8JA==
X-Google-Smtp-Source: ACHHUZ5WTM9BvqPWbVXAGXg1rQ8FgY/ECsnpVegb3v3Wt3m1gWeGXnAFcFVnewNzGrXeKaoSYjRoJKc771LYXcgt6NA=
X-Received: by 2002:a1f:3d15:0:b0:440:3b4e:9a31 with SMTP id
 k21-20020a1f3d15000000b004403b4e9a31mr2451504vka.2.1685375560931; Mon, 29 May
 2023 08:52:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230528190828.358612414@linuxfoundation.org>
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 29 May 2023 21:22:29 +0530
Message-ID: <CA+G9fYtYT438NoeQegueRqLD_4x+6x9FSBLAcW3jU1+BpwTkpw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/69] 5.15.114-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 29 May 2023 at 01:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.114 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.114-rc1.gz
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
* kernel: 5.15.114-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: cd3aaa9c7395cb221c57a5d6e5ca7d342669d553
* git describe: v5.15.112-274-gcd3aaa9c7395
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.112-274-gcd3aaa9c7395

## Test Regressions (compared to v5.15.112-204-g30213a86a6fe)

## Metric Regressions (compared to v5.15.112-204-g30213a86a6fe)

## Test Fixes (compared to v5.15.112-204-g30213a86a6fe)

## Metric Fixes (compared to v5.15.112-204-g30213a86a6fe)

## Test result summary
total: 133865, pass: 111296, fail: 4340, skip: 18041, xfail: 188

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 32 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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
