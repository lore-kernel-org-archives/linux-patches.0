Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64BD191494
	for <patches@lists.linux.dev>; Wed, 26 Jun 2024 19:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719431487; cv=none; b=UjzBqkXuLz9rHB8jpEnShLam4QYkpLJFhf0LvBUuPALOOaEocmg15eT0XEFIF2NwVScN5o0+M+9pcr1ZUbWUQNe2rEWAtPPVqbgGUmw5oUsxyKeu/KgGaKZnkXj3j9+1oo3BsCh51GKDmdyNdtnDW1iF8yu1GosRZIoc4ApRXzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719431487; c=relaxed/simple;
	bh=wHznnM78MYZ8sRXjvyDL3Ud+SD69Me0ZAd2Rh2id1As=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JeIaDTyYYwM8HPLLNWCTGyoOFXtKxbNR4xY98jq6i8MCKVTuqLmi2LxR7nCY4c67lmkE9Q5upHFSsTKO5RyuoJS0YP7XT8l3rAlHISiPciP5+o8G3s84MRwvMMF/GadCfS57rp43MBhT7x0lDsNc86fpUiAVSiPblo0Ro3toV/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uywV7TaP; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uywV7TaP"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-57d1d45ba34so864226a12.3
        for <patches@lists.linux.dev>; Wed, 26 Jun 2024 12:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719431483; x=1720036283; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/9wy7DyYPhVWOxmxXBwLSUmvyHRJRdJyP7og1FLAuaU=;
        b=uywV7TaP+jYeyWyx9xzu7HvFKn/4vn0VUYkks56a8g10rTpjVDcWFEybVQPG2voORa
         lN8DV6fbCLCJ/1lQKBcs69hyja8OShPyF+k3IrlLPKdw3Oh1ivqwqTMDqQclzJsMSicp
         oNxpJZ9cdU1i8vowlDoHPgOXiSJAoD67vNb1YtnqPSI9jUyDuFnunpjavRsMwddwdrKf
         xRplg3HYG9lfJWdjqana8bTSaeywONJx551ONpGwIrvopYvLbXVv8ZEdW88x8LErnPmr
         Ns6o9SK8aDQWo4rY5xedQceaz0iVepbV8z3btOkRYZMqnHgRdWcoO3U1ph/MQxdXBuyl
         y78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719431483; x=1720036283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/9wy7DyYPhVWOxmxXBwLSUmvyHRJRdJyP7og1FLAuaU=;
        b=HE909LY0x0sJNGPxHvyfGoSHTmlWeU0/hHI2nMAzIoDGHRA7OHRTZfrHlWezNFCVDQ
         35XUu7dIIWd4Ww2rs+ZZ3MjdCu4vKZvCdD1WQMwjvRylWmTKgN5IhbY3gy3R+lRFgP0k
         +eWOAPkgxTVgxkiWIJ8V3+SO2s/0bYIecDV2AlXQ+UA0fRJGb8RwZc+dV2CP5/4CSA57
         x/EVru+v09q+4WjfBDnV1WKuFQJ8z3wUtNCF0gme6c4jEEelza/7UpnzEQRlinO0zFV2
         3cQwhmlva7PuG3ocycWj/cmLfT9ONJmjkM7vgTSNq4wAxXJiQHhXfTmkfNPdQvLs845E
         hPig==
X-Forwarded-Encrypted: i=1; AJvYcCXh/FxQVhb7YwQ/Fuv3Uax1BT2qsnTHP492kF6hC6ie7p0h8owxZJFwQOV5m2BFfTBHPZXvkq4w3rhUKPaBMA/CEqybQXdg/w==
X-Gm-Message-State: AOJu0YwslhS2M+FDJa2Q0qR0kRzOTzA4nKT03tUpVjfjcI1gLr/ThODW
	S6iQMkaTxbGkmROX/8W2dFONlFpCKmKFBp9wd997D+9WXUJm9C3cmcPSbhZWeRBG+gIZq+MOqfS
	+NSaJN2xvOCPFwq/sAIYdXNufwVpvQVKLuit/Lg==
X-Google-Smtp-Source: AGHT+IFtl2JuRCY1sm+cgT5dlCY0NBxa6gNIDGmESPez43089CZJjtIzEUHE9NB+Jp3sKGTdotqHG+Syxm6o8J3p7xk=
X-Received: by 2002:a50:c2c2:0:b0:57c:c171:2fb5 with SMTP id
 4fb4d7f45d1cf-57d7002209amr4698203a12.5.1719431482998; Wed, 26 Jun 2024
 12:51:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240625085525.931079317@linuxfoundation.org>
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 27 Jun 2024 01:21:10 +0530
Message-ID: <CA+G9fYu7SvvK41RVCLgDBoV0phAMbfASkw++HP-prWo532KUJQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/131] 6.1.96-rc1 review
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

On Tue, 25 Jun 2024 at 15:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.96 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.96-rc1.gz
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
* kernel: 6.1.96-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 80ee32f97e81cdbd2585b8b81e943f50e8078a08
* git describe: v6.1.95-132-g80ee32f97e81
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.9=
5-132-g80ee32f97e81

## Test Regressions (compared to v6.1.94-218-g0891d95b9db3)

## Metric Regressions (compared to v6.1.94-218-g0891d95b9db3)

## Test Fixes (compared to v6.1.94-218-g0891d95b9db3)

## Metric Fixes (compared to v6.1.94-218-g0891d95b9db3)

## Test result summary
total: 237419, pass: 204833, fail: 2499, skip: 29697, xfail: 390

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* boot
* kselft[
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
* kselftest-timesync-off
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* log-parser-boot
* log-parser-test
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
