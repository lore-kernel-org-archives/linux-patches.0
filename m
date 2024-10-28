Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8811DE3D1
	for <patches@lists.linux.dev>; Mon, 28 Oct 2024 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730131148; cv=none; b=RvWlkIZ3BA448XfemXZ+6yQCjhYUHi1cM/2iajbNw+huszmQImiFe3mGMXJxjxLIfrP1UbFlS+xqM/s4jDu0GK5n8zxlfVVuoYcZKlx3cPF5CMcPltQVY4T+kSDHCN2dh52f2tOCXHJR07pYqoYAzuHkFHyhQx1ybOFLRmrvdnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730131148; c=relaxed/simple;
	bh=2v+31fsAuqH5Or/7S8FGahDVr8vX2gCynpJPJHnnhyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Aq3ckaswA7VB3eU4ko8I6lEK0tteACtWbjv0IEqXdP5hMif3bquFCcFtB60dXeiLnRCQaeF73S+SaiyRhl5XC2T2Iqg2z/4XIttaRlUV/11+3LIp7uF7UZxgnqv/j0fjYIcBzPQI3g+5IP05Bs6F4bFlJqIe06xqAOq8MBIdlBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OEuIsVYR; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OEuIsVYR"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-84fc0209e87so1117531241.1
        for <patches@lists.linux.dev>; Mon, 28 Oct 2024 08:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730131144; x=1730735944; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yJC6auGRBpZe13DzVemmuLWUaBopi5nU7ExWxzvBshU=;
        b=OEuIsVYR7u4Gp2pErcb4i1ZlMpUYRTsx3CB7U0FCa9DNy/mk7R2pBLhLPoD1y0mnuI
         Q3vWOO4mFLJ0tC8z1NSFF1ff06Y+7nnwwJproGr2P3ut4b+t1qaJuxZSioaQUOLfuscj
         gEq8R/pVcnrOKTU6F+jHBiJBjMWAuq55R0j/DqwVVJawdpwPo89GlUK1V4ZXyJiu6ycg
         6jg9hprx4Or2ENmMw9DUK3sgygvHMPoUgD6eiNqfPjQ5y0bU7aMQxsf6d+NkfVfhXiDA
         jctTjOQXFBHYrTVz0iTQS6Qfo97jUDSFpzd3OVNzS7kLJoGJ7gJiOfIrjXTM9hCDzHzC
         dIow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730131144; x=1730735944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yJC6auGRBpZe13DzVemmuLWUaBopi5nU7ExWxzvBshU=;
        b=TaGT3nO4uLayhXfm3HTaWrssiVp7RtpIWw15yQvJtYu5sb0PPuMqUBnd7i5vYMYgcM
         lY+cuar4mSpYGeVaAwsayO3qCm/6ieIEoU2SgKQbswMOXRADCbk505EYTBjUaHgFgWp0
         jVfWGKN6IIeW7i0aKItFQ01S1t0nLciqpPs9JTUXzAbIw8z5AsvnU2RcOout45/em/sW
         OQEzpDfcCjkxJtALAJ6B1cBHurC64lA1BsjCefVfQnMmux1Hv4ot/uVbuHT/qpvUPz7x
         8MOyDBgMt+5yIU2zPhWJ942aoSgSmeYdzK5+SHya2+BEQ7jOmU7tTzcPeRZe9tvpIj1o
         b56Q==
X-Forwarded-Encrypted: i=1; AJvYcCXg3ZB62E2BTh9rMzPcwDY3JnezPOevwd/au9e6PgEybZUnDWi8q7OgIJlSORo9WSBR9Z26RVIh@lists.linux.dev
X-Gm-Message-State: AOJu0YxnnQ9ITrpbGrMgkshDTw4SOZMXLYqr/9HBuyhI7M4fg/9g47Fc
	wVDuOJgcquOWlVAlAMlrS7ZGrDG4NBGq/Qfom5P/AMIgBj8xkGmK+PWuvseKEIF5wvMcOvwVQDP
	QwRWSSzNCvsbekzK3DVK7z+iWrzflr9o0hKsx9A==
X-Google-Smtp-Source: AGHT+IFb5ipmqTDP6PRkDrrbgx6qFZCwCBWXaecTKmbEwMANvBnjLWkMV3ysuK/t3SKZVkuElvNc4qm9C0oifErOJUk=
X-Received: by 2002:a05:6102:3910:b0:4a4:8928:718d with SMTP id
 ada2fe7eead31-4a8cfb58da1mr7235134137.8.1730131144638; Mon, 28 Oct 2024
 08:59:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241028062306.649733554@linuxfoundation.org>
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 28 Oct 2024 21:28:53 +0530
Message-ID: <CA+G9fYsK_qFQ1Y5UwmDvgLGp9KDapucDraWBTjPx+Xmi+wLx+w@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/208] 6.6.59-rc1 review
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

On Mon, 28 Oct 2024 at 12:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.59 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.59-rc1.gz
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
* kernel: 6.6.59-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 02900c91433b84926f38cf08dbcf877e84697d21
* git describe: v6.6.57-334-g02900c91433b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.5=
7-334-g02900c91433b

## Test Regressions (compared to v6.6.57-125-g6cb44f821fff)

## Metric Regressions (compared to v6.6.57-125-g6cb44f821fff)

## Test Fixes (compared to v6.6.57-125-g6cb44f821fff)

## Metric Fixes (compared to v6.6.57-125-g6cb44f821fff)

## Test result summary
total: 111228, pass: 91063, fail: 1276, skip: 18810, xfail: 79

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
