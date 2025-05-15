Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D92224B04
	for <patches@lists.linux.dev>; Thu, 15 May 2025 10:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747306758; cv=none; b=lHFlxl+y2IxsoT8ndcVefAjCtzLZMCltEXxPr4mTLUwXuLgpngRVBrA9kPXPWx2qzn/n2HpCMHubO4IoP+B6tEJvvvcOBFnTH2e6oI+Kr9NYLjB+SaA4Hm+vDlesB18u2vhLM3XUXFs/KydI5lhmdHhCsO3yIWPselSTT8ohN+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747306758; c=relaxed/simple;
	bh=9QFwZcBibBVpLT6/+3sb4orxgmkhJC3pvmyLj05cBT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CQK70K7LAHimIOiP1hYer5SWN8dpTEBA3S0PVfCrHQ6YUoT1ksFn/5LLNnATz18pzOVivW8s85ztR//K491ZgU+AQXEXM4msxlgBbTilwZ5Kcxp/dvlTdaEWfzkrN+90zj3jGMMFnH2iUP1dk3FgYYgNUlcUgS/C9okYZl3ONdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=stDk91gQ; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="stDk91gQ"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-879edc092e7so200552241.0
        for <patches@lists.linux.dev>; Thu, 15 May 2025 03:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747306754; x=1747911554; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qsRkLMqMxQwLJ0CXylasENbOTOGM70G82AyMvQWY+TA=;
        b=stDk91gQABd9Mv8+1j+PF0hrqC4gUYyiJhM98u7Xz4HeaGezGeV2XKv2FzWd3XRn6r
         PeZaDyMq9/tpMlb5uWu0+WQ/LKpASl2AZWU4an9C0Ym6oCv7TfjWTFc+XUeA09jDBycK
         Nnx3ISocyTxqpbt/aUoqU5h2G8XvnCGOmoIvnhuKCtWVTyk9NTdksEyifB9MZlea4Ora
         736LWQ11pYrlk93Daj6jwC7vOvJp6b3RkUANlmfeNVf3NFwZ/Dw3VV/jHrWwaJfZxwZ0
         1M9nQ88Md8C/sqqjOeINwWyhaTjhux4c/rMD1lftmp5IpsW0bRmV9DIl1X2091NsUWbK
         Z/FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747306754; x=1747911554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qsRkLMqMxQwLJ0CXylasENbOTOGM70G82AyMvQWY+TA=;
        b=SI58DImt3r97RK8TDH6Goq/bOx3hMIpmFzyrGnbXmcOekS8DYrKHiudzutjKSsEOdk
         PUGvBTjvEGBIICi3NXHvEDx7BdklnOwLb9eSyyhxkaoBr5y9i2QPOTo+St0dTGFRrMxq
         GlAyedGF2iwGilKfSdm9MBtKjOoZAC41de1JtFha9NnSJ78n2wgRIT3KRCTMNyJL1WgX
         ivtOTi2jqE0+MLIkq5XZF7V8jql52QKaFF4ThfdcewMXv1oHNdF5G5BjnJXb6a93nm27
         ZV+tw8/2M3vEHABmuE2w2OpAWbm0ygNmOQag74ntb/h+981nZ8PTeClVQxLNh5xiXCM/
         EWBw==
X-Forwarded-Encrypted: i=1; AJvYcCV6FOGkpun7ya2w4w1EOueybusIHqIyLRmAEQQwUSwmMMQaN+YJzNTdJM1FIXsVkjjVoqQjIV/2@lists.linux.dev
X-Gm-Message-State: AOJu0YzioOEO9FxJ9UJrcDatnC62nTu7+w+cx06Q+ew5G1JRSyRCN+Jw
	0sSa1KcvpLtoR4fTdF5TEOPZ1qkfaxw7xpQcvdXPXZGXZd95iCpoKgkiB/tBJKyr4EXeRAaNsMJ
	JO7pX6QKVTmz7kOxb6RqWD3dZNzZ5zZZ93d7nmw==
X-Gm-Gg: ASbGncuBvrOnAKlsDHy5koAD9UrsKG+3GWXKlsqOgUGFlITeSWXEeOkPjIoOprWLvCc
	BjNnI1E/4iMp7A4l9FXwfAqYDSgQvd9XecsIJd6EQl1qhMCciiGSbjdtRMq7jqzJsPd6y4Hnk+V
	da1fks9Ab8ngSI2vlfm8ZZzfZygpbHal8=
X-Google-Smtp-Source: AGHT+IEv0+U8fMqSqn1P6QHjlMbDnQk+8SzJmA6XFX5ro9DiGqlagEsie+ti2MXUCscCb1YsZKxDC9aSiVPPZ/dfOAY=
X-Received: by 2002:a05:6102:3f91:b0:4de:b205:dd57 with SMTP id
 ada2fe7eead31-4df7de0e243mr6580002137.25.1747306754653; Thu, 15 May 2025
 03:59:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250514125625.496402993@linuxfoundation.org>
In-Reply-To: <20250514125625.496402993@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 15 May 2025 11:59:02 +0100
X-Gm-Features: AX0GCFsg1NpyeH5tPjvE5b6oOb4_UgehqJj_AJihIsI3-hwof02VM_YjwL2M-is
Message-ID: <CA+G9fYtzWM6fb3OiosyQESPh2NxmwUwVVr-16FN-E4Y1GLNv5A@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc2 review
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

On Wed, 14 May 2025 at 14:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.7-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.14.7-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6f7a299729d3dff3ffade04ad8fbddb3b172d637
* git describe: v6.14.6-198-g6f7a299729d3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14=
.6-198-g6f7a299729d3

## Test Regressions (compared to v6.14.5-184-ga33747967783)

## Metric Regressions (compared to v6.14.5-184-ga33747967783)

## Test Fixes (compared to v6.14.5-184-ga33747967783)

## Metric Fixes (compared to v6.14.5-184-ga33747967783)

## Test result summary
total: 151222, pass: 125346, fail: 6191, skip: 19127, xfail: 558

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 56 total, 55 passed, 1 failed
* i386: 18 total, 16 passed, 2 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 42 passed, 7 failed

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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
