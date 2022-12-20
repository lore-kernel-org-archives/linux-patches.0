Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0867E
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 10:51:21 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id d185so11456798vsd.0
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 02:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RJ6o5IfEsp0BRG4ODzXEEbhMqj09Ho4N8ZgzbSCiNbQ=;
        b=wuFdu1lNeZnmuY+TQyGTF90b7b7Yr93aYUkTKYZa+q6l2lCRUzWT/V9214ACcP7y1A
         pYcQnf79+txo7ZqMDJTAgDqJayBqnhf5Cu0Rj5kSFVlA7mX1+InE7E81x4yw/T3S2ZUh
         j923E1jSxI8j94WpiaOwiWJS68ToxMI0Y663nBiw+pUTSLIM/XEL3wyOvwjuZ4oFhf8/
         ld2yE9nokjhd7vrODE6iAhQqFHoT6alEMD52MHlHXEgyF+WpM04W7gtuROYETmfONgMS
         acIRbilGilfctkj1xsavIgF/sfXEYB9n/AboHW+1Ik7Xs+qsGdGkDv0v8Tx7w/7kn+Zr
         LiAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RJ6o5IfEsp0BRG4ODzXEEbhMqj09Ho4N8ZgzbSCiNbQ=;
        b=cNP55n3i0gtCTYgtlHXqJM2ds9QVSInGSFNWoy27E4QnjNh+egk9v4PqyOhB9gvcfU
         nbloekYgD2gXMB32/9JD9zrqgl70RqJAW0lTzlaWSLrRSV732UstKwmUtnHX1QeJrE/z
         2JSmlJTf5Uzo29MeHia0A8N18Y/b0Hv5Bqb4g/YLHToiiP/4LNIxMH/SpH5OKSXP29/4
         zQnrxacHO7zHDoKG3hiPArPysjOaydQikfWwUTKexwLi7N1SMIGVe0FmV9O04aEFr/Gn
         Psi/8sMWfcyrR8ZtKfoMlsdodbGb97jsNdWejzIauf0D5xi9gR5WbBNuLmcnmfA8VKJy
         yhiw==
X-Gm-Message-State: ANoB5pntD08UHGhqL8tOiOjo+QVXFreUE0kBI80W8gS+OIUbQICTkMwl
	G/zERhtt12zq56hdskOq3ttwYyV9SP0RtCBtfxQJTg==
X-Google-Smtp-Source: AA0mqf7htH1ST4A0I16Ps1jABr9Nv4RhZ4YwRf4zg3dkfPJUvWzJ6AvII66m3g5kNuVUfYK4+FNIbPV+a8xJ8NyuswQ=
X-Received: by 2002:a05:6102:3ca1:b0:3b5:d38:9d4 with SMTP id
 c33-20020a0561023ca100b003b50d3809d4mr3972802vsv.9.1671533480206; Tue, 20 Dec
 2022 02:51:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221219182943.395169070@linuxfoundation.org>
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 20 Dec 2022 16:21:09 +0530
Message-ID: <CA+G9fYtDkQr74iFPJN91zYuL48sW1G0FmCZkvZk1cKF4==Ua5Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Dec 2022 at 00:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.1-rc1.gz
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
* kernel: 6.1.1-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 4478ff938eb5814bd2ae93b7e2d68c4fe54e9380
* git describe: v6.1-26-g4478ff938eb5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1-2=
6-g4478ff938eb5/

## Test Regressions (compared to v6.1)

## Metric Regressions (compared to v6.1)

## Test Fixes (compared to v6.1)

## Metric Fixes (compared to v6.1)

## Test result summary
total: 173959, pass: 152611, fail: 5743, skip: 15605, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 146 passed, 5 failed
* arm64: 49 total, 48 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 41 passed, 1 failed

## Test suites summary
* boot
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
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
