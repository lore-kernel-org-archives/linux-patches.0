Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D101A3234
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 10:10:13 +0000 (UTC)
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-44d426d0e05so1014978137.0
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 03:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693908612; x=1694513412; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1NVo9wK9uR6XB7OEqVjA5/FypKBWn8rSsF+XNP2y7I=;
        b=Z958hSjoxKOdmHMuvEKzX6j6v2lzAG2o0cc4yVsRwggXlFYKNpESm5oFXkdkjoXrtv
         6ea+fsXXGGdsFYfA8AsWgxH1LbkMaYHZJr+zAjLVwlEg1JmjRpcgPJb2MZmqxY85Btws
         fWaoTudASpLODusu8MCiMpe8j4KcAiEhJXQ1eS31GCovrSWT5OsHJqtis+k0AUyePHcq
         2u38udMd6KNqYK4vGegq5Hzdq8J2/EuhC6nh7iP5LHy7/e+tTN8c2XFjnYTU5iMLivq4
         Y8vzG119bK8kuwJH9fPMSGLNdHg0JXqlQYUgHOwD7icVQN13hamdHp07xr03A3KjWWxO
         GoDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693908612; x=1694513412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D1NVo9wK9uR6XB7OEqVjA5/FypKBWn8rSsF+XNP2y7I=;
        b=L+7mrxEJtIzH2M8XjVfmSfm02fdpvYngjj7BTw3RLdcY+rv50ATiJ3ZMU5mvTblJ31
         joryL8XLLvSgNxwQAbMyzrrILeol/RBgLSGNEj2dcnmsneHPJ34l/EmS34gyIT0DRtYX
         1nTSWK7USUJjBrNQSgH/67rjUwcLcGj003Aa8+LQ8dv9C9WDkTYkhnOGYfjSKpJrs7Ai
         kDcWxAuLw7Tgp+7Qz7mKma6bc/u1LMxUy6vPP+EIwDXaN4KwUJRHxHBKj1RMK4V8zad7
         hWwP45WBhjT1HNwP+jPHz+d81JW02AcycGmn+L6J9jueDrtYcv3EQgYw8Bioh/dqy32C
         ab6w==
X-Gm-Message-State: AOJu0YwFEes8/9qrumvUWzwOONRjM67f4Qqve/FHfTdbyjISK3dUrC+V
	ZCVIr2QLeyr4BxaE9puNN5VxliehoX0PiSMPVF1c8w==
X-Google-Smtp-Source: AGHT+IE1V6bh5Wpm7L8b3xz92pn+LrSd3K1fkSSS8XT9JUjoqIZlkLmMmgJwNcjHVjrcuXzyd/kx7ikhguuSfU0jKJI=
X-Received: by 2002:a05:6102:2454:b0:44e:d28f:e49c with SMTP id
 g20-20020a056102245400b0044ed28fe49cmr10435179vss.23.1693908612436; Tue, 05
 Sep 2023 03:10:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230904182945.178705038@linuxfoundation.org>
In-Reply-To: <20230904182945.178705038@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 5 Sep 2023 15:40:00 +0530
Message-ID: <CA+G9fYsXyPe92z8Urfn46vSypOd9EYYGh1Ei1YTkHWJdGmBUJw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/28] 5.15.131-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Sept 2023 at 00:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.131 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.131-rc1.gz
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
* kernel: 5.15.131-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: bec292fb85c525832713d1aa73f07c39a477e2ab
* git describe: v5.15.130-29-gbec292fb85c5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.130-29-gbec292fb85c5

## Test Regressions (compared to v5.15.130)

## Metric Regressions (compared to v5.15.130)

## Test Fixes (compared to v5.15.130)

## Metric Fixes (compared to v5.15.130)

## Test result summary
total: 91910, pass: 75958, fail: 2130, skip: 13741, xfail: 81

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 112 total, 111 passed, 1 failed
* arm64: 41 total, 40 passed, 1 failed
* i386: 32 total, 31 passed, 1 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 10 passed, 1 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
