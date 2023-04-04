Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C827F3
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 07:27:10 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id h15so27637158vsh.0
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 00:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680593229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vlz6Wp5FK79o2mUyLxwD7cc+G1aD53kNQqkkJLlNmhk=;
        b=b2MSdNlXgNEG/jBi09Go4KIlwhJgyep1CaTtYSpiR+Sa7oXepsaMCcx8vsnYRXdYk6
         gKWOFPrfoPQYooMAYKyGHJJ3/iGh7YdmqdQllZJl0KlaFp/yvinDoeiviv1Iz97HMp+h
         KHfQan9Bl6y8yuuXx1GibtVed7Nn8uQs/xili0NvzEGcqRxB+UpBDAc0RI41PUfQuR0C
         Frf4lgpdlFJO82YrVwilc5aqcXnZBE7o7As4zjmxgfTcOXb8s0niV5/GWQ1GIQDBUThV
         veAPZJI6KyWPBHOMBWa2uyFTcOA6isAll0kZJ14uBDRMyOrrCB1vqPlsJiz3OnQu/9L6
         OlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680593229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vlz6Wp5FK79o2mUyLxwD7cc+G1aD53kNQqkkJLlNmhk=;
        b=iVF74d1WfNvOv2wvuZVjSYysicA0O66uSu0L/Qaqh4RLLwpIQCJ3hX5tM/1jsoQELz
         NarEeujKEn3vkScuK0eISwk0C1JmRIqagpz7jfX2Xwnd0/qsXPp+iEPgKmHgjzThurjO
         2WrhnodYqMQt8UTLbKDZJPov69Gp2fGDzX20osU0znb4EtXsOaqaxRUNFuZoYMksZjkd
         SvgwWju1g3bdWgC79Z+yMvHMeuR3k/HeTDyE9RTgLE0imDUfxYlvDpWKubkdgmBeF575
         6FiUwuMCpytFf8JfwNTUozph5MBsdsFfIOroSARh+BxYMjcmhDqh7dI0+rY/zh6tHL3b
         guLw==
X-Gm-Message-State: AAQBX9eYyhrSXZKPscWn4tQXtiOYrI8ih/nU50k+8x2y5pa5O1Sv3tKO
	oROYwyDnBtxQBfLajIB3ActivO5yF27oa2QC5YfBuA==
X-Google-Smtp-Source: AKy350bRVj/1oluDM3VgMwrtB2McZPzYAWBenGEvOJExZIHSkH8u9/UzITdKzBR+kwpBAAiGqgk+VVnmxHFUfts3vXA=
X-Received: by 2002:a67:c812:0:b0:416:2ad3:35ba with SMTP id
 u18-20020a67c812000000b004162ad335bamr1626316vsk.1.1680593228980; Tue, 04 Apr
 2023 00:27:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230403140414.174516815@linuxfoundation.org>
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 4 Apr 2023 12:56:57 +0530
Message-ID: <CA+G9fYsHAG8y3nC2KP-5sCzchm8hBrOOfWfYb_DTJgdopU2KiA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/173] 5.10.177-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Apr 2023 at 19:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.177 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.177-rc1.gz
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
* kernel: 5.10.177-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 7d617ad89b616010f8233d54ae9d5623cbb91b41
* git describe: v5.10.176-174-g7d617ad89b61
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.176-174-g7d617ad89b61

## Test Regressions (compared to v5.10.176)

## Metric Regressions (compared to v5.10.176)

## Test Fixes (compared to v5.10.176)

## Metric Fixes (compared to v5.10.176)

## Test result summary
total: 126510, pass: 104809, fail: 3271, skip: 18206, xfail: 224

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 43 total, 40 passed, 3 failed
* i386: 33 total, 31 passed, 2 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 26 total, 20 passed, 6 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
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
