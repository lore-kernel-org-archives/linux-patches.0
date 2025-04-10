Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C4E20DD72
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 09:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744276624; cv=none; b=oLPGvvFbXK8YPyY+ZvndKtEFiV7DeA33UaX/lgTnxVHpdn9b/ueKN5Zixyw78W98oHYtW0eOPy/pYK3GGnTgl1lWWfwxgiiOHwuNQNncm9Bor9t86Tsm0fnJb6TQf0t2PPzQIw+qQ20oC8z8qIIwv3fFo7+ggeyqJRJD8KbN5e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744276624; c=relaxed/simple;
	bh=Xa8Ff/pN7rm82/Hw80lblkpQWMIqBTW7/2gVpQ2MNXQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PGBZ3B/R/98y3xCyUfGXq0gu9aKdaHd1s9WjQFX2XkbCfXEA5GrZ/PCSYX4h3Bz45UuIJpYn2M37G41l+YyEc/FCOMHTTThHy7+Um90VOdqKnVU00eQWEPGMY7ROIzCcXISs82EBjiZhYzPN8Ha0rRJrfblbnZhfJ4vuLVjg5W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jRytvYia; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jRytvYia"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-523f670ca99so315757e0c.1
        for <patches@lists.linux.dev>; Thu, 10 Apr 2025 02:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744276620; x=1744881420; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GdQmyUTj4g0SuNw3N9A0Br4aQqbGmhp5SDoz/CPIiNU=;
        b=jRytvYiatOyfOmdV+4bicznMySTzWnWqWt12gEhVV/673AcUDnYr8QeA47+gWTI+Lj
         zbiTZFnV29/KSBrKn6xzFj/CWC/G/wqWvvjWF3eJOTaFThUQV3RoYMC9vVeDkhQzOPIt
         G5NQVVi0fKuJGMr+31wZM5XCbCOtNcyvbn763JS8bR1KPHyBUlH76Cd9Rzsunwr1q15H
         8omV/9L+UuxilL8cpi7T6/a2okyb7qFtTbqHbwpMd62VFg06L5Gqw/pFcXG9mMHoLJsK
         pXGO6j+dZXa8rcE2DKPD7JWjhkOM+nXzpOmSPmJ3ZUBref4HRxyo9qXV/SP/CrQzl6Fq
         QXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744276620; x=1744881420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GdQmyUTj4g0SuNw3N9A0Br4aQqbGmhp5SDoz/CPIiNU=;
        b=HgsJVGWInp0mBoTnwYAHwQEj5eVXIg/TqaBVfQkqVPq3bdT62ilFH/o9sXB+nVlZyi
         n2HkXsV8J+sPXw9Dc4OCSMbIEsD9iQJ3elviVAUtQmgN8/JBaOowqXKwqE+G0mXw4I3b
         tjjHd3jzln0LW6osgZURjLHfXGiwcrW4CkJxsYLN9t+gVsdPVppPfXFT6L8En1U5TPe8
         3XvVWIiA9syXVYvLKS9vCgKywIZ2RApIOvPaNYdsLRb42Cb3IHqc3axOK8sxsYsaV70T
         GgRLlmoUWwhCDJ9jiBCSon1GUFl/1MjaZMdN1BlqYKhGUYF6BbPP9d8taAN87OK/fTDQ
         FUig==
X-Forwarded-Encrypted: i=1; AJvYcCUs4Q9o9Tc3Sryo2O/l1xqHf8sL0shUrEazVNr6Icv5Xh7XVhNcgsxeUpzHbNkpHqS5UIt4tXPM@lists.linux.dev
X-Gm-Message-State: AOJu0Yw95rNYrSmmkxmd2w0bTR0WW1KjAfB4Zyd+fz6t979OJRFlLSWn
	bRa8kQQNtOUT2+ZUlZVyvLRmSN70SqCzIQOfI7SPFIjE2yuMaVUodUg4pfg/bWy0NuM/aTDQN/y
	clHFoDMA+44y3PfEZd2Vgq06B8rk7a63F9IXdQg==
X-Gm-Gg: ASbGncvOcpA6r9kzyyMDDa7gStEDgKAmCkGGboyK+zNym1onK1YuImRMb5ryn17QgL0
	t+jIX5bLb2Ba3OA3eYKuqSD+ct50Q9A7mz9sw0L5C15gFIxyCPumykB7Fxe68fxBfWsZ3V+khCo
	2sxM0XOCCehKyrhUbJBc+xhIpPipOYxOT3hIuaPeLia7dR1K8pLG6frpUMz9xIvhdx2g==
X-Google-Smtp-Source: AGHT+IE1KynZHJuyz3u/gcawT+AeiFFoZZSoMAW3X0C3a+4tVcuYH3tbZBo6Pebhc6HyfPbQV+caJt9l4kTsChhokA4=
X-Received: by 2002:a05:6102:160f:b0:4c1:924e:1a2a with SMTP id
 ada2fe7eead31-4c9d3620e92mr1047489137.25.1744276619774; Thu, 10 Apr 2025
 02:16:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250409115831.755826974@linuxfoundation.org>
In-Reply-To: <20250409115831.755826974@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 10 Apr 2025 14:46:48 +0530
X-Gm-Features: ATxdqUF-Jfnj0n0r8H8OdiFSk0hQ53ptwMn1zgVSD-9e5YmY8uzIaVkWfZZN8_g
Message-ID: <CA+G9fYu3c-bgqcAxs8royX1LJM-+BqZE8yOkNueD=4H2UStNZg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/228] 5.10.236-rc2 review
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

On Wed, 9 Apr 2025 at 17:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.236 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Apr 2025 11:57:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.236-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.236-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 5b68aafded4a439a2c6c9b0fdf18c2c3a7560bb7
* git describe: v5.10.235-229-g5b68aafded4a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.235-229-g5b68aafded4a

## Test Regressions (compared to v5.10.234-463-g92c950d96187)

## Metric Regressions (compared to v5.10.234-463-g92c950d96187)

## Test Fixes (compared to v5.10.234-463-g92c950d96187)

## Metric Fixes (compared to v5.10.234-463-g92c950d96187)

## Test result summary
total: 36631, pass: 24606, fail: 2712, skip: 9093, xfail: 220

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 30 total, 30 passed, 0 failed
* i386: 22 total, 22 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 21 total, 21 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* boot
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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
