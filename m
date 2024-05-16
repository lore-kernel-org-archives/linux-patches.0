Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9611928DD1
	for <patches@lists.linux.dev>; Thu, 16 May 2024 07:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715844821; cv=none; b=Yy43+CbQSWFcl9ZF2x/boDlCHxwQtFy+C38rwxrQSW5wxFNLQB3z0tg6Jsm34T4ZNQ+ng/YJUx+KVfn80NzSN23I9c88BH8GsN96WvaR41nKoPwYGDARgFtSQOJt9aKmcBAkjSAPyfjY1Br4/f/DGePSVPepDmeMmUA7UwByHtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715844821; c=relaxed/simple;
	bh=mV3bzfV2I1TjTPcS2ZrQrzUq8aipyYkqsnM4fcoounU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nYyZTXKo3h1MQ1SAfedsHx3+yND/vbaMxjnNeGRyjVtc8G97eWvg2AQcwf/5N6cfB2UG+IkO0pX3ch2sx/ZBmHPhEvmAJgI2e9YfRRfsKU97W6PaNaQNRBO8mTYBEkwQeKvwctBqHJuX85u86NJTQZxHffu8+eErmBuK3pX+uXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hiMShvgZ; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hiMShvgZ"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-7fe97255d23so527887241.1
        for <patches@lists.linux.dev>; Thu, 16 May 2024 00:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715844818; x=1716449618; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pIWq/FZE2YXC731qnWaoLEetM8Q50pTmv2YuXDZyF8g=;
        b=hiMShvgZk56m0XlitO0AYfImOxWphZxONP/+8xVutsfSQUU0GvOu54xGuMokyG2hlp
         mGuCis6V95ofVwi7ET0AT47jTvQLddKo1kc9VNx22Eb4mITDU3nTlIxDowrrmNc2zsRc
         n9RWA8/T9PHpi/FhjLtb215t8IaM/5I7/N0QgdE113FDjRidRQ6c8tuTdKAKfb6XZbnE
         9B+1qw7Q21g2xutreUwehNI87WQ4ZWr1JeLzGc0rt0FQLKO+UaiKO/9V/bLLUnbSOMSb
         a97BvdO6+UzU1ywd9KdR68ap/kfu/Gzsz241JX/WnPdCixgn88Z1V1Z8Ht0lI4v2ijMk
         px0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715844818; x=1716449618;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pIWq/FZE2YXC731qnWaoLEetM8Q50pTmv2YuXDZyF8g=;
        b=v6GMb/nLv9j0U3sv8Vl/Zz8DQLTLBQs+ApSv19DG6s5ygGonXLmVwlRhmDY4nCvd25
         lMUnuk2FMsPqLIUkLflg/BtWdikwKl5X4PToAWOq0y3u0wdVvvIUzyGtJ146FwZJAmKr
         mjsrQ5UWnoO19vrzslsYw5PV9G3YIeK9H62phKqUD3pXIFB8bk57kOB7fe5dwiBPCYuh
         Tpk2lH7chLD4AYeBleZGVsErK/92WT67ZK6R8KekofkMwfTlBG9Qx04xVERPgs5z7/SH
         L5GzjyJGLB9qTdm0j4Hsuxgu96gYltHvabDfmMjvWVXScDhzoLz/Pz1JkaArGz1xHTZ8
         RVDg==
X-Forwarded-Encrypted: i=1; AJvYcCXC1Iv1sPcu7EGINnElF4rsdffSb5iDAcZOYNjq5nHJxMPpCrBvgJJjARSZXVL8PDNuXh2w5N6rU1NJ/7rlCLptCf6FRr+QAQ==
X-Gm-Message-State: AOJu0YyVYIIZDtZf+5Tkl3qvt3rvgNnar/8d1NOY9fuuFMofI/EokzfU
	IXIfkHiFuUxXuOxqv06Sez4t6WWRdFB0LELss/Q55feRkM0uL8XFAewKWuS2al+hzG6am8+pU3I
	HzTn6x4EqV+KiGG80j8yNhGU81qi0JKj2BklVUQ==
X-Google-Smtp-Source: AGHT+IGpRPi8is2Z+QCntAHBaeChPe/gMG90B246WuBKo8Y5w6+Oj96SVZGUzvo02KPLmnyH2zx4kpOyclGT5J1KB+U=
X-Received: by 2002:a05:6102:c86:b0:47e:f116:4535 with SMTP id
 ada2fe7eead31-48077dca716mr18583373137.8.1715844817070; Thu, 16 May 2024
 00:33:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240514100948.010148088@linuxfoundation.org>
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 May 2024 09:33:25 +0200
Message-ID: <CA+G9fYtvj5OEOeAG31vON6vE_NHE8a-3Sqg=ptb4hmf0icLmtg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/63] 4.19.314-rc1 review
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

On Tue, 14 May 2024 at 13:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.314 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.314-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.314-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 61b47a187ce8efaf5f5b7cd7e2ab6ca1b7da2557
* git describe: v4.19.313-62-g61b47a187ce8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.313-62-g61b47a187ce8/

## Test Regressions (compared to v4.19.313)

## Metric Regressions (compared to v4.19.313)

## Test Fixes (compared to v4.19.313)

## Metric Fixes (compared to v4.19.313)

## Test result summary
total: 42289, pass: 38159, fail: 195, skip: 3906, xfail: 29

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 102 total, 96 passed, 6 failed
* arm64: 28 total, 23 passed, 5 failed
* i386: 15 total, 12 passed, 3 failed
* mips: 19 total, 19 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 19 passed, 5 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-lib
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
* kselftest-zram
* kunit
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
