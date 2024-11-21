Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98FE1D4324
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 11:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732190208; cv=none; b=DYwGzM+F8ZE6yVQr70oLeaVE5guK7/DeF5XHi6AFYY7+kt6f//chYZ/X51fRqWELM7U4FRep6kQr3E5ydvusCK6cE/TkC5v3zyoahBUbezX0tI9pBfxHVDUrm9blTkqH21Sz1tAsmJ5h1vXApuidcu2yA2ybj2whaC2NON56Xt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732190208; c=relaxed/simple;
	bh=VkGV7Zt+rEd3MMDFMNpRohwhdhdrUG06HHcUUpm+I30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i09xyvA1Y53rYSbB9ZZQDWK9tKXO8ub6EwJluv55lOOAdrhzVkoiL0YUhMs7NJ3oXfupOv0lPJqoROWwQVQ+MHy37qhjhQMb3N3GqeQbNIxNI/MQ+bkKAR7SO2vL4IplQpKCdxNicWoPs9J1ZEdP3AkQQgFbNXA3axYLVLp/e28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AFabngFr; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AFabngFr"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-4add2193012so16088137.1
        for <patches@lists.linux.dev>; Thu, 21 Nov 2024 03:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732190205; x=1732795005; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6Gdo3Vzol5nCNRn6dlVpR9KZyNtJnDJ8NArSZRSKrA=;
        b=AFabngFr0R2V1t9u4cN5sl0jjsmZNfJviNO07hOnAFejBgzt28cj0UOdnmKlfL44cQ
         g0gVcpnqOsXNGWf9oUFvXl2EbBFLKwcKzqO9bUbR/jP2wETmmRDgV5XTRLW4XLm+sg14
         0KR0UnimTTC09keAZ3auPk3WoZnhcOrOjVAg7fCJsd4WneScWiDbINSx1fzNIWNbnbK6
         85wmJgvHPwTu6zxM2SiIqRn6/kPe00qju5+llPSkbsuL0XQQksVuQcc3mubUzsHjnnoR
         VIM2WLfZ13a26APC7M+EjCccIcMeG/Wq1tnHcLKyDqZG2oPsSq410u9JZDKZ72yPP9+/
         CCcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732190205; x=1732795005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6Gdo3Vzol5nCNRn6dlVpR9KZyNtJnDJ8NArSZRSKrA=;
        b=PvQyDRO3M6FUC7p46PEVgF9rj/spk55S4fQ4s6xeAGpf9yzIdlgt7OFzptIH9OQ0dx
         82vd4inouzZ+3vFiCZRRGJuE8smTw80vGQ2S1dDTXaLpPiHmCTwaPLM4W1hEgFDxRQ48
         YYeBox7v0FyAxHGv1CsUhy87WtGlgi+1WFuMdq3onH9E2az3xDSg5dqt/Ic9kinaJTGg
         tGodqWf0fsQWI2Uct2N94nLabINjZ/FwNoVZOzYCTc9EZJtJ2ys7n4/3OkONO2iduAZh
         bjDOxTb0hSnOMLp2s0EQTbU2aJQIAFWG/0TNuBW4sCXsrlO12y4IZWSJ6y9kshcfH3bw
         hlTA==
X-Forwarded-Encrypted: i=1; AJvYcCX4KMwaPGT3b1VpMQzpyv/LGQnPv6461LUKGz4mYP8hvNMx7BJoNQ57WKjZLROPYY1zUOjxoKAc@lists.linux.dev
X-Gm-Message-State: AOJu0YztN8y0tZHq5DGv17xboCTjMdD1/zI67C+mt4E3F+9CGkXpY4km
	JXzErSCdk5Z3DxwfnPbTB6/4ZwLEActV9oqHQvWBpbfYQRMU97yIZB3YSbcWu9MhS8SzqQXiuMi
	+0q0pen0SsIJj+zbRptoQxZ9Z2CzbRmwdVee3/w==
X-Gm-Gg: ASbGncuXxZQ7sdqVcZPXiVMMCVydbYptPHiCcLyZZ4ANa7KD2Hol0JECK3DLjg2dQt0
	iRe+VoZhr9UUVd8QwfMIKcgWkFq+ImZ469lkiIDWpyLf8XnyV/7meYeMTe6QgqufV
X-Google-Smtp-Source: AGHT+IHWx4Ch0jeGqZrv+bKd260l45EkCV/RlRxsXv4mlux6sr5BbBUsPegersHTqKg2s9qYi7j388Ee9Xg4esX0wVA=
X-Received: by 2002:a05:6102:f13:b0:4ad:4b64:530b with SMTP id
 ada2fe7eead31-4adaf4156a1mr7940550137.3.1732190205519; Thu, 21 Nov 2024
 03:56:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241120124100.444648273@linuxfoundation.org>
In-Reply-To: <20241120124100.444648273@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 21 Nov 2024 17:26:34 +0530
Message-ID: <CA+G9fYsuQ_F0H8ByKiNazExpVbPGNrZ8amUoXCjc_njwng2Vpg@mail.gmail.com>
Subject: Re: [PATCH 6.12 0/3] 6.12.1-rc1 review
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

On Wed, 20 Nov 2024 at 18:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.1 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Nov 2024 12:40:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.1-rc1.gz
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
* kernel: 6.12.1-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 11741096a22cc5e52f0cd4cc91f4b83bb848ff62
* git describe: v6.12-4-g11741096a22c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
-4-g11741096a22c

## Test Regressions (compared to v6.12)

## Metric Regressions (compared to v6.12)

## Test Fixes (compared to v6.12)

## Metric Fixes (compared to v6.12)

## Test result summary
total: 137313, pass: 112117, fail: 2757, skip: 22439, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 138 total, 136 passed, 2 failed
* arm64: 52 total, 52 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 24 total, 23 passed, 1 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
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
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
