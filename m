Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF241547EE
	for <patches@lists.linux.dev>; Fri,  2 May 2025 02:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746154483; cv=none; b=Y0aiYj8WqVGF/O7Yi5B7MQAyRVqIU3cE8oSyHphpDdGXbvXpPP8gVGQW2UrV3riRZIl1TZKp2SMRyUd4uKr6gU4ZKMAbjHXerQoRe8sR2V531NBScBvr6muvUHZOJ8aDeMXeltNfetAcKmbH79+WT3eMBC9OuOSrCgS/VA6SEao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746154483; c=relaxed/simple;
	bh=0hYuoJkG1HiS0affuKYm7oyM12/o0VWgq0bU7+BeSQE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IowlXjmDM0DjUJSAD5qmEyhqvUraTPB8DxP+HlocxMCAYSwnjvceSZtXbN6AXYqxFm4kyPBz8hWeYtQNzyWY3mg7GFXOmSM6+nsVWSTIr0fmT9z2jo5cptBmmMg9A2jM/KqiiSgwq/oRACV19kOswRgu6000ZvZaqbhYCdZO56M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=linIhy8g; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="linIhy8g"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-86dde90e7a3so355664241.1
        for <patches@lists.linux.dev>; Thu, 01 May 2025 19:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746154480; x=1746759280; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEZEuaBQX0F2OnwvUEVgaG6Yg7wPrQNQ4N5MN97UuLA=;
        b=linIhy8g8Cpzb7LinzPsHIQZnjyZzyOdsZROo0UWQH//In0vXTQ6LOwH4JBlVV8Kq7
         Ki8xSGz3Eg+RZkHXL5BDOpY42ZUnhcVeSXLnd48Gi8GMSkx6SX15aTfREb4J2/KvaUSq
         d7wU8Ww8rCqsvxo4uFz/3X47KaIb7eIvQlg2G9dho6wGbHvgtlNRIr9I5xRUhYxLoJip
         xgxv5RGMAKE9uwBaVp9e77OIJcD94mvFOlmQdcSNpYDmZ9+mGKVppWgZw5EEu2Xn0gcy
         IC1XpSNh8OWUex9ZBAVRJiOD+Q3u4u5ACyWfOewb6Z593wdWgavOSG5q/FnDXUtXhXxs
         dyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746154480; x=1746759280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cEZEuaBQX0F2OnwvUEVgaG6Yg7wPrQNQ4N5MN97UuLA=;
        b=D4qAwG/vNgVqUD7McQkWfU+7J6uKImX+NpgRiJVM8506OG0jPXakDa7xQFbL942kZT
         PTvpyHPwdSzVNfyIS+8nKE8XXoNUqmY/qEZWxYm53GuX1shqIVtPihh2bxbWzZ8oA46K
         fiKcLjYuf8LJdSNpDdddQ4Pn4u3ZFL4JFrx7ACTs4N2yacaUKZVvcrkY++Uzu5CPHe1X
         efL0SeOdP1HwUlpanWo1hzGDrw2dmiRUjWYBvl/NrgA/hBWamkxh2ZDuK56Y9MVCajUU
         twjDFmImLQbHVVzdIopIMQctjEE5G5uty6WCUSXjPnyYRgCUCMF/XJk9hEq9sMoe2Iq3
         wH0g==
X-Forwarded-Encrypted: i=1; AJvYcCUC54YUVPT0/xAt5JfDsa6cqj0xvk7HHcMLT0EkHZpPDeDppgB0L2NuO7cgi+ervZN8l4M5lLZJ@lists.linux.dev
X-Gm-Message-State: AOJu0YyxK4MvGorY5c3Za6JxLBsEcFiDcqTetsz/5uT91F9/+/Zo9ZvJ
	nU2Gum51X282M5uGDrGp4zi3yssUbZB90/WuMhfLFMoFBAagY/r4FgbCdA94+ixaPevbJl131AF
	/VyWiLeafjXxNAopbRB2SPcfFEynRRSSqKLZkog==
X-Gm-Gg: ASbGncuxvhuU1gCEmbV4xx+SopepebRqO83xr6lWEuntlRv7jjWo/hRIzBaGM3vgYTb
	TIMGLahsOO/lG40spYhjtgyNWbHvVDpr/5K01RL9RnWcygIU9C9g/N514wYF6jiYwZW2n2wik8q
	JVZk4Vx9dmvTONDDiMA/Ia
X-Google-Smtp-Source: AGHT+IEDIdOj9oMB0nKvbGRJkCmB7KOZ3tGAGHP+ARfItXrPW4FpkddRtuJsISkNkowV55n2pzm5c2j+ozEWBz9kQVI=
X-Received: by 2002:a67:e7ca:0:b0:4d5:cbbf:456f with SMTP id
 ada2fe7eead31-4dafb4fae17mr976341137.10.1746154480135; Thu, 01 May 2025
 19:54:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250501081459.064070563@linuxfoundation.org>
In-Reply-To: <20250501081459.064070563@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 2 May 2025 08:24:28 +0530
X-Gm-Features: ATxdqUETEfbQXoB7koW_BPnoWBWbalINWlkur-9r8oo5Yb17vFPnHyQy6r5AsNo
Message-ID: <CA+G9fYtLUfJs2zAzvVhKN4Mo=3ZH455dnfQwc+Ck7HYJEhDUUA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/368] 5.15.181-rc2 review
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
> This is the start of the stable review cycle for the 5.15.181 release.
> There are 368 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 03 May 2025 08:13:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.181-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.181-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 85e697938eb09a3beb10ccd150f64f998876c4cc
* git describe: v5.15.180-369-g85e697938eb0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.180-369-g85e697938eb0

## Test Regressions (compared to v5.15.180)

## Metric Regressions (compared to v5.15.180)

## Test Fixes (compared to v5.15.180)

## Metric Fixes (compared to v5.15.180)

## Test result summary
total: 76543, pass: 58926, fail: 3514, skip: 13517, xfail: 586

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 30 total, 30 passed, 0 failed
* i386: 22 total, 20 passed, 2 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

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
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
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
