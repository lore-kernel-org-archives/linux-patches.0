Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069DD18C039
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 12:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731759858; cv=none; b=mhVw8q/7Mi6nRYHv5jpncrPltZZoeb05cnzTkOYGba6S997Fc5V5J2NCssujh3eF3GuWYQtF7kN3IVF/ub9mgRERCa4oSoxhvfqF9fl1K2JvG6tjYW7m6hQ/RlVthn01wiRdXG107SVpXxg2uUjEJ8eNF0MCLYkquZyENNZUaeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731759858; c=relaxed/simple;
	bh=bYULgciyCSLuULT5+I/Ayl0l74K+ik5BB6SCvfsZi9s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aWatfsj3v6Yz9CZhzatauUiA7iAItPF4BSADh0QbJLCKO0LppmwAg/hPDGg8YflevfXvmj6pJx4kXsZDZs/hyN5122g3Wgbu7UWXEIZ2pSYNIcoxw3nIsNywG22lHna0OjorqGlZsi9Ug/ljTyY36r2c8laszicSVwJQ4p+eXb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qJIbvEtx; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qJIbvEtx"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-50d34db4edeso1929558e0c.0
        for <patches@lists.linux.dev>; Sat, 16 Nov 2024 04:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731759856; x=1732364656; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7nkGHtUc3FIG3ky9xeRxe+zYPSC9XJK88GiAX9MyBb8=;
        b=qJIbvEtxtHEeCLqK4Cu3bn2eGxajkMSo8emoRsOaj1/nzpE2sPDFXurgaFAXlJnbnH
         WxbvjFunT4r5ZqPE8t5iI2kG26z1p3j1oCG5qEO1UtB1LQG6l8QPbggmXCoIHkJPXQPg
         4GGb2gBiafPI1Zym31QiEVbk+Mis7wBs9qDXRci6DlZikh4nx9lbakTDb5lcoHdqOzP0
         V8DVf9RaoNUSoNca6DfXlMDljoYZiGld/StDawI4UkffHrtgTUkr2JnOJrBJP7IBufHe
         Eq1AnTgfgZnbWa1ueTzvn+gHgw7kQBpV2mTi/9Ww5GNn7zr45a94u7yNvHYoytIRTiPp
         KbHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731759856; x=1732364656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7nkGHtUc3FIG3ky9xeRxe+zYPSC9XJK88GiAX9MyBb8=;
        b=AVvxfhSCJv4WR8kaOfZ+o9Ca0r+7+HsY/op6PvYYVL8txH88Wg+KW51+9N7nzw2XjM
         zZ8RxswMnEkpMrSSj9XuukhspoR1cYpBEdf7dyQRI6LPcVclWGL4L2sP8X3VA5o0vr9L
         i8oNfV/DU5YjFR0GmE/f2lTbOykfp6AAGh1i+eiCPGNUhW5p+Q9l7qKmGbqSLIOPN1+l
         F9kARqy60de6T5QEAGptOOQ+KxmCoJF335v7Qmrm9CR8bXpFefYfZyooFzXbHHRsp1UA
         kwvzMHrPjkusEn1uVXdYL1N3auw+kCe2YWQg7BiFW/syGb+FLH7uQYS9v4hEneaIKE7R
         xwOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWD/EQrxs8GAQKkfXMIyTQBVTQLdEKGgFdkrj1OwUmedsZuBUfJUj/yM2lNDYqKhFY60sY/BfLm@lists.linux.dev
X-Gm-Message-State: AOJu0Yypl1wNL3i9/3XS3zyfYx0xLWX6HtdtYhfhpTGf8/HCTX86ijwO
	hzIXMKtB6XGTWR0GuItbyEwamtBl+mqPrxy50IkxaL2rK552S2jJMDCQ7h7HPYxv0PD9ntD9rc1
	DQ+vw35eSF0HDJxrPDmdjlddLCsQy+Q7fmY41Jg==
X-Google-Smtp-Source: AGHT+IF+QEjMi9DU+ScDdeDqS7AuB6ZeLuFW2i+9eWgNGHuQFxoMRcnobhp2pxADVNb3i+KK8LIvVS5C+8O6XhOWiBE=
X-Received: by 2002:a05:6122:1d52:b0:50d:4bd2:bc9b with SMTP id
 71dfb90a1353d-51464ec51f7mr13430686e0c.0.1731759855932; Sat, 16 Nov 2024
 04:24:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241115063722.599985562@linuxfoundation.org>
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 16 Nov 2024 17:54:04 +0530
Message-ID: <CA+G9fYtKyZtmgoxM+wNws=9WZFc1eMJuM0H0RQoAm+BgKfkSNQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/39] 6.1.118-rc1 review
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

On Fri, 15 Nov 2024 at 12:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.118 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.118-rc1.gz
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
* kernel: 6.1.118-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: b9e54d0ed258a28241a31fd3e9830c7ec6dc7124
* git describe: v6.1.116-139-gb9e54d0ed258
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
16-139-gb9e54d0ed258

## Test Regressions (compared to v6.1.116-99-g41a729e6f9a9)

## Metric Regressions (compared to v6.1.116-99-g41a729e6f9a9)

## Test Fixes (compared to v6.1.116-99-g41a729e6f9a9)

## Metric Fixes (compared to v6.1.116-99-g41a729e6f9a9)


## Test result summary
total: 113780, pass: 91019, fail: 1946, skip: 20718, xfail: 97

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 134 total, 134 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* i386: 27 total, 25 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

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
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
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
