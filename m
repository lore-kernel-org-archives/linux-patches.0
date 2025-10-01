Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB6E19DF4A
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 12:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759320458; cv=none; b=OWodJpIqKm2+d69tTlgvbpP6+whkZKta5jd6DIoOy4CeBM7LXPUrkgP+s0q6DoTwGkJcl+H57qQTTTlwGmYmbeDK+QUFY8fLgzbjhVBuKlAgSn12kdRqA3GcFD1cvq78R36TCZxaK6IXYfOhV9d5dkM02HLdKWsgQJ0lJyMeqqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759320458; c=relaxed/simple;
	bh=KLwS60J/8+RWtqASMttEKYh5KohtFJsU2BRcSHzWDes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G9LqP4stCvBMV1LBHUrCyH0wXzbYZvUOJU8BLlLYawjYJnM8tAnyZpoh6a9wokixsPHpzbbi0AJTTnFO5NVOwBGSqnBH9Y4yxNyYugeifEuyNN2pfjqtDJ6YQxLQDDbEbY+74Jfrqabk0kw2ydFeb8uB6ED8t1soZeyz53n4yLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WyxlsXTs; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WyxlsXTs"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b550eff972eso4764273a12.3
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 05:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759320456; x=1759925256; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rxgZeKOlcJQk5z15C3qUg5xdCnQ+kVOlBtf4/nD8Hro=;
        b=WyxlsXTsX5NvkM2zVTEZ4cRJBIWyQx1th4jhj+at46yjchTYhNWfVQ2nx9MJdMBn/H
         Ef6Jvzt9h/zoMSCIRryryevzRBJINlsa6Kx43DROeTdWjs8zOhN3ewzQ4sHSw0UhBf8A
         09vSZmF1PtknETVhdto2owVEqnByh/k2w6+9zfX6llPiJSQRJZmrTZVd42YxgtVjAPTS
         eFlFITVpn4XTOLV6oLtjuw61rIBtcdZJjp0H81CKkSO7rZan0WZ/xB6ex2e3EvTH+JPZ
         em4cHjq/JKTg9zNuuTdcxQ8Qs0f3np/2myBaa5//c3WNRl4Va3w338mH1XdZrrkXCFzW
         rvBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759320456; x=1759925256;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rxgZeKOlcJQk5z15C3qUg5xdCnQ+kVOlBtf4/nD8Hro=;
        b=rNK2ERsKBti5pRlNfQjTcBpkhXDkNiiMlRsHrUJqVgkVXlxBRyKEqTZZk3SgjTONOG
         DYPO/rMSSPNMkc4rM7hYztxZ3TvBSj5baCC+67wqeYfN2wWn9curbq2fq3zsITCZn8OA
         M0OlFKfyI0i08hWdNtMmRLSyF9YfyilZmmFRl6vSeKxjbqpyTdxVQSWw36fu2zq6W7zp
         nSZmDNhcdqyDxVmXM1HMhxhI0TvD3zQ0OXtYNPud6CwiggdkqlbGnoSd6Hhx+r6qg1ou
         G9HudCAlacJ6GybN8VwjFmkDAGbCXbvrUurAMnczGqHuSwuhawlzVHmKMTLvIa11/ezH
         iASQ==
X-Forwarded-Encrypted: i=1; AJvYcCXExZN9JAMP43Hkj+8iGugbSZoZsIrDhiu4LM02EPF923cdvXYJiwa5Xe1/8HWFqx34h+dhlkLh@lists.linux.dev
X-Gm-Message-State: AOJu0YzGe/HCNThsAk76H1IDt025052Xv/wdL6qG9iwORTxxVs98MAcu
	jUVorZKG2pLmeVmFfVBWsLpIykpTDnGXB8a/K9RX5Gflj871LOPcYqggeZfW8T85p3F8bBr95oO
	0sreVvlrkoEVckb1zr1KQ7o1sVswiKhnltclsymEyKQ==
X-Gm-Gg: ASbGncvr5TOS2YlQ0rGR0w/AuZg5HSQw2nH4rWCWzifWOWUYExDLuXYY+A2lm2Ic48m
	44iA66h5V0yJ72o3EZ4wsOrbxMoU7c3bxAhuO13d2khsTp6S4sSs9oiAwuTXWCdiNTn4btkqpHJ
	UF/OUqpa1Micd+Bi3i3swM7t7bg49Eq5sgydd/5Xib5Ch1KNQQ98EL8FxttnthMzHp1h1qy3uPL
	HrYvV1KdoeBoOit4NigUDAT8+eQE413kSmaf/x7UiRFnqEIuROyMWvx8Ai6LdFZgs6ZSR9H4nYi
	3DS/wWpE3OzXu5AEMeLQ
X-Google-Smtp-Source: AGHT+IHL5VH/dDJwfKusXYhYW9QvidSoHEl+++jEYo5wsQBw18GkBcB19ZLrvyu+Gi6i2SHaHAm+a1Ojo4jVT0crWYo=
X-Received: by 2002:a17:902:c406:b0:24c:7b94:2f53 with SMTP id
 d9443c01a7336-28e7f2a10demr45520025ad.6.1759320456078; Wed, 01 Oct 2025
 05:07:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250930143819.654157320@linuxfoundation.org>
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 Oct 2025 17:37:23 +0530
X-Gm-Features: AS18NWDTltx4j1hbJ4bSb_7pYAsXuGTenb6lzOZx6k94vBvLvRE0x2stPvloBUo
Message-ID: <CA+G9fYsdOigqpVZXXf9SUJPdkJw1i6QyMGCzgZv0=4dqBdFjvw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/81] 5.4.300-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Sept 2025 at 20:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.300 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.300-rc1.gz
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
* kernel: 5.4.300-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: e1a2ff52265e4d85abb275e2930b92c821a3dd19
* git describe: v5.4.299-82-ge1a2ff52265e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
99-82-ge1a2ff52265e

## Test Regressions (compared to v5.4.297-70-gf858bf548429)

## Metric Regressions (compared to v5.4.297-70-gf858bf548429)

## Test Fixes (compared to v5.4.297-70-gf858bf548429)

## Metric Fixes (compared to v5.4.297-70-gf858bf548429)

## Test result summary
total: 39813, pass: 29726, fail: 2683, skip: 7251, xfail: 153

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 33 total, 31 passed, 2 failed
* i386: 20 total, 14 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 9 total, 3 passed, 6 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 29 total, 29 passed, 0 failed

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
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
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
* lava
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
