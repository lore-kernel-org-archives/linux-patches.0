Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BAC1EB9EF
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 13:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736257847; cv=none; b=eWRuMvP2x6yWmP9x/1xfzOgQbHTesdSUfQKmf2mzRIwsZ73bJDXpjzehd/WLeYmpNIT0QUBAeB9Ax3EyknaSVD/rG+Z8BJcLsvoSAeJgOWk5St4bPW2xM8+iGgUEths9goY6Wx6M/W+K7nSl8vmnNs84kuCmQ87yPUN/IIzbLLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736257847; c=relaxed/simple;
	bh=sP4oWAvT//ozkGmUP0ZN4hVDx40Bvi450ckQOfqUwPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ld9Ef6DVoVjekfZmCD1Yt+cR+suVet0hGjdcHBGcCFql/jvM01EKyGZTuQftzXUkaHiNwdBCq3MBOFuFGOrUd98Vokq3glu/YtmzrbcRUV1T6RNQ9SHLi6aD8YsZmv+tY14scrZh7Xct3eEmX/1vwnPvarkW14N7PLSJV2445Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=j5dn4hJl; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j5dn4hJl"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-4afe2a1849bso8984651137.3
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 05:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736257843; x=1736862643; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=164argy2X3LIEO31q1wNr10Ni9B3ViQtWgmng2fa1fg=;
        b=j5dn4hJlzukVlF+LGS61iAYK7LjfsGBrZhxHy4sNa4zSeOwQgPKHgCkNKYAkcUNLxm
         G3FoEbc5hu0IQdbK4JR72FarqAYo2pUTPtkVhuKLQCOO5Mm4/emgTi/DXEUQSSCabZ4R
         U8Cczd/5IF6EyT8y8+1dxf6og2Vxkrt8YMXpBBp7nLI74GenK1nEdv2YIGGR966IlMor
         pwU+oB2VZEdspjPRSc4gEt85P9ZA7eQNyb3zCWwCPhKITGdZvV01fMgYp8hfDR46IBIO
         tQv0Ftb4mXiKiczyRafiVAJuVtZw6ywnzmENIadBjljuafi0LxRibCAsYS974ye1NIiD
         p5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736257843; x=1736862643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=164argy2X3LIEO31q1wNr10Ni9B3ViQtWgmng2fa1fg=;
        b=r3gHu+fQZM8iUuTwVdp+OtYHVXlcb4X+R1t5LlvPYjaX5h1/H8WUL4Zj3c0V1K7Lp9
         lpeNqyQIu+a2gLhQMiqf8aJ5qUKZT5DV3FF5toWh4XOyeZj79Po5Ti2fwLhsBCL3h8qC
         njq6FLQG67Usxg5LQE77tZ+uP1Dhw24UnCqB4sCjB7i+5oAGz7BnqYCmuugQpPESCZ3d
         2fmtWCovfrZsiDilfsoKAzewejsO9Un9GH3DAy893hbYgLBDSGWuwuk0zAHkEbhKJJmT
         +3R9Ihc7g42FiG9HShHn4nUyPL6PuZN/9rZfJPSbtQqz4qZg5YpubmVl/9+0wxuNalJw
         WN1A==
X-Forwarded-Encrypted: i=1; AJvYcCUVvA9jMFTnuUAF/HPxr8L8g1O0tJrEum/GEHDCuD15WTX63h0mg77/xJPuF3zmdeqEHqf4l1Cz@lists.linux.dev
X-Gm-Message-State: AOJu0YzWJUKDk3OkCwmDvCf/CEail059BgLUiSWM5/7TJ2vxh5hGrd7n
	3ZwQXx/YUZzIZ4++mkBenZMiIIRJK8b0ivStqjNkwH5+Hp7+xcRAyCiKEggHGyorQzs4sLjWPS+
	gltT86TeRD3WGXC3Ii74RVhBNDtxOnEIFmXbsSw==
X-Gm-Gg: ASbGnctjSYTKvi8PqhUpYObq1VALZIbhIgWhLbZ1fo9Bi/6DyzwzBir4J63RYH3d6Og
	YvZED61A/WJQh0gRMyO68lXJtfuKOkIel0O3CeP8=
X-Google-Smtp-Source: AGHT+IHz+j5iVS00dGrFXWRq97XtpZ2mEIgqAwb2bx8/DzfD/TUJp7IDVfIlNsufhiZfHrvB75RSphZ3r1pe2EK4jCM=
X-Received: by 2002:a05:6102:d8a:b0:4af:c5c8:bb4c with SMTP id
 ada2fe7eead31-4b2cc3873f0mr48630403137.16.1736257842750; Tue, 07 Jan 2025
 05:50:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151128.686130933@linuxfoundation.org>
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 7 Jan 2025 19:20:31 +0530
X-Gm-Features: AbW1kvamNNq-c6KfFtguRr11KHieKl-FClYg0LvmlYpiyBNWjOTcP7GiZthTi8g
Message-ID: <CA+G9fYt4c86Bf_+SVYL0tyafyJC6+3JcyA_vmrzSYgfmeQLuAg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/93] 5.4.289-rc1 review
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

On Mon, 6 Jan 2025 at 21:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.289 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.289-rc1.gz
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
* kernel: 5.4.289-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 0578e8d64d90f030b54a4ced241ec0b7f53a7c57
* git describe: v5.4.288-94-g0578e8d64d90
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
88-94-g0578e8d64d90

## Test Regressions (compared to v5.4.287-25-gb66d75b25fae)

## Metric Regressions (compared to v5.4.287-25-gb66d75b25fae)

## Test Fixes (compared to v5.4.287-25-gb66d75b25fae)

## Metric Fixes (compared to v5.4.287-25-gb66d75b25fae)

## Test result summary
total: 42887, pass: 27545, fail: 4176, skip: 11101, xfail: 65

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 136 total, 136 passed, 0 failed
* arm64: 36 total, 34 passed, 2 failed
* i386: 22 total, 16 passed, 6 failed
* mips: 29 total, 27 passed, 2 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 30 total, 28 passed, 2 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 32 total, 32 passed, 0 failed

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
* ltp-filecaps
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
