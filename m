Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DE0335568
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 09:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841826; cv=none; b=fLbxsGIZh30jP+112IvUgAeVB0S8/viBPPssQ96BOnJMbflCxbBW4YyPjZ15pE6jCruPIUOBX1lb0nqKvYg7OJ49KmjwFRSIIKaWQOIhCEbMygZraSOn0BlVr3fOVT/ctd9XQyFksk+iApCmRtWE47NzgsUmEy4BY90j9tbmxbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841826; c=relaxed/simple;
	bh=paEnSubsEM1IlX4Fx8BGns84K+slnryUulk62N9zV60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eSWS1aHSL9UI2HGDPGqbIRm5pLpQIOCCkbFiSjCLW12e6aAj12wjdHfW9RMAFm+FHM3FNeqzGNA+mN8f5vkkMmenqSTuSb2qrvazAt4bZ0LSFevZ6Q10b0oRJnk2nF396cYtTFmqukL2X2/2xqJrq4AK/boGfSULysZ6nkPLynM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HRKrH8+c; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HRKrH8+c"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-298145fe27eso10947405ad.1
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 01:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764841821; x=1765446621; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xQCdKxxIzlGDW/pad8bOskN9bo38tocSPqJ0Sm/bO4=;
        b=HRKrH8+cvzuyYMfM7PNfouKjRNVCLIjcbgWKg7bzocuk3mC2oaqvLHPyMNFZQT0HD0
         8MWAlOWxiKRnQko/208VAJnIAbHGDqzLgIDG6zAQIjyZXSphT3++xo84KzumszH0zur7
         DVfcuoPke1DoYAwZNZZ10wQPWlHGOBuDPBViJbljV6egeJQnLrGzCMQMnI15BCzsPmtw
         3/ZjCNNFHd0NKrfHpfFJ9133ujyWtA+dUs4kWOprirDhqvmvrzNjpiiADsA38NSNy1mU
         dCw3+KI7GQcPKQv/v16nmb63nJ2dHRTYQkRoPjqSeP+cHt+b4tqzbNgVqQi9QdVogIFk
         LRpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764841821; x=1765446621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0xQCdKxxIzlGDW/pad8bOskN9bo38tocSPqJ0Sm/bO4=;
        b=abrgYbUr0+RO5jNF1/HTPeY7bIi1Z6zrB1JMcoQv0bNKloQIEGrf7+Gn+p/mF4f2IR
         5iM8Sl+SACIUY9jCXcE7CdSDS7ogfcS3K78eAt0tySl7q4WDX3DJSjbVFK7SjrS9bUGw
         zTozzRtjOetZJE7fpfUCUm+9cGvZaC/5pO08roZGET+vnwd5D2OYRHIyNJEc3xBXFSDI
         NVXQfYhnd/vBn84Y3OKG6Ro2r+5Ut2CfBsK7Vt/3KaGv8L3n3VfBdyk701aCJOqab674
         6g7IV+7dH+83t4uS0L6jnH4bHQy5etbc4zCOJMW7UX+m16odOLSGt0O7St4yy95ylAvj
         m5yQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJYnX99iZae+h/R4mzooS9GA76uBnKGIXyKC7yeKVAxWivjEHLQEp8U5yOIPZyWWSYSnTWElGD@lists.linux.dev
X-Gm-Message-State: AOJu0Yxtzp3zm6kg3lgwD8KvrR++DmsTGdwlG/s0n+rFwbCAwhSVbz84
	cJtB4G7xKNOrU1FRZpaQuYQkWtTH1VYygrmgv9bDaHIcLXAZKt1jDNkvMWEHxyNnEQJLYKymnH9
	kRFwTIlmQNmmZfkIhCMD3/DpDhavv1rLG/uPyi0KkSg==
X-Gm-Gg: ASbGncsNDKtHWZpwmOPOnZJEKW2nFGKFxrg2gTlzA0yVrocFRiKbveuo0jX2yWkMVBp
	v3xVEjx5yZE3qhOiyCDAkST0pacRYp+fl1iFo5ADVS1dXAVm3dXdmW3jIATLa/Mvxe9BfI2tH3R
	R3dU0TanV74AEVdwHJj12dAECd5SqrsY6A/rNA5boG9AvTdo6eJeHB6p7bx1zEfNXG80A1j8M4p
	5TPsSLNJZ2rSMPsbMrYnuAqsZmBGWdhGGtWrhcAHvEfUGO5+veQoiX+pbU/RuMSrvOfnKP/XaYG
	QPAtrOsePRKSQ/cmo6Ijce8463MN
X-Google-Smtp-Source: AGHT+IH/MuYsoPNwU3yqMF6glHHl/rGRMPC2ltPLwOqcYJ5es3WIKFs3Nw4GaKMGeFuySPMsiNHb6ZwWyb4dnOc4Mvw=
X-Received: by 2002:a05:693c:394b:b0:2a4:3592:cf74 with SMTP id
 5a478bee46e88-2aba42fe05bmr1983435eec.24.1764841820649; Thu, 04 Dec 2025
 01:50:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152346.456176474@linuxfoundation.org>
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 4 Dec 2025 15:20:08 +0530
X-Gm-Features: AWmQ_blZgGVdRz_MNdiWwG7ey1yZJ5o0Yjq-9lxTgtnmoqzXUZJVXJa_tbKBRbc
Message-ID: <CA+G9fYv+7+8r7Gqv2y9LTs+JOzzOP6sCsNZ_3oz=EzgZUkKN7g@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Dec 2025 at 21:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.11 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.17.11-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: c434a9350a1d08ea6dff3ed87c9a6104e0641ecf
* git describe: v6.17.10-147-gc434a9350a1d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17=
.10-147-gc434a9350a1d

## Test Regressions (compared to v6.17.9-177-g6c8c6a34f518)

## Metric Regressions (compared to v6.17.9-177-g6c8c6a34f518)

## Test Fixes (compared to v6.17.9-177-g6c8c6a34f518)

## Metric Fixes (compared to v6.17.9-177-g6c8c6a34f518)

## Test result summary
total: 123996, pass: 104773, fail: 4209, skip: 15014, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 57 total, 54 passed, 3 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
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
