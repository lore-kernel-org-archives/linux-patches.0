Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E09183063
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 06:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723098077; cv=none; b=p1YmCY/LNV+2j/nWdrHL314Nj7Fgl9shbH5oUGfV3KS4NSadG9ycDNHJ6REge664/VLPpm6SxIj1sqLtnWrlYyo9HqVbEImeKG95Z1wwHOIBxTDUI+cyp8U/A67ungXHkSqhnIgce7wqO1rXqCw58HtpXopTwVcCblTxo7PXqY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723098077; c=relaxed/simple;
	bh=V7Nu2/ZOQOgFQOgbJi83OYAm3jyTziBatBEifZmB0Yc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EzW4fKeLcYiRM6hmn9toMC/kq1quLlUr+3jmIjSust129EpD+GHSU4I+XtsWhpCHO1Ri1vciji72wNt5sCExutcgBEPzwd0cMoZr9CAlFzvJV84oCr7movifNN+TupoKsiufZdWnhSyXU0BkNCzNTOz//M2FkoY3sHVztj//fuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ONzhrtmA; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ONzhrtmA"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6b795574f9dso3931546d6.0
        for <patches@lists.linux.dev>; Wed, 07 Aug 2024 23:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723098074; x=1723702874; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l5AswontD5tk+EsapM0JEEIt5oaBQZ21TTd0t8hYM3s=;
        b=ONzhrtmA6f30kBl7XjSif/XYkRc1FmUdRHzao3HxubahZzOW9a0fPPUA5ATE5zJiNL
         WDpThj1ArKV2GMg3b5egp9QwJkWia9xtpMnI3ATNlCcAOcxEDX3CMyGpkQmMzKFUJVBN
         hhWaPJ3RFh7udXWtrpi2njg4X3J6y5cua9Tcpb+Ayh0wotyLEVJQI3gLDEmxfkHjoZxx
         oEscXu+veevWoA8bCYacNXk83Q8xP9jVYUfURdyWsWkYv2VmF1L4C9usRWH4VOXYDEYT
         oDACGH8DmeEuvX7xcO5wMYtpGjZzLqqebolxfwE/tCUdAtoOCI1o208Z2N3a3+pN36XP
         qV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723098074; x=1723702874;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l5AswontD5tk+EsapM0JEEIt5oaBQZ21TTd0t8hYM3s=;
        b=nPT2NU7jJXbFCW5jrPYYx7NGl/iL9zjRgBvgmxFsv7C4B7VwMpuwf3OqFlmf+f66JT
         QRfl4+szE3LsWeLEe9PE/b+eHXvjJKITUfb0URVLxLa7VRoRs+1F0n7BI9PzQd9uomgn
         /HUIyPCIvUe4MgiSfXNgyMTIdaJNUAK+WFDmX6uqXrl4HU7L48tTwhjWax+KSQ6odtq0
         NkZ9RKAkXIW7Nl2I5vy46W9GNx/UhsgzgBeT1IPhw7LC3gWyRv/e8bBEXBVlQRFeWFz4
         VETXPIhUVwE/P1rh1sl2ZmDeWPCavr1cUx1ZhXR0welYbHysvsg3pxXSeMv7a/peBCe0
         jvgg==
X-Forwarded-Encrypted: i=1; AJvYcCXOHVYYpTOty8MjT5347noG0Cz71b2oghAprmcmjQLpkHmpqTRgFbzm4frtXLYaVcsKQwS4oNrreMhU1Rxmrv2TwdyjZEWL3A==
X-Gm-Message-State: AOJu0YzyqpPPukP27morriJ2kJYpy9xSskQyvccM2wB9J8JhThmJlq11
	ArE1OB296on7knF32NdmY5U1EZJKi8gng2OnPsM3T+CJu3nN306FlQ7aw3hCbFgCCKw46mxiXfg
	cYI+El8xO8W45Y0RCiHLdZgRHRdAIn1JXAs5Y8w==
X-Google-Smtp-Source: AGHT+IEZklhFPOddni0uWN5gwDIhwP5DBZkY/OQVLihWg66EVGvODni6waZMR/SeojT4IYuqP35xq7zDik4puesJWU0=
X-Received: by 2002:a05:6214:598a:b0:6bb:b4c1:646c with SMTP id
 6a1803df08f44-6bd6bcc6cddmr13156246d6.22.1723098074051; Wed, 07 Aug 2024
 23:21:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240807150019.412911622@linuxfoundation.org>
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Thu, 8 Aug 2024 08:21:03 +0200
Message-ID: <CADYN=9LVRXcvLU5nHcK5sw5_uHok41X3-HPznaetV4cE-SrkJQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/121] 6.6.45-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Aug 2024 at 17:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.45 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Aug 2024 14:59:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.45-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.45-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 272b28faf61f0b80e9d6f92cbcfa32817f9ece7b
* git describe: v6.6.44-122-g272b28faf61f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.44-122-g272b28faf61f

## Test Regressions (compared to v6.6.43-569-g7d0be44d622f)

## Metric Regressions (compared to v6.6.43-569-g7d0be44d622f)

## Test Fixes (compared to v6.6.43-569-g7d0be44d622f)

## Metric Fixes (compared to v6.6.43-569-g7d0be44d622f)

## Test result summary
total: 238058, pass: 205175, fail: 4074, skip: 28347, xfail: 462

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 127 total, 127 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* boot
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
