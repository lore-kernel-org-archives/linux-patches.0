Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6A929B0
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 13:32:44 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id d20so22376869vsf.11
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 05:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+JOa9pZ7+ghAgpItfrprFVqlWXmHMHYenIGtlQBzKw=;
        b=F2k5RDZeoIE5VJbWxYIWjjFQMBpubb9nOElNeKL6kxhHkh+1ag7CjXfXi9IkwbNaWC
         7h4n5E9dSML3Oy9qh3EQhg/yzXRGsLMgc3U82wwuyvsyjhSDS51YM962HebyssumV59V
         KH6NnWO7EVVa/LoLb+vKEYM6427Vr2RLBGLyYJmdBTTSgAI7oNMmy/2jDjX6/uy6nxSi
         0xMphofecLvx3/bJAKv4G7viTet8/aUB0+eXZadXdimALk3R+ifpT8Y3bZkea5yKFtqa
         Mkob0wLPQWTUEcE4UUvj+pcRwl7i2vW2Vu7Nq/qfGPztYMXTBZweVckdx7bFb/kRZQ1R
         h1Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e+JOa9pZ7+ghAgpItfrprFVqlWXmHMHYenIGtlQBzKw=;
        b=w9UTXRmE9JvOSGqqsBF3PZbFygoBbe4egXVb1z5YC8WfS9nrfGmqxqj1GsOVAsVZVO
         Ih7HQnTaM2lOQpMt3F1bReiZn4khMOG7h8hsUToaiFPLs7xkLqAR1FiPmgX9lbRbsSzO
         GFN+l/s6KVMcyMT1+BgJLX7W/qgaUXzKjvhikAPAOQqhkjo7691kLMdGuiv2UQw2KHGi
         /bnU0GNRhQKLK4zVIfk+MxB+YQPLpT8x/FrZAjBQVVw7GTtS55yCk86KxSS1XexRxqJT
         zKnETvk6yegA9qq/90GJuHI3RrsRer3Rj3ykn7inTkneeaIQKA1UDmbcQmRC+PVeUDQ/
         3Tsg==
X-Gm-Message-State: AO0yUKXvvE3ZwWbGAhxujGE+ZcCU40RHEREsaQ/qDPHzLrGPdyT45ZO/
	as8LnikkCWDpMvbdWSOb8Z0E5TyBqv6qOKCmRgQftA==
X-Google-Smtp-Source: AK7set8PXR+poX2YcXj7iCgYydTF+Ao1o9SGyiLg8mU8hDre6+aCk1K8aMCxotCIKFtKAoNrlqhM17w7h8cWXXNfNOc=
X-Received: by 2002:a67:f6d5:0:b0:41f:641c:f775 with SMTP id
 v21-20020a67f6d5000000b0041f641cf775mr6258638vso.3.1677763963739; Thu, 02 Mar
 2023 05:32:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230301180652.658125575@linuxfoundation.org>
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 2 Mar 2023 19:02:31 +0530
Message-ID: <CA+G9fYt_2bZ3AXe49PkGF3s-WLY4=+oDa20dYR5YHZr+tV1haQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Mar 2023 at 23:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.97-rc1.gz
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
* kernel: 5.15.97-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 6e657625508dd663e1229f6f6677c578cf36755c
* git describe: v5.15.96-23-g6e657625508d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.96-23-g6e657625508d

## Test Regressions (compared to v5.15.96)

## Metric Regressions (compared to v5.15.96)

## Test Fixes (compared to v5.15.96)

## Metric Fixes (compared to v5.15.96)

## Test result summary
total: 139666, pass: 116363, fail: 4228, skip: 18769, xfail: 306

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 42 total, 40 passed, 2 failed
* i386: 33 total, 30 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 36 total, 34 passed, 2 failed

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
