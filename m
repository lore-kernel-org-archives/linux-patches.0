Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56965185B48
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 11:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726053283; cv=none; b=GXauC/NrT7sKtGmbBwYdPf72pGF7oWW3dmPsG4MMHZ2jP4Z37GIgTbRT4WUt8E6Ul4yc+sIow6cDsYCGCVXRy/82v3NMMyJ4p5DuBHrENMb02rodqrlbtu0icfHCjBnYdpouVj4jOPVDu+ZsR+0xAc9RaZvxpIs2Mpu7VVSevuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726053283; c=relaxed/simple;
	bh=eLZ7w7cowPa3hhjddGdA8bWcU9jM6WNWngJVkRAKwMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=roe3OkJmHLEkD5JKE/BcYJfsSV5wuGJuWUivSZRXaEsd8On6z1TrNN8B2yuSpl8nKTCMr2wLdhYK/K6hUJORafy65OyVeJ+iIsVQeekU/H14k8dCkYqIJK7Q0fGV17wkZeUJxDYqmAUcQ7lFkpJlrxyiCW4PlMu3ZQHzHShZscg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PqTWdCcp; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PqTWdCcp"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-502c0ffd07cso1135817e0c.0
        for <patches@lists.linux.dev>; Wed, 11 Sep 2024 04:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726053280; x=1726658080; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbxD6Wjz+v5CvHgK6ct9WCz155k6N2RRxLxKsD63LvI=;
        b=PqTWdCcpXFKNSNy5UPIKv/8SR4xdd9Uq8Q4tFq8tqIEqNKwnkkzSMlldSYYoCxsQUc
         gxrgPf4qKd7QEcimoM6lnB9EHWoLRw0n4S7Gjne+fh6gXlxMMxsguUMEOD3+dj3DPN79
         F4/ndrwU6DHfCnLhtO1Oqn/9RMyMfRU/BHwiW9wnlnurSpzk+t2o7V8Ju100ndwEduLE
         0+2kWQ5tKM/QSGzFsi7oHVj4ZMdn3YGM6A/SD/WDJs29mRaMJw5VH0ScESjnN/9Y80H+
         r5dTZQEMKZw04c55PjMNM+SHYHskEjLwCVD76nrABOPWDv+04Hk2UB0yd0sznKsoFWJ0
         l65A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726053280; x=1726658080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbxD6Wjz+v5CvHgK6ct9WCz155k6N2RRxLxKsD63LvI=;
        b=cvx1e5j3Jp7cStec/EMiu/ZQx7JVgFG/MmI3hajgEyzr8S/R/9UwX00bDTaeihv7U2
         JsbP8yBs9oe9LkFb88NznugbQmg/5Toe9QlEbV+DypphsoGtKq1Y3wUHKF27dyDqV/D7
         bZCHsoIVHuZsyxhLVEEy78ZBk/F87Pil+ek6tcp9TFFSSHWatEyjmsMpXmxyl7kEGDkd
         +BdKHHSdfL7c1IF7pAZ4TyHHQ3MijeezNxMQk1ec65HZyx2jRIzkjakrgELUWIaFXaIm
         j+6n7GaeMLvP73+MIW1gwHgDknt4J9Na2RkldWL1CyzZJjoRGE5nro0oB0w0z4OiSzXt
         g3Wg==
X-Forwarded-Encrypted: i=1; AJvYcCV9bsKRX+SClbplf/xzZnSe/54rWmPiEudvvzMsAecCg3gE5Pi8jazjrG+oGOhyKojKd11Pb2UW@lists.linux.dev
X-Gm-Message-State: AOJu0Yx16O1bj29S1b7tL5BGbkt2HBmefzC+6Sz9WLfxOh/Gx+fxMliw
	v54RCrB+MpqpCaXSWRoIJxhS2gU3gDYiDVqPBshUP9r0r7nSQ40IGUDUu9nXLU4KIjkGAhNQrUj
	R5WzHli7MHu+RlPbXQbczdvaJ3uMcTJLmka20Lg==
X-Google-Smtp-Source: AGHT+IGJdmdDESJ2hyYLx3bgpfboZD9Buso5h41DrgJJgM3cqrVacNQh8sevxkDEFVdgEIxpTzITdrKLs4m4zvYwZhE=
X-Received: by 2002:a05:6122:2021:b0:4fc:da8f:c8c4 with SMTP id
 71dfb90a1353d-5022146e600mr18116038e0c.12.1726053280241; Wed, 11 Sep 2024
 04:14:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240910092558.714365667@linuxfoundation.org>
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 11 Sep 2024 16:44:27 +0530
Message-ID: <CA+G9fYstZOHMFx9OHTseUTpXEZtRMSEujTMT+frbdSzQmm++jw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/214] 5.15.167-rc1 review
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

On Tue, 10 Sept 2024 at 15:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.167 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.167-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.167-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 72253b6b4643a28e11448f1ee2d2f0fbda027130
* git describe: v5.15.166-215-g72253b6b4643
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.166-215-g72253b6b4643

## Test Regressions (compared to v5.15.165-216-g36422b23d6d0)

## Metric Regressions (compared to v5.15.165-216-g36422b23d6d0)

## Test Fixes (compared to v5.15.165-216-g36422b23d6d0)

## Metric Fixes (compared to v5.15.165-216-g36422b23d6d0)

## Test result summary
total: 278874, pass: 232368, fail: 5633, skip: 40510, xfail: 363

## Build Summary
* arc: 15 total, 15 passed, 0 failed
* arm: 306 total, 306 passed, 0 failed
* arm64: 87 total, 87 passed, 0 failed
* i386: 69 total, 69 passed, 0 failed
* mips: 66 total, 66 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 72 total, 72 passed, 0 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 27 total, 27 passed, 0 failed
* sh: 30 total, 30 passed, 0 failed
* sparc: 18 total, 18 passed, 0 failed
* x86_64: 75 total, 75 passed, 0 failed

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
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
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
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
