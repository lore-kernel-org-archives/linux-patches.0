Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF8E29B0
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 12:49:08 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id i34so67074077eda.7
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 04:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OQI/f+ntz5M4Olnk/oXWleUzJcGh7PHcTDgD3KqTpU4=;
        b=VO8QARkqui3bdk9IgDxRJ8tx4sSXbFs0G9I1UfkB/mPtW5qbuuRsLbAz7IEJvCR5WZ
         e213cGsSB5qapFM9ybYeGn0bw2vDHRbh8qMRlfP+AgEKhs9iG3p4fD7rxJmiKWzXLigi
         8c22CgDUW8KROMfWXzj/ZMY4lr20WOXr7c457N3rJ2mSerL1XnkdtddJiBy2/lGmHsnx
         nisdhFNONZ4ytJM+aJHTFnh7U/EIkIJJDW7HpDTNvr4Q7UOiT7PmBLipBtp0w3uCeu9I
         iSw+vbkDFZQ9k0kzEGPifWsRB4nsgIR4DKKOcgY90ODVDMPLkq/3eWEeL4uGL4aCU37a
         pa1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OQI/f+ntz5M4Olnk/oXWleUzJcGh7PHcTDgD3KqTpU4=;
        b=ttxLuwns3NOCP0cbIPToJ1MpaiaR74hNu4DL9l+GSA1vFw9KLn/90U3LsJp1X0rCo/
         YPYD6RbqFZJP+emvPIskUFLhQ6PKL+xIPcQVLdwA3SlPuhRiC8/G5cTYEmJrGLTgeATx
         0XOcz4RYojskPrI/5ewUgPjXv6cG4pZEnpAdauIlg3wDIdYcmX+Mehtsj4DQeVektHmN
         KBD35/UEVDa2LFnAwpZciYX2sDtKskVGuWMSw8ILZIOPabv2X3Zd9hIidml414yilUQ7
         7un+1b0kfng97UqhbVQsvAGFHd3Nyqoy7+x3oM1oh8wvC8at+F1fKJskpVEF0FA1AFB+
         rOkQ==
X-Gm-Message-State: AO0yUKVd6+VS60DRcwkwNsFOJCR9fyPSGk9Zn1pVnYqwi1uRFWpeqjP+
	NJ1IvMeiLFMqz9Hj5CF1WdqTYv+s8FEEN38I6LJyrA==
X-Google-Smtp-Source: AK7set+GzA4Iz2XRep1CHwWhdZQyez9Dskjo5QaBGEhnmuAfr806wQ+LW8fFYLjuNxLZakZkKnor0eSJ5dZ8PgbqZ9M=
X-Received: by 2002:a17:906:9d90:b0:8d0:2c55:1aa with SMTP id
 fq16-20020a1709069d9000b008d02c5501aamr4713780ejc.0.1677761346825; Thu, 02
 Mar 2023 04:49:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230301180652.316428563@linuxfoundation.org>
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 2 Mar 2023 18:18:54 +0530
Message-ID: <CA+G9fYud5NoObu9b4qAbFtWibgwgmMHyMs8rRhXV+1MzKvS0cg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Mar 2023 at 23:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.171-rc1.gz
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
* kernel: 5.10.171-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 032c569d266c83563696ed018f5679bf7b5afe45
* git describe: v5.10.170-20-g032c569d266c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.170-20-g032c569d266c

## Test Regressions (compared to v5.10.170)

## Metric Regressions (compared to v5.10.170)

## Test Fixes (compared to v5.10.170)

## Metric Fixes (compared to v5.10.170)

## Test result summary
total: 134470, pass: 112238, fail: 3614, skip: 18316, xfail: 302

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 112 total, 111 passed, 1 failed
* arm64: 39 total, 37 passed, 2 failed
* i386: 30 total, 28 passed, 2 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 23 total, 18 passed, 5 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 31 passed, 2 failed

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
