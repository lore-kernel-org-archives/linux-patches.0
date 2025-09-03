Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6692D7DF1
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 07:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756883873; cv=none; b=sVOGrEBUrJPZvRuSYkrCaPgDNWa9zzqdbQsBUJB6EwgSHNRce1uQdQG5aNveGSSFaOEKdK1EtjBkwx2yG8DxxmYo4m6DALcmuFE+0LtsMhTCxf2qXIHfga8Wf+c7DxNPEIk3UEoSlwg9oQ3NqpepMnAb6yanwCoLfs4MrZ/5gXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756883873; c=relaxed/simple;
	bh=UmRwMk4UyU9iF1L52qhq9eclMpOmDUwbEL6NkhJwQSU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bkQM7zZpbHlCVaDSJ7IBPvPOylzARudxtGoBnVSfWoexRLKLwJtgnPlgP+t2uVkzLuQNfSfHr67MieOFdM2+tcyWcSfMLhKE/YgoRGbQqFu0b+uTN3v6TEBQcXl12I0XA0Sn3aCUR9uGZG2nGHQwiuRzriDODOaArHz2DOjdUS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s+TrXv7n; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s+TrXv7n"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-329e1c8e079so1365343a91.2
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 00:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756883871; x=1757488671; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtZQk3qEYaGrYFmRuGVls3E+sSCgFoBR1bXzERkWFbI=;
        b=s+TrXv7nuWouqMlxYau/6e2GIRV0JHQDC+xn6Ro7jYTW4pLKOCzdfEzZzFBwuPqbRa
         CJefrdRiHezZIhhzOoZvZr7qYYrl+1uPFc0cXPNo1oh82vpou5EK6v2dJEZx8/CTcY9U
         Y/BTg9IQ+AIWnhvZMb+Uh5bYhU3Rd7Begs8unqAennFp0yJVSAjZqhBkaNHm6C3uOOhd
         qVQsxF4gDETPajYbHe0k/irEekjVhe7v9SbvznTcCq579PzrZVSqWhqVhpokWXQvSHwl
         Yd96vwQSkpNeie/PKwz0W5XH6+Nm4Qe/faofCfVokL2CemDqte+Vklt3ymcNmnBD6FBE
         7hpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756883871; x=1757488671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GtZQk3qEYaGrYFmRuGVls3E+sSCgFoBR1bXzERkWFbI=;
        b=oGYRxek5OL2v3NnsRUnY1uu71Om+wpRO56kNTnqsXqXKVe2bzBe8z6eGrJAvNuJWoQ
         IocFYg4kph89kCBb4t7wr7aAveEi4y85pXHPdeTpBiAd5KBmw1f14XS3M/XV7fe7rS3x
         mg+t9Awj7twzv6l7ArOJciXOTdiKnh17fBPiYPKtiE6lPbsLGyXfxW29YvhQZeCkll2c
         Ls4Um+WF3RfGaICGR1JPtdY5ONEI4cGesc44EleT3yCjG9otr/DoR5UMZKhzGH+mIENP
         ft/n/5zjwRBBoCfJreJm4a1Gub3j8zY/mq+XEx9kZaZ81t3uGyMd2yIqFlBPmgxqtMc/
         Vt8A==
X-Forwarded-Encrypted: i=1; AJvYcCWwhNgQZa2k11I8/34sbfv+KSwcT+GGBmkr1DJjzqCw4dBeNwcDes1Do4QQbToJW6/uCapIeBnn@lists.linux.dev
X-Gm-Message-State: AOJu0YypmLKYopnIh/4du/S9I1vv/EDqad0UMWyjQCKyZz88MG71GLSE
	AXIg5l8PX889CUWr/1Mx5TwOvl3sWtzLX0McJnbEVNvuLf3p2cJP6SqiZAO65fcmQYHRC0Geojh
	ekeFdgZ3OScY4MpoBnAcEqgre6vAtSeS4ErIFCKgq4g==
X-Gm-Gg: ASbGnct0mxWo1sVw8ogJNqTBu3nqWKLJKwzS0sX6KZEJ8GWVHLT1eSq831Vn25GIiBp
	HB+FhEbPROD8SdUwPSMUhrxJNNvmU0tKLC+DQVEHassLzIne0rER0SsFxJOG5/K0jnAWwf0BcTO
	5yG2VZeMBBhXwTm7ebXy99+Y4RJc7NCs3YDwxrQAaGf/zz/bsxe5q1EUbpBP9LwOATK/HrnAp/K
	1bwuAK+D3L+BQHWVYdaUATJNa//r9PLXyS9cUDInkpGjRfYGjA=
X-Google-Smtp-Source: AGHT+IHbC2eWGnJAQSmz8QCetFm2ywFgVLZ0FazDkS4bKQYQIfI4IWjdRDCFy0BXSLm08wp/pFcKC9G3amxy2x1vLgM=
X-Received: by 2002:a17:90b:4b8d:b0:327:c9d5:257e with SMTP id
 98e67ed59e1d1-3281543c7a0mr20454710a91.16.1756883870836; Wed, 03 Sep 2025
 00:17:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250902131948.154194162@linuxfoundation.org>
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Sep 2025 12:47:39 +0530
X-Gm-Features: Ac12FXx2JI1QpukV4Lu7p9dVUayZlLzc7S3-kKnWthy6XbZR_LyCoaVFceYkR08
Message-ID: <CA+G9fYsc5L2CHwD26-+ZqcCyDPzxi3f9Mc=s11QEtcguBRMfJw@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/142] 6.16.5-rc1 review
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

On Tue, 2 Sept 2025 at 18:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.5 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.16.5-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6a02da415966f62533bff14bd579f6866076597d
* git describe: v6.16.4-143-g6a02da415966
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.16.y/build/v6.16=
.4-143-g6a02da415966

## Test Regressions (compared to v6.16.3-458-g2894c4c9dabd)

## Metric Regressions (compared to v6.16.3-458-g2894c4c9dabd)

## Test Fixes (compared to v6.16.3-458-g2894c4c9dabd)

## Metric Fixes (compared to v6.16.3-458-g2894c4c9dabd)

## Test result summary
total: 350240, pass: 322942, fail: 6798, skip: 20500, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 1 failed
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
* modules
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
