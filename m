Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04FB17A922
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 14:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724855683; cv=none; b=PVT9LFzg6G2PGV5Hr86rPcSEz8zdPJyoqpbrZ4GHdX2lKGKFEZNGTKPIfqXda5o0NTF3LHZS3rvUzqUkjRn47hog+4hUtrxCTWIHnPnI+EKtioun6jVL09zTQuAJRWYjfp4L2BIZ8UhCgJ8Ps6Tv6I6s0NtUaum9LVxBi9M0XTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724855683; c=relaxed/simple;
	bh=CI4CXriw67wC68iskUm0bZE+6Nt/fOtp76fyzaDXIBM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XaFMMOlSDDCMqVgjGRc5stX+b9T6wa2ICFY5gPrdBGkd1MWU2AJ/Bib0ooQFWrf5419OmPp+zEj+Z6yd/Z0Ew4UEndxwafDUIx6RwV6GmIFurS89CxYVe6wg8cMW4ISJtKKHeYV/3p+6lvMEpcaGDWKkXX/D+J0+wuBf9qrW0u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WZPRP98I; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WZPRP98I"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7a7fef9a5fdso29891185a.1
        for <patches@lists.linux.dev>; Wed, 28 Aug 2024 07:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724855680; x=1725460480; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gyUo6RUUr6GklVooVru1PomCfQxfqpdR7hVYNrLOVFg=;
        b=WZPRP98IbZj/N2pDfIRnk8BNP/mYRqKEcisOztds+jbiy/duo1ii8IOByZ/GrSTHE4
         Reop6crLe3Ldo8W01AfQDczcAhccGYnHqxjVapPwZNmpd/9iEWT8p1rD8eC87+ZWavYe
         J5Dqp2fewTa3dZi4zQzNIf8oydUGAjp2ziL2cZQXBB+CTouiy5qu4zDXEIWdyX448ej3
         hqCFH744vsAJG63mmjl4ypDsaugLM68rPvjnKDwJ2JeeGOQ1eUcVhFw+YYWXXnxTOjuj
         9pexaHtZyPGetV2LwmI+bcuCd2oKnNzO1w5JMXK2klj43WiTtScXpkEA9cCHBQ03ZN4j
         FLOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724855680; x=1725460480;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gyUo6RUUr6GklVooVru1PomCfQxfqpdR7hVYNrLOVFg=;
        b=Wwj1dlk8BktrShFgso/pEJj4eZ0RVl0PyQ2CsIMOQ/amnv9+gqKV3zal85Iecwdv0x
         z7bX/vWbvn4Z2z6mU6kd4fy2We15V9QfL9VJH6IXE17nSsB3C5fXrnZCi6uIxXB3FQC3
         ZHZxtNL45mA/oE9B963zl0aC5ElyUr8aDPFLJF1MOne4FWSW2hTVhRALu9AqRPS+igPZ
         WP3xaoA+mPWks+xMly4lVInx/GaKUoyxBdJ8oqjblrCl5Kyrl8ar0+8EUY+vrF1+8xha
         pE2tU86TyytpKfUh1FnSeMpzDttzvF1vjeNb7+1DpxThVnyA+Lr6yJvU0Ng0epld6CgA
         vdng==
X-Forwarded-Encrypted: i=1; AJvYcCUgpmwTNzL6IZoAAHQwfgwjM4eOJKm/XquEafr2ndmFCk2rjUEzIw7d5hRJYZ5JV39eZxA1eyOr@lists.linux.dev
X-Gm-Message-State: AOJu0YwB1GgdJPpnP43jBTRchi2D2MiT3NaroAHS4Hh2ql1nUgmvFsAF
	EW8pqscIqBO/3GIU4k2ku0bypz84UQANw7qCYocc2TFcjIHjemkRcLLSzw9BBpefL+L3VPRipVn
	f+ItJ3IZ/kEmwy1h6yFXzyKE9Vi4CvazEXEljkA==
X-Google-Smtp-Source: AGHT+IEmRhy3Ri7l+t9MTzUjqcgJRsQ6zYubfPpsh9IZnoAxSLNHwf8XAweS0vRUop5x8D4Zqj0ISY/ukGb1nnceqlE=
X-Received: by 2002:a05:620a:44cf:b0:79f:aa9:b3a0 with SMTP id
 af79cd13be357-7a7f4199661mr424667685a.13.1724855679800; Wed, 28 Aug 2024
 07:34:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827143838.192435816@linuxfoundation.org>
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Aug 2024 20:04:27 +0530
Message-ID: <CA+G9fYsUxRMXOZi6skrOV+ZOo0yCj6NrmBFi5CptTdRRQzWXpw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Aug 2024 at 20:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.107 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.107-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The tinyconfig builds failed for all architectures on 6.1.107-rc1.

Builds:
  - clang-18-tinyconfig
  - clang-nightly-tinyconfig
  - gcc-13-tinyconfig
  - gcc-8-tinyconfig

lore links:
 - https://lore.kernel.org/stable/CA+G9fYuS47-zRgv9GY3XO54GN_4EHPFe7jGR50ZoChEYeN0ihg@mail.gmail.com/

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.107-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: b9218327d235d21e2e82c8dc6a8ef4a389c9c6a6
* git describe: v6.1.106-322-gb9218327d235
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.106-322-gb9218327d235

## Test Regressions (compared to v6.1.105-39-g09ce23af4dbb)
* arm64, build
* arm, build
* i386, build
* x86_64, build
  - clang-18-tinyconfig
  - clang-nightly-tinyconfig
  - gcc-13-tinyconfig
  - gcc-8-tinyconfig

## Metric Regressions (compared to v6.1.105-39-g09ce23af4dbb)

## Test Fixes (compared to v6.1.105-39-g09ce23af4dbb)

## Metric Fixes (compared to v6.1.105-39-g09ce23af4dbb)

## Test result summary
total: 141679, pass: 122248, fail: 2025, skip: 17193, xfail: 213

## Build Summary
* arc: 5 total, 4 passed, 1 failed
* arm: 135 total, 131 passed, 4 failed
* arm64: 41 total, 37 passed, 4 failed
* i386: 28 total, 23 passed, 5 failed
* mips: 26 total, 21 passed, 5 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 36 total, 21 passed, 15 failed
* riscv: 11 total, 8 passed, 3 failed
* s390: 14 total, 10 passed, 4 failed
* sh: 10 total, 8 passed, 2 failed
* sparc: 7 total, 5 passed, 2 failed
* x86_64: 33 total, 29 passed, 4 failed

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
