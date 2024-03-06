Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201DA5F853
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 10:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709721207; cv=none; b=iaugXhstKSPLXPH9QENZEjoxJRdyP7D3rMUCGr9avAo9wo5lN96vwvD+ylC9gFhOYqGHP6FthsA+zVBHk71evmgwMtSsFDxbiM+m/6yLbz6zK6IIXfvMaUdEuStlTeZiS6/QxbEFTDiLvOdOl5a3j6cPSDHhJwKNnxibv6LnSvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709721207; c=relaxed/simple;
	bh=r8I7d25oS9grIAnDMBNqKWHgDV8KDouDSkKqAk9Cgqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GL1cGoWKgn8hxfZk55jxT83mTsBgUq5w/UTisomu5S+0g4WO6dgEVWeIT9lgNJDn/APody/eWE16pg+lhP5cft5ZZjq+sYsxP18jMYYQdB/WDCYadynpBZZDF61UNFdl8EyomDjFzqrU2hPEOdHyAwcaRSeoIk+YXX/9G6B4+2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=b4pzhyXB; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b4pzhyXB"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-472630e4152so1317256137.0
        for <patches@lists.linux.dev>; Wed, 06 Mar 2024 02:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709721203; x=1710326003; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EFkaMIm1obtudGJ1kf1EFFHAyCZ7GxqkHja4nTwRsKA=;
        b=b4pzhyXBHcTOPrzXUSQEX9G63vpzbkDTrbiLlIXRt38jlDM1tPstD8AL1U0Td1Adx+
         Gj2GY7w8Xr3nvMccuxQyn33SSnUdqSaM2F7vxbhOkhQBxJaGnodaMhydm1rKwgUTCJzr
         GVYp1tGcphCF9US1aPY6MutScPdqQAJxQU6oDnv8FaMscpd6zkAuWfy2CGdleIemCITg
         9IWUIBJckVWDrJhAtwlLKW1NJanUeq/8sKNJ6rTYbPCOulGqIC1mWd1bOMn8lnQVut1M
         oY7UxPiN+dI/nYd5mEiaqSUkEICZ6yz5fH25fwxm8TLBxLvdVETo2KlgaPuS+fZXLmDK
         F6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709721203; x=1710326003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EFkaMIm1obtudGJ1kf1EFFHAyCZ7GxqkHja4nTwRsKA=;
        b=YxYbGcDpg4Uvo5WIwmdNhUEIxfQN+HXpDXA5BtuCj1e1itOXxml3b1tHIFm78T79nb
         kK6UqX5RVRLg8OVV41ozeXoNB8VhOvyL8FEt1mxShiT35UZjplsuIvKXemXpjFWj8Sgx
         9iWkgUXrXT2tmF3cPs7/LGikZL9zG4GeaWg6AAInDzs4HBeRn58leYpFlwNjekZRDYnU
         SZSYmZQC76feQ+5BaRml7mCoyiGPrw5w20hc3yJDrvXaksSm+5Y39erNktx/GwBAhhA8
         oPrlzWJseMOMw4UJYAUt6cxsJaWwS7TONVmttvVgACOqfdys9+Hsc03tTc8VwHNB+deS
         +qiA==
X-Forwarded-Encrypted: i=1; AJvYcCXl93jDzEcg6kFKd99kFFS0ysi53TuSwLW2qkbYZQSKfzZCtrV4v/cUiO7BJAer6vqVDE3oGQGAYFF4WPKVGHPyELxgWbEDYQ==
X-Gm-Message-State: AOJu0YzK36XPzU7AW2lJG+BzmYoOP5D8qL9QxXkVIs+XM5w9ZfWAzE3z
	OK2aP2KMzwu9Wl/T6GzVoZLj+ob0zNIFXIw83Gb+mpUgRwAg8fl/T1KrGLs6FX5BLdB1pl8vGhx
	IPUQxDYd42hrgkIX2BVcrjmm1GXiHkCitOqKLEw==
X-Google-Smtp-Source: AGHT+IE0x77S84TtLxcOdVNEf09H8CAh/J0+qhX6uQO+4pPNNBGqMdIxF9axcvTED4L7HLfrhT+Eebw3d0oNaEqcLAk=
X-Received: by 2002:a67:fd8b:0:b0:471:e8d5:8c8c with SMTP id
 k11-20020a67fd8b000000b00471e8d58c8cmr4596459vsq.26.1709721202759; Wed, 06
 Mar 2024 02:33:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211556.993132804@linuxfoundation.org>
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Mar 2024 16:03:11 +0530
Message-ID: <CA+G9fYvcS6gy_-pbiqwFoJh=s_ocLGh0TSZR-zNiTSh9smZWfg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/215] 6.1.81-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Mar 2024 at 03:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.81 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.81-rc1.gz
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
* kernel: 6.1.81-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: cf578ac947cbb5bb72cbaa7a166d0f92318c3126
* git describe: v6.1.79-411-gcf578ac947cb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.7=
9-411-gcf578ac947cb

## Test Regressions (compared to v6.1.79)

## Metric Regressions (compared to v6.1.79)

## Test Fixes (compared to v6.1.79)

## Metric Fixes (compared to v6.1.79)

## Test result summary
total: 142733, pass: 122117, fail: 2309, skip: 18166, xfail: 141

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 31 total, 31 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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
