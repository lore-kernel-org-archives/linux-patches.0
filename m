Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0D629CE3
	for <patches@lists.linux.dev>; Tue,  9 Jan 2024 11:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="abCSi327"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-467ed334c40so57528137.0
        for <patches@lists.linux.dev>; Tue, 09 Jan 2024 03:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704799894; x=1705404694; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6Wp2UNlh0Q2JLdp+psUnUSDYyfwqpeVTQT7FJ2KOsk=;
        b=abCSi327CRZSAobq8oXXMs2i7TjvKaxot5OyGGFAQmpH9xU05nxwxNHW9jWYzqvdL0
         h5k03L6mjGoSN/OgF0lh1oYCG7E9+bMm5+SPyAtJzyqsJo3jz/SStqcsk5xSgfGSZBrT
         s2wmx2KAk56a49TiiVEL3AUQP8T1vaIojjjibFXleiQSVdvTJnpbQCQLLNjcVpo7tXAL
         QJgal0J75gUmwanm9S+bMCr6kCv3VbwwRSOZArzgzCV+xqekNoOb+aEnNgA325fOemdv
         gzm3RtSONZ76UKWhhKZFd3AME2CQh3blGQmpMci7pcxI/GgL0ZtJMt8iSNmKHhXg6KIG
         1R6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704799894; x=1705404694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6Wp2UNlh0Q2JLdp+psUnUSDYyfwqpeVTQT7FJ2KOsk=;
        b=Nj0HyA9DQ8bI8ZkZKcrjo8xy5p7WP0Am6+fs3Qyaf4tm/sjgqC3IkU3AiPiXmwODnR
         MbTMcMIPSGxkmhBYDfzhpbx4yZqVlvcqLnP0WMcb81pRx+4esOsTF6NAK7yqIrqyh1nW
         kz5La528Fnax/PCM7YwntoScg1EmGQflB2tmHIAqgmal5wprwopjX1FzIzW+oBz4FTjO
         Sf9tH8UviXNbxxFwiDyZ+Km5Iw/l0aB28eQI+7dYdJ6WDMuUVqnr/25c/J+oZyQWnpr+
         i/Z5x4U89N/+2yIgaJX7dDcQCis//bYIimK0rtHbtuA1LDPcKTCk2XSVBLIP8NpG8Zti
         pzeA==
X-Gm-Message-State: AOJu0YyrdxYo5tiVV2w7GqWhFjpqmRYqLyoxW8krimmOZNanxRZDYEOc
	4ISU4cMUc5+vV0inH9ZnAjIagX/3Ax2Zs6AVi6U62k1ORXwGjw==
X-Google-Smtp-Source: AGHT+IFLtJJB1Yw27s7lF7Ckcwq/VMZCqLAc+JPwHEuYlOagxkuKcTmoLTgCF2QL0AWueN4Wfk09uuLL8MDc5uAnV4Q=
X-Received: by 2002:a05:6102:6690:b0:467:d91f:83a6 with SMTP id
 gw16-20020a056102669000b00467d91f83a6mr2533686vsb.0.1704799893451; Tue, 09
 Jan 2024 03:31:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240108150602.976232871@linuxfoundation.org>
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 9 Jan 2024 17:01:22 +0530
Message-ID: <CA+G9fYtojxHqvsiw2UsqpT=uvTo7B2q4F-LQ72_TvZERQmQgYQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/124] 6.6.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Jan 2024 at 20:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.11 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Jan 2024 15:05:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.11-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: c52463eb66c8ae86cf354c700d80ae02fd9a1eda
* git describe: v6.6.10-125-gc52463eb66c8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
0-125-gc52463eb66c8

## Test Regressions (compared to v6.6.9)

## Metric Regressions (compared to v6.6.9)

## Test Fixes (compared to v6.6.9)

## Metric Fixes (compared to v6.6.9)

## Test result summary
total: 153932, pass: 132066, fail: 2439, skip: 19275, xfail: 152

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 144 passed, 1 failed
* arm64: 52 total, 49 passed, 3 failed
* i386: 41 total, 40 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 44 passed, 2 failed

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
