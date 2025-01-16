Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE791DA2E5
	for <patches@lists.linux.dev>; Thu, 16 Jan 2025 10:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737023167; cv=none; b=BQYdTwrEw2Ps0nh3Ct3FtaXL8ubCrZhZ/hwRsRLO/YDzSCdedfLMRxLzOE/gvZU/I9mDbct6OZ/YI+Hs4uQnK2fO+C0BdCsktwlt8TEk37r7GXqsxNc1Gpwoj+axqi0Iygx5l7ZWbiDnU4KR2GiGVZO5tUOeQkIn1kdaom1avPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737023167; c=relaxed/simple;
	bh=3FhcqilcbilCn/lJYai0SA5bMXuTjsXBNywnbgdXFfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P8L7791nrhOxc2GlOyZyIFGf1R1iaYkEhYmu+ALrWRSc+KTwIo3Jirc/6/4400rblUgAvGo+WTEKeTs1RiY16aW+m3BY3rZCk3zxeduNwt/iQbyeODfpEaEYQI5XpU3F8x/yqkUtlJUojbkYeiHKDKD/xFqlTvFLdrIJdawdFY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pbxULDAE; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pbxULDAE"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-4afdd15db60so126419137.1
        for <patches@lists.linux.dev>; Thu, 16 Jan 2025 02:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737023165; x=1737627965; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KvcLCVaXPyBO71qmkpEFfYkIMD9XHMHUK9nSlKkhZH8=;
        b=pbxULDAEjTet0vST3IiMWyl+thpM9qOrbmOT2YDK5bK3cAIxDJpAzkVnX92Uczazly
         Brl49wviChS1JWs8bTVTi7dehk4Uy0DT6zdXWZuaShwyCpC9Uf/43b2oTTuLIbKoIp1T
         5Vew79DGCIUEJL54EPoKzdpCrt+Z6a+ShJWVaLFC22MuuKCfNoNtsp+lqoc2l6oBG7Il
         Kdkh/ffVNNrnNmhi3Tm6qVKn9h4dfsfxV0DziUtdgSVAefOLcWNWzPQQnWwUhsDnV7cU
         MyxsXf/V/3JcxYD8RnWMRsJA1b6eyRXRO/Wn4ZoVT13ixmqZPR72yuA5FyZ6mNwVSkfE
         vsqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737023165; x=1737627965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KvcLCVaXPyBO71qmkpEFfYkIMD9XHMHUK9nSlKkhZH8=;
        b=TjiVA9vsPdt3roTES0k6dNXuJfRIYi0zT7/Bby7viF5kI7fbmDE9C8EJw8Yg2JhsN/
         wUdjDLesVenchRn/oppMEIq0+GS+rX0Q/mDfL+o9hCtQF40iTN+4Lw4iNwZwq9WRncDZ
         3yJraPNaau/Cr6twkZQjWK5qhkoOMNchd6IX1ifcgEqFe09rjQW+rWzdwvFLMzk7w/gr
         W0XthmCzqyxpa7XgovDRq4W2h8zZAFFMw84J1iECCbgsyHP+wHvMmF04GIRq4QSXFItL
         bYbuEZ3LbW7gIOGesHHq8r43MjARithpYsq8JaVLK6pYwi5MZlsFWMXvuHnI2MqxqQqH
         zA+A==
X-Forwarded-Encrypted: i=1; AJvYcCUW/rKnpJvUQOaA+iIK4A/GmCJPABET/MpSCkpCu+0lTaSiYwoON96sdUjSuGEJ2lcAbuDKRy0L@lists.linux.dev
X-Gm-Message-State: AOJu0YxpJBzINXB3hU9FOdEP3u8HDD6KQHoNNzAMIy5YxAy3BkFqLDuE
	EYFCzuNepfK4y3GeqsB7gW101LW1MbqDmCI7KOgvyly4KtPdXPXGHzFwiG2Jd5yW+sxS0Kjpdvb
	wt2UntNWsP3fvMLzg3Oth8OZat7xYHdi/flDeUg==
X-Gm-Gg: ASbGncsKCihOrv7mR6uMcsTqJGLHVXxvnrkcIKn/G5QUV0diO7l1/7yVa2v4TGRI6Sb
	5vc7z1z0cjWIsVcj1aSCbM6PgjxHJq4Ryzod9Vlg=
X-Google-Smtp-Source: AGHT+IFas+i17ggODnCZKEXX1zs0v69tG5R5KXmuUrlRbhzq9SwCWQsetJOesOaYgRWPOGePsl9ovKylLLm4ma5TZjw=
X-Received: by 2002:a05:6102:a47:b0:4af:fa1b:d8e0 with SMTP id
 ada2fe7eead31-4b3d0fc7fc9mr26349966137.15.1737023164885; Thu, 16 Jan 2025
 02:26:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250115103554.357917208@linuxfoundation.org>
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 Jan 2025 15:55:53 +0530
X-Gm-Features: AbW1kvauvc4c3OGr_lb5jyExRKFeSsAMe6PW8vKWbdWuq8cCNQx1iOxCSETNdRM
Message-ID: <CA+G9fYvubfVfMAONWi3Pqt3RoJJ2hZT247yQs_d9qqenr7e+og@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/129] 6.6.72-rc1 review
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

On Wed, 15 Jan 2025 at 16:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.72 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.72-rc1.gz
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
* kernel: 6.6.72-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6a7137c98fe395a5691fdf06ed53c9b1df1fb3a3
* git describe: v6.6.71-130-g6a7137c98fe3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.7=
1-130-g6a7137c98fe3

## Test Regressions (compared to v6.6.69-223-g5652330123c6)

## Metric Regressions (compared to v6.6.69-223-g5652330123c6)

## Test Fixes (compared to v6.6.69-223-g5652330123c6)

## Metric Fixes (compared to v6.6.69-223-g5652330123c6)

## Test result summary
total: 96734, pass: 78107, fail: 2971, skip: 15248, xfail: 408

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 46 total, 44 passed, 2 failed
* i386: 31 total, 28 passed, 3 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 32 passed, 4 failed
* riscv: 23 total, 22 passed, 1 failed
* s390: 18 total, 14 passed, 4 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 38 total, 37 passed, 1 failed

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
* ltp-filecaps
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

--
Linaro LKFT
https://lkft.linaro.org
