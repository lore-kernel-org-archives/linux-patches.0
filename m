Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54C81EE004
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736257594; cv=none; b=DmRkCLZBrUNLhQiWBJFQoOTJFo029L7ZN6x4RZmo/gqtTEI49hhbTVeDdDQ+6B/Dp1p//165UGLu0cl4o4+gJl7CLSF5pYy7CQVtiP3GCBHgoAQLG/SvrqxczR6ffLHpjb9Q9GgEmgvRRvJXWD/0klv7WUOwvmF/G9OHjv7vjhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736257594; c=relaxed/simple;
	bh=c4zaWbztBUVig2b0rtoihCmkfhinQyeht2xzMok1mT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iAeAN2cznf78iNU6onz5h9Gf7kXdF9EkJgHNGBPe8xJ6ztc64q71VoLaVoq5aDpyN/O7Xlv0NO6b6dna5sWSWPnkjJkv9YA399pPWuoQ1r7XjkErCg6NXohEfxkMxDel2TGfaOI7EYmQHd1xMppjJ9kVuAuQl5cRO/O7SfzRR4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X9lk2gP0; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X9lk2gP0"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-518c46cc6e4so4991196e0c.3
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 05:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736257587; x=1736862387; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAMGdLTpXOT3n9eC7FE3UE/RoKHM53ulqTtui6culm8=;
        b=X9lk2gP0GuPzdgvbkMQZ7Yidgt58GT5xTrtv7zwBnUOugLu53EVDA6aReHCLXAZhlt
         SENTi/0RsTj7ULxM0l8Uq/6SjT0wgBGayIVBSak2oVMXxFMpp39Jp8gkFYtjtH+9fXY+
         UWmJz3gHJDgiqwhTXB9vrI8ZSL/i9qP/enVA49txA3El6ZrR/BgDom9pGGeF3kzGU5AG
         cPQ2lbA2a79s2nT8IVNkt1JEdE9+XGrbOjYOMfxBuf3vV73kQesiWnenWJRsp2SQ/qio
         2IA/j2f7ZaJbmcWVh7Pd+GyuJBQFObAhRbczzXF6QP1SIPnoXbPSraGzL0uYRtvNVX1E
         9X+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736257587; x=1736862387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OAMGdLTpXOT3n9eC7FE3UE/RoKHM53ulqTtui6culm8=;
        b=Gw5vSMwxmiL36zKbZyO2OfThwxws+FPchA43YTFxMIygkVk8R4seDO97qNjBFt+Iv8
         FnULbFuV20wXeZ+9iVr8K6nk0oB7D1qOeOx7yF96lO+6xMuR/6FwSaUsz9BleCXrCieT
         qxA6DNnKeFTqp5r5+MiRqxuU8QL17AX87QfDtiTde358FoBUd2weBVYqRbDTtWyjkErc
         PbwKMX6LV8TKAMKYdrCmzvTzVG9BWZ+vdc5e55Qy6U8xYxUwPVQ+xylhdIx5/5Nt0Sr0
         CpWc0oVWvdXoLL6+XoarlF6+pdsvsGxxZt35qZ8gCH2YrKezpt+gZf+Y0F4tmm9zzVnj
         rh0g==
X-Forwarded-Encrypted: i=1; AJvYcCXMvyntVk/iO+sbXHZxsjPFZgyBDThYSoYm1XZKaT2fRJJtqFJ1gsjnTTUbP+1skbUH/Koa1Rt1@lists.linux.dev
X-Gm-Message-State: AOJu0YwvQa1IeBItFEMBqKOtLjsDSOW9AtFnSqrYEC/NG3cvQDL0G31v
	65q4PlJI0R+9Up9Kt/aMx5C5Df2Q4Nu9rgPA3YahL0SQ/e99v/RmT6q2y4TgdPoLTLGXmif96tp
	KgegyMgu3uHfu1iRYCyhqvP847NINtopQeH/kFw==
X-Gm-Gg: ASbGncsaM4KUUh9m8ixLdbqv0DbFRSbYjHsR7T+0G5T8w6V88ao1l8ql6RtarFIWn+B
	gALGBqvKY2py2wslGPT2jwvxEXLelJqz5T5YA7oA=
X-Google-Smtp-Source: AGHT+IEDB41RCtrEyqxY3BJbFu54a08GTpGhSW47/06Rvw5p1eHcSJ8ESQDgF/bjRbdP5K0BGBH81qG4kDyNkSnU6nE=
X-Received: by 2002:a05:6102:4188:b0:4b2:4950:16fc with SMTP id
 ada2fe7eead31-4b2cc399b22mr44987586137.14.1736257586792; Tue, 07 Jan 2025
 05:46:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151138.451846855@linuxfoundation.org>
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 7 Jan 2025 19:16:15 +0530
X-Gm-Features: AbW1kva-wnFf6Gpv368sk5BP2HXq0iTu0eMEHR3tzMH92VZSZcwnvfMAHK3xzkI
Message-ID: <CA+G9fYvTeERvkq-k-fFVzrqzFjG=7i-mro0MXQ-JS_rPubtbmA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/168] 5.15.176-rc1 review
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

On Mon, 6 Jan 2025 at 21:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.176 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.176-rc1.gz
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
* kernel: 5.15.176-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: bcfd1339c90c53211978065747daad99e1149916
* git describe: v5.15.175-169-gbcfd1339c90c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.175-169-gbcfd1339c90c

## Test Regressions (compared to v5.15.174-52-g11de5dde6ebe)

## Metric Regressions (compared to v5.15.174-52-g11de5dde6ebe)

## Test Fixes (compared to v5.15.174-52-g11de5dde6ebe)

## Metric Fixes (compared to v5.15.174-52-g11de5dde6ebe)

## Test result summary
total: 54560, pass: 38397, fail: 3232, skip: 12777, xfail: 154

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 104 total, 104 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 25 total, 22 passed, 3 failed
* mips: 25 total, 22 passed, 3 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 25 total, 24 passed, 1 failed
* riscv: 10 total, 8 passed, 2 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 27 total, 27 passed, 0 failed

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
