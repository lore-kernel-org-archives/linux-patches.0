Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121092F2341
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 15:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752678893; cv=none; b=M2EpQgoodEGtkULqvyr1MXhZo9GtXR+bo76QmpuoMfYxHabQI/cIJn1wXwp6RqucDZRy3S3tlswVP5qtLuW/vWYflsVVBcARdWf7hUytm6beTUfEo9lJFmWLKuZ+HnhXNJ6uZnkuJgxBwaX8sqas3QB+m7kwRdGD360r4NoQUSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752678893; c=relaxed/simple;
	bh=sJ9F1d7Hm77TJIAltAZf3WHYV/zaIkRNhhbrXivEKVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZqFyUX7/GE31VOkZH0FCZK5b8x6PUUfPnwDW/2yDM1JE8/eWGHtKnE6RRubzhzUyqQzaJrULoQojggVb2NBsJVszYTvq89bS2l+WMftDQzVVlQ0T7vrIzAAktbO42oJY34KtoPFdee4HmoxyscisFbc0NaBaTc4a3cYZzgcDRiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TIp6VU9W; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TIp6VU9W"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-23602481460so64472515ad.0
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 08:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752678891; x=1753283691; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wG1bKPX3a9pOYPMo36U/kpFDDPKBd3jz+ZJQT3BD91k=;
        b=TIp6VU9WR0Z6cVNSdozf2hK+JzJxtdW7YdmZdqaurH7mWqg33C6wBHflCmyUMxEhLB
         KFUnRLwaI7czfCdaXSHwZVAd+28vY5uwwYvvTlSns1DXz1KifL8tYeMgBRukUMomNGoA
         E0pej9mmkNZGt75jVYb2BCQWtFCVoJ52l5mDgnLeaQBQQqtrx9ZJc1k5ZVOikY7Rpic9
         t2/u8l6ePhr1BIgi7Hv6i8NtiV2ZnzHiUlGGz3I1grBFvkjB7jQygqwGcLZySTmid9mH
         krhukSnyJDAbUoueoaFhYjR2ddeXDpyIvM5ZB0gpaeYX1rYnQ+YqH/ZIY0PWFUJm3qi3
         avQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752678891; x=1753283691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wG1bKPX3a9pOYPMo36U/kpFDDPKBd3jz+ZJQT3BD91k=;
        b=v8qts9QaIUbQ8EZYvbXuxi+orkwcg9lEE74+ph70cCw0WQvDSK9OBFzswzdjzyf2xw
         ukTYEa9oIKN+EhcUoj071gUeAyETX1NSa2DzhFpqojh89XIk1xmovsC2e+jayj7CTdPb
         fTNRNrvVqDAfMtWt71BL2xxLLlQXEqXK5ty5bYHTwoO1QiEGGs60c3hluIeMbLotjF3h
         jU3pZX2yvxyVhgSk/YAV4b4d40cuK7V+I1CBvHWMajVT7s7nzLFwCyjr9l8Kn7vBJdFy
         kDViqJCgzpjHpLdT3Y/m49p8FnP+beYxtn+G+sYm8NZHeYiwSHjQ7UCdFXa3gpHzvKyN
         18cQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQz3CYSKfyj0Ur0XNy/AEfwg11tEkZaoJKkAKFMW/wUdlYhBJA8Cbr/WeyjPGivB08CC5vZoXR@lists.linux.dev
X-Gm-Message-State: AOJu0YwcPiVkx2Ry/N+H/wNHqqwB7x6fdmkB0nyHRCXo1UySnuRovESx
	//H70yUpawP3+YPJTzOFFq71WT8nVvA3ovbbQXn9G+afmJ3vDvOnrSmGufm2mEKsefl2G7DbgFT
	hBv8lG32eqEBIpmQ6A2530QUZl68+Jn0HexJTX1JAhA==
X-Gm-Gg: ASbGncupTsQsjaQAlwFrTC1RN9VCq/krZ95NcrSHwFkteKdORbmq12mnIMiAQ3ATesG
	fegyAFxsXjKpN+4hx2NW9C/Qlj3neQ6rS+3KrK4vaDOqgrDtobkR8t6mG0BaqrmN8zM7891tiD8
	KHtS35rhO5AKRbR3SnhekebAClwHKNbApIjOXRq+XP1Jc7GRchNYBRU99NpSHcFDV6zKXkass0B
	6y85/I5OJ5mYS8v6ImUA8pgjMAsdBN/A9/660Bh
X-Google-Smtp-Source: AGHT+IFN4fuIIiulZ3MRb1paSNqs6Z2BJ/Xj7EPl0koyk36NfWEbtV/zpTDUJl+uQQQOsVLtU/8WYBy+WKPOX8mi3zA=
X-Received: by 2002:a17:902:f686:b0:235:ea0d:ae23 with SMTP id
 d9443c01a7336-23e24f366a9mr41690455ad.6.1752678891055; Wed, 16 Jul 2025
 08:14:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715163541.635746149@linuxfoundation.org>
In-Reply-To: <20250715163541.635746149@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 16 Jul 2025 20:44:38 +0530
X-Gm-Features: Ac12FXxuAFuQkORwiuMY8JC4Ac2ZwV2xrsQKTzOurlwV1lEs9CHp9_WNBFMoscs
Message-ID: <CA+G9fYutkaN005d8hw17+i-F+TR7M0FOMNDhjMYEvkpsrp0+Xw@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/89] 6.1.146-rc2 review
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

On Tue, 15 Jul 2025 at 22:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.146 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 16:35:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.146-rc2.gz
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
* kernel: 6.1.146-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 33f8361400e7e0f415ad8f93fabab430397bc2ba
* git describe: v6.1.144-92-g33f8361400e7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
44-92-g33f8361400e7

## Test Regressions (compared to v6.1.143-82-g10392f5749b3)

## Metric Regressions (compared to v6.1.143-82-g10392f5749b3)

## Test Fixes (compared to v6.1.143-82-g10392f5749b3)

## Metric Fixes (compared to v6.1.143-82-g10392f5749b3)

## Test result summary
total: 222917, pass: 202922, fail: 4848, skip: 14938, xfail: 209

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 132 passed, 0 failed, 1 skipped
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
