Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA432BEC29
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 10:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750849085; cv=none; b=gEuuCSKKgabM7rvLjHXMjjNZrczpNFYAJmnPcdAOTlA5dIMHEQAa5tYTmviPIJbzO+pFrZetozN+v7znZTeOU+1vhBEOg/wjmRTgvAd/rjI9uJqdkbDzCm8zSxYExoU6SLc0jjtbB3fczR4l3+rMgle9BMZ2x1AXzwlnL43KHek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750849085; c=relaxed/simple;
	bh=D72mDsP1erYv+cbvWDuoheOFU4iq9ltrX5rHkzuOLfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zcin2JO0jyW5EPwGPeT1XFXu2ZmVZk5YNgYBxlzLWjsaj01AbwQ41eKkt6Qb6plzjDVgz6+00VnMBbWH7pSnHgP+pbh1mMYjVVA+sGolT1SwRmV51+vc9YHh2+ktV21uFHdEdzEDDV7V+4HWqLsyhOoTA7EjwdYlObB2chc83aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r6Ev3ODv; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r6Ev3ODv"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-748da522e79so3111076b3a.1
        for <patches@lists.linux.dev>; Wed, 25 Jun 2025 03:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750849082; x=1751453882; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ILAX6gSRE6kdPqfm5GXpanQ56vn1GjYg9ehEVWFYiQ=;
        b=r6Ev3ODvcI2YQTOfB4xQUJxmZKOEzrpSppokIltyyI29rJj9heI0dytifUvYF7p0g6
         rTLurng/uCRErZPvQw/EdTujKWcCGo7MbS+FvOkwf8c9ajtF3YwBEVBzl6UqAkcEA5Bg
         hTSmzOW0z8M56DNuM1MxDgyGz0X3TXOlxTzQREK+a1/IjKn577BtkrNPP5j1zmg/N7hm
         0LUzZ20+YFu4r9sVTBq08sk+LD1TtFLZsk6biphF9kGVh+5ip3JdMOBJIkkxFKLVQlBd
         rYER077YhMHF6D370HGdmLqyCQesVkUw6oFI+w5WKc5iJ8XSivqp1YIkvpTzq5rLjOGG
         Sp/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750849082; x=1751453882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ILAX6gSRE6kdPqfm5GXpanQ56vn1GjYg9ehEVWFYiQ=;
        b=ss6o049ezcrHc6voQ84V7IN3CUdFyYeuvz3P9iyIWC2bF+5JIFHrxA+wMBcODjXWz3
         w1HVEHpli3jCeaeWi3nk3N77EqI1YMTv4esm0T9P2HCwkh792zL78bD4xXzHJlD0fkJb
         Jb+kn7oouCkGbbj+jg5lODpB8V+LvLFdP3Kta/P7ciZA6VmEzyfP+j8k8QiXVM0WSMFQ
         WsGxy23tcRQMPtXVOUgzufib31ivoQb09Tu2pXae++1u3Zx0sgO4yObjfyS0q4FAZ+vf
         Sm/oxZW72c7CzfYIMeH+tNAKIqLFstC/AKb6PZa/sUv+w0hj/aNxjD0OL602hStGweJK
         jMfg==
X-Forwarded-Encrypted: i=1; AJvYcCUeXwlRiDzd5RTBx0YD5c/bA8ckOt8wpjl76+0TTiWkpriY6mjzGStjd41z3IHZvPLZl5Z/EdNr@lists.linux.dev
X-Gm-Message-State: AOJu0YwI9yydqwsIGQg6D6s50tzfGEoPk5Ue9zkcmWWutluRqIIFwMoc
	MdEW4MS+08Fo2IPcTFwyzl59FI5y43Tn8s6+pyMtMziaAg77YpVrVrqwyAPZPQ3kSeR0OfkgcIx
	LQ7UCMLqEmyLQ6JwwbZO1JkHADghZIR6y/ySVfuj87g==
X-Gm-Gg: ASbGncuRO5GnSkvXZ4uP9kxxOia+SdwWU+9D4+d5P2lLL3JOEqRniPZTr2gGbp/T//9
	YsaHAPn4d0quZr8g3u8xIrIbAAA9Lvw6QXLL1r12k8GQiBwuz2t5G/x4Gs3QOr2J597P5amXmhZ
	c0GcNZEP+sbx+th6TlG8oTe2+kcAtF1fF7qQmKXP6DIk+EIEvmG9SyRU5M94outBQ9eZ8ZlWARv
	9Bf
X-Google-Smtp-Source: AGHT+IGwRsFj0UhDLAKL9Lzvr4zJw7vlaSrihVLKeOijg8pRtuJpuGoGsVMTxmEHUYJc8eXh0Y+cl5E9ZF4JKiRvruI=
X-Received: by 2002:a17:90a:d60d:b0:313:f6fa:5bb5 with SMTP id
 98e67ed59e1d1-315f26893d4mr4206266a91.18.1750849082440; Wed, 25 Jun 2025
 03:58:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250624123036.124991422@linuxfoundation.org>
In-Reply-To: <20250624123036.124991422@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 25 Jun 2025 16:27:47 +0530
X-Gm-Features: Ac12FXx3_t-mGX_V8J9UvgTrbHLe7MKYtXoHtEecv2RZNbjg-T01cSYHtYXBEO8
Message-ID: <CA+G9fYvY-KeV9yfas8S0ZU46BwQdk5pGEowLVkEgXo-9BTXQEw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/507] 6.1.142-rc2 review
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

On Tue, 24 Jun 2025 at 18:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.142 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Jun 2025 12:29:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.142-rc2.gz
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
* kernel: 6.1.142-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6d3c6e22f526bb03b148d94dc2848088c4a89c6e
* git describe: v6.1.141-508-g6d3c6e22f526
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
41-508-g6d3c6e22f526

## Test Regressions (compared to v6.1.140-326-g1c3f3a4d0cca)

## Metric Regressions (compared to v6.1.140-326-g1c3f3a4d0cca)

## Test Fixes (compared to v6.1.140-326-g1c3f3a4d0cca)

## Metric Fixes (compared to v6.1.140-326-g1c3f3a4d0cca)

## Test result summary
total: 134454, pass: 118781, fail: 3766, skip: 11722, xfail: 185

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 131 passed, 0 failed, 2 skipped
* arm64: 41 total, 37 passed, 0 failed, 4 skipped
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
