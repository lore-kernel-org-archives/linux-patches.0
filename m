Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F8B20C022
	for <patches@lists.linux.dev>; Thu, 23 Jan 2025 08:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737620831; cv=none; b=oGBUX7MMDmSH5joCCVLrWRs8N4pIUkgndDEZepDZCdCVC0RzZhxFR4ApEOENWaDbQjV/Z8Q9Mt71wzJpwdRD8ooCNApgcsmDe8I1Cs1dkHuv0UeUb2pCAnPWqRCyesHUwYb3cWxU6lQhujZiVIxOSQ0/pu8cZ9JTaUGQYjik1Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737620831; c=relaxed/simple;
	bh=L322Utr6J8zVV4lpTR+PtuxY5mRFcRCy5yeMqhu3irE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OrjreS3fxat6yoA2GJiWsdxgt6JaRj1lxYSFQQTV+lX6Z069SBRkCgFh4ZXKgFtYQM8dxpWKwbAANu7p/Qmz2X27lIAfQwTKjmsIQ8I9foyeO+UbqQTxNZVGoCZAGbxgT2Mtjl7ZfxojMgRgMbhLlgGn+zbiP8f695EuFHMPQSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hAjjc97q; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hAjjc97q"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-51889930cb1so207575e0c.0
        for <patches@lists.linux.dev>; Thu, 23 Jan 2025 00:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737620828; x=1738225628; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6jclPLjrwga2DiBE7oCd45pavQD/4g/MMHO5//z3b4=;
        b=hAjjc97quOmIE0AMmB/NG/4vDwZ6xnsm+q/16mf9ybk63TKyzRlu8kB/ilIm9MIRjb
         sPWM7ts8IWGAo7uGinRNWoAlfgxmS8UuLw6ytYRMxw0wIsGXAchkX4TFoonQVbRXgE3m
         VwqrFMVqB+kBI3aT4ORkPGQV/l9haWAC35KOAXXJBpl34x6Ob7zQHBmCnh2W4rOygKzP
         Ym1JevyZoBKmrdrS7ccB2p6g1aT+4tMrR3MQ1psdgsUz/zqJmMiLUykb/FYhEpQ9/9k4
         nuS38Z9wNUIqZ9KqxotSSmlPBX28NOzr433UcHkUBPqSmjexlb5f3fGLgJdsizdEBhsY
         uh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737620828; x=1738225628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P6jclPLjrwga2DiBE7oCd45pavQD/4g/MMHO5//z3b4=;
        b=d9QresM0/nucQXOumvZaqJqyhC61GMFGu2t/P540FPHHpKY2+y1r3qomG1cKFghkXO
         LsPUcoKeC3lxOINOTtiaRQdAbsum7y4/Hawh2+Z3g2eYU49arff0COAMhp8czZsa8KXO
         P2vfgz/hzNZbS68At2X60z2jZI46jiY1FZkmLMVkmn0lwsT5oHM/zBig90abrLT/Xwjf
         r+5mFHFVRnV9whcVebZHqF6hfFh3YNbjV0Mb22yfKaBw83P6PnkW/u4pqZyZwUBbRRTJ
         u6fqGNWr/uajbparH/A1bRlSjKtb2aemm8Y/8hS3g7MvI7RF87mTRtgKXHzT2dnPHB2P
         g5IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIB7Vqfls/zHDHwCGs/KuIkYyYSZaU6EtpUJpSPfkDlgEMB5QvNCRiIek0Rom/7w+xwNAeADAU@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1JEIoMywXDTIQcRwLSQoKzdR0mMdJuhgHfzUuc+NmiGqc/aMT
	uq2hgW4VCGpFb/bDTwafFlA6eAEyBKpX7ajXDf8yTJE9neO8h3xFfRlELsYbWBI9EEVmZFFqXmp
	bEq87I/unZOVwSgnpmNIhHdZWgpk2v4OhLx9/MQ==
X-Gm-Gg: ASbGncs5b6JMbCQBBR/J+hk57kSGcLlG7+IXfsMlZcNPDxzzjgyEgDcr7ZaSSwrNcjT
	yfSiMC6QIpe9wnm8o4gWT++91PdETCrBVKGFeBSmbJvFxUCjrUzwPwG4prI4RfHM=
X-Google-Smtp-Source: AGHT+IHQm8f861mhiPICLot9dmANF5a8TDYEm1Zvl+JaFZN/KfkIuLR0vWEvxdP92bFL5poM5v/usA2MXSxvoECS9lk=
X-Received: by 2002:a05:6122:4fa1:b0:4f5:199b:2a61 with SMTP id
 71dfb90a1353d-51d5b30c771mr21183949e0c.9.1737620828020; Thu, 23 Jan 2025
 00:27:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250122093007.141759421@linuxfoundation.org>
In-Reply-To: <20250122093007.141759421@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 23 Jan 2025 13:56:56 +0530
X-Gm-Features: AWEUYZk2YHSIi9OyXlh8K5Gbw7CUiK8lE3haSlXHvUFB4un6zyfmd5icX109F_4
Message-ID: <CA+G9fYuev+wW8U2-d7QZ6tx+TxqLmPAshw63UgdsDs+_Q4zvcw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/121] 6.12.11-rc2 review
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

On Wed, 22 Jan 2025 at 15:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jan 2025 09:29:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.11-rc2.gz
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
* kernel: 6.12.11-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 0bde21f273434bad90411f296c22f02c62c07b2e
* git describe: v6.12.10-122-g0bde21f27343
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.10-122-g0bde21f27343

## Test Regressions (compared to v6.12.9-190-gd056ad259f16)

## Metric Regressions (compared to v6.12.9-190-gd056ad259f16)

## Test Fixes (compared to v6.12.9-190-gd056ad259f16)

## Metric Fixes (compared to v6.12.9-190-gd056ad259f16)

## Test result summary
total: 114776, pass: 91853, fail: 4843, skip: 18005, xfail: 75

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 56 passed, 2 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 40 passed, 4 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 22 passed, 4 failed
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
