Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4115B1E529
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 17:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721238168; cv=none; b=s0MMvlEaUem6k6xIlkIi/5OeEcVosie1u6gNAvn2tKz0PE+qoXMEj8BliF0sdYngp0/Bv7Cq9KCKWGiAr0bIEYVrdJbty2iWHZhjf9ROxdAoQ0kRQMo2uUw4K7ADBL4vPK6z6EyRYJ7pe+OUPRyBxu0FN7p6KZJIENwyuwYDGqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721238168; c=relaxed/simple;
	bh=imJsjbJjC5BO/0I+CVhFcrhloI6xPXF6dE/sgRpbsbA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=imzeyQXZOPDNGsvKwzCG1iNvoTTzzs8kKMW0IdTbAb95oW2ODdpEiSEbyZBa38O92KUTPRugc3U5H1SPBN1VKpPv+Noo5dj9+5OrNcygu2YCStRoez/7c05uKARdtmcMDzLTbXJLpD6GTAYu5RkC4L2ExOo/7pjlOsq3Hvfv4cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Md7zzsYl; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Md7zzsYl"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-48ff6336bbbso397571137.0
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 10:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721238166; x=1721842966; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HKqzAXRCryiZEV7EYlPm2aB6IfTgW4/PxmTcBeXfLYc=;
        b=Md7zzsYlHAe80HaFxKgnVQ6kNqrCPh0SA2fQiyww3RO5KY781QgOyiIP9sIjf2Ql6A
         U40Vmez3UeT5gDlz2YyDKxEFoFecEbvqEcf/Hyu+9a+VSquDnjcQbOLbzps5RqEmBXBX
         ff46PNB2cKBZexPjSfgavhCCZZQqXFSRV0CbiiFILtX6YKRYsYeFL8PJeYaz39GXsdNk
         cGIUeASpc+fsvrz/xZp8RpT8Gu4ItHtFWqw+GSMfyX2o79v05Xiy7RtZrdai3d36zk47
         g7XAXhGlk2m2CLXUeFZHbslC2CHauDiyc/Wr8qs8Hcth68BIOuF57pmMaVkjzHJXvro+
         njSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721238166; x=1721842966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HKqzAXRCryiZEV7EYlPm2aB6IfTgW4/PxmTcBeXfLYc=;
        b=IHznx/GWX8bWL/UDYLyE/n+LwdZQ9VZ9Rjse/KYQIXweYkMil1iwKD8amexleiJLkv
         LzsF2kZJrLR+22mQjnS7g+LmOJMhtQGyBgigJ0rEVy0ZEdVYFeJxCWkKN1ePq1ZdWXFJ
         bNaeS2Ij7k7Gfwl0A8ah4mjQ6ZESXFVC88vPa6iekvkt/EunEdIBwNP9l9NsR5eEpUtQ
         JpwEVjKRYksHNHwE8+xkwzzwSU3YW7ueJvosKO+FTP67T0htsHnSvdw7IbfnYiDC18d0
         1CRVwq3aUV9FMPZPDVqeNpXBQoOu7fo06Qn8ZPNhnUPCCBaWVn4H0IFHdcU9C3cfyoUq
         Zc4g==
X-Forwarded-Encrypted: i=1; AJvYcCWe7IgCNroJurFSDqSpOV0w77ZbT8OzrbSvda8MRrOIRurZyBsEXKQm5ZDLWVj6MhXpI9/ky5qy097dl1BuR0efunNO8OUDjw==
X-Gm-Message-State: AOJu0Yz2861WlzjB9TSdkfRovQM5dTJgNUbDIymSXWofX6J+OwWjByLL
	MR4cobAAF2l5yxR1pHWkuhZSBdVh7cVpG9xUjaSSDVlLVh/8N1Vz7H354FNCh26E6jYaY5EQEVj
	YJnXJJYT2w0RhCGU1u2TY/M6L6eiqAkyL5Q8Ktw==
X-Google-Smtp-Source: AGHT+IHtXe0A1H5suV6al4yCBqOPwnstQHto1M+99AxS7tG7VGtKb60tWSsPi0pD/O5MedMSjz9tMT1qUOuIyOJvPhU=
X-Received: by 2002:a05:6102:1524:b0:48f:df47:a4a5 with SMTP id
 ada2fe7eead31-491597a6557mr3452607137.11.1721238165943; Wed, 17 Jul 2024
 10:42:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717063804.076815489@linuxfoundation.org>
In-Reply-To: <20240717063804.076815489@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 17 Jul 2024 23:12:34 +0530
Message-ID: <CA+G9fYsx5tFng2+6f52ijVck3dKvygR3cW+F1txb0UP8AK9JKQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/145] 5.15.163-rc2 review
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

On Wed, 17 Jul 2024 at 12:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.163 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.163-rc2.gz
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

## Build
* kernel: 5.15.163-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: b84034c8f228ff36147b71fd57836ae4c4dd684a
* git describe: v5.15.162-146-gb84034c8f228
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.162-146-gb84034c8f228

## Test Regressions (compared to v5.15.161-357-gba1631e1a5cc)

## Metric Regressions (compared to v5.15.161-357-gba1631e1a5cc)

## Test Fixes (compared to v5.15.161-357-gba1631e1a5cc)

## Metric Fixes (compared to v5.15.161-357-gba1631e1a5cc)

## Test result summary
total: 83799, pass: 68345, fail: 1539, skip: 13831, xfail: 84

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
