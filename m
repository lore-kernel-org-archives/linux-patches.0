Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED5CEC19
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 17:49:58 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id r3so21893835yba.5
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 09:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nq3AzpSRBbWcICYu5OOeBkyYd+yGYnaz3Om02KfDufg=;
        b=teqnQjgJGkhIgyaoI/H3ihIHnGnvmRfpKjzWT/eIh5e86b1smDThothvnsgT0DLFZx
         cc6MtETRvrqW+CdsTeIRQnDjHXZiCL72XnI/0meYsqXREcm1J6vL9QcS26Eml6G0GVyM
         rsFsRjT+GqzQ7PNfU8+lIaX5AsS4dkRL9fWLYTrNxhmKFOF2zZzwvRg7D5vtIpCSGAJ4
         O4oTQjxXRbVY4WmLdEJFnBxLNkSgEkd2i1F0DTZU8tjZvFjfpXYVlYZXT8LXEJaLxBO3
         MJk+Wu3EtZpk/f2H46rPqv/EHtq+TVuhpv5lN8MBUUwg6Qy+QeSmwkbuE9tFfQOvXZfp
         SRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nq3AzpSRBbWcICYu5OOeBkyYd+yGYnaz3Om02KfDufg=;
        b=o6zKHbxCk8W+u5HLE85omqvAM8/S9Nb5Q8wuZPe7YsWn578p783jvamClfixi5Y7ok
         PctFfo4ktHEgWeuaAbQwqYQYE8WuEbkcnj2dsqDqkwFuuaafc0yssY+e9AwkflSGncg5
         fHS28h2M/9JLqT9Q1ktRecmHPev0FxQPwz9Dbq6UO5V+Vl1KqcMwqneN6O2ztI6jdgyv
         HRhYz9n7sybeIqhzJuZv+sbVE7XmjTzIlZ30keNmoQZ/KAlk48kYiFb6ClWZI4GYdkxr
         h4ZzRP/3KTTor0M1GNqjpt5uqxAWCg15PYyAo/NwTIktB5WtEYclxUpTfd8iHCueyb/N
         3fkQ==
X-Gm-Message-State: ANoB5pmPvYk4V0Ix+NVfAHsE+NlER3rYGmoBUEPOE0b2oRVD4kkO790/
	j1U99Py6NVJAbd0GT0UQEBS3AZq74tMHB1VZIU/FzA==
X-Google-Smtp-Source: AA0mqf4HrEeB7pUDS2yONj40k/dJn+sjGfhpvj208P6V9Xk0LjM3/shvsSss1MxGD9ehfC2xfXziIcOJ9WRKKznx8XY=
X-Received: by 2002:a05:6902:b16:b0:6d6:9455:d6c5 with SMTP id
 ch22-20020a0569020b1600b006d69455d6c5mr18075586ybb.164.1668016197143; Wed, 09
 Nov 2022 09:49:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221109082223.141145957@linuxfoundation.org>
In-Reply-To: <20221109082223.141145957@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Nov 2022 23:19:45 +0530
Message-ID: <CA+G9fYun_sLLwxS5v1=9d9TtRu3m+uYNM+FN+ZHq9BmrS_s74w@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

On Wed, 9 Nov 2022 at 13:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Nov 2022 08:21:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.154-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.154-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 69a0227f6bd671ba8efa071c58d9f127932e25f2
* git describe: v5.10.153-118-g69a0227f6bd6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.153-118-g69a0227f6bd6

## Test Regressions (compared to v5.10.153-118-ga2b01d6ae5a1)

## Metric Regressions (compared to v5.10.153-118-ga2b01d6ae5a1)

## Test Fixes (compared to v5.10.153-118-ga2b01d6ae5a1)

## Metric Fixes (compared to v5.10.153-118-ga2b01d6ae5a1)

## Test result summary
total: 147758, pass: 124924, fail: 3289, skip: 19119, xfail: 426

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 47 total, 45 passed, 2 failed
* i386: 37 total, 35 passed, 2 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 28 total, 23 passed, 5 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 40 total, 38 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
* kselftest-breakpoints
* kselftest-capabilities
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
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
