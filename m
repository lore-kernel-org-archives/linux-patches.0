Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE6729B2
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 13:31:33 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id j2so20990401ybb.6
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 05:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aouj8d0RJ50aW/Vsd94vh5WZ038hUS4IE2hWYAidGmc=;
        b=oQlsBIixlmUIimrpVlQi8SjHpZjTmQ9qwf9leUmFVEkhcal/uKHuBZKYDUUZsREG/s
         9UVXHavUFcIsvUCRsRT8gtxWd4wcuBLmXeOfIBRuu5VTjEAICEg9+hPf9/gWxx4m3e4A
         teVzA/O5CMLiAB9kQY+pi267KIBN+1FTumTLYsabQ4ypNsl+QXskthrfXR8YcsWcW5p6
         20Im87jQH4PVyJ8x8QJJ35wR6rTlIRfmwDVs+IARh2oYGe3+LU4G4W7uFJ+VZNFGyGit
         EFdxCnRshMX9Wr9lqsavcCvgGCCyj/nfCf01xTYHy150XnaXZ+fwGKklQpF2LTQoqXHN
         NwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aouj8d0RJ50aW/Vsd94vh5WZ038hUS4IE2hWYAidGmc=;
        b=lXJ4Faq4Ion24MJblCNV6MmegWxtBkZu+HCLiidxox4NKFv0sur6sPKJxbiYVXZWeF
         F85W+ki85PDJ1Rc2imEaX8UAV9rxkot6nNj/c/osxowK0W4pmJ+VAhNTxnqE/rGDwhQz
         xa6wnb7I2QZyOyonbo985l3If2Wle8cPaM6w39wWVoXrbska70Y62XqMKs66GrDOx+cl
         d69t+iDDcOKg8w6MBOG1N05vEJifEZLkzAjgfIgWol+8P4JNew/KdOYj2tz1SGQCDSlx
         /gH14louOOFnlZ8kWfGFYiR3pKw4eUrcQLszF+tg0gPVc+pU+wb2K+0QvqEEHHYXDoSm
         RYNQ==
X-Gm-Message-State: ANoB5pmzBs0iPilfoczzen6+0Ze04EdLfMfQm19bV1Wh58+NaOMUyjTF
	VSJwIYN+tMCUz9wushdFhG0heWYNOFUJiaF+7sniBgthFBV6yQ==
X-Google-Smtp-Source: AA0mqf68Ln1lKgotZFyr3fzO9Mouxw8mfDxH3Vtst3AIQC8HW/kBWtipUDsYKITAOMekCTktLZZRfcAiOiQ+Nxiesb0=
X-Received: by 2002:a05:6902:120f:b0:6dc:3322:fd84 with SMTP id
 s15-20020a056902120f00b006dc3322fd84mr162371ybu.534.1668000691870; Wed, 09
 Nov 2022 05:31:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221108133333.659601604@linuxfoundation.org>
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Nov 2022 19:01:20 +0530
Message-ID: <CA+G9fYubT+C7KrKeHDTzXuc9nq-PpVV_7hoLgYDxb9Sp-FaKqw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/74] 5.4.224-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Nov 2022 at 19:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.224 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.224-rc1.gz
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
* kernel: 5.4.224-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: dc8d80bb822aa0a393ccaa810d63be127d1bd864
* git describe: v5.4.223-75-gdc8d80bb822a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.223-75-gdc8d80bb822a

## Test Regressions (compared to v5.4.222)

## Metric Regressions (compared to v5.4.222)

## Test Fixes (compared to v5.4.222)

## Metric Fixes (compared to v5.4.222)

## Test result summary
total: 130360, pass: 110431, fail: 2196, skip: 17226, xfail: 507

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
