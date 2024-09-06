Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC8C13D613
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 06:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725605081; cv=none; b=EWUM3dt/ZQTsyFHFbAPs2KRClUT1ZVg+WDybWmDSjTldQRMRbXjay2I9PGA2gs3EAgHBHXW8zGULoIFimY1U8yXdcXOnKRMZElf+mBwlBvh1pWSRV9fB7U6MVc6+FMvJyqcYJc2OurMVyPm3R6/HVgOpFt7XQa37f/J1ovPHx9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725605081; c=relaxed/simple;
	bh=oa3H9YCpx5VYGA2KbkYcPMgZzeKNVh/PFUtLWy3sJ/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aFj3fLBysnooXkEKrfHW5cRbbEqnEdTIW1o8OYa6JOK57otP4JlmLv1VPFWwurtjT195oZhipqn0SKZhPMKIQ8f025zVNMfn37VbMN738UgyA3A8puhoIuCPS8KsHwzJfUlrdOvpg+728l8wMKaMxNqe0pDf59/oiFReBOHKVXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jqlnwlHF; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jqlnwlHF"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-49bcf6b9b64so425630137.1
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 23:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725605072; x=1726209872; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+gP4o7JbisYVim+/wPjL+HDCs0/A0dQBHIFGkvw0INA=;
        b=jqlnwlHFpv1iY72KMFngwXzvHpovcgQGw3PS4qUn2Q4N9Aw5qCHebuQ4Ensx54uXF8
         /DpmUWUcj/Pu+O1qVdhTSrVVPn0zAgdpX4+Qx1iIgN6ReQRqB0g9wmGiixgkW2DqPpfA
         l951zaf6ymqkMBiezf/DylPysxcS1hnGuPSIdLo6id19phGXVucPDWjGAjvCMYcepo39
         qWb1JQk/nU2xiqxk+Cd133VX3pCzqFCnC231fxrxTqOzZfpkeS0PzditqWXliy67Qwi+
         d/VMcliC+6Ia4PbiVXCoPwNcVSM7eKFOx+62I5uJ2XrOj7HcgAm0LL0skr5LFWOKMuli
         FaIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725605072; x=1726209872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+gP4o7JbisYVim+/wPjL+HDCs0/A0dQBHIFGkvw0INA=;
        b=d6de/l/qrwwUPbgvJl9sKmy2tzLalJrLJm9LUTG+qRgcWerzNLxaJKCvcxFqunMNlq
         2QMqMNf41zr7WIAdM6WiGSAHuefw5UsVOh1h4Yldkl6msgNBJxX9AkUqEa+VsNUOSYjS
         dUWqci8mMprIUd6Bp6Mk+hFvyADc79JUVJpXNfDfBir4lrYLW5squo0TG/JF9mdZ/LlC
         fojLQ5EnMw4QgHdLJpA8HWTzS2KEUc/3Ql50RKbdvk912e62+zej2kyt5a9uaXaBfmOL
         k+zfBjHDGipD/KC712uPU21BQUVbBUQDvTCq9I5cS9s8c/sL4cR/ig4Tnyy5pn9Ezkfv
         s/fA==
X-Forwarded-Encrypted: i=1; AJvYcCXoySZroszOAYKHQCpYa5MvXG+yhxzsBlWl9eq7hUWv13HsVSqADos/6r6NqfCIhIA3XhPtKS0p@lists.linux.dev
X-Gm-Message-State: AOJu0YzevHR5/dyoNX0OosuBEfHJxdGkpsESKjIJ7z7PGYxzTJBDW5Eb
	2Fp7bOjr8BuMNnZqhggpwGUW6oLnLL4IhcAGuZpjTTRkCs8jZlzte58E2KZviqGDdx6iVZcTKPi
	rMVRv3VkBxwiOhdyhQ6ChBAa+sIJS41fgNtvk1g==
X-Google-Smtp-Source: AGHT+IHuUmzECAJSrwF2r14ymHpo71IMGLjs7axdWUb+JN+ClsSfKWQfo8MjNbsnf5TglvLkxKmzZ17gWcctxFVA+yk=
X-Received: by 2002:a05:6102:b02:b0:492:a93d:7cab with SMTP id
 ada2fe7eead31-49bde165666mr2127128137.1.1725605072208; Thu, 05 Sep 2024
 23:44:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240905093716.075835938@linuxfoundation.org>
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 6 Sep 2024 12:14:20 +0530
Message-ID: <CA+G9fYtr3bs6RbBgLc10QJ2c2Uh4EHiif7bFOD0J+p4rEoCukw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/101] 6.1.109-rc1 review
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

On Thu, 5 Sept 2024 at 15:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.109 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 07 Sep 2024 09:36:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.109-rc1.gz
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
* kernel: 6.1.109-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: be9ed790219a433e9d1aa5ca79fb51e3e52bdb81
* git describe: v6.1.108-102-gbe9ed790219a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
08-102-gbe9ed790219a

## Test Regressions (compared to v6.1.107-72-gde2d512f4921)

## Metric Regressions (compared to v6.1.107-72-gde2d512f4921)

## Test Fixes (compared to v6.1.107-72-gde2d512f4921)

## Metric Fixes (compared to v6.1.107-72-gde2d512f4921)

## Test result summary
total: 190787, pass: 165221, fail: 2316, skip: 22988, xfail: 262

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 7 total, 7 passed, 0 failed
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
