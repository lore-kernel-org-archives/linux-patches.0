Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B7A2E7189
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 13:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753276039; cv=none; b=N7gupA6clrBiCBFSrU8I6I5XhA1Az9z8u5iPcplhoT6OSx1u7GbSeFFUvwUNcyoxH4KTVLOzgKkIiIev89sfuXSG2EoyI21F5IGSejnYmFsWshgH8Spe1r7Yzdk1byJTWZrQcrCd6+8SdRVqwnvnSmKYijcLTzrqRstW3lI2TVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753276039; c=relaxed/simple;
	bh=K5g5ghBqJeQ8gfTrmh/oFkJT1Bbutgsqi9q9KbN3jrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W9pJ5EVlh6uQaYDaCsE/81Y5nGRKawt7uEJlI1KA/m5K7p56zIol6AImcE0RRPqRvhgjMi4C+nOVL8JTL13GmigM0YM4mwPww45RlPUgN3VxNnWAW7WybliUVbGvw5LOw2sqkQai0L5mr9vUEz+1n1RveKzRGlTyP4GIUnJJW70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l6j0JDXB; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l6j0JDXB"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-315c1b0623cso6111807a91.1
        for <patches@lists.linux.dev>; Wed, 23 Jul 2025 06:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753276037; x=1753880837; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ILj9WSAGRmrcwz1/CE7SMUUUscFZ+MMHiLlins5DWvU=;
        b=l6j0JDXBkOdIEyiTLcarYvoOiGTqT8ENNM9dILVIb2b/EVHkCuJizmaORGbIFtcaq/
         A7Ep/Caix2+M3HQGfJc4pdgvFnQx9NS7lH/kxeKbaC1/Bec3lzmqLvaGHcoJIINia0kh
         88DtFB4/Z5GryVvjuSag2y7CHP5XOgpnR32mlD+BliTxvmi2/dcJHww/nb94I6ySXluK
         UG3GjJlOuXowAr8Tt13fuYWMnrnglPknnQbJQdzedEhAD4c15RRD3Xq3bmfyNkBqNtGI
         cFJ6aT1FIUHRoak77GmsLNwPo9M9uI3xdMncJ4cAg4fLotzD/wecfTcQSu79I+umwznY
         ho6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753276037; x=1753880837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ILj9WSAGRmrcwz1/CE7SMUUUscFZ+MMHiLlins5DWvU=;
        b=YnmtzIBdRMWWvWe9jRivMTq9Ec9LVf8Vbm/mWtcxeU4DZXrgVMppGx64gfaU8mxcbw
         dUO7izYgSo97wbyKspK2/RU5dr7csiKW++VyZxvSDOx/GWEqHArl5FpCZ5KNYSwBhq+L
         +yhcrl+yCZYznpQwjEKficDylHezcao6lUfDyjNaP6RnxVB6Xcf8/Fxwj9R5Zimm0NT3
         XjlUfcef/sdNXgN60mmK2imUVhFDkaK146z9n4ySj9Liz37ZJRwgL9BuzaGBd8qIYIv2
         xqEYIcFBe93/i7cz3IYUKnqdtWxc7iVwrMVRcZNlssQeIgbHfnpoi65YIRlu9jig48PS
         eLVA==
X-Forwarded-Encrypted: i=1; AJvYcCXdMCZlwnDL8dWwUUC3z2FeyeE8i/G8QB/hxJjYLAGqCMG0op/AQMarQwSk7QyRbwHesEgDIMh9@lists.linux.dev
X-Gm-Message-State: AOJu0YxhrNAnkmqKzr6ZKDUaCoILQsdFCi5baTXcFMStbm5rPvsc2SFG
	JC7S7V2bI6VWLVe2nPI9oskXgkNa+u8ReHcFcWEa14xgFXeIJ/VoVTl1tdBTOkDx+L1+/9O9zqi
	dvoEzzfx02RJOTTFxm/4KlEUtZmfRclRjB6N1uVZP3w==
X-Gm-Gg: ASbGncvekfDs05UqhTicrXqMW5pQEUAU/DCDGrfCjQ1fq9h95+a9UBYQjR2HSjlzgpw
	g1dYoYbmgdNJbnRV83hldjh4cg7PGXIILdYCCbj4JG6krnj8qwoIy4kakJypb4Jz+FLIGgA3PKg
	Jozn8trXsMUZzT7Rknnna3LqpHYr+L9OJuBZMgKQmheDOEPbOvLbU5kON/JdVkxkLo+Wl6b1MW4
	vzqdGOf1GpqwaNs5j050lEKMLXwSNAQ9/zeBZQi
X-Google-Smtp-Source: AGHT+IFFU4rGd/eAENVQgxvllM7kgatqYKSu45A5IXoyTjOesjXiiHd/HlBjUVHHJk/SHkBrHRo8js/6zPqOdNttFNA=
X-Received: by 2002:a17:90b:57c8:b0:31c:260e:55e9 with SMTP id
 98e67ed59e1d1-31e507dacffmr5191069a91.24.1753276037411; Wed, 23 Jul 2025
 06:07:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250722134328.384139905@linuxfoundation.org>
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 23 Jul 2025 18:37:05 +0530
X-Gm-Features: Ac12FXy2f0C4oio3mLtIgEQuU1pBJlEEwNWkdnl-ndkktKLp4yIP8BKyubkNb5E
Message-ID: <CA+G9fYsXUvYV3+JQf4St-NjvmMoOOpPCZZ2HqDxcVAoZ5kCd=w@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/79] 6.1.147-rc1 review
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

On Tue, 22 Jul 2025 at 19:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.147 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.147-rc1.gz
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
* kernel: 6.1.147-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 3a0519451f2bb2cdc91626b4ae69a622467bc60e
* git describe: v6.1.146-80-g3a0519451f2b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
46-80-g3a0519451f2b

## Test Regressions (compared to v6.1.144-92-g33f8361400e7)

## Metric Regressions (compared to v6.1.144-92-g33f8361400e7)

## Test Fixes (compared to v6.1.144-92-g33f8361400e7)

## Metric Fixes (compared to v6.1.144-92-g33f8361400e7)

## Test result summary
total: 223705, pass: 203512, fail: 4887, skip: 15084, xfail: 222

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
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
