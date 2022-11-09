Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6DB8F72
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 11:18:29 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id 7so16055166ybp.13
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 03:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HqpT7YF5pBzczIJ16OUEpSt8Ce8OHXNWCTckQB7p8Lk=;
        b=MxxKQx+rVS8JDQFj+9e8rQG5mJDUY8lZSCHiVLPgXV/BRDDaCH6Si1NkA6l2AhO/29
         QsGExCVaVxUoTYtovqrlMk23Fj347wdCnBPO4/dGFsdyTMoSdnx+zSkPwSNCmA0kD9aO
         VIXX9ok+Ai7NrjfwGXTml02YQJLicFFJEo1oLd0CFOd62iijAjok34AQ2Mkr+RJkUsJW
         g3PSSFd5tHnUpRyoTwiKGTQ+xKK1TLaz3MrSroBMsSk+d9h+sYBkFMGPaxa5j2Lf/sXa
         J2ea1Rof1nW3mnNy7LboH554dueyr+p4yPcG6LCX1KRAChug39OK9Z18ZlEUorCO9A5A
         gU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HqpT7YF5pBzczIJ16OUEpSt8Ce8OHXNWCTckQB7p8Lk=;
        b=uR2pO2GSHrY9U8QVdqv05Ga5J2LsplfGuengxQlchyE4zZ/2ENflkrGu4fKYYh33ld
         PeptUU4NYr0BBZ9M0jKj77Pvc/UEML+GYMgj6Rth4SqX71k3oxCV9CYKN5t65azwZLDN
         qjNSNVodPlxPc3EIgRKbK4CREvk0Eb4Ouhs8Xiu3MkunbuhejEgOxD30JZ3XHo69S9Tk
         yr7iUKc5+ahTzrpWfj9DJLunAoOBDcevFw0ONW2GdAAaZP/jELPpLWECXElNitEpgAHB
         IbB8Y0xQsg/Zh46roGEaenp0No9bumn4KvCZ4oZSoBz0jc33ryM1xUWq0Mehkfnm6HUJ
         Q3XQ==
X-Gm-Message-State: ACrzQf2XJFX+1DK5tNXAd8y6YQ3eUgSJvJKMtRuFauPUp3U+EmYqY0Gl
	cMc8FdCfr/KVc4vqQfUAl0eO+XLMZYb7fb2hzNGqcA==
X-Google-Smtp-Source: AMsMyM5tkoZA6Uy4xXUm/3QnF5U0+qmGBXy+sivkBy0WbczWGXusBneWOd6254+9+awHeYNdIXaTp6Vzg83vN29PY6g=
X-Received: by 2002:a05:6902:154d:b0:6d0:c289:7b9 with SMTP id
 r13-20020a056902154d00b006d0c28907b9mr34793794ybu.534.1667992707865; Wed, 09
 Nov 2022 03:18:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221108133345.346704162@linuxfoundation.org>
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Nov 2022 16:48:16 +0530
Message-ID: <CA+G9fYt71fM3ayDfxCefkSMoRfbcDMwjK=1TF48mQaf41WuWNw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Nov 2022 at 19:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.78-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
1) following warning noticed while booting x86 machine with kselftest
configs enabled. this is always reproducible.

[    1.465970] RETBleed: Mitigation: IBRS
[    1.466971] Spectre V2 : mitigation: Enabling conditional Indirect
Branch Prediction Barrier
[    1.467970] Speculative Store Bypass: Mitigation: Speculative Store
Bypass disabled via prctl and seccomp
[    1.468983] MDS: Mitigation: Clear CPU buffers
[    1.469970] TAA: Mitigation: Clear CPU buffers
[    1.470970] MMIO Stale Data: Mitigation: Clear CPU buffers
[    1.471972] SRBDS: Mitigation: Microcode
[    1.499045] ------------[ cut here ]------------
[    1.499970] missing return thunk:
lkdtm_rodata_do_nothing+0x0/0x10-lkdtm_rodata_do_nothing+0x5/0x10: e9
00 00 00 00
[    1.499978] WARNING: CPU: 0 PID: 0 at
arch/x86/kernel/alternative.c:557 apply_returns+0x1d4/0x210
[    1.501970] Modules linked in:
[    1.502970] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.15.78-rc1 #1
[    1.503970] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.5 11/26/2020
[    1.504970] RIP: 0010:apply_returns+0x1d4/0x210

Full test log link,
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.77-145-gf98185b81e48/testrun/12907748/suite/log-parser-boot/test/check-kernel-exception/log

metadata:
  build_name: gcc-11-lkftconfig-kselftest-kernel
  git_ref: linux-5.15.y
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git_sha: f98185b81e483128439a76d6e64217b606c09bed
  git_describe: v5.15.77-145-gf98185b81e48
  kernel_version: 5.15.78-rc1
  kernel-config: https://builds.tuxbuild.com/2HGeJ0HPMmHQP8DQlZikW685I9F/config
  build-url: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/pipelines/688777444
  artifact-location: https://builds.tuxbuild.com/2HGeJ0HPMmHQP8DQlZikW685I9F
  toolchain: gcc-11

2) The arm x15 device kernel crash log was shared on another email thread.

[    5.393585] Internal error: Oops: 5 [#1] SMP ARM
[    7.917999] WARNING: CPU: 0 PID: 8 at kernel/sched/core.c:9542
__might_sleep+0xa8/0xac
[   10.529235] kernel BUG at kernel/sched/core.c:6360!

Email thread link,
 - https://lore.kernel.org/stable/CA+G9fYt49jY+sAqHXYwpJtF0oa-jL8t8nArY6W1_zui0sKFipA@mail.gmail.com/T/#u

## Build
* kernel: 5.15.78-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: f98185b81e483128439a76d6e64217b606c09bed
* git describe: v5.15.77-145-gf98185b81e48
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.77-145-gf98185b81e48

## Test Regressions (compared to v5.15.76-133-g55ed865a9c8f)

## Metric Regressions (compared to v5.15.76-133-g55ed865a9c8f)

## Test Fixes (compared to v5.15.76-133-g55ed865a9c8f)

## Metric Fixes (compared to v5.15.76-133-g55ed865a9c8f)


## Test result summary
total: 154331, pass: 129988, fail: 4055, skip: 19753, xfail: 535

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 47 total, 45 passed, 2 failed
* i386: 37 total, 35 passed, 2 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 10 total, 10 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 40 total, 38 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kself[
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
