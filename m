Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22432BF3DD
	for <patches@lists.linux.dev>; Tue, 13 May 2025 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747156780; cv=none; b=OqI7XkgLrgv8bMtz3uFw5AF2/NXoVkuGNuP2KvtJPQfqlXKG1lBK9vF5J+t888OWmPCdMTJ7aYhhekbUWa0CxASZpM2QF/TeM+3ry92Hnw78x4mK0nKm0pX+abPYx01dJn36I+NV+J/bpw6OdMrY6hGK9wkghNsXqJLaZpgCT9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747156780; c=relaxed/simple;
	bh=tKnzglOUbxjTqjNWOorvM7J2sUaowqzLBzWcmVegvcs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gNLJcfoWMB5/1l+iFQsNjfySkWrMXzGHPP76tfZMGRxyp7++hfAYqdaDYry/SfS5nOr024NXhuyvHW/BYSrxo+pHaXemSRYPI5PfY7QovH3iegkAnxbLGLN7eB9LfWNQUyRsJ9KPkBYMOj5mLUIa8OLulEFXTAcWWUPfdrpX7YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pIvS06DM; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pIvS06DM"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-878427f091eso1624504241.3
        for <patches@lists.linux.dev>; Tue, 13 May 2025 10:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747156777; x=1747761577; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2WVZtZgOj//5jxHTLtKRf8BjEquu6XdJr3DYNY96xG0=;
        b=pIvS06DMaWl256h623knrdBJgZeo4IBlMZLNaFWs1Sw/ki9WaePOd/ncQQGX2laH0t
         F9c//4Uchap8R4/O9Eju0/Xu6nf8Ln3b//Ak+J+d+OEz1Bv5OPXZw2s8AjsWiPb3ADj5
         Pga0y/zj0DXSmmrf/zVgV6oDDNhx5HQF3teUW/8iH2lOy5ZRYGWcfdFFEBtutznnTTPP
         CAkAnR8offfm3FIGoaRri0Gij0qBI/OxdtzDPMYr1JuCHB8DF39qSkOIpyN4Ay9LjgSi
         vX4xD5TnAe7Rz9yu6Tdb/xg8aLZrvVv4wziaDdQZLbht8jyFmecNpByAq3mucu/4h5LK
         zfPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747156777; x=1747761577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2WVZtZgOj//5jxHTLtKRf8BjEquu6XdJr3DYNY96xG0=;
        b=dY+o2krcU1YNHQy5vjF3JQlSg9cSH1KY1nGoTpnO6T2SXTsH6/kkItT6GxmLp0SFsh
         eQw21TMLUroCgT8OIKeSZy62oFZidefpwelyYIbnzvPbewI57wpHtYQsAL54b7O1QZUH
         yiOETepgR8DYTxCiiPjVLoRFtagjD6OskApj7z7tS+92bQjd/GGgW0rNfoKGWAE5UwV7
         /4Y7n/82cYVoxir4tfaWbKRF/Nw0G6a7gx9VjQ1b9iZ2WrOWZ/AwEpDee54ffUcWEp4r
         bRP8UpVlziz+NmP3UsoAsm5SubTnc6O8NRzSP88IBr2YEdWabRQ1MXndRnMyUdCEy6iN
         Y1Wg==
X-Forwarded-Encrypted: i=1; AJvYcCVk+++9GrGsp3KxOsM00BdlSNGMUPPYHA4wmhQRPsW4m11eNRUGdo/HOQXaWcZ8z+1pnZw0REVx@lists.linux.dev
X-Gm-Message-State: AOJu0YwvY2Tvf9unB7nHPHbphKUx6MVp/RIxiwdqUDLK4JLJT6bSWhQ2
	/3jy1qEFkxrmIabTEjX8oFCVb21Jak+NbcuRz/y17UqXQvgVOhSBfVOzJ4VX5rPTLs7KCQGG4YE
	hJGTrlVDldPiYtKe4iOxqMc2Llg4IC2DN1l9cqQ==
X-Gm-Gg: ASbGnctel8hz45orgD5j62N+SBBw3BdiGg0ErBSLlO+cdrlCFgUn3xokIj03YBJOZn7
	TtX3Zu2Vyy0j/WEhEuEghOFjxbOOB4UOAcv+cZUpgPHj8A+iioZ9x8iE4KRIMp5Tpms/gVYSXMD
	bX8UnYD/DqzfzrE8GbL9F0uB/f4KZyhLU=
X-Google-Smtp-Source: AGHT+IE7SVN4f0UtH0PQNtPFy8g588fN+A85zd+IU9uAeKM1aPz2rmVoENJpTwIiBwisipoYFwbTKfFOf1DxGMVshD8=
X-Received: by 2002:a05:6102:3e1f:b0:4c3:3eb:e84d with SMTP id
 ada2fe7eead31-4df7dda5483mr356685137.21.1747156777441; Tue, 13 May 2025
 10:19:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250512172023.126467649@linuxfoundation.org>
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 May 2025 18:19:23 +0100
X-Gm-Features: AX0GCFu7eFv6DmFvFsrCDFVNU1cnMtQjsu-NkieuGgoCmhh6HwuDGcVt7BF5brk
Message-ID: <CA+G9fYu=z3Bf9zUTjUPWdSpjehsqKmxwH4=Xtjz8BHKTdcvYYw@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/92] 6.1.139-rc1 review
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

On Mon, 12 May 2025 at 18:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.139 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.139-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.139-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 490c91e6621e9ec53a2bd0cced0bd27018fe8597
* git describe: v6.1.138-93-g490c91e6621e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
38-93-g490c91e6621e

## Test Regressions (compared to v6.1.136-100-g7b2996f52bc8)

## Metric Regressions (compared to v6.1.136-100-g7b2996f52bc8)

## Test Fixes (compared to v6.1.136-100-g7b2996f52bc8)

## Metric Fixes (compared to v6.1.136-100-g7b2996f52bc8)

## Test result summary
total: 91883, pass: 73707, fail: 3346, skip: 14630, xfail: 200

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 25 total, 19 passed, 6 failed
* mips: 26 total, 22 passed, 4 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 31 passed, 2 failed

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
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
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
