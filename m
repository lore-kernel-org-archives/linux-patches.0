Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595A11F63F9
	for <patches@lists.linux.dev>; Thu, 17 Jul 2025 05:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752729807; cv=none; b=edq4r3BCcwpfesqnqilodo8y2HAYhbkv7lK9CdTJWrO6VF52eSKf2UGBIfT/Bp33KQGV+/W10Hje2U6wctGXqceM6WVQQ+wphNdpcr7IcZTck5d+8EDPrDUW62VMMrwIvfrw8cB08lAwaOyC4BQVHsMZTzZuhX9oojDLZPDePMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752729807; c=relaxed/simple;
	bh=Go4DWykoSKJP1cS08Vxzg6QHAJO7yZfQSTkvC1QNlkU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qgly40caUdKqQwwBGvjCPxr0IWrjBt6PzZcuHK/f2lvn7WxVfJoLeqK+Qi2rVqJwimbjcyb2kMhcWBzQtdaZ+lJYNoORVSyLzdUgIxxwdcNx/o6ilzV/XAMI8475Y/7R90N5W9Dy5fbnunXJ5F1EANmNcsE25KA2XplOuxRdiPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Jx1YxntK; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jx1YxntK"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b3226307787so417292a12.1
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 22:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752729803; x=1753334603; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbNXNk8Bjt0C/jyZ3yLfvc663qoXwVQsDwn4FalQUM8=;
        b=Jx1YxntKnv+EXuWOoyoNSQ6iCG2lZo/I66gINVBTdYfdOekiBjXT6ffl1v0EP8bct/
         y9XFWMyk5LK//CvthFjCmD5JT7IwnpTSjSljCh5L7uenG2MkRDgGg75HIMvu2LfvArrA
         QNfDzB46dg2gNxwoYk71SFluuBagd0VaN2KiXvtJZofpNQ6vltGPQWA2omzGzGftJHfW
         gmM1n+0fXpYd4jBjeN5vjpRH/0qfuhhW6A4FoO5R83qrwShPNw8uXu7gMPUIcJtggOB3
         uRdRqqsdOjrQpgk56gBJtfUfAwbONRT4U1MXRa0qGiu5z2vc6JCN55RFEjzERRQNQeem
         /eow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752729803; x=1753334603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbNXNk8Bjt0C/jyZ3yLfvc663qoXwVQsDwn4FalQUM8=;
        b=ZBCxxMNAqOnZ696Sm8qTpFSStIIhe6B27iFWhMmjKNDh0dVmC9wqrDeqotgmztrJfG
         MI3GevsqdiXuRSaM59lLY+5+Ct13+kjon9i7qXQHHqukoVATArLUQiVnOf8VI2MbkT+t
         eG6d15Swye/zSqV6lmmh5myO5jUskvDqw/8gjSQJADO4T787/bDftdKn+HiDrGGUkTfi
         DsWpBORZxoxI2kUg50/ZwIPNpRhT3uMA37U/3lRdAa2fBsritj9WgXqGZ3YIn0M3HqFK
         wFcl9Xd1Mx0wxQ2tM5ecQ0A6hjbEQqotcvO7p1Fb/JVxMmhQH/Dc4VIaNvpeZVjJw7eW
         SwRg==
X-Forwarded-Encrypted: i=1; AJvYcCWgAMO8gitZDo4fH2RDLlfb2B7XX499wvbpkF6BbyE0o/e8s41N+YQX26C8afLWxVgeVZFA9H46@lists.linux.dev
X-Gm-Message-State: AOJu0YwWh6VD5xQNBFOt8YxPP33nVhs/uJ5SaNgVg9ukTAG/ICADfmdE
	9BH1CrHlMWY35NhEDoGc2ha2uF7pV6z+vv8x0KQl/tt09+FbcDMexEAbwAMIuDLu2OqQHuyr8xP
	WpwMdxC4/4VXAhoaz29D9dc5DFIxOwOtwe8YcEgjLJQ==
X-Gm-Gg: ASbGnctx9GJAcv9X50hpkNm85XvlznqcM0LgWvTeUttrk05jkuAWcSFDakloYYA+kvJ
	2cBnokWaQ0sVtOLcQvpwCWtM0Jz1Ls+ldEtNa83FvbxSgLbcBU3Tgk2549D5kYsyXYRElA3qhn9
	b2wZXJrSZqZe7uwB6iaVzRKw8hBu+mQKwjOkK4+xA/S9M9E50KwvNOsPuG/CVdG3lsKsE++DnWQ
	r5+or5913Q3JttsHv0aG5AN15mRmX2ry6yMT4py
X-Google-Smtp-Source: AGHT+IGC1euAAA5dE+kok7mdUFeay68s6sXYaX1cEPylz7XLvI+8baa/hLQApw+98wrPtjBWn3XlSJUgjxrkBDbUHL4=
X-Received: by 2002:a17:903:2446:b0:235:be0:db6b with SMTP id
 d9443c01a7336-23e2576c493mr78845715ad.45.1752729803488; Wed, 16 Jul 2025
 22:23:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250716141302.507854168@linuxfoundation.org>
In-Reply-To: <20250716141302.507854168@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 17 Jul 2025 10:53:11 +0530
X-Gm-Features: Ac12FXzq-Ju7B9DM2i3Uy_CU19Kl5aGcWdwTnWvRw2hksW63aQqP_uvej_ipHLE
Message-ID: <CA+G9fYvwrnndRbDQA3y9Fy94_J0a1sixG6GfV+R1p1iN3+ATFw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/144] 5.4.296-rc2 review
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

On Wed, 16 Jul 2025 at 19:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.296 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 18 Jul 2025 14:12:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.296-rc2.gz
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
* kernel: 5.4.296-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6d1abaaa322ed206d965a1e36bd88e4ca921b85e
* git describe: v5.4.295-145-g6d1abaaa322e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
95-145-g6d1abaaa322e

## Test Regressions (compared to v5.4.295-149-g32230c3fbb24)

## Metric Regressions (compared to v5.4.295-149-g32230c3fbb24)

## Test Fixes (compared to v5.4.295-149-g32230c3fbb24)

## Metric Fixes (compared to v5.4.295-149-g32230c3fbb24)

## Test result summary
total: 31832, pass: 22716, fail: 1849, skip: 7132, xfail: 135

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 131 total, 131 passed, 0 failed
* arm64: 31 total, 29 passed, 2 failed
* i386: 18 total, 13 passed, 5 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 9 total, 3 passed, 6 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

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
* lava
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
