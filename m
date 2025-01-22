Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48A1212B30
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 12:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737547590; cv=none; b=sw5pBPFZjhWsOXG94Z2jQEgiBLtvEzK/DILWrGRJnmfavx6BpXjYwXrmSOZbVNx9RHJc3gT2BchhjpyhNxbSiAejqynnef8VNWkesTRK4Mut5udd8iW+Z/IE2vjrbr3spuvtXMofbQREhkQb5mstB81/RpECxiACxTsNZtNj6NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737547590; c=relaxed/simple;
	bh=WCNAfkguun3M0jumq+PaEvAdNAQXoOs/1O+m+YxWaZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OrztZkkEYixAgCzk/Ds76wv77gdJIEzdR8t7DKcHCQEhNYjzQHkWyl3etlRCt+GMH5OBD2wT4e4Orb6N4ENtzWq0RQR53yEIU9ZV6QLniAxeF7byeuXYlyzstoDI+ahHGP0wBNxEGBcgKhw+qX1JuaF3W+ppXzjW+/24cSzJ3VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=syca1F+z; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="syca1F+z"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-51cccafb073so2248701e0c.1
        for <patches@lists.linux.dev>; Wed, 22 Jan 2025 04:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737547587; x=1738152387; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dHk7NAaxf+oYEbpjS4HQTJJQPTECTeYKL688RmbnOtY=;
        b=syca1F+z3jYTVN+8gPM/CmKW9M3OXgIZbpRlHoV4FZN+yJL+p1vjpr9pdJm5zJPbP9
         YfVN27Bzqgjd8kJ2IeuFPOTHM2XUHD7ZX5Pw+KPQ2mFe1A5+GNDHlTMt4cSOYYSf7Xpu
         H+47HAfGcIeCoryrCxcQVUHX8rv9gz+LjQ5OmNh65EDwg7RJr5MgE1wu/27GxtI/UTKw
         IKNPaePkgInRw8om7NANoHvU4N6zWKwlYegdo4q6dbCKV13lhgoZeVd9c7qmT+v8dMfa
         wGt5GgO2SiibRAJ2bBLnjAtHkwQcO6naIu4KXmOzbRoL15DQX/VVUUVrxYjzurYUIl6u
         hy0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737547587; x=1738152387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dHk7NAaxf+oYEbpjS4HQTJJQPTECTeYKL688RmbnOtY=;
        b=MCm7Bu8yl4GSVJK77jb7ZsnHgH3Mk0SZm+XYxYbsFLTHhqJTVwTsX1i3WNtevYl29F
         UjB6Nx5SJRknJtqs/0wOsBj0Yk7cFDmiKs2i8Wti3MpDJuR8goyhshafZ8Ni1KAacSRV
         WtfsIT0/U5QLqXQSZF6rAOwq+p00Y4Ch4Qo8YmQvy+g256h76uLJy47t9qGCvwAnTs8g
         I6Ojexe9qIoYBNBP3pCkGIvT2RSQhYR6BGcb3OVFQ3kqCrzKYG5FrJjjGWIJkPBCNB3h
         Q2Njnh4RN15TSgO354HANv3WH90DTYoSqjnJzspOgFUK60OhVKgISyeAvPZ7zDoynrO3
         EraQ==
X-Forwarded-Encrypted: i=1; AJvYcCWV3BOLaI4b06P4bBuc3ronkAScfqXzqyC06hVHzy2jE0wSJZ7Qe4rrBUM1b7WEqvQHry6mHAFM@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+A5gXPl0Q8nIHt0KpE0uXJ2oUyZrQi6jPKBFfXJTkaNTyg1yo
	7QyrDs3HK3/o2lvrhEHTeD1RShQhW3+4WZRuDL80HegjstaX393+xX3JZ96oe10+wcwK4jZlMPq
	axhNeut9cGapmUho0gJyTS/4PAfsafEwB6nn2cg==
X-Gm-Gg: ASbGncvQzFFFdpplggIR5JvPLa9dN7URsTSWtESL1YHJV6LRw00K9MkjYcSyPb9+sRS
	qRgLV3Iq5jpU7GXGVv1I8ukt2ngG7dxbDarQACnLmL7lFf/Mt6ZxLpQKlYPpzP1uYsKpufqPJsX
	ZzoifZhpiWhg==
X-Google-Smtp-Source: AGHT+IHzpAWnMUS264HCJunu/dak/42/IkL0+dKu4p5++YpVDJ0kSAmxUVpOud7wMUU706HbIDdRDxy8ENHJL2XPOjs=
X-Received: by 2002:a05:6122:d87:b0:516:2d4e:4493 with SMTP id
 71dfb90a1353d-51d51b77f17mr13625599e0c.1.1737547587074; Wed, 22 Jan 2025
 04:06:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250121174523.429119852@linuxfoundation.org>
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 22 Jan 2025 17:36:15 +0530
X-Gm-Features: AWEUYZnRLDlTPlW6xfmSjYXS8mferD-ti_06kwJgELSii21yl2Eb8b7oQ5OxO4Y
Message-ID: <CA+G9fYsDRXLsE9KnxDZ4tNKfoBdqozOZfEkVo5b2CZaeDD606w@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/72] 6.6.74-rc1 review
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

On Tue, 21 Jan 2025 at 23:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.74 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.74-rc1.gz
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
* kernel: 6.6.74-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 429148729681ff93db022c19a17ce00dff9c04f9
* git describe: v6.6.73-73-g429148729681
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.7=
3-73-g429148729681

## Test Regressions (compared to v6.6.71-130-g6a7137c98fe3)

## Metric Regressions (compared to v6.6.71-130-g6a7137c98fe3)

## Test Fixes (compared to v6.6.71-130-g6a7137c98fe3)

## Metric Fixes (compared to v6.6.71-130-g6a7137c98fe3)

## Test result summary
total: 101573, pass: 80919, fail: 3206, skip: 16985, xfail: 463

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 46 total, 44 passed, 2 failed
* i386: 31 total, 28 passed, 3 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 32 passed, 4 failed
* riscv: 23 total, 22 passed, 1 failed
* s390: 18 total, 14 passed, 4 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 38 total, 37 passed, 1 failed

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
