Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA25A17A312
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 11:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744196417; cv=none; b=SEPzjvO2JATJ/AeN76TqLnFcL6SKECiMb0qqw+D870XM13SkFXl10gt7XYoRVx/PmUwFqRRPSut2ITR3ZjJG1gGULM77LgKUEWVQplqz/TmbFghPAmv2Clm5opOIWmbd2MIVHqjt9+bgSw9D/F19sYRfpHYyrlHBZgP5s7WhINU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744196417; c=relaxed/simple;
	bh=09N9lr2hL1uBA0J9A1onZI1++O5r/bZidfTgoStsh3U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u3Z3DX+/RMURJMEdAZ4a1IvzjAjsZseHf5RdIYUwmBBZb6fGODCmzYEJlDFJwg5rk2PgSgIj7A1cDjgp7XiG7M85OJzgFHx6kw3erFOM2aGWfPSMRcH7jpSUq1FAC6LQT9UfQf0TeG+Nbysk8IY20r81NUe9kCdlHuXc6TtZyWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d1yeUwJS; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d1yeUwJS"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-86feb848764so2724496241.0
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 04:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744196414; x=1744801214; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/r+UtYo/qU1HvE/h/9g29MK3UmN/8EOwDnMaNEnDOrU=;
        b=d1yeUwJSVp03bSBLktqQ3VpFVAMs5ul27Nr1FRcUMU/Y+8oYs40olLiLyLfhBdHLP8
         q6MINgVDnUjW5/pG8UXe+MM7tfgIa+tILRhARM031QDHZ9em0EYafB7A0sr+Zbut9PP4
         HKZtiAj6z03zhTAaQbX/9GUa+GHp2rA5NQc/0f9J9nmd+Zw1hAH5uiUJcfVSHByLOSWP
         YegFIOWUtwhO9GK1baX5UTliHC15P6LXfgx/sE5PJkABc2AH9neu8PLdbVkLTrVtPcrB
         XcGwWVQXTHmTyC18j8ms6bsSazIASxMgTrZKUGU1LUlDRbvSa4pI01gDe5/oiHz4Raz3
         td2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744196414; x=1744801214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/r+UtYo/qU1HvE/h/9g29MK3UmN/8EOwDnMaNEnDOrU=;
        b=YwEuw6WPaNdYT2w3okf7UG/BYc4yMgxwb+ZYUu/14qsQpdXZhvlULBWUfn7AGFx2i6
         RXQjWCKl8ZWH4c6Y3XxUAoUCTgazjW0BTTPkDVdXyz37jocAL5OTUy/auXAZgtMSIH9G
         iu/D1itBUAHjiDEZ8Q0wZ7Ci/Fc5bv1/WwlPoYSHTMODU1qza6Ibq6CIdcCG8oedMYhN
         QPJFpW6A8GJKyuPeS2g5smLmk3BRiKckwppmvKFMFMjfKtGRoyVzUB0TRmYx5bdRF97B
         aKpKrmgVbHelF+pignblRuvJReucSUVsRoTRBXUil0eIXGbI16I7SjgmkxyA9TMwfNM6
         FqnQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8suZ23QpvN2h9n5uC1vd5rrBHFrbDYUE4u3StcvM+fDIi4csGDwyvwwHLkMOB89eWvEmRvdF9@lists.linux.dev
X-Gm-Message-State: AOJu0YzA+F0v0PWVaOYpAULuBE28JRM2e6wNkmSeVnAxZ8iMhTY/sssQ
	QLi0RdeGupMfEUTLhoJLCWaHdoOa9GAihzVoDS3hmGhQkunzkDIakRURirp4S4RDwKBGlFgORFw
	GLWjVfZb8Ip5UqHg+QWrpYmMx6tzrpV2R0PUb6gB15XS+IVOiCko=
X-Gm-Gg: ASbGncvbSBVfMD8UHv43FuoCMj6ynJuRpORvhZRZcsi4P6T61z/YFU5yEsfLtuNJE2Q
	vnbFb4EDsmjxJ5JtDeSLt6UhYPh9vo2kpS/vtQcIxZxWB4FhyYbmjCMCnzNt8Bmlp9j9MS8ICU3
	Pk0/nVC40ZJY0OohArkhLJe1G2/0BX7BQwKgaTzj0l0gs8UMCT8EjK7eq/hL2j3gKPmA==
X-Google-Smtp-Source: AGHT+IGo9sv2kAp6E1TzReXRQThxB1ji5GcAkSOodvJZOJWIQxm7smQrGCs22c3dVXAkmC4M67oP2TT6jxzy9gzqXgU=
X-Received: by 2002:a05:6102:801b:b0:4c3:858:f07c with SMTP id
 ada2fe7eead31-4c9c41bac11mr1541584137.14.1744196414562; Wed, 09 Apr 2025
 04:00:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408104815.295196624@linuxfoundation.org>
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Apr 2025 16:30:02 +0530
X-Gm-Features: ATxdqUEbbqVQnyWqpGGFNxrrvwRlgHPDQwMWHgCjswzOhAlFJNCxt03hbe9eXSc
Message-ID: <CA+G9fYstSS6rg2GZPROMq9QRGcN21v-Lv4ED06+WsvSOXqf=Eg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/154] 5.4.292-rc1 review
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

On Tue, 8 Apr 2025 at 17:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.292 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.292-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.292-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 7a5af469195f5d6a1ee88a8cbe2529477317d901
* git describe: v5.4.291-155-g7a5af469195f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
91-155-g7a5af469195f

## Test Regressions (compared to v5.4.290-329-gfb482243c16e)

## Metric Regressions (compared to v5.4.290-329-gfb482243c16e)

## Test Fixes (compared to v5.4.290-329-gfb482243c16e)

## Metric Fixes (compared to v5.4.290-329-gfb482243c16e)

## Test result summary
total: 38270, pass: 24396, fail: 3248, skip: 10469, xfail: 157

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 131 passed, 2 failed
* arm64: 33 total, 31 passed, 2 failed
* i386: 20 total, 14 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 26 total, 24 passed, 2 failed
* riscv: 9 total, 3 passed, 6 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 29 total, 29 passed, 0 failed

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
