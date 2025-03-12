Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0331DF735
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 10:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741775597; cv=none; b=Pry+x29OgieSVPht15bMP2T96ro7fPbZoG8BaAiE9sKoWrBzy30moXA6nDDxbjVX5kzoIEK7UmHwEJS6y5A7GYBB7PFYykKDhY/CQDS0ug7sitKx1wnJRG0X3Vm3Q9ZHAZPZpBhj/WZZ/EGFSwhqflYZciSlSbFXIogYkAgQPVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741775597; c=relaxed/simple;
	bh=OxNjpOJ6VfzOUaMrWleIBMA1ReLbN1SeLEL4b38qWME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cmTpO4wEwtW1V9h0uNgk2eZI+lC1eU2O6/mgo3oweuVreMqtOwRxqXrzKZVlyhzN684fP5Yzqfc1d8guTjNBSZCfsi3HuL6Lv+eQPQGzXe+uQODPh955cGnnmP6q4XmX2G/s1Wm1gR9OWI3S2T2oIR5Gf6xgg7t4nzlbmmDPWrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Hj4/S05f; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Hj4/S05f"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-51eb1818d4fso6676694e0c.1
        for <patches@lists.linux.dev>; Wed, 12 Mar 2025 03:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741775594; x=1742380394; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KM0MvCdNVxzxXgBH2Q5bQqwEpszrc8WPfw4cYOnLhIo=;
        b=Hj4/S05f9Z9gV/FYN0c4YhFgNcYFdcKQSJvv+zXlgXW5ZC+uv1Bg8UytbuX0Qdtpla
         TwEcQSrBuV0WAZkFC9IsCruSbb1+OVEa2Y4i6gRVYkzykPnQWu3mVu5rF4dFaJT1IKe+
         A8ujKExd8iPOCmA9J8KSiiIgDSKH87cafmXYVJvzyKYSQ0mWFU2PnuvUZChikVRZhUjv
         Wcg2wgbDbQK7UtDPqaeUksqkTiZKDIqwkYhhxXL0/uslNWk8L3ht+UUevWqbFLyoeaMA
         h6Oq1gtH4QfzJfAZgDF+BgHq7fKkxVsEnJ3QF7ihq56ojHa7fQLK/w3dZct2gQUAIp6X
         yAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741775594; x=1742380394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KM0MvCdNVxzxXgBH2Q5bQqwEpszrc8WPfw4cYOnLhIo=;
        b=nTUtCPxlTUJWsoILnNBsBzsRbhpB2q5rXE+x3j4R+GAk/ZGUKA80Wy4k7jJSorvSZk
         ga2+7Qyg7sEeBKeYxMoIyycxmoClTZPM3pvuOK1gR8WxeW5BxEor51FkHUsYFYITgXFk
         PRWERHClatgCsvAI+0simgUBarxBiMdyfiFj54PxF0fXw+klZ48D3pjOCd27hwLExIZK
         r5ELyJCbifoMqrtXeq6gm8cvaIkvZ934tTTY3aou1sAz8LSxKbQrB65zdDdz4Cvdpatf
         bXnl9KaZsh8JDS9+tuH5jPGGDvaCdtih+laYHpOeRRpWxIua8G0BezGU1WCo+mCmmE3b
         wWgg==
X-Forwarded-Encrypted: i=1; AJvYcCW+5lfB2y7Vii02KV1tHTzPJUM1W6KsUKEfJdNaFv0lpbPZqLr0MFx7copdXfmYdPlo90eua0JU@lists.linux.dev
X-Gm-Message-State: AOJu0YwTck3yd2tCNE45jUBBpfIlQB0C/6IUJ8XopHZ7v+Pf2J5R/6Iu
	6I9QYVkBtxPwdUcwZiXsKDhWtPLK+sS5KmMtWQ2uOvVVb+x8uDqX/cFRA7JkPt1gZQMfeRsERvb
	E0aMnh8Htn+jNatwl1MIZtelOCyp2wP9PmHRcMw==
X-Gm-Gg: ASbGnctz0e+WsxanPZpMAoo3/XBPi991xMwNxo5BezRJjha3LNyQpuMxL6LcQT9H69i
	EFQy74TU4tRk6Uvxl2QqrKkD8sBb84r+H5NxVoO771f74bpcOLGN3oqrRvuaJZJO1DYHkBiwwDC
	f0cjiKDNx8+sdERu+2PRpbtXJMV5Heifp6arguIN0xTDKzF+lFJECBkFC8CGk=
X-Google-Smtp-Source: AGHT+IFlw8H9uqBvw9xXA5rE2InxUbS79lI5zq6VR1c4tWkxgj7QEGwJsPaP1vOJJJKSz6buJDR0kzLt/Wt2JZPh3lA=
X-Received: by 2002:a05:6122:8297:b0:520:5a87:66f0 with SMTP id
 71dfb90a1353d-523e3d8de95mr13152498e0c.0.1741775593628; Wed, 12 Mar 2025
 03:33:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250311135648.989667520@linuxfoundation.org>
In-Reply-To: <20250311135648.989667520@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 12 Mar 2025 16:03:01 +0530
X-Gm-Features: AQ5f1Jp-kXQi5W-EyPUYylM5Jm9lw1_VYlNpkYa3ZexnBwthVaba4bKA-pk1Paw
Message-ID: <CA+G9fYs0W=2xDtFzNhwg8pipi_iXiEZFNvD4tz8stZL=1fKWAg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/144] 6.6.83-rc2 review
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

On Tue, 11 Mar 2025 at 19:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.83 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Mar 2025 13:56:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.83-rc2.gz
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
* kernel: 6.6.83-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: e7347110295b72c0d0c942ed260f679edf70f859
* git describe: v6.6.81-152-ge7347110295b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.8=
1-152-ge7347110295b

## Test Regressions (compared to v6.6.78-442-g8f0527d547fe)

## Metric Regressions (compared to v6.6.78-442-g8f0527d547fe)

## Test Fixes (compared to v6.6.78-442-g8f0527d547fe)

## Metric Fixes (compared to v6.6.78-442-g8f0527d547fe)

## Test result summary
total: 122461, pass: 100025, fail: 3148, skip: 18798, xfail: 490

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 46 total, 42 passed, 4 failed
* i386: 31 total, 26 passed, 5 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
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
