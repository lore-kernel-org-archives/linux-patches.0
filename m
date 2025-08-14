Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EF32EAB98
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 10:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755166264; cv=none; b=YBpUKJmv29Ji5RVyhnYWUyq0hTVlzEuNqhlsUypbrSafe3YG5mLLjMWLK8EAM4E/WkSgoEDwCY9xMBdvCtcd8tNks3fkeR5b43jSBJ+3xffjd8txzj3sdNJ/koBtXwpA2phDOmdOEFx/3TA704gsWnZFpM/vZnXRl73fyYskMaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755166264; c=relaxed/simple;
	bh=3lgh8xQ26jozDiJYVvb/a6YneyTFrSwzHoOPM1g7Lwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lxAM7nvxvP3/CgKDg23NuJBhP9gJA3gzVJHJQlY4KMzvMgFKHT93TspgsB3PZ7Jxp28ZFDfN8FJ5UJez8exidAGhBbWTaT5ZhEI3DRmyEGbw1ih60MU9/ZjMui0K1nl/QyLjruJ1FiwwwpI2Dg01Ei7HQ+eCWRXRCtoj57uS4ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sI/v9A1v; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sI/v9A1v"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76e2ebe86ecso986724b3a.3
        for <patches@lists.linux.dev>; Thu, 14 Aug 2025 03:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755166262; x=1755771062; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+fX785wkBJ0IdNPwEH4B6np2Zn3mGDedo7EzvKxRowo=;
        b=sI/v9A1vyjWh6Uq5ACCrj4IDSrRbkPsW/Pe84xH2MuB8YUN9HXpFplFjvy3Z7O2qX6
         WXHIkO2v9A0PHSpmAi1qBX2jsOkIE8iRGhqk7AFzZVkTE3V3X3aepAWcta5rMn78PB1b
         4dRI8f0Ue6yzqm/dfMtnNd94ksm+mwoU/b4OPAn9EEcNdkpGXKLksssQXLZKj4wqNL26
         5JhS2+xMpkhi1NmEh6GEU9gNcyU5cPhMZ7wWwwJ0J4w7zcpYlUwma8IFCBsi2CZM4j5b
         fAoLJ8bAiVdN00Ny+0fBfqpkqbYoUow5/ncQYyP1McQ2VwN6q1U5b7iTKG+NYfC6Aex1
         0IIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755166262; x=1755771062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+fX785wkBJ0IdNPwEH4B6np2Zn3mGDedo7EzvKxRowo=;
        b=KT4STSenipgVxOAaIT2/0oAW3CX8lpEJkD3qoKRLVqsbIU/sLD64zxgUPewL2gBKFk
         0YmxcgzGA5RnEWurq6JFf5f/hjgcqAzx0mg8dcPp5cNLsFceHYn659g+l64eS00nKLpm
         bkmSOUBtVD7ie4vXLXmOHALz2UpcEnqGtwX4pN0CKLowdGzv8TFclOKwBHcYBHOKHWXn
         9rPf37O9C6rI/6zS8DQaJNRL/HDXHStaEdTheqbN0WxL4RcLMEZtPv8ZgtSUN7fmIVdB
         K79RkgyHxpYJ2JxzwNbr8pMBV7fdzDdZYkvxtBZgQxr7QydSeRZJiq0iylSGhg7KNDP3
         NQ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUO1zeAAw42yDiRMKDx84okZ82Srk3yv8KnEtKHJVKjwTRj1dUQMG52WB50n39kwkV8R0q8KBtR@lists.linux.dev
X-Gm-Message-State: AOJu0YwYFMM5mPOPn5YfWM/84vjvkbCjW9h1mntzy28pblefE4G0ZWTo
	ZCnNYaGOOVH3B4oiyv5hmNku1h7jRL0TMYc0CnZeEdjBUcfgWkeXhuq467mUjQ7olgPx7mJEfec
	KG6eSoz2FSWdEggtk8VWQBcUNZ+W0F0dFXwCpUG/RpQ==
X-Gm-Gg: ASbGncumRJqFR3tM0E3t7wiTCakQn0lzql2gSkBeM9oI9BjaIZdBgUt2dlYG3uN5eAH
	mZMe8/sVcpmcMlVsNysNl70CGf3u2j/GYbP36RtdQITcpgAwjwlCAEG45F0zcUE1jJ+c5CT998J
	zNs/UvHfPJUOeXo29I4cJ9Tn0V58ORaooA0TLTuH7/qQ5Rg68wgJ+HrjLdkEWQU6pKXa7lpO28A
	ILJyFXQ32blkEX+k5iHfTIOBjaZ1XcIMlxTDKxsdpFhDVSltDsJ
X-Google-Smtp-Source: AGHT+IHb4ojkdA7zcslWWamWR1QUnn8TXopVuG6YgtHfwA2nc45FHARLYsJF9iFveQxGypjEoJChOlVWGf4q9ywKLhw=
X-Received: by 2002:a17:903:1b0f:b0:240:3d07:9ea4 with SMTP id
 d9443c01a7336-244584ed15cmr38835865ad.7.1755166262424; Thu, 14 Aug 2025
 03:11:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250812172952.959106058@linuxfoundation.org>
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 14 Aug 2025 15:40:50 +0530
X-Gm-Features: Ac12FXyZ1RL-JNvJ7CwJU5ih2TvRDng2iKqcJ0NdDKAOTzZYTi5fCS_1BEm7rUM
Message-ID: <CA+G9fYv0QfL4vF5hJoSzd-kQ=BdcH8toAMhvEnhqem8og_UQjw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/262] 6.6.102-rc1 review
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

On Tue, 12 Aug 2025 at 23:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.102 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:27:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.102-rc1.gz
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
* kernel: 6.6.102-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 7ec7f0298ca2b610c71e74b76d032616fe2cbaf5
* git describe: v6.6.101-263-g7ec7f0298ca2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
01-263-g7ec7f0298ca2

## Test Regressions (compared to v6.6.100-77-g1a25720a319a)

## Metric Regressions (compared to v6.6.100-77-g1a25720a319a)

## Test Fixes (compared to v6.6.100-77-g1a25720a319a)

## Metric Fixes (compared to v6.6.100-77-g1a25720a319a)

## Test result summary
total: 279827, pass: 261488, fail: 5549, skip: 12412, xfail: 378

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

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

--
Linaro LKFT
https://lkft.linaro.org
