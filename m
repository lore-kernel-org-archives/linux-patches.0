Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67B22261B
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 08:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709110211; cv=none; b=dCnGvtMJ3UC1es5sdvvKS0Pb3WIqYJAlYjFMBCBb7SEnGnz3GTLaU5CEKAAsoXRSlo0R9KelkSgp3bjVOThJqd5q1fgzsrx6IQjN5/8u142tqNu/uvnfnCq8OKVIsu3720ck3kjnitQN8S2jnY52CxfUv8LWJPKg9wZzBXwgsWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709110211; c=relaxed/simple;
	bh=mLh6+aNUh4FntiPlQM+P2aEMsa+DZhrGXjkKdK+LLcw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qyIx/V0rbLgjwazZzmLoyperSAr+bfJiavd9XeSqzRVvrDhhqqHgVuQmg2ulsJl9TFOL3S0gqEGQm9bfQpa7lPDQOxIbK7oAeliakkY1wiRViWyoLZvK6Rpb8ipxOTxY+RTocAhG+7j+i1gkZEkZnPeNQZ09jaBQegl2FAX7ims=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nhdjoWkA; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nhdjoWkA"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-4c7c5ea58acso844121e0c.2
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 00:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709110207; x=1709715007; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SfLLRr+7TVO9BIvaySCbRAIq29D/g1YN79CAfZ4LjO4=;
        b=nhdjoWkAvbnop4R6XkMT1PogH3wNViXkQbK5e5agrQV2SLvtNMPChiE5/8Q7K+E9Yq
         2mXpTJg7mODpJ7jhMizCWGVZjs5SihzLOt6ccKXvy9tHuIGHGzDgdWkkw1mxAOhBaFOX
         IcKrNHl52zchhg5N85a1UeZcp8hUnRQwBm/y9HZkbFgVQYOMSw7M+niBEpzbfMofNA70
         gtK0T6riMl4iLY4UxTBmurAm5MrieGY1dWMgkvWW+FNezEl/Ow3XZmroX3qTAV+Fkpw8
         GX3esnb5K2/WhdP8oMgE7MLpWR98/9lr/1Gvj6m2Gqi+ml5sf3NjhNxoOppncflwAvXA
         6zzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709110207; x=1709715007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SfLLRr+7TVO9BIvaySCbRAIq29D/g1YN79CAfZ4LjO4=;
        b=Wh4Wgpt3apZDQp13s64pwBOprRrk080pVtWkHV55HEEcaY4Md3Vnwm5fa/jyouOkf3
         McV1N1MlruFhZvnA6oHWYPGNEnHGeRMgietsyPoU47AcXBkAGHlYS9jr86eWoilJpuHG
         2z5qHFcWmcog6fFhTDaX38xbGyYQiDOplSuHXil9bTex8QdCbueLzFsIwujMhMXHFZyR
         n7DDa4kpHyz0HPvDqbznXTSsEKilwy7nv3XzjChRqmPwgP8SfGyGHyDtFygTVglJ67LC
         UW25XGr13alrvG/NPIYia0Po0Z2zSuQUBQdng6wuKD+ghfsDUSDAHDynEp0Z8spPtwmJ
         hrfA==
X-Forwarded-Encrypted: i=1; AJvYcCWiSGlgpRnrw+MWK8oarE4fIklxz0QSPQL6G4a0GxYUiy7hTGCBt0bjdeq4rLSSwsByoJ02eGbKy4qr6DkC7y/Y3g5BuP0/MQ==
X-Gm-Message-State: AOJu0YwqAGL2XXnh13B3erHY363Fl9nccpOElT8/aaqcmTbZRRno9LhA
	BSWAbqte8qizDQHAslmn19L0oGMwu/zPAMWEF3M7rTay/xe7n1e8ViEJxSWD30RVSihHyktXUkg
	k6iK2KvAWEOWd2mWti0rt6Er/ATaVZbNuIiOKjg==
X-Google-Smtp-Source: AGHT+IFnsrl6gjCAhHgO8koFIoHLY5w/+IhehRrtWDWApTw4cgij5r0Xf31CBOYKUW7xMtxXK+PbUVZOw3b+zV+49jo=
X-Received: by 2002:a1f:4e82:0:b0:4d1:34a1:c05f with SMTP id
 c124-20020a1f4e82000000b004d134a1c05fmr8561580vkb.0.1709110207559; Wed, 28
 Feb 2024 00:50:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240227131548.514622258@linuxfoundation.org>
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Feb 2024 14:19:56 +0530
Message-ID: <CA+G9fYvzwLgC5i-vzN22x_ocjDRD6EkYwtYyKrH=DUZjumz7vg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/52] 4.19.308-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Feb 2024 at 19:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.308 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.308-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.308-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 6ea6c59b4f34e92143ce345e6b727f8d88ca98d5
* git describe: v4.19.307-35-g6ea6c59b4f34
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.307-35-g6ea6c59b4f34

## Test Regressions (compared to v4.19.307)

## Metric Regressions (compared to v4.19.307)

## Test Fixes (compared to v4.19.307)

## Metric Fixes (compared to v4.19.307)

## Test result summary
total: 50056, pass: 43934, fail: 563, skip: 5518, xfail: 41

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 102 passed, 6 failed
* arm64: 33 total, 28 passed, 5 failed
* i386: 18 total, 15 passed, 3 failed
* mips: 20 total, 20 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 28 total, 23 passed, 5 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-user
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
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
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
