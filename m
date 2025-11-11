Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9104032826C
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 17:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762881074; cv=none; b=GHspAecw6ZRc+HBeObQ4Sa1Ubpif7jhPrkpChgwkgz7YtXw+FVnV8VF8p3NJ4MIc2Nk4C3Tf5by54k1URq+S+/vWvGMyLWauDYZqj9nl0lwoYuFwno7IfBTo65q/mXDQ0ioSrd7I32uy2PStwtyjuk6C6usrimg7gH+lziZ0RxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762881074; c=relaxed/simple;
	bh=M5SWC/ZzGICrpsGy0ws7WBFefwMyTwIJqGaOFlz3nW8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ogjap+MphcgDopoCWFATPBeSpbWMn+01kujBVtAuwIeYsJ1n1XPTwWSWUPD9jkCXExcD+8BE5ep1OcqA02r5Pj36erbvc/Cbgu2MnMo315udOH/X4FWjXdaAXbK1zf9/Dn1e4Mwot7v8gpqoeQRoX/OMle/Vpjtriy9UlWeZgJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZRGD+VWJ; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZRGD+VWJ"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b62e7221351so3623920a12.1
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 09:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762881072; x=1763485872; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HYA3N5+LW84uc3fFIjJhQ2RE7h8FnuvgCOqxZQpkq8Q=;
        b=ZRGD+VWJW1j7eQIFKB3nIWIAuV/B3I0dhsxhh7m6g4MdIj4gi2gjV6jK87qo0otG6Q
         RAQLsA+ZE5ReMncsiD5UEoPEHSYzUnZV9HkJ9rBQ8L+X8B2VSJIH7spmAMx94NnYclEv
         iuoHpf2GQ4LYFOX+ij1iyeMB20PfmXqLHu+NZP7cxRF6GD8UYdx1eUV4enNlAm+pYGW0
         ra8XxTCFm8x81rVkBwwvXyrypyUSiXjVKXNlCZzG2ViKNjXPKhzvHVu0ljzxKc/26F5/
         tmUuLi3ynf8Sw3rxbcmVsoXBzwjqA7iVJBrua71AzApo5MoXc6DvX5DX4No4f2v6f5ax
         rXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762881072; x=1763485872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HYA3N5+LW84uc3fFIjJhQ2RE7h8FnuvgCOqxZQpkq8Q=;
        b=v1HQUM9h7KR7/Je8aWYeKGd7KjXH/Vs/3vVlyem2b/RSpLhHC8arvG/ZoejEY+JcgV
         2TjStLi+JzYolybX6vegLQqqJM7TlRNTssouRb7Nj2jfA00Z4X9Ycg3pwGx1eNIUD9A9
         hBdnsRBRZKePYdCbfSGemb391YVdR5YWcx75VKJ3TYZK8HgpXuvrh3plFPyE1y/R3KsM
         xzAlHVq74vN4dDS0ft1y8M9Un8u4VxCQFVHBMEPfgZwxDC7qQ6d2hpRdlGjrbe1pML2R
         JZk9fr4aDJ4rM21afYH/kX8d+kgCaYu5p81vgaqumkLj0sHISzHQw0d3yqKFtPXbbGYa
         U5aQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6IvypH+kpVl7X/Tj5KZJTDKp8j1dzMe+7BV8hPuwwSAqeShBponjJUjXB7Ls1jWBkQRRYZoYN@lists.linux.dev
X-Gm-Message-State: AOJu0YwXOxT4NQHboJMoM37FyN3RlRwhRFPXpDoKfuWnTyCJsNZswNcb
	blUoA2A5g8Pb1wWjvf1eAz+lJ+5Yrfg553UB486odM2zFIW24R4H1Yx11utDxbevWDfr0QJhLLL
	Ie4Uc3KYpiPg5sUdwJQfWTweQ1rTALfH9YohkLjhHKQ==
X-Gm-Gg: ASbGncuaVVNScrjDYzUHw8abbj9VsleDgbntX1c2qwpYcsxL2NYDHo7jNb/C1O6+KGK
	eHyn2sqVTywZzQslyaK+SHKQ5f3DhUMCzFLu3GOHzPNd4iqxguje9xVajrAEtxTEJu6pfJU3rC9
	peWlzhV8d365XEKJxq7zCs9Qf54kyymfSvzc2NX276abEGCEbmlZHxktFnY1SdvAUOaS9KXHpp3
	PbrheXTC77SvMxzXFTON2UVLkruJgpAmL2Fn6itfA9GTbxxh54W/UOCr1N1gc89TwOPAcSkBmAA
	S/Tx1tLNNz1c5R3GOw6LyzjuylM=
X-Google-Smtp-Source: AGHT+IFlLhpBIxkK/o5HRow5nDOpJpBNkdHxuJq3gOmppeUMKLKNf0PyrtnYTUc2Qk9tZv4yl9D247eFzCIGZIv2wMs=
X-Received: by 2002:a17:902:ccd1:b0:295:7806:1d7b with SMTP id
 d9443c01a7336-2984eddee65mr509315ad.45.1762881071929; Tue, 11 Nov 2025
 09:11:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111012348.571643096@linuxfoundation.org>
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 11 Nov 2025 22:40:59 +0530
X-Gm-Features: AWmQ_bkPy11x6qA98zrHbB-fFmThJx0VvL4EnyNUU17Y_7By7h5jvu5tlHvRR1U
Message-ID: <CA+G9fYs=TLsf6ttjcNep6FSibccva++QJG_FCJsRt+5i7Dxpyw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
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

On Tue, 11 Nov 2025 at 06:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Nov 2025 01:22:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.58-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.58-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: e6b517276bf625e5d0a1f6eec0ed960bd99ec0d9
* git describe: v6.12.56-605-ge6b517276bf6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.56-605-ge6b517276bf6

## Test Regressions (compared to v6.12.56-41-gc3010c2f692b)

## Metric Regressions (compared to v6.12.56-41-gc3010c2f692b)

## Test Fixes (compared to v6.12.56-41-gc3010c2f692b)

## Metric Fixes (compared to v6.12.56-41-gc3010c2f692b)

## Test result summary
total: 120229, pass: 101980, fail: 3716, skip: 14186, xfail: 347

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
