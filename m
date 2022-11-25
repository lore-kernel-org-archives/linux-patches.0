Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7C1846B
	for <patches@lists.linux.dev>; Fri, 25 Nov 2022 20:01:27 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id 205so6235218ybf.6
        for <patches@lists.linux.dev>; Fri, 25 Nov 2022 12:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XsAz5OBEzFSCrUnH0XURNQPAnZshG1GxLmebcCoOCro=;
        b=M1fxuOx1LYLPTrX7jOgiFNsY6mUl3ZHy75KtzD2wHrMcSLVac2HWlQZ/pnZVBd8r5i
         64QIaD+J3JdhCwsgP8FKln0/tKEgXUlKf8dUtNZAsLlAC7a0iylDO82oYv62/RsFqQBx
         zqs2fRI5qzheKBClurQPHvoraeO2w60ryX9BY5gce4XWRUhQ/XE9CBrZ68h19wRXZxWJ
         Z/3vdq588NLmDIcoKH72Eqgk9AidinRyGdLiP5ErQACJpawMNxc+PYN3nAHnn9rX0b4P
         3tah9AxCSkvyNZi+siePM1rrbv8Oa4gpzATi/AHaNLUd6O7NY1PTF7bUOocZzuK87eTr
         fkdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XsAz5OBEzFSCrUnH0XURNQPAnZshG1GxLmebcCoOCro=;
        b=KiH9sw67SoKd9dfyRdPjRBYBdF3+/03L1P/terQwIVVZuaKO4L8Iky88AveUfn49a6
         mBgE8vcBExAp0A2eOvj5eqV9wqNVJit3aehqcyxcGUKmJS3x4/yy3zpAmjBuRD/acZzg
         UTfNid/Pl3sxzMVT8uOCMVdA0qXcHjym+1DiA4g0uXV6jPSa/Ce3NxQ0j5eziQK3wNIU
         +5OZbGYdj1e8P0lTVHKpLIFn6D6qcBSmVzvQLM1ZIRml2DuOO5jc2qiXdbOuEtCKLm2y
         Jpa/Dc1+1rAEKADt61mEDpbul90d67pJCtohWf39WLTldBUroH76h9ov5NhktA1vsp6M
         s05A==
X-Gm-Message-State: ANoB5pkfKZAT78mQ+FYMReRJHrhochrALA4JlUihO1EjCdTaeBtHX9Ct
	krAvRqI4tPDsh04ZtJz+ZQUJqIhQhwy62qA2XZruWw==
X-Google-Smtp-Source: AA0mqf7gKI/WoDu6LpJd7wKwjj72gk7p/63usADkgJGSXUlrxGzQ+7EPO6kFAvRuwsaxR6ehDmpUK7sviW1uFtmqxJs=
X-Received: by 2002:a25:d9d8:0:b0:6e4:c5c4:a62b with SMTP id
 q207-20020a25d9d8000000b006e4c5c4a62bmr19152567ybg.560.1669406486793; Fri, 25
 Nov 2022 12:01:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221125075750.019489581@linuxfoundation.org>
In-Reply-To: <20221125075750.019489581@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 26 Nov 2022 01:31:14 +0530
Message-ID: <CA+G9fYvHBGz_hHcxqizx4CKLuRkeQp9ytAuCjsBp+BGf1xQ0Og@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/180] 5.15.80-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Fri, 25 Nov 2022 at 13:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 180 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Nov 2022 07:57:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.80-rc2.gz
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

## Build
* kernel: 5.15.80-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: d0344da1eca6840c665685e68ae82c09b301fc02
* git describe: v5.15.79-181-gd0344da1eca6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.79-181-gd0344da1eca6

## Test Regressions (compared to v5.15.79)

## Metric Regressions (compared to v5.15.79)

## Test Fixes (compared to v5.15.79)

## Metric Fixes (compared to v5.15.79)

## Test result summary
total: 145876, pass: 126345, fail: 3093, skip: 16007, xfail: 431

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 47 passed, 2 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 7 passed, 1 failed
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
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-lib
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-openat2
* kselftest-seccomp
* kselftest-timens
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
* ltp-fcntl-lock[
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
