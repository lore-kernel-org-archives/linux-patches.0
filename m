Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AA1125A4
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 08:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707899334; cv=none; b=QBrZYO+3bpQMRxEQwmXZxOPtyH8d4eRUDur4fE7cOYTQHBXWzV1EfURJAhKZjHiHaCZKe+N6RJqRmAh6sEf76UN0orBK00BDwocNgBkJz7O3CHcWXXlMJo1bhqT3UcMS0VlMahsLvC8Y3XDPrPrG74fazXsRyKEJcgFF8TfcfdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707899334; c=relaxed/simple;
	bh=z1RzFrnMZf3GiNGXTX2mQFwYpYduJ0m3d8+ydYvytKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yx9WUiafDxgViZ6040okv/sKyD71BwiVmlh+oI7wB9oWl8510mJbiwLJLuXvTS03ArG9Xpg6QDNKi8bsDPxLQB6U5IOswppSKrw1j4HhwgIjrj7Bc2VXiba0aBag2vP4fWThLKFDSXrMVAd4RGJLqsMQyPek8bAwXHz0FaTq9xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=waAewcKe; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="waAewcKe"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-7d2e007751eso2500127241.1
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 00:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707899330; x=1708504130; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wuolcvOTiNcGT/sHrvkvrIkmAZtBKK3PrIqOvcXIMOg=;
        b=waAewcKeRy1vdbjGv3I64O3l+Xt2QWQV95u76DLpimFMb7cG6E1EjFTj2CLAplmV+q
         ztYupe2KFPlPfBTpRyUEbAAhJHmNwme+uqB/ksm3/b6FAyzAaJkIcDvtgOh1EReh6Uph
         LFY76MdU0DViZJfMGEycOSTu8DCOjRnDI/Z2OGcX61CFtrZp/tVrfn+KZT175zNChwaF
         M5BHB7cm8tdyd268SBD5wI2mr9Tz4Zb4Lrga6A524T6UJNPsDrtEhReXnG8wkHrgV46q
         zcqjgu/rmuy+Xc3m+iFowWAZtpf/+mEF+k2Rwm5D+pmdm/BrsNyXRUUH7HXAoq8+GYHo
         nXVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707899330; x=1708504130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wuolcvOTiNcGT/sHrvkvrIkmAZtBKK3PrIqOvcXIMOg=;
        b=TPU8Mfqrg9iX7KXJ0lAc6qfMXtQBxNJH2AqCD9wdzA9V8RuqgpWBQkIZMHA6A+gMzu
         Ilk8Ne2DfHAROUnEkaNTkQLIReOJ2tN1qSJiTWk99FnDtP7XfAhLOvb5xuzA3RnRl+lo
         CawrssKcA34bsj458HLCNIirFy9lX5FIY3rSx/wa5boRgptinpveycuXFikOdjP5Xtb6
         I51oPJC/bQuEV45mZamWChdL8ZCwwVlJVkPvfU3yGpkTD9rAF23/cQ5McG/EB7jbMVtP
         lfBMW/PlgqDCcHqBrWfUnmBEVYl3K8XWai/L3MY25c0H5O1dRZ5vB1Iool4tLKOMvGIj
         Slhw==
X-Forwarded-Encrypted: i=1; AJvYcCWTuqKBmlTfJGQXOUvSaU+lTMxbqS/3D+f62fT1lO5mG7LeKp/WoVWqb/9BWkP4m6LN59QsUW5so94KT9XRVHIBAMwFt8fM5Q==
X-Gm-Message-State: AOJu0YyUpuPG1YyoAy2fnHNRmnSNL5EpeNyXrRmDFjKyDBDKQnek81CB
	VNh63dFG6Z3g6VLrRT93I5JRCmZfkQaPFHJfDdYGJa9SdtvdIk5rJH7O3FP3ajfCLT8Qq9oMM7n
	XhltOMZ8g76MFlxC6iC6dTwVCSjprmfnAb1FTZw==
X-Google-Smtp-Source: AGHT+IH5gPatoltUuSpmQuogAkITp7Yv65/QnblbYKRWzTEZiP/Cga8EbN3q0wNeVyUMaUSMn5SZXDDhJha4BoXbx+w=
X-Received: by 2002:a1f:4f04:0:b0:4c0:3000:8b26 with SMTP id
 d4-20020a1f4f04000000b004c030008b26mr1874842vkb.4.1707899330557; Wed, 14 Feb
 2024 00:28:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240213171852.948844634@linuxfoundation.org>
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 14 Feb 2024 13:58:39 +0530
Message-ID: <CA+G9fYvdvQzb8dxjeYrvAPMw-qzQ2s=6AO0Z4t1Zgs5pxY+Z=Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/121] 6.6.17-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Feb 2024 at 22:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.17 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.17-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: bea54b0cb986e2c93aa5d99a24eb2255850384b1
* git describe: v6.6.16-122-gbea54b0cb986
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
6-122-gbea54b0cb986

## Test Regressions (compared to v6.6.16)

## Metric Regressions (compared to v6.6.16)

## Test Fixes (compared to v6.6.16)

## Metric Fixes (compared to v6.6.16)

## Test result summary
total: 149653, pass: 129011, fail: 2047, skip: 18425, xfail: 170

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 132 passed, 15 failed
* arm64: 54 total, 47 passed, 7 failed
* i386: 43 total, 42 passed, 1 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 12 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 48 total, 46 passed, 2 failed

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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
