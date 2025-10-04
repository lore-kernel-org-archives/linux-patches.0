Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB54B4207F
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 11:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759578573; cv=none; b=Ga+V91fq5j6Q4immn4VewExK136jdyM6fNiEtTB4CyyEkgNUJq72ilLjQKWL/7x2xQn08hTetrS+laX9fDNK5PZ4C6TWfMIVRYmsXgfAsol33sMnXnnFpSdubYTMhhl3n7KDI+r1yQXq78ASrvhdqgGFkQzFcqQT1ST5vMbEQ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759578573; c=relaxed/simple;
	bh=pkDwk8SjdRqCiJc5hSKeWuyIKUzjlG4TUuSd6ZQX3HQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fHvIIukuDJoLGwEnBIwYFf675gYnnb63fvJKEQXTqMGbPvaSvnS1rMivGH5COTj4h7DAMZ0C8OlLGiT9fknzOanu8fuza5EhYMt8J2N+H2Ipo2n6RMtcisE8In2Sm8zsh7Yxpcp7o2w/TsTUajwLdVhvTmrHombHNpcWN/2SJ2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=w7YaNwX7; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w7YaNwX7"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-26c209802c0so31479985ad.0
        for <patches@lists.linux.dev>; Sat, 04 Oct 2025 04:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759578570; x=1760183370; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LcTUdgesWfT+Mzq+dtlZbSTiYi31AaGTxu4nWfR3YM0=;
        b=w7YaNwX7uowDpe6u7VfuKsnPVF5qf1HkyCd1Y3HiABTtN0tjIXcPlM5O3lkrruMax8
         YAYmwqr3OSeK/Gc21lwnrgS1Wzat/wgk8xg4eyqeiLHRGqtIg50Lq4+/cggGPK89dumc
         ks0M4BSAgETsTqOfKMaIoGLBAE4taxBRo8lu6fIDEIVoaCO4GZwtQlpn3+6RBJH+kgaw
         6zxu+x6Sa/3k974rbOGaQEp1EeMjZLzKNnaGZM7QK2kCL0Ngvfvbov8gmeAuA3x1cCEY
         yDn/gsNdIdBUerT7Q4paEK1mw/5mKiuAFBUOncbeXTSv9/r5QjD5q12mWm83nbwpHJCk
         ShRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759578570; x=1760183370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LcTUdgesWfT+Mzq+dtlZbSTiYi31AaGTxu4nWfR3YM0=;
        b=hs+F2B6swHKqDN/BTmJm2p8MbyReV1NlLzS6tEEaLwaTWdzNFzhksIIldSaKEUS80d
         5l+vq21FSzuL2fu2OKv2mMS8ZaRsTmOrr3py9+6GtbwEejlqlNmnysxZNsx6a2JQ0TrK
         s7hLzim+AdaqfJM/NYCBPyMs50CUCZMxd6RHvHlHiC2g4HtkPa+vn9Q3HiDYmI0InoTf
         NDvqlgKTF/Bp+5EH+p0MF0OrzsENlCZ66CPGPxJLp5KnOPbqEAtd0jweXGNl68lk0hkj
         DbCPhrHuToq0e8An36sfQijLzDDKkhTLr9toqds/kDKZC8QoUACNQ0ESC2BppV1oKH5m
         Tgww==
X-Forwarded-Encrypted: i=1; AJvYcCV1p2vDHsnIPAZVhqyW0i2Jfi2+9TO0dqj6099DJE3jz4XDHneXyXYh6NxjMbZ++v4XDb4dK3Mr@lists.linux.dev
X-Gm-Message-State: AOJu0YyFhbhog/t8O1Ouc5SnTTGjp2hY80l+HxG9knWJ9nELhlv+M9qv
	AIeDgAavFThgT1hqV2yv46m4b1tVpEp/e2z1pkCWvRmVA+Lavon8oVH4NzJSG6kIB1+A4WU/tuy
	dsXlcByePfh+bmbVzvqGA3lhutIRFbb9Aa2f5nWuN6A==
X-Gm-Gg: ASbGncuDNg53PGNt9EZu97Lptv14ZxkfXaSZNezGJjGo0l7kWTWVRyDl14wlZBxEcpE
	wv/m8Gn0msPjvML9vJj8cGg8PlJ0FN51l8zl2senoaCGGzfIZy/ZrhAusSCQjIMXfreOxdVwPV7
	RHBRfWsCVijg2JN5Bl2p3+krws3w+KFQnLmV1xmSjTM71ZJ83lN8GlJg492CVaq6wckpz68E5cV
	B/HnC69Z/s40wSud7x5nZgAb4CSfhLyQg0LelO7kXfWHqcFm0DXEDWClNnuGVaWpaBnwcS0pWu/
	UvsQeddsG7hyWnFgyGNZOcF+
X-Google-Smtp-Source: AGHT+IGR+4ZoxTrGQ2mwM3T3Xs48koDKoSlzjpywHqi9I3UCgz7/U5A0yFN9OxuNUTRLiQOO55AwrEpYyVtoI0/jDYU=
X-Received: by 2002:a17:902:da91:b0:28e:78b9:5780 with SMTP id
 d9443c01a7336-28e9a665ce6mr92230575ad.47.1759578570192; Sat, 04 Oct 2025
 04:49:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251003160352.713189598@linuxfoundation.org>
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 4 Oct 2025 17:19:18 +0530
X-Gm-Features: AS18NWA81e55FQMABFWQN53g5Opr6JiuVi-7M3ZefmVGyxBOciifUBnGhnH7Bdo
Message-ID: <CA+G9fYvC3zw7ZDXfSi5Odi79yR7OqP0-5+nB4WtexXZtWQXCxw@mail.gmail.com>
Subject: Re: [PATCH 6.16 00/14] 6.16.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Oct 2025 at 21:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.11 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.11-rc1.gz
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
* kernel: 6.16.11-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 13cc90c947b1412899e3166281ce75d1bf1ae157
* git describe: v6.16.10-15-g13cc90c947b1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.16.y/build/v6.16=
.10-15-g13cc90c947b1

## Test Regressions (compared to v6.16.9-144-ge1acc616e91a)

## Metric Regressions (compared to v6.16.9-144-ge1acc616e91a)

## Test Fixes (compared to v6.16.9-144-ge1acc616e91a)

## Metric Fixes (compared to v6.16.9-144-ge1acc616e91a)

## Test result summary
total: 160076, pass: 136235, fail: 4547, skip: 19294, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
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
