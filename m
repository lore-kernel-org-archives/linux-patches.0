Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9489B28DD3
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 21:33:52 +0000 (UTC)
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-7a8c41bd59aso678060241.3
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 14:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695072831; x=1695677631; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIZx05JLJAmHOrZCr/hJJwUvmnsBDSO2CN/31nMnpSE=;
        b=U54gsC5fehwzst4EVMlZ0Jif0dT7lm5ZnIE09eUiBno5/iisaFMnrL6uN+Ybx6NjJk
         EduKutx+nhv+d71DTrJtbna1GFGpPH1faQRzsz8DxRAJ1jGCi1sHm1A0E28cz4BJy9lY
         7dkEpvzunjWuAET5btVcfxV2HMPyARufO921xd0gt0pyZK0HfmiR4hIkiUhAj00tUpke
         PEq9ESvWwtnKdVQdAOjndZq7IqqqXaJ4g7Bm9oisjkqk3U81pW8wb0zCerpJTl8V/aQe
         gbviwgnh0xq1bs8dgyeBxPQEbIgyb7Mgs6Pm2q/0rWlnC92931Y++RbF7ZDIt1FblRgI
         ZoGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695072831; x=1695677631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIZx05JLJAmHOrZCr/hJJwUvmnsBDSO2CN/31nMnpSE=;
        b=L7FohV/31DREjZPVWfboMyOov6BrZR/8VZzVXJFkRKyTJn2q+Ffgsp64c4CwfqBNGl
         EYUrTmoYtI4vVVFzYqXIl/gQ7WvgTyp5RNrATstFNr6U5v3JiGElTNkkixRdGTcU+SVh
         dxeNLvSroj+Zv0Tcb/Phd5bT70Ry8siF3gkjG8dZjisZQWQ0PwbbF5sdK1Vq4SMFu7KL
         aDM1dRYshecX5362NJthYyKzo3IENsmfqmlyv8eSutE9ZvwGRYehWhoCo/Qy73cuG4gj
         Nn61HRrQn4zmNSuFQKfOdCfzl4pr8QSmWG+pTpwDC8tJvU7OB2fCdNrfvKIaw/xsYkwd
         FVqg==
X-Gm-Message-State: AOJu0YwMiVWJgHnWsztbYbknIViIEVX2cZksscjBdoUcqda8Koc617jl
	NjkrAAENq3dyE256s9HqDQzhcCxcuig5I3M7ydLjTw==
X-Google-Smtp-Source: AGHT+IHLhrmXSQ/itj/VEMUQIBZOtJusuCdBSn4CNVSZXaoxsnWtZvBsp0tNfVwOHox+0EW+xxuoJynPshEkDR654JY=
X-Received: by 2002:a67:f6d3:0:b0:443:6deb:2b4 with SMTP id
 v19-20020a67f6d3000000b004436deb02b4mr8425927vso.2.1695072831407; Mon, 18 Sep
 2023 14:33:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230831110830.455765526@linuxfoundation.org>
In-Reply-To: <20230831110830.455765526@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 19 Sep 2023 03:03:40 +0530
Message-ID: <CA+G9fYv98+4vjxVswpLgx7PsFM7U8nRp2KM5O=_pTfSzFG_kGQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/11] 5.10.194-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Aug 2023 at 16:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.194 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.194-rc1.gz
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
* kernel: 5.10.195-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 95379666b7a68327e8f4c3a0dbf28ae0c479ab4c
* git describe: v5.10.194-407-g95379666b7a6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.194-407-g95379666b7a6

## Test Regressions (compared to v5.10.194)

## Metric Regressions (compared to v5.10.194)

## Test Fixes (compared to v5.10.194)

## Metric Fixes (compared to v5.10.194)

## Test result summary
total: 80823, pass: 63120, fail: 2111, skip: 15541, xfail: 51

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 111 total, 111 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 28 total, 28 passed, 0 failed
* mips: 23 total, 23 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 23 total, 23 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 11 total, 11 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* kselftest-sigaltstack
* kselftest-size
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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
