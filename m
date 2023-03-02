Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D31F110B
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 16:11:38 +0000 (UTC)
Received: by mail-ua1-f44.google.com with SMTP id m5so6504439uae.11
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 08:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZoz+85clIdYHHRz4psRFE9FEccrG+YghRVv5XN9g1A=;
        b=EOnQIcgrt+MkJMGUtXNGtauplLHtTY/RFGJ19kV8RLKYb+XFUJmuYMVV6uNCiKZK/s
         ffa/T1C6Au9S49x6ier1rnQ+g9VXLdVXVyK6VGGVtzSoP/1a9+yIUf7tj/cCSZFpPqvB
         L0e6AOuEeFP19DAsEJBfph+HVbLQ6rpJFuGiJ6lyvHayh830TOSlCQ/rBmKr+ePTh+Pp
         KmwrusnbRjQKGcYkm2wdBhAJp3qTd7lG0dBrdkGzZxQJK/JmVKHcC3Js9c8vt2j18zp7
         ZJzRMYdwz++e8PkWaVm9DwdPV/gIB8l3dGo/UdHjRvKlNsUysa6I4iDk6AKc7CgiNHj3
         vl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zZoz+85clIdYHHRz4psRFE9FEccrG+YghRVv5XN9g1A=;
        b=vXv2EWyXWSSJY6SHTeVBu2bKMCp9CTVrsxXUmVvFn2IqQzChyIznEaqim6yNGphjoq
         0WVHL2K2d3BLucvDJKnDQH0V4K6ZuZreJNK4bMb1VVE4IRA9YE3S8Gp7Z0QoeyIIWR7k
         twufplkxKF4QQ1unpGDsOmHr41iXcALKkA2tNx2A6w1KkOaKHz/vQT3S4oGKbrd4Lk3R
         9wmJndISf5yH1Aj+F+l44wvA8zFFwYNNYgkgcy5iH4eaqJzK5bBso78Hi3Kvpp0EBxQM
         EEW5d+OoZgD7SbyB1sKTlFuUSkSsB+3FZCN8JEnT0T9LvaNktmhjYrqgVq6s3N9Z5y0G
         MZCQ==
X-Gm-Message-State: AO0yUKWBsVyDDGyp7LEllXyuB3njBYJN/MAZnWfoWA6wpJndpHYRqEcE
	wX1Dx4YO1+qvVYWd3nPdnTFCZIjc7hXbGy8VW+NGDQ==
X-Google-Smtp-Source: AK7set+APC/erYWnIFlBLm+w0FzkXpZEbNPzYiLTJCkP+8/yXdcXT3o/EZxxODpQa2TLZUX+bKBlBnKWGLiIPSYWSgU=
X-Received: by 2002:ac5:c85c:0:b0:40e:fee9:667a with SMTP id
 g28-20020ac5c85c000000b0040efee9667amr5879630vkm.3.1677773496403; Thu, 02 Mar
 2023 08:11:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230301180650.395562988@linuxfoundation.org>
In-Reply-To: <20230301180650.395562988@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 2 Mar 2023 21:41:24 +0530
Message-ID: <CA+G9fYu85a8sz8Xq7Bmnn3H8uq0+H+D41YUGFC4gVdo==68zXw@mail.gmail.com>
Subject: Re: [PATCH 4.19 0/9] 4.19.275-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Mar 2023 at 23:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.275-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.275-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: c17367998a27f5908f6d793274690ef7f91fe0d3
* git describe: v4.19.274-10-gc17367998a27
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.274-10-gc17367998a27

## Test Regressions (compared to v4.19.274)

## Metric Regressions (compared to v4.19.274)

## Test Fixes (compared to v4.19.274)

## Metric Fixes (compared to v4.19.274)

## Test result summary
total: 96256, pass: 72823, fail: 3436, skip: 19617, xfail: 380

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 201 total, 200 passed, 1 failed
* arm64: 42 total, 41 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 42 total, 42 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
