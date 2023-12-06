Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32795315AF
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 11:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pbPdhDsM"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-7c55a04cd9eso2185547241.0
        for <patches@lists.linux.dev>; Wed, 06 Dec 2023 03:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701862685; x=1702467485; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vqiXsfY2To4PHI6eJQCHduTSebcEXd5uADmfhHEO5xo=;
        b=pbPdhDsMTxQ37rxwPViDENwH2+ClS1LWPBhTvU17c0L8BKjq/WPNl81JFt97pLY+01
         lxDcWR276TzDoxwiI5cny3Ug7Tz3HHWd+ZgAw4cA+eo4jQ0OOZ529q1l8vI70nKkgRr5
         fBsjXrVf1PQzHPOy4/b2U7eb6oDumTjQ6QzhNqnScL5t6LRqPth+/6wIa8ixuyF9Jhdv
         ZF4c33VL+JEIyARsm4mMykB8xrTRmrXg5Xc1JYH+4pmyAfEcOOKNsgLbv3wfOq1aBEtT
         hPvr8BppCMvIvubpx7tkldIMGyFwIJzNjimj+1sYOEojSC52yKcWUEocVSas4hox3C1M
         n4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701862685; x=1702467485;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vqiXsfY2To4PHI6eJQCHduTSebcEXd5uADmfhHEO5xo=;
        b=uf+iQWZsNrJ3zEuhluVo76i5LHMQdeCWxnzWZTzj5TyXhtFOQmxvPjg78HeIKJP4d0
         pG/FR6lqaCJ3mpYLyxMQLu7WwH/QMXdmmW8BVEOfeK05Fo7POHssWDshgayImYpo6//r
         vGoBIyOwWExEQSEmPtf3JGKDIEaf6Q4G9odbrsAgtzTtOqGuPrJUQfuJ3W/8Oo7jaZEE
         Ox5UPfSpgGgwVjVqoS9T9LIbe2f1V2wuOpd2SXUkAaSFRojLWpwZ65qyfAPCJTj6UGdD
         CWaO4Jsgb0CC0GRppoW8HxRRVSwOZJuZRbNPeG3+sSugOc2/jeDoycZPNMjiHVKHmmKk
         allg==
X-Gm-Message-State: AOJu0YxJxNYZ5YkG7pslNKJCaoGjETqGiiJ/VejmCfbhDimIYY+pQQTh
	piXfLzHW8EBIrG2m9p6rfvrWUZE6yvzwuA4z9SQdsg==
X-Google-Smtp-Source: AGHT+IHourNTb7WMH0K3D31guA9V35xLG/P7Tn9mTPPu0kJQ1+4eDDR2yXdz5EU4bC5uAzOSV87KWRPhW1gtjYwiyX8=
X-Received: by 2002:a67:ee1b:0:b0:464:7f57:b474 with SMTP id
 f27-20020a67ee1b000000b004647f57b474mr567721vsp.19.1701862685076; Wed, 06 Dec
 2023 03:38:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205183249.651714114@linuxfoundation.org>
In-Reply-To: <20231205183249.651714114@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Dec 2023 17:07:53 +0530
Message-ID: <CA+G9fYsQLS9sksdRLphmSJ+K7bYDsdiq--xe+eivsOfAeM2Oxg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/131] 5.10.203-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 6 Dec 2023 at 00:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.203 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.203-rc3.gz
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
* kernel: 5.10.203-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 3e5897d7b3637fe06435b1b778ed77c76ef7612d
* git describe: v5.10.202-132-g3e5897d7b363
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.202-132-g3e5897d7b363

## Test Regressions (compared to v5.10.202)

## Metric Regressions (compared to v5.10.202)

## Test Fixes (compared to v5.10.202)

## Metric Fixes (compared to v5.10.202)

## Test result summary
total: 86943, pass: 67634, fail: 3147, skip: 16110, xfail: 52

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 44 total, 43 passed, 1 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 25 total, 25 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* boot
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
* kselftest-filesystems-epoll
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
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timens
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
* libgpiod
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
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
