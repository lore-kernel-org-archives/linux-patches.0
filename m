Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F0242067
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 05:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721281381; cv=none; b=dvr4j0a+081VnC9zyRBexxEJsrKZEJwxGTA6L2vJKnyBB9uIsSBFhfd+crPloVSJm0xCJ3BM5PReyk10yh+S0LZGdfTSaToDUgdEpf8EtALEUuSw6K5H/eEpGP3GU9efG9ef95QGskGHTGwe98eNVvWcNRlmr8Fn+sjt6KvcLfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721281381; c=relaxed/simple;
	bh=r3xnGagx4ZthBzuU0hwQn+oAgPu79TSzpYSUUD05+9Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eJl7XenyiQ/NridNBkOOIKAzBL3zo2lELxsyoeW6iogRRcE+kpfF+p7WiVHFmtDmjiv7Isced8m/Ay0VlDpa0e7h0XORgGU1cFY0HteLZD+2Y8ZbRe5GVUrcLa0cDOL9NLDW9HLzpYWWZWHhtbpe7Q71WMon0l7uNaXlM5hxaSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SgiB8dgX; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SgiB8dgX"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-81061d00c0eso122178241.1
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 22:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721281378; x=1721886178; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YtOloMrdbyKRqwgvMAtslxCxX95F2NZOqbDgAe7suXs=;
        b=SgiB8dgX228PnbbNu5R4gFUnF9yXdQv39yOA95xMtSzQkyIcGDwYcUp34qdu6bMPHg
         cUuLEUTEPGA8i5Sdkz9yXStxXCBbrUJItrNEZ8kg45ReIpUZefjjK7poFQ8EpGfC1Xlj
         mYP2besN3cclBdZk/U4kncmnE3qnubzVe9LTGs+zFMB0DD0B5uUI1CLzjAU7wT8AJr2v
         vWRWYISgqfqgOeDSPnU3O3iqt7xhmOTkihZHC3MAs0gs9A5yOQfZmukEJX2fI4bVedu2
         NCC+TNURtks7vNAkNNG+n9ga0mb8FRQ2X+cWSM5uyuOug5qbImoyiyvPPTsFrYzwPSuy
         DPjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721281378; x=1721886178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YtOloMrdbyKRqwgvMAtslxCxX95F2NZOqbDgAe7suXs=;
        b=PhrK+mPE24Nue12iG1MKZ0r9hUsIZgT6ZhDizY97dOGhcwMbVmYM6IlRbltsyx4KAo
         lFKhcG8XYnxIg0C4n1GSv/pdIi+LpB27n+IrC8VQEHiPaUYO43nwA7Enz887uAcH5vMQ
         9vy1Wh6zUDeqxRJnzvaKdIYi57eSsK+EqEwzk2hkrkCopkb3FaeNPeTg7U8mckmLKukz
         kGOQ17HR8L+C+4VI6B/a+cXq8dH+Aa2UN9AL51F2R0l5bUdvzcsgTN9hVTB51as19jm1
         j8nFUgk8ywmgnw/lPN7RNWJ7xO1ZxTOnLuYYSRLl59547NFh1+eCNAEJgjptQYSnjC5Q
         lJyA==
X-Forwarded-Encrypted: i=1; AJvYcCW7vvIKUH9HTs+ywdbRBXYVzoR7x0sTHJJUga8xpO1skCqpJToJO96ucMbZUbnLxRYnU4oC4x4m5S7tyaYWbY8XH4Ftl4+tpQ==
X-Gm-Message-State: AOJu0YyutB4ClcsHLeMzhFiJJfz67c49LGXNPIQIpLMEheDqdjHOXqnh
	ojb6mgxOynM92sXjhI2JRMLIwvWe3kURVk7xPoM45YdXl94rmGZMwX+lxuyWrgqEb9rfyyKOlG/
	MwxvBNSilIpIePm/HnzyAp4drz3HXjz13g9vbaA==
X-Google-Smtp-Source: AGHT+IHo48/VuA6FA9O3qJYr3auC1eNUX38955i0sshhbnmGFehMSpwIFcP0A8sEQi8qZL3ZFWo9Eqff6B5AEaQW5HA=
X-Received: by 2002:a05:6102:149d:b0:48f:ea84:4837 with SMTP id
 ada2fe7eead31-491598b5136mr5536906137.9.1721281377998; Wed, 17 Jul 2024
 22:42:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717063752.619384275@linuxfoundation.org>
In-Reply-To: <20240717063752.619384275@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 18 Jul 2024 11:12:46 +0530
Message-ID: <CA+G9fYsf5d4H0Tme9D+aqAchpHo_8Yzq7EB0xZWb2CUbNByCHA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/79] 5.4.280-rc2 review
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

On Wed, 17 Jul 2024 at 12:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.280 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.280-rc2.gz
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
* kernel: 5.4.280-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 4fb5a81f104646353fb38c79e16e02395338a782
* git describe: v5.4.279-80-g4fb5a81f1046
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
79-80-g4fb5a81f1046

## Test Regressions (compared to v5.4.278-184-geee0f6627f74)

## Metric Regressions (compared to v5.4.278-184-geee0f6627f74)

## Test Fixes (compared to v5.4.278-184-geee0f6627f74)

## Metric Fixes (compared to v5.4.278-184-geee0f6627f74)

## Test result summary
total: 97896, pass: 78819, fail: 1682, skip: 17324, xfail: 71

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 132 total, 132 passed, 0 failed
* arm64: 33 total, 31 passed, 2 failed
* i386: 21 total, 15 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 28 total, 28 passed, 0 failed

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
