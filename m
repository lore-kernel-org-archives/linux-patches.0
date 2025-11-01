Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F6A2E413
	for <patches@lists.linux.dev>; Sat,  1 Nov 2025 09:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761990809; cv=none; b=I7HHPCyBdf51XXVB0PpAbItbYcrxilXBA5jtpV8g7SQU4z2eJ7z4XAlWZjSCdc/nOvizaDnnrk+QgOKGPyS8IBEXXE2Sfyo9Bmf355c9ccY31hjXaYKWT2WNOwG6rZ2QQMj2YcHlTitpAhy2S077jGOPLLimjNMasJGQtoFUOLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761990809; c=relaxed/simple;
	bh=4NnyNfGAC6ZsIDcYxmD2cQdCUcSzIsBYlbDPrmER68c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PD3HpJm8F0C9ey/nPkMvhVFIEGTNBwGhwOr4Nzx7wrJYLZ8gaI8b/FygdG0w6LQfk4RLmF4p9xhxWYnkwM0PSWAp6dsDmbytIKIDUw79ILPDIyvJi6Nyac865kuqzfFjLzV2DEqgDMYG4MMPdAlxZG9yqj4lQo6yfmHVmG6B4GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ml8QOO8k; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ml8QOO8k"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-290aaff555eso27816225ad.2
        for <patches@lists.linux.dev>; Sat, 01 Nov 2025 02:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761990807; x=1762595607; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kiQP2oPvOGmDsDaKXplb5p4mdzdNo2KLeVLNAbQUAh0=;
        b=ml8QOO8k4tDKwo35S+3ugt9/KpaTZ5q7tYj+xT9nYoztEb2ZJAnteRBD2SjPheJtQw
         D0ALR4NwcTG/j9p2nuHNy0G1N8MuH8dBpZAYqMPPuIaEGJ+v9xRHpq4LOTC87JlDI0UL
         ESJLjU56/MXfYfx4lmMvPV8WC8UVuW+h+G3YJEjZcRu0zAlwJPDXBnpDzIni8nOy1QP5
         jIp1oFGS4XsDwOBNZuWDeX6k1Vdbu614gX4cFX5t7lAb9S2Am7zl9qloUwK1BwqCHpMc
         K20MTC1WfPLxBHjBDm+xYsaXD8mPB6B3r8uwATZEIHyAetbnhP5jy8DjrsR9++aza2cr
         yQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761990807; x=1762595607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kiQP2oPvOGmDsDaKXplb5p4mdzdNo2KLeVLNAbQUAh0=;
        b=eb/CHGz0lc87PhPfWrSYWXL28rm+34NYrvBDNur0KM7Xn7/giD9EOSdsItrSvGwv8l
         navuraSYo2VJ2MWFa3IfYz1YF0zrFud2rCRbAUKfk+NsEiyCB8RmVmSzXduXGAYnBXQX
         EnMhWVWBrvRInUZdDYmgem/oUmTU8fwEhZhFppNOSmS+j6h2+S0rOyhk9wPb8CPL3gxn
         yH4+LOA2Kr3oSPCyE5mf7Xr8cDnwZxkhzoi4cHTe5MXcswzigAuWw9Pmk8CTmI7GHSpB
         dU3rptZLfuK9XeV8H+nDmqUhe3v7xsY+esDYg7U6+Z/gw3Iku1ATMrYJ8zsYH1WVC3o7
         DEqw==
X-Forwarded-Encrypted: i=1; AJvYcCWT+xh/3g7bp2i9HMd9/SqUrQasUUWv8I6K52KszxFkFAEO/E8BoS0EmdtYU93zW2TTsehNehwF@lists.linux.dev
X-Gm-Message-State: AOJu0YzaP6Xfk0A17CF2gR2nK1/gmeRXb7YsU6pSL5yt08Pa/w/4Co96
	LBQvYuOIf0tv5dLn6bzWHLtb732p/5+Bxis9x45ShflhPABzLJLJbkRtZ6Fou4RqdtdAbHvBA8Q
	RmuoY6xVk7VlBIqPde0XofE6V5bGGBoX/bpnoL/Bcyg==
X-Gm-Gg: ASbGncv0VYn/FKhMcCGlz+lsa+cavd5NMMUAywdF3FhHkJyaCiOt54FsK9ngRgo4T0Y
	IbXQY5nhQWXqjHtzJiwCyhzPdkj9KOmvJ7ytpjA6JCM/bHZbG9fJ4IOI3A6rPjxSh7xOB5aZICY
	AyXINqIIkDXmfFZy3LHfSro2y3Mb2ddhVClNEfeuHhBotFXmz+c/LEXlVCEnL0Hbct5zRZNDv41
	9ajl+638T5cgxIipkWf8ynlYZd84+ihAi+p2Obw+PTckgkpbUikfPmqK35t/p5rtHEC5qbAKsgV
	LVAaBxVStbf6DYPw9rVHw+OGNmxTXwSWu05X7/LeoQCAS6AJq2lAM/Iy1Jgg
X-Google-Smtp-Source: AGHT+IHVrBk8ya7HzDcwr++ObnOTVtnq1sbGBgvTci+3t9R5SZASv4ftQASWh0z/vQJbU2KCgwT2mFvEfsDiwiZ3kv0=
X-Received: by 2002:a17:903:2c10:b0:294:ccc6:ccfd with SMTP id
 d9443c01a7336-2951a3a2fcbmr81603865ad.24.1761990806719; Sat, 01 Nov 2025
 02:53:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251031140042.387255981@linuxfoundation.org>
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 1 Nov 2025 15:23:15 +0530
X-Gm-Features: AWmQ_bn5F8EySgrsxxev7HP3CeF23tQ9Lh_tPAR7Mkem-yjGp1bdI06dDmwKJF4
Message-ID: <CA+G9fYuqGSNJadcBFCS6VuBrWN49BL+R+8x-kFkmgKfBGzxfNQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/32] 6.6.116-rc1 review
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

On Fri, 31 Oct 2025 at 19:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.116 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.116-rc1.gz
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
* kernel: 6.6.116-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 2c2875b5e101bfe6ef42655c890d804b3c04abca
* git describe: v6.6.115-33-g2c2875b5e101
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
15-33-g2c2875b5e101

## Test Regressions (compared to v6.6.113-190-g6de03dd48e80)

## Metric Regressions (compared to v6.6.113-190-g6de03dd48e80)

## Test Fixes (compared to v6.6.113-190-g6de03dd48e80)

## Metric Fixes (compared to v6.6.113-190-g6de03dd48e80)

## Test result summary
total: 116160, pass: 98408, fail: 3409, skip: 14040, xfail: 303

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 128 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 14 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 34 passed, 3 failed

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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
