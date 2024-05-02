Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E4A21A04
	for <patches@lists.linux.dev>; Thu,  2 May 2024 07:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714635533; cv=none; b=Ht4DbWfRNED+PxSNj8RKtmZgl4znjJZR7eD+9mt9H14CgOf6gqi10I7jEUm8HNZbNm3Whf+NC7jGqroRmmzCqB5xMfhGQ5lvZGW7vAOxEW36aBR/DmoqonwkXvupIUN0VHjS4rAVUCQtPD7mFM80Rc2tH2nR9XVSjbovyT/VmoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714635533; c=relaxed/simple;
	bh=ZRq/wv3Q/D7MfozoZ6kI8+huj26C6rzpsmkMBmsTlB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hBDwYnk/uWE1Kg9Mxj45PbxMl5B02EgaosBiFP6fbqYjU9P31RlzelDlsF8oyb9sIQEa2rSa0q0cQBd1ntqGbh/6ZzyUFUfdaL8fXLbjJmKhXDhCP+AoRHIeU6y8stWUnGsVKvKRvu5o39jzJKx5M0gxy282z76Px6MVHaqOFpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pEy1pc37; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pEy1pc37"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-7f16ec9798cso863600241.3
        for <patches@lists.linux.dev>; Thu, 02 May 2024 00:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714635531; x=1715240331; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9gKu9rH10ssNrFu1YAE+gIyQ9AxIDQwijoSSwpqBnts=;
        b=pEy1pc377nb3z0spxB1JzBHrw2pJZguoyWfj2UcEJSyeQaq6DvihOHv5cgD/Hy+s40
         +q7Dpa/KWa8pJQP3SL5CihdXD98QTPanUFqTRGA20GC8KgTOFpGnuXb870ICqLOEd57h
         3jFRi2kUgZbcUpAP7vNHYO8jViVLZvqvToJdbLYXiNDmW11HfB0LH4DOJHdSMh4qprhk
         GAoPM6IFSwUcZgd5TIIBdxq2XnmHSIGWEI3X7YqNJCzfi50eQIQ4gWfbsoQIvY1Y4EL7
         puH949yZmplgE3G2F7VLySRiJYu9fHWdjcCdrnNuDzdtP2iqXqplBoQu4tpGFBm9Lab4
         xZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714635531; x=1715240331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9gKu9rH10ssNrFu1YAE+gIyQ9AxIDQwijoSSwpqBnts=;
        b=wB6vimxs+GsCQYQxi1QW0m4/w1qmWhG11KhmJziJrRER0+euJ9LPJC0WG+S5bd1KRE
         LlQhFgZHh+k0ZVEEIJbN38WxRVk4FVCXX51uEQnMAoUkjSAPOlJtZ/VHpOlsLTijhIsi
         x/Qx6hTGhl2/2TZuTsHQyr79QIhE279LNMFCMFgyVuHviRJifOVmJFGY2Nv63DdHgY/k
         ddrVLc7iepuD44DyLSbrb6YakS4p2E96TAsX5UuOmM53Ks/d4oEycEXN7tmJKPq6FL+o
         I9K57pXLooNQL9aVFmOduax8i1Rw4eCMbAdslejwFiY2V1WVmfRgjCOtc22QyCEuirZB
         2Fyw==
X-Forwarded-Encrypted: i=1; AJvYcCV1eqQHMJnu6W/JAQorVk5IU9L735r5wlDeLt2Fzqx6PJkwRD9pmnxqfl6U/6VdXwm4XBR1twRxANoUYSJQcOLaxdZMkVLtLQ==
X-Gm-Message-State: AOJu0YzXsFUz/qyD94LHbVgl1pz8UKUZ5mt23ipIt7NMy4NrUqxUcv1P
	60wP63L3AVpohOhfW+4dQFVfJDMSwqSWypzN9pFEpLpVU953KE1yKHLSpOzIlDQGY3/dtLTUruQ
	JKi9qu8UZ10fJxHMJnUKnPQ/vS2v+oR6L34xkGA==
X-Google-Smtp-Source: AGHT+IGawJOdMBNjBvqeWFMmff2S/95Drr+AoqQWZc+2rNhKUWNrUsC16OO4+ymmP/tQQldwWLiszKL3kA96Jda8Q/Q=
X-Received: by 2002:a05:6122:2a45:b0:4d3:3878:a523 with SMTP id
 fx5-20020a0561222a4500b004d33878a523mr4927594vkb.12.1714635529283; Thu, 02
 May 2024 00:38:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240430134024.771744897@linuxfoundation.org>
In-Reply-To: <20240430134024.771744897@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 2 May 2024 13:08:37 +0530
Message-ID: <CA+G9fYsWVqKe=6AoDzo6gcLYWVnojmT0QFtcXw9T-WoQzr7eQw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/137] 5.10.216-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Apr 2024 at 19:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.216 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 May 2024 13:40:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.216-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.216-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 4d39cb0f1c9c5f76a76b47182cb4ae20fa4a9e0f
* git describe: v5.10.215-138-g4d39cb0f1c9c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.215-138-g4d39cb0f1c9c

## Test Regressions (compared to v5.10.213-237-gbbdc0ccf6f16)

## Metric Regressions (compared to v5.10.213-237-gbbdc0ccf6f16)

## Test Fixes (compared to v5.10.213-237-gbbdc0ccf6f16)

## Metric Fixes (compared to v5.10.213-237-gbbdc0ccf6f16)

## Test result summary
total: 96933, pass: 75646, fail: 3919, skip: 17306, xfail: 62

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 104 total, 104 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 23 total, 23 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

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
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
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
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
