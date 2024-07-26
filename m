Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60EE17D360
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722015320; cv=none; b=sJT1P9WNP28Z+fWC4TvjcUnZWGm4G2jeic6LUHiCjZ7JYoXHlIDmLZVvNSwJFYOQuSQrdD9xywvhgDdifCyJMDxkVeKOQynSyNxgURsKhZIAcAYbIC/yhi1xnGlVEHtZBHs5lBRD6+fcb1xEnIu2XYePs9wZRb1+OuFWOE8Vaz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722015320; c=relaxed/simple;
	bh=umFRODgqfL2wwFCbNOhhOUXnZ3p5JF/AfwUxGRT2PwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nyPm4spmuR4PHy56a78IskG+kK6/O648pkNxQ+Ni1557cbCaIAsdJ+btn7GgCsET3kUPQrcGD+6qTmz9Z57CpH/KQNYWF/uRzo8RQd6jGBusramyCuWvIKgYO16MVwbKYbbhI7vxBU0Nc7+t+Xo1/DISH7qbPdUtMqW15LnoJ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GdXvTuH0; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GdXvTuH0"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-492959b906eso792862137.0
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 10:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722015317; x=1722620117; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rmt7Th55qF8UK1cZPsKKvc1veoEjIw9kwV6u+0sda0s=;
        b=GdXvTuH0qp1QwcV6jNvkrYDYgktWFIkSrcBv2Qchl/tRDlm+n0S4ATW7VXKLZeqeHq
         7TInd552pG1NdLXYOq/HiUMcDchke+/AP2zxbdMjhY4CVgB6x6Xsf5L4/vR1YjiR2rR/
         3DHPK3aAJtBayVdWjDVQE1O6HCV9PWDKWojU84FqAYp2v7L0R7jd6RrPKr+kETWadpqV
         ci5UZeIkFkrULbYqACWCURCYZ/UozW0MUR5N1TWwXBx0vgoXV2/gZ1K77CmFMK3viHkt
         XuNR+gokcX5s5ubijimbXeLlmIb2rXcEo0nQ3IwjIsyuMi4SA/cVuJvoc32UJkugmqMA
         pTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722015317; x=1722620117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rmt7Th55qF8UK1cZPsKKvc1veoEjIw9kwV6u+0sda0s=;
        b=RMTmesUDtMEV5/QHx5xCMEmMEH1vxcwd9eWzDc7+JO50ZjqdpZULklpc+Fm0Xvd82D
         QW59KvWEmxqpu838QXvdu4qL1nasInmfL3WggK7IRyMdV0nleTXN7nK6e7kJ08VKRNIE
         U9Ssc+19zI1K17j5lmwcf1TboXGZd23PGSfnEnx90ATg5F33czzyD/VYqQq/ZT5i2V/1
         FDJwTUN4uGZHC0gfzSA8zacYssRf/TRBMYDcQ3mG97ugsg2cmApg9dKJ9ueGtRZ/sKRG
         Zq8Tg1IOcuj4Jbj7MzXF1zGQiguQ6u+QPUgu8M5nFzengSaUwckzhctC8xa5/6KPMYCR
         Xs+w==
X-Forwarded-Encrypted: i=1; AJvYcCXSYbzjgZCqCfQ8++59vp1RVVeLqI6TytsKpZtshAVU9JJwq3V146XodSwLyst8AgfIuMJZQm0QbnafkxXhw4zNvv2h3xWyaA==
X-Gm-Message-State: AOJu0YwQ7pyuRKlbQ8YijttaRb8QZGzXZpUGnmTXD/N8qqXSz90/CnxF
	AHBH2/dGQknZ2zMfRouZd+VpiFLEU395Ual+RcbhXlgK4k1OxqayLgNduk2RD4ArwTK7N+TduYT
	jkOuGbVcHTbShfHwv/MI/2V7OfZJwca/xoI3sAg==
X-Google-Smtp-Source: AGHT+IEvmTlba4BH+71ZAButXHtz6N8ddRW1U+8AFcX9FeDtloChwP1hzISXt1SxmhhiWmEj5zsaz2PxoEseY5I7yzU=
X-Received: by 2002:a05:6102:c12:b0:493:e66f:6bac with SMTP id
 ada2fe7eead31-493fa81b6e8mr507454137.11.1722015316653; Fri, 26 Jul 2024
 10:35:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725142728.029052310@linuxfoundation.org>
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 26 Jul 2024 23:05:05 +0530
Message-ID: <CA+G9fYu_mdKF5hF3q=nENbLRGcsn=ZSYErHXcd-SY=Ow9TvXPg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/13] 6.1.102-rc1 review
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

On Thu, 25 Jul 2024 at 20:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.102 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.102-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.102-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: dc0e6d516f8a1f3321312ba50a0750559f9dc526
* git describe: v6.1.101-14-gdc0e6d516f8a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
01-14-gdc0e6d516f8a

## Test Regressions (compared to v6.1.100-106-gef20ea3e5a9f)

## Metric Regressions (compared to v6.1.100-106-gef20ea3e5a9f)

## Test Fixes (compared to v6.1.100-106-gef20ea3e5a9f)

## Metric Fixes (compared to v6.1.100-106-gef20ea3e5a9f)

## Test result summary
total: 47994, pass: 37873, fail: 907, skip: 9174, xfail: 40

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* boot
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-kcmp
* kselftest-kvm
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-net
* kselftest-openat2
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kunit
* libgpiod
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
