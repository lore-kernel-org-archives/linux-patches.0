Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BBEEBEE
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 15:46:56 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id 63so21465379ybq.4
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 07:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+db+5Z9ir7Cyd5yAhiscv5NRodvbCYjVQnMRArw9osk=;
        b=vjaTfhZqXUBAEwNj/ZgtOMYYqfk+85ZTZOEhAGlRKCZEIj4s7pLHGwM6jXl3TAXA+l
         l6l+62k+u+fawUq+NOl10enWS6+qhIJYfsJdkBLbN1ItDfIdeoxF5UIMaSpzfC3Ja2lb
         wb9Z5V8zeO+0fhUyF3ymzmtdSqFLUZvyHlA5MEijisce4GcjqguvQ459E0tZkDM+3P4V
         PSP5kpQHxZVgq+K5Xg8Mf6Zub+xuDj3AdK6Uv9/LKupUCPCibMdk7xRpmXzXKzSTjkKZ
         3ERtenjh6FmwNlgXdlBcFeArChsbJQGU4rqTokQSapalbqZ0NyzhQZvPWzPzZc4FzI3g
         Smpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+db+5Z9ir7Cyd5yAhiscv5NRodvbCYjVQnMRArw9osk=;
        b=BE0z3/SY8WKtdfh6x4pm2WUFtJp35L/LDOS37RLLpc+/6CjkoY5tN/LpP2s6+TFTlE
         NCwudZKcvz5FXiHCg7QlJ7n3ZwOIUCGZrzIkVbWmAuuH1dXP1Ut8O98Ew2m/eBvp58df
         rq3wXCNQuICu+cmZiYhUHcM7FWNFEk96PMjHBy5kGQsZ8Jm2U/TTh1oVr0A2lYVJvcLL
         ECFfUqoW+uNKiTCr+mHhFDvuJrG8pCVemaoy25OV66hMQ8mS7ZzLSaXJ/alkDQJvqi3D
         Dndq64/4O8MrvU/TSEuiiQm44ROv6D0Lz0DLA5gdsA4gq/awMyPqJVIHlBppbobAJFCs
         QqdA==
X-Gm-Message-State: ACrzQf3PC6BCZJLOgkhZv7zu6jHsLQO7Yg9oh4Mr940KPzbvlMIrE/Ct
	Q2MOEi7cpu5oRmImyM08R+0Rhd18zYFSvsCEERp6iA==
X-Google-Smtp-Source: AMsMyM7QSOPHgH1HzsMpetlXtet8fhrPzU7Fp5FnD4HjiTTq1nkptf1jD3guHJXHhlcmMMI/F0PXzi6A7FgFAIWxGaM=
X-Received: by 2002:a5b:142:0:b0:6c4:8a9:e4d2 with SMTP id c2-20020a5b0142000000b006c408a9e4d2mr1093482ybp.164.1668008815284;
 Wed, 09 Nov 2022 07:46:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221108133328.351887714@linuxfoundation.org>
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Nov 2022 21:16:44 +0530
Message-ID: <CA+G9fYudWjUPHjsQG-Fhc=DoxeEfg2+5ZOS4rAFktTcZ-G_hfg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/40] 4.14.299-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Nov 2022 at 19:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.299 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.299-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.299-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 85bb1cff28dd862a007c7d7eaada3e4f669566e2
* git describe: v4.14.298-41-g85bb1cff28dd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.298-41-g85bb1cff28dd

## Test Regressions (compared to v4.14.297)

## Metric Regressions (compared to v4.14.297)

## Test Fixes (compared to v4.14.297)

## Metric Fixes (compared to v4.14.297)

## Test result summary
total: 111619, pass: 93601, fail: 1960, skip: 15138, xfail: 920

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 308 passed, 5 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 51 total, 50 passed, 1 failed

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
