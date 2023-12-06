Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDDA28E15
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 13:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="R56sgNBE"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1fb37f25399so1946212fac.1
        for <patches@lists.linux.dev>; Wed, 06 Dec 2023 05:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701868629; x=1702473429; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nxVVrdBlmm59JQaj1tQrRYncz3o/xDnyNSt5IijI0ys=;
        b=R56sgNBEsu04QJ5vMs001ljL6rIB05rIODo5IDxLbf6pozsJdd5D94V+VtSKnkCMLr
         Kmoln88wr/6qkyr0QdkMLr1vr6iY9YbY/fzljaW/XxEZTn36zVC8wwVgDmu2eaAH46BF
         Ty1ghv8E09PlQ+qJW9wu8O2iKA4Jor+k3fqk+a9qhwMXbBz/kM4poiQWucPwggd61jWm
         LSBUaeZ4b3UXnyi6aR8eYEBYuRF7KW3erJTg706BCgf5VB632OwmhJNWwOK/toBCuMSq
         TmKOpZ/iRLPgbirq4XefLzerTJXgFLg1Y+V2p8vb5kwfQSNd6lzqMGRkrD9XmaMLJ9hA
         7tyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701868629; x=1702473429;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nxVVrdBlmm59JQaj1tQrRYncz3o/xDnyNSt5IijI0ys=;
        b=Y/ERV3JxqZ0rqLxT00NyuZACPALiBNp8bvqkiamwAc5vM7Yec67Pd0bRy9e115Az52
         90nGzGIkHH4NMEfa1B/hFQwyBdjd5HgdbnaT8c5e3xIbl4txIGvens2OJtQ8Qyq+OR4K
         wSgILSbDhTfmrzGn4u/pv6m8pI8/FOGSj5N/dSIcb8eMtOXSfDQcqf1OEljhzRqyIuUE
         GUGpuF4vmTzOVfQPoM1VH30yTpt4y4r1M6s+GcC/ksqwEwDvfE88neNAxNW7yBrDfb1j
         T+XOdUAcjdOp34jKFS2ToeKe0x27J3E5Nxwa28ffw/JRsbtA3sbee4p09lDfiUXLtCnG
         +UGw==
X-Gm-Message-State: AOJu0Yyyfb8CdkFL0ZGnJ6cFZVf5KbmIr8JMaRpVb6yyHDw+M5ouNfxj
	6mtH4FcT5CYz7l2bWY9d5xDxQ6pIk1dQR8vlKteN0A==
X-Google-Smtp-Source: AGHT+IEEMa1x8V2DyQnpeISuBHHmKLpaAiRXC7RZ+9Yn8EMDmGE8IlSDh5LMPNs8JlqfMe1L+cLaEP+jd11GHaSV8JM=
X-Received: by 2002:a05:6870:71cb:b0:1fa:f20f:de3e with SMTP id
 p11-20020a05687071cb00b001faf20fde3emr925186oag.54.1701868629446; Wed, 06 Dec
 2023 05:17:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205183236.587197010@linuxfoundation.org>
In-Reply-To: <20231205183236.587197010@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Dec 2023 18:46:58 +0530
Message-ID: <CA+G9fYt=B4NN=Qa5UcJKU7-wTj1xZHHgTOJcUU+0v=NYyF6Wdw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/63] 4.19.301-rc2 review
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
> This is the start of the stable review cycle for the 4.19.301 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.301-rc2.gz
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
* kernel: 4.19.301-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 58069964f7aefef236c6f95ab212d0da19c7a4c1
* git describe: v4.19.300-64-g58069964f7ae
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.300-64-g58069964f7ae

## Test Regressions (compared to v4.19.300)

## Metric Regressions (compared to v4.19.300)

## Test Fixes (compared to v4.19.300)

## Metric Fixes (compared to v4.19.300)

## Test result summary
total: 55181, pass: 46377, fail: 1610, skip: 7162, xfail: 32

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
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-watchdog
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
