Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0730732E15F
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 13:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761658982; cv=none; b=l0FJWobVqqQf6GqoN44EijFsxKPmaRtcwyJ5VI1JG3j2vrz82hVY9i5yNAthchcJGjv+EYAPHgw/xbYw+s2Q2PfHicHYpIDfW85tKcEMk9Oa2LmvgNNmyV/p8zQ1WwDSRQVY+cyOYXXioLjHvVQxDVfGe9LJN89ACUdyjcj+CY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761658982; c=relaxed/simple;
	bh=NkTLesmb1wL3baUpMFlHe2G3W0/q/YxF/pJo68s6F7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mQMJWRsSDH7eAKHvzEPiuQRVaUQBQiiWPYtGtvWs+reXevN6uklfVus0uKSVqds7HOM81E5M3VLCeCBKzlzpR9n4lZzIqdmi/0+abnQlmBNCkSrrudQC5oJAgu3cZYhlJhcm+nTsB51c7Cpekz+cfuugvveSL5z27p6PQWxqqPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Jo3YhrDA; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jo3YhrDA"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b553412a19bso3909418a12.1
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 06:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761658978; x=1762263778; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6IwLo36G1uBhKQ2BuhOcUno2dP4iNx04KNZvVlCM3I=;
        b=Jo3YhrDAgCXP2mG0HvtRWjl3za8ZybGVk5gZbSKrhFF3S1TckcKaClTeTPxUVnMTdr
         vNzWHwP9083SYCEKIrCs6B9TUHuPXfgkFRRZVZXVIDzfSI/dZmCsG7Ia2S/TpYLpn5li
         ws0bbmVEJJb5F0CwfQRvVwjdG3ItJIFVNCZ6BKR8UgIZMIYheYzQrYRx+cSaU+uEIHdF
         wTCnGf3pFDT380Se5HFHaj7Ezrbxvmix6jCdgNojXgGcO73bPi+HnMB7ekV6QeF15/+R
         FUvm7ZQyh1gs229qyFfH9vf1gyecDI36gs2K5mh/9mj8wwLCd7+l5tQkozwTTvo99SUy
         j0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761658978; x=1762263778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i6IwLo36G1uBhKQ2BuhOcUno2dP4iNx04KNZvVlCM3I=;
        b=D5uV9atBVwAzUNudoseFZfEBB4/qltVldrYKqx+FNwRyOdfRuC7oyBNyxfzFII/ugQ
         0uDSKay+YQ1VJfJ4pmwGA0NE4ZHXHxf2Z7wJZ8SmANNz/9HsZIy5sR8u3+l6wRo7D6Rq
         36qReN6853JJMnx9auniA3fAsyW14znUXn6i6z7asDi/XhyisEfTHGmwOGA4E2+9lveO
         Ww5/bYatB+2kwuWo8RTubhP/UVPXVsFruUApLe1Ao22EhHOerePg20KrVvVh7HQXkidG
         wYKe/Is6alhgwW0uidsSHnM24PBlSw9R+/EdQEZ8OHpRtPGTZkH4R9EV7EyMcEdJUuaT
         gNFw==
X-Forwarded-Encrypted: i=1; AJvYcCXvGpQYCABB85a/13yh9o8WmA1sY3vyPmH847EJIaJNuaMua92lAc8kZHRUYrF5eTT6HEAy2/8n@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6FERDn5kJtQK+vEwpmPsuI3j94a3XcSD5IzrnIclRfd9mr5r+
	EzQWvkJr3H31PQVkhFXl/vOsqRIdet6cu+Vu2odSkpya1nEEizeuOmBcl9L6xeuyrGkEhfJJSHV
	U8xfIhMw5vuTh8AY2QEIJKBrvM/q1bqMiwwvPR9LkoQ==
X-Gm-Gg: ASbGnct/9P0l6BXqdN79nIHotwt2cCeM90XzsDuJj9eKwTke6x7Oj7B5DtprP5trbWY
	XF+pX8gpiYX4U21gLSpmEtCwDab/OPp2eiz9CJTCgmmvoTmrQLrMsZbRk5Z60RWBufvAlcqJHrF
	BBtXWiQLBhc2AsxHAycr3lucu8pRsPvJtE5za2oKqLWIpOVnUVMV7luwv9AfX38LvL4kSn/JJIR
	C7cfpDsmq8m3KN7RwzUtTmmSB3xHsxTeSdNsFXQleZJ7zwgRRZVxyak5v87paGowm1Ls02NsKFD
	klxeiKmoxHiFOg4dR38z3bDjx3d6u3sd/Ljy1lBO4GufprVN3A==
X-Google-Smtp-Source: AGHT+IFOKqumylDC3091DymmwWVMempBrV41yNWr40LgMIQoxbB3YsiPNdrsfBOuzkn9llz2IOW5cx2sNZcESM4Ln90=
X-Received: by 2002:a17:903:2446:b0:28e:681c:a7ed with SMTP id
 d9443c01a7336-294cb5231edmr48006645ad.36.1761658978283; Tue, 28 Oct 2025
 06:42:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251027183438.817309828@linuxfoundation.org>
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 28 Oct 2025 19:12:44 +0530
X-Gm-Features: AWmQ_bn_DPdFHC2JndhMvloWcakN9sV88rkaOQG3xnnYurPT_LYolUnNKN-lF8Q
Message-ID: <CA+G9fYsQ_riqA+C74mpf6-_zoqyh66kozjFrQmAFBfxqvzoqpQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/84] 6.6.115-rc1 review
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

On Tue, 28 Oct 2025 at 00:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.115 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.115-rc1.gz
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
* kernel: 6.6.115-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6de03dd48e80ed63781bdc986cd9895c1172a6b1
* git describe: v6.6.113-190-g6de03dd48e80
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
13-190-g6de03dd48e80

## Test Regressions (compared to v6.6.113-106-g8ed83e981d68)

## Metric Regressions (compared to v6.6.113-106-g8ed83e981d68)

## Test Fixes (compared to v6.6.113-106-g8ed83e981d68)

## Metric Fixes (compared to v6.6.113-106-g8ed83e981d68)

## Test result summary
total: 105308, pass: 89135, fail: 2925, skip: 13018, xfail: 230

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
