Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29BC7C6D4
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 08:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798091; cv=none; b=MXTzU8JOsEG4mB3TF5IhLR9Pmw1Migj0i1oWPfGbcrBifZYMlZxpnP0Q2QqSs+z1bX5+yVFSOGgWisDe1jIJe0LfVp0BFk905VEhDXUxRXhBUdqLVbw6pvDRZZcvq8ctLBOYAS1fPuxwLYUhPSNU0MZOQjI5dBbBeRxF+58Z2Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798091; c=relaxed/simple;
	bh=bmyrHc574do+lctxZWnJC4whXOXLMycGax7Zbv4IkWc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J04J7HRo9ziTH3fSyk2o+35HEpO45dvcgIyhu6f/CSydgGIKq/SBrGV/nW20RW7eRNltVJebSIjYkO1suIlq8bw20qN9ZXwKaGa/RX4tEo3ky5Ehq6jmKimdiD43rxGt39yTnllyNov+R51oVlbcnaM6HBGY0DyKhLPzh43bqRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SPvAN5p9; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SPvAN5p9"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a7aa4bf4d1eso243018166b.0
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 01:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723798088; x=1724402888; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FgDB2NePct9+ltaB/xLwIrrImMavCdcOJFMhb/o2DB4=;
        b=SPvAN5p9S3ZaA1wkVB3XMaC3YjaRNLAyuQfUHHBJOOJY6SjW3F5QzHyqYLgzBl5gt4
         qQ279dZr6/CI/OmfoJTUy7skqwcKif1z2HPrHU9ek0nkg+Y8E4ILvM/dhqTHe29zWgTm
         GcHXyMP+mMEFJvq8jXXkn8a202Ax8xJiWB38v/JMOj7QTlkPAgcZovRAfkSwR9X8S1B/
         ziRnDfM69mNHZCwcJDu9JPLhvx8xjpFyFdNaktrGzi/MpVc4qPFAcu/AzOfYQx6UQuUw
         MKdBMfxV8XYTf0wGLLFkuI6g0EV4+qmgoDZoi28ulUGrMfNKF9WnV0A9tfPf08hGQu1t
         WgXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723798088; x=1724402888;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FgDB2NePct9+ltaB/xLwIrrImMavCdcOJFMhb/o2DB4=;
        b=rk88Q9O0y84t7om/RvR/5ZtWeFzlQD6cswrRDRA5hB/JzK1msfq/LH1iElmic8T9RG
         XIH1B8Ng0HatzB0nGbKSrtYuu7xhCY7cdUFvlEYsfILhKshanJMn5UZmNsoD6J0zQ5La
         21nBYjOVo9MZGCerNQbz14N1Ln58sMNieUKGrM3PXG1eWv1xbtlN8BIgFL2FhxQeN67o
         GMU2QLQI0gWoKbUz8cwcGfazPLsVXIXCF/eakUiByKOtIfeAnNAw4ddeK3GbQAKh7b9O
         wAB67HjAQ/jbbG7hpXDrLJzd5LJmvRgsi6brNqQJk3O8MZGtVefHg9J6Vuu3JzbLb62O
         5FUw==
X-Forwarded-Encrypted: i=1; AJvYcCVITf8DA6ivlBidGwPQD4pdlVX79KpBTTWvMck8yiJFoEYsADhrkRRYZTAd49f0ZiowGqFTW88Yd+2/19WeKJ4qY0AU2G761g==
X-Gm-Message-State: AOJu0YwcZoLaX5FVdbCnVB2atb/et0v6Ti07VNvtg2S2p5aL5Ec4XELf
	xffgHCC+gaP5V5kPKlODgcBLlgaSJXqRRv0+WWm9HH0tAOWdkKl+l35bJOkSsp5HnzY7RQpB/bf
	+l/3nLRG8MkrKyVua3f9otvZttFqk2Dau5Hsqqw==
X-Google-Smtp-Source: AGHT+IHMrXHEq/AoPlWkkFV3X21l5tRq+ZrKaLROjooBrsCA7qHeDdKASNHVtAR6pCNmKKXHOqYkmYzfqiBhVBsjRLM=
X-Received: by 2002:a17:907:6d10:b0:a7a:b839:8583 with SMTP id
 a640c23a62f3a-a8392a42a3cmr161029266b.66.1723798088013; Fri, 16 Aug 2024
 01:48:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240815131832.944273699@linuxfoundation.org>
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 16 Aug 2024 10:47:56 +0200
Message-ID: <CADYN=9LTKMLu9u3XZqv_-r_KK4hL-tnX14VpSpE0iA16Favkjg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/38] 6.1.106-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Aug 2024 at 16:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.106 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.106-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64 and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.106-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 09ce23af4dbba4a348ad90cbee52a46ef1d685cf
* git describe: v6.1.105-39-g09ce23af4dbb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.105-39-g09ce23af4dbb

## Test Regressions (compared to v6.1.104-150-g9bd7537a3dd0)

## Metric Regressions (compared to v6.1.104-150-g9bd7537a3dd0)

## Test Fixes (compared to v6.1.104-150-g9bd7537a3dd0)

## Metric Fixes (compared to v6.1.104-150-g9bd7537a3dd0)

## Test result summary
total: 159479, pass: 137501, fail: 2504, skip: 19237, xfail: 237

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 28 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
