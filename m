Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B086A26E712
	for <patches@lists.linux.dev>; Thu, 28 Aug 2025 07:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756366006; cv=none; b=ID8osP9EGHMXHyeJkB/goCr2ec5geV2GW34rVeteGX9oNoKQsagTYgfCVxejSdWT9bt3KQh9kJl/rKp9JPRB/1M/jONDl9QC88uREjeWRxcaORixagDHc4ke4M45x3ehm1HcGKwXhnHatEIgobYhk7Nd96CRuNTaW6Us2Xr4n/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756366006; c=relaxed/simple;
	bh=FWeqn5vRZAH6k0pKhP35N/soh/ogrNerUNcbSo/TcDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ewNM9JY3ZSd/QpkgrUl4zonI2jzeuEYCFkkOM0RKXkuEbXKuImq5mE1USWHDjgKJsjrWPlTowEvMPkqLeE/5GRhLgjZDo0FewAuIzC3ktqXYgBprWFEdp6tnHshraj0mmO6MeUstxBLeaYBmzaDeFP9mnTueRHS7sLwn5LPjTVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nX9XUb+I; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nX9XUb+I"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b2a09bfa2aso593451cf.0
        for <patches@lists.linux.dev>; Thu, 28 Aug 2025 00:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756366003; x=1756970803; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7deqPVGcNTC25viCblNvhMMKUTMA22h7onsyE6m/3YQ=;
        b=nX9XUb+I6xdSZOLxCAzgaXoOamkXY0P9ooAyjrFsRXto7dngo67II5hdZSJNiN1jcj
         9EVUtS+RwzuM+2A6fEVC0+lCkjRdWNxYL9DrR/N78E9kH0Hd33/dQD9bh+GULRhIuL3T
         loGXFhTPDp/2mchR6S81qhshFNM9IiU/JTOSCbgZoZaEwdQ603gfNTs7CftnVW6i6Z5J
         nrXoYXAolQwnPxdeoyLHnV4lQS+/Ob8NRufE+4KKmbq95M49JWQxo1Jrxzfsv71Oj+pQ
         b9iL2u67OqTpgxyj92v4+fQT6peU6tfYmzb/QXqvLaT4KBx841WATsxSkDxFiF6BLdpQ
         qnng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366003; x=1756970803;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7deqPVGcNTC25viCblNvhMMKUTMA22h7onsyE6m/3YQ=;
        b=XD+AIhjPt/FxfDhM5TjPyWO8BZdHUx/8vtKdDK7cZ8/3qZdzHYp/CIOuMzxsE+vFKl
         o9T6XnEAvltbmU8/rTaT4HXeBE9FLQJDnc6lo4Uob+cnAhYMwXU/4ZT7kbUJAQUiaRUl
         wNm9Tl3pa5l1oLKqB+a2FAWvm46O1o3bSdWsMrgMMxwwidaFWWzOdu1hb4xvqj5owVW4
         PhvdHvviZ/plzap+DPEVJSqB9+YbbrzdI8OkmFX1TTnJ8QVx4SQIJpRwMu6FPcqNK42x
         /+bff4qn21H86HVBVNcvUS3WB2iPaR8ecCfkcSdq/oiOu3gpX+rQRvM+RnL6VaPekfKu
         uAYg==
X-Forwarded-Encrypted: i=1; AJvYcCVK56tFQVkZYwwX3IwNCc6y4fZ0HOFyHy8VsTz1Okz0kIwn3/RCVLMXl3N6RrNcEiNFbkHrPQzl@lists.linux.dev
X-Gm-Message-State: AOJu0YwCHJu7KdaNdFMQ/62LJhq7RLR/MLB+KU4jU6xgBeYC8xTk9yAx
	ZgrAekBG5B+4rbKvqtZ+XmdGqwSdNIEJ45dB8nP8JWHQndRxL8LXwekUes5J8hMe04c8urxty1j
	YlqWXwDe5W4d+asWqEjYlIMtM2qzeHAHgJ7iY+D/QIw==
X-Gm-Gg: ASbGncvHSNBYotAiB/gugYMFq1GMgUvCtWzgnHdTiYZJznYt9VXQB1ZqNTRZIeuG6ha
	F2/gaYhI3owG2JCMO7bTxDGs4EQ24o7juaYlunoMyW0Mck8/kuYucqlODssYERKkuPLadRFge/Z
	tQ3O6TFzRWrDU6mxwR4lceE2CfaqCz1uOm2NH8cNcKBdRpg49TB3RAyNybvF7QqS74rg6sEilx8
	1ozbF+PUfLcOOLu
X-Google-Smtp-Source: AGHT+IErKUhUmI37jeBXoTvy7qMI9WCIiqOnvQ/h3DmG9UhJAH1k1Z+eP17jDLSBcN8nrX9bC4v/R4LnJVxfLQLcGYg=
X-Received: by 2002:a05:6214:1d25:b0:70d:96d0:83c9 with SMTP id
 6a1803df08f44-70d970c54a1mr165565056d6.2.1756366003397; Thu, 28 Aug 2025
 00:26:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250827073826.377382421@linuxfoundation.org>
In-Reply-To: <20250827073826.377382421@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Thu, 28 Aug 2025 09:26:32 +0200
X-Gm-Features: Ac12FXziFZRFGNoRBwgurFlgUSBKRKa9JvBPPmeOBJJCRxUePGr8466KojIL_b0
Message-ID: <CADYN=9LV1rjG1dv-Ctbk24nwhRuu+a_mzBagaFEMZkQ7qG65WA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/403] 5.4.297-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 27 Aug 2025 at 09:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.297 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Aug 2025 07:37:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.297-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE: the previous reported arm64 build regressions have been fixed in RC2.


## Build
* kernel: 5.4.297-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: a860ce417cb1ff7332caa94fd6014183f8639a17
* git describe: v5.4.296-404-ga860ce417cb1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.296-404-ga860ce417cb1

## Test Regressions (compared to v5.4.295-145-g6d1abaaa322e)

## Metric Regressions (compared to v5.4.295-145-g6d1abaaa322e)

## Test Fixes (compared to v5.4.295-145-g6d1abaaa322e)

## Metric Fixes (compared to v5.4.295-145-g6d1abaaa322e)

## Test result summary
total: 43352, pass: 33098, fail: 2462, skip: 7622, xfail: 170

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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
