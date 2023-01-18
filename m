Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FCD2564
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 08:28:54 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id j185so3818905vsc.13
        for <patches@lists.linux.dev>; Wed, 18 Jan 2023 00:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EgwkxFA/5hxmqEfVpVeMVFmrcPYGb/v+fJDmHhdHR3o=;
        b=eRMTBBitDmXLUDrc+w7LsAc+KvobQW8SbRV7Td5vH8RB1qq33GnD/MCBj7IRL9qSzE
         4Fu9uBHrpek/EDo/CwYhoyTQQcQFj7+ZD+6BVhZD67HngX6rwhZFv004220336p6kj4w
         y0FV7LaxHYu29/Y4qCIz1g1OeJdSU7SyTeYBMh+zftMhVXddXYxplU93KbOkUfhAshi5
         Dv4A2Z5FmZhPOkQqOJkNTYxNbexxGr9u607ZxdHwJjXw3/tnrNe0cr5E6TuAVEvQ2qru
         xRMlfBmREH7Qd0h/r+KjNrmK673A1/hxDVEGNQh0QWmo4d9rKt4kPrV6SKfcg1PzYdzr
         phhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EgwkxFA/5hxmqEfVpVeMVFmrcPYGb/v+fJDmHhdHR3o=;
        b=GIrr6UB8rre8+xN+xt6inBD22rUfBxTHi2mgGa8DheaVbNSRAjKBRdVJoH28OzkCEi
         VxiPlOcnpcTsjy+97yOfnpnKcz8ed1mg3XAmt/dBuap6yemrE9WfZRMRRhPxmeln+nUJ
         ClcJiE+34c+lki9OlKmFs/uT5fRLwUlxMzEcTiTBIpkomLoZqk/PKV8+5o+TtVWbOHws
         imlz+6Nk7C81+GDlk7gIJ0VJEJn3FY0ieNvJrMwhhdvbm//yGQjzWFB8gQ2zo/wC5zZb
         yc1ptQDPhUVCTTA2AEgihXMwINpsjBAXFkKJwp1ksiBCrhxlZ/f3AzC8xEiraGkmL0h6
         4u5Q==
X-Gm-Message-State: AFqh2kpRrrxBHMwBF2eCkNrx1AxmzEhWWgxwfhmUTwngcLQkuuzq3fdy
	bcoFFx65h6c/OZXFPfHYnmn2CP4XxCCANWCYl/0LWQ==
X-Google-Smtp-Source: AMrXdXvGUOZPwaV+QEUIGHCU3lvb/IGqsRJFa/dzFFJWVja/uIqybMB72t/g7Dquhl8e+BKtZLHFICGU4ar1Zdx7YMw=
X-Received: by 2002:a67:b102:0:b0:3d3:dd2d:88d1 with SMTP id
 w2-20020a67b102000000b003d3dd2d88d1mr751429vsl.83.1674030532755; Wed, 18 Jan
 2023 00:28:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230117124526.766388541@linuxfoundation.org>
In-Reply-To: <20230117124526.766388541@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 18 Jan 2023 13:58:41 +0530
Message-ID: <CA+G9fYt9XmoHM-YBQGxxsWx972e4aZ1wzD5-DY470Mre5QtXdA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jan 2023 at 18:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.164-rc2.gz
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
* kernel: 5.10.164-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: eeaac3cf2eb302f0b8478a43f9d199b1bea51e15
* git describe: v5.10.162-852-geeaac3cf2eb3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.162-852-geeaac3cf2eb3

## Test Regressions (compared to v5.10.162)

## Metric Regressions (compared to v5.10.162)

## Test Fixes (compared to v5.10.162)

## Metric Fixes (compared to v5.10.162)

## Test result summary
total: 144322, pass: 121403, fail: 3574, skip: 19028, xfail: 317

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 133 passed, 14 failed
* arm64: 45 total, 41 passed, 4 failed
* i386: 35 total, 28 passed, 7 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 28 total, 22 passed, 6 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 38 total, 31 passed, 7 failed

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
