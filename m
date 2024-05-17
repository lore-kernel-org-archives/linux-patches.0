Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCAF2C68A
	for <patches@lists.linux.dev>; Fri, 17 May 2024 09:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715938754; cv=none; b=EMZm7EHLXABACmEE3snSHThVD4WpRu3JZMLhz0udLMgJqqSwZGCLFDcI+4StYROO3nlJjtGTgg7W9QD2b9aVU0EYBMgFHm3DK7DVjaHBy1BMG+8g+V7yqNTZyvHsoIjHuZLOAG0QsJ0K26/P+xWflhCg/myT1svyRbc9jk850bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715938754; c=relaxed/simple;
	bh=vwMdcDIQvua8QfAz0KCBvSIyqK+oD1woVdY8EEgI43A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PZP3w34HUhYxyXcfQh898LQgfpncwing6LFOtJuxC0cQrkWYrWoWnrIZWe4doMjnL3KouYn5pUvjuicynaxCAbVYuoziwKhxrgliTqtoHK6VHTsd9SmyL1IgbIHI4uL+jqbBIxAIwx7YOrFczoebxEqc0OxnrvgaAlrPGBwZDQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q+Q2PHDz; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q+Q2PHDz"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-47ef11b1a31so3505298137.0
        for <patches@lists.linux.dev>; Fri, 17 May 2024 02:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715938752; x=1716543552; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuD+vaTVxp4rifybaa+fTKWXuMMvJfia8QWk97uGpDQ=;
        b=q+Q2PHDzRf2zrsrT2z2hlaHX0doPmpV//rzDSv5FCm7CKWOK2zElzEH4cUOL+b36UU
         T92yuPP9eLJkCGeJGDLQIHtv+4n8O2lQK0miVpxg3NF6Q3RQl89di1iRCCRdh6DX6hBF
         hLoQWadhMybwJHv4EI89lSH9FNPqXqf8hdZzcJM9/DlvsJn2PLXYMj+mv5KA5Y1e3932
         XANOt8CGqTu+yjOIR8jv6fEsaUGuyTlAXEU6IrskpGXo04Ty1BHhSBiIueNemeEXG2hg
         Hczo6HsPQ+ncWkl1YXD1z6pMbCcDvbJ/avxqcY6I7OsY4YAWacbi88Og9o5InE91UiRg
         QoVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715938752; x=1716543552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FuD+vaTVxp4rifybaa+fTKWXuMMvJfia8QWk97uGpDQ=;
        b=DZOklQbreO1MyynITQgLA4xqwyEVfp7a/NJ/gmGoYQgH3ELFxeOuL/Q+f9O1AkYGQI
         vSwkJM2U5iuZnfM/ytIZf+ZvYTTVcPJ0PNl0mdv2SZfjcnyLdV08uZ1B4h2uwRdBKuyz
         lO1wl/8OwVlHMYc11JggPhvE1R+8VkrxJjJDBh+Bc0Xesrgz7HGzQNrY0XHy4ErODRhs
         /s3qWcVigia5gy8RXznEPL/B49XWS+z3ftAR98SwbF76XbfcMzToG4VPvZ0LHx+qhDj2
         SjacZvRfPvYDa5e5+lIf/wN0I3BjguraZbPFk2wE57It6Efd23c+U0UK5hvU90rMRZjl
         c41A==
X-Forwarded-Encrypted: i=1; AJvYcCXbgWbTBI68n5mG8dC2RP2FZ5BMQ6ly1uZzgPhxXhH7ACFZe309f1VVdNLGr0P4i11DrgTqOIhripuEjWPThVFE2fUky8to2A==
X-Gm-Message-State: AOJu0YxfXxoMnS6qnlZbSG2AqZcjDFSa5R9wFWPU2orQ8KVKylAlfaDy
	lQOYG8xConIFjg1b6O8DI4atKxW65b5hLmLzXl2Q5VGtXVt5F3tTqcCNBMIsunn98luxzyJGnkH
	OhfQ/Qtw3eCBzvlLAwPTN1dA66XBgStSZ46K5fA==
X-Google-Smtp-Source: AGHT+IHrWpEjQ4MuHn+1UCMXMvxo6TPAysFNBFiBtwi3VvVlxttL5ISqmS+xmbCxdfUzOtLRd9U5BMTsS7DqrGFH434=
X-Received: by 2002:a05:6102:38cb:b0:47b:bea0:bdf7 with SMTP id
 ada2fe7eead31-48077e8625cmr21291823137.27.1715938751847; Fri, 17 May 2024
 02:39:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240516121335.906510573@linuxfoundation.org>
In-Reply-To: <20240516121335.906510573@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 17 May 2024 11:38:59 +0200
Message-ID: <CA+G9fYvG=8z_8+zuOaWVSW7_XZFGuGTxsLY_wzy33S8SL990gA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/308] 6.6.31-rc3 review
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

On Thu, 16 May 2024 at 14:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 308 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 May 2024 12:12:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.31-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.31-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 2379391bdb9dd9e503c33379d81b96ea5ed321a8
* git describe: v6.6.30-309-g2379391bdb9d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.3=
0-309-g2379391bdb9d

## Test Regressions (compared to v6.6.30)

## Metric Regressions (compared to v6.6.30)

## Test Fixes (compared to v6.6.30)

## Metric Fixes (compared to v6.6.30)

## Test result summary
total: 173996, pass: 150566, fail: 2409, skip: 20778, xfail: 243

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
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
* kselftest-filesystems-epoll
* kselftest-firmware
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
* kselftest-livepatch
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
* ltp-cap_bounds
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
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
