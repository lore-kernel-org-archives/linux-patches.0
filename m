Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3FD28150A
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 17:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755105975; cv=none; b=MZMIU8W8Eb1lecbZtvr1awEAXQkuKKmCgwRmgHkG2MLXceERDW7DoVKSljrsGVuYz1BTYv5JNlR1nZoOYDd53Y5LRdkj1vTBMi5G53UB6W1JLXH5VbNBdifjZ2bjOs8AWpw2RuPoEuk/dWe0wI3KYjd8nUjupWxhinl3Sv3xa0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755105975; c=relaxed/simple;
	bh=rDETrbJk3fAL6TMAFhOUKPzKW8tVVoRgZczqS/dXqrY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nDW/DANonoDTHFzANJAPchhYQMtRm06rpZ/daGIXrszqSlaMVHCSo5fdPUcGsZPdDhqvJqeIJeDX4x86y6x6jK8QWwyzNeB12/d54abhCbAiWJI29fr0tai5ektpmRTOKxql/Cc6hV4hIFojPqlWhxqxsWYXUH+TeROZFFpQ3Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k4M4a3AY; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k4M4a3AY"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2403ceef461so58075475ad.3
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 10:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755105973; x=1755710773; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xxEaH3PT2IziDsC51uoaC6ApX/6gZJaUq9Qapk3Nwc=;
        b=k4M4a3AYcHDfCJ244+TcU8ElYvxNmH68xPReV3BjgxS9cDkGBXKA4eAQYxL5D0yMzP
         GVaD3ScvzqOXP44QQflLk71mdIkmrsIl9v3ybHZXhH3DLUr3ewvCzOrmKgQXmFzaeDAu
         +SJ4tqrf31tBi5+nbUqx9J1OtOIjNwEfVQ+u8V5MQasc9TCx+s7ZdLBYAQPxPqEsf2uY
         UExQBaFV0ZPDUsp6ZBPNHdYjYlllPfLfDIuiCFevAjj8fKOZCEOsIhHB0itn5UWy8ywO
         7T5K6euSBTnw+qxWT77sctE7OxxfyksMqmfPzrTiLrcQlBgbOLzVtDAwtTVdg7Ar0B3U
         1aoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755105973; x=1755710773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xxEaH3PT2IziDsC51uoaC6ApX/6gZJaUq9Qapk3Nwc=;
        b=tKJ7XMevD4UIfDSBtBJnmvNpb1SKRtOiad0UrnJA6jxIFkMXkGSxnA8G/Otzq5ZZRk
         4/vujgERr5ak3ZVoGTp9pzTq8mwf41oVbB5pRNMidjsE+yeCFylbLX5EXQbpF1JMpWJO
         lZag0EYkwueNAu9c3YxEp4kh9xhwEECsqRpyGbfnjHkyA1fIKnwxETdAh8UbGBxh8f1m
         ZtKJ9C8Vwca4hryB/+KU165g9Z4mApm8tdVvjE4QT1LSbz3zdMgmfbtdlcqPHDpOlALV
         VJbhGXG7wnHsAZs3o+eMW6bN4EX2gjPbOlDKBRyqYeu6tT1TTDKVUz/jTtYCIkuZSdms
         8s0w==
X-Forwarded-Encrypted: i=1; AJvYcCXl7IlVnt9UZjBCFQ4rl8Tdc7Pbn9OqcQsmdnzCOmUOKkUZXRVAUBfOgVX3WV4B6ya5d7zvTdJP@lists.linux.dev
X-Gm-Message-State: AOJu0YwgrDOPJDACP+LZ9OOB9LOagrSJHWvIhVCJ1T7Gj+cJ9UIybLFI
	WMgLKYQKwQf0HfYuEfTSPPS4GKLi6ci6m3AhS9V4qzXwCm2BQnHfkkCkq2hXY5RMhYD6QjTwwdl
	ODD5MwupZIqahgHRNR9Le8tU6n7He3sJPhwmqqn+mWQ==
X-Gm-Gg: ASbGncubdVOeNktbBYR0XlheQnRDWYEqLGu4rmhUI8dpTMRvj7yCxdxlOORlrMUAC91
	sQqFd0sRwZxLN82+ylZ2f/jgQtQK42MoFoafgaDwRROCyQyj8vRb0WmTTIMyOyhBd/GpDrRXvz8
	G3TEfbJxGIjE4Ro0eYkpCoSofJCznUPrQoW1wtC5R6EHT6Mno2WKNaEFMjhg5bFtrQU8sBgtDCp
	FPBkgKmO9gabdtEASCzbhgqpH3EvUVfRdFKJ2Eaz99Dx5Y=
X-Google-Smtp-Source: AGHT+IEOkUkmYC5N/J/vB64cbgQmSrvC9vCyxLSKaoYb2OP1VG5F4R/rhGmiI87mYKoYirIeiXdBHrdRGm8IHUx7phk=
X-Received: by 2002:a17:902:f688:b0:242:fbc6:6a83 with SMTP id
 d9443c01a7336-2430cf1c309mr65017485ad.0.1755105973321; Wed, 13 Aug 2025
 10:26:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250812172948.675299901@linuxfoundation.org>
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 13 Aug 2025 22:56:01 +0530
X-Gm-Features: Ac12FXzdf_Ej46tF3nV5G_5SGIOihaXG54zx8BtCQLExaOGHxY4DFkmbvtbwtTQ
Message-ID: <CA+G9fYvK-gORTTuFqsipKqCPrD-k+uZNrvwpT09s9a6NLcNMUg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/253] 6.1.148-rc1 review
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

On Tue, 12 Aug 2025 at 23:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.148 release.
> There are 253 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:27:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.148-rc1.gz
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
* kernel: 6.1.148-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 7bc1f1e9d73fe5fd8a0e5a3b960f8d8f5aaa25dc
* git describe: v6.1.147-254-g7bc1f1e9d73f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
47-254-g7bc1f1e9d73f

## Test Regressions (compared to v6.1.146-80-g3a0519451f2b)

## Metric Regressions (compared to v6.1.146-80-g3a0519451f2b)

## Test Fixes (compared to v6.1.146-80-g3a0519451f2b)

## Metric Fixes (compared to v6.1.146-80-g3a0519451f2b)

## Test result summary
total: 219500, pass: 204027, fail: 4142, skip: 11087, xfail: 244

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
