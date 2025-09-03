Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73D52EC540
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 09:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756892656; cv=none; b=q3mmcZ/1ZG+4Hf+ph4WLxlQHYzethKJ1Za0u2LlwcgRcfK+/4dZbT4UN5nd8EiNFdeWTKtEmH564+PZvNiY70SFjrhUeEwGEUBw3jlCe+NhlI5W4WAu9D7RJwqJ+l+6qua9TCDAD7f9kxrgYtcYcuMasJNJ+l7P5ceaUBnVPiwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756892656; c=relaxed/simple;
	bh=4DO31URqLOlIMCZRzxmllm/LEhaNDOtfIDJngVNU0gQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mob3PL6M67zMvSoEOuSaeXNnvd+eu6eEm/5x/N5rvRtMtb67a07bjyXz9KCcPzkX7WE4QYReD63jcb+h8UGJ46LoID3Y+t9+4YrD/7PxMB93IHihV38LrexwPbS5a3v2MixxJypne5usZDlV+bt8KW4t9hfayK4sfmmYmF5sqfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YEXdmyFn; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YEXdmyFn"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24a9ccbf10dso35637135ad.3
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 02:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756892654; x=1757497454; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtzzda4QBQAaKKzF6sjShO0A4Pr/KXZhT9QV7iIvqZg=;
        b=YEXdmyFn08k0Pk1LPwLx4u6yt8JmkedP1iU+IEzd8Y5q9UadbuLGB2LNIM/uHAXrHA
         pcqS2oJE8H6oAlhUFEqkrz0CdoscP/Iwc3cr6tUxuHjC3vluq7mhMaVbnCEgHyOVMeS9
         nSeaJxSWVy2/wUVaBt2tc/eznmmonxSUrJoNHha3oTSZcjxqLZZIcO0bBPnA1hNHMiyR
         1p/Of/97xAbDenzxosurkKFnK3NF2rBbcNQyk1WNhxxZn9/TSut9mFnJ22koLdWbmiAg
         /mg7SetXg9jbzJmV7zdJZmLQZOUeX7ZPNQZFTdgofBLDQialknqzypcyLWND7h53VAbg
         i2KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756892654; x=1757497454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtzzda4QBQAaKKzF6sjShO0A4Pr/KXZhT9QV7iIvqZg=;
        b=CJm6Ixvr3Vn341IEZkszkSQkkgwwDOEVWdFvPHkWp1diXZXN6T1SYRyaZ8fNv9J2ku
         ZAQ0IIZ8FCfsidPTxGTBWvniCboKQe34HbJ+OTM69d7URmAR7FJYl0ewVAxv8L51Mtom
         g371VJ5vv5r5HuWssHX4VymGurLg5cOYNF0WzBgTD63WID+WbWH6XvblOanu3ZXJhJVT
         wLaBkD+2WbLC9OL43TDaMy17jWCXMrh8c7DuDB6eBvkUOwbzTjrSvJRdgt/KPimwtdSZ
         yScYd+nmT4cPXZqyiuM7I8h799zEq52PZ65At5stP+k9pCifzGTha5/hwuzscmqw843p
         Y0wA==
X-Forwarded-Encrypted: i=1; AJvYcCVJ4N0QcxWUKoiO6H7o/REpGzxrNCGlfSERY4fhyolRuzRzPvFd4laj3EVIdugGmofmyAyJjZdt@lists.linux.dev
X-Gm-Message-State: AOJu0Yyz179UfUzJVEDP2ky5ff5E0QvsM7N5dKhdsfu8nsfHKalSiN/H
	LWizt2vpDq1PW64HhQY9416yVazSPJTQ+LQTaXWhvK0/imlijeyN1dZgmGyvwfXAKP9kZ0u83HH
	iMHeX0fKQvjsJ3QdxPxylPN3CWo9TYBjy1uXxtZIcgQ==
X-Gm-Gg: ASbGnctRlzT3UlsMq/JNLvnepa9/kiFfy2by0CpwH4evn/hm/53m++lxX4np8wSURAw
	lqJXuNTPINTDe66ckEVGKbQbeD0h9GV+K1gTMQApPMH01AQwKKF/3QkHBxjnKfSFv0Zods3Kz6A
	tu5KPC34Be3nD5TbBO+hcnpRGd+190E74gv93tKhM2dMvpO7i36sr+6bYSqk2ZFY+tyQO2OVOZg
	ObBDzrK2kuHF+p8Bwn81Twe37A+mHHD6z3gRdhCbn6mSnac3WQNddSYH6dEXw==
X-Google-Smtp-Source: AGHT+IHi/AIip1Etp8O6tE2+9Jrulbj7mZegJyFHVes3qPLwUuW5JJbcwOl3A+MkyPFMk+GbxU0Nie6sEeU80s96Wm8=
X-Received: by 2002:a17:902:e88f:b0:248:e259:16ba with SMTP id
 d9443c01a7336-249448f9912mr160615025ad.4.1756892654045; Wed, 03 Sep 2025
 02:44:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250902131926.607219059@linuxfoundation.org>
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Sep 2025 15:14:01 +0530
X-Gm-Features: Ac12FXxnehF-f0uX9uf1w98xh_zbbMgvqVVos902X4S572K02cR0LhUNbnaqGvg
Message-ID: <CA+G9fYvSa6TioRgDLT_KtYdWYLz4hUbNroVjg9KiBEe6niDr1g@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/34] 5.10.242-rc1 review
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

On Tue, 2 Sept 2025 at 19:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.242 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.242-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.242-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 4576ee67df7a1a73a4ec410a6c8fba6afd0238a3
* git describe: v5.10.241-35-g4576ee67df7a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.241-35-g4576ee67df7a

## Test Regressions (compared to v5.10.240-524-gd8db2c8f2fff)

## Metric Regressions (compared to v5.10.240-524-gd8db2c8f2fff)

## Test Fixes (compared to v5.10.240-524-gd8db2c8f2fff)

## Metric Fixes (compared to v5.10.240-524-gd8db2c8f2fff)

## Test result summary
total: 38282, pass: 31263, fail: 1860, skip: 4969, xfail: 190

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 100 total, 100 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 21 total, 21 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

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
