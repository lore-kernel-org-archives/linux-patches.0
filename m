Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFC01E571A
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 15:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738338599; cv=none; b=kTyVJ8YnD49n0Vgm9ZyiDbMFoSTW5A4otI5/t4ExQTTd9aSR3lR0BOJhoscxEMX3ejOEiuzVXOwuE2A9hxQmSVjDHC9/+4Guq9imiHBVjYUYcKoFJVtVrYbQ6aH5bc6AfnoIR/J2vnWAhyI9AQxq32txtpHWMaqulMBc+aDxNKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738338599; c=relaxed/simple;
	bh=o2eVme6LWBzp3TARLj8ZVEg5e8/pMmtAadvIJSWcjeo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JTueb7bx60ZEyBI0azxoz4bNO9DHdkEHS2Br9dC8gYEw+PLi8XXnhZqAdSIDCDKLyxdV8vL0w5KZ86mlbf1VvW+ud3v6VThG5gran1Ju9FjZHmybEUi6DYyvW38FJP5+4kih7/L4/BJOIrtyieA31Qp39Trn0o7VJhKE6IZhNeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gSE2U5kq; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gSE2U5kq"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-4affbc4dc74so1351154137.0
        for <patches@lists.linux.dev>; Fri, 31 Jan 2025 07:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738338597; x=1738943397; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWixQrVCIAlgNIcS80jNJtJK73gPxHWL9wIx8DKe7MA=;
        b=gSE2U5kqCbg7YiafRJpMbKkW+1X9UX9E+NaFYl+TPOgdHvhF8gwOYhuvEKivilZi1J
         NcxUZ9xfo0HrublnLebbWcwZX0Gw1rHXYu/lP7YX9TVS63O9qtzu10R3LkK94fbBpU7N
         Dp2kk68hP/5ZkXt/No43rggcPRfo7f+MjQd58h+EDsXkW7cm9BPGDGa8GxTmbeThyoMi
         t1UTSue9VpsjywUUgUQravg4DnBAlla1/Cq1GNcQD8ruI8wIAR0eRFkva+gfda3ISVQN
         pKqB9CHFpzs822LJm4saPP4VDg44sERFECfhplvdV9wyv1RDDqlR8j+irzxyRdIrVrRR
         JF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738338597; x=1738943397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VWixQrVCIAlgNIcS80jNJtJK73gPxHWL9wIx8DKe7MA=;
        b=gzIZt/NHQwfc6z08WgXGFPNvMCstuNfp2A5RZWRzfbopYCn0pLwXvvqbhSGlUknw6+
         hZkFO7gDhuqce7yrws374IDJlm4iX+fWHSUV0k853QfVAvgHQ/+FHPp8g8CU6ET+6LaV
         Ay4eXPLZsw5w+FDInr8xm+mdBpbnHkhiXVSoJdPk2HtY6p9JHIoF3+OtaVXIpF6qQjxn
         SGgCLOH4ONkY4Hsn0jcLHJcRLvnPrM91vM0taKiGL8SBd9hkr2UwxbDM4tXxa1aoaPh7
         IhMR3wIhSmu4HLU3RpR4dPjang3CjYDCtr4gJukDOboqKxBynnlS7u9VqP4A6W2lWLPh
         XpkA==
X-Forwarded-Encrypted: i=1; AJvYcCWTCdH80FgiyEsTgiSadWIXAakl0FcovcjYIeQ91++U3NSaItTN2/ejunDzU9cM3zr9O9CXBCA5@lists.linux.dev
X-Gm-Message-State: AOJu0YzgGCjXDY881USgHEplMfDi82s21mz8+TWN8fujoXM0SV05IroF
	C5ESaIT1KyXl2COHTRyJZItd3m8aFPLm8lszZJkwI0xxmrChv9QZM6LpMylIUoVY0FCxVmtocQ9
	njqs3A8aokXh6bbIuem308p6HaNq0nYYMNrN++Q==
X-Gm-Gg: ASbGncsF4ca6Zr9gZNm/49YtpFbnIt5kHYpsXVwA1wbC6ToadRfmXaSInxYHAUhYNiJ
	aMyBYpxHiaNsZnQP3v81fHe5uYgdVjjod1tKugY8Ht5MMkyR/59SyFjDihGg3Ike0iUyx3B4ZKs
	1cEaVYPeKHBvU5DMrSh6AShWDSOmn96g==
X-Google-Smtp-Source: AGHT+IEmU+ide+wPljEknjlPcnDS70VvV4gNHBQPkhRPBxsv4r+mkc3GijgB/cew2sz29EmYjuvDKwtPUTAI7Moscco=
X-Received: by 2002:a05:6102:510d:b0:4b9:bc4a:bf48 with SMTP id
 ada2fe7eead31-4b9bc4ac3b0mr5004678137.21.1738338595383; Fri, 31 Jan 2025
 07:49:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250130133456.914329400@linuxfoundation.org>
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 31 Jan 2025 21:19:43 +0530
X-Gm-Features: AWEUYZmgHq21FJCqLUpH2YZWV0iYRhsBr_y3qwk_JndElOm_h0vSyasAEF7Z5l4
Message-ID: <CA+G9fYtJjEoVvJtg=DMXZGOaAXhiwYzGRu0JFkWpDpBSZhDmjA@mail.gmail.com>
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
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

On Thu, 30 Jan 2025 at 19:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.13.1-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 65a3016a79e2da6e613c74c51e580ff1b3ad1225
* git describe: v6.13-26-g65a3016a79e2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13=
-26-g65a3016a79e2

## Test Regressions (compared to v6.13)

## Metric Regressions (compared to v6.13)

## Test Fixes (compared to v6.13)

## Metric Fixes (compared to v6.13)

## Test result summary
total: 142397, pass: 92519, fail: 31182, skip: 18696, xfail: 0

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 132 passed, 11 failed
* arm64: 58 total, 56 passed, 2 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 41 passed, 3 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 49 passed, 1 failed

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
* ltp-np[
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
