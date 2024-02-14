Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B9614ABC
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 09:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707904770; cv=none; b=jGYVMGz/XANhMOtwxHhoAP1uxr34q1vlqGP4+qAhkqsHjhitByRl5uTYi9jYi/f3pmI3eOR/l8cszCf3Yfy1AFuYAVA8+LHk5lx0P20weC0KttbPpSHteQu+hvY5bDDqxQw7Eg+Y7LQuWTk2JhG/Fkjd6Rljapx4HkHvMcrZCOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707904770; c=relaxed/simple;
	bh=gVm+T16jcvQM4Y1wUhuHUjRQ2X5j5IjaP/OVPSsMexc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eePBcEO7ovKi6RpqmLvTJvOHNhztfyLtKLBpreIEz6uF6cjaJfLkc09cAXtcUZyygW1rFPmdhseN34NBMxPFNKqqrUrvkmlKkOC9FxEnpaL0T2CmCOH5f5A/H5kzwyJdp1DPA5QGc8tGotjQEkJ+X6Tw4DIWBIu+YUCtFcsfjjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sC4D/bsv; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sC4D/bsv"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-4c01a5e85e8so585786e0c.1
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 01:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707904766; x=1708509566; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAHtwofM8Ywhu0ktwJwjy0wlIStiFxtTZO9UUIXRgew=;
        b=sC4D/bsvGE7HaE1i1TqY7ahSSlp24joHUSrPRgvLEbODNUDq+T/fN6L5sLjuPrWS6u
         6Fvw5cUyXY2EOLw1MACTPV4DOkzf1btrCL31c2OzZTH6IunGk9iN4hacgRq7foG+fgxu
         5paG1LxrhnlDoVLzsqckpYmjhTOfwhk/n3qlgYs02USrVaMB3Qv7SOdcGxWmhHI2CWvf
         tr1NLTq3MPvQl3UV4ulbHr9E3KoS2WQsl7tbeZlMD1HiTAYfU1LaiBVF/oP/fT+tjQMe
         aXuILAoLZEijGGB2dVR1Mew+OfBFJS2OGL6o9ooROB7Ny930c+aFpKeDpXik+ZJv1pE/
         ldXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707904766; x=1708509566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lAHtwofM8Ywhu0ktwJwjy0wlIStiFxtTZO9UUIXRgew=;
        b=tCNgq3ZY9uyHhKrCt9N+axYacLHk8GJN+eqF97xEMdggTALJl1rVdQwTv6URQxtpGs
         9jyxz68m3tUsO7Y9vDkYpnx1NWovCUjDqN8rV6DuyXdKzQE95a4raspNq2ZrFRYUcPJF
         Jy19GsfwHVQ5lu5DfDD7KLeinvnU9BFdoHmP+sEI8KhOVvk1IuYocD9bW534TphOl0lz
         dgNLb047QyqU/Q21XBsMqGUFnT2Mub/PXra4X1uWKs9oZHu5GOawW/gAoEv/ACm1WeiZ
         /N79XGhLuGPQltMlE4g+jZiJ+pZhaeg2FBcEN9CzuKMyJfGuV8+GNJ709qSqc6poO0tj
         0dww==
X-Forwarded-Encrypted: i=1; AJvYcCW9USIg6ifTbGkEA0tL8jZTBTDqGnqHnCmQR1x6PNtVKbInC/fB1YSqLiqXTVwynkivUb4rF+0cNQ1V/WRVh6B9h+H5TakWVA==
X-Gm-Message-State: AOJu0YwnheFcZgmlnStIFRzuLbIyat0zxMfeXIxdzhDdhQfFNUMPl2Yu
	3PfWyTg3d0B3rGPplk1OCrMFJBKdfjHvNWVPdiUnAyIsjKbaTx3ektkTNU64NKe9wufAxYpMKOc
	8ZDnTPebWbJSno4oOP7vpZL/zBlnPYVNj/uHMLg==
X-Google-Smtp-Source: AGHT+IFBeVupttWDvF/dg4Ea3WjE172cD27Ig5hKgGkV3ufkWk1COS12cpNX0UcUAM1xEvEs6xqsQ5mtiODTpi5teZU=
X-Received: by 2002:a1f:e602:0:b0:4c0:3621:7ab0 with SMTP id
 d2-20020a1fe602000000b004c036217ab0mr1996869vkh.15.1707904766341; Wed, 14 Feb
 2024 01:59:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240213171853.722912593@linuxfoundation.org>
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 14 Feb 2024 15:29:14 +0530
Message-ID: <CA+G9fYupuO5kZm6ZWOUMSD8=RgeFiGQhZQ_Frfd+1V4X5q5EKw@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/124] 6.7.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Feb 2024 at 23:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.7.5 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.7.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.7.5-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.7.y
* git commit: 93a4df567f730b1297234a01ec53517a02cbe64e
* git describe: v6.7.4-125-g93a4df567f73
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.7.y/build/v6.7.4=
-125-g93a4df567f73

## Test Regressions (compared to v6.7.4)

## Metric Regressions (compared to v6.7.4)

## Test Fixes (compared to v6.7.4)

## Metric Fixes (compared to v6.7.4)

## Test result summary
total: 146978, pass: 127001, fail: 2214, skip: 17594, xfail: 169

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 129 passed, 16 failed
* arm64: 52 total, 46 passed, 6 failed
* i386: 41 total, 40 passed, 1 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 12 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 45 passed, 1 failed

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
* kselftest-x86
* kselftest-zram
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
* network-basic-tests
* perf
* rcutorture
* timesync-off
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
