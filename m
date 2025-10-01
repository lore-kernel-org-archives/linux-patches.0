Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC67A23507C
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 10:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759314134; cv=none; b=N52WV9C3CUdKq07TjfQfKNo8XVmuCNZTWoXIDNmdfk5IIadJaLuUFagDTIL2Y9P7xbfmmmv+lVZe0/5Dka7ZHxbO4PSY+2Wi1oMvEmL5hfzwLeoZtbohftila94a9BUZGpDlImtqg50vMHgIOrr8IPeCuJoyl2yizby9GQhAMEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759314134; c=relaxed/simple;
	bh=OTliHX4DjBx+mupF/CV++tI7w3tjBGKObI0txuXqMIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rKgGeTPyNzixmfmxoc+ksQacHaDrXq9Aw9LNrGrVvU6TcbgiZL/mtezbv2Z9qH7MC4z6NB/iToJxxI5t9Y6IF2sNMIt2BA19+5pc4x3Lw6+C5r9Q6A8yu/7tszE6bscu3rLPS7M75DRBHFtGBWxonmDhoStnfnhtBRtXiloo2w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=npZa1YUy; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="npZa1YUy"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b5526b7c54eso4354624a12.0
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 03:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759314132; x=1759918932; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MyEVhMKoRQmspXzhQGLidUHqVI4iIdBM6eUSr/v/1i0=;
        b=npZa1YUygcO1tvWeE9Isf62yuJ1/iZf2gHHYj0YgV1x0uy5RIxk93fewri4kHupLXB
         WVrXGoFX1Pf/Yl1cRw+jHdBMj6QzhjzQVl536kFHQrPzdPK79KTrfmnENRPMo8ctrKrK
         7LDq+EFyGviUjemqCsFFIog3kvarjVbwVapHvFRMTvLsCIeLsnUAncMhbOTjn4JV2KKb
         3XPb8vKbC02skZ1UODpJ27Mxu+6DhNPHOBh4JWp5KEh2jJTm+OOwxJ86wVbK10PrweXt
         hcuE4PXtSs2lBDTTLMn3QBJiVR9Fcp7He/5U4seyWm5N86Ojds9wYE2v5+h9Hz7yjMkf
         jh5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759314132; x=1759918932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MyEVhMKoRQmspXzhQGLidUHqVI4iIdBM6eUSr/v/1i0=;
        b=xMZ9DXtpI4zTefQiPjYImwSza+0/UBLg0PT3hsfQG2dbu04JlVxPNNzq53Utu8MLqM
         xmVRMkoLBJBUzB/Se0eAXPiy7UAW61ZYjRnw1SzlQ0rJtEqH7x67WnhMxn/LvIKfIPyW
         dZTLqct2KK5GEr1EaakVYtMk39dDOCwCieY2t7RCaCQCvZPee/lZ8nbDVj1HE3DlHJh5
         oBoZ8lyDY+uP8V4uhpTogUbpMhHlMnyI357INwVCD3Vv/fqWEmWam4INEazTtlVBYuGU
         IMUU0rt5tjQgE/Nk0gi6NsH/calStsCWRHjg5Y/C+ngbKlBsfJQVAQdYAugQRfFo/ZqE
         E6+A==
X-Forwarded-Encrypted: i=1; AJvYcCVCsSGeZ5zJZLsxF+PXn6bT7WZ3xs9kLnD1sSvwVo34GhZ9GC83L7vk47axo16IDikBkktFft6V@lists.linux.dev
X-Gm-Message-State: AOJu0Yxn/HI7vFDTyxazZLcfhyyvGLjLpDo43T6RBJiBYYv8CdyA88Iz
	ozaOe6ytUe9eks94p/Ji/ZfAftHDgdR/VGMLvYgMl48B/+qVnNVayjpeU8JmMkUdg8DA7COuJkz
	9v4SFQUKlP0ucHgktxW/e5qpYIL9E0FLNWlQx0h6nMQ==
X-Gm-Gg: ASbGncuaO9KPSCYAV79Ok6sQuV3/FPMtspn0Ut25h1+ei5fJ9Q/5HgkKtLX3+IZ6ixi
	6+AXnhPk5Mhoq+RPf4DBogUh7PL71ZMLSz+g7P0Xv6kKv9xsHKs9Yx5W+GMmVe7KWzI8G9w5L85
	qXRq8l7a1CS0Hyn4jOjcH76E6i52xIHA+0OuineOp776cUxf/pUgKNQ/Q2KoSJP925mrIvqPWEj
	77mP+aMNaO/8zI42MrlpxUHTYrMNF+EWDLfDkGx7Jjav57lJj4Np9WsAhJ6AQ/wZgrVMbaX5tM8
	R1iI/af+iFi7MftLF5C8
X-Google-Smtp-Source: AGHT+IGo9YrBv9rBn/WWKf2pOXy6IvJ0AZVZCB3CCSonzjEZG/QZC9w1FlI364hn+cBu+gdtSNuOo4dxGMfNqACEMPw=
X-Received: by 2002:a17:903:2f08:b0:288:5d07:8a8f with SMTP id
 d9443c01a7336-28e7f2a3ba2mr34511945ad.24.1759314131937; Wed, 01 Oct 2025
 03:22:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250930143821.118938523@linuxfoundation.org>
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 Oct 2025 15:52:00 +0530
X-Gm-Features: AS18NWDFm3YBIpvyX9ximxJERerne8N0kR9urFmXd3w78LNh6kYHsL6Fv75FDXU
Message-ID: <CA+G9fYvsvta0E7hQ84mY9=1aY0z3kypxd2CR-RAtqtkwM9fZwQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/91] 6.6.109-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Sept 2025 at 20:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.109 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.109-rc1.gz
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
* kernel: 6.6.109-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 583cf4b0ea80d8f32feb8655c39067ba1da1ffd7
* git describe: v6.6.108-92-g583cf4b0ea80
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
08-92-g583cf4b0ea80

## Test Regressions (compared to v6.6.107-71-g6bd7f2a12b28)

## Metric Regressions (compared to v6.6.107-71-g6bd7f2a12b28)

## Test Fixes (compared to v6.6.107-71-g6bd7f2a12b28)

## Metric Fixes (compared to v6.6.107-71-g6bd7f2a12b28)

## Test result summary
total: 291438, pass: 270254, fail: 6807, skip: 13926, xfail: 451

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 132 total, 132 passed, 0 failed
* arm64: 48 total, 48 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 40 total, 39 passed, 1 failed

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
* modules
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
