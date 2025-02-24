Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FD11FDA
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 08:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740384952; cv=none; b=Qzddr9ip5HFxtkmcoTwYv8Mw1q6YjGEO2Fbn1aBORGMNpfWNNPFSpN/SmPiXaXOcmKvH6PhRn0NUakeq5Cq1+97v7krNhOG8MyKs2TaENCReAd59eU/5rmZv8w0vNm3CEep6LwpDoHBOAGw/BFbvqvsY86567TzOccs4QcQ9KpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740384952; c=relaxed/simple;
	bh=GWOmq/SU5FvkARyYsOTefg//x/uWpGN7kXITX55gZVw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tQ4rXLZS7p6HNPpKQM7Nn0Xs7Yfvx8HJdXxK8vqP1WIXQzYbZxbmJRWcqfN9TdlPZZ285NRG2x+BF8IyZhca5tYwO3q066aDU0GfPG0ubux4d8pdHhefJ1XdG0NB9cU3LbFe4NFMsJtmMLSq4F6Q+hQQg6PjRnMwxe4rE6Bw164=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z2pF9Uzl; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z2pF9Uzl"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-866e8a51fa9so2729969241.1
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 00:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740384950; x=1740989750; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KfaExuEzw+yi+UhF0ndMdtO6v5AbFoFgAvWAoNTpMdE=;
        b=Z2pF9Uzl5PEg6dF+yjD3HFcVTRpZMRQgfdA93GKsOENdTihdReoKOdZwCOlFHTod1U
         hxtsYGX77X8ZuGQwwHosd3h5Id6SP40lExcEpTvKIXL14JI9bO07wqC4F/E248hRnXO7
         EsXch6E1lWgG5kAFL0poEZ/4l+omM91FhzNFz75lEXVTvC/GomChb6fF40IfV+zwNKXd
         coQFvePU9FRAYH3l6kEebKSIVJgI/o/Qrr4+ZL1NpMg5mt8gCeKUjSPSIxnGGTkko2Nw
         MAkNgjkCdbZIAlae1OoPPcujv2IpwwMl78c8SNt40p/WfWaAMyKKGjfOalM47RX9YPN9
         h6Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740384950; x=1740989750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KfaExuEzw+yi+UhF0ndMdtO6v5AbFoFgAvWAoNTpMdE=;
        b=M6T2DG4cWox+rb0AaI5vo9zY5IWIbk8+28EPPN7u6L8DBa87lMbL18epy7S08ZKuJk
         jd5deEvMkK9xG4TidVkUAtkKpDaSQDSCKAhVEMs+JCtXSMd2p610inn/GpKD0ql4YxX9
         jd0wYVoOlmn6rOeHYylurWuiXx6J5LnPm/LCdiOHzZDUun7NsLa7WghGOclRq1E9Thsu
         /6L6Ll9TTdrTt4ElRKLa0VfZb6yvoJaX3LMv8snzosoOYmZrXvc+gBKqQ6UgadKWBM+p
         yt83p6plXDZaVdoHgkxgu5EI9WGzL8+Q5n4vBKCgcS3u71lrmbSHliWLD4vNlcjs+6HX
         7QeA==
X-Forwarded-Encrypted: i=1; AJvYcCWHgwUFQCRs2g+TwqftmSReTZW7BmKQ7Ivzfv+PrlEwclsoQscerRU+BH2yveQgrS35VPxu07SF@lists.linux.dev
X-Gm-Message-State: AOJu0YzpzBarlKsPxZQdA7RXzSFo1V49hNN0hDBFex/3wLQtLpaqGvTz
	skjQbq15c3zsZTrT+eCHPGJFWAojNdpgAdUcgKUySQ7mmu8n+3IvFIsCQvq6NjZwD1Rpo7LfrMh
	2paAcBdItOWwvUOP0fDOrSOoectcaVwrTYKiyKg==
X-Gm-Gg: ASbGnctwPtKRmPayHpgjR8Zgfql7Eko63c/02jpxqKmPyOJMT2PgPi0QWcJxpxsLR/w
	YYwdMQaMvzg1zo1R9q6rYopmnm8jl119AgVMKHlasEsLTEGHLIT55J0iFWK1r6pQwPHQNo2kmb2
	zFFLJAfgD4PEmbErtFtsAnrm1B91QMiNlTgXDfLLMw
X-Google-Smtp-Source: AGHT+IFc115RJeH5JT0j+3w3wvCrq/AUOfV/8I4K53IvbnOg1TsmznhiEqqpup4LggCT7+8+VL7ZRrGjE2PExyTSqDg=
X-Received: by 2002:a05:6102:370c:b0:4b6:9ba:72c0 with SMTP id
 ada2fe7eead31-4bfc0d99c32mr4822022137.1.1740384950049; Mon, 24 Feb 2025
 00:15:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250220104454.293283301@linuxfoundation.org>
In-Reply-To: <20250220104454.293283301@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 24 Feb 2025 13:45:38 +0530
X-Gm-Features: AWEUYZn85dY5ySPbnb-rOAoLV4jXZBzx4as3Ge9fLIUK21jmGyMeitK2qFepA6Y
Message-ID: <CA+G9fYuokw31OLwLC11ipPZ153PT7+mEddA3vF=KmPMF=ajvvw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/225] 6.12.16-rc2 review
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

On Thu, 20 Feb 2025 at 16:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.16-rc2.gz
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
* kernel: 6.12.16-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: c3d6b353438e989b2ec07730a3454b583937b796
* git describe: v6.12.15-226-gc3d6b353438e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.15-226-gc3d6b353438e

## Test Regressions (compared to v6.12.13-419-gaa95ced31609)

## Metric Regressions (compared to v6.12.13-419-gaa95ced31609)

## Test Fixes (compared to v6.12.13-419-gaa95ced31609)

## Metric Fixes (compared to v6.12.13-419-gaa95ced31609)

## Test result summary
total: 126820, pass: 104027, fail: 3980, skip: 18747, xfail: 66

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 137 total, 137 passed, 0 failed
* arm64: 49 total, 49 passed, 0 failed
* i386: 17 total, 17 passed, 0 failed
* mips: 32 total, 32 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 38 total, 38 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 24 total, 20 passed, 4 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 3 total, 3 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-kvm
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
* kselftest-rust
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
* ltp-crypto
* ltp-cve
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
