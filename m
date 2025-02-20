Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552901D63C2
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 11:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740051612; cv=none; b=G4xQAyO1Mc8N9nBS26UysHYnrNTXvB38MlaGKq9y7HJdcWNR5Kblox/n1Q9F/CzyjkwBGtn30wSuwJSQBww77WcXmprDPus4F3X5dGPWh3b+pX/35y/Yvncb+Dq6YYLzyLDQ50ScXcnqYQ56Y86S/G8r9EdoM4f8FFIWKc/v1x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740051612; c=relaxed/simple;
	bh=eAOfwsqQ8PG1lklb+kYxzDxtQNtsyazqKqe/WfuseOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i0TN/0TVJgEyq/tXXskeP+3kd1EnQe+9YnTXFkjWrzNywjZ7zlcCkYamkTlh0p3FMMlirvOVyrNlBQGzzkLRozmnxJiKlBlSJvckyJIF8tPP8ONodMNl7r7D7CReblI52z3BZ9SkcOIjO0CfE1kz5Fgq5JSatxZh8+I/RLRunXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K0yW41ht; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K0yW41ht"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-868e368ec74so518878241.1
        for <patches@lists.linux.dev>; Thu, 20 Feb 2025 03:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740051608; x=1740656408; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bzgTSWeHSpJRGiFSifmTH+Wfxn1Cdsi8xpzMCpPcT9U=;
        b=K0yW41htaHRgKbmZ9CKC/SK9a6deqkkU9+sA0nenuddltZfGlq6uZdxWfe6O4lrGp6
         af/xqmK5k9lgwGiE1YSD8mxm6THyHUcCcgtLieYRynfqQPcSbUTEJsNLnUFhSYkRTvgk
         52PlMjrokDQFG5Yfw5HWtfHUDhjj8cPqh7+0RRQGMzWAmbjd/BxfPGiys0U492l5Nrr7
         eNqFCKBaAos+eqZ9ddH7kBKx+TV9amBgiTxes4zTJcjMHh80SjY0ILG3e81dUfd8GgE3
         AfXPy4uRa4tQNnceiP0QunGusu+RnL9rVivDD/i8Qq/ivSjxkgjADkQHnJXcVHeKOcNH
         0gUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740051608; x=1740656408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bzgTSWeHSpJRGiFSifmTH+Wfxn1Cdsi8xpzMCpPcT9U=;
        b=Ymc491GjjEjK1tX2gBPB0dzYCIXsHqfaCqR9PdMH9Ef+uNuz7Y/rGNxqTj2nZ/xJLi
         mWqDfCEQahuJV/DGCAupsspwMbQTLT6bFdmChozVbRIYLrM1MSOpXXzPV9J3wR9LG8vi
         Fe3KCrhmhARkGwrs2Wymwkm+flA2vOAB44JL69xvlQWpU+iyR1YJjEvlH7VYR1ofAzNx
         +rNUM9evRKPWTQvM3WT3D14HUCAXAO90hpuYaJ0gOc6njWLPqXIoRK4CXhrj8dUGoI4R
         qxMSFEQvCJrTvEc4owUovLqwYYKNmYy4ulOIH9qUTD13bHKMpCoOFpdPTQHr2BfNdOsX
         JN1w==
X-Forwarded-Encrypted: i=1; AJvYcCXy1U4UlmlnBSWQwKLCQ1EwnDejuLUpl8Ysf94m8WbCiec+bPK11NN+32AjLs2BlbD6VjGPxqGW@lists.linux.dev
X-Gm-Message-State: AOJu0YzNzItaPSh39CBO0YAObi+BYlThRhCUAFqaH1PtsEg4K3pCaUdX
	T+SVVUYqit3QlmKEGX8BTz6WLJvhQJxJtAfEravlocfX2/K6XYzD2eQXGmt2okuVkntH5ADZpUz
	VwJcElpiRWdGteV/uBoCo+HWYwfz6T1dviepwsA==
X-Gm-Gg: ASbGncs0JWppdIg7NaZuEJNlL0Cp3CeBomf5NdvijgsASzMuUNgJDyDdEwkzdAUXDbG
	/5kiW4sp/982cF30kAx+e6NDGVCogXp38yfCyV7u/vXoGL3YU/pWua/gjNCB3RjV7RMxBqyPKuE
	55naYmU/K7Q7k7IbDLFEA0NapJBb+z
X-Google-Smtp-Source: AGHT+IFOkqN2CGqfVZbis2+W4/1tF03d2S0k+uTt1KOsy6VWfYfx+gU8hHMLO3g9P5SaEkbG8ZS1YKhD1cbkBS1nk5M=
X-Received: by 2002:a05:6102:6cb:b0:4bb:dc3c:1b47 with SMTP id
 ada2fe7eead31-4be85c04e93mr4306655137.14.1740051608001; Thu, 20 Feb 2025
 03:40:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250219082609.533585153@linuxfoundation.org>
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 20 Feb 2025 17:09:56 +0530
X-Gm-Features: AWEUYZn47O1F-ZaWjo-DYedUH1Zw-C39d2YCRlVT-7kJbYIWuc5oy92wQ18eqoE
Message-ID: <CA+G9fYuBdefC8Fmi7GZUGhj=fMEucoKJBi1E1NmHDCL_zFQj-w@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/274] 6.13.4-rc1 review
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

On Wed, 19 Feb 2025 at 14:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 274 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.13.4-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: df042386d398b1dd18940b647ec2a78164ebfabf
* git describe: v6.13.3-275-gdf042386d398
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13=
.3-275-gdf042386d398

## Test Regressions (compared to v6.13.2-443-gf10c3f62c5fd)

## Metric Regressions (compared to v6.13.2-443-gf10c3f62c5fd)

## Test Fixes (compared to v6.13.2-443-gf10c3f62c5fd)

## Metric Fixes (compared to v6.13.2-443-gf10c3f62c5fd)


## Test result summary
total: 63316, pass: 51057, fail: 1685, skip: 10574, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 137 total, 137 passed, 0 failed
* arm64: 48 total, 48 passed, 0 failed
* i386: 17 total, 17 passed, 0 failed
* mips: 32 total, 32 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 38 total, 38 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 21 total, 20 passed, 1 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 3 total, 3 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* kselftest-rust
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
