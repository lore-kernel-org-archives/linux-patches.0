Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8072A280323
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 08:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748938263; cv=none; b=lyoUu6U+xPDmJgGd5cmNeHpSBowzfqBZqTP3CRWaXV9PvPYnNCHx6CEsLPYZbpoQOnV9ijOcyylQencGNUiqpfaMQXDBOWEOeCnqshv0kwYtyrXMYQyDJpkD9I7daB9eu/bz7JCLVQzX+s1og673Bmk9vYqnRQvPpDsBj+sm0x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748938263; c=relaxed/simple;
	bh=jUmM6kwyLUdPbLKXSy2k6sMf1vokiKUNKs1IpfSBBNw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SHJ5Cf6g0aW/F+oF+kN9oY2dtTni9WYQvAOk0tGdUpf3Xx5aCTP7a4vav7fqdVWWWZ0nyeE6KM4e3mdAkNSy4R1WiXWbwWD7EM3NmXZXLwkX9LHe96yAPuYfaiE6PIyeFM9JA475qlBYowandqi3oTZZ6qHpPj1KeXHRtcfjuUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kP6Q1wIx; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kP6Q1wIx"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-4e58ad70536so1792619137.1
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 01:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748938260; x=1749543060; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJvNtw55BnHmyAVpfP1EHOhy3chABBvF/TrseOesELs=;
        b=kP6Q1wIxwslq1+vIxFgtNM7UOUl64UBTl/EIkztg0/v5a0DFiba0QL+xMpDt2m47we
         /HuBeL37+CcNlvkWDbNMhHbJ9k8O2OCN0F5+rqnMAJQkCtKRU/KBGEjO7FlADeuKVWYM
         kx/xRXFJ4S4cW5B13TY3YXugxoqP5GJCoZmoJbFDvlqrIVlanpm+seCJbwEcYV9p4ka1
         lTBaU8ejiRh+9ycNJ9DBkFy5qpTX2ASQzCgrCN98BwDLVKFB5uqZUaeAhQVFtdoSoJ5+
         310BNtt1L+BDzLlvRHNigqharP7fexLThwqbqTn5zvl18hl9zhxTRHWD5+4JGW5wSN0w
         5GTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748938260; x=1749543060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJvNtw55BnHmyAVpfP1EHOhy3chABBvF/TrseOesELs=;
        b=n9X0kBSAPdom0CozVFtWzD8ZcE8aES25hy+hVlHoT/KqzRO6AMk28B3qW5FnrSRAmv
         IBQ+wriTMXV/bNYZuZ1Z9GynWszsfPJiX6cqpheQZSv1v4ZE0Q4d9yqCAYIx5NUO+/Gs
         T1cxz56ZJzzlhz0e/d7RVotM0aFkx3FO3612viZf2lbKY7ORtW9it86RhphsNqrV4hjK
         DanWU+ogQznseL2eVzNEHVEdtF4z+0kayjROxuktX6Qd/3xd/mekbMY2wjn18fjhluP+
         sCSMZEEwSnsOAiy/J3ErCptTTY4wOvVGH5zFv58jfZPpnKmfYjbWOtADabz21MzyYixb
         U65w==
X-Forwarded-Encrypted: i=1; AJvYcCVus0YHRHhUZT8cIhYYctjjWDUm646fGk49vfsJokBEndKhntsFgRIn0LeaO4wS8alLkqiP8+/F@lists.linux.dev
X-Gm-Message-State: AOJu0YwAeJlkiU8i2S3lVt+j1I3IMD9E5eVoNcpTIQJEf23uYVCEM3a5
	r8AN0PwYV4XiVAVN1ZE1/WAvX4GRbH86l0Thv6dtA8vH+sRgmenUsr5JOwev6n1fidFKsSeaqPc
	UQwJXQ+wThb7MzFwMK9Fn21GA4MS0MnFBhIsDkMnXqg==
X-Gm-Gg: ASbGnctxvBur8duJ+jzV/K8R4tce1Rpd1J2K1FZZsks+BfAiIY/qvP2DtVyjHxiVU6Z
	Rzp8kCoEW2JWr64U6v0R8U47md2ZbIrD94t7AXAIHEJ0ihwhTZFWDPNQ3IXzPdEckSaETFmZKf/
	nu2z4qh8DYUDdxQh7/F+MAZcG20MzLyt4=
X-Google-Smtp-Source: AGHT+IGCjVs4dMM3MqoDJk9DJ8c8U+dd/1B+c44BJ3TUOdOFILG4zbRELFKWajaB/m4NX5D1opMnugTamOsgMmdpw2k=
X-Received: by 2002:a05:6102:290a:b0:4de:d08f:6727 with SMTP id
 ada2fe7eead31-4e6e410aefcmr12879939137.13.1748938260246; Tue, 03 Jun 2025
 01:11:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250602134319.723650984@linuxfoundation.org>
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 3 Jun 2025 13:40:48 +0530
X-Gm-Features: AX0GCFvaxqWfgagp1ffOVYDvYD0c_wS9sizPQ3RqMcYEeBwQFBqHVjlDChAbOcU
Message-ID: <CA+G9fYse-qFqJDg17B_syP--b60iHbi4jH7=E6c8R_=F2Pkonw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/325] 6.1.141-rc1 review
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

On Mon, 2 Jun 2025 at 20:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.141 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.141-rc1.gz
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
* kernel: 6.1.141-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 1c3f3a4d0cca7742a95419a6c91fff4326a2de1c
* git describe: v6.1.140-326-g1c3f3a4d0cca
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
40-326-g1c3f3a4d0cca

## Test Regressions (compared to v6.1.139-98-g1fb2f21fca77)

## Metric Regressions (compared to v6.1.139-98-g1fb2f21fca77)

## Test Fixes (compared to v6.1.139-98-g1fb2f21fca77)

## Metric Fixes (compared to v6.1.139-98-g1fb2f21fca77)

## Test result summary
total: 219869, pass: 201359, fail: 3409, skip: 14877, xfail: 224

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 21 total, 21 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
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
* modules
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
