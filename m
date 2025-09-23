Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC5C12B94
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 05:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758605103; cv=none; b=emfaFuVYQLDaVD6jdiWHVZa4ZwcYFvPfvfTizGcxt9idpkvOg1h1IofHEZcrKOOsC1pKqsvFh49YAVz5MrX1W3n0c0GkWUJHekSJ/xqMTldOxju/mHnm4dsJyE0YzweXcjSvstq1Jd0XXN+K+I/fkLwaqUpk7NGIRj03awMPvAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758605103; c=relaxed/simple;
	bh=cm9sB6g65hW6yY/FNW4iDQ2FJw7IZcdkRm8PWxCVewI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C/pagyXcj7XdQMJ2N2Q7x4tQqtkFYNz2Iyhr8hUZB6KHKSIlYpt6O3YIToyJtM72A33qVpI9zR+6mVQF2flVXS/YI22af7+uxbluIi22n/JVSf/n3bVp6Sqo1FLkBiWIGVGA5ffvJISawbMYrPruvD+Wf30BEktgS1w00ZdLxVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hfjEt4CV; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hfjEt4CV"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-27c369f898fso8740505ad.3
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 22:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758605100; x=1759209900; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2l2GxVZ4BdK5rUKJmWFIDJCnFKVfvbZhz3z/nqrDFo=;
        b=hfjEt4CVZy7qhHaWExFmOpfC/zRu+kJ9M6J4O21qsjC5XxwjwwDCR6ZbUEshWbzIwS
         mGotx93JqpjCYl5vz+A6Ye0mu+HluLaqZH3Xpq0rCp52m7lrgS/TwDbEefsUqqstFv//
         qfPd/acsz69AciqjVWD/Avbyd3BlqcqNN6bgg14M82YdMF3yDkKmoUdEY3Cv98v9TKon
         Fvg3hqYv9xa0BFvEc1NsivpRSRNp1JTls0V6RoS+0iFWYFhKrCx0p/cbV5cTc5GcBHzq
         lMY1OxGHDzVI+pC332//1gAMTXstAmfkfija2cNsBb0UydI0/2uwkQLZYpcwZ5QUa4hr
         VIxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758605100; x=1759209900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d2l2GxVZ4BdK5rUKJmWFIDJCnFKVfvbZhz3z/nqrDFo=;
        b=PATMZo2cP7Hgpi3dIXRO+W+aOdmjNIP1S6YhzKINMY5hhmTzrbk60tv1bzCBTS7D8y
         OOmryX/HvZ07XICvpJgntEq6oEWTOq5DZ7KYRBiJ+6YwkM2Ava8AB2lIuh3EDKR1P6ks
         AiKeT5odFhMhHHlGSEmr1kmMuM8EF9G96GPJt3vklx8On5L3BnLC4R1311hbftQU7j3l
         3Td6QbXt30ccDHr5+M7dktts4ovE2fVA4hyXodXd9S8OV301fYso/dx9UqskCNqPoPrI
         uirANTpZ7c4Sgh7SIN9tVloRjl/lHTEaTSewBh4brIsw67jtDDX5qt2/339TVx480pfC
         bwng==
X-Forwarded-Encrypted: i=1; AJvYcCVXXcaQQFyXr+RXzB8V+y+7MW/3RXHoMqxeNREKYAHUdwuqvewiQLuOYcq8cfjFrTdzqiHXc/MC@lists.linux.dev
X-Gm-Message-State: AOJu0Yyym2X5jDYFF1RViUK05D6X3C+4ki3B9QFOTGrgmYL2nF0UjgyR
	vJdal+b4QjnYkjSfqNhjA5IPJRnEnJSUYY5SWzmpGsIEiCCeOvEuz5efeeVtYUGEb4b1WGymjqu
	5M5HZ128vmCSzHp3LTUdv21yvKegq7ls7Osfh2K7E/M8YMxTs9IgBm5loFA==
X-Gm-Gg: ASbGncteHZsVdNek2FUiPhDVQpRz3ZInzLOjJx7hsbI+5z7RG+9oSMNwJAUbpHksmOf
	EoEu47XciPTTBX5McKhF7Oxyq09Z6Uzicr0UDMPTSG6mzlOx04VmHkI3OPASsJqK335sMgwTxOC
	ukN76KlLFzrtriAfhjlZzRvOWr2KBKAUzfsISMDztW6vqpMRAwxMoYOMiiR4XY22hSnfALPqCT4
	ULDqVWEtOOwmzP2Xsq5sbWe29YMDNd3cpnVyDVm
X-Google-Smtp-Source: AGHT+IEaV7F+9T9RJ1B/iJxOIKWpi/n4+mjOfllQ91nyRkEoBIVGF5eOLfay0jwvAkJUj9Nn3Lo0U/QdY20V8G9vhd0=
X-Received: by 2002:a17:903:110e:b0:267:a55a:8684 with SMTP id
 d9443c01a7336-27cc1572869mr19903375ad.2.1758605100214; Mon, 22 Sep 2025
 22:25:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250922192408.913556629@linuxfoundation.org>
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 23 Sep 2025 10:54:48 +0530
X-Gm-Features: AS18NWD5DBQhbha1W-yJyIO5a2wFOXqU2hCi554qEwVFhyfdz5r4gIwW28W7lfQ
Message-ID: <CA+G9fYswyv3G0ZvR3C3dM6UuzQyuHVPcjiAwPRHxpmbwuKovsw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/105] 6.12.49-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Sept 2025 at 01:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.49 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.49-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.49-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 1fcc11b6cbfd87e64e99c97c45c4f8fda2192ca5
* git describe: v6.12.48-106-g1fcc11b6cbfd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.48-106-g1fcc11b6cbfd

## Test Regressions (compared to v6.12.46-149-g6281f90c1450)

## Metric Regressions (compared to v6.12.46-149-g6281f90c1450)

## Test Fixes (compared to v6.12.46-149-g6281f90c1450)

## Metric Fixes (compared to v6.12.46-149-g6281f90c1450)

## Test result summary
total: 319891, pass: 296933, fail: 6279, skip: 16277, xfail: 402

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 47 passed, 2 failed

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
* modules
* perf
* rcutorture
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
