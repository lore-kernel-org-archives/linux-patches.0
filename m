Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED0C185B72
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 08:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740385213; cv=none; b=ZvrXHIWFDO8AiPzQGfDMdZ6vu4SzYRIXwZnyItGgl53m9dmSAviH824eL7fIljnD/i0vegiVrkPiN1INVsPhkcAAjGWyw41wSbS1uPY+OLmlNmZlurzUEZRRoFAmjfOiyTpMsIqUcu/EaoL3O2sn50xr5T1kb4A4q6mKH5HGph4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740385213; c=relaxed/simple;
	bh=21E7UgrvRkxRMCUgPTzjSwSV9qomtLwoLuLUv0Zpa7w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NNFGRR8uzy6sPpv97VCf8zHqFlbsZwlHQwV4ONJLuczr4ErLpEpiuoWQF82PC3AdSozLI+pIa5YA1c1tUxrldRvuwjh/MWcf6hO562dcf6fkNgJc22nslzQmy4K0W5FAn6TTWAeXq3mDNYJQgR6rq06Ytxliqv+xgNZIGI6pRVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qCLTsL3I; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qCLTsL3I"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5209ea469e9so3526865e0c.0
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 00:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740385211; x=1740990011; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6r85kezRIutcCGmLi1srTZWWPXuVJ6TvYefvLy8aRc=;
        b=qCLTsL3I8O3Fa6XjzGuQwy2NeOlqMpnviXrO2XXQtSZxCX1sgUUXa2tYs5IVyl/O3g
         44Jn5Hj/KqcvI2r4cOArKu5r/Ht2i8YXHI0k4f+dQ7cjLI5hoctg7uxTeqElXQEa92q6
         hxmlp0AAUsVCd0Y3oUnyWHb2hz8IgZQcdnC/7Q5c5IJEpFeMy4ECgJUBUB9Y6QAmwkHb
         qeslxcE2ql7BbfO+mnq1khPQUKBW7G75BztbfWovs084OqTkia3B157t7ySrZNcSf2fJ
         207MmJZElTEt+F4iiP+rEzdY3y0H1DsZbKi2wVSBC7jpzRtew3ytpZPIr8VrrjW/0e8B
         im7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740385211; x=1740990011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j6r85kezRIutcCGmLi1srTZWWPXuVJ6TvYefvLy8aRc=;
        b=YP4DVTOlG2+zjAffD67DVJUBeT2XAt8WlbjX+GPUCJtEnclqtm1xTPFPDIYUq+xDjK
         WAVJ0QxSD9yh8oRg8s3t+y11vBBp0ggGjj+Dw3SsXaMwJxHNOOoiQ0eGn9boSLWvAIal
         6YbKHD1HJptlN//EjHHu5kVtHI7wr38lrh87quogW7Y4BPZ/gAwDo3ulhncOJE39ik95
         X11Lm5KvXLuwZ9eZNB1FdKAvBVaf6E/dhCZT9ScJi0AsLHNvODVEdMzah4SwkqQVYBSU
         NXRpeEMOideDLw/y84oTijDBbm/M03K400zzm+toATOp8Rij3jxO/DZPf3Faqf3aiYRx
         vO4w==
X-Forwarded-Encrypted: i=1; AJvYcCUc8sgO1yGfsIvkOEyxjgyRiwA9gM5VWjfxJwwvqebIzuixjVpLOjLWx4/Fw5lC4ZA9T67iZ4LK@lists.linux.dev
X-Gm-Message-State: AOJu0YzGzsdBPXnDgQrHWnhJ4BHHUngEJLrTF9/5Qydy+gwImUONcJqJ
	hUNxm1ARr3LbQuTHm82fSnAhYU8UEOGE2h1+nZZp+7EJ7zW8bfc6THU1BftijutHu5ae1Bq5buU
	EqHc/M6mB/cg6m5PFh2bkob5utxhbEd5gpdwQHg==
X-Gm-Gg: ASbGnct6pS6oN2mtTZrUwUCp8iBLr5rTeWwQNauS5/k443pU2inXDE6YR2FukspKxnO
	XdtPvmMef9eAFYy1pxY8xwwg2t7sfox55Zq7oQvwWtgbNKNd8S7En5NyzxlUz08pPa2DH/U3KXs
	zGz5uP6zFN/QrkJQdhmObnnpd5lgmelVdYkkwCK+aO
X-Google-Smtp-Source: AGHT+IGGzBs8e4QC3zhjyLv0Q2Kb5xRXaFl1GSs1fX52Ac61Q9Lj9A2GVQb5hQJPza9sD0lao51FBajmXwOvO1rVoSk=
X-Received: by 2002:a05:6122:3190:b0:51f:a02b:45d4 with SMTP id
 71dfb90a1353d-521eeadca66mr5091486e0c.1.1740385210804; Mon, 24 Feb 2025
 00:20:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250220104500.178420129@linuxfoundation.org>
In-Reply-To: <20250220104500.178420129@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 24 Feb 2025 13:49:58 +0530
X-Gm-Features: AWEUYZlEaOoTQqQ6ZfWquTdxPh6cQo7pAekxnBccb5yJ3vfsbf5zMYnRWYnbUyE
Message-ID: <CA+G9fYuGk8vO3-OHRe3AHzgDWhNYWpZnuhT3p49zytXgeCN1Gg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/258] 6.13.4-rc2 review
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

On Thu, 20 Feb 2025 at 16:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 258 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.4-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.13.4-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 191ccd3d65d15205ada79613c4f4a38e01e56b28
* git describe: v6.13.3-259-g191ccd3d65d1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13=
.3-259-g191ccd3d65d1

## Test Regressions (compared to v6.13.2-443-gf10c3f62c5fd)

## Metric Regressions (compared to v6.13.2-443-gf10c3f62c5fd)

## Test Fixes (compared to v6.13.2-443-gf10c3f62c5fd)

## Metric Fixes (compared to v6.13.2-443-gf10c3f62c5fd)

## Test result summary
total: 125960, pass: 103347, fail: 3715, skip: 18898, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 137 total, 137 passed, 0 failed
* arm64: 48 total, 48 passed, 0 failed
* i386: 17 total, 17 passed, 0 failed
* mips: 32 total, 32 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 38 total, 38 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 21 total, 20 passed, 1 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 3 total, 3 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
