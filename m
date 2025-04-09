Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE8725DCE9
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 11:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744199102; cv=none; b=l+w5t7sJdruK57Wr8m4w5wQIwQn27qgnxx06sgWDhy02JTImygj/z+ETsTb4nDY6qvMb6RNGEU/VKeyZ0ataGsUQoLygvOYRMS0pXNHeF4rhjW3MUQtPmlGVrLOzPkdWrvN7dqNs/ZkYoDx3jr/T29knkZ7WMsvM0xzFT+MEBEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744199102; c=relaxed/simple;
	bh=zarmtMGLBF0fyOl9uqcT3OTLO4TlTelE1W7ZZgRVdbA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=szBFAry59MTPqZqxsY99Fbbw2DZlk0iQEGpwFY2pDhOyND7xfKUV4VaMpS8stISbQ5rPLa25249Kw9WoSgomgOj9GfwH2fwFIzreZSrbL//Y93pjWA79dZiajDVRc00sLexskHzr6Riz2MfhifkJJw+CEeDvnsmdTEpQkKFHCW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bzw7Seyz; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bzw7Seyz"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-523ed8ac2a3so3088226e0c.3
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 04:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744199099; x=1744803899; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xbrTJkqffrjK4gGBxAkdXaIIHS0s0LVR8DdB7dEPTSI=;
        b=bzw7Seyzjr/9gltC3NiM6n70d8txlseiqsE1pVw//r6nKgDfiQqc25X5vfR4R1Vb5/
         ISvHA1WfNyU4TJEO4n2GMegsc/xdm/w5oz77vGH2X+KE7W/gqbyhlxhAOp7r8JMh5xgJ
         2eAJ0ha8PPGBI9AVzpgw0W5rcrfT8VdNUGYrF5hvAzblsDG5di1NwMQi5aPXjZ7BV25m
         QpSYxYksPvXiXqzi4X4VLnoeg2AHzcigRFrosqgunPpTN/EvtP5wfNCJdnGivBHK/6eQ
         dM6g1yNJC8ik1NOuLNFEV5B+AMnKzDJFciR6zclFnSz8d7viylhH8PL0YnKWZc1kn4QN
         lUjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744199099; x=1744803899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xbrTJkqffrjK4gGBxAkdXaIIHS0s0LVR8DdB7dEPTSI=;
        b=kQhgU1R2w7WWPEtoaTCCjrsCcBGqMZiY5x99X8kg7E8zUWPeqs5UumwroNNIpg8h8f
         E36Fj4syA2FUNQv+zy09SWMK7Uy4T75ChtuJlauqE6x3vkkD6KfVkGrO9CwNYzL+02c3
         JVYqtb7QCe3JLTM2WQZUWpryR4JAlBvTWA7GozQWGJDJqNvUe8cTka+r33ZB+ERgbQQg
         iU6USerJ1hx+bTBKEnFbwiVP0SButrPoYTrtSl0qF5+dgrXWXx1cj4SM16xNWq/+OUre
         oNZZL9AmsPCNre66DgXR8p5KwN2InIHzIjjc+xmaoKJQ6iuRFPsvfyFhw28MMhlEq7+R
         ngTw==
X-Forwarded-Encrypted: i=1; AJvYcCXk424w0LDNkz4sWcClqRTyNPrg2gc9N4hzaWxA1Cdud/InkiNvnjZQ8YVKtWCq3WCF2jPcVXEB@lists.linux.dev
X-Gm-Message-State: AOJu0Yxld4IEHUQvPHO7HnVmt2JoT9rI9oIcoRdY27INSvyGuIb/bsS7
	NqDrsCN43vGbJ4i2MIEniBzgadTuKOsVNa6U9SyvtrODx45wddxX19EVzDKmwUcujl7aRcRlxVL
	oiSFnjOCB3gNGRzWcK+5GiSXogTlXF3pKSXkiMg==
X-Gm-Gg: ASbGncv9WseCMFxw3WyaW1EnGX4UH+Bygv+3gF4JgoHMJ3GCRaR/qfGrPtxO5YHhMel
	LTlJjW0dJzpfpRuyg6TYb4ytyoJ+peVqcOGSZ1ozTvyGUd+Ctg2QaToJ2tH2CXZOlQjKsQVAIan
	jnN4yBFHoK1QwZ8TzAgA3REitUczk8+7xFoAVfgjY7oprGxn5xapQ12SY=
X-Google-Smtp-Source: AGHT+IHrVANQVRjeANWQVvB1yYz56RRWrcD33zCSJP1mZGCTeaSlafYnKAspMapR8pMTmVjYUIGkaTzo6983LDNHlLA=
X-Received: by 2002:a05:6122:3c81:b0:516:230b:eec with SMTP id
 71dfb90a1353d-527a91a11e8mr1685385e0c.5.1744199099347; Wed, 09 Apr 2025
 04:44:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408154121.378213016@linuxfoundation.org>
In-Reply-To: <20250408154121.378213016@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Apr 2025 17:14:47 +0530
X-Gm-Features: ATxdqUH3MDuXzU1QyOuT7vb7JPOkq70ygkcjB1HRs6SVGaji56XLgCR3FT9aB1s
Message-ID: <CA+G9fYtDLzpJaO6buxdm7xxRqWRoVjKsoEjEas-CUKCwhXweeQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/423] 6.12.23-rc2 review
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

On Tue, 8 Apr 2025 at 21:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 423 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Apr 2025 15:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.23-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.23-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: a285b6821aebfc3e637c25e08623950368c6dc6c
* git describe: v6.12.22-424-ga285b6821aeb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.22-424-ga285b6821aeb

## Test Regressions (compared to v6.12.19-371-g03f13769310a)

## Metric Regressions (compared to v6.12.19-371-g03f13769310a)

## Test Fixes (compared to v6.12.19-371-g03f13769310a)

## Metric Fixes (compared to v6.12.19-371-g03f13769310a)

## Test result summary
total: 111716, pass: 86981, fail: 7665, skip: 17015, xfail: 55

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 136 passed, 3 failed
* arm64: 57 total, 54 passed, 3 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 35 passed, 5 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 17 passed, 5 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 47 passed, 2 failed

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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
