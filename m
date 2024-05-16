Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8150D4501A
	for <patches@lists.linux.dev>; Thu, 16 May 2024 07:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715845318; cv=none; b=u7nWxL5NkFTPHMVp+g7XSGBkBfq9bs31AMr1P5znqfqTtEbeo9YbvsvxMogyEmGccQQlf7aT6hGIJgcHah9xjrPf9zABPzp1EXXpwpa7d6IdpmkeFYI8HDQAJALWAdHouVt0sH64kRh6gf4RNnlwygDVPUN19slEBYm6FfnbBXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715845318; c=relaxed/simple;
	bh=j/jADXi8aVK219RoMXFxr0FK2LP/W6+xdunhiuD316E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R2swGWoCR7nQtXIRNFpiVM4FVnOdMTMC3TWwL+ZKDVul/uTD6lX00iprV7UcjzRHlEAGw47q4DUQ0IQFhfDnITx2LeHimcT6WyHMSa+yDRXj87sIVULU7Xxb8+V8kSM6jNDacczGBibWScLXYldes5muW+dqUH2a6Mn3y2kbV+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H4kP6ZUV; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H4kP6ZUV"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-48072da2f81so2045910137.0
        for <patches@lists.linux.dev>; Thu, 16 May 2024 00:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715845315; x=1716450115; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dc20ps0jcAFJUuVh3rL9TK1FgnvbqFRCMsnNsO8X2rw=;
        b=H4kP6ZUVyfC47VdVI9dhbzzh5ZYvoSVMStSWAsLzgXZwQPHww964uvuU0Da2E0nKS9
         QuL+lx8LIV/WE5oG1irHdPyJP/6ZRd7fhyI98LNc7Nl0bcaeKt4q5/AOBoVhBgAIitAN
         HOKNywQwv48Zzs5mihZsVoJOBE0/YRqTpXsaBNI5mUb2U3bPfF7qd5eV3cIaNjGV3UCF
         Vr9PSUngMn6IUFaHNe7WTlAR+6q5BJJRMY0r1c2h39Kqj/yAfCnDCocLY/XglFGQ8ast
         PjzXjVHAMeGm0ozz5a51r+iQ4wV6nMrRnkI22fuYfhlopelMk73fMfALQyWym6LZ3Fkf
         zJ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715845315; x=1716450115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dc20ps0jcAFJUuVh3rL9TK1FgnvbqFRCMsnNsO8X2rw=;
        b=cY3qL99xms/NocDDNyrKyIbwB7dWG7T6f6LWZkSWWiOcfJXPasFhb5EE7x+wogNMsa
         0CqKo7vKw7ZhWJPXS4Zsb4cr2vcMxOZf9/cA/ELzAGh7VCiuvqXFBt48ktqnnqTB1WpE
         lVtXP7llaLRpVkbP4D0YXLDdCUVT/4nZV208sN8lH8VgZHOEsrv/EJRwHymMLaO43c+l
         QWSFdvuSmH/Lqu4TSTui0AahiBVDJC9fp+SEf5H7EXfSjRgQXKy5DgZbcXocKFFvkuP+
         K97DRaxcJy0hhQuRzkwTXdFlM4HD086PZBOT7sPy83mBRmxd3GxaoOncTq5fD6aormby
         EIxg==
X-Forwarded-Encrypted: i=1; AJvYcCXsDmLUSXS7RWWuSpxVJQ+KPTKEo8lqzswF/8NRvIzJI4l05TntrP6n5m8O7LM73eZjDvFZ3iDcJATzp0JDUXxIN9d94lYz7w==
X-Gm-Message-State: AOJu0YyybVpHRo+2YRpuiHOQG+igPyJSQauX5JGlxUiJ1LmuvSbwwg7o
	0PguGdR/m4LmjKCP9gNHsenvBNUr78/PiWY1A1KNLcRKCrO3y0nuuV27QBOr2fZ4PjdByX9Gkfz
	9ckEKdr6Y7Ar/mRBQi38bNj06BqBmF3JV5+gsIw==
X-Google-Smtp-Source: AGHT+IFhhy55sY01/+/Zby73Vqqeyn4UsGekdgGN26SRGbbQ48ktrx1ypYxjBGoTD2XxjGyZO3aaJBMLOFQX+ce/Htg=
X-Received: by 2002:a05:6102:38cb:b0:47c:f0d:3ba1 with SMTP id
 ada2fe7eead31-48077e83090mr17760401137.27.1715845315492; Thu, 16 May 2024
 00:41:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240514100951.686412426@linuxfoundation.org>
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 May 2024 09:41:44 +0200
Message-ID: <CA+G9fYvGZjMKyM+5HoPOhYT2mHx9K4JxbWR1m59RqpaH=8CxoA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/84] 5.4.276-rc1 review
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

On Tue, 14 May 2024 at 13:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.276 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.276-rc1.gz
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
* kernel: 5.4.276-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: ea8a1bc66159e9f769146360b41d36e87537045e
* git describe: v5.4.275-81-gea8a1bc66159
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
75-81-gea8a1bc66159/

## Test Regressions (compared to v5.4.275)

## Metric Regressions (compared to v5.4.275)

## Test Fixes (compared to v5.4.275)

## Metric Fixes (compared to v5.4.275)

## Test result summary
total: 79349, pass: 65689, fail: 1047, skip: 12565, xfail: 48

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 35 total, 33 passed, 2 failed
* i386: 23 total, 17 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
