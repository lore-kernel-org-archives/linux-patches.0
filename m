Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5739119E96B
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 18:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738953932; cv=none; b=iH1FO7oILlTJsiszyCBTh3PlkI5cwqPLqQFGOaPdZlA2eM6s+6MDNAOiKIkjOpTOU6h31T97y8Nqh+fBn8e8DFCDhZrz8FZB5nE9wD32hihhCTKHYcK7kAPj20f4qi+oVReqan5srhmBI2apLrjwVTGgcEdQCFWgOsDiWRnZ2Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738953932; c=relaxed/simple;
	bh=OdW1emNri8kVC8pI/hPYJfis2oc+JFChRYjAeCvy2mU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ORIN/59NOMVnwvVEephHfC1IqAcBQRyJHjsAHFHAsQ6VH/0y3sXmH4K42L/bx5V9gBsXoVwKXSo4BeH56oZeqLvumedjKSGpx3s98/WJEKvfeW17vrXpNIfGNg0NTZ1MoSYzrxtpdB+iiRdzqYaAk06ll7N1bmJGQFJeuBcPK30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AH8CcYV/; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AH8CcYV/"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-51f27fed6ebso500213e0c.2
        for <patches@lists.linux.dev>; Fri, 07 Feb 2025 10:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738953929; x=1739558729; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JrZJNd0kBd4brj90D7LeHLADJbtHZxxD8+SSJUSVGgU=;
        b=AH8CcYV/PWbbJiAuOLUQu2BeDPh+OG9EsZ451yl2VieRhARqQ0foj9On3f1TvjpECN
         Jdge2hv3tgujPJut2CObUJSrMXcHOi3iJ8wB+GHauWC1ZoMmvS8cM8OkqSxbx0uCSth/
         Y8AKFUc6Sx0lNKAn0iCbNyvjQWND4ainySQDsKFLZrq6rIjBgpT5lPMDc1Umq6cWEZ1x
         MGoK7pJQ5xl8Pi5qN7entV06xPmUDwr3lXS6OPR4TnAmdZwHjSuhB7SVSgzFnOYzA6OG
         Jdw+2xc2rNhQuapjx7ANZ+bhtoDhAJZajwZEj7QbLrqQxnEzJieSzpi+TTj3h0TwuOAE
         /OXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738953929; x=1739558729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JrZJNd0kBd4brj90D7LeHLADJbtHZxxD8+SSJUSVGgU=;
        b=rzu2wlbY5sgzWk46HxTdDYWQEhrXhS8S4KdRdTVFPX+TRHAnTZJ0uhNetxTIIIKowd
         +Cq+rvKS8lwjN/hazTK5lvw2FlM1fnhRNi6SY30yjR57JQUiSxeXy1aQinoFLmPotgZU
         SZp4zmGBvgbsmeboHktcEXPdN3rJsqbFHyk9O3a/ECGkW7i8+PoTI8fFSLMRbtT8zVGM
         ZhoGbRvXHQiDBxAHt3gbwLZMsupbN5RFqi5hFnluczQ/8VGJysEws4EuTDHYhl+dumB9
         r8Z0O/GZTbq044w8/qHQdesuLGKoY8v0hf8wMWnm//5JXF2gTZGBA5R6R6s29pxiQFBN
         +jEw==
X-Forwarded-Encrypted: i=1; AJvYcCWD8yFeVCVcrEvbLWee+rgyDCUodBPLy9hO/GtoHBNsdVfGYjnZ1gZaN8Jc0KjJZkUMd3dFWD+A@lists.linux.dev
X-Gm-Message-State: AOJu0YxCxGQaZrselgW+eNM4nYhigds4wfsxXs4F7faYq5lTJiczoE5C
	94qNtprGRKqlkR7aG0k87lHz4BvW5AQH599CKqceUAvEMcLiywMyIrBas/+XINQ/DAYg95T72N5
	GF51pMvLsz3WL0SpzVNHz/yqI+qo5yVapQLm54A==
X-Gm-Gg: ASbGncvmXeh99TBTnuWFRjaa2bOTv/gS7Vahd6cLEuHg5S9nYV4TvDmcbhfCGgsNdSb
	7UEH5a3LaTk3aaOZr+4iQkpYo3tcYHOcbwXlQyFJgmGmo21dbuK3jf+tb1kbY6tOIIn0F7iYGbF
	kRBNUVdxKCfROb4Cz3TVbnUsBlHRI4
X-Google-Smtp-Source: AGHT+IEG4rTjDac1kRwYGWerf4E1q0tf0QDbq8ANmQnNsBSbKG+iJQfyy/kNZ0kixZlxKvm+YSfXHquWbvrO23DhSrg=
X-Received: by 2002:a05:6122:10f7:b0:51f:358b:1c42 with SMTP id
 71dfb90a1353d-51f358b20c3mr2497181e0c.9.1738953929027; Fri, 07 Feb 2025
 10:45:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250206160718.019272260@linuxfoundation.org>
In-Reply-To: <20250206160718.019272260@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 8 Feb 2025 00:15:17 +0530
X-Gm-Features: AWEUYZmMx4CBm45_f0XpymDozDy_fR0zv3UmXrlXsWxHCGnqcsBXal63hDRC1eE
Message-ID: <CA+G9fYtytLbzC=2BQunZgpv8CKHKN3bdFOB1eFhizfz6iRd62A@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/619] 6.13.2-rc2 review
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

On Thu, 6 Feb 2025 at 21:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 619 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Feb 2025 16:05:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.2-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.13.2-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: c541e7f2b5c78da7ce25ce3e55189f2136efd142
* git describe: v6.13-648-gc541e7f2b5c7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13=
-648-gc541e7f2b5c7

## Test Regressions (compared to v6.13-26-g65a3016a79e2)

## Metric Regressions (compared to v6.13-26-g65a3016a79e2)

## Test Fixes (compared to v6.13-26-g65a3016a79e2)

## Metric Fixes (compared to v6.13-26-g65a3016a79e2)

## Test result summary
total: 3290, pass: 693, fail: 2452, skip: 145, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 113 total, 109 passed, 4 failed
* arm64: 9 total, 8 passed, 1 failed
* i386: 16 total, 16 passed, 0 failed
* mips: 32 total, 32 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 13 total, 13 passed, 0 failed
* s390: 17 total, 16 passed, 1 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 3 total, 3 passed, 0 failed
* x86_64: 29 total, 29 passed, 0 failed

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
