Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EE32DC359
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 11:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759318986; cv=none; b=js15WmjBlcoDMpv+9eX3pDS0JjX0+QY85Ni4rQWYJQa/V1mqQsQ3jg4jOfrY64U/lw2tMGf6nDK6WgECcKYkA2sXHlKPGZtP19E8pEHLidNVQ+Oi80uhfw3mi99pq0ZYWS2SumIGRk8ZqaW4KxF0TW+C45jNqVnZWiMKyDup7ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759318986; c=relaxed/simple;
	bh=ICC1mpjBaX1fMrY45swyhJyHRGjc72JKuZEGUjPTJjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FWZR8LuxcNvOsfD+ptqo0FFvdWhHchEgI3w4PwvM7hKLDlG0zZTz1FE/gZ08pxPs8AvmVJxM3O3xzRUF9hCdvVuZXMjFJFF4WfIUI3SxMkWsPtpMQq2eVZznIAu+dTd3VRlmpLmLGX/3Gw5y2hhJ265JyNBl8Iroh5pGpYxFTB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=z7dosk3h; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z7dosk3h"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2698384978dso51558995ad.0
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 04:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759318984; x=1759923784; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/M4p9D7lI+yLv3i3nD5AKMya0gsPB40iM48gCdLXN88=;
        b=z7dosk3hbuC5mOOyg2rR7Yc0YwD++YhY7SgnL6r1aTGHVPw7/mHPYtknq9gIcH8UE3
         nIso+eAD96khNo/dSZqHX/vQj0JKv9dHD0ayP0/wugGv/SkO8uCkfRiXp9Mxn6UW/u2k
         +/pztJIULXcHHw9qOMSTmuFl9sE6/la1W8BaPy6+FhLbTgai3BQJnlfbHHLYeMwDC+Gj
         6rrDzKJ1wvwSSJr5GUU0+FFA/cdbLNm8fkbCmaReqX4OF7U+XAUD/SX1imlEyisd8tFM
         Pv1LRw4Hjxz9W9Ithu5twg6C1worUM2jyu/QRW6HaIsVw7iF2Pc6rLvRxXeDMOiN2ufv
         0rSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759318984; x=1759923784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/M4p9D7lI+yLv3i3nD5AKMya0gsPB40iM48gCdLXN88=;
        b=AUyMO6oiBUpWppILl9AyZ/uLxl5B5Vz9VLDEPOgHdQqr1OpR81rwn8nbgYLrWikP3e
         RqSrypoGi1X/jzuTUMP2HHm1Pud0dt7e9fvFqCB4OVkDPRvcr9C4UEdwSthjDQiBXV89
         8pR3QJXLFFrXwxECWGzsUHFfIhFXg7knoVv+WxVcO9u9/k3C+RhEPGzvNjkbgkRJSuSm
         TaGoyKVLV4ehgh+vFNdHM+nB0P6Ni3iXGJ4GTDFDf7nLXsBnxtorUT3gaDy/0i9C1mw5
         2nU4w2+3zMnqRCJ9JQD1ZzueQmaQ6HupOrocIsbAAXC8VSqMXfWDw+2wyD5BBZpZqRyZ
         TzGw==
X-Forwarded-Encrypted: i=1; AJvYcCXmlnspa7sY4TfDZNihbynVA84JZxOrr51wQMW1zTsDb8FP0zaQhlMUXoPXh2aSZC+euN4SdxWW@lists.linux.dev
X-Gm-Message-State: AOJu0YztIdWzZhwisUp6I1dyJtoIaQZD2cGKbhFAqo+yWPMxyrsI4ecH
	oW0SiOC+y4ZIZ2MCbeNpQpsOOhynJbHZ+n0pXGlklXKFdufLJne356+1vJVNntH6Bxr4OWvdLNv
	nbOfCBWyB8/d7Sx1D1RMNOajvEzHXLbSvyDwHQFXlEw==
X-Gm-Gg: ASbGncumPqFE7VpfTVSIfQb0n56wDxXN17WJpj3Wex3zVCkAbpgUNBYeDEZMV1lUMSR
	elIsqIjKyajlyetIp4FpSk1E4ZK3Lgos88UbunmfgJ6xWbM0Sn9OcUKIVMGxqltMiOQsBKBLFJd
	p4GgM3uoZMKfqEamISsaZfFEE5IjZPUypFwxwT3Nh8MnfZa4WCnA7I79I1DCH945hzPl7s9UYwO
	Du9xdztAxRr/Kaa3Usk4HzastLKhcH1DICrUEnA7FEJ9JxjCAnDlYXyPjgaRrHEREgDkdGknPLK
	wxeOzClGd+JfOKSPZZg5
X-Google-Smtp-Source: AGHT+IEMbx0M87eZESs9jldV4MdFM4iSP810cku0WLVGzXf8k/U5UFP/ypYIgF2u0SiTMZolotTj1uDJoJPKSAwtYQ4=
X-Received: by 2002:a17:902:f68c:b0:275:b1cf:6dd7 with SMTP id
 d9443c01a7336-28e7f32fe82mr42585035ad.34.1759318984443; Wed, 01 Oct 2025
 04:43:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250930143820.537407601@linuxfoundation.org>
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 Oct 2025 17:12:52 +0530
X-Gm-Features: AS18NWDxtP73CATq2NXcRu79wLgRRf1DYlwdDx4ErrAk_jQ77dIgp1kcYcZyKK8
Message-ID: <CA+G9fYvrpdXhrUWK_FGbxXcTn3pN1-Hw=qJUjyD1k93C=g6ewA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/73] 6.1.155-rc1 review
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

On Tue, 30 Sept 2025 at 20:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.155 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.155-rc1.gz
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
* kernel: 6.1.155-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 8a8cf3637b176b7508c3f109c6234a1a6e86d9d2
* git describe: v6.1.154-74-g8a8cf3637b17
a* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
54-74-g8a8cf3637b17

## Test Regressions (compared to v6.1.153-62-gbd7dff6dbcf5)

## Metric Regressions (compared to v6.1.153-62-gbd7dff6dbcf5)

## Test Fixes (compared to v6.1.153-62-gbd7dff6dbcf5)

## Metric Fixes (compared to v6.1.153-62-gbd7dff6dbcf5)

## Test result summary
total: 225710, pass: 209239, fail: 4868, skip: 11344, xfail: 259

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 35 total, 35 passed, 0 failed

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
