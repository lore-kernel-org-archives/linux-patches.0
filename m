Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC790244660
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 10:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758623430; cv=none; b=lBI0T+FgpQ605wvz502IHSpdillWFw6NkpEjSNNHTmKFCKBTNClsUmG6PbpB9LOpue7Lf4YcjVdZN/kQH7qIrqdsgdJI4cgkj+9MSlxXISi2IEIhl4YNvm7eueoIcKk1nXOLPKLslMM0grmTA8HUzUtb966ovE3zzkju98jdQqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758623430; c=relaxed/simple;
	bh=nQYDG7/ESRE6NVpQ8N3MVFRC1NTmVZPp0DyEPgDS3Uk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hr9aIAdYfgwV2Wmt367Jv3TyxHtJCBMiftU6Es1CXsO1pIFRZ6tXwOmZym65MQDr6s2QOM9vf7m3huFp3P6XMxcvFT3i6SBnjMF+SfjL4aMrzYIJekkh1eFjYQFKntv4W4rrZJNkqEIXad8DJCJFFLWGjBuT0T4yAMQAD12OjUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pMF4RnDq; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pMF4RnDq"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-27d69771e3eso2408685ad.3
        for <patches@lists.linux.dev>; Tue, 23 Sep 2025 03:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758623428; x=1759228228; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HMRYr8OtOqO/HFrezWjaR8f9pLA6E/Ty5wzBOjw1mXE=;
        b=pMF4RnDq2sPtxO17X0ckKRAndqN+qK7aganZfiSRCZ1BC1bBWD9Ps6q8eNbW1reQ+5
         JVvX1jwXRF2ZYzlJt97mczHZJOAHnu4kmkJcMWKLVZGSuXiJ6j4Hbd/+B26CJ8p5Mor5
         raUESO3kSPpcfpehTpdTdM3jhEFgnKTCjcZby/J5VeJ3hc37XEeuhIf5lAhbQ8aCVtGO
         vopKEYCzF5A/usqtCj/dxhz51Arow5geKvBoO5BNBTWw6n5HHBy7BhXwKUAi65AXpRLt
         aUTFauNm6IEDWtMXtx6QDQxsfU25WLlpP+6Lus/9NmYg796jXbGfqFwViXt6O6ydNf/k
         JwHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758623428; x=1759228228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HMRYr8OtOqO/HFrezWjaR8f9pLA6E/Ty5wzBOjw1mXE=;
        b=oSgNLijzKdewhRWdUFLGVMHRWMF0g98Gq5K2BoAXWPuqseTD1vzOdJYe26vGLgy59M
         3K2y/71sqrLCbikOqxFNVOSF8kYv9iDlecwJ3P3X9OMpqrEhd6KR0tstplQ4Gui3+5g4
         vshDbqI7Cbww2UlXDAyQ2MyasfEQLUSlOhMTYIBQGkWiLbdB3uGIPbdJJN9O3NirlaCi
         aN4eFYVRMuLrwz5tfclUvwdwgMxXNZIFMLmo+A5DwmTTCZs1i2MJuYxi9DF4ki/bujA0
         gWENchls92XLSuE7ddmTII8+DMXrS5wId2NjNWi3sYKokVUwbRzhAH6NKCaz6vDyDmSy
         63Tg==
X-Forwarded-Encrypted: i=1; AJvYcCWhm6EZfvcheV9B+iR5eKgBgFpEQ/cOAAl2tnd4RCMcaWaYNthF64yr2uvgWPe17/hRAE8AMTeJ@lists.linux.dev
X-Gm-Message-State: AOJu0Yyx3VOadmElp3WjhCbuJ6BUSM6fBrIf5gI5UTvNasPb46PGg9ey
	mMEi+8yelI/w5aPRtFl095auGqRppVw6EGI9/Wfn2CdvIFfGNKrmLa4CR6rW33U+9SEM4v410Ew
	6sOVWfVapDXArI6F/8Z0Q/2mGvZHF87/N09MqP1D6EA==
X-Gm-Gg: ASbGncv4ot96hDXw4Ix9NxoAp/rxNSqkDRu6PHENvgOe7zKl0X72vKLZ7IhKI9ZlQtW
	A6AOCVyMGKXvwJJ7QYgk6suA7Av0ogmnnPb1UPglAy6qQIEaN9aC1I0Mv5oXVI8eOxQPWqsR8d+
	nkcXDRId85iRRG+wZBvLHJzR+b5JVU+1b8r5HMPQhL3l9Hrq6VixHF+9mXqH8FeawQlaSO3bv7C
	HRiEnZ0mtKTaKklOL4Nr4ebMnyz02x82dIMF85H
X-Google-Smtp-Source: AGHT+IGCbLaovnWzmpLxnAHxOBtwxFY93rFcE1czzzxjsg6cIsdwcN546zJG2Fui5rFNOkdh8TTlG2kvVI6evYMjiRY=
X-Received: by 2002:a17:903:11c3:b0:267:95ad:8cb8 with SMTP id
 d9443c01a7336-27cc874d3edmr25011055ad.44.1758623428016; Tue, 23 Sep 2025
 03:30:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250922192403.524848428@linuxfoundation.org>
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 23 Sep 2025 16:00:16 +0530
X-Gm-Features: AS18NWBtNIoXbscRPGhjJ8JgJD1DACVC-p7XxDGqa1-ukOiEjaqrJ9qSh5X3TZU
Message-ID: <CA+G9fYujv6g69Pmpr-yZ8fy-P1ywrnhwe7Tip3X1HPPjfP=L5w@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/61] 6.1.154-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Sept 2025 at 01:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.154 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.154-rc1.gz
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
* kernel: 6.1.154-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: bd7dff6dbcf5b16eefef05f2750607b70bfe727c
* git describe: v6.1.153-62-gbd7dff6dbcf5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
53-62-gbd7dff6dbcf5

## Test Regressions (compared to v6.1.151-87-gb31770c84f52)

## Metric Regressions (compared to v6.1.151-87-gb31770c84f52)

## Test Fixes (compared to v6.1.151-87-gb31770c84f52)

## Metric Fixes (compared to v6.1.151-87-gb31770c84f52)

## Test result summary
total: 227967, pass: 212169, fail: 4614, skip: 10926, xfail: 258

## Build Summary
* arc: 5 total, 4 passed, 0 failed, 1 skipped
* arm: 133 total, 133 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 21 total, 21 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
