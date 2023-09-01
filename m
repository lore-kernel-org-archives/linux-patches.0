Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080A78BEA
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 08:18:07 +0000 (UTC)
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-48d0bfd352eso652922e0c.2
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 01:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693556286; x=1694161086; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+KKL+WFIFHs2TSwkta4cDHNYwLWptckS2+uJrcQGO8=;
        b=zG0ApPZaWTD+313NNIWvYbKd/a+OFcDEh2hSdeT19w+ZH+OCmmu/yUmAs9C50guuP3
         B8GgjE0yPiNOnnA8PwHso9somANaIzsGIWLzBkBuOM5Qe8LhruW/268vRvLMJraP18tL
         a4E7BcOZYe0kO75f/DDKVcdHLhGpgxRQhH5sWz3v9zfbZyrRusKlTASRf0PEiXLPjRKb
         1BdGJfuAFPAaYxkQjXSgKO9XOp6Vp5W+SWrUUbEaHsze98PhUFXMicMlNQLqEWYc9UyY
         JZDuflepNWo8g7gqk0r1o19wGlQ6ki2Z9nCwmq+VWW8mkjGjD1S4Lj06wTOPBXztEGQ4
         kQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693556286; x=1694161086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z+KKL+WFIFHs2TSwkta4cDHNYwLWptckS2+uJrcQGO8=;
        b=TCddiYmtwKYSmnv0n2CWvgdp0mmgJMLYIemcjEsHsw4gdC+tuZh/FYaYeI/R9JHDJD
         cYcW3WitQxugDK0IF5wOjTiHFKXaPRqr1iOe4n3ywxqI/mCbNKBhGJeD8lXjBxGilKR3
         8k1UC9J44dmHbzCBSI40Q+izUDK8Dhp5fk4D3e5fXkk35LrsA2C4sVZnw+nDjkr61GrQ
         lDsAnG3AMzjPNsHbciM1EqhUn5SHG9yiQzWTj0ZWPo+wCa69i1C9ef0qMqgBIdK1QCEg
         m/S0wOBOgSGKApLf+4H2i/rIjUkYbiz3qQfDbUuffmZRXcusm5FAwiq+eSfgwmlKrdDN
         +bBg==
X-Gm-Message-State: AOJu0YxzNhcMAiTAGz9JU17PH8gFAVAdsRwbHFFVB6fnvWTkIO0Ay4X1
	ZOyh0GHA8UAKF2c9h5QI1CfzNcSSTItHXMxkcdvCNg==
X-Google-Smtp-Source: AGHT+IHFPQUKt9qsuwJKT3ZWlOx8dXC8j9SqrsOuIVXsAlDAhky/xIIJUVxlRG5/dxM2PISpB31qnwSzJUYjx+SW31g=
X-Received: by 2002:a1f:4a02:0:b0:48d:2bcf:f959 with SMTP id
 x2-20020a1f4a02000000b0048d2bcff959mr1902993vka.3.1693556286477; Fri, 01 Sep
 2023 01:18:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230831110831.079963475@linuxfoundation.org>
In-Reply-To: <20230831110831.079963475@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 1 Sep 2023 13:47:52 +0530
Message-ID: <CA+G9fYvNKR3eefurkQQGOjF_6xzsGQK1TWDaZuFgTdw28mdghQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/10] 6.1.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Aug 2023 at 16:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.51-rc1.gz
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
* kernel: 6.1.51-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 1767553758a66ae5cc765f89bc22c22273b382a4
* git describe: v6.1.50-11-g1767553758a6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.5=
0-11-g1767553758a6

## Test Regressions (compared to v6.1.50)

## Metric Regressions (compared to v6.1.50)

## Test Fixes (compared to v6.1.50)

## Metric Fixes (compared to v6.1.50)

## Test result summary
total: 136400, pass: 115230, fail: 2624, skip: 18376, xfail: 170

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 144 total, 142 passed, 2 failed
* arm64: 56 total, 53 passed, 3 failed
* i386: 37 total, 32 passed, 5 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 15 total, 12 passed, 3 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 45 total, 39 passed, 6 failed

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
