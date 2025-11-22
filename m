Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D25C28488D
	for <patches@lists.linux.dev>; Sat, 22 Nov 2025 04:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763787085; cv=none; b=m4JhaBV3zrMLSbGuica9m10/x8l9BPRDoaMR69VUAw/lakmU6jJ4xUcf6jZvDauSxwNkgo11wxdN3/e/CAFAAD0/YoQmfDno3jM+elg7OpWBswP8f3dLa4lGvrF3h9hIVKcl8PoPL/gvXzvAQV2sAg6TzihXn5y23/XblGM4PGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763787085; c=relaxed/simple;
	bh=TUEua0/wAoOAjKQrGKFZvy18WHinTe1oqQGXmuicXKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GLu2GQBB/eSE02++CKqkwYOxjI/EqUgt9WgWzdoRn+8S8+/zcyaE6eDYxAx4v+HFG9WlH2MGJf/G9CsfgIceKNgRnBxvVBRFMhgmN/HWRdUqeALNjH7HGdcNqaHW7TdYexZP/q6N1pobCFsuT7F/0RxSKuSjPAQcWU+pNNubCIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FC8yFri5; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FC8yFri5"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2a45877bd5eso3839549eec.0
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 20:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763787082; x=1764391882; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=asI63flty4mvoIqkQyV2Ch4O/PBYBX7tCTS9ueMUh2E=;
        b=FC8yFri5FamW9Uh7Z9yYdYry+hNDqK4NpZoe4NvZZf13Hq8pNdgGjc1g4lq/5ijNB2
         yysY/bLF4EEiA4H4pjpN2v22BoCyFvQGZ0XwXYT6Kp1c6iMszkrgsxOl1fBmlX1INC4/
         e8kzSRQUpNWPrn5FNXAh8cDsGDZYCsWej3iUa91gAAxSYvqrHo7xAFx+FXhxJxhWonA3
         AwZhVk2x0Q0B13LtcFw2OEWkFOCavy+cT7Meh7YAA8Xx2C8EXA8HJtREpDTaeMqcRiQf
         VYYTWCWYVRC7gbHFMEKxHLRhzvQhuwWVd2BTtp15BpnPj57dGw523vVf3bpEI/f11DPQ
         cq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763787082; x=1764391882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=asI63flty4mvoIqkQyV2Ch4O/PBYBX7tCTS9ueMUh2E=;
        b=RDXo+ajmIGFFVFFRAKZ3TG1aMFqVjzMaQ3knnF3fR1ENDGEQjtHV3Q6SMQqMMyz3zW
         LvQVdFdJVrmVfjngeeT00flFG6i+DKrllvrsSPPA+x3yZL2ZMvzM+VU2nb5tZ3c8jnyp
         LfGHWcx4BqyjkdFAtcZO4/SlYW+9H2OdRzGrwd0BHxCdohHuK8Rj3SE3udN4oCCfwr1p
         doE94AsRzJcWsKjUUPt4W6JtcFfECRXQe/LNs37BClbelo7nP/ootojo1Kjyd6XXLlNx
         qbbtBLCV/j3/QSuNYgbOTvZdNIV6FMWXjNzoHtvwUoRJ3nxL+ZcOR1IyMTaVV0NT4lHb
         oANA==
X-Forwarded-Encrypted: i=1; AJvYcCVkwzIuCZ1IczHqPMBXI36GrxN/8HQa+W41o5ZVCoHilRfM2LwwTMm1fWYMpfx3wI1vkfXZD2cI@lists.linux.dev
X-Gm-Message-State: AOJu0YwbjkZGLCXDIK63wySlFRPOCcQdBhPKvuK2caCseOak1db6rX78
	KFWi+CDM041/NPKUdYbb76NsXZ/8JepIqQCHe7HiHsfMw3/hSjqzRu1xMOebxQUEzM0RgQF8hoY
	PZPxI5G9Rc2jGtOHnl17o/ZR3Yi5gOFbAT/V3P0/Ksg==
X-Gm-Gg: ASbGncsCVc7zWviwdP65y6G/PQQNgsOzdLQMWHADHZbv+SrsaWL4y6jNAlEn38aneGq
	ugR1R4KBHtB+dd74Tu7/PMxvCP5iFYSbtiJUuIa/NSBRAORkauXXm8oggFd6Ya4rFMztanCkTX6
	gmHB4BysAcH35AIBVTwUT8yGorYphFJ0pfmJawWmn0r5IekyjEpM44ZUBZpiHLiXp1EMDZh1rPj
	i9XSgmFjYZn5CM0OT5qr8803nmmwSgZ1eRZyrfdjOIaCu5K+pwYv2qL4yaX1lAJoSA5JKDtCnOi
	WqVlngiV4caPlU/2VgAl+z46y2l3
X-Google-Smtp-Source: AGHT+IHwmVvlAyIIo+U94q9DXDgPlcT96xbKFJ78wizY3cIfoXa0JvtGu4A1hwwjgcpTk3Cfc1Utcro6JanCnEenBbU=
X-Received: by 2002:a05:7300:a2ca:b0:2a6:a306:efdb with SMTP id
 5a478bee46e88-2a718576e14mr2236705eec.3.1763787082112; Fri, 21 Nov 2025
 20:51:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121130230.985163914@linuxfoundation.org>
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 22 Nov 2025 10:21:10 +0530
X-Gm-Features: AWmQ_bl9aP_dXviGSF9smM5QiMhfrYH0QvLhLHd01n5dELXq-9_2NCdrAo_s_JM
Message-ID: <CA+G9fYt1RAW++XEOaFMSd-ieMJR2Ltj-6MgeRGV05SmTYBmavg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/529] 6.6.117-rc1 review
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

On Fri, 21 Nov 2025 at 19:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.117 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.117-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.117-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 69eeb522a1e229275a2a2a4ac61032a65b6785c7
* git describe: v6.6.115-563-g69eeb522a1e2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
15-563-g69eeb522a1e2

## Test Regressions (compared to v6.6.115-33-g2c2875b5e101)

## Metric Regressions (compared to v6.6.115-33-g2c2875b5e101)

## Test Fixes (compared to v6.6.115-33-g2c2875b5e101)

## Metric Fixes (compared to v6.6.115-33-g2c2875b5e101)

## Test result summary
total: 101411, pass: 85745, fail: 2822, skip: 12615, xfail: 229

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 128 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 14 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 34 passed, 3 failed

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
* kselftest-mm
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
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
