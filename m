Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D063B20B81B
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 08:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745482126; cv=none; b=jAXYug0UaA51PCEaewZJpA+WjxrVnjFKQPdUy+W8Ble2l3t9yG6lQBvm7IXljOW0RUyhXYmaoc7Jaa9y/iogWaGFmCTYjKMF0YiNru/ZQiFTebCSV5KzrncRoQdrVdy66C7bLsoW9UqMgwFStCxc5FDrmN4O4AJIA8ygIs4e1rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745482126; c=relaxed/simple;
	bh=XMsRgpkb2SXXP/raY/UYJa8RZCLxYHFKzljccCfstzc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HvXu72BFmCGQlQAthNJU0uyezMFtUeTQpFEAYs1m3Xq5I+ZB0dBaAND5GnPbc2BxHlN6sRkySStRVsuxyTjtfqA3rxFea5Lj4NK7fWawMXjGJ0ENNBm5uYlWTF334rW+5O0UjnFUrfjRGEomNBCvrc2D7GyyyB2n4XFUs5w2YeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QLKFVvvM; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QLKFVvvM"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-86d5e3ddb66so324584241.2
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 01:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745482123; x=1746086923; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x9ry5y6v3BguodSRbmzPbtuUACQSgSr2k84w4YzS07k=;
        b=QLKFVvvM1kVmAGKgf+a78KJFtnc9AHfRSKZnM35mFWZ9eNQnwL7Sp0/GRh3Ll8bocu
         noHxCHmgiUNT8gHgLn8GLFh/oSv0nRhw3DwkBDYeyZrwXwZXMZ4HuMyZgnblXTOqPcel
         ApySKiAOisr2xThZMArmXAeHQX7xO4iY8AXwczXe+k9G2QqQ6qvHnUn1fH8dQ3tFbYLb
         Dw4Kowc1eEhnZ6bV4YeG9Uym10Vc4aaTXOE2Abu/4pYkMxMo6IYXYjAftNVwL3iRk8op
         GHVnIPYolVU1wb9nlCPEceYluJNDPW7K8ba9p0BHkwl3NwM5Y2mzot+qrl7YaUboj2YS
         tXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745482123; x=1746086923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x9ry5y6v3BguodSRbmzPbtuUACQSgSr2k84w4YzS07k=;
        b=I8Hq9SgNrBbNPyzq1O7Lcx0wNQWI5enyCq2r8qy6vuwnZtUGQivftngCXwlh3DkTpl
         eSsk0nzro/hk7JHPz1d33RLYGaynhC1R340vdm3LCM0gGWlbN0jgZAP1Dc49cKtV/LBW
         z/0EjKmNTioSPhszge5ns2bxiMT5x7MvXA7A1HB0MCOFeu4h12OYQtTQqi9an36gq5o4
         Jl2lld6MSkCN8Vso//WUyEP1wQoDDa4IvVHvwjBNL+xP9m4d7WDWWATCs2Vo5CUcNUhr
         fGDcOWQiaWLPWxEtIosas3W+hu99oT+RfqVnPqNN+iZKeG1AHcMkLvUim2jTP5OTqL41
         eYkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdur7Sn1EbaanJfp4ZTisYa16A2oHdDHwNVqqHprN3wuWeN/ZehmDif/Xe5o87WONuUK2Df2q6@lists.linux.dev
X-Gm-Message-State: AOJu0YzHNCIWXm6CxrC3kBfZ+J6Fw3LLCekZzurD3JgFCPwbuJ4FDOpG
	UYn7kLEK3/BV0i0UnG5TDbKOlNI80QZZ2bigM4l7TWNn12o6BxcesfFGDGGcNsFC2NyJ3idwaqG
	iEfznRuc5PB0/HZ2il2mj1MIQIs0iHknbffnutw==
X-Gm-Gg: ASbGncsznwKMSX9QjUMpQREG5JCy/AWKq/gpzqClgd5h/+h5CzTnhAE/61NBsAkbBV/
	/LLb/pyGPZC/gT5QbV1ofVnpWN0r0nUlBBbIzSWWZ3L+K8xpWrTv8B/7Trrm/ncAMnep9UF0hGg
	yY+9JGBYHkNdYCaFv2DOcayXGj/wTc8WoJ/n3LtB6AFL9iiC66eo49Fle4
X-Google-Smtp-Source: AGHT+IHuLiIQaxV7As9jN0AX3z194no/fwAE3hbqKt6NDFMtRG4ZyUmb2LmDWhuoltsdgK3DNqrWN3SEY1EPrQUgRaI=
X-Received: by 2002:a05:6102:d8f:b0:4bc:82f:b4e0 with SMTP id
 ada2fe7eead31-4d38f1eb8e4mr1301852137.22.1745482123615; Thu, 24 Apr 2025
 01:08:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250423142620.525425242@linuxfoundation.org>
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 24 Apr 2025 13:38:30 +0530
X-Gm-Features: ATxdqUFpxUtHfy0bxEpqkDLhc6S0uNjin1QyfJNMfTEtDp7xD86Uj_5YQCP2L4A
Message-ID: <CA+G9fYuiLKi9-qCgE+wRPVhV85f2MkLcqFyse0a3TuU0sfdk5g@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/241] 6.14.4-rc1 review
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

On Wed, 23 Apr 2025 at 20:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.4 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.14.4-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 86c135e93323307bac64d9c9ff1cc610c19b1d44
* git describe: v6.14.3-242-g86c135e93323
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14=
.3-242-g86c135e93323

## Test Regressions (compared to v6.14.2-448-gfc253f3d7070)

## Metric Regressions (compared to v6.14.2-448-gfc253f3d7070)

## Test Fixes (compared to v6.14.2-448-gfc253f3d7070)

## Metric Fixes (compared to v6.14.2-448-gfc253f3d7070)

## Test result summary
total: 130872, pass: 109149, fail: 3399, skip: 17930, xfail: 394

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 57 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 49 passed, 0 failed

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
* ltp-sc[
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
