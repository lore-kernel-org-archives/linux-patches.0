Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B7E266C7
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 17:57:32 +0000 (UTC)
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-4525dd7f9d0so498006137.3
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 10:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695059852; x=1695664652; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAt5sHbrWgx4zzl6Pu9fZMLoH+lVEoE9WFINBvxYQ70=;
        b=T9tXuIyYzGmmBtMwak43S/oMkT8xlArjQbqYmyfIcKOJuc0PshbFL2WXm+Yb7RD+YV
         krQMQio/URiAa+vH3u4z5jXVjSmAVKbpH5d1O6P2LQV+d6ASl5/SCcgLmEwel5sqL1sc
         HUI9muQATuIMCs3PTkrDkJm5sNw3UuzPMTO/ClcMg+1aNZ/v/SMmwsmtVg3hGktGx4BO
         A9RIxQHyh1hFRoYo2WCAeKhRo9XTP/UjbG9GRuaD65D4EI5nrN3FIDqONjx5uJRjBUmx
         WudBZQU3rfaAfbCVINZ+24MK4iO4ZC+n9/IjTjqmzPSgVmLghHQn6E+VIQQgVFBZni15
         gwnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695059852; x=1695664652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAt5sHbrWgx4zzl6Pu9fZMLoH+lVEoE9WFINBvxYQ70=;
        b=WVF8Vb6isim5CbNV+4HW/HvII/TN3HCG9Q/9NU128hw+HAcixheOnuuJnn0IS3s0ij
         Qoc0kAiNHjNkbVYRSTny7Hzv53I0DZZHxAwSg0IUwep6NWTSvbt0O+TKbSmS+h8Z4d7f
         dt0Sf7/1HAM6lU6fyF8E1GFMn3WsKGSuAdjRl2sJ2W6DnbiswyUi35KMv27Bn+P9uEne
         7YOpToAirNpJS4ImRMqlOpw9wbmORwwDeFf4fUkYwSbpjsMLUpBBWTDnA3N6GJU9y1z6
         HFBSF0AwBneppGRti7Ktus1uVhgj+tKkUoyn6UUOUrgIM5w1aw6NlSHKs/BrlNGyfyPH
         R6Lg==
X-Gm-Message-State: AOJu0YyZ27hrZQIaR18vSe08qkwJNPYt1FwTjHJ9C7Q4X0YmuNtRdeZ/
	kQ/m/1Rqei5Y9C6PAiY/e/h7wYtW9O+uzvvX8SONJw==
X-Google-Smtp-Source: AGHT+IGE4a/5sYIMQ54j0tdNQXS5tUfdTizYlTAdElnrf8kFc1XkBAJ5OcfLDItMUFQbfeIbPBGDN4KUDHSK7miLsYg=
X-Received: by 2002:a05:6102:f94:b0:452:81b3:4b07 with SMTP id
 e20-20020a0561020f9400b0045281b34b07mr1345973vsv.17.1695059851588; Mon, 18
 Sep 2023 10:57:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230917191051.639202302@linuxfoundation.org>
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 18 Sep 2023 23:27:20 +0530
Message-ID: <CA+G9fYv-YTGcnGEGpB9Pd5ZjhzuyFfPZPrwk7zax8ovovyQhjQ@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/285] 6.5.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Sept 2023 at 01:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.5.4 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.5.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.5.4-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.5.y
* git commit: e5d077fb1eae958bde2a55b3065972193e501b78
* git describe: v6.5.2-1016-ge5d077fb1eae
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.2=
-1016-ge5d077fb1eae

## Test Regressions (compared to v6.5.2-740-g7bfd1316ceae)

## Metric Regressions (compared to v6.5.2-740-g7bfd1316ceae)

## Test Fixes (compared to v6.5.2-740-g7bfd1316ceae)

## Metric Fixes (compared to v6.5.2-740-g7bfd1316ceae)

## Test result summary
total: 245581, pass: 211062, fail: 3143, skip: 31023, xfail: 353

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 278 total, 276 passed, 2 failed
* arm64: 94 total, 90 passed, 4 failed
* i386: 69 total, 69 passed, 0 failed
* mips: 59 total, 55 passed, 4 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 75 total, 71 passed, 4 failed
* riscv: 52 total, 48 passed, 4 failed
* s390: 32 total, 26 passed, 6 failed
* sh: 28 total, 24 passed, 4 failed
* sparc: 16 total, 16 passed, 0 failed
* x86_64: 81 total, 76 passed, 5 failed

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

--
Linaro LKFT
https://lkft.linaro.org
