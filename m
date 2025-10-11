Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490C6201017
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 08:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760173013; cv=none; b=a3pgJWrs0jrStlqZlOj6gx70h2rB445kSEejsj+jLC7POw2LOurzcyzkVGkuvs4UShCe8YqD63UDvk83UVEy2fPMabr0BDxLBqFtlAhsZGhfXtIvCFecfREvS0beQ40JSgO1zbLmIAl8Po/oi3uaqJnMYCZAYVov5TXNT79RYcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760173013; c=relaxed/simple;
	bh=Q84Y22WpyJXzt9iWS/zC133vZ5OYVYmhlkD71g/ws3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nWHoNHzo+OfCT9fSy5DdMVqhZcdmBC12RwUG5CQ3uN6jHFO9ebLl+vz5kULyyhq7FE77ccqrCISITStGbb7qVDSm+b1ldfMT6dzOnu0vDyyEnYnuop8QHmLMqlR38Owy4ZW7g4L1AR6aotxY+YRce6HpXw3ZwDMjYqy1GugLz34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ipOiuAXE; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ipOiuAXE"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-27ee41e0798so45119665ad.1
        for <patches@lists.linux.dev>; Sat, 11 Oct 2025 01:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760173007; x=1760777807; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZkqoAYenMOoLgUnvzMFIL5K5C3oJ0apuih+rVEe5zM=;
        b=ipOiuAXE3u+6DzvTHd+DeMa9zWJWbArDdXm1YGxoANi/6idxkPg9Txb3NFuZZ/IM9w
         DPU8gIC8ieliFr0HTYfpw6+HwO4ndf6RZoO0lm73RoTzuiLF4/CTKY3TMU7D5icwzRTu
         rBMxQrpDwT46zK7PUP3+dEPAv2nXNGox/oSWi4J0maeXluz9RKFXvsn2CWUMbl3kGcmF
         0sbpJX3IH5SpVCZDfiXR5MWTFgUxyzLy/BBersV7UtDhRa0L6P14YTo+Y+o54izd0dtz
         XCRR0nVFsAE3gqpjcnPkgJrggJypNqG5UCe5hHNvZAxVjHVA/sZKckdSja8wCz/gGNNF
         0cgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760173007; x=1760777807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eZkqoAYenMOoLgUnvzMFIL5K5C3oJ0apuih+rVEe5zM=;
        b=EkbmCUm/Bq9nRjFYcbgY+h62+6zLj9nq8xN4ttojAmNCY3dRs7WsJqiQ9jFUHBVAES
         8UzMb1yughSLiefg3yn9Wpmc7RvLupsBWEayz8pBcjcmE4/zm/jgOyhmCOdwuSRinD/Q
         BzVuLnk70ZDnIIcFpAJRs9P+xo3Vc2tYSFbDFBLFeI2jnvanzuMIvfVmuxStSPAifWOd
         ANFzyLstD2fy4FHsQ0NfmfZyT5rl5z6b++NJH24DJrLn9fNqMbkmV3iS1MSCeLQ2C5nL
         gF8N9cNAwVikH4h9GvhPcLTyg5shRip1UgmkqNgb0ejy00LcfpIWNszZJXzYDF/syoVP
         YQLw==
X-Forwarded-Encrypted: i=1; AJvYcCVrPfLR+Q80mWJGxGaCnC4HHAUFUMkGAlL/XlWoIL1OIQMDq+CzpWvFzRbq1eBD+GHDfAH7u0eW@lists.linux.dev
X-Gm-Message-State: AOJu0YyKJceZA+BS4TZZLb+L1Z/zLtLc3T2ivUiKitetMGrY0EPe7NXH
	LSMNYzQtluHiWNP5uwooty77P4k3Jy+92zcYapxxNEOvfQ8ZXgo44K9C2Ip3ng9fe7fIwsEvxYH
	FFBx02gpFQtV934MfAhBAPxbpzN+KvmU5xrWv0meYrg==
X-Gm-Gg: ASbGncsYvYBuiDm6azqcToMX0E8tDVzuZRPmDWwOhnC34K7/pqtJGRnPa/RMO1ER1wj
	joBSMkHQYx8FJB/j0ab5Cm5OIu4YcaOw+etX+WcPSZrGSqw1SCcHK5RPiIIS1BNZYUNj0c/Ah9a
	XowOUM1z9wIY3BLopV4QiaSik8KggD+p2tVS0Z36YKnfs9S2liJtSbuCbMVJhzaG2Naz/ufh2QM
	YcAlPlFhRcwdcgUXZOfyeOBx1yDcf8VBWm2FivIaWv5LbuFk9zqgyoKB/wBvs2rGmJnOSTsDleL
	WHScZGMZkVwJCQHSdFfOnztnmMKI
X-Google-Smtp-Source: AGHT+IH4aGvIBP2bJ9+QW0JQJLsjmcgQxlEsHkanAzq5vTqx6NRHHgIQno4wEWY+WHR6+SBn1LZANqc4KSd/RDe0qdo=
X-Received: by 2002:a17:903:2ac3:b0:281:613:844b with SMTP id
 d9443c01a7336-29027418ecdmr195663335ad.52.1760173007557; Sat, 11 Oct 2025
 01:56:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251010131330.355311487@linuxfoundation.org>
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 11 Oct 2025 14:26:36 +0530
X-Gm-Features: AS18NWDVp8xoME8Wr3vMHaskDzUO7wibXF6YelZ4zKm_xPeASpMUVNthsWfcn5k
Message-ID: <CA+G9fYvFgAOu=8M5LH5yBca6FyZCtrFEuTiEw7RzPoGp7Va1sQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/28] 6.6.111-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Oct 2025 at 18:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.111 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.111-rc1.gz
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
* kernel: 6.6.111-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 65af00078567f7e13108e6036a6bcba7f2c26892
* git describe: v6.6.109-37-g65af00078567
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
09-37-g65af00078567

## Test Regressions (compared to v6.6.109-8-gc901132c8088)

## Metric Regressions (compared to v6.6.109-8-gc901132c8088)

## Test Fixes (compared to v6.6.109-8-gc901132c8088)

## Metric Fixes (compared to v6.6.109-8-gc901132c8088)

## Test result summary
total: 133027, pass: 113628, fail: 4440, skip: 14481, xfail: 478

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 128 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 14 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 34 passed, 3 failed

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
* kselftest-mm
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
