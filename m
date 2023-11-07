Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A408E328BC
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 18:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p0LVYec6"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4ac3083ca04so1387982e0c.1
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 10:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699381606; x=1699986406; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KXV1p3zsKYtWAQQYSZiCkScz7P33fi2+JtuHXVpT4Y=;
        b=p0LVYec6rU39psvAfUEMeNenGV86R6otm/8TV3DaE7Lk0kKJu0cVl4XyViTW3dZo5A
         EKL78N1aBxYywO7UdRLsKyXUIXjL0nvASVH4KgSmxnmhwN9lJ1hqZxVMWAyhtdzC31zC
         9rswbbjWifzx9K2uF7jeAbPdsE3zrvZEi/+Psu0iXI1SAOa223YmdKVdO1nDJbX6g7RY
         /ceY2xWPF9LVqAC10Wv2dYqLsS15+H7/PDaf9xKIFH9/qLb7aKxB+tQSQj8oTxuyH5Ri
         0QJmmDCpLE2XUrlpfPOa1+XSluNGREJRGnUN1+NcG0rInD559d7dgJuZ/u3T/+NLs0mG
         JyMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699381606; x=1699986406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7KXV1p3zsKYtWAQQYSZiCkScz7P33fi2+JtuHXVpT4Y=;
        b=N/7XMuZ05mhyoAGdjTNFhCb7F6Rrm0s9sXtXkw4uhbXhdWddjUcxqDQqKMOAgVQfAW
         8Da2vBTC5rOryFy50w4MFGYgneWHk3hIWbJqjpvn0wegS30eg3cihstqCoYWsj/z5khr
         I26hE0TiJyDaaIiiuUzDyjs2CXdU+V4KM8NLf0qxvNoWSTRtcuWt2Yg/FF86Omz50kXe
         WyB80D0SxdAzynXU4FypriHgxOpwe6yl4J0AIdtj/t1tpGsNb6wTwg6YqoT4zyMn7+KI
         LeTuZ3DXeeQk+r8j88HqM9WMr+diK+a5dMLv25GJ+Bs8/Em+KEwt4W/wlViBNmqtGu4F
         5gPQ==
X-Gm-Message-State: AOJu0Yw681M1shigew/0kSGp6AXmBU685n3jPRn83aKymfxukjSCb+rm
	MnsN6f0SIEhnmSUhYYfRimqijBvvyLMyCvI39WFSfg==
X-Google-Smtp-Source: AGHT+IHvAWUWkPDxuN5004b/0EeB57kSIgWAUM6P92bqaZVZjRDrF30NX/Wqmm0/cwN6Q8YZyNieb7M2NmxBn9Xgc9c=
X-Received: by 2002:a05:6102:5a:b0:45e:f983:7072 with SMTP id
 k26-20020a056102005a00b0045ef9837072mr8072949vsp.31.1699381606390; Tue, 07
 Nov 2023 10:26:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106130301.687882731@linuxfoundation.org>
In-Reply-To: <20231106130301.687882731@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 7 Nov 2023 23:56:35 +0530
Message-ID: <CA+G9fYueD6h+sijhY-tP2DDhTtkjF53cYpypFpeBpHr=fhnRXw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/74] 5.4.260-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Nov 2023 at 18:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.260 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.260-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.260-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: ca21f12ba7d859ae3203525ac055a1882383b1b9
* git describe: v5.4.259-75-gca21f12ba7d8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
59-75-gca21f12ba7d8

## Test Regressions (compared to v5.4.259)

## Metric Regressions (compared to v5.4.259)

## Test Fixes (compared to v5.4.259)

## Metric Fixes (compared to v5.4.259)

## Test result summary
total: 88180, pass: 69717, fail: 2382, skip: 16037, xfail: 44

## Build Summary
* arc: 4 total, 4 passed, 0 failed
* arm: 147 total, 147 passed, 0 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 29 total, 23 passed, 6 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 32 total, 32 passed, 0 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
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

--
Linaro LKFT
https://lkft.linaro.org
