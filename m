Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7415B34188
	for <patches@lists.linux.dev>; Fri, 12 Jan 2024 04:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HH0a9mLJ"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-467ed334c40so886341137.0
        for <patches@lists.linux.dev>; Thu, 11 Jan 2024 20:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705034225; x=1705639025; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hzf90LiTCpa5sUiUA09sK84T6uPQpjZSE/91dDd8yLA=;
        b=HH0a9mLJ1XYUau9RPbJfIUfYLiT8ZexZpVOvZ9MSdP4ZjTfkz99QWTxD+919JrsC45
         gKDOUnFoUC8aAYxCJbobAgEc1QBnxuT2Pwei7hj5STT0jI9FYBU95CMglx7Zamvk2+yZ
         f9LKkJp2Ra/7ll77rw4pmWEEj2q6MxnEf1WurEaMB/UHtEe3yG6rO6ssEFie8rg6+j4L
         JzY+OtvTFkJnuHrHkfsLUycWskfw+rAMDUmcaLcUtvDG/FfU3/bYaLFYWzj4JLqdBO7d
         yDA+L/XPuk6NpG9xVpi3oTqHCoU5IJJQNGaBOiZQvasISG+J8rZyILT75nAAZCeuGYAX
         7O3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705034225; x=1705639025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hzf90LiTCpa5sUiUA09sK84T6uPQpjZSE/91dDd8yLA=;
        b=qtLLHDmZohRYwz0s8fRd7W/lg9PzeXkxbIAggD/u0tod78ig/4QStL8n4jRd7IOBrQ
         1gdM5+bTCF1FNZhkFuuDgi8s3j/yWJ2wL+IRDHo/M/qXn0faZ7P3tzVxfxzjMTlWSdP1
         yVt1ZkO2F1OG0g0mX5J09fEJbwOTUc8X7AlZhcxoDHAzyoI6OqzlDEgph4dPDFW1PuzZ
         phfwZt0AdIewR6JY2RVX0lTYqDQyQwdDwPnbrxmQwCIZU3PiTuUImM2kSot9fxENMdpx
         bBQeS+VJrWyN4K7H/LgnEj6iSGiJPUaB8IXLh5BqX+MJL/iYx5uLjYwX+PkqempK/PsI
         zgOg==
X-Gm-Message-State: AOJu0YworDSTWGlLiia2S9bO7vs3RokLMcuUUxPNITGzuTL7VH+/mXHJ
	EtL5zqyj1cZYN1XkrcQJqLpaGC0HBWk01ksUtA+WmimQuBjgww==
X-Google-Smtp-Source: AGHT+IFgVO94yzNbpSrgU12juUhZjn92ct+FeTcTjVmz/40/7oK7QO3ODgIsc0i1L8MqSRllGGwhsg4CwbAR62aRlFE=
X-Received: by 2002:a67:fa0d:0:b0:468:836:3d51 with SMTP id
 i13-20020a67fa0d000000b0046808363d51mr871292vsq.31.1705034225092; Thu, 11 Jan
 2024 20:37:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240111094700.222742213@linuxfoundation.org>
In-Reply-To: <20240111094700.222742213@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 12 Jan 2024 10:06:53 +0530
Message-ID: <CA+G9fYtnNWLzNXRs_k9Qa8pdFn911T-vFOtcR2UnCYGb1KRYAg@mail.gmail.com>
Subject: Re: [PATCH 5.10 0/7] 5.10.207-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Jan 2024 at 15:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.207 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Jan 2024 09:46:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.207-rc1.gz
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
* kernel: 5.10.207-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 9d64f2ec9cf9d1a55dabce3c7f639ec26bd1d7b4
* git describe: v5.10.206-8-g9d64f2ec9cf9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.206-8-g9d64f2ec9cf9

## Test Regressions (compared to v5.10.206)

## Metric Regressions (compared to v5.10.206)

## Test Fixes (compared to v5.10.206)

## Metric Fixes (compared to v5.10.206)

## Test result summary
total: 99306, pass: 75376, fail: 4061, skip: 19792, xfail: 77

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 117 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 25 total, 25 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
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
