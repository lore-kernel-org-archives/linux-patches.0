Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C353A1F4623
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 20:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750881761; cv=none; b=BbOr2epNSl+rVX6lc5/jIQ36XseOiZyLoowVbW47dQ48NtwODpWqP3SHIBAWKnXnhcvdi2bSekgxGhVMz8jMhvJU1picwjeL/lEjeD9Pyx+lqM9T9FsZ4zvrrhrEMqEh+HL2FEUDos9h0bgJb8xyZR9rRdu3m2uv3wp8TppudIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750881761; c=relaxed/simple;
	bh=GWxvHFwPBV5gIX5Qwmy+RsHiRnqW9YVgenIq5FFMcBU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a21K5q3yYTToWC4rtYulnI3bfmqU4VrxgrfwWjK5lgK/oJljwsQB4KaSt2HjMEsmrlUVqmueDrHTKp3gmzRSDOF/a458MLoEGn4hlN+4U3fNHtqkPbw3ppf4vE19lz/RRltBwF4DBh/QFyM89qLPk7owFBmm5gjU421uBWxbrhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dVIz5jxI; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dVIz5jxI"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-739b3fe7ce8so481370b3a.0
        for <patches@lists.linux.dev>; Wed, 25 Jun 2025 13:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750881759; x=1751486559; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5UB338dJyB9x4dGE/uaHtvPfiiZjGfFWO/fBs+2Cp2E=;
        b=dVIz5jxIpoCaAcLItXu1y6UUDuP0CS+meOs+vF4Dmgy86NCF/s/8RkWAGFteUyiTUf
         Bgn8ypErz87C3QMX3URWGssBXkbyOzzaQrjaIIm3JSDqhTpwoRF49iSTScPhCExaNNZk
         v+fpYDDLl+hSC8A0y8frnfx+FX7dsJaoXBLw/UaTdv9OPHI0qlUi3yVQBWrkQIrC4fiw
         ECRk3b9/ItQxKYRl+C0ehb5tcR+6QXANvdXy2jBSSFGJxAAjfVhM9q3d3NCiamrI63TY
         JYpf7377iSPa3qF19gUEBZ1CqnrhjPRDfUOCm+2q6x53tRglYTVMU9bMPc1VB6TpxEsg
         wiVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750881759; x=1751486559;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5UB338dJyB9x4dGE/uaHtvPfiiZjGfFWO/fBs+2Cp2E=;
        b=PiWKHhUv/T/Ux5yDJA6ITKJzB4LcKRTJK0xVdXKM/TCfeC0GVMPXAquUWe38HVLlcU
         YkXBgsBDBQtoeVZYQx2Ml2K6iiDoVDC/bo6KOl9QP8V5naFHk8JSTn2Q6f/5pf9Fx+3U
         9X81KfFeCEQ6g97+gASROdyBCuoe9/5nBWGAt/3tDcmvRTIQrftBQ1Wbe0EjIxZ9Y0Jf
         DkcK99+hCFTC+uAsybztT8P+sLHxEa/w42TnStBLXVJlzLgnCnv/XVBvn7b5H3WhLeqz
         yt3EfY6NpLxLT3uryLX5lI5wVnoD7jqFUHURKHWscehuOOoEZfUJ5s8e6++Z/3aj568N
         gpaw==
X-Forwarded-Encrypted: i=1; AJvYcCXm2+RdEfDlB9ad02jcdgpWvzDi5f9EiA1WlyAaBuYhYgHV4+8On6FO3RYICezHHt12nFDzg9G9@lists.linux.dev
X-Gm-Message-State: AOJu0YzK6TlIHtOQ5lbaA07KxkHHgOEkT1i3UGNNWs+sjbxbDJ/KqrHN
	whmWSmMP0iLwPj/UUBwdyQgOxT+GduG/KSx0sVAaLT9swrodwvcnfB5WbzN/iNM01i66+g2/CZh
	r1crImCBvCfEeNHyrA7wMfeRqB0fwsQ7z5C+sYyJWwA==
X-Gm-Gg: ASbGncvmkc8cDf8cnBYLbcgthTW9Yy1D8MuZ6C11OkCWnmn032vsJtvBTW6hkvXUA2K
	XcCFhID+QXOwbdvj5bdMO+M09xHfV1ffxx4hA1iZoEi7nqJLpAN8tW0yr9E6ySCB1UEYAW0EDdv
	Zdu3KM0OF8vPR6VBJRQRg1RQsbqbcTjRM7SRTptU/hbqjrZ5I33srPKLKu64apI7LDr9RL4xYBK
	MMGpsrFqWua5TA=
X-Google-Smtp-Source: AGHT+IGp24/z92mP7JfdtfQI7sA5sbT6HecvDxjyl6G3uib8/3VToor/29Vj/jdDEhMiO8w/jgWZY09yEuJRJcmOpZk=
X-Received: by 2002:a17:90b:2b4b:b0:311:ffe8:20ee with SMTP id
 98e67ed59e1d1-315f25e9832mr6879387a91.11.1750881758779; Wed, 25 Jun 2025
 13:02:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250624121412.352317604@linuxfoundation.org>
In-Reply-To: <20250624121412.352317604@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 26 Jun 2025 01:32:27 +0530
X-Gm-Features: Ac12FXzEp4L8RYJhUT_Lg9wiamdSRFMkF8CBHtdeGPvPWKEwJR4j0UjhcHdLfRw
Message-ID: <CA+G9fYse3W=-C0JbR6fhw=PLPy4aWUFqPwPTD0eK+x0sLidxYw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/352] 5.10.239-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Jun 2025 at 17:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.239 release.
> There are 352 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.239-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions noticed on arm64 allyesconfig build with gcc-12 on the
stable-rc 5.10.239-rc2.
(this allyesconfig build was skipped on rc1 due to other build regressions)

This was reported on stable-rc 5.15.186-rc1 with bisection results.
  randstruct: gcc-plugin: Remove bogus void member
  [ Upstream commit e136a4062174a9a8d1c1447ca040ea81accfa6a8 ]

Test environments:
 - arm64

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: stable-rc 5.10.239-rc2 qedf_main.c field name not in
record or union initializer

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
drivers/scsi/qedf/qedf_main.c:695:9: note: (near initialization for
'qedf_cb_ops.get_login_failures')
drivers/scsi/qedf/qedf_main.c:696:17: error: field name not in record
or union initializer
  696 |                 .link_update = qedf_link_update,
      |                 ^

## Build log
 * Build logs: https://qa-reports.linaro.org/api/testruns/28858666/log_file/
 * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2yxHG0IfVj37DNnB0QgFB8uKDn2/
 * Build config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2yxHG0IfVj37DNnB0QgFB8uKDn2/config
 * Build details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.10.y/v5.10.238-353-g9dc843c66f6f/build/gcc-12-allyesconfig/

## Build
* kernel: 5.10.239-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 9dc843c66f6f9281a760618b9967c74c86438b6a
* git describe: v5.10.238-353-g9dc843c66f6f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.238-353-g9dc843c66f6f

## Test Regressions (compared to v5.10.237-271-g8bfb88108193)
* arm64, build
  - gcc-12-allyesconfig

## Metric Regressions (compared to v5.10.237-271-g8bfb88108193)

## Test Fixes (compared to v5.10.237-271-g8bfb88108193)

## Metric Fixes (compared to v5.10.237-271-g8bfb88108193)

## Test result summary
total: 37161, pass: 28448, fail: 1823, skip: 6742, xfail: 148

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 100 total, 100 passed, 0 failed
* arm64: 28 total, 27 passed, 1 failed
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
