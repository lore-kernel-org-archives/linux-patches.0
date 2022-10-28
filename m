Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDA92563
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 14:01:52 +0000 (UTC)
Received: by mail-ed1-f42.google.com with SMTP id a5so7982156edb.11
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 07:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BqeNWIlBRkMmK1mslOPps+q6bAFky+VJHL/6+iGrBtw=;
        b=qNMH5a1M+Yusizq5vVYKCJkc7615P73mvw7J3+JaYW9TJtpTCQNjAhHCQuhmoWn29U
         6wf7kRfCsuHxjkf1sBu71O6h40lAn3piFnLNgdIHl9vL5L1NVPWC0QIQbmqw2azPrSDq
         o70wM7InpV82lDGuQ5C4fKS9C+RS37XtnMKCYPOX3/h+OR7q0vc9orr1YWSd7r9A+SbK
         ub/BmNgPOSHFmA3DY6obZOEX+p2WRbXKk8UijaG7o+BKlReq3dRWHW1aP5qq5eor50ac
         +q4smWoHnA5dhY1NL962a12T9QNxCHEixkd3CBEvEh7/LgvjVFSsGpCwYvi34+TG3djQ
         +kUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BqeNWIlBRkMmK1mslOPps+q6bAFky+VJHL/6+iGrBtw=;
        b=FLxWyGdd5MKYP5rhX4h5lhOAAB5Wnqs/21Nil/44CoCtYqSk2BPRTQD1rz4uVZudhU
         ly8EulTepfzrs5AfMGB2ubcyB+V7Wv5nXC90isNHF4M3w4ubvoOpzsqj2O2UstN5QYpN
         9wv1pJDK0x0lw1yNMzhF+gDi2k3YCG1kd+8C0RbF3aS5oEcsQeaqUxddXUuojUQPEUr2
         lGrlcC5Hri20CxQdbBPAD9ITBHb7PC0jiMaW/01bSug5ojxllUz/aKnqK8RuzvcX0LjW
         Cr9Dyw2GFfP9on8H0c5la3lfMfrkhjfv0CqAq4uZNDq0gbz2dCwNjgZQbWQ7MQpAetZ7
         vbmA==
X-Gm-Message-State: ACrzQf0lkTfTciuL5Sh8ACMqgTH18sFHr2MTq4m1IEJVepdKP1V9TV8g
	ecFdNcyva4NUA4zixMdBtORCI3JPVIt0/3XwRY6Mxg==
X-Google-Smtp-Source: AMsMyM51gqVjvddmfdrHA2Awi7ragYxdhTfpa1HK2izQMpQaT3xyPp8hoWc+aCUM2WWSktiGTWBV194dhzRc8s8qhZM=
X-Received: by 2002:aa7:d996:0:b0:461:88b8:c581 with SMTP id
 u22-20020aa7d996000000b0046188b8c581mr30465868eds.111.1666965710354; Fri, 28
 Oct 2022 07:01:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221027165049.817124510@linuxfoundation.org>
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 28 Oct 2022 19:31:38 +0530
Message-ID: <CA+G9fYsvTNAFG5qMcoq_6PtexE3mW_0KKLi-FAMcsD+naskziA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/53] 5.4.221-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Oct 2022 at 22:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.221 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.221-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.221-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: f98a212520a532dcf91de4a5784c6b29b0da8874
* git describe: v5.4.220-54-gf98a212520a5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.220-54-gf98a212520a5

## No Test Regressions (compared to v5.4.219-256-gf49f12b65484)

## No Metric Regressions (compared to v5.4.219-256-gf49f12b65484)

## No Test Fixes (compared to v5.4.219-256-gf49f12b65484)

## No Metric Fixes (compared to v5.4.219-256-gf49f12b65484)

## Test result summary
total: 117476, pass: 99333, fail: 2165, skip: 15484, xfail: 494

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 334 total, 334 passed, 0 failed
* arm64: 64 total, 59 passed, 5 failed
* i386: 31 total, 29 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* riscv: 27 total, 26 passed, 1 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 57 total, 55 passed, 2 failed

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
