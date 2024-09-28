Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B697A1862BD
	for <patches@lists.linux.dev>; Sat, 28 Sep 2024 12:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727527475; cv=none; b=CERCoygWKzp/G9Wu3H8cjHjzFT0ty2jrkEnn4yIs1o0H5H4IvIwDCEOg5P3ykX9nWBb+ftL70Obhk17uo5zf3MxisJ+kv3C6fgyAXX3mFT2Ap3dLCafnl88dVR2JBqyMwk/7HQyMtJ8+66Lnsn4uEA11LpvOP7iurpmibRFwZlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727527475; c=relaxed/simple;
	bh=GO9Kybgme8G9ShcZhWU3dKPy/9DpcB4TGRFTg/mb2OI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T0XOjTS7uRYXgR2BBiTxK7pBT30BkL6L+c4ezyCbukm/WtydwJv8P9uhRbZyGDlzsqMgPTZoBb89g/Ox77E5Yn4kHUC32vdmQ/VfJR2wsPtw9I327el1e820nFmlB/ufoO40Ocz46TruahmVo54XgCmvhLxBsO4sUAVDoX7edUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ch65EBiT; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ch65EBiT"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-502af8a83daso848974e0c.1
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 05:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727527472; x=1728132272; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bu8CwGpH0zPsgWS5Di3OLTvt+aEle/prlAhM72/hucg=;
        b=Ch65EBiTkYwACysaZbn7T3q4m1bAx/P+pK85X6KdWMshNEdf2DVGNhVpmTuFCs32m4
         DrjqRqqE2GE8OkzqezXYd0Yy3XRnOaLlnuKSdVlkyoKxa1RFdJvrbBkpIJTDnZME40IX
         A1CYTIXyyl7aGRJC1KMatYUj0EXK5kGLAInEU2gqPP3mqJU302+u73/M1Pa+WuXHSnCW
         GpV6cl25cY5ljvdzYhhkHe2jiOtAWjch1k/1+xwxZng1erK7RruqvXC2jgoTnup6AWIz
         oo9MSsAcTyYI+M8AfRg5wLwgHfEqrCeN63k2EII1+S8Dm17+HnsfM5Z21ywWLZs229Uv
         l1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727527472; x=1728132272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bu8CwGpH0zPsgWS5Di3OLTvt+aEle/prlAhM72/hucg=;
        b=I6Ev4CMPERmuJ1lpeAUEkc+QZaTRYaZtPmombMjufUQkpNd+0WTxIRMbooO2fZ4u+a
         99WEOEK+9jZJw8Ic/EUgnzRt0W086vB4g/RlOOZe+7lLpbOeAqVtV4rLBlBks8h3oXpI
         7mR2GCg7B2zoe5L37ROTIWU8PqAfTMeKrFZ9SDDBIz883Bq63dST214L9PMO3G54RJbR
         JFGfaSzfCBUjBBk9mjFjmiwZZd05lKIyK8wcYNoakPd+7bowWy9aBQoGVccVYIJsNVIK
         CgSQJ2gNGF4whVf8aeRcV1tMlJ3etGkIhGxOMQhF9vLAp7pckCpQWOAr2K8KaYZGQ32k
         SGPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmIkt0RGwwa5sGJDc8Xj9LB3r6tLJ18wzDVu0AhucskV3p4oQApDqxj2A3En4n499Fbpk/cE+A@lists.linux.dev
X-Gm-Message-State: AOJu0Yy85admT6D0fH66qTWFe/n563/uQL4WIpnlbEYv2c0yB+VjJP14
	cyD+RE0mHqQMsfg7LYR4KxXfE2sROEK8vnj+J89oWPeLOb29pnSV6IgmyFajowMMEBsoJBEj/tf
	4RWveG8mf1ojfagWqeeC+qi9sKgNKLDo6sbdrAw==
X-Google-Smtp-Source: AGHT+IF7wCbv7uEqQ39Y7mc7iT4ZkeoJI5PmT1fxWR7B4sLvWW9MW4Lvyr3+hiofSGbveU7pB2oKctHz9L/6YWxL19E=
X-Received: by 2002:a05:6122:3b0e:b0:509:e278:c28a with SMTP id
 71dfb90a1353d-509e278c998mr134507e0c.7.1727527472570; Sat, 28 Sep 2024
 05:44:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240927121718.789211866@linuxfoundation.org>
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 28 Sep 2024 18:14:21 +0530
Message-ID: <CA+G9fYs4GKpXUSFUTage1LDFngjEGZFrWfMMo2oBe0wuWVPUBg@mail.gmail.com>
Subject: Re: [PATCH 6.10 00/58] 6.10.12-rc1 review
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

On Fri, 27 Sept 2024 at 17:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.12 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.10.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.10.12-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 8b49a95a86047813f754fc406afce23ef0458caf
* git describe: v6.10.10-178-g8b49a95a8604
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.10.y/build/v6.10=
.10-178-g8b49a95a8604

## Test Regressions (compared to v6.10.10-122-ge9fde6b546b5)

## Metric Regressions (compared to v6.10.10-122-ge9fde6b546b5)

## Test Fixes (compared to v6.10.10-122-ge9fde6b546b5)

## Metric Fixes (compared to v6.10.10-122-ge9fde6b546b5)

## Test result summary
total: 231568, pass: 203991, fail: 2025, skip: 25083, xfail: 469

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 131 total, 129 passed, 2 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 6 passed, 1 failed
* x86_64: 35 total, 34 passed, 1 failed

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
* ltp-ma[
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
