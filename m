Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C59015E5A3
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 11:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717760920; cv=none; b=S3jfZNiaRjy+far6/9SEK3HFDlSxH0Z3zu7/hbcAWcOmLAPyoJMMOAk4icbasoxn5emUmh773QjMhd+ABl8kINjVpRWNoK8hGSED9g2OhzXwZYdAEHiPwanzI60c7s7mNI6GTJu1IsgYHpBbtZlEegSCf2ysPwb7M0M66BK4qYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717760920; c=relaxed/simple;
	bh=PeHkH+NfrrKJoMuN2ygAp9EcFcYtXM/K53hPDtU04fM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ho2KzSiIpLarPjvszV1BZNzpAwJYlgPsGdG96dytVqv6PY8FoywAJQdspCIb8d8rSv2gbq7+dQdYwVHZD2FaMYH+OOJh1UgsI/SPJkRZgDaAeFDShD4vC2GZDCmnkA6csM6Y8fRFjLm0ORnv1f9oWP+/COvIEu7wSxeNTdv25EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QBXZEa/R; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QBXZEa/R"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-804efaaae87so665449241.0
        for <patches@lists.linux.dev>; Fri, 07 Jun 2024 04:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717760917; x=1718365717; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/5wtcce17x6OATn8wPdogmtY0ka7nDOqTZMDuD4ISs=;
        b=QBXZEa/RGC4w8lQt8ktQa/uqOxlH9RwAi06Wsp0kBCVyo8gMC+VqsvSjIloPSqjbC3
         86sVyIFVr6S6nhcora/C3TIeYMkr6vEgEmTLvqfn5psQUEzJ+W2Yvvtee4lwPYgTFih/
         2CyCeR04qaGLs2/LrcidSExuAi8GmZVzKDr+Se+4nXkddD87Jepwt4YT5nwA2eBXs0wN
         9pCKBpZgyJzjuAsMRII1/JXjS28fhvd/ysaKiRZrTja0xWsyrohlaMSE9LVqEDwsBfic
         CXwTJsEd0A96FOWQMm0fZqMepfbhEQqinewRmXzGbNqjk2V6TBOSFvOGWdj8K2FI9Ndk
         HnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717760917; x=1718365717;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V/5wtcce17x6OATn8wPdogmtY0ka7nDOqTZMDuD4ISs=;
        b=luIsIeTAfCBGXQR5tdQp8NVSTnnSXEVs0wl9Eu0Qhob2rWObr+gBaUdZzqBXeK9L4p
         UfCrPbJj91XX9tlmS41SWFhLLXBXVz2xkc7dgiV3tp5F/WOuMYYtt1AmUwjH+oPs6zYH
         teZY5avrx9woPD4hpWIk8QeIQ8nzU5uQYPlsrrvhVefofALkCtlvQmLsd49T4ckPzF77
         KbaTHzWzZlHuoFQDlFfwCzfWReILClLzEGlcbIzt7MOsGfAXooW3FeV8UjtXWOqLKP+i
         atp3NLkOpD0t86CyL6bj2rSI/PBafiRcGH8SQe4QlCFLXxU3MxyHNhHzrULpADDCkuk9
         B6pg==
X-Forwarded-Encrypted: i=1; AJvYcCXpCwpK6HZPvJWWUPej9oTOxNsKmZzww1d2jAROZ0wOZtKnM7avluYUoBQ+sRFGyCylpwdRxCKC0p4MuB7O2H73JKmpf+xT7g==
X-Gm-Message-State: AOJu0YwyYsePqxZHduquuFblojKovKCDU/KzN0f0YY0snbYBTOQWzFRu
	31SjmHGH97qXVVSyKsZMN5EyY97LOquJjMDLwRV9smtMqzsC1ylAxvSBSLBtyCPFChzVulyXzIZ
	cV6DLlICtQdIYZb6fZui70v4uOZGcjH7pZMKR8w==
X-Google-Smtp-Source: AGHT+IEdwmO0c+MBu1y4ofqEbQghy0qcz8uztrknpjZTw/IJT0CA0vI0J7TGrTqdcGE88Tlz0cCpiu60YEjDyFoXYrs=
X-Received: by 2002:a05:6102:4a57:b0:48a:3fa5:b832 with SMTP id
 ada2fe7eead31-48c27538f02mr1869372137.33.1717760917249; Fri, 07 Jun 2024
 04:48:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131651.683718371@linuxfoundation.org>
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 7 Jun 2024 17:18:26 +0530
Message-ID: <CA+G9fYvOP-FL7w55vPig3p1iva_MAO+sqWnh3ZwPEopd_y-jow@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/374] 6.9.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Jun 2024 at 19:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.9.4 release.
> There are 374 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.9.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
Build regressions on Powerpc.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.9.4-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.9.y
* git commit: fcbdac56b0ae848d2259d6b9825f289688a77e0b
* git describe: v6.9.2-803-gfcbdac56b0ae
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6.9.2=
-803-gfcbdac56b0ae

## Test Regressions (compared to v6.9.2)
* powerpc, build
  - clang-18-cell_defconfig
  - clang-18-defconfig
  - clang-18-maple_defconfig
  - clang-18-ppc64e_defconfig
  - clang-nightly-cell_defconfig
  - clang-nightly-defconfig
  - clang-nightly-maple_defconfig
  - clang-nightly-ppc64e_defconfig
  - gcc-13-cell_defconfig
  - gcc-13-defconfig
  - gcc-13-maple_defconfig
  - gcc-13-ppc64e_defconfig

## Metric Regressions (compared to v6.9.2)

## Test Fixes (compared to v6.9.2)

## Metric Fixes (compared to v6.9.2)

## Test result summary
total: 139061, pass: 121356, fail: 1981, skip: 15724, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 126 total, 126 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 28 total, 28 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 22 passed, 12 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-exec
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
