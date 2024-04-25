Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC9C8172E
	for <patches@lists.linux.dev>; Thu, 25 Apr 2024 09:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714035804; cv=none; b=s3k6XWVXIo9AMLgs44G9rhTLOzaXJWZN6eaQ00mH3Ex1H159VNOu6TW09WVrDvNPPm79qEEJGOO4qB+eXT7MAXh2D6RUjY1IscGF/kac55FFQU0HpzLqPbBDbr85RV1pnczbTUyy3cr0jEl4YiP8IkV0lyyHL3JBRzqlkfyRsdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714035804; c=relaxed/simple;
	bh=ZUPmUsp4FbU+mE+eCQMvT+H6XdOKmyafB6yW8V9CCMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cSCO6ZHOp/5CQNfIc/KQ/TazroEohzEm9ANIqZGR+osMaYrYmiuUyuMLysgGpdnN8Z1Z3yxGVsNJDYpffbTMfcSO3C4UIcb2WdGTDFXda9vXD46VrjrQFeopUmuIJ7zVqNdshi6jEl5juKAriH2c7/C/4cyqS+9st2oVUStH0zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=riOx7g+Z; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="riOx7g+Z"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-479dbcdba2dso326704137.3
        for <patches@lists.linux.dev>; Thu, 25 Apr 2024 02:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714035801; x=1714640601; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KgeSMNzCtPW9pTGGecqbIsVVTmp3VeZQK6Zv4GNnC0U=;
        b=riOx7g+ZYGk4t+hlc5QQk2Dd8dDgmFrxVAUB1oC4alYSdUKrtcdjfDM9QIFMRGVxUZ
         T1XyTyua1DrsIojiNK5nVSR3/+1vaDFCDzvVwIzChK4tqmSYMcUDFHZ1nzaUgaPjCD4C
         snNxqDhEO+0WDsr9JycdZtwW3mVzUjUW9JApVS+wUfeuYM9tlbfE1uhldyE/tW3NoByR
         ObrmLwDfn0871dWbbszz+aHKnvZ0HwZmaGujU21N15G75UorNuQqUnAc1L+0jBopEhfq
         dzmg8nnkMmzvst9wp12gwvfFgndZD3fxAbgwgWi+ZdLzlS40dxdRnYZkVZrdNZT376Rr
         CVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714035801; x=1714640601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KgeSMNzCtPW9pTGGecqbIsVVTmp3VeZQK6Zv4GNnC0U=;
        b=ku/+UpEztM6eaHrPVxGoN5p3PShwCwUpr7PjArbIE5L5RZjnRb9cAl4kphchP0hjea
         NvyWPh3ccKiG7JPhaHjqQbkttwCnrc0JgaPf9s6QDz2YdLcRE4w5U+dpf/JoX5jU4t+n
         XeSWVpunzUeaGKoD64Ho6C2dv0h5HjxgYq7cLwUcarEbWk+ecaDVkLGg7BnTdK0DeCWw
         94nNs/0f3XR1u+COD/zouFxHK+AtPiVUjV1NepIna9ArkqiRZeVVjARJ73SOnJov7QcH
         M1tFK5GXsCnNJLQgW8JkSeKb7VeccBperc5nt7e8Sqsasq8lyS6xs7MsE+fvw2QLGKch
         NUMA==
X-Forwarded-Encrypted: i=1; AJvYcCWa957s0MZGKEW27EFYyf8jJ+yE1Ukxeji2vc5qtpvQTP8SRvSBtyJ6Dz+ZMFQxTBRFg0HkTBFJqiaSMyuwofTago+BjPDpIA==
X-Gm-Message-State: AOJu0YyK40GRHaAihHUVVKxqPGjOttxZgEneKXuwBddOaOpNuTU0iGnY
	r2KS9OdXSDd2OGssHA4mCAoxdwTR7kizIEG+lIV6alV0htWz+Lkeb+4yWarNc/6N+Rh9BWc7zo1
	Pfw38C0RBfUUBM5AXpSSTXOiVWa8kxYLW8IoDJg==
X-Google-Smtp-Source: AGHT+IFjLCdIePc0CRV76JvXKRpM63ZIEp7nUatMo8eLmOh0CUs5HbI9E75XAUQLnSKETrYu3yLo6Tv4MXgtQvstKUc=
X-Received: by 2002:a67:f98f:0:b0:47c:14eb:5fdd with SMTP id
 b15-20020a67f98f000000b0047c14eb5fddmr3400496vsq.29.1714035801265; Thu, 25
 Apr 2024 02:03:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423213855.696477232@linuxfoundation.org>
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 25 Apr 2024 14:33:09 +0530
Message-ID: <CA+G9fYu+x6HHNQUEf=KCpuCbLYce8BYegoVCoppkZOnsbJxRMg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/158] 6.6.29-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Apr 2024 at 03:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.29 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.29-rc1.gz
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
* kernel: 6.6.29-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 73d4a5d15a314d4e0dee024e089d765001c1ce71
* git describe: v6.6.28-159-g73d4a5d15a31
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.2=
8-159-g73d4a5d15a31

## Test Regressions (compared to v6.6.27)

## Metric Regressions (compared to v6.6.27)

## Test Fixes (compared to v6.6.27)

## Metric Fixes (compared to v6.6.27)

## Test result summary
total: 161084, pass: 140552, fail: 2102, skip: 18269, xfail: 161

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 126 total, 126 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 9 total, 9 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
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
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
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
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
