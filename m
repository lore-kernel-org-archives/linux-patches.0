Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB3E405F2
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 20:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wb1Bn3BX"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3b843b61d8aso2824509b6e.0
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 12:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701116440; x=1701721240; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t2NzrYRK1cQA6Nbs9R7f/RggIIXUG+CxAVQnblSzuic=;
        b=wb1Bn3BXtbq0Xjauea3cP6eP7M5UaVjyL2hzUWheAXgRVhRmXlwA+X3wrOyS5Dx0uf
         B7yH8WdKTNYcF+jM5hEx1bF4teS/XyyTvETdlx7wWH9O552pD2yQQTftlwde6fBH6JCk
         ugH4pKVEYDI0/tkPcurlENREzgaQbrDNeKFeN2FOe4sNopKdxmiCxroaV+2eaU6IJhws
         cAqGSxi/7ykSy62CR10xVN3ISnZgsmctE8gLiS8oa42RH1+DIP+tRT6EhxpJugYtoK15
         6kvCy7A+fBffd+WlfYJvKWghSeCilwMlok18RiCoIrbuoexNazK0F7dh6Ium4K8E67By
         jQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701116440; x=1701721240;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t2NzrYRK1cQA6Nbs9R7f/RggIIXUG+CxAVQnblSzuic=;
        b=QUL6UDF2qqIKdvfrvMEMspiojE0aBt/NpZTiqlyX9ADLTvlnotbD/Q5iHSp7lcVhH1
         x1C/LdQ3GEdEOdkDnwm41OxN9m5XRaWSqq/dG4sjlCQsg9oSAIHdJG//zqhidfIfAFwA
         AJMbw3b6U+Lj7KJog2rdJhhxp3LcyM+e4k9fHLBz1C9HPIm+QK72+Nik81+ugBzLZYLg
         KBS2+C2ujHA6VFJcERokkWCcWiBLIvPxGYeaA2ltjUMOnhKGwKAE85iqCm5eerMvgpsm
         KaWrqgceSg8WYC/tAdcFl/oxuinBKN+rDJYeIXY7eSMr9tFqV4XPlYcS0LhLBQHQ2ZyA
         cnfQ==
X-Gm-Message-State: AOJu0YzRXyX+5zuX1GBVwpVpnLhcifhl5O1XzygziRzKUz/unTr2Xxih
	2UGjt5XVcIgHQZ9XHu6JSfatR69oBdOR1YZbqXr/5g==
X-Google-Smtp-Source: AGHT+IGCPBUooJKVCZtpXckqJRhyldpmsmzNHObiJ7d5EWHZTZ3D4Yz+OG5FjDn4UO/qTEspQc7WDWbp+OX9rAfFaBU=
X-Received: by 2002:a05:6358:71cd:b0:16d:fb2b:d0e3 with SMTP id
 u13-20020a05635871cd00b0016dfb2bd0e3mr15576067rwu.1.1701116439646; Mon, 27
 Nov 2023 12:20:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231126154323.146332656@linuxfoundation.org>
In-Reply-To: <20231126154323.146332656@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 28 Nov 2023 01:50:28 +0530
Message-ID: <CA+G9fYtitr-n-H+q28LRBs0tpuS8aksVHNoD1L54M98=FedyZw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/92] 4.19.300-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Sun, 26 Nov 2023 at 21:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.300 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.300-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.300-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: c66845304b4632f778a17e0056b8df432123907f
* git describe: v4.19.299-93-gc66845304b46
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.299-93-gc66845304b46

## Test Regressions (compared to v4.19.299)

## Metric Regressions (compared to v4.19.299)

## Test Fixes (compared to v4.19.299)

## Metric Fixes (compared to v4.19.299)

## Test result summary
total: 51623, pass: 44853, fail: 854, skip: 5883, xfail: 33

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 111 total, 105 passed, 6 failed
* arm64: 37 total, 32 passed, 5 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 20 total, 20 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 26 passed, 5 failed

## Test suites summary
* boot
* kselftest-android
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
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
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
* kselftest-user
* kselftest-vm
* kselftest-zram
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
