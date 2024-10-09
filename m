Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163DB15F3F9
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 05:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728451767; cv=none; b=NjCTqIsaHmH/eAyXLoKV9zmn1QdBr2tkMppEELJP52MjwhlEetLjan/PpZ/sG+pZlnDQNF41n2aZDQrI86D7JGSIk5R4/1xC3I4XlT7hIdbXORQVhf9j1Zwnm0PI0aL7XyfpQgzpwwaDQo+y5SqK0iIldplxkTnpA1EC834ne50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728451767; c=relaxed/simple;
	bh=OBoCzZArSFPgtY+XzpCWy7XGfDqTIIl94ILCcqhCr+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ca5aBgX+1ZH7Hf5u8sYgrfzbmdY3dGZfBBxRrOY4r+oLO3RQbfVKx1MELrwikCyc27yejv9NZG+BLaQOzhtTPFG3TyzEHftL1y69moUvj8TgDJBexh8txrZR06R/R25j1pFzON6SXEMQgP9Gj9TO+NfuvNLb3GP+4l0y+gx+lTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tK1R5C/Y; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tK1R5C/Y"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-4a28a1ae1adso2247286137.3
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 22:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728451763; x=1729056563; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCiKLx9rR66lKJZ0yCzrSNrW64yAvgeD84o2+iatpFA=;
        b=tK1R5C/Yk/OLMBGm8ObJo3u1oOtTVUMaHvbKxp5w2/h6A9H712HSSPO1VKppqxhvX5
         hHyPEJw/o8tmOLik/qUOo5Mxnn5or9rHpHCgGgKZt6EeLTm6ilVe66hZJh5HxNgQJMTu
         AKpBBmx/KLW0BRrNUn4qm4zx9ye6JncBeDq0Ywewd+JScHsy1w++4fUwihLdjtnqu8gJ
         2Mi88YXgZyMQoGHOHmeDBSuzYHt5796Xm64ILO9UpLDQAc6rHe+c2k2SZDRmQe8z/xNU
         UEzZjEFzxOabPWzO+Eqmhwz/zqqYMgihTCcUsyOx6eYIYqMpc6tLWJ8hJmXJsMrZxn+H
         qQ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728451763; x=1729056563;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tCiKLx9rR66lKJZ0yCzrSNrW64yAvgeD84o2+iatpFA=;
        b=Yi4zLiSK+RGiSjWu8eIbe0H/M6BqEx99iYIaU5xZtrIBKa90/GW+q7rG5SoW+J+Srr
         qZhxiLjyoD/WUJTa2O/ElWNFRugfVQ4AV+MidgUI2V2bvc70wX/ZJ0S3gtNn6jvDaRsv
         vkuNBCVm+uczS+m8jRquap1Nd/WrLvRiE00VLdR8JVbTUJsjk5vz7+4eOg2EcX2qys61
         SF+saKwPr3IPcpGpLjd1D/X4QAqZlwrOQ98ADcMrQtK0YH4vlQMOUNfY2iOvHj9sVA3h
         ACwB5b28q/CzkkBafekANxFyv3jArP+JhmEd8JI1Csw4BMfnJ2KkXjYldDBxrb9oT7Ox
         Cu2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXYdoqblPQycAs+GcmE8VGjHs6AC3bDFIe4D9iUoPzamNlIr1VN+uA3tHRQsymjFC/ePi7XUz2H@lists.linux.dev
X-Gm-Message-State: AOJu0Yye7wIEBvC4pncZEsArRDeobGGGi2ACH8F3qeOeT9Hqr1FevxxZ
	3HbSQ7jYTmeN9asOz2DlxjWjd8g6cdQW9HaBb9t9YCDVSJskp/Bs/a8aBJfCTCiKNg5oWkdaiht
	cK/2USN28uLh9LPeo2gMVzqf+BxYivosBwNItrw==
X-Google-Smtp-Source: AGHT+IEcGCHgN/Nj3U5qhLD6lgrzYU7T8ZcxgAgJFS75WLUI0nZsy/ZitTpWbJ/jXeNp0bK1KTTXpLFNuIpFI+P1egA=
X-Received: by 2002:a05:6102:e0e:b0:4a3:c7ff:8263 with SMTP id
 ada2fe7eead31-4a448e14dbbmr1647756137.20.1728451762845; Tue, 08 Oct 2024
 22:29:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241008115702.214071228@linuxfoundation.org>
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Oct 2024 10:59:11 +0530
Message-ID: <CA+G9fYtKrtzVZve=R_QiUUya5KUpAYn2R5andSk+ghPU21z3Dw@mail.gmail.com>
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
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

On Tue, 8 Oct 2024 at 18:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.11.3 release.
> There are 558 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.11.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.11.3-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: dd3578144a91f9258e2da8e085a412adc667dba5
* git describe: v6.11.2-559-gdd3578144a91
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11=
.2-559-gdd3578144a91

## Test Regressions (compared to v6.11.1-696-g10e0eb4cf267)

## Metric Regressions (compared to v6.11.1-696-g10e0eb4cf267)

## Test Fixes (compared to v6.11.1-696-g10e0eb4cf267)

## Metric Fixes (compared to v6.11.1-696-g10e0eb4cf267)

## Test result summary
total: 229679, pass: 200671, fail: 2692, skip: 26316, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 131 total, 129 passed, 2 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 18 total, 16 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 35 total, 35 passed, 0 failed

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
