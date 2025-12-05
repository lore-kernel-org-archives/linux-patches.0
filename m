Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBE4311C20
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 10:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764930367; cv=none; b=a37Bhn95u9ejGc1l5WHtde69xuABKlIFd2FeW7mrO5Bo2A/38RhiNSidxch9UrsPlHXA3Q9t9bxE11H1TSXXIXoIhP0rcTndWwwckzoK36NzQK1gAjIf1+GpLgPDucbuRS4xDPHgVOeKtHHhHVgENCSyO43U9wyt3A3jeNAVbTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764930367; c=relaxed/simple;
	bh=0X44rTBFoZxC528+irDpQ7IbGw+Sw+8vgkxtYkeRM54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MYAStaDXbt4izRJRymXh0FmnCKZWUm6+wCBXjZYXTmR3BguCzpHX9TWuDigiowb7fHxkM+F4w7e/Ux3OOAZcq/8uE+pFvBoH8/RSV3LaFo6Y2xzwsp1pWlNFPkRliRTmF1b/Z514Uq5wbSWsx05mNGQ92pKnZBqWjqhws/DU+cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IASHjvcr; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IASHjvcr"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2a484a0b7cfso3559485eec.1
        for <patches@lists.linux.dev>; Fri, 05 Dec 2025 02:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764930357; x=1765535157; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OdDYSUXbreK3nnvrwRaDva3mvj8fpQE8bz0YdLVbpgI=;
        b=IASHjvcrLQ6cNR4KNGcMn4lZ8DtKjrP2lSYFNdnTT4ccCY+OUqBetzit1RPH2DkeDk
         XBGkMh0odVfNwt0PM8ZOPOQT8QAVQGMvbB51yQW11QPQmVX9FAJucgUwmhfCBL6/PXXt
         0bREl5Vhd2Rx6W0qgYK87b4LqM7IqgSoomrTpHgGq3GAGGeNk8s8qRX32K8aiW5oyI23
         0+47zI1gNfst9bvkvQK979y5hvmsQlvX4P+zseNBFqAJxAO1SDK3VuixK1wuTdMk2Jls
         paHAkf4zJvcPDqvVF6H+M47jOWLOIemjssZqlLD/xERhg9joz/67Qp9MHCGgtgmwv0bB
         J0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764930357; x=1765535157;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OdDYSUXbreK3nnvrwRaDva3mvj8fpQE8bz0YdLVbpgI=;
        b=MgYPak5yCMlncIGbyh7dF7GfG0TIIi5mkUuQqgnCtJj5CHn8zhC47KP2SC+yitRs6V
         gpFAIs0KiuUcZh0QoOu1X24vdOCXqcTAYvjq9GB2EafnP+yOGRWdsbuS4efjaMRy0hBO
         FvtbB9r/D7yq5eMJ437uGzNZk9UxN+sUMKttYe8M/tTHfI4WKRiXdKQSO2g0ogGy/z79
         iZXcTN0GgHnhCgK2+aIS7Lr9St6wW4+oS23AHf2ChZrv0eubJIB2x+iq5RkeUITagcDo
         ZekWg+MhKG4BklpLJi+D/Rhzrh8pWwIuIlxTbOfNKRKKKo9s0PNdkcxItKs4VzQo1CuW
         IexA==
X-Forwarded-Encrypted: i=1; AJvYcCVNX4adhiEFSg5bioXGGEX2+M57scQjjwq4NwQj4BWpiey+1UxIJMGW/mf+QB5I4C84dyOoBLFb@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6LLbqQ8wX3ejjO3BNVxkLQpnhs/g2P8YBEzI3WprCmi54uWe3
	0EM0MQgFo1ZHFRV+uevZKt2Axh8f3m3/UcgQlCNqv+1k5f7lQeVxEIJ3lHq1Ebh1Kv/sKInl799
	+Sfy6RwktD628ACpBxl4qFYmM7oqlWvVevqSv4Hy+pg==
X-Gm-Gg: ASbGncvIPJJEV1BeRgMOAOzILFXNI1HJYDWFccJiPRhOfjFRjsWTSYAvkCIEu/hHxdY
	tTIZr98cmtzVUd3dFpXai2mPXuhn6C+hbwcUAnXGZOu/bR6F2Q9b/KcJpAewip7cAj49J55zn4b
	hPapA7n1sQiyu225icnzGZWuPtj2IL2cK6C5eJv0wFacIMIkeVEY/XXNZ218KWmYQut5qekxIHp
	hl95IsZSFtqOaiyocajyF/CkU40Yz3/tEo4N1rzOFtuzkL21+JX1xspovmNZNDwn3jBYkyT
X-Google-Smtp-Source: AGHT+IGgJz5h9CNdhQnno2YzTuv99mFlBnV8wRHbHHIQaHsCuf7EysXn8e17W7rmAS+9f2bw/nXBejCaiWufe/9G7ac=
X-Received: by 2002:a05:7300:7b94:b0:2a4:3593:ccba with SMTP id
 5a478bee46e88-2aba33eb71cmr4631451eec.1.1764930356732; Fri, 05 Dec 2025
 02:25:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251204163841.693429967@linuxfoundation.org>
In-Reply-To: <20251204163841.693429967@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 5 Dec 2025 15:55:44 +0530
X-Gm-Features: AQt7F2pXdOQvj13bd5jjoOZPeEBtuzEGfrQaH4valfbj9TAZee-tH0PkAeLKvEM
Message-ID: <CA+G9fYsPdOY3U8rMcBHOvKz1JVjApCfZxry2GvO6bE6sKGbedg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/567] 6.1.159-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Dec 2025 at 22:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.159 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 06 Dec 2025 16:37:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.159-rc2.gz
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
* kernel: 6.1.159-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 2ee6aa0943a7e281eb5db51475b9c7e47d30be9f
* git describe: v6.1.158-568-g2ee6aa0943a7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
58-568-g2ee6aa0943a7

## Test Regressions (compared to v6.1.157-158-gf6fcaf2c6b7f)

## Metric Regressions (compared to v6.1.157-158-gf6fcaf2c6b7f)

## Test Fixes (compared to v6.1.157-158-gf6fcaf2c6b7f)

## Metric Fixes (compared to v6.1.157-158-gf6fcaf2c6b7f)

## Test result summary
total: 87788, pass: 72727, fail: 2957, skip: 11908, xfail: 196

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 132 passed, 1 failed
* arm64: 41 total, 38 passed, 3 failed
* i386: 21 total, 21 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 10 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 32 passed, 1 failed

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
