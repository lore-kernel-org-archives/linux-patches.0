Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7576A46B5
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 12:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759320343; cv=none; b=hw6VoMquic5wHwAHA27FBqrViYLZJwvkZ1YigD0icDlfOng1N5MkH/3e1Ae6ZcnZMBhwcLJYTJINJTidre+6M6W24JCFmsNvF82SYt67LI62avSeR6GKA5h5bA5QyX6pRZjIzcNKlTJMZIaK+oppWLECNfTox5YF/azf5N9m6IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759320343; c=relaxed/simple;
	bh=O6vKQTz1eSAv1FTPz9NfRzTKW63iKa3lMOgQwx7nkZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kS1D62eou6ZuwFgcMkehvU3wVoQs4xUhOnGqZYNA5PsQZhBMjtXi4m7OSOe2l8uyqz1j+USM+Mp5hk3GAt2dsE5RuGEwr0Lp2rH9GCCDMlkPSh7Hp5XPyOo/BGcZFv0JPk2DCXj3FBDh1SMlATNppPZv+IvU8epNgjnJtQK8UCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F8SiIcbj; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F8SiIcbj"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b550a522a49so6329499a12.2
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 05:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759320341; x=1759925141; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hg1GfvybsU3QtTfMcHFEjVchBGwucMjxi7dlwU4m9P0=;
        b=F8SiIcbjSbnq5bNNnGP/kLGxkbzFQh42ZI5vmy16XaxDoB2Gv1nqct2Bdj8PwFcM2v
         BjWrt5u4daVuEp0Rc4W74LOv9NmwbbOOeS4HXn/888oYwddZFx7VZW9LaQKDhBtz4xwD
         UvpZXw5Kcyp0/v706xai4XZvDKIfOcNe0OY5hYoybrsfNc6lAJditlqHxnwz6xY+BXZD
         Kb5szEDIsnqk3g0bTK5B/ZbGfpi5Tw2LlgSh3hhjSmhp5ZCIRuhYqZy3J3UeD7pJeVPL
         zx0aFudeGgvdOb/xHAA0NrNuogY63E193oJsfn/uPOdTKdBa+A8IhHiJING9AkuzsKAq
         +Psg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759320341; x=1759925141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hg1GfvybsU3QtTfMcHFEjVchBGwucMjxi7dlwU4m9P0=;
        b=vk6Tjt+Z8xK8bmbt0lgQC82VLAs/hx0QrES2tj0REdY2Mkn+HubToa0JTRdjoLcQz0
         FI2y5KC+T7Urq7gqLk9xlKwyC16RrXgTQMdLcJq81jAS29TtQpLyb0B4FU0CLFPsDTir
         D4Suobpo8Z83PyMBP9EirgXOnGovBgsTULcHq194/aSZ4OTqyZS7gR/n8G04Z1adgfAY
         iQ0wOZ76i83IDft/f4uyecxmxdPQbu6j6sfV1cSEoTETsYiuoYhgTFFA1H7+x26IelCI
         nVJYFsFqEwdKWAo2m8oWOBxsk1efnFrVR1JN7JTQJauu8PtwevZIA4rSlSNvSGiaPk6D
         uOvA==
X-Forwarded-Encrypted: i=1; AJvYcCVcIJZN4N4I7bQVLruhUXCIu9v19f9dtQRLA2jv1brxp8DAdGnzTRioNybahlivqqcsV2iVt1Hb@lists.linux.dev
X-Gm-Message-State: AOJu0Yzj8bgt8tmUw+DR/jk/299zrpJXWsam2m89vw+c36TETK04KS+h
	WoHLrZiEvyvb+zDwSCrwv6tBQC9SbtJiENTf41XZHzAvlvjYMrzsBZF2RzNTOQssw9Zrlm0eaeu
	YUDKIS2pUWqD/yF8NjH125LIUgbPfsYEfXBKOXhwnag==
X-Gm-Gg: ASbGncuAJoaPGJecZa1m24yx8vEr+TaGLZD44buARSSKqiCbEgXF/mSFGKnw/bYO14i
	y99gsEM1NmVm4SwTKtya/VngIfap1EHkULu8PjnsxN3rC4bDJv3qhbboKHm600WqL6+95/7rkFu
	26BYqoRMLSf01RV5mOSu+S3YdoZwUVLEO6/J4yKCkApH5een3iy0UirUXMP1VVZTWsHR/+Mm2p7
	bZ3eMY1KrzyQQlGfiixVxCIVJZA2pjWakFNmvoAYX9PeXDqUb0Jt4V4ai1hwzskpqksdIQi8mR8
	gqm1PjuuZZXLMoHesAyCR7O8rSBs0jM=
X-Google-Smtp-Source: AGHT+IE+69MJlAegp6HNoWgT69FNLBCWEbG8GGLCgCE5L5FpcTX3fcSAL52w5RW24lGOU0JtgGcawYpVHiKGuzYHrGo=
X-Received: by 2002:a17:902:e78e:b0:267:6754:8fd9 with SMTP id
 d9443c01a7336-28e7f3284dcmr41559095ad.39.1759320340797; Wed, 01 Oct 2025
 05:05:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250930143827.587035735@linuxfoundation.org>
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 Oct 2025 17:35:29 +0530
X-Gm-Features: AS18NWA9XV18Pou9nUNt_ZdVA85rILDAsVyiyN_bBk1qQqHPGQaNRQnhWQ2ceJc
Message-ID: <CA+G9fYstR1tuG3bQ1MhE8nvqzRmg3bvd9k9xnLXtPJQOcqwUgw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/151] 5.15.194-rc1 review
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

On Tue, 30 Sept 2025 at 20:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.194 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.194-rc1.gz
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
* kernel: 5.15.194-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 2e59a3f5f54406d7cb71d75a55df3c9ab93cab18
* git describe: v5.15.193-152-g2e59a3f5f544
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.193-152-g2e59a3f5f544

## Test Regressions (compared to v5.15.190-99-gccdfe77d4229)

## Metric Regressions (compared to v5.15.190-99-gccdfe77d4229)

## Test Fixes (compared to v5.15.190-99-gccdfe77d4229)

## Metric Fixes (compared to v5.15.190-99-gccdfe77d4229)

## Test result summary
total: 55742, pass: 45195, fail: 2492, skip: 7695, xfail: 360

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 104 total, 104 passed, 0 failed
* arm64: 30 total, 29 passed, 1 failed
* i386: 20 total, 20 passed, 0 failed
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
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
