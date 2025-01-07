Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F47156968
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 12:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253430; cv=none; b=gpTfxGZtm+XY0+F00wUGWO1xHTS51GeT4fS/yg6ygNfdzSI0udHQ/djJqnXcYRRmkO4y+Nnsl62XBb/TUcHecKHYaIjKhsuO9pTxqwV5W4I/0YnUNNeGhSl/3NOCaKQXu6mQR1LAvDaa5CkEsI0jgOOQcDdn4m/FfK9OwU21w/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253430; c=relaxed/simple;
	bh=t1n72OseNab7FuyJhepxlJi2akVqhRVK6GPd3nDE7fw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R063zeNe3F6iCmAwB6RJ9POUEWvTILNvlltWOuQqHyoVNgPFP5MDCgTG/6hcnVdlS0h2wIXGb8ZFGJsCSQXY6kzyFsobyjPFOB77dJiKJk1BAsN58ft3e4uoe8hVaxSE6JM6mbvwHWB70iaTD7gRaWPCvUMOypb9F/aXCNCKvD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zLFj36c8; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zLFj36c8"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-85c41442fdeso2879481241.1
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 04:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736253425; x=1736858225; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIlTnII7lXnwEw9J19XvQRXl5owerrmaRqUBra4MQiw=;
        b=zLFj36c8m1RgKMH+7M5t2ztQ+5UuF9rUI+O9tMqj8cBaGiTMDDbZheE0XZBEBqKhtr
         4RPzVUzsYIAsSG+Vbj0CkzQGA9xT+9PgwLlJ/GAQoTCSqe9cYlFeI/DrZdr8H8JUEkgo
         P4k46xTqdSKSKhWiEpgBUQMq8Jxu8n/oZ4onYYZWjqlxX94BAVkn64XQ9hddNhnZm+oS
         vSvt+RyNJv30fJVzUOTDiOz8UQ9ts1JEWwU0i7YCs6nSKNGWq9XRL8BS989AEMpCC5GK
         X4hW0uc6Vp0UBwzMyYrXAjQ6L69V0iy5lcsCcnN/NNN80W8VpRRTyAO6TJEfyEk4MLfU
         /DTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736253425; x=1736858225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AIlTnII7lXnwEw9J19XvQRXl5owerrmaRqUBra4MQiw=;
        b=IjIh7J8ubt6lJmagfAfFmH4qIAk4tJPJ7UeOfuPgXdoRYmbxjiiliQDAXngSztPNFJ
         vsBGeuf0djpN6+9qZj2P3RlDhB6XE7oTQqVyqR/bpLSnIevoV6J2SPuickCyva6L4GZK
         g23VToqDNxoDNJNOrTBz8puDscvHc3MNVvKTRV27fcIHUXKqYjCTMFTjEzAL90sJxtkJ
         yKDYG0aAsTmrtq9mPFeMtauZX6upEClr8SSepB2O33hLfaXbIC4MH3tSxWrMcO18FE9k
         VaQTy6S29Ydihxsb6LU3y+ZaAPULucroBODkIAQfekw1rD1iw2LlGhhfCsKtonuM89PF
         UXSA==
X-Forwarded-Encrypted: i=1; AJvYcCUH7jXWbkCbhwaatTKIdwDsiBJGCViUpoCTM3fEFRrFA7dXpa0mhicfcakybOnPJcwr0YoHMrT6@lists.linux.dev
X-Gm-Message-State: AOJu0YzQfp7HegdZkXM9fxZFC3IozX1YQaXAAenjEcTYQC6dBHS3PsWa
	H7xfsBzT49fpGS6cHx6uJ4VbweGkaaLIVZLNyAVKh3a9x0MrUPdk40epaHz9Gh4qG8nyKLDNxxD
	O/WtxYVjittDKsXaI4x0dW1qi3S2c5NafsZjlWg==
X-Gm-Gg: ASbGnctnVQoj1BaNp7hGf5khpW22T1QnT9m369N/TBkVwrl2jd+Vzo7WfFTJuUrixuP
	b8f1G3s5hPyQn6Y7xDLwICinif4RnHSifpR6S9SA=
X-Google-Smtp-Source: AGHT+IFXRUdS38Tu+KbeKP8zhQYDaKQRDsBp66iFxxXtcnLzdoa4OcdTycz9efyEmWJMFz48X9/u9Ze/uNpldv7b9o0=
X-Received: by 2002:a05:6102:3ed4:b0:4af:a98a:bd67 with SMTP id
 ada2fe7eead31-4b2cc313aaamr53643688137.3.1736253424942; Tue, 07 Jan 2025
 04:37:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151129.433047073@linuxfoundation.org>
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 7 Jan 2025 18:06:53 +0530
X-Gm-Features: AbW1kvZPVmZ0nAESpvurAnzQbyjpI7HxHiK_qTPQKxCtFxBl8Gz3ViwtpD3IB90
Message-ID: <CA+G9fYusD4gyjrt7AgrUUbMVdW5vpiKx6vO4NK1wZSVwBohtQg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/81] 6.1.124-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Jan 2025 at 20:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.124 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.124-rc1.gz
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
* kernel: 6.1.124-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 88f2306b7d7493dc9a6aaa851f2983532fb5666f
* git describe: v6.1.123-82-g88f2306b7d74
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
23-82-g88f2306b7d74

## Test Regressions (compared to v6.1.122-61-g519f5e9fdade)

## Metric Regressions (compared to v6.1.122-61-g519f5e9fdade)

## Test Fixes (compared to v6.1.122-61-g519f5e9fdade)

## Metric Fixes (compared to v6.1.122-61-g519f5e9fdade)

## Test result summary
total: 114042, pass: 89304, fail: 4717, skip: 19888, xfail: 133

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 138 total, 138 passed, 0 failed
* arm64: 44 total, 42 passed, 2 failed
* i386: 31 total, 27 passed, 4 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 14 total, 13 passed, 1 failed
* s390: 18 total, 17 passed, 1 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 36 total, 36 passed, 0 failed

## Test suites summary
* boot
* commands
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
* kselftest-kvm
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
* ltp-filecaps
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
