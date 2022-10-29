Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8293023AA
	for <patches@lists.linux.dev>; Sat, 29 Oct 2022 06:56:03 +0000 (UTC)
Received: by mail-ed1-f54.google.com with SMTP id r14so10771935edc.7
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 23:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jgDeNBSZQlv93+JZzxDcsUdFM1DjuKhSQlC8ZxGJsjw=;
        b=af/bSK46rGrdA/00qrPBKyNQcAoEJ1sjk128cBxb1c3vg4vMM5FkkVFhgAvAsWhA+L
         idOb43OQFtL18QYZglupH0Abbs43GtC/bwoMA0Zp5G8KacnlCjaG6+OoDm+TkxYSCTr5
         N/5hZI73ykbpiuQSG/TjHcBjghFjxpSymD7eZ5fHRDKCDScULTf90MH7ktjN/fetvFf+
         4YlCP9vrpdxT8689WoaVT4JOihQP1qsiNfC/3h/AEA36HC2Yy6onOWYppFAcnDgylA4d
         gujTnLi7BnTFxYb5TtyVS4p1RI1knRrs4D/ZvNX5HcKoc7rUmOVSWIWj0wwZ7d9V45Tu
         kDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jgDeNBSZQlv93+JZzxDcsUdFM1DjuKhSQlC8ZxGJsjw=;
        b=ZdthW5Ii2EGy5+gAJ/bEw4UR0IqtqA83C7XfZyrOWiFLS4Cotk2s/+zjMteb4X4LKq
         Zb7tOqmDs5IVdxs2/3JYDpQV9HXiUlFCeM0WUtYw4CIIZD/TKSAE9L241Nm1MLB6YvO7
         BAlVSqVw9pMwqooRDMLSxxucqas6xmzhJRli5ZhtK49VdOenXPG+60LwUL8aDkkirpyN
         XttvOPlEKFtufPWb91Lq5CM1soPn0nZgdbe9CNm0TcKLYNZG5/uMQQUhBoGLRi56LCrQ
         LeNzw+zbd1Gidobce9eIq0y14rIDgKorUouRHirEHhPKvFRrhhxl+7gszol1n+gOCMcM
         zA5w==
X-Gm-Message-State: ACrzQf0NkxL9OB9eUcdG4g9EkyS2jGMzev1gURH1cy5G230Yv8TtCWas
	RNbq0WF0N63LNvLeKJaVdB41brC/3rCdXoZQ9k4QgA==
X-Google-Smtp-Source: AMsMyM6tDrG5GJxbw9ka7ABfSJ4a6/flhTN1qr4yNFTEPMRTGJdVeSpofKnpOIuUOtn4C9Z1RPgt+sgYj+Wj74EX1Mg=
X-Received: by 2002:aa7:d996:0:b0:461:88b8:c581 with SMTP id
 u22-20020aa7d996000000b0046188b8c581mr3073783eds.111.1667026561426; Fri, 28
 Oct 2022 23:56:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221028120232.344548477@linuxfoundation.org>
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 29 Oct 2022 12:25:49 +0530
Message-ID: <CA+G9fYvqrVD1XdVpgGQY+VNuK=VDDTgbS7BapQBH0CKXOHghSA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/73] 5.10.152-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

On Fri, 28 Oct 2022 at 17:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.152 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 30 Oct 2022 12:02:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.152-rc1.gz
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
* kernel: 5.10.152-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 04a0124fa82b58226455ad4662246e6ff8c53bb0
* git describe: v5.10.150-80-g04a0124fa82b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.150-80-g04a0124fa82b

## No Test Regressions (compared to v5.10.149-391-gb4f4370de958)

## No Metric Regressions (compared to v5.10.149-391-gb4f4370de958)

## No Test Fixes (compared to v5.10.149-391-gb4f4370de958)

## No Metric Fixes (compared to v5.10.149-391-gb4f4370de958)

## Test result summary
total: 132774, pass: 112586, fail: 2626, skip: 17166, xfail: 396

## Build Summary
* arc: 4 total, 4 passed, 0 failed
* arm: 113 total, 112 passed, 1 failed
* arm64: 33 total, 31 passed, 2 failed
* i386: 26 total, 24 passed, 2 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 24 total, 20 passed, 4 failed
* riscv: 7 total, 7 passed, 0 failed
* s390: 5 total, 5 passed, 0 failed
* sh: 8 total, 8 passed, 0 failed
* sparc: 4 total, 4 passed, 0 failed
* x86_64: 37 total, 35 passed, 2 failed

## Test suites summary
* fwts
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
