Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F70B221FC8
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 09:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760173206; cv=none; b=Z0hI74gYQwJdugMpdZkmKkZCR/WY8OqoCuXMFIconzWUjRbifmwxQU7NNHLDnRbjcnUB6Vt+p4B9LL3eQUzgWIcy52KbDZkZSFx5uxi/Q/9ykT3v/oPtN2pPGlr4KqkfnmwLrPIdHdzKO2h7JSxyuASqD71dxXOjGIRIlgCS4qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760173206; c=relaxed/simple;
	bh=zuajZvg1GfmhlxobaMZIGMtoZrguMr6AvFfamYTmViE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nSbPli1Mw1LiP4vZ1oIvPQlLEQ9wE8YudCRvUALUaoBYU0V6YhoOUGPcZd1+jq8fmdLxDo6YH1iA+NpWjBdRhBxe1JVWC9l5jKwEtFEjtICP03KSyL1Or3k8LmL+U5cPM9iIyVKF/LyY14orqOm84Emj0Sr+mkCkYjbEcM9lrPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sTTj5TeG; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sTTj5TeG"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b631b435d59so1814076a12.0
        for <patches@lists.linux.dev>; Sat, 11 Oct 2025 02:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760173201; x=1760778001; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mb7NVdVWR6Oqus/up8k+fb1OsLddvjLBoX6iFlO25NQ=;
        b=sTTj5TeGaXFPy1wzG5ChS6toT+1kLQjKqkH9wcJJNBD5nZqPM/tb4muVuYr9zFwxa1
         l6voEG+4woq2llDRyhzflzBFpz2jcSviZ2zsUQaKK/cN9ZeZ75J2fwHhZ0UD6hZGJycN
         KHI0vZ8xe2rt6kDjxCR1VfZ2qvMIMeaFLqFuU5HY7/c5D/ZUtuMD4ey8dXb7b0p/iKyY
         0ZupPf7+mbKaGu/N1y/fjLWBAzM9DrDFEOvbHtplDPw4Oj6Kv3eiO29bo/NlKdXSOrAV
         qIQYdvdqfmHGSeZ/H8KLkVar7AP0ZtWZKK73Mai7TGNVPnNKY2pWRW9FGpk7pNd/ZfuC
         iCtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760173201; x=1760778001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mb7NVdVWR6Oqus/up8k+fb1OsLddvjLBoX6iFlO25NQ=;
        b=tVkLm9C9V1sAlxlUnanmiKPPHqDkOaOZsqx6k/b00CuUD046Mn2zbvYxodyjI7QnEn
         NyLrMCVW9NalDMiWxnzYwZ6bMisZ2UC44T8CClrdl4W2PjGiQ7VYoBjxWhzAoj/j0t5N
         k6a6hqRAqycfvVfMBdqptwxMJzUQ5qa8pX2uiWmda3Rs+KLexAAidyWPCplUuPCWQgd7
         TCq2mrwsDqmgp97gsJVPr2vFTg2PG97GOR/v99vIrF/WpC8KBmj0wN5LkrJerGmkHpOi
         iUgWrNzb3ywvWSIavgyW6lP1IsXczjx9YMWQ4KgnKhY4MTm4BQtr2HXD367EKfCI5xh8
         QaMg==
X-Forwarded-Encrypted: i=1; AJvYcCXrYFpTVcBp4GwP/2jPoMX4EdjN+cuRLgxumanreV7YYnSTzTdV7Zj1zzdgUe7kYpo4YwMNHkuh@lists.linux.dev
X-Gm-Message-State: AOJu0Yyrr0n5rWWsZOStsocKVTevTGq3GIEnZDH+V9W1i7jOn7o5pgnH
	v1NZoXJ8AiU6RB/cMpV1L+qyHeJyg5vCi2nlQa+MC5NTZ32MbAkx5dakk8+9I4TCh/HNKCGGNS0
	XIZnxHzPkXJpAaJqAHYEReQ0VKonFtL3nDVuAt9m7NQ==
X-Gm-Gg: ASbGncvI5tw9+Ha5JbH10snuFr1dwW89xhxnTPqkSiq8vi/VQctbhZACOUoCJL5xIf7
	IxZrCrpzTKM0fgIMS/wnTX3PA1+XxHNv1dQ2bTn+Z1Q3Z5rElaGJ171NIo6ZeO5ph0R7zIkJss8
	o2F2VbQHlBm0ePlNeGoHzd1QhkYNFuT2DWbWvmt57iEnHuPa+mx0xhUiyN8DOsCQXsdzJfOybz4
	svJ9D2+Xb7VTfIadpG02l0CAsulV17l/Z/HdLMJOvl5qNYAYWoi6lb4MCk2UqWwwj1O4LTbsDt3
	N04l+qsOL0lUecWdgA==
X-Google-Smtp-Source: AGHT+IHIh+NtbdhBJPGvp+PdsKgznE3j6MW/wih7cdcg3jXx7CDE5Ab8+HYyON/WjHGgLkjljP/zfUAk/pZ0KlbqthI=
X-Received: by 2002:a17:902:c94f:b0:271:479d:3ddc with SMTP id
 d9443c01a7336-290273748efmr210402125ad.15.1760173200610; Sat, 11 Oct 2025
 02:00:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251010131331.785281312@linuxfoundation.org>
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 11 Oct 2025 14:29:48 +0530
X-Gm-Features: AS18NWCh-0xz9_-woYeOmtt1_Loq4Or6bloaX3lxvECbB3fpRYG7edD9-6QdfCU
Message-ID: <CA+G9fYsgsDXS-x7eV04QS0dpRcA2fWKHk7GOgcsQs+0UT7kgAA@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/35] 6.12.52-rc1 review
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

On Fri, 10 Oct 2025 at 18:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.52 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.52-rc1.gz
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
* kernel: 6.12.52-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: f7ad21173a1934329ac5bf0c8b5443d5666d3ce6
* git describe: v6.12.50-47-gf7ad21173a19
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.50-47-gf7ad21173a19

## Test Regressions (compared to v6.12.50-11-g791ab27b9c00)

## Metric Regressions (compared to v6.12.50-11-g791ab27b9c00)

## Test Fixes (compared to v6.12.50-11-g791ab27b9c00)

## Metric Fixes (compared to v6.12.50-11-g791ab27b9c00)

## Test result summary
total: 154823, pass: 131476, fail: 4882, skip: 17920, xfail: 545

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 50 passed, 7 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 23 passed, 2 failed
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
