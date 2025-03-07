Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A942820764E
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 11:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741347213; cv=none; b=B2cfLxyf7bGOUYH2tnJEtShe+MXZyGM9gT+Sm63IFtMNrcgafpbGJAD4sywF2EDQeGNt4V+Ls47WJi7vEFFeXHP7B3/cYiQbsZ72cRW65vY1g3d4RnAmyxbeORCUBscuJov0gNpe2TONO1hegeP4N9EFy0MDG8lbdmVRhahFQQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741347213; c=relaxed/simple;
	bh=UBnBUcC8OdCTN47ndj1+/FiEIQPtdgXbgndHs9HLu+E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UtM2lWz8FH0nhVt8KXuCjpk1zd+OtU4/uTB44cCIouuCGCwSCI8VZBX3epi+IndOrPIrtrDibI6HLtRCMl615idogfY/YHuMXVG75opfVPiX2bScFnvwJVvujia2bwESWQW3PDF4w+kbqGyjlg8kXl8xmt2yTez4+Vc8CzRAJKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=b06dOa+u; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b06dOa+u"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-868ddc4c6b6so716545241.2
        for <patches@lists.linux.dev>; Fri, 07 Mar 2025 03:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741347210; x=1741952010; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFvEW9+gOAumMdwUS8FQ7wKhbDn/YCcr8dlH8XU7VG8=;
        b=b06dOa+u6mfx40mQ+7fDu+NkIMCntN9dNF5paHtCJoxDs7reVMMYVIhk2AKapGC+Jc
         CMmzOeH3J5s8la2zwdOxTtSL10eFmCwX5CrEn0clxkElLWyb91fwtv6Ku9b7wDTizSgp
         Xsrd4uEHfi5yehM7TFmf6opqN9RjaLlxdA/Gvm2eE7GyQlZ5authKmJvRFzEw9tNij2W
         3zTOo24RSlDDVKx7mtDoInO2cYmqtdEI78LYgdJdqqdFEDfbGs5H2yIus84st7RhuDSl
         fFzZ2D4nHWLuW1zdXYKeH+UImfhDRFn9ESy4aSUTaY07pgiXBIKEJXwfGbgL5yWoMg0Q
         5ASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741347210; x=1741952010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aFvEW9+gOAumMdwUS8FQ7wKhbDn/YCcr8dlH8XU7VG8=;
        b=eJeuaT2bKPYytrnMvPqVB5ar0PPmhkMp1UjnZZzd58qTOS2K28luYYdrVAotHYW2d5
         ZGE0vBTRKq+P7Luuyl3n3IEjnCjB5bmNYjcHSBXBN3MXOjVvb2qYeykXPtxE9ju1qbMx
         XiNSVGRvHZ3Re88eQdaHtQf+4VhYChPlSOk0N35kgQgcual6GyPCh2Ir6XAl5ItMD13n
         U3hOeaI8t8ExRGPAhMq+hZLIf1XMc0ROmZ+xrqsk9AYCXtOhAjT7TFfpmBCxaJBAaqq/
         W0vHhSWXFG7YxqRKPpYMgjt02caNjhwomFFwGnnsZtaQJeTawkkL+XAFumKFF0p4EqmS
         cNuw==
X-Forwarded-Encrypted: i=1; AJvYcCWJfVSFRfXP2bbr9RBwo6BgpQmEa8dLmJFMWQwVYRm+sOGG3yfJVuOT01+ZxPNUnTfgXtUu8KO+@lists.linux.dev
X-Gm-Message-State: AOJu0Yzy4fcF4ExVf3aVsmzOCSJkYYh7o/ZrlfXb8tUfdCzXVJxaQKjc
	gWmZ/+9TtAWadukL6S65BLS/L1E33/XTMJKNTZrLJmkpDxryOqS7WOqNZs6GSJ26me/DTfLZVVD
	a/08oKTmIFgSzdW1vH3ytXxFmg4O/jyihTS2I5A==
X-Gm-Gg: ASbGncsYnrHyKDnhCtX5IMNM3nYmWdhT6KybsKLHvTnselxroUqNIP/uy/h54o0KCt6
	Cc6DhrRjgeuzm3VzfbiYTr6IJhh/QxQDxIKjVYqcYW9u1Y5RPuKwTVlUtGv0A9HANvU1VEVzSKm
	oC3Xuol8kTyMBfR0Ps1hYGQg/S5bbJHLZqZnnFHHKe2Flyk+ud+3Ux/ul1ZvY=
X-Google-Smtp-Source: AGHT+IHJA+j/csP2xeWzCbqhvBUA64gace/4cP60Pao9dUXtJw/yVzXRBp55cl5+h5+kWw/pj+oWqNAn0ryDA2aMF1I=
X-Received: by 2002:a05:6102:2d09:b0:4bb:e1c9:80c6 with SMTP id
 ada2fe7eead31-4c30a344411mr1907125137.0.1741347210593; Fri, 07 Mar 2025
 03:33:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250306151416.469067667@linuxfoundation.org>
In-Reply-To: <20250306151416.469067667@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 7 Mar 2025 17:03:19 +0530
X-Gm-Features: AQ5f1JpPpPQ1WqZW24UbFwjCCjLQvm6wQsbezNjruPWCZUfozzH1tlvkj4rl9yI
Message-ID: <CA+G9fYu5pu8-VdefnTHsyBwCdJ34TWb_3U2snGTm2c5pm8ftLA@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/154] 6.13.6-rc2 review
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

On Thu, 6 Mar 2025 at 20:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.6-rc2.gz
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
* kernel: 6.13.6-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 3244959bfa6b859b760b8bf7d9ab374356a374d5
* git describe: v6.13.3-552-g3244959bfa6b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13=
.3-552-g3244959bfa6b

## Test Regressions (compared to v6.13.3-555-g30be4aa8b957)

## Metric Regressions (compared to v6.13.3-555-g30be4aa8b957)

## Test Fixes (compared to v6.13.3-555-g30be4aa8b957)

## Metric Fixes (compared to v6.13.3-555-g30be4aa8b957)

## Test result summary
total: 84333, pass: 68272, fail: 2726, skip: 13335, xfail: 0

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 56 passed, 2 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 42 passed, 2 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 25 passed, 1 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 46 passed, 4 failed

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
