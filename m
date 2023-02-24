Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791D33C26
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 10:27:20 +0000 (UTC)
Received: by mail-vs1-f52.google.com with SMTP id j14so20901304vse.3
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 02:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wQ0LnxDqyXNhIiasmsXcdl7r1rET+0V+JAvqOijLUA=;
        b=nIZ9s6rS3Qxe7IMXjl7HGHCiKAPJVNiKVTwyTEdGP6qCPxoh/M2th9Vt/Z//AhxYan
         ihujjmW0z2LoIuQQ1AwHkmic2ZJsXTI23ulor4XGEOGw6a5bN+JggC/TRwDMfDMw6vKe
         SzeArBj/0fTrnjDKW1PmxRSxIhOxfPIcfzYlkMoQg/0hKhrY3s+s/Lcipq5vnYu3wkFK
         qrp0r7UV86upv4A9BEh8Ck/Zcs/dTcgMjjinlpwtMvmKC8u9t7qnJ6W4RhEfXqRB2UBm
         v92VKtf3/vlDBuYf25o3jtTucnroE5GnPHc1jVx87Vby7EHAwsv5JGy+dWDTBTqUcC9+
         WZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+wQ0LnxDqyXNhIiasmsXcdl7r1rET+0V+JAvqOijLUA=;
        b=VkzyBi/r48WzXxQEf6FRxfOe38kAkwAnOiuZNDVQarZs8IgqdIj0y83hjnQeStTl7o
         ivjDaj5z1QEEQAKhomEKyJG/azC7Sfl4bfdBMDA/gwJobkWg2jn4XIQ3rM2EvnH9iwUN
         bvUkWsz6tfGgE5z2dYpH5Xq//Wnce+ZyUl8/Pdi4ZoPD6zn2w7JYo4jB8cj0nuELC6pW
         1gMp/D+W0xleHq/txBoTWwAVOqB0yBjhnb0DsHuWX8Uu2LwtD3vvKCq+HsDoTr2sSqV4
         7PKaM2NuZo+gQSUOmEciGiCQBoJCwwyskopYbHB2tlSXQv9RC4pUAnnJJWpUfKDOGQ8u
         ha0w==
X-Gm-Message-State: AO0yUKUKulqX7Ozv2+7y8Lw/zkGORkr5CbSLlpRkMW1eNokuj40g0c47
	mn3V8JcWSBJI+kR10HEv4Iea75HcM9kCKmCLb1y8/Q==
X-Google-Smtp-Source: AK7set/hvgIAxYTcidM2yJpC4ZO+bxxX1Zd8baIlkBw23OgUiir20lPqowqmJnzRBu1faje6vD50pG1qZ36kqtrP9YE=
X-Received: by 2002:a67:fbd2:0:b0:411:fff6:3cc4 with SMTP id
 o18-20020a67fbd2000000b00411fff63cc4mr2131876vsr.3.1677234439212; Fri, 24 Feb
 2023 02:27:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141539.893173089@linuxfoundation.org>
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 24 Feb 2023 15:57:08 +0530
Message-ID: <CA+G9fYvDYddWyEY1yVk8i5cU2=8iJ6cdhT5Wz+qoHu-qxLnhbg@mail.gmail.com>
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Feb 2023 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.1-rc2.gz
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
* kernel:  6.2.1-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: e81fdea0bf0d8e461d39e9eb1ffb2458509df8be
* git describe: v6.2-13-ge81fdea0bf0d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
3-48-g342b7f3b3ae5

## Test Regressions (compared to v6.2)

## Metric Regressions (compared to v6.2)

## Test Fixes (compared to v6.2)

## Metric Fixes (compared to v6.2)

## Test result summary
total: 180513, pass: 155979, fail: 2816, skip: 21718, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 146 passed, 3 failed
* arm64: 51 total, 48 passed, 3 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 13 passed, 3 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 42 passed, 2 failed

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
