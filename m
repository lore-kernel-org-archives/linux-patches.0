Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F9043ACC
	for <patches@lists.linux.dev>; Wed, 29 May 2024 03:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716953301; cv=none; b=TmeXBTiU3v0QL3gHJKpL3Y62lIwDt7gg8bqy1UoFItcWz/LmVqwPbYKKYz90UpvEc+v5LhRskfH2nGPGo/0xUbrLA/Puf7zaZMsI1MqjX0fxKLcnBAAygX8DvdUDfm+XJGof7WW5NYtrMuoNtzcGvgjQzHKTEdX74TTQ9L5FIo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716953301; c=relaxed/simple;
	bh=wRt+TDfSYlFEo9QS6+j0hrFYKrhvxg8xfu70bcZErBE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N788ifOgf3TRaiGX9fRtewyozMVdX4Y+XFqMcgm1XoumHzJ+JvcrzL0su7zBJu0ArHxG9wUldWE5foMkeCs7DQJ3X36nwxf9x2PKNABg0r8eABZYz4z+HtmBFpZMxQEYhHLTEZ46y7zT03s5t9peMzxUeoz3NIKq2RHBNIRaMlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tQVJU/0f; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tQVJU/0f"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-803121609bdso488692241.2
        for <patches@lists.linux.dev>; Tue, 28 May 2024 20:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1716953298; x=1717558098; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aTGZhWYe+6C1xgVbBSIL7jdPle1wizKI4qRK3FbTxHg=;
        b=tQVJU/0f/c9+zvouE0gjoh0o+hnj2x/4dtfu1ktirduAkgy2wypctIS/Sl3KkoSk8r
         HHWjxzStw4V4wsVOlH6rm8sNFmTDsFzly+luUERc5tDPNPZ076gBkK5DxGmNn/k826uz
         eaeKEUlbcIWdx+yhaFT0hFiNhblKS6UujrOH/Is2Mfw/mmFV9MM97C2T0bCBNHpoapuk
         e6VmNbM0vi8WEXgqI1Qcc3M1Yi3lmxszSTbdGKxXPmfHj0SEkFr2rrfLvRvddPLPxMC0
         Oav8m+g6U89S/fDe5pRUmkUHEpkBaA5nFPUsU9Z8ekRihQmvkcegIrIPnEYSNJpMvFzG
         u0DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716953298; x=1717558098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aTGZhWYe+6C1xgVbBSIL7jdPle1wizKI4qRK3FbTxHg=;
        b=WrxekRdNUzCMcgb6lfDw8UWdDZwxwaiLMTlFKLjZp3GLQG3axDLiURvlH8wXtj2VV8
         1WBCQ0ZYVCnZighsS+43dmmMShR/K1DWpiAn/nl+CaU22lmb+UzRzMPJmtPq41n1JyL5
         nN9DIS8qsV884fOAH7/o5OpS/FnzTytDaDxkUwpzj0E4HOChtz/DyPGRTUZRmKRxzVEG
         Q9SAJ+Ycalnh2Tzt1P8IzHxcHrGqrJZ/GuBFtvE4oOh+/QMSBPEurcf0zydlhdvB6yCT
         4VkD9FPTaN5NVjQW/IYZBPCnpYKA3ntc5grVl29+X9EGPwAeWCWbU6qC+6C5DI0NhvVa
         /d7w==
X-Forwarded-Encrypted: i=1; AJvYcCWkTFTsCeKSBSexzj6RKGSzixBnZSHdilY12bPG7WoZR/MUrTs2wBkUKeF5fBz7CtUx9K1sdP959bnO1Vxz0Y4GhOStIitz0A==
X-Gm-Message-State: AOJu0YwBbOs5d7JMjwoBXL4VydPwc1JSvM1AdbjGMFyUaFfFXJRh4bf7
	7Lfs5M5QWPzX0HfHHcFe5nWRACEN5f0fBkzrOJ9HKP4Pavb0sUmJSFIEk2SCp5d2dKCU1ZAYiwR
	IsYspMs4VuYrj9R0XTeofHtniu84Q1lZcMZ+9MQ==
X-Google-Smtp-Source: AGHT+IHpoGFgIK6a88msVLi1jV2V44/8HkVwz9s/s+DVm/mINPSvG56jyyOZprGwQ43LYPMKYsw7FuSaczrzvnnBj9s=
X-Received: by 2002:a05:6102:22f6:b0:48b:9460:b5f5 with SMTP id
 ada2fe7eead31-48b9460b61emr3078771137.29.1716953298214; Tue, 28 May 2024
 20:28:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240527185601.713589927@linuxfoundation.org>
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 29 May 2024 08:58:06 +0530
Message-ID: <CA+G9fYsbuFey+yukQYqKwVK3tEcMebAKsoV-qNaFZX7aHLDrDA@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/427] 6.9.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 28 May 2024 at 00:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.9.3 release.
> There are 427 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 May 2024 18:53:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.9.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.9.3-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.9.y
* git commit: c1009266618d24dff4fa4dd5f4086d4701b1fdf9
* git describe: v6.9.2-428-gc1009266618d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6.9.2=
-428-gc1009266618d

## Test Regressions (compared to v6.9.2)

## Metric Regressions (compared to v6.9.2)

## Test Fixes (compared to v6.9.2)

## Metric Fixes (compared to v6.9.2)

## Test result summary
total: 194636, pass: 167011, fail: 3701, skip: 23924, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-exec
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
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
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
