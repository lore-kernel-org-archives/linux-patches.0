Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8D81F0994
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 19:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750880526; cv=none; b=W9DaSNd3dHKraWiSYK3MOhwYDRTe851OK3m31smFL7idcGn3c9Ql/QVW+GYdylHPnSZhFm0Y4QP9BIFfjvXLmCPV66SEHgTRSGUomiUcNBTTIcDkDi7zexs1U3TSwzTXPBOaEOsEOnBlxj/FyrfedBZOrMQNCOoqyIaTQ9chZD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750880526; c=relaxed/simple;
	bh=8XtUwx2BwLQL5hkf0DSUr4YxplMp2dK1xZtzuPCx+6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E8vWicPaYMPiu0b2R35mA7FCosRGylKJh/C1i4NgcX7SjQAeikdkOvr5HNlq2Ozjf8HkkDzTTl542BywETeeduMgh49DdHQUQPyaPtXNLkaqBSK28cgiz3wajf5bG4j3AHbLCzxs0x4iHUZyMYelzOAp8vbBIsH2ou1WyITJyJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dlU2oXmv; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dlU2oXmv"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-236470b2dceso3777475ad.0
        for <patches@lists.linux.dev>; Wed, 25 Jun 2025 12:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750880524; x=1751485324; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ITnI0wy6+aC2aZG3lyBEjNmPitHxk8dkEkiBg5lq/Jg=;
        b=dlU2oXmvkMQDv9FDRo87SAce7+9TKiwCdJnkJ8MW//f4J4udNLf2yruSrg+LVvm4ts
         yQi0SYyCw2+wfAKbjSSmDmjHglW+g6M/Ofu7F4vj205oPsvC3L/Fwzz9uAQf3CNwKMmA
         dWZ+cGKlBwlxGIYSApTRI/CUPoOt3vsZp70PbSJ7QdMYeb0oKu2oUthZ6BNUk6SUssPC
         cX4u4YFhyaBoykHClxleyQrx/w+eacAiXMp25qyBp8MLS/UNLPvHH2rEwpSOwwGiZ1r2
         bOhltb0rwOvrtkfkpXScssa6KPHk9j0SOoWXtvvIWYM+LjGV0JTVZl7/95L8TkiBpcmQ
         PJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750880524; x=1751485324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ITnI0wy6+aC2aZG3lyBEjNmPitHxk8dkEkiBg5lq/Jg=;
        b=ptMl5n8T/cPFQiaphFYoZc7Gbr4MnZnR1mYXVmq8BLkI3GzDwlx0+0v6xEgjRwBJSh
         wXhAIheOMLfDCGkDPwXo5Z19puESPVfj7Qoh+9VWnH5XfYmOZHAL748VUDR0GojKneaA
         EKq1I04pUGFETdutN1yD40pwCuvQuptR9FB0F6dfX9bmZ6HWAyiUPC7StgjLS1uCoUFi
         Yhs+5+dyfMy8R4jXfG21Zt7UlFBo/hbLoSZhK1Pn+HGo47zJv8Y0/qPHf3COs2k+uDcf
         DRBYnKTeZuBl549PlasVgyxdKjjSlcFmLky9xOj0rjm9ZFLFe1HMF45ovelVN0MJbKVm
         3Zvw==
X-Forwarded-Encrypted: i=1; AJvYcCWFgQZ/tnXQcZt7egYbX1MvlIwskcdwQdL99bRQ24z6XXPyXU0B0QY6c4V1RpTi21HBYdXvtCdx@lists.linux.dev
X-Gm-Message-State: AOJu0YyEN0pl1UzTCz6W4SWfC1zX2CAik9X3k2nOuRM8OYQLTBlDF+nK
	9V1aySZAHxClDIveB9sczxSA6NxrJ4XttzJe7jD/xa6jOB/HBn9vFFnMdlA7ufL3QD/vvC3Ch1E
	mzUMuKf6sHVH3SR483q0RJI2XbHZIV/kcDILCXjBEEw==
X-Gm-Gg: ASbGncuELhmGA2Q+umZymKu4xi9WFUwNinhQh2SvBrNlO/HkdbvC91FW2MqYEGMeFwM
	zwwWvpfyKoGJqN4qI5w1czQmFid+ej6ZOnmOSq3x1Tu4zVhTuuXVOjKkvS3wqQnpf8JN3YL4VyI
	QqPkaXGlA+qTttm9K1a8DS5dcPkK31PfWFzP74lILcsVYLnwTPnycX4Qz7DS8lPQP9GnWqwb4IB
	HlX
X-Google-Smtp-Source: AGHT+IHI7fLEELCEdQECz4jvJ9vfnnYb912O9SMYpH723cQLFhWR/gkWTkcZd4ZK1gNY8Dl47Tx/LTqNtu7WTvEjmvg=
X-Received: by 2002:a17:902:e80c:b0:234:cc7c:d2e8 with SMTP id
 d9443c01a7336-23824062835mr66798525ad.37.1750880523839; Wed, 25 Jun 2025
 12:42:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250625085227.279764371@linuxfoundation.org>
In-Reply-To: <20250625085227.279764371@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 26 Jun 2025 01:11:51 +0530
X-Gm-Features: Ac12FXyBZWFqQp_A-N04cBiioXbW9Ot02Z6PLnqwzoIAurmuEnCDQiactbZEcG4
Message-ID: <CA+G9fYt59B7zrOO3pzF_7c4ECCOcG3JQKK6kiKXN+AztFuDN-A@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/215] 5.4.295-rc2 review
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

On Wed, 25 Jun 2025 at 14:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.295 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 27 Jun 2025 08:52:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.295-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.295-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 1de5ce8d465e02df0b8d08092e497eb9636c542d
* git describe: v5.4.294-216-g1de5ce8d465e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
94-216-g1de5ce8d465e

## Test Regressions (compared to v5.4.293-205-gdbf9e583326d)

## Metric Regressions (compared to v5.4.293-205-gdbf9e583326d)

## Test Fixes (compared to v5.4.293-205-gdbf9e583326d)

## Metric Fixes (compared to v5.4.293-205-gdbf9e583326d)

## Test result summary
total: 39680, pass: 29163, fail: 2048, skip: 8349, xfail: 120

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 131 total, 131 passed, 0 failed
* arm64: 31 total, 29 passed, 2 failed
* i386: 18 total, 13 passed, 5 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 9 total, 3 passed, 6 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* boot
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
* lava
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

--
Linaro LKFT
https://lkft.linaro.org
