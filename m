Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D5745C1C
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 14:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724855429; cv=none; b=H7Bt0M+IyZdC5JT1qtL+6vMghyF5b473kkIiP8f3yWE+hitIdFhOh1rrQUhgKpO39Dh7RCbBpf3FxU1RzoWtDrFmumLhYT0sXBrvqFhSfVATmWzbK6nJJHoP64qvMQVA1OjRGFnsn/rt7IMoTNQleYhe8Nh7WH8aQCGX/Vyyo5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724855429; c=relaxed/simple;
	bh=YZh53+tm1jWK7RaDz+8FbQa5r3/A3gn5m4gTaghhwns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aTFYljQkdOf+4sBMJc/QS7fWzx4D5ZThlpah1gF7QHWOHne4k/vMkUtYGh1k08vQjdNaIa45MyoS0yJalgnyj2XZHNvWVdpHndohm5+kZvegyHy1jYhFXauzEW3a4huFlf4RMVE/vdesPw+feXCEmcBGfK/r89SW18PK/f80cf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cZQZ5lRs; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cZQZ5lRs"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-842ef41238fso1989595241.0
        for <patches@lists.linux.dev>; Wed, 28 Aug 2024 07:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724855427; x=1725460227; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=g+I6APAOIwIU9c/5xt2FS2nc4O0yLz2kmSRGO5CNPtk=;
        b=cZQZ5lRsvtl9IWjdRrLXhUUZbFd/PoSMpeoRiz4oykS7zEPQkfymRM7fT/4+EUI2ex
         bGaqFUUZPJ6KpiSWPpivw+u0ZXbA2vettX7FBo6OFu60qcx53ayOhsWk9g8+wy6hiIK5
         soLhevFBdiNEshmFznzJwrrturorwv9WQ0K+Swt9+HNcAuSVp94eoeyG05/OnYmPc0Nf
         ptnx8aLiuUotJVQjtEkk9Xep7WoMZDcqAtRpJ3M52tJBw3k89kS/QFiGQc/xQGEgzueF
         IYt3loB5fdfDsG0tJx7kIiPveRbKGiB84DZr4vgJtV8ZhNu2nxyqK0KMYATIfsN5kO1E
         4RJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724855427; x=1725460227;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g+I6APAOIwIU9c/5xt2FS2nc4O0yLz2kmSRGO5CNPtk=;
        b=oi2Zlbfc5NtG1BQRFqZUP6VFOP8h9OlplYHwwE8VUFug8GHY4qFasxjHU98CSpKAXg
         DLGDQUAbu2+F9+zuhMegDc71YP1iKHYeVmQLsRrWoylp0jvdP8PGnrgH+YHGtj71zAQH
         Lti/uLWA9bcbSDgeG3EZ/qjN5fIGkIiWgEpJEUplGqmaJmUjfim5gN7gtD45gV0d83ml
         Mlj/2aoSmn5qNW4NbgIuyWyawzjcMW46HlvGngaDZwVy6/5iCNVSISWTWv56ezwHP2BJ
         QOJQVlnYSem1dQhHUNNQwXo29XSX0ATD+39XkfInzwT5jGi1Iu5GkBdACpZfBWS6AVtF
         5B8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXWhMBs9MXxv7T8NY7WuLJx4RDOXEQN+lKo7rOzM51s1nfGjjFHJ+bhVVWPQm3vxlQe+KcxB+gN@lists.linux.dev
X-Gm-Message-State: AOJu0Yzasu8xQ0y2+EEzTTl3fwWdESAF11XDDbtB5dCyfprpyHZUwTKM
	y0nlUqsJEJF9PiaKsZjfbz/5yBAcY5EmG+lwjrMJ4Fk9P6kl00pR2txRFEa8Pma5e/EKRpS4r2q
	aXaXqGW9o6gtOOBfFwCbumOCo577+PV39xGJHkw==
X-Google-Smtp-Source: AGHT+IGq7uay+0jqf5B2CAnMl3F5wBbWN0BxkzuTMdNG0bGx2V9dHO4JII1MKnjNtLCn/K2AS1G95HydPOUg3Irwgu8=
X-Received: by 2002:a05:6122:180d:b0:4f5:1c87:ce75 with SMTP id
 71dfb90a1353d-4fd1acd6b8dmr20138723e0c.11.1724855426409; Wed, 28 Aug 2024
 07:30:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827143843.399359062@linuxfoundation.org>
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Aug 2024 20:00:14 +0530
Message-ID: <CA+G9fYuVcn734B-qqxYPKH++PtynJurhrhtBGLJhzhXoWo0sWQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Aug 2024 at 20:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.48 release.
> There are 341 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The tinyconfig builds failed for all architectures on 6.6.48-rc1.

Builds
  - clang-18-tinyconfig
  - clang-nightly-tinyconfig
  - gcc-13-tinyconfig
  - gcc-8-tinyconfig

lore links:
 - https://lore.kernel.org/stable/CA+G9fYuibSowhidTVByMzSRdqudz1Eg_aYBs9rVS3bYEBesiUA@mail.gmail.com/

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.48-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 0ec2cf1e20adc2c8dcc5f58f3ebd40111c280944
* git describe: v6.6.47-342-g0ec2cf1e20ad
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.47-342-g0ec2cf1e20ad

## Test Regressions (compared to v6.6.46-68-gf44ed2948b39)
* arm64, build
* arm, build
* i386, build
* x86_64, build
  - clang-18-tinyconfig
  - clang-nightly-tinyconfig
  - gcc-13-tinyconfig
  - gcc-8-tinyconfig

## Metric Regressions (compared to v6.6.46-68-gf44ed2948b39)

## Test Fixes (compared to v6.6.46-68-gf44ed2948b39)

## Metric Fixes (compared to v6.6.46-68-gf44ed2948b39)

## Test result summary
total: 175487, pass: 153815, fail: 1637, skip: 19813, xfail: 222

## Build Summary
* arc: 5 total, 4 passed, 1 failed
* arm: 129 total, 125 passed, 4 failed
* arm64: 41 total, 37 passed, 4 failed
* i386: 28 total, 23 passed, 5 failed
* mips: 26 total, 21 passed, 5 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 36 total, 31 passed, 5 failed
* riscv: 19 total, 16 passed, 3 failed
* s390: 14 total, 4 passed, 10 failed
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
