Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A121FE45A
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761659153; cv=none; b=dvpSiPo1sNSbWIjAvpXma6ClUiaxCpnxJYq1Qg+1B1/hH7RXNaoiSsTXfDX1pSx3b59jF8A8xRkytPS4MEFXWNX0Q6JLSHOZ9KagM/I6qcXMKsmkhIPvtyob4mympoSuRqX3F2uQ5Nwj0HJyL7TLHhB8Lu+VbP4xTY6BoFzyNAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761659153; c=relaxed/simple;
	bh=gAweIO9n8J08eHn9APdNJjAICf2I1cbLYhJ+XHIC6sw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jN3U3l0j22Sw0L2W+I3yNrrD+ApJazDygKH0JvNv47JId1df6prkfcD2UGIxzsdTHn5olMeBwc+c/SPS+n5d/q0gA+YG6nIvV1uIYKwoCUCcWFc+3A1nWirryVAVfu28tKKQOXZ/CpGHeZKDV0WbtFVZNSsQaJxf6WYEfd3FJVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nSMZnOle; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nSMZnOle"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-27eec33b737so86064255ad.1
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 06:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761659151; x=1762263951; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zXp3oSsESI1TV0Y+956qT+rO7jlyOrnA6aCow0zk6rY=;
        b=nSMZnOlePbuWSd5aSmXy+hyOKkjBhyh22yktu00Gy/L34mSzmDT3O6WYh2t5EXhsf4
         foJBJxe5TlNv7toHJyq0TumZsAUIpWBqUXDJZxb1shmGyCYLUwuVSVa95Ewsi7L0Z6Ez
         gCW8fUdr8VoDzWigUtXjQF9YEWPcBqh4D5y2Y2Figdi4A1fKo+gIxOVYDDKvtiTqy1SA
         rsonUIPT/t+GlA2jKYjGIHPlbk9aAxpTlS5N1a46tKV71+f6TkE5SqwJ92m6nw9KlAFs
         ShmHh4m3b6SoHiE/v04BV8GFcIr5TbcAZ2cXQfZO/g2GGGaYvrAGfcxmey9pFONiD/k0
         V00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761659151; x=1762263951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zXp3oSsESI1TV0Y+956qT+rO7jlyOrnA6aCow0zk6rY=;
        b=Bz8MQFKRP8KP0AMZbY0QE/cWUZ5QFREgyWw5X7UbI7LeWPhL2KV2zJGkZZA2nfmaMD
         66+yHDwsgSHjyy2eIwtqdO9AxJwGMqJQuO7U8I6DMPJAWXqcA7T084ZAxeQw+hdeEwqY
         CsalKvfhZBy1EIFORRMUjUJP4XO9M9hKw/aFQWk8eDbocpwCtuzKA2HTKoDN5PYRzB8O
         OLazzdJSgbLhJALXAACEamxmvKkz/K4ZAM3q4C4cMqgwot7eBfyu6camm+DXUEMw3AxA
         TFturk50hdPkv+WFzU9nN6q3+Sj9Xea925Ep6vOk5cWV9lTXFpfPccPe/gEYYqBB5u4V
         66gw==
X-Forwarded-Encrypted: i=1; AJvYcCWb548NgT2VlVxqHdMrGg+9TuZ0/JJF/pDb82jLTSBpVxZga3TQZerZlVnavn/QSJ3nF7GkBcvH@lists.linux.dev
X-Gm-Message-State: AOJu0YxJs5zp5VT0+MiAIsh2wVvCOP7twDlkBDl9c239/QF/DCNwZXAx
	iDzjIcqJrJG2Icon5EeqzVjC2QfBvg9c3g8FDejLuIIYeRWs/tfMrJVJa6rsVTRyCEeM//6EOhd
	/iWQUt41UCbYIYawotkP3b0YwPxasPB2PC3lFaMU8PA==
X-Gm-Gg: ASbGncvpEZAShFxCjyVS9bxL3I9IbGWjiTKmYoshzPYn9myLVMzsV6lAZB1EWwwd/+V
	rTbwn1H0sVpwPMNrxMk32AmzKRiA0+dggJcCXSvdEYTFOay4LEs/sfwbin0ixLbjx3m6ZX7YuuL
	he+mdorjpQ14kRioSRhahVDZbRqQlzD3ykS8mHtYyTEuRzfNTES+53nPNLYkDzk+eGMWPT3lMj5
	VRzU4kWX98PnMJymfJt+KXOBKH0xuzo6p4KTL1eSrRdPAcXE4r+Dbv0XBZdQlnOZHon3If0gtOp
	8Qjg1kiVpJ/hRLM2fAelLtm/vHjd60U4Fhc4ek3wl6e0+uJv3g==
X-Google-Smtp-Source: AGHT+IHxZ/1XB0XTooTy20gF2J6qp6ErSqlur+nLfC1cS2f0htQwqZP27n2jGLSGOe9wQ3S48YkxgzPbfK7mTrgqi24=
X-Received: by 2002:a17:902:c40d:b0:290:94ed:1841 with SMTP id
 d9443c01a7336-294cb51b8d8mr48988685ad.41.1761659151099; Tue, 28 Oct 2025
 06:45:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251027183508.963233542@linuxfoundation.org>
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 28 Oct 2025 19:15:37 +0530
X-Gm-Features: AWmQ_bn3RK4ifsADAyfT2YCeNyByQ1FJjNTINqrzgb0emwEGcjVldmM9i7J5uE8
Message-ID: <CA+G9fYsOAFpZfQ37Y=En+PesV+Voa80CQgkU_Y4y2Tpta4+2Wg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/224] 5.4.301-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Oct 2025 at 00:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.301 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.301-rc1.gz
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
* kernel: 5.4.300-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: e1a2ff52265e4d85abb275e2930b92c821a3dd19
* git describe: v5.4.299-82-ge1a2ff52265e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
99-82-ge1a2ff52265e

## Test Regressions (compared to v5.4.297-70-gf858bf548429)

## Metric Regressions (compared to v5.4.297-70-gf858bf548429)

## Test Fixes (compared to v5.4.297-70-gf858bf548429)

## Metric Fixes (compared to v5.4.297-70-gf858bf548429)

## Test result summary
total: 43391, pass: 32354, fail: 2994, skip: 7851, xfail: 192

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 33 total, 31 passed, 2 failed
* i386: 20 total, 14 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 9 total, 3 passed, 6 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 29 total, 29 passed, 0 failed

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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
