Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5818D396540
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 14:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765980488; cv=none; b=Dfc9ajUxP0d+1QNpwZQ2t/LQLAW6r38rYIAQFVk8VhmecBuEo0AlAyvDyIEHV4TheZ1EwqGrGYte5ns05pHRnIdcGaAL0LVE/PucWY11o1tLSt8j2f/Q6A9GMl6oRcshnFBxlAW4FEk/fwX4KukwWGdVFmP5VP1QpFP4u2tG/AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765980488; c=relaxed/simple;
	bh=MBFms3xM2UNaO/eWDUaG5chC4ET5pBUs323KdSf510I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HixoIKlSaskDrbcx1YjSooihMT/Gv5h3Nw9PJwmbxV9NwFPr7nTUEPz95qgRUywlCwTHyO0/ylR8wXHitl/l4SgDiRUgkW1xri2FVoYE3ZlRH3aTLMBv+pWueGTpblT8VMt7HMUtqENLTrF11tSClKAZRil1Tl4MysnbHTCb2ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZyJgbmyi; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZyJgbmyi"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-7bc0cd6a13aso368613b3a.0
        for <patches@lists.linux.dev>; Wed, 17 Dec 2025 06:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765980486; x=1766585286; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ac+iHzN15MmHfh4/SEKIGJf2kaLnC6yP7tGfqO6xAZQ=;
        b=ZyJgbmyiyYQAyxitsP4uyxEmku5xQqA+RUtANiPV9U4mva61wql/YvJg3cHdh+w8QD
         EAoG3VKLbuG0vcrUed3ZcKxCvcwa2Ry8wey0xi4kaiOvo43JN3hCxfQJBtjJPFqMOm0x
         UHdkGuU0IHQCLANODs6OnVr84lxYY5HeWzSX8FflZXhgD+82YajDeEKR+Jw++0rnga/Y
         MtDzqWfqBu/fEpNM3BPB5kfBEY1O16sNCfa+9NCiUoABPPA2dZQZYNp1mlQVz9altHsp
         6/Z4VU2T2/J1XKL9MWrhXQ7cxkCh+9jijyLWoiik0sQllSXzj4vSB1No65SWJjwAfkNM
         K5NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765980486; x=1766585286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ac+iHzN15MmHfh4/SEKIGJf2kaLnC6yP7tGfqO6xAZQ=;
        b=i6dMIYkRKvaUYkWh2RTa0ugKUtTIkO7/usRD9fTNkNWylH3VCRImEBqBPb54sM35h5
         fmUvv5O8ybMw7H561mFXGkLRDJHvENlx8Ig5qhFyNda0EALSc2iGoiUNJUImqOOD4fNS
         z6FtsOG7yW/G2b1SSOJcp64gJFKqzXdT8P16v1j1Ax+FPP6lGnM/ukJ4Xx3beifRFByC
         /1NLeoIo8oQQjJanat1LGLYHkd+z35tGyimIQiYYtlvBLaPj1CUdVEKaVSXahtj+RCqA
         yq33P3HLa57r83ElQIQgYABo9qNYhRxfshm+U7PmHhSSjIdKgmTQ0twlGhUsMQWcX2kM
         i5xw==
X-Forwarded-Encrypted: i=1; AJvYcCVRasJbQ9tfHv/weK+LcIMIaZ8GUbvpASgErURbhTzVA9LYPeAW/LMr0SFCsZh9pWXM8OHstiYw@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+OXF0nAdUir+2zmE3VAUDU7eQ5sGvAx41QMdK5DypSEYfR0/Z
	S22yHFBy5p3y3RU5CSLreKYazzDXNXsKoSSO4QmxaIdGYZHPS8tEiv3owhNvGus4PBU=
X-Gm-Gg: AY/fxX5RDwJ24HBBwbeyVf/4CtM/3RWryJsYAWSxMdIJcmgOpryLbOTvGgVWZKMfL+3
	2Ni4sAvyZz5oNmf8CuFXlLIr6Cx176EgM4KtIXqmlT0+3vL1m6l7BZxgg1+2/j18pZu5lru0DI7
	iU7zGkbNjkKfptYeQs3XoWgopcrsXEO/XjFmjGtN3i+1r/9K0d46pcl+tIefqbElUDVtXYoJ8Ee
	C4WDPFQUb+U7a1ijcEazr5kEDIrhy7tfRS8JSrX+1wKC6hHAD+T0YK5yCLmWVEBLMhsoxHokGa9
	dK32Y14XOp0LFHrhw33hb0MhCB9cH2e8W93YthAKxljrCIMyHXv0yJOjeOf4z5cDWKdY/leNZXy
	G1DEXmuxm8CdpH8RYz4ccPV/BPl0VXA/tmU8Nl66tg5ylgbGI/fiZm4o570q6eGdRRk/0fdYTPR
	HpNC9LVunLrtoPhaLG
X-Google-Smtp-Source: AGHT+IGTUaCBmzAyvEvAdKj0QT8f22yK+WILp4fpU1FCaukHTnwGZaAIgHjLIEeFAPnPZPXUMrtCeg==
X-Received: by 2002:a05:6a00:6595:b0:7f6:e71f:c6a5 with SMTP id d2e1a72fcca58-7f6e71fd1b5mr12162298b3a.0.1765980486224;
        Wed, 17 Dec 2025 06:08:06 -0800 (PST)
Received: from localhost ([2405:201:c00c:2854:ecba:10b1:66e4:448])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fcbb6fa6e9sm2887629b3a.48.2025.12.17.06.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 06:08:05 -0800 (PST)
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
Subject: [PATCH 6.17 000/506] 6.17.13-rc2 review
Date: Wed, 17 Dec 2025 19:38:01 +0530
Message-ID: <20251217140801.440784-1-naresh.kamboju@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251216111947.723989795@linuxfoundation.org>
References: <20251216111947.723989795@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 16 Dec 2025 at 18:09, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.13 release.
> There are 506 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Dec 2025 11:18:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.13-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The clang-21 allyesconfig builds failed on arm, arm64, riscv and x86_64
as it was reported on the 6.18.2-rc1 and 6.12.63-rc1.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.17.13-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: f89c72a532b507111acfe1b83ff4855dc6772043
* git describe: v6.17.10-715-gf89c72a532b5
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17.10-715-gf89c72a532b5

## Test Regressions (compared to v6.17.10-147-gc434a9350a1d)
* arm, arm64, riscv, x86_64, build
  - clang-21-allmodconfig
  - clang-21-allyesconfig
  - clang-nightly-allyesconfig

## Metric Regressions (compared to v6.17.10-147-gc434a9350a1d)

## Test Fixes (compared to v6.17.10-147-gc434a9350a1d)

## Metric Fixes (compared to v6.17.10-147-gc434a9350a1d)

## Test result summary
total: 108080, pass: 90577, fail: 4070, skip: 13433, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 51 passed, 6 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 46 passed, 3 failed

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
