Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C24E18DB21
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 14:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741272742; cv=none; b=kDzt0N+jRp86dtZQt2gLphMJqSAJ/1yIdwE5sH0M4PJeaJXtiR8AyQwU1eF1gz7hidwEh/mYgndaDtUaoRNob9dW3FENPa7A4iz7doyOljgIIsLW1cu0YnHgr+8CtcMfHJHgQ6zpxdL7OkTs5FL+ZvDMdAsGqsoVmKVtcG4Sd/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741272742; c=relaxed/simple;
	bh=yUu+b2vzGVtm02aX2/54++X00P3YWAnG4YmO83c4ObQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VFtTAompoepc3ShxL/EusWDDeDujMedLPtHjxvdlJPqo1q/KkzNsckwFyS4DMzmLn9b3LvgNrSeM2JGJ0TFwP95BY9R6Rplmva15BxxLTzcRKPaxDMvlyewpu/dASIUCFRtxQzSYd1oyQphrEEYfdThFHMPkoKL99L6Dz9j/0R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C+1mdMUn; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C+1mdMUn"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-86d3805a551so202971241.3
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 06:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741272739; x=1741877539; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=++XXHmZkM/4heXDc+pXKcqrY45A7F6g9wZ+G1XbfvUg=;
        b=C+1mdMUnwyuh7CbHyJf73C/vUbXE13SlUYFdFwxcG4nFWjlE0W+deHq5c5QMx9+EzK
         ThreeiGR7AED41q+E/OC7mt7itk+lbr38etSfikP+atoCka3Tan3puIRMlXXi2hHYb0k
         kzkxBlZ8HpHCWy7y2rsPkbdcaRa7BM+akUh+2zG0dJk4iBaHyVuxoW6m0Mw59lrFja6d
         ZAI1gn+GRCwx1E/pxj2kgHawfl59XNF7jN7AVkrjpDC+UbRAvs0V17JMs6qKBlN8hK8a
         m29gDyb3XjP1xUc+/0AW8vzwxQWjPoZu2+Hb1B5TaIiZjVAWiyuTHVOrJQgvNfxq2al6
         /gjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741272739; x=1741877539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=++XXHmZkM/4heXDc+pXKcqrY45A7F6g9wZ+G1XbfvUg=;
        b=chJ4PigqzqIAGAAr0VK5ndaoicNHgkVJjmDGULYsfLy7CfU7kMqY2Dt6nHzabKvThp
         RCrfGWFXbMsAp60+zShBuRbl/OQsxviDVNnQnfXnPfBtO249YyvHe0ioJiM2VNUezfa0
         UNkl/rmlK3kLebkgSFydx/g6TPosKhXPiosD0hBRoFdA64u4xiUd7DOrpIWts6+1+ac6
         wEf6LC6gnWp9n0G/c2tcbJ2/OxFYPXxR06xfHHXOwo3aWKzA8gWm+l7+YxRNkJ9CNfJ/
         7DXy5oTyxlF7wFqcKFq0IVD93mjGnFNiUdXZ9ykJVCd/ryEMW064y0udvjMqKX7OeOIw
         Jw1Q==
X-Forwarded-Encrypted: i=1; AJvYcCURC2ABWJjZLuouAw0Uj4D+iNNQkZ1LnYVu2C/Ywm4QY6rP7kjXu0jZQaperYLi/n2Kxfsdsct/@lists.linux.dev
X-Gm-Message-State: AOJu0YwwiI5M1vmqKIhxeaHgPmGmc0jKrhoE9phIhPh+mya17YIrRePT
	RBYYQXUnrknRZdwhgqqFItQH0Ty0CJkVASr26w9xxSYG5lUsAi4Cg9qoIPAxwVb+r2hAdwB3vFr
	JVDHs7zUlqOBEKtLuO4dez4zKHshzKKK++RDbiw==
X-Gm-Gg: ASbGncunZ+NHL3TIiGnWIEvSsmZn1nAuT75N6YGhnZ3vKIYjtAUQgIVw/StTi2qRo1Y
	kesh8Hwp+8dT3yW7iPd3g1+Dwx598OpV8/DsZ7ifDXoP7YdDBy31F1S59Ftjek98ueM6UkotHfL
	pReRlwq++F03o1vhD9Suvcro/9S02R+kJ5370GPwG7RLwBQXNfCq2OKANN9Yg=
X-Google-Smtp-Source: AGHT+IHqKw0y7gEoV2UPp2JTXAc45pxenBD9EVRnJ3CNyJRZgT0EsDiICwm8oX0iHkmbYK+jllnu/+N/IxUM9GPv2y4=
X-Received: by 2002:a05:6102:4193:b0:4c1:86bc:f959 with SMTP id
 ada2fe7eead31-4c2e27a6eb3mr5045988137.8.1741272738910; Thu, 06 Mar 2025
 06:52:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250305174505.437358097@linuxfoundation.org>
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 6 Mar 2025 20:22:06 +0530
X-Gm-Features: AQ5f1JqyKMYONNiG8qjjNgx2bFmT-sq5eEAlVlJjqLc1GhF9Jjc0gVpKZ-epy90
Message-ID: <CA+G9fYucgzxXxrTBUJcgRyJwXk=14S6tL9G-jd4Wm6fM4VaMkw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/176] 6.1.130-rc1 review
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

On Wed, 5 Mar 2025 at 23:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.130 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.130-rc1.gz
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
* kernel: 6.1.130-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 34da6dd4fda1d2daf1b0df768fe6224d0993e050
* git describe: v6.1.128-747-g34da6dd4fda1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
28-747-g34da6dd4fda1

## Test Regressions (compared to v6.1.128-570-gfdd3f50c8e3e)

## Metric Regressions (compared to v6.1.128-570-gfdd3f50c8e3e)

## Test Fixes (compared to v6.1.128-570-gfdd3f50c8e3e)

## Metric Fixes (compared to v6.1.128-570-gfdd3f50c8e3e)

## Test result summary
total: 75778, pass: 58508, fail: 3115, skip: 13933, xfail: 222

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 46 total, 42 passed, 4 failed
* i386: 31 total, 25 passed, 6 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 14 total, 13 passed, 1 failed
* s390: 18 total, 15 passed, 3 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 38 total, 38 passed, 0 failed

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
