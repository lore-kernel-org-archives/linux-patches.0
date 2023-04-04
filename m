Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250FF6AB8
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 13:01:28 +0000 (UTC)
Received: by mail-ua1-f52.google.com with SMTP id n17so23166074uaj.10
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 06:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680613287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AKuT2jdlAG+SgHXtPwT8kZwDya2VIJf4E3a+udNrV1U=;
        b=UVu37TzURWNtOLler24i+dYYA6JmTJHIBsMzMcAxh+2FFaw06F+PKN4gICXbWGrAhT
         aYUR7CT0QjUMik+CvKtNvuLcV0JIFV1Esdb35EIU5bXYVOEiZAT/sRHCJDqwjPHLRZk1
         gnb3FKzHoB3mvBEmHXANFTaRalrPYLFOeWe/tRkoVUjaKKdURnI/Sfoywtj+qiumn6JQ
         5b5cx0l6AtytMhl9cPSSd6Wm4wAjP6Ef2sHeZh7r0qXIv80fWcPmIN7wLRCxVpMJTg0D
         1gJCfA5e6b6pSYKdy0UOvzG0EzCjbhyDsRqZCZw276sCXYdVHYG6x7t+OEVqQCiM14N9
         LG9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680613287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AKuT2jdlAG+SgHXtPwT8kZwDya2VIJf4E3a+udNrV1U=;
        b=EWxRNl1/A+MCom5Y2rgspBXn2SEBmdGP3cM847EaPW7qTdluy5YEl6V9cmJ/vdWXRj
         i6hHIw/T8K1nkmF63y7tTAmlx95SSnTBORtvB30VjZlyOZogHH880HZ5QXRvMsE8V8qJ
         VoOOQvJNzZOkMyYQW1cqlCb1c2g1bKIQf/oqOr/0+VFa9X4R2YbYwkMgWcLg1Y+PSvHu
         qd70OvVSm0JIUwbYKu5vAq4jM7ueNXfzihfSL7E99v0vLCE73+0a7vlKhcB+wycmI67g
         OOMNk6wtgfgD+fvWN2ijRAHytA2x7JAifRO+9svvRLOrxVXjcXmfQAR3VKat25+5QCxF
         oEzg==
X-Gm-Message-State: AAQBX9cr6jQSZGd/L1eDx9ZZaSbwZMY/LB3n2+nJ/+BzBVQ5Rc7W3XHB
	E4pozp/nzy4E5vjYrm2kuW6tcVmzhcxTeYrFwG0Bgg==
X-Google-Smtp-Source: AKy350ZpaUQox2idaCi2bd7ek2lLeGMJEmRBZJpd+DvuzTfp0Jexh82Kfp6VQxs8ZCtJIMUzcUlSwJtwx2rOxZoLa9g=
X-Received: by 2002:a1f:90c9:0:b0:43c:6ef1:7116 with SMTP id
 s192-20020a1f90c9000000b0043c6ef17116mr2183840vkd.0.1680613286831; Tue, 04
 Apr 2023 06:01:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230403140415.090615502@linuxfoundation.org>
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 4 Apr 2023 18:31:15 +0530
Message-ID: <CA+G9fYsjKH8SqfNwaa0grQjaB2KbaJCTmMAzuxdLLKiK_qA5Zg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Apr 2023 at 20:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.23-rc1.gz
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
* kernel: 6.1.23-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 01cd0041b7a5a573cba99332d1c30a82999d7fc1
* git describe: v6.1.22-182-g01cd0041b7a5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
2-182-g01cd0041b7a5

## Test Regressions (compared to v6.1.22)

## Metric Regressions (compared to v6.1.22)

## Test Fixes (compared to v6.1.22)

## Metric Fixes (compared to v6.1.22)

## Test result summary
total: 168890, pass: 147321, fail: 4018, skip: 17196, xfail: 355

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 52 total, 51 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
