Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E8A196446
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 12:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730981023; cv=none; b=UWAyjctKFHND1tNXOKtLECymPMTofE7JB3FxB6ioLIUcHwUiLrJ3c5O2Ldy5Bp/yd256Qi9aloVRRamilN2uPJlyOD2eDF5abLuWz0buphJs83pcyxpN8C50t4WZp3A7ZrUUVWmObscfqWBA9744fC8hVZWnvXlBj50zajRhZPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730981023; c=relaxed/simple;
	bh=IHosAZVePfA6j/L2D13dnEQ/Ic9W8mSBmvs6TFc9t0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kaNbmyZgU8njKoCO3E1jan0xj5OfrHP+3oSvqZ/RjdFQeCshlvQnS5i1NPUYKNZESL6+Gc9txsZZ1R0r67MNT4TUXLDXSEqQTZxjCh25lV/ERd1l/JhDpTFe+BN1uxbulZXU5/JEcO5Dr0XInRSuzj+b586p0R94wTtsJL0+gfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uPnk4ynD; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uPnk4ynD"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7181eb9ad46so531587a34.1
        for <patches@lists.linux.dev>; Thu, 07 Nov 2024 04:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730981020; x=1731585820; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+NR8Ybu826lRz0YdDfbD41eoh3Xb5mDE+JZUUs10lA=;
        b=uPnk4ynDpCQ308XRUHqTuevGQUntQLoFSg9PSJOrcSLKZbWFzq/MM+ak2guBlgnKPw
         gmRQBvyQtWfBkIchPETlLP2dma38D3TDa189q9J04DYldssShcX8cGy6kXR+FCxKbznJ
         VrEupgAc9WsL1cyeLOqUohiCM5SEsJCOMxE/o5uQghOtX63h76v/YvREa+PWLiTKPiWg
         VFg0vmLEXb7SkGJXNrj4YvI3AL+M1p7Cf4bXBsDTL2lUkfU9O/6PGcpY7mpxSLIlzyys
         sKcFClhso9UDKJeOtDKAKM7+vBRiFCS+oQiPUJI9rrJv9M3y5p9hxxNXLPx+kWJ9sHia
         NBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730981020; x=1731585820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r+NR8Ybu826lRz0YdDfbD41eoh3Xb5mDE+JZUUs10lA=;
        b=fQVPwewPvs3aprdYFubfclw2zYs376t9GjYoDUgF6QXEfk9JMloA5yUvsS4/SlabJ4
         nS2YJiXzKVo6NbXEjAfr++As27ovCl4FecAoSxbSlG7exlgaSoSfGzJtvwqnxWQu2dYu
         scvvhFUhOMn8ajYVaUVVZDaAscpWgB20NGbcJZu0F7B3+VBUAVXUeM6JVLd+5PabT9Ov
         VsHV9hVHvL9AggacYlLeGj5DVxyvbV1Fd5IQHwvJaZj9F/UnvUBcvbQ/RNZmaZWrDFiT
         hx6FfHrQWK0fC360dcGqYDVw9OXiUvXdGBqgbfzqtry6eoWrxa80qvjzrn0KPuzJfN9G
         fS3w==
X-Forwarded-Encrypted: i=1; AJvYcCUOKwDvGoa+n8ddLzUDCVXB/351rkWliuSkCp3O+SCulvv+cj8UtVo2gy+Rh3WAMnFW4d2TTZse@lists.linux.dev
X-Gm-Message-State: AOJu0YzXpnm2v6ddZ7aTH97suaZ06mKoVeAT9h1xF/Mep2hMxH4AMt3O
	XXvLfJMnrAdXEmf4aDQe2Bf8sY14KIMBLMfTNQbYk0zg2FZKMxvD5TRUxef3XcqxGROjj1WUn0O
	tnGkV+uqJD7CpOAXbleNnGtoG/keY1iMC14FGwA==
X-Google-Smtp-Source: AGHT+IEKoyvJ/cov0WtFF6wWofUTQy58nUtFI4fWiBL3gWCsT5hXlIPqU6bdph9K0DRsV5d5pc4VjFe8An7V8XID1eI=
X-Received: by 2002:a05:6358:d59b:b0:1c6:1d18:7cd8 with SMTP id
 e5c5f4694b2df-1c61d187d50mr876504555d.1.1730981020545; Thu, 07 Nov 2024
 04:03:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120259.955073160@linuxfoundation.org>
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 7 Nov 2024 12:03:29 +0000
Message-ID: <CA+G9fYtgOA-5y73G1YEixQ+OjmG=awBQjdKjK+b0qLNYvAAVpQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/73] 5.15.171-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, 
	broonie@kernel.org, kobak@nvidia.com, Arnd Bergmann <arnd@arndb.de>, mochs@nvidia.com, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, rui.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Nov 2024 at 13:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.171 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.171-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
----
The following build warnings have been noticed on x86_64 with
various build configs.

drivers/acpi/prmt.c:144:29: warning: passing 1-byte aligned argument
to 4-byte aligned parameter 1 of 'efi_pa_va_lookup' may result in an
unaligned pointer access [-Walign-mismatch]
  144 |                         (void *)efi_pa_va_lookup(&th->guid,
handler_info->handler_address);
      |                                                  ^
drivers/acpi/prmt.c:147:21: warning: passing 1-byte aligned argument
to 4-byte aligned parameter 1 of 'efi_pa_va_lookup' may result in an
unaligned pointer access [-Walign-mismatch]
  147 |                         efi_pa_va_lookup(&th->guid,
handler_info->static_data_buffer_address);
      |                                          ^
drivers/acpi/prmt.c:150:21: warning: passing 1-byte aligned argument
to 4-byte aligned parameter 1 of 'efi_pa_va_lookup' may result in an
unaligned pointer access [-Walign-mismatch]
  150 |                         efi_pa_va_lookup(&th->guid,
handler_info->acpi_param_buffer_address);
      |                                          ^
3 warnings generated.

Links:
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTjBf6W7vsijHrkw=
8ZdOnL9Iby/

## Build
* kernel: 5.15.171-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 7a95f8fff07f7c8bab8da252016221fad81e010c
* git describe: v5.15.168-239-g7a95f8fff07f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.168-239-g7a95f8fff07f

## Test Regressions (compared to v5.15.168-164-gcebe213d2a87)

## Metric Regressions (compared to v5.15.168-164-gcebe213d2a87)

## Test Fixes (compared to v5.15.168-164-gcebe213d2a87)

## Metric Fixes (compared to v5.15.168-164-gcebe213d2a87)

## Test result summary
total: 60712, pass: 45080, fail: 1728, skip: 13822, xfail: 82

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 29 total, 29 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 25 total, 25 passed, 0 failed

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
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
