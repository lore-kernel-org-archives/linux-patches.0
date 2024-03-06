Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382DF132C04
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 13:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709733130; cv=none; b=ilAqr3G4zoUb2CNvudmEFvANv8nrtemg5xhuxZNQiUi1ZnS8LMifLT3yMIKXQ8SlW1124Y46Tolk50a5VNWraQJ8KBT7e44NckiaXkhP4GYpg740daFdNWUOQBH8ANXQ+Crx1iFgyt50IFoCDlDkbhAejB8UdEyA14cXjwAk3bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709733130; c=relaxed/simple;
	bh=DxD2l0TYNyX0nIo8X0aUdafi5RwApWasX/Fm+UM7f2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kIUq48U7rG0Gi6DqBjSdFhqjh8slVIT83Q5Kwtn4k8FYyHQa0NTodmzX2a7YbiuhfOov3WUmPFPKrtpJ+W1oyOafP4DudvxgtP9LH0AFza2SMDu/0jbWX5K22eovwJB5aLq2NxjibpYO2JtWFntAb67KELTijB26fCaXOrYn1Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=luUuThVQ; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="luUuThVQ"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7daf957595bso2007107241.1
        for <patches@lists.linux.dev>; Wed, 06 Mar 2024 05:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709733127; x=1710337927; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GIv5f1kNqPYJFCk7U0R+MAUVSCh7feTHZ/Nse4z4iY4=;
        b=luUuThVQ8/5DprwWDcjUCBIKuEFiAgMBoiceLr00uN6lubXIh6CXUgLS6yxakRRI+p
         /KSM5E2rlfpv4bVmgkX1DGgQnKx735lT9UrauO/55nd6yt17swtAwNwOqwN2ppjntsUx
         5Lpbxy+0d0WnmeF60oNZ3w42S56SnS4U9d279oWncKYvTo0l3gxZeseSn6JLNQwvpa/f
         arKdhvFGEmY8ZCevrXZk14BAJ2+2HE6di/rK/hl8kOEM54AUMKteN/61RWjJaSphCtb9
         2/UsNksVTwxIsolWPmN7z+YgWtrBG6sSzd4peXxyPLB8wFX9pzcI/Ey35fR1ezeduk+v
         qdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709733127; x=1710337927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GIv5f1kNqPYJFCk7U0R+MAUVSCh7feTHZ/Nse4z4iY4=;
        b=MKCTqcNn9UK1yOVb9etono7oxmXSHZ92/Br744I/0A7ECLHPNfprh8razgCszSMfNG
         5NYKtBQ9xZDz5m7DHJaGpV470AUOflstYFs+jbwHTvyQpF0axXrrTr5bIhGBd78e1yvZ
         qKk7a0qZiJuZGkBk8zRDbcJQ66tyhrOUYiEOGPwV9MaUpY/vWTma2PVTDGMAK2JY5qlE
         tjwW1YGhC59fLrh/cJpsXiNWoWHGznXcvzDXB8PAUnACYxidPy8V+KTE3WLJKlbbKxAJ
         YmffHs1PN7uW5rIogMUH7AL69NuoYLol7uxFqm9V0CPIbfwAN43TOZgIrl4LrSMTVO1F
         4bOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCQItLFL9Wl0RSVTbNFJ4X56Styc9PD4eKZVP+QtEZmEXmMNAjiH+H5leOqQVmvUlOzR954mGMJV3DjZFLiYRX49SsEOHThw==
X-Gm-Message-State: AOJu0Yw02LORnBXRBqBNjIUgopQdA5hAtF8ttTkUXRwxt8afzQno9H8v
	9FUgx4nHOHIctoUakR+3dd0lxndIJePj7RQhVAZYTcj98isvUWi/ax2K4ivR4kX//ZdruN8gZve
	vg6E/ofLPOqMw6WybDtZoXYNGxflUa+Mha9b3XYJQqTl0f4i2aDQ=
X-Google-Smtp-Source: AGHT+IHhkU275prC88a734xDgCRlafAyCScqUTRNlX3nQgmvhtdfhst4HZGyhvX8Gi1Gdr3G7TwSw2pUSMs4KDdr2fU=
X-Received: by 2002:a67:f408:0:b0:471:b9ab:7bad with SMTP id
 p8-20020a67f408000000b00471b9ab7badmr4148859vsn.29.1709733127093; Wed, 06 Mar
 2024 05:52:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240305113119.020328586@linuxfoundation.org>
In-Reply-To: <20240305113119.020328586@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Mar 2024 19:21:56 +0530
Message-ID: <CA+G9fYtdu7zVnS0=Z12x_YLUbLaefpFL2F4CnmD0AHyP1p_j4A@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/41] 5.10.212-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Mar 2024 at 17:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.212 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Mar 2024 11:31:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.212-rc2.gz
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
* kernel: 5.10.212-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 713b6af903ad5057407164571c78c1e307098b8e
* git describe: v5.10.210-165-g713b6af903ad
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.210-165-g713b6af903ad

## Test Regressions (compared to v5.10.210)

## Metric Regressions (compared to v5.10.210)

## Test Fixes (compared to v5.10.210)

## Metric Fixes (compared to v5.10.210)

## Test result summary
total: 92769, pass: 72680, fail: 3078, skip: 16948, xfail: 63

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 107 total, 107 passed, 0 failed
* arm64: 34 total, 34 passed, 0 failed
* i386: 28 total, 28 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 25 total, 25 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 30 total, 30 passed, 0 failed

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
