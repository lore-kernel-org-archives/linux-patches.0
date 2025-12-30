Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA672FD673
	for <patches@lists.linux.dev>; Tue, 30 Dec 2025 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767108085; cv=none; b=VPLD5jzhjv05arQ0+fZ2e9W4k+gmFRuSBYe9iCIt2unyFAP7O58YfhRDe6WtuIK5AXIT8l4zZaMzyuDjHE+fe7yNjTg35TiZABVRvDPap5WRGpft2XUAourzQMWeUwyUQY6fgYHRsLL1jlVpeROlYxgzaJww7noHYluZPkz58Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767108085; c=relaxed/simple;
	bh=nOgn9zgIxNV3+tec//KvqOEEc7pfkKxwJfai4hakGuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KOO1d5Shi7y1MenhT5S80TZvGuWTrOrkHKfJMcQ06tCCPJNuHyKL+9rEOr0qkbK8c5z5eQHcbLiuwR7yUl78PIKu47eU8ttufZCOEBYAHopDz5fY2KbPeEdoi7vv+ybXS9rc9S1vk7PK+by7qUPOO3GOghEis/7Puzi0ovc9h+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=P4JO5lir; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P4JO5lir"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-34c2f335681so7553505a91.1
        for <patches@lists.linux.dev>; Tue, 30 Dec 2025 07:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767108081; x=1767712881; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sH1EUHrGlfr/nAjb3VFlEXAHnNoURt3tL1CKf3VoEH4=;
        b=P4JO5lirDoBNZZANk4LgQqZeOlzmoUZEvXWwNeuHWUX18FeAKqBzJQoHYSFRrjOLCT
         2lxOxnVnjcamwrwquZhlspnCwIlclS5EitPUiJCE85e0ZbiAb3rSLnm4a9oVvDNXju84
         UtCblgcFMxX56XgQtGgQdduvB4BGBIjmeNp6UkXNTvjhtwoVBTyrnjvXSzhLG/2pYOh8
         S5kN9/aGfSlO8RQ5XaXgFeFHp9CJFl9yahfWe1j4nBQL2TNot8R8C7x0OSvlVuVKQWV1
         Bede3gylTavzSFKh9PfFDaNj34k1phzl6w5vOEdU9bmvVgaHmRjnwXuIqwsKj6x/qylY
         uEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767108081; x=1767712881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sH1EUHrGlfr/nAjb3VFlEXAHnNoURt3tL1CKf3VoEH4=;
        b=m8/8uAGAZYuit+Wmnqn9ZkGilyupaF7GzdyfugFpwotQY7DUhXhUirEXTmm+Ni2jQz
         TXdMu/JVhdddRsUxf80j+N+tiniBcm813fK7ibtfVrAe7F2fZgNbRKHRbSfXmcWrAAqr
         DFkhw04royLUKacQrq1+32abZ7FZ1yShybm/k31xKyfjvT6fv0R97wPpEfyhgUqGzn1o
         tk4X/46yCITmW3a8gj133fJV0lGuZNQ+Yv8U5HrnegpfJDvUOv0tYM3ksj36AEuiz9WD
         QxoYHM7GFIKKVCJpUL05rKyIg06Edh2V/ZzCW8UeJEuQxe6QL5/Jd2/6u+lgg3N0Vjc9
         plbw==
X-Forwarded-Encrypted: i=1; AJvYcCUnpLe05pzoGnxoCdH3L+M1cZhf6+iz0dp5fBstL8HDpLfhahTMS4aL5BH3h39k8Uh6PhwtIGo7@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4qQpVnh1CpJ2oYLiWK2IvziN9nuV1hcQQtSzl+3Kae4NPN6nj
	8t6ZxG45/ef/rC6YPcz42Ns1vU7XMIpV1++k0o4BbhToZG4lsP7EPrSjq0ygKBUmZG8=
X-Gm-Gg: AY/fxX6sRVFk/1kPWeaCPAioWQBYSMF3944kGxvO0FRPu2argswReR9SKR+4ChOE5MX
	ZJ3ZjPzD2JOWLyaqLnWpW7/+0cn6AlI1uuTiGm5FSqNr5WoUtXYqBVDovkhDrwatWLkZoWFSz4A
	DC5CuD9cjIi5I5wMe5MO94XGCMgLNDKdqqJzSYo/Kcr267wIBt9KYhzptKpmxvJJiouCDHCsaxz
	pNwM2ULVvwsg3oFeuVeObbvWDq+Kxfj3+0I4z4US66GxDYmVAheWwn33A4hHO9+yMLW4sneApvJ
	uhuLWvqOb76teHBzE4QaKi+s0xi9rv5l/+xV6jTKUIV5EEMLk4LLupvWx56Vpx9OTd+5EdWz8Ev
	bo4iK7ffHge1yTvaNFrRtABvyFx5pN9xGe/1FuMDn5KiReXO+54/T7oF/GxZTMRi06ZIBoBwmuw
	Q17KFndAeWkE/eMORHxg==
X-Google-Smtp-Source: AGHT+IFrb+KXpf4nELheJV2i1itf2OZyMWPkGLgWEtUs9og/Vd4m2h29NT+CW7dlqJJtLnTd06XEJA==
X-Received: by 2002:a17:90b:3d4b:b0:34c:97ea:e4d with SMTP id 98e67ed59e1d1-34e921df30cmr27258260a91.28.1767108081468;
        Tue, 30 Dec 2025 07:21:21 -0800 (PST)
Received: from localhost ([2405:201:c00c:2854:dbd9:82dd:f61c:42f6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70ddf58dsm33285781a91.17.2025.12.30.07.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 07:21:20 -0800 (PST)
From: Naresh Kamboju <naresh.kamboju@linaro.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH 6.18 000/430] 6.18.3-rc1 review
Date: Tue, 30 Dec 2025 20:51:03 +0530
Message-ID: <20251230152108.35370-1-naresh.kamboju@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 29 Dec 2025 at 21:45, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.3 release.
> There are 430 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Dec 2025 16:06:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.18.3-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 685a8a2ad6494bf0b31b9421d98414225146b792
* git describe: v6.18.2-431-g685a8a2ad649
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.18.y/build/v6.18.2-431-g685a8a2ad649

## Test Regressions (compared to v6.18-645-g103c79e44ce7)

## Metric Regressions (compared to v6.18-645-g103c79e44ce7)

## Test Fixes (compared to v6.18-645-g103c79e44ce7)

## Metric Fixes (compared to v6.18-645-g103c79e44ce7)

## Test result summary
total: 136451, pass: 113600, fail: 4155, skip: 18696, xfail: 0

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
