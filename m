Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D43221FD1
	for <patches@lists.linux.dev>; Thu,  8 May 2025 08:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746692538; cv=none; b=Hd5o+emSH3FtN6tg4bDKnqn78R72L4U17e/yC7gdNDLboj86QFhUaT7geYLblZFJP529YFMFJ9qAAENysXyWJ509QfwJd34FvXq+wArt3nXbBb7SxzaV594bhoxkpRtLuPxuJ22FqvHEuHRzn/sQjmAmIp37TISvD1LZ38IBbWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746692538; c=relaxed/simple;
	bh=XWfLcjDKDI/D9TTc1clgQJz4Ie+db+3RU9g/MnHeVPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rK/G9Az7tzsDf0jxo2ygwjJcWuOwW0ChG83anBY91TwYSo7V/nWnRYWs83n8X0J750yBh5NUFFIt64nUUhWytp99gMlBvBDSooOmuKXWIwGfmztEkzBnIU8j+e2lY5/vnn/JT8Hs7ZPTql385PsT3ftr7N/4QnfOCeQJmtbF0wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ADTdQrOQ; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ADTdQrOQ"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-4c34dcdaf88so218100137.2
        for <patches@lists.linux.dev>; Thu, 08 May 2025 01:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746692534; x=1747297334; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4SXfokFPPLJwoMKncfdiN1Zib++ikD4gCmyzaltHX8s=;
        b=ADTdQrOQW2rSskKJsraRCbZEwC2aiX/CyY/T70F/1aRhtH0UIRYQ6jIDttevBEULZs
         BUvh5qv3V4rK9KGo4y+eMfgtYG4mKsGdlvtLOESvtR6bDLqKsmiUdxdZIcYex3P805qJ
         p0+fZZ1PuY+ZcmYUc/SDgl1rifuq3GvRdI9gtlopOZIFB6w0PhbeaRb9O3qs1xTUbddk
         sgKpkuldmJQzzXHwyJiMS1s1PFXV3Yizq6f4hiVHT8Ny4p17rUT7xfZc+x/PmbdX4QSc
         aWYVDQwcPDOajaXlxcF2amlhBmSNR+sdmVSVc5MM8ac1dRH9uD8oGmb4pTaV5o1RI3vM
         +gig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746692534; x=1747297334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4SXfokFPPLJwoMKncfdiN1Zib++ikD4gCmyzaltHX8s=;
        b=N30aEwbQ+g960tmSMHZqKCRO8MaibFAqAw4xLuWnz6IbmLXKqkBLNPLd7pyz5WSrua
         ncrCSO/dqwN25LPRw0vXZ8LGHSxd6aUPTAdgE3r9yjBnAWfgWL4TwwbtaH0XFt8j7tcw
         ahJ5nI8RYWZuubFHpTBA+6T3KxKzQKPPFtbc7uhKOYOCrU6B3hFgckAwP1s7ZU2L7XH7
         poqaX/jrtMzKk0vQ2Y4SpN9IBnhnrH9KCOKKY6olOa8xmPyL/pRmWWx7ku1YVbkYO+IZ
         NUqqF+iEs1dTHt8LUG8wYYwL6izLc1oSc7H1/6GRN21pR0zIU92nXEsweQDQ+XlDYu03
         SNgg==
X-Forwarded-Encrypted: i=1; AJvYcCXeTpF3pZzfIa01DbRu0q+GW2RuIoDQI2w0ILJGm5gYtbX0TMMKJh7XywY98EMhUv0psQQHr8+7@lists.linux.dev
X-Gm-Message-State: AOJu0Ywpj5ioNOX2Ja8SouR6ZNqDspHIbroRy2zRlgyJAkaZmBsRBYyj
	nhqrCmA+xBQrGPscM5LJfQdScXC3H6b0OKinb4v7yLXW9M8yH+q+/Ao2RZSUR8kw1cPhPbihVgs
	ib7mvbVsDP/kRtSFmlFirwaUfCq4/HOpqFKOX9w==
X-Gm-Gg: ASbGncvSSyJVqmnKCxm39lOKtU2kgQ6PRRHq02A1PH/NTP+eArf4VY+Ar58YghhZPeq
	Kco/62KSqPhF5Cxq7V88OyeNPV+3dHdtnPzIO7P1G2teOVdkBvZj7S0Spfvl8KtmE6h03lWmjuT
	ZH5DRkgPGuk8SqHSfV19kFn0W3vnqr/NF0xap5SvvKguiejELnK0QvJ1g=
X-Google-Smtp-Source: AGHT+IHlylVojaFVxlpNw0MP0NVcwjPbv2ez05UaIZkY1iM/eQuqvcRPbqM2LAtJO6AS4BNg/KZaVgxZfCYEVDeRey4=
X-Received: by 2002:a05:6102:5090:b0:4dd:ad20:a333 with SMTP id
 ada2fe7eead31-4ddad20abc1mr1297672137.10.1746692534570; Thu, 08 May 2025
 01:22:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250507183820.781599563@linuxfoundation.org>
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 8 May 2025 13:52:02 +0530
X-Gm-Features: ATxdqUF56HpomFLeHyAStWrs4gBJAxYiq8xr1FI8Qqso3ZFo7BKUuCQKs_K1faQ
Message-ID: <CA+G9fYvR12QXK9+uQYu_XiiH6AtyVT-Z_yx-f=1k0V2QpMGsCQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/164] 6.12.28-rc1 review
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

On Thu, 8 May 2025 at 00:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.28 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.28-rc1.gz
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
* kernel: 6.12.28-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 483b39c5e6de6bcb0adeeab81c10cac4aa25f8ec
* git describe: v6.12.26-167-g483b39c5e6de
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.26-167-g483b39c5e6de

## Test Regressions (compared to v6.12.24-499-g990f4938689a)

## Metric Regressions (compared to v6.12.24-499-g990f4938689a)

## Test Fixes (compared to v6.12.24-499-g990f4938689a)

## Metric Fixes (compared to v6.12.24-499-g990f4938689a)

## Test result summary
total: 118401, pass: 96123, fail: 6121, skip: 15784, xfail: 373

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 16 passed, 2 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 42 passed, 7 failed

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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
