Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5BF147C86
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718042154; cv=none; b=GC4RkasJlE2sE8cTUdz895WsgKr4YUVA/sNzIFWYvGWL4+PSTOj31+NEr1YqOca+pEnLrr22fzcUZr+sdsEEqIFHUewifTCjgOmLlmFKFyl9ITCZj9MA47ckwrjqzFonsWqmINUxKew9/HPW8aFkdxEnJ5vkw5unKIliJpOYdYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718042154; c=relaxed/simple;
	bh=dNjI23WLp0imEmdkBxjx2VmizbZl9IeRvfhVp0aj6lk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FpU1QyEvUK9aV4ZxTe+oHt47zAUz/eoWX00VkHadOa1qmIESMxg+o2h+wY4eM6PAaMTJTfLxOVZcIX0SN/f8NqGIEx4cz8b5wxUF3SQHHZ7w3QbPgHpqWPyo/UcbyDtMi4eIK7YT0bOCb3up6HjRQsd5ZPvkimgUR+IiNcFHoL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Mp3ua13V; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Mp3ua13V"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-804c45a47b6so1371189241.2
        for <patches@lists.linux.dev>; Mon, 10 Jun 2024 10:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718042151; x=1718646951; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y+JeefLMklHAV+yI9qNZHPNA7M9EgyySno86Vwa9gbA=;
        b=Mp3ua13VpEtbk6ffYzNHU++wrdPxp6I9eOicqunY13PBxZbo9zFZM1BqXCPZSVttFS
         IDKp9F5rzPDyAl9fnMln7L2U6IDeADl71DPzw2T/yt3LfqIFmHjKLVAbPlgdXBmHXX6i
         ec72HaKn0mjqiUKrk7iUpSlTXGaPviiTJDblZJn2lqYcYWN8URJo8G5NYcrVu2o/iYe4
         qYXNhQssQ5Bf3dn/z9mnhzR0EDdKoLhaP/1l2+dGtgMFj49Qc7jQ2qr+PzDXw7fAgr9M
         eqoPhVIETaHDZVVTzf3FBDb9YRe9AHOMZthMHJ+CJrN1mPZJccqez1OhRQuRTM6bjJyY
         wRaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718042151; x=1718646951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y+JeefLMklHAV+yI9qNZHPNA7M9EgyySno86Vwa9gbA=;
        b=bBG1rDuZTs5Xwbgkelclxh/IWpmjF//x9mAFMPraVbel77UtxzvtaWfm0adkzqbR5B
         4He1lfXdMOvdJvdmGkGERSZwKKZ9K3nT9/2PwO7OAxn3NIAmkcqEgFa81Oe03fdDVtWs
         hEpv16J07aczcVzPtUydtYiDo5A83nbCfpQGUF7DX0TM2M67qvaqy3lnRLrS6ZrApM5n
         VVoxCT+/AGBhaUlKBxsShhxCwUnK3CpZ7P++J7BaiNyrGsY7+akGzIqoEkEak5iNkOX8
         4ItsfAQuBaQD2Fhunbuc8Nt/YcJfLTu6OUY2TFmRx0axR8aj4E2BpfELoqvyYLIiHWnh
         zxFg==
X-Forwarded-Encrypted: i=1; AJvYcCX14B6EzoruZ1fcFg2MFQ0OchqENd8DGW3Qbk/YW2ZzTez2Cs/1SdSQq0iNwJmaRhm7hASsJVmlws2L0OvOIfnBb7DqlJyExw==
X-Gm-Message-State: AOJu0Yztv5nH4NtE3oDWO4rJlCyMwWh7GGKTvnep9PPtmduQ1JP2+j3T
	H5nwARtoXwT+UzVZDzbPU0tr0TNsjuWL9OLA8NupYbnk1QMz/CngwxE+U1D2hRLEk4gFMsJWwBn
	RF4iOVOz7j5fT4nkJPDnvLOM9AGCAP2fVerlJ7Q==
X-Google-Smtp-Source: AGHT+IEdg744iLrX6ZtbyA6vFCgoj3lzq+ppqtfCzhKioG9uraYqBhXuiuKLGd4W4eaRkB7Qken+1OHN4uBNCiH7lcM=
X-Received: by 2002:a05:6122:16a1:b0:4de:daa8:b8e2 with SMTP id
 71dfb90a1353d-4eb5621e208mr11288152e0c.3.1718042151230; Mon, 10 Jun 2024
 10:55:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240609113903.732882729@linuxfoundation.org>
In-Reply-To: <20240609113903.732882729@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 10 Jun 2024 23:25:39 +0530
Message-ID: <CA+G9fYs1zvpNDYiRL83Cs5D_o++QHQ5rpwjQHSDCPr3GM1bAQQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
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

On Sun, 9 Jun 2024 at 17:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 741 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.33-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Build regressions on riscv reported.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.33-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 7fa271200aef4ae8f0bed8a8ed81629ecd5ed2ab
* git describe: v6.6.32-742-g7fa271200aef
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.3=
2-742-g7fa271200aef

## Test Regressions (compared to v6.6.32)

* riscv, build
  - clang-18-defconfig
  - clang-18-lkftconfig
  - gcc-13-defconfig
  - gcc-13-lkftconfig
  - gcc-8-defconfig

## Metric Regressions (compared to v6.6.32)

## Test Fixes (compared to v6.6.32)

## Metric Fixes (compared to v6.6.32)

## Test result summary
total: 237984, pass: 198342, fail: 13030, skip: 26078, xfail: 534

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 33 total, 33 passed, 0 failed
* riscv: 17 total, 6 passed, 11 failed
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
