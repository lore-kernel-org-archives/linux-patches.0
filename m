Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A926F199FAF
	for <patches@lists.linux.dev>; Fri,  2 May 2025 02:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746154646; cv=none; b=d0qQqD83HmjMvmJ/ueWSeUsMNiune/yIvqgeR19yN48qDG+OmeNASfxcbNrBJ/L0n3YhBrbwB+wZieXYS1TCbL47qOl7m+Y7Lylvhjse8NB+WGE6wVHROVsg3P3Pn2ldnDkCo53d1Z22f3EbQ3xF4esVQWkm7n5K/wbg5DsQ59w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746154646; c=relaxed/simple;
	bh=Xti1Q8NVpaW0SAekQPjXI4HoFyiGloMcGsvei40vPu4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r8n8G9D1sd4DpDySeijoF3+FC9yCejXa2UEDWNnlmRJq0zGJu1sWpb0GlaiiO0wOUuvw9rlMYz138F/84FcDnRexfVKIz3d6zhTrQngdafHwms0ZwZ9MZ8ow4tA+1fqIRLgfsDDZKgRO2jWkWHH1o5QqeL+i8UGrzrpvhUKDP7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v5hr8Pav; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v5hr8Pav"
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-86d6fd581f4so1612272241.1
        for <patches@lists.linux.dev>; Thu, 01 May 2025 19:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746154642; x=1746759442; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lpv422QdHa8iuGl+dZEsxSBPRHtPDp9WBE8ZtLi4eok=;
        b=v5hr8PavYFgM1HmOdAIVUZMOs+PllPePdFuBKstuwIQaqlAfeGMawFDmUkA06PavPS
         /Tu38orDqu2CTOLM62btlgZPKTgudrgSQLt8T8n/RU3aURSSsauY7qbUDVp3WiOkJA1w
         qCkkd9vOGWj7nRZBs9VExRI9h54a82UsV1Afj5HulBj2UV5R6Kn7d2yGraQxUTBhxKVY
         xiAnQAAzVNxtT7PAgcnPHvSN4+HRnwSPh5Jt9JfNBzrkDTalsIpbLe1N719Iqy//QRmV
         avBxCk+NaZqxOaE7Hrfw7lzQ+K4Gk0s2dwUO+XbU/6JFYOy90qfJVVRHypK09051+cDz
         G74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746154642; x=1746759442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lpv422QdHa8iuGl+dZEsxSBPRHtPDp9WBE8ZtLi4eok=;
        b=HnpabbeaFy9Cdgu/uzIpwBMgrIFoDgMzDGaWzirOsu3QBDXmESR3g8nPgYInRaY0Wm
         euj81mMRvWmTRQAMbXhkRcSVFoE8Rxe6HMzQgIDcWqTAZ5iPD4iamPfY4DuD2vbBR224
         wZIzbzZxi0ka+QMTqxEICtFUubQF1PJ8gdD9qqEg9YBS8pOQMTp31ioV38PKHGNBvoQO
         Q/GMDjDxnyhQjmbTuDwNuEwmucdGetS+goTdq53n3QfJQOxMl7A8px/4ecuRdliP0c6l
         1ApdcC2lYoTSpGUvHjlQcC975hN3Zv2wqLoTEkaOTWDaQreYfBlL8ortmXdnwG5eYx2K
         y2nQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkcz+E6ldnVdTiTdNMkWTaYz4rjx3dC2b8ivHRzpI6ZXt5bYvBv2anUYUD8GD1lOeFlvttDH4l@lists.linux.dev
X-Gm-Message-State: AOJu0YyGkGyg9RYrAt2BGuVKTYB64dIOwApvvoQ+GbAP0b/0Uzar0FiX
	oWYg7+x+KnPxb5fQaXTWpFegRZqMfq48YAK05vzMbuZPqb+SKCDYTJPKxeFSgclbU0+fu6VM3D5
	Xcwpz9b7xicRNLVVozcG+Kx8v6+vavbiOrGLxpg==
X-Gm-Gg: ASbGncvLBuyQZzQ/KGNN0he41SPSGXWQ6+E7Q841TJITmJEU0Ja1f9G1Kmj0BpXBLQp
	SKVHESwC8m2LPbxMLh7vogJfVpEyWy6uZyDTqSxG0R2heZ+0m33/Lbc5mVAzPU21H+fFPO2GoO+
	yEeNsqLkV8iXXw0t0FpwSz
X-Google-Smtp-Source: AGHT+IGnYlmTarH7APTfkjBdOgnxELdwGSUFkWrvBO+UOVEjMcvmdgBKNUyZh1FMsKVsTM/sryK4beIQOmF8+UuFkvg=
X-Received: by 2002:a05:6102:2c82:b0:4da:e6ed:19a3 with SMTP id
 ada2fe7eead31-4dafa71096fmr1216716137.2.1746154642592; Thu, 01 May 2025
 19:57:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250501081437.703410892@linuxfoundation.org>
In-Reply-To: <20250501081437.703410892@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 2 May 2025 08:27:11 +0530
X-Gm-Features: ATxdqUHdQ5bvFT7Z7Koe-Ur1Vf9C3tvV2SY3HT9fNV_i8RmqYFHj3b3yFdOKGL0
Message-ID: <CA+G9fYv7jtmdCKOchbeCZSJhFkeV4Q7Ks7AX7+u4cn8Gr33HkA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/196] 6.6.89-rc2 review
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

On Thu, 1 May 2025 at 13:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.89 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 03 May 2025 08:13:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.89-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.89-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: da7333f263c37f74e92d643739aac42787c70e79
* git describe: v6.6.87-586-gda7333f263c3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.8=
7-586-gda7333f263c3

## Test Regressions (compared to v6.6.87-394-g2b9f423a149b)

## Metric Regressions (compared to v6.6.87-394-g2b9f423a149b)

## Test Fixes (compared to v6.6.87-394-g2b9f423a149b)

## Metric Fixes (compared to v6.6.87-394-g2b9f423a149b)

## Test result summary
total: 141532, pass: 117269, fail: 5272, skip: 18402, xfail: 589

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 27 total, 20 passed, 7 failed
* mips: 26 total, 22 passed, 4 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 20 total, 20 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 33 passed, 4 failed

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
