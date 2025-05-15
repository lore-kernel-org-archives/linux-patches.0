Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3CE298C0B
	for <patches@lists.linux.dev>; Thu, 15 May 2025 11:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747308684; cv=none; b=HxBa86iqAxB8LlL54uJ733OJEo/zdV79ZuWVHxAUbROtH6gaQx2ODT+7L2UNergGRsB7AR+FyGrDHd6y80CnwB+2pu3124ciGux6NYkBs8eH+2FuN/XO6UCNXF3Ha9iDFJAux6vj3Ozkd6EFgrh+AuB8yd/eYNe9wpLz6JcJo7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747308684; c=relaxed/simple;
	bh=qsRW3vbR+o2v/z4yaSsJHASPkM4MT6K6sx7naxQV6xU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i2i+5pkkIEWD4uEVFRgBdIfjtKIpd4LRdi4MJu4HYU12QKw+f2J8rxvblAsyNGYTJB4rykHWfjmhG7PdyFM2zacKv+wherAxm2iGnj8NV5WhhuE6E/8c9IDQYu07xQbKpgDpVLft6uBzVxVJhpOtGoEqpmiyvg0w/BDdylIUFeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gCSFqr3m; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gCSFqr3m"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c54b651310so109563785a.0
        for <patches@lists.linux.dev>; Thu, 15 May 2025 04:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747308681; x=1747913481; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxEWoY+VW2OrREQvVPjH1SD5TqWAf78OGCNTGWqFpeE=;
        b=gCSFqr3mESYaSq2njmD4lKRY1/YNw/FQ+Qj1N9ZJkVnn4Gv78naVYkbhrkAW4yF9cA
         yltJd/rQSGvitmp9y0nES+f72W1pNElB6X1a0d0ROVDF/XyaRMRQ328t38lOCb3QMxYk
         T3A288Q996oUfxFaFK+IEWS46ovjzbHpDwjkYL/zdXLPCgbBNt/VBv/9FJr5s52iDoxt
         96s/lYpmPqzix47mGQtBMvtX7f70xNoCJZNhRUgPKBzHAWYWprQG/qy1J/NhZbqobbXy
         p9nOWnYXUCj9B940xDwPp84Qmdji7rv6xqfHa/R8c1LSXgBhKYo9GKRPF85Bg7NfY2WO
         n6pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747308681; x=1747913481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PxEWoY+VW2OrREQvVPjH1SD5TqWAf78OGCNTGWqFpeE=;
        b=tKUMgkY0QToB2YizkgbrkDEXZWJzKrnqBJny5ozajdrRF/ivFTVq62fkKw6Eku4q4k
         6dMKtX+bL5iASR1R8w8bExsP5Q9N0w7tgWHstoMtwyTUA2Wp6/cAzrFZEFW0GfZ9BcQl
         qKjasnN1P3REfTK0vo/FODlnJIEJJ1r7coGthMQo0VMSLMfipQafhtwAFxEEaERp/7Xy
         lKeLeuybMlEzbs7+Oc/8K0VBw+nA++0Tvc7Vr+Fbnjs+MVPGlsvHQ3quGfFPXdLoIblA
         m17nMNqHeh5MKbGpZM2o5lz8doq65IwWH/gX5csVvprw93jXASrVM5OP5ywGdFwXojeX
         qRCA==
X-Forwarded-Encrypted: i=1; AJvYcCVGiPFNjKzEQLh5GB7yCcO9ChMsCCAk42+JT3cDrRxQ5tqV79reX+pbKOVBOKo1CLCNSL0sbYAd@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd7ge3xLVLjodkd6OnGZOFQPcPE49fBE9SoOkjiOJvJJowLYMn
	3qioNRozBKJ0n48StPs5i1tVpougNGWW16GrRj7FB7MDS8OFh8obbE+j60clx6sNGkoa3cIAryk
	9W+8CwYHAXOjDEFw7bMprDcj6wWZujJ2uKqwFRw==
X-Gm-Gg: ASbGnctid9bCUlowNjcwCzGb96s6oeznBtGbyoXrApa+XX/G04p05lH9iCZgYnpTuif
	MRKau05KEESN1BQTFmdFkl00Bg22utfTr57yUXwSKtyq1URyW7LhGb9jhBrd8VzZaNCi20L/e4m
	F+jpKmUHnbFoeTU5pGliO0U+FSXb06xw8=
X-Google-Smtp-Source: AGHT+IEYL78mW5V6f0UBCMXnpjVvkevNNxPGw6FlGXVKZwLAMco8C8nI+r279fEjTclloL0MN9zBtHMl8DPg+40OrXo=
X-Received: by 2002:ad4:5946:0:b0:6f2:d45c:4a25 with SMTP id
 6a1803df08f44-6f8a4c3fa83mr29897206d6.41.1747308681497; Thu, 15 May 2025
 04:31:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250514125614.705014741@linuxfoundation.org>
In-Reply-To: <20250514125614.705014741@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 15 May 2025 12:31:09 +0100
X-Gm-Features: AX0GCFtHAVDNN5xGothkArj26zibJHO1rUyFkXyYkWWTeICME1w7EGNWEafl5bk
Message-ID: <CA+G9fYt0zWzReEkj2Ys4GPrAg+Q43Ph4TxNW+yS2w_NtfZXZ6A@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/96] 6.1.139-rc2 review
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

On Wed, 14 May 2025 at 14:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.139 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.139-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.139-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 03bf4e168bff87c44b4f1102d5c743a14e71c564
* git describe: v6.1.138-97-g03bf4e168bff
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
38-97-g03bf4e168bff

## Test Regressions (compared to v6.1.136-100-g7b2996f52bc8)

## Metric Regressions (compared to v6.1.136-100-g7b2996f52bc8)

## Test Fixes (compared to v6.1.136-100-g7b2996f52bc8)

## Metric Fixes (compared to v6.1.136-100-g7b2996f52bc8)

## Test result summary
total: 98968, pass: 79519, fail: 3690, skip: 15516, xfail: 243

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 25 total, 19 passed, 6 failed
* mips: 26 total, 22 passed, 4 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 31 passed, 2 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
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
