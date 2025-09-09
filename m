Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5416A23E35B
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 08:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757405683; cv=none; b=jJ7bCBRnXaX5aXnysltjdW8H1UDexahngnHB+cA5NYqwptdT9VbHfAx64ohMOISIgJhG9u7UZJOCJnmDxeD878NLM5JqAm7eZ/VWVYxXocjth5169mbRAY4ry4mDrVCWOZJgVYbe3vjRXVx1hLUvo8f9RaYk67FJ4juKqo1Ql28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757405683; c=relaxed/simple;
	bh=Y/R4UDZ+ZSvt+VaXgW1xyYWYXJ3iCy6juBUJfKRwCSs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cPoVIl58WhvR+tfZeNaPHExTG7soDve/PVt4GBER/HcqXjoe8bO3uH5sLaCjRA7nCvAsOXCNscTo+DbCYNO0RLSPRUD6ll9GzN3dRh1Cs16CcEk3fDgVN00umjy5/yUi/v2yH8XWX2XnzJmeWbj7j+A48pAIyGuyebuCb5dRQTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kAz5bznH; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kAz5bznH"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b522fbe3088so1332341a12.1
        for <patches@lists.linux.dev>; Tue, 09 Sep 2025 01:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757405681; x=1758010481; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tIpgvsteZsFCH9XFFKILSkJ+RpxiXOarjA0CWs/e0Ss=;
        b=kAz5bznHo+3Pf3uOo9GK88Mn7niS19apLtc9nyMHicU4faGssV3ebY9aaRu4xZgHAg
         fdi09mV8vlBkyowd8UEgbairw+c7ZFOIa2DT0/lWQBtndDAjZZz+26hwfnbRY1o1isNL
         k3chbD/MsduVnc4reV5kSAc9vOprfRnPEpETw3Q7u5gFTr9Ijtoyqnrq2O4JEWzyZdNK
         7dIsgKwCpE0xr1GwQ/OQC+RQu0HeM1AG0MvofJ1lIjIW9RYyzsDfBNUnIHyBL7L5rVnQ
         0vDoqlNROfe26SeMdND0+EV4wBz/BMrmKLFWNGyfu8b88A6Ac+2k5HnftQDEU1HgoOii
         undQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757405681; x=1758010481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tIpgvsteZsFCH9XFFKILSkJ+RpxiXOarjA0CWs/e0Ss=;
        b=QNsUrT5SgsLmzvHNfABL7XxLdZI0NIXyh+FqUaPmrpexZZipvs5FnlAYEQ+zEBfbBa
         NDp2WQlesh3/Cmi1mD33eMPXJ15iwnmfpyR+Gvi5LhaVOBdTmxBj9FnTawmFrWvX2HUl
         Xal1C8thymgEfTDMfl5HhXhxvQfzgyjMwzSvGCikoTR3r7XSNm9lssiam+QdYYpASLdv
         MqIrEWuSuU999UjZo46myk2KMIX47wxdAXsDwh3G5wn982NSIN+2JruYHqgnQBlZpGJv
         FFfgOxHfgetW0unTC/5DWgRnOmgUbNfGEG04Uf5WvNx9Xj5lzCxdI8LfaEKvNGc3PgNa
         cbrA==
X-Forwarded-Encrypted: i=1; AJvYcCW4WuKOeCo+he8eOD07QHunUSGLF/J2KO8Xlr9ipnuTazIXdbJ2Vr0J87pyP8ke4a4S6KI+58+u@lists.linux.dev
X-Gm-Message-State: AOJu0YxYvZ7JXQGR5j8qPAFT4muAaf2dKRj3iLwkBle58fdyhHK5q3zX
	rB0YuPrBt9lP0kGbWRB745tth09u/7iFitmFIG+CnTQAgdpQ4yP5ksv7MmxvB/nhFB2Bx9Yda5e
	IncdO+1JMwt6A2M2l9LGxm+TPJfWDaU0cOzkmysC1NA==
X-Gm-Gg: ASbGncvtz7lqgz6XjbjQoyTtvd9RyOLS9wuLBWXeH7MtiAU8ruMIa4y/IZEYZT9b9ad
	X33s27BTD93/EAK0z0LCPXYQXjXgzev49LUoKEzw6CAf+9OOST4OvsXV73NV8uAZUT4pQuo2aIK
	u+ruEcFHw1UbJwZSbM9WSi3sUnEXNAmaz8WPUJYk+UonxMyOlk/AmLcAE4hlBpHLdVm1jQPLUnA
	gmjFfcvATHIBHNG4Ygo6vUM7ZKlnrRlyS08J405GjKjXLUsMWR0/6cDPbcixf4Fp0F+N54=
X-Google-Smtp-Source: AGHT+IELD9aMuOIBvTjO5dI/RE7Ggtv6zlFzVxwqiI8iba1V70sNtE28/4+HPw/Dy2au9sKayL5Q3BSRVpKjTZNUggY=
X-Received: by 2002:a17:90a:ec85:b0:327:4bd2:7bbe with SMTP id
 98e67ed59e1d1-32d45037837mr13813712a91.4.1757405681401; Tue, 09 Sep 2025
 01:14:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250907195615.802693401@linuxfoundation.org>
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 9 Sep 2025 13:44:29 +0530
X-Gm-Features: AS18NWBX6sG9ivlDQZwj3uF48WgLHfvr7cs9tUI07CgvAn1-iGKNVR1tV29XcAQ
Message-ID: <CA+G9fYtHR3SbJthRkd+HfOMQQJ75L6fKNhU8uMmk5chRmN1G6g@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
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

On Mon, 8 Sept 2025 at 02:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.16.6-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 665877a17a1b1f125d4ad586fb5f032accb7d853
* git describe: v6.16.4-327-g665877a17a1b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.16.y/build/v6.16=
.4-327-g665877a17a1b

## Test Regressions (compared to v6.16.4-143-g6a02da415966)

## Metric Regressions (compared to v6.16.4-143-g6a02da415966)

## Test Fixes (compared to v6.16.4-143-g6a02da415966)

## Metric Fixes (compared to v6.16.4-143-g6a02da415966)

## Test result summary
total: 348600, pass: 321208, fail: 6791, skip: 20601, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

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
* kselftest-mm
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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
