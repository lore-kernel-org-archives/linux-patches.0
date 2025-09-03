Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9A32FDC43
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 13:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756905605; cv=none; b=QoOuTsCb1rR25riDcwajCIFBfdSk6Z85s4Xr8wWr5iujzwfwSfg9yTFYJraVufhI2xjVCBjYdynbYcRkNhBJak/7u/+vDLdrTFuKDwK8zsDgCClmrV+E+L0hNhKckoGYkDKiu86LAZgtn8/Q+gEt1OV7XhF/Kdclk7daMbqBcWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756905605; c=relaxed/simple;
	bh=MBf+FNCGKxwXMZFLdgqxv1wJ2tqUK75/ygRKEJaaXYI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lj73V9kt4qEnm1abqL5N0VXRgZCZAPWEgkthLU9Q1t6/wxq9hqpBkrrih21Fs26JwgNV7z1DuH1QJ8ikl+mT8QmlsVuA3WffBcvh5Yu+TXhiYIJUEG6ZY1maNhBg2jNDlwwSyFA5Glu73gaigUDocU1nEI2dF2JCB2OHHFuV+Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tXGy1tyN; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tXGy1tyN"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7722c8d2694so4331402b3a.3
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 06:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756905603; x=1757510403; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNv0gNy0s2fPL97dDkfmI69n6Su4g4QO35nVtCIF/5c=;
        b=tXGy1tyNVVir6VSdkm0Usb3JxhMbPQ5Z1ywFQuZDJXRwEXYaovRpRRObo4fhOeUZfH
         0c5UTRIK1wCgdpm9cvxmsOYMMQrvoOxKIGP9rcTX7rfx7ZfcpDeJyVWgQXxRSwFmlXjI
         eQ21VWkQnu9QHhJ5Zjsms3xI7Z4J1Ef60+yn2bIawgrzMXuvsiJtqiLVkVWtHB0YatR8
         wxuHtzAGyXLvYPigeIXoFgFTvSt5uSwZXUvuCVGSV/2tPOJg9ctOU7eUt7sUPeSfGdGC
         WfJFNt45mISB+BaswUVR5S9LoA6Mxhgh1W8ETuVEtJUku643z3ljJRNCc6wG5ChiyXO8
         LK+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756905603; x=1757510403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNv0gNy0s2fPL97dDkfmI69n6Su4g4QO35nVtCIF/5c=;
        b=i/35WI2S1jyOfBOCi4oJgqasJzlttK5bgi528RER8T0tNjMIRZ9+gcdadUrzZCIjFa
         izQBaevdF7reBI3ONQT0rWSxyIvODR7/XP3ZEMLjzwD/Jo8wZ5ClSrZc8kFi4MsaY1wc
         vNj4qP2ndZFeGcdUXnPnZocE2jJW1MFsYEt7z344DBAqvKg7WO3LLpq4fhsg4ptKnVJI
         9elz77Zs5pcAv6jmyfkR2VFkMxLRJeQSZizyQ4U5zvQZqjk2vFsVbodkQIRdAesZrBAN
         wj4cjbaikT3pBmLNa/3FJYjRJ2desr3pKg4GdAdRKummYeAQt++S5O8bkHRH5Yhq19Rm
         icDw==
X-Forwarded-Encrypted: i=1; AJvYcCV94CePvjmKWKzpeHEn1VXHiAEBoNpwrOVQQwNBw+Y5GycQEWKXoHuDJGJyjMLP94hfySAtMgLd@lists.linux.dev
X-Gm-Message-State: AOJu0YyWWz8lnytXkel7WNM2T3qOocSAPrGPAw60QzsgWNDXk0mp5ER+
	BTHx322/nVK/bo2mLQKshnxJU4MrUlG1mVV5c++h+3PhkTkv3O+9ogfbcklH898+KNNQP3+q2+E
	yWqC/ExHIOKkaSR9EM0fUJiX2Bjbw0R8kdszY7w4Bvw==
X-Gm-Gg: ASbGnctmcCcFSClghfFuUb3dZOa+jOm8kH2hwRuVr20v5PKASYubbjtBCBw39xSdK5m
	05LSlaEaiaWAOcXk0nl4OwKA9XHZb/rrynyeO5ES7mYIaTGoTwjo4Z7B/KhuNYCyouXpb92I9eq
	uMPCHgMdIJAMquoA8bL1NCBCFaq05aFGp1ESYupBSx94x0Hoaw5aspFYOQ6Mmog8u0DMRBRNEIX
	j5GSp9cy37rrTpldmJjn3aojd3VjCJN4soWN4wTgNNSSUT731g=
X-Google-Smtp-Source: AGHT+IHdTXE73KoeeFD67NGkxzug3Oe1MMbVqH+Kjq3Jcv+JioF9+0keLKnL4nXRSH3NfQ3WSa62apQ+FE2SJGMwrTg=
X-Received: by 2002:a17:903:1acd:b0:23f:fa79:15d0 with SMTP id
 d9443c01a7336-24944af0f6bmr215296135ad.46.1756905602528; Wed, 03 Sep 2025
 06:20:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250902131930.509077918@linuxfoundation.org>
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Sep 2025 18:49:50 +0530
X-Gm-Features: Ac12FXyFlwPtRrrFcPyzEecmFta83FVyMG0IZbGUnmR2iHwzBgijBa_82EhQWLQ
Message-ID: <CA+G9fYshM788qKDL0cjYOxLJJy-1wd8RRB7Ky8weKA1QWWKvzQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/50] 6.1.150-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Sept 2025 at 19:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.150 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.150-rc1.gz
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
* kernel: 6.1.150-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: cdcdd968ff27439390868ee985f1a70f6d6081a8
* git describe: v6.1.149-51-gcdcdd968ff27
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
49-51-gcdcdd968ff27

## Test Regressions (compared to v6.1.148-483-g3c70876950c1)

## Metric Regressions (compared to v6.1.148-483-g3c70876950c1)

## Test Fixes (compared to v6.1.148-483-g3c70876950c1)

## Metric Fixes (compared to v6.1.148-483-g3c70876950c1)

## Test result summary
total: 226941, pass: 211392, fail: 4456, skip: 10839, xfail: 254

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 21 total, 21 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
* kvm-unit-tests
* lava
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
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
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* modules
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
