Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611D0136D
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 09:17:15 +0000 (UTC)
Received: by mail-qt1-f181.google.com with SMTP id fz10so15738537qtb.3
        for <patches@lists.linux.dev>; Wed, 07 Dec 2022 01:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iyRSJ03UYoEC2ZtAcRU2q4OxeENJur53H/F9njw3Qjk=;
        b=CwwKo8wQabX5UBj7ySx2RiInxsdyl8Nab58vGWeAhSi+S520s1bNbI3gttzJ2tub+I
         SWL9rA80hkaiNVbJ4hXyITm2o2Xk5TjmIzL3aOWsmGCXW4BSGwmovkBUmkclufeXHVuo
         JyIFFcXS/bfIk1DjXr8g1JuQsvZ619U50DNKi8SYUJTwxcHA9d/A4oTXKLsvgviteqy8
         dRH0j4cBWRkVzNecR9PRAew0roseMpCoJqbdPFBy7k0yHUMUHkGqS3BeC6nkg1dtrTWB
         sNG7ZtSKzPhscQ6iMayVJmCkVDFFuUEdmbVJVqKaFeq9ZY7A43Q8Yn862eZBEyTEigOX
         UCWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iyRSJ03UYoEC2ZtAcRU2q4OxeENJur53H/F9njw3Qjk=;
        b=vilo9tla70wgLC4cVvGVHYFFeNpj06zJC42Z60S5AXAMSbFRl1FZaiHYX7gTp9gHgV
         7QgQjyZxoTdfB+f6lbFiK57mN/+tmb+8odBR1XCQTgdE6tgIeUEdR4j/GIYz/6s1IZbt
         pqdkXUADQZw7mhXOhzvpcGQIuJYZ3SK4rVWsRQz596bODeO7MREOwmVWU4sHY4H2icEf
         rsUhAADjgAWGb4wX19G4CUrqxqP5yEwCMGDVtNeFRdiEZLV6goJP5bzFDf2DFFH/A9Jo
         tSAfEh83jaRnt2S+/uX2QOwrRzl6lmL4g+Y3uLSAZZwdnOaIBtFEIlWAlF60TW5UWDIW
         lCfQ==
X-Gm-Message-State: ANoB5pnIiL5wPd5If+bb2UzvoBh0kdmu4mqiExXJ77nNrXuuSWgJ1tvK
	dsZBOSkM0ua4K/d4h/d3ZWRT/DBEzkbTyYM2YwFaOw==
X-Google-Smtp-Source: AA0mqf7Yb0+c73+5Y8nxoCFx9H6KqQ4uN6dtxr2Qj6hcqVAihaJyCT0h8A0pYK+kkc21tzcDsWjVTpWORrrznTbMym4=
X-Received: by 2002:ac8:148a:0:b0:399:a020:2aa with SMTP id
 l10-20020ac8148a000000b00399a02002aamr67013643qtj.247.1670404634052; Wed, 07
 Dec 2022 01:17:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221206163439.841627689@linuxfoundation.org>
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 7 Dec 2022 14:47:02 +0530
Message-ID: <CA+G9fYsWwBVo==b2JaxPpZVj_r1xS+Dmhwx3pjzZgsLbZfD0xA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Dec 2022 at 22:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 16:34:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.82-rc3.gz
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
* kernel: 5.15.82-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: c5f8d4a5d3c87702a65ac957d865ddb383152e04
* git describe: v5.15.81-122-gc5f8d4a5d3c8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.81-122-gc5f8d4a5d3c8

## Test Regressions (compared to v5.15.81)

## Metric Regressions (compared to v5.15.81)

## Test Fixes (compared to v5.15.81)

## Metric Fixes (compared to v5.15.81)

## Test result summary
total: 148814, pass: 128616, fail: 3329, skip: 16343, xfail: 526

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 47 passed, 2 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
