Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF5720322
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 08:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318311; cv=none; b=Ud2hfFDauWpObDMYc1L8WgV+qJehpu4rrvFqC4Xc3VWUqLBbAas2BmMlwdcPpB8oW2G4hFUOiDKv5GcDDPS48kPqg7WLYBLHUmgzQso/pknu5tqz24Fl+2lRP93Pe7ZdhAwquGChUq/SyRckXaP3c0CnPmD/MuFUyhkPsv5A3ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318311; c=relaxed/simple;
	bh=2LrVIlClEoUiMukkkRWfmFHxPdK2pBDVDG09zud9wgU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BUp8GBqBtRKoJWOtHrmZqVlV3BHb2od4E1RAggascTPTi69ezM0Wjcy+pHaN0Q0oxtHnktS/o4GP0mlTmbZnAlMdCkyPyseehm/0HQpY+RbqWxdcYeIbzBbf4/chkk7D+kuOsTN6TS2iNaCYkgh9bypzWId84VraLLeRT3leKDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dBsCeQNo; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dBsCeQNo"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso1097357a12.3
        for <patches@lists.linux.dev>; Fri, 28 Nov 2025 00:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764318308; x=1764923108; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5uYrd53GbhqnVXd+rWaqcOqymzSCbRhWWrjjFVeFsww=;
        b=dBsCeQNoCGEd2W9sb+W8W9MbB7S0NQ9E1IT5+SQRYs30e1snHelEcMXkKWvw274Emf
         VyUgeoGd+NOmUuJ6w0yka6WQX73z+x3LLxN4l7IJVHOc964hLuyI0gf03xMZq1acIDTZ
         ZXIwvXHUgEQeLBZRZdUfFK6B45hyUzd2tU6pFr+mebMhs2UN7S7ZTEVMca1+nfBj/RDr
         XdWJ41oPo0cUBhhVTNhdnwWym3vwxoD6FJRRERU/2K7+MKfcOlUzPiwfu/wQ46f6D/LO
         S6wbsF4I/uQ1K+uoSdpVnnJDiFA0XcA+ia2ZoOqVXvVkl+tCiuqg3yoaxOhV5LpKXMnY
         +CMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318308; x=1764923108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5uYrd53GbhqnVXd+rWaqcOqymzSCbRhWWrjjFVeFsww=;
        b=JCSIXxbiKNKFzwz4zdcFTzSnGT2W2RDvztjNxWYY0MprOqiq7II5TZnGVYwXAn2QTJ
         VS9UwHLGX84CDMEz2yV0Gdawu7fUcQlDKTUbJNjTrRD7Rb2H5PmGedtq9VUPo7l7RH/J
         BLZGNbIDHVFk5KzCzuz6SYOycBcSUZbROCpdtp8z/ytXzFJYaH7WaDSMs9h2wKI0lIJJ
         t0FtmUsE3Q0sxCw9A13a6eBP6eeCS5b9ZRjZFAqWiFMtmDGHyffE1kB1G5zd7ulsVzAO
         nud52D4fr+yuWfegDeMQ2ArY2Q3kKS5rMq+PjOuPJ1igI4DOxaZoDBR497VQJK+sbgWN
         kcGA==
X-Forwarded-Encrypted: i=1; AJvYcCUTm6U7JJpDstsHQ9cpQzFntARleheZvwLd6PMhhD7A1KUzOWRWSiuB7hc8EB10E2W9iz2oc4Ln@lists.linux.dev
X-Gm-Message-State: AOJu0YzJd9seR/idRcvJFtnXdPxP3AnVWk6BXlWekncPZBKYTVl2DsZ1
	wyk5LeCHK686vIfGXpdl7pMgg0LKDBves9YWL9PMoEqtYe9Ie+NB44d2AFip+hylMyqGs5okVsg
	ObNFAGH+0dWLQGj6TjynF7j8qNI93Zlro2jQGxuf+ug==
X-Gm-Gg: ASbGnctrycnuz7ejPSTDRlNeCb0GAHO3Gesp2yR443XbM7Vm8ePkFSmFSSkif/xPBXd
	yMpXF5pgeXiKTParrgQUN7IdF7EGCYclW/STC+fsA996jHWQbBeKA+JIJcp1/w8nsLMX8wrNO7z
	pdkC+yyf+kqq1p/ManKgWp5tvRCIJW+DC85f6LZvGcCj3oJkp7qi7ogOtVlmYyoEVz+xONfN3Ox
	65doHW0ZhxKMEZs+sTTNF7s9EldcbE/a6BzcHe2clMT6m4XTIeptqLUPSMWLQ3SjORfTZvl/8Tv
	vMzK17LfoSV5OV55PCGBV72j0lCbw+YRVA1LpZM=
X-Google-Smtp-Source: AGHT+IEX7w/0sdxjJ1WFSvglwlncuFs5xO10w/ShVlOuFqUOcubjwaYoOiWLKgn6Vu3slhE+eujlA+UaukdYtZ7hkx8=
X-Received: by 2002:a05:693c:60ce:b0:2a4:3593:c7d2 with SMTP id
 5a478bee46e88-2a7195c9a07mr16497327eec.18.1764318307733; Fri, 28 Nov 2025
 00:25:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251127150346.125775439@linuxfoundation.org>
In-Reply-To: <20251127150346.125775439@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 28 Nov 2025 13:54:56 +0530
X-Gm-Features: AWmQ_bkjyIxjczZwplAkbFTpE8x3f1OCIMqCUZQihFzJU3KU5PqE03bUZAlNnIo
Message-ID: <CA+G9fYtkSLQXSiv3XqK=e7kEE6EzhN-i=xcTiKdB2SoH9tMh_w@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/113] 6.12.60-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com, 
	Sebastian Ene <sebastianene@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Nov 2025 at 20:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.60 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Nov 2025 15:03:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.60-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.60-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 375669e5645f465d87d534f0be2eef993e3c7bab
* git describe: v6.12.59-114-g375669e5645f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.59-114-g375669e5645f

## Test Regressions (compared to v6.12.56-605-ge6b517276bf6)

## Metric Regressions (compared to v6.12.56-605-ge6b517276bf6)

## Test Fixes (compared to v6.12.56-605-ge6b517276bf6)

## Metric Fixes (compared to v6.12.56-605-ge6b517276bf6)

## Test result summary
total: 121315, pass: 102842, fail: 3825, skip: 14279, xfail: 369

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 51 passed, 6 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 46 passed, 3 failed

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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
