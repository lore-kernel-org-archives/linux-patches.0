Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C254963A
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 07:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723533013; cv=none; b=lLNCfjeQXh3Zz5rfYt6iDypR79s1mZY2gAjnqUxGrVj5Rpfibfoq9bPIZ53sA3D28TgNneY0+SRiLcHA5mOZMm2zbDz5iNgiXPNeEv5k049XTnleB97TfU5NOE+lqxr8fS0ALw6S9jLhknxJ9+R37uRcymD9cAW9LDH1L5I4mEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723533013; c=relaxed/simple;
	bh=vROMTYPZA1hbG/rVcd9OwaeuEl2pN85JgkfJTXNAQzg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=evschPM9va1TNIlBFQm+YnDqL4fZkNq4E3oPwC/NTxd+H0Ix4U06QzSnUpN+6z7MriB94hiV/OcQALczTtAd2RwtKW2j0L+0Aukm+7Mfr5ixKGby7L4InhMwZl2MnJ205MwNLavh2uZuFbbIN39BscZNEkQNOSdbh2cfbzuplDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vYs5YkcB; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vYs5YkcB"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-49294bbd279so2187853137.0
        for <patches@lists.linux.dev>; Tue, 13 Aug 2024 00:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723533011; x=1724137811; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MWpt5hrm81pO0HFVAzXbDHOgm5yQRHjKeCNb3+8kYHk=;
        b=vYs5YkcBB6wy4yvcewBRP1kCSrQ5N4RczVYqtC7q1cJl4PKAMEhq4raotbnZAh0M13
         fsJpz5C2eNDt0h0+JS6r8tivzhh0DuDTOKiAs5v5CXCI/J8/KAMn4L0ELYRqBTCA/THe
         bwq93uu9xpduUofr4JlrG+amqO+bZGRu6xwRnQUVFHJnRUXWoKcEOARXP5T+Taa0JWV4
         WjUriFgzAZze9qULB5ptVIvs8eYQCkSZ0y9aFHPBjb6FChpItfR7ENMydMYMvWoXektn
         wCuaYB63kAF5h/kwXkVb1n3Lvg9wI8eFNZxFX0PymQ/pLQdLM+9F5QIwj0ijv9QS5YWo
         fs0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723533011; x=1724137811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MWpt5hrm81pO0HFVAzXbDHOgm5yQRHjKeCNb3+8kYHk=;
        b=QLw/inOnrQPLmsqk8niJFuKNTq/tJ4ZBi4wTeGrZJAvB3uSfOnl0HpEirFHFdjrvn2
         pr9EgdoXONBSFvhdxVq6DtmFW4hCAUOPtC+KHVYDm72KboBBacO3FRKddmtbjsCs2Nps
         NaMXuSSUc78TDV85mOawrD6xus7HEzP3Cbc8hLjfXa1IQ5/BVNy03BdG0laW/y9K18j4
         XeKk8ggGYwZxbrt9rcYLmHiTzYZxGm9AO9EDCdfn7LghoeFoitE5iMJdn2TceuTXvqUF
         dIGiWv2cRKJiJqKCL0hJWqOpEePYC6nT/rleI/W4P6nuPR6d9eQk3MAISpgVljs/cBhC
         cWJw==
X-Forwarded-Encrypted: i=1; AJvYcCVsRGmm/iDkBcUe6amP9O6KfiZal4FllGoinIhGlZBL7FAoui4CKEstGElsCirtJ+TbiTZxdtWUOA0CaR5P5CYObnhhqWX2sQ==
X-Gm-Message-State: AOJu0Yy2Nhb9Xecr6CBS0lTbMAZBA688LjCp2DgY6W7W74/GGwjXNQLy
	0YAqRaqzSt2E1mA/QQ6g6c53gawmJoNeoUvQ3Sxc+ELUBMDvo4gydz9bF3kxQpFAKeAGKO+vyMd
	I3ujGSAuVmr5dYIUDycwsysZlHvhH6NZGGTzx7g==
X-Google-Smtp-Source: AGHT+IHWNtjVPQ97SmyDE7vc05XgRLIP5TFW/d0cX62CVeQ4XzpbMqbYToCfV9aVegqByWYG0KWVvi8nUX3uozUeCX0=
X-Received: by 2002:a05:6102:54a6:b0:494:3a01:e340 with SMTP id
 ada2fe7eead31-49743975053mr3518939137.6.1723533010700; Tue, 13 Aug 2024
 00:10:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240812160146.517184156@linuxfoundation.org>
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 Aug 2024 12:39:59 +0530
Message-ID: <CA+G9fYs6LCnr8UVXVmTPga-LjA4VuMoEfRP+=LEmQFZQxA+=JA@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/263] 6.10.5-rc1 review
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

On Mon, 12 Aug 2024 at 21:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.10.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.10.5-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: b18fc76fca1a63141db3c822c1b169a1ca4bb08a
* git describe: v6.10.4-264-gb18fc76fca1a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.10.y/build/v6.10=
.4-264-gb18fc76fca1a

## Test Regressions (compared to v6.10.3-124-g83c63da99a03)

## Metric Regressions (compared to v6.10.3-124-g83c63da99a03)

## Test Fixes (compared to v6.10.3-124-g83c63da99a03)

## Metric Fixes (compared to v6.10.3-124-g83c63da99a03)

## Test result summary
total: 257536, pass: 224323, fail: 4505, skip: 28188, xfail: 520

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 127 passed, 2 failed
* arm64: 38 total, 37 passed, 1 failed
* i386: 28 total, 28 passed, 0 failed
* mips: 26 total, 24 passed, 2 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 19 total, 18 passed, 1 failed
* s390: 14 total, 12 passed, 2 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 6 passed, 1 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* kselftest-timesync-off
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
