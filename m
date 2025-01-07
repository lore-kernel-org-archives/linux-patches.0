Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827341DE8AF
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 09:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736241155; cv=none; b=Rn6VMMZmmv+oobRXjr63WoRJflmA17UhTLktX2SPAi8K7s1yMUAk6u9RR4wp4JQ7+jfnXi7Zn3COqS17+fjYICSycUnVLn8AR+R92zwm+EhF+PguRM+/he8hAIthWtAriZLrqZtvQ7bctpZDk2m2Vr5liH0Og8u29Efpm8hXw4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736241155; c=relaxed/simple;
	bh=vwQHPAVlH6Xu6LDj6vxTZlZLu/ue9jZ/NDNsMErjYGc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UBToYbTwqEWPHRHqqckbWtLo26RQvpkDye6KPZ+jOdBYr0xg4VTmeRvDev6YSYAWjEsiGvg9H9kNQHr6z32q/GHH2qOMNIivr5xkZZvZBewc7y5uMyEr9fJRViUobNqKbPHXXGHRs1GQ2LefoSJqnpz7Dj4gx6600kIJrPmRIi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vym7u0N+; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vym7u0N+"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-4affab62589so4032404137.1
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 01:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736241151; x=1736845951; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3f+8PMqm/72Skv3PIVV9dMBmUXrF4Uosjp+ptj5ZKv4=;
        b=vym7u0N+81FLw4Cl02J5Zl9DE4ePCmkhR5PVENxoAt7Ee4GNPtW8//VKW4mhZvniU3
         BfqxSUDVYXp+Yq///f2rDD4+fV4AjbwkPii0FhoCLqHNAnoQjlHZjzMEV87E/6BQxI7Z
         uI/lj9bcNFZzWTR4EsD02tEnV5OHikNbMaylm5kWiet79E21bB41fL45wzScqR1cEbBr
         xKm485mp5v+4tAaSBpZaCEZnfsZ0oAzaZgTAg8rxknzwsc6dBOn46AZZbJaDmtxjZ8Bd
         8WE+RpfbNC/pADf2FTuMNAYkU2zSEkRTzIlTnic0z1F1Pba9a2bzKSCgSMyoFnml6v5J
         LFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736241151; x=1736845951;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3f+8PMqm/72Skv3PIVV9dMBmUXrF4Uosjp+ptj5ZKv4=;
        b=OLQndECaTFy2mUp2qMoxiG9Jf/VMlILbydRReQne5DsrwQY2vd7fiDtNEQE81jbEnV
         ogN5xDgaHEvSnJKeHPrNsqkW98yuGxaYD/9uR88mvsPgrTlNI/tsInhcAb+aCG6i3Z1s
         hKnCDQCI+ufPXxYF0nZSrYM9N8HpqPueqQSDc8AjuiVJCIezVMmcLwsCf5EWmmkn9+39
         vTfVaVuvTEF8QXcxcZ9D6i6Y0stY2F2fZGt3GsQY7uZP858QThblu1OVFLP6N21bcY3R
         PHG3WOHg1nWYkxLcjBJicB4BhCPnT+/3XYxLzJ43EFmvpzRfZAXbPALCIfsFr+TFPWZX
         Ty8g==
X-Forwarded-Encrypted: i=1; AJvYcCUty/hbxJquMY0xP5ujRVQY1e3rZRqeLIw4cRgi2yZ9yo9jL0EBlCrqBLaSw3bUQ+3701SCw0rg@lists.linux.dev
X-Gm-Message-State: AOJu0Yzw7MmtKVFT3w5OR6m9Lx1PyxDGhBID/b/evu96zScWa226BdNG
	cKF/EBrpItICKBnimYcQ4IHM2cAq6PZZ0zZKLGxn6mXw5w5vxJXlUWFdk96jFww88GG21+hP94J
	wcEmN8jSR9gyyPdp/AuPqVAw2NkxQ6uevI8VWzPzF+WGsBYJxhdQ=
X-Gm-Gg: ASbGncsfBrt2oQ4CJWJb7eeE5F7ZI2IGLQg7cjn6Brn/NvDeUnj+NKeT+x+2nRYIWN/
	rAmj6oRnJnL3st2CY0Zl90bY4m90TqLUn6vbI0nI=
X-Google-Smtp-Source: AGHT+IG8Wpe+tisCowZGZ9+zs1OBt+0BCWDNLnE9ZufiIjtj0ni7ANsziVCCe/cOHOkIXKi0UnTDLhOUSt8JX61oC18=
X-Received: by 2002:a05:6102:548f:b0:4af:f740:c1b4 with SMTP id
 ada2fe7eead31-4b2cc319f2fmr45981439137.5.1736241151496; Tue, 07 Jan 2025
 01:12:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151133.209718681@linuxfoundation.org>
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 7 Jan 2025 14:42:20 +0530
X-Gm-Features: AbW1kvYhV5tIM55ZWEG-0B-pDUWOJ_TMc4UkSUHFDq_r4c5Gv7TWZ5IMJcCykAY
Message-ID: <CA+G9fYss0LJRq6rzg0g_oG2+c_TZ=i3uNnq7DuWWfm4c5YkOpQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/138] 5.10.233-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 6 Jan 2025 at 21:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.233 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.233-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following build warnings are noticed on arm64 and arm
while building with defconfig using gcc-12 and clang-19.

Build log:
==========
drivers/gpu/drm/drm_modes.c:772:6: warning: comparison of distinct
pointer types ('typeof (mode->clock) *' (aka 'const int *') and
'typeof (num) *' (aka 'unsigned int *'))
[-Wcompare-distinct-pointer-types]
  772 |         if (check_mul_overflow(mode->clock, num, &num))
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/overflow.h:88:15: note: expanded from macro 'check_mul_overflow'
   88 |         (void) (&__a == &__b);                  \
      |                 ~~~~ ^  ~~~~
drivers/gpu/drm/drm_modes.c:772:6: warning: comparison of distinct
pointer types ('typeof (mode->clock) *' (aka 'const int *') and
'typeof (&num)' (aka 'unsigned int *'))
[-Wcompare-distinct-pointer-types]
  772 |         if (check_mul_overflow(mode->clock, num, &num))
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Links:
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2rGK6opE7YJuvUHMLAXMTkCvBsd/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2rGK5umd3ST7IpCpaejp3VuJJxT/

## Build
* kernel: 5.10.233-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: e0db650ec963f170146da2f830585256577a4ae9
* git describe: v5.10.232-139-ge0db650ec963
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.232-139-ge0db650ec963

## Test Regressions (compared to v5.10.231-44-g238644b47ee3)

## Metric Regressions (compared to v5.10.231-44-g238644b47ee3)

## Test Fixes (compared to v5.10.231-44-g238644b47ee3)

## Metric Fixes (compared to v5.10.231-44-g238644b47ee3)

## Test result summary
total: 40675, pass: 27523, fail: 3504, skip: 9568, xfail: 80

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 104 total, 104 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 25 total, 22 passed, 3 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 24 total, 23 passed, 1 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 11 total, 10 passed, 1 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 28 total, 28 passed, 0 failed

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
