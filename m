Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4D13431E6
	for <patches@lists.linux.dev>; Wed, 27 Aug 2025 09:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756286507; cv=none; b=V8ulN4HxsWAjbk0Fx4g/StQ1VEZWmYw4N7uSIq1jfuXyty+dUQwC/7hKKTZeONpN6bn/cw4K4hfXh9dafZqfLAtzv2zj9RN89m0AURPWf8Oz7IzUb+ZjQR+8IUCXM9dL6RpUAaG8kitUXbT0BOWUAwu+0G0uH3/wQ+j7OyDwozc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756286507; c=relaxed/simple;
	bh=AZj1pPR0y6aQduaZ5xgjFt/qPTTBCkCy04MTwZiYc68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iSeIRhF2vQAYZF+bv604PrF0jmd77LNj7ZM/J2vLvM8BavNSNV0RFNXuYSase97cxHHgnXSgJdaTfx1bqxXcu294SDoamQtY6p/gqLEUp5J4jOPAJch14kVrltAVdXECg4Ids00PgWgo8zXSXzmukxVMg8CLxaOVw5Ls+26wD/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YFZ5KYRQ; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YFZ5KYRQ"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-70a9f5a381bso11693636d6.3
        for <patches@lists.linux.dev>; Wed, 27 Aug 2025 02:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756286504; x=1756891304; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TokNB2bRsR2/8TfbgHqQMAf+PDOGibFsscNCc1T3i2Y=;
        b=YFZ5KYRQuvGfo4itMx+WTfyqoadOLlvW7lqkisnTM2/rSUUBUZzNIV6U5MfP4RgKSt
         A9Tx0o0ZOFWnTsQuyRBNMf6iVvNJyxd5GN/KN2InH79pjYtEv8hO8X4rhzBpxNdsgl0I
         omPMaADLWsRjvG3ALQ8QRkJE+IHaKA38p1zjvf7THfXNTfiH/WrRezJJZvmENOQ1bAyg
         XpRvpn1E7sSu25HY2N/U1oRUgrHQbg208HIB8IfaHpRQu1eq7aLdq2LzpuNsDgm2yp4J
         jwASJJ6FxoFjgtbP8Bf+wKJNnPBN+3gyX08vvXF/kU9MGCwdqrAQfdPDkgeAKMxPWUSc
         CX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756286504; x=1756891304;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TokNB2bRsR2/8TfbgHqQMAf+PDOGibFsscNCc1T3i2Y=;
        b=kD2QxEy2UOy3+yfveqtG0H5r7H/vD6Ey38XuDAO5iyZfDLgPTbvZXmf/9b9O0yToZg
         bM5y88UDnFKYZz3dyyVk1FwBg3CU47nlSxcMIgxuihB6L9145bc3PiYTvlaSFE9YSpcK
         iIowr4uhqOGisMXrj5iwWvOfH7ZKxu8eIUh9W6bHSy678n7CeG2AjiA8HHhs7HD/NHrq
         voZ1DPU2CRa8Uzd1Y6oxGTUWQNpY363WZycyxUSaWjH/2+cCc3LFq+INDVC7OEzkQIe4
         y5+2R0DUSrKyGNeP68JgpbfNlIYELk9ApY4KNaGH0QE3kIuW2bC0nOKE0sw2gD0Q1Nvf
         ATWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFOSPh1IiSSvvVUcvFqa3wcS8FNOYd09RFnb2jJZuUCWMWFPsRLr8i9jAMowIgl+/44Trxc/XX@lists.linux.dev
X-Gm-Message-State: AOJu0YxuGU8AVk8QMb8hnFfUZKhmN7w9QOwZumRjb2jBgblsqz7Dmq18
	zsKguC82nAarC3F5rlhEuPJziCe4yAobqb3FinlggsM9HYbNFs+fS6IavI9cGfYlH8rLDXoW99o
	S6ZLE1ZexWeBs9B+dsrG04ou8EPVunliDY5xoDjrKaQ==
X-Gm-Gg: ASbGncvCWcW6lEnB3aPJSNlgfsDpGofs/XUL4e1LGvoAKlXunJLnJqHks2pSzybzpq6
	q7QWmNs0cw+LlOtl41fk18jN+8qLYctV1FuHnejEWrr30MhvrLk/tkD9pSK7apgY9EwRPOyKQ/9
	s+4uXflgNRGRfb9juscxaspBsbWDhbsbbHH//d02I4ukI4zhZ7PUYG+kQMzHryRHkqfs3Eb61fR
	qFBtEJ7rMswKges
X-Google-Smtp-Source: AGHT+IHRCD/JU20GaEDsiDJhdDH/JUKzDUt65iA63JTM/WPiGZauyuzKZ1lvNdONWuPnXHyUAwIhAWkdWHIzEzbCdvI=
X-Received: by 2002:a05:6214:2602:b0:70d:dcc0:75e with SMTP id
 6a1803df08f44-70ddcc007d8mr23662316d6.4.1756286504325; Wed, 27 Aug 2025
 02:21:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826110924.562212281@linuxfoundation.org>
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Wed, 27 Aug 2025 11:21:33 +0200
X-Gm-Features: Ac12FXx6SLC1LrRxF2iJyXQTbryx0aIJgs-VszLB4HPdRp05YybesyDgvF8jLqI
Message-ID: <CADYN=9JypMr473i0yV00bwEkOyi3hgN+q48+e+dEhikqPYQVYw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/523] 5.10.241-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 26 Aug 2025 at 13:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.241 release.
> There are 523 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Aug 2025 11:08:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.241-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Build
* kernel: 5.10.241-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: d8db2c8f2fffdb163fc985c8f87a2847f3ccd4b8
* git describe: v5.10.240-524-gd8db2c8f2fff
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.240-524-gd8db2c8f2fff

## Test Regressions (compared to v5.10.239-210-g2067ea3274d0)

## Metric Regressions (compared to v5.10.239-210-g2067ea3274d0)

## Test Fixes (compared to v5.10.239-210-g2067ea3274d0)

## Metric Fixes (compared to v5.10.239-210-g2067ea3274d0)

## Test result summary
total: 38319, pass: 31293, fail: 1893, skip: 4967, xfail: 166

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 100 total, 100 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 21 total, 21 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
