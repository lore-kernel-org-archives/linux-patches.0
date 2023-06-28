Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5F22103
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 06:35:52 +0000 (UTC)
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-78f638a7be3so1457073241.1
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 23:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687934151; x=1690526151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uBsZLVTgJrT+03UCUP7W/SIjStfAyEMLyISpbv+xmm8=;
        b=xx86ri+gwOC9Wrp0q2L70VLUTQPpIylppGK+gJKP77dlncpC4yfRIVNFVgwGV9lES7
         ix7kpDChhplxq+KypktQntqSkE8E3XENNdXEKXs7+1UHfcP5lJyZ6C4aZIuL33KwjyXJ
         mrhfFUy5tDOjFzdUCAv8EIBPqxiUFyGIe1IYLMuR2xyVWcrJ+ITNM+tEvj8aOUu0lYkx
         P89HAxCgho9iOAwFyUdCe+zGGICW7hw+itHpWeK9jqabj46NYYfoauGku/wpmbyO2rIr
         ljHgAUu68EJDld92x4cYCnjc3B4cFTuVIphVamUUPLWkc8EN+FsAgHTW9xi8sD3ejkiv
         B1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687934151; x=1690526151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uBsZLVTgJrT+03UCUP7W/SIjStfAyEMLyISpbv+xmm8=;
        b=SS++lm5u2lzv5jWiBtF1diUoNE5zHzSTCQtWoJZnLtvyR34QK0COlZhx96DqXvgctI
         gXk8TFr9xIiEIjMbw3pZVjZElKMA8oFlqmJUNx3/wYybLxzDewJgoFI3U1nbPZU4C9P0
         mp60O07C55EAp51MPmOz9w+cnD2e29TuKWXOCMumvRFxbl70ZiJrcDryr1Am2UbHAeus
         HRFTkC4vIgF1y2wsX+Nt1Sw80PceW4xx953fjbPr4bvv20ubaLVruvfisa4P0Ck8WV6U
         wocmIlMY5L7smASehHxegv0JwElPhyA5YlMDxSGcH9xmL3ZvzCkPlOq585oNpC2pKHEV
         K6Pg==
X-Gm-Message-State: AC+VfDzpq1efsX76Oi9fshjwj4AzN81cvrmw7FxCsE96fXpNSNXf0/PF
	IGzrkfiHIDjC3guvF7nVo+V3Y7NVFOvGKM1EAAsiRw==
X-Google-Smtp-Source: ACHHUZ66FiA8xyxebfpqH1Qrde7H4jIWrD3BH5kC6/BYy+JjAxjAd0yItqgheFmJGhyMczqDz+DfrCQyD/3ICxiw6Yk=
X-Received: by 2002:a67:efd7:0:b0:443:62c2:7f4f with SMTP id
 s23-20020a67efd7000000b0044362c27f4fmr2989394vsp.32.1687934151245; Tue, 27
 Jun 2023 23:35:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230626180800.476539630@linuxfoundation.org>
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Jun 2023 12:05:24 +0530
Message-ID: <CA+G9fYs=AMHqGPMG2wa4wi8o6QmBqYEFABS8B-SDdf_7Ekzw3Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/170] 6.1.36-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Jun 2023 at 23:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.36 release.
> There are 170 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.36-rc1.gz
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
* kernel: 6.1.36-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 8c805fb9757e69c239188ee683605520ff73b913
* git describe: v6.1.35-171-g8c805fb9757e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.3=
5-171-g8c805fb9757e

## Test Regressions (compared to v6.1.35)

## Metric Regressions (compared to v6.1.35)

## Test Fixes (compared to v6.1.35)

## Metric Fixes (compared to v6.1.35)


## Test result summary
total: 166130, pass: 132599, fail: 3459, skip: 29913, xfail: 159

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 150 passed, 1 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

## Test suites summary
* boot
* fwts
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
* kselftest-watchdog
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
