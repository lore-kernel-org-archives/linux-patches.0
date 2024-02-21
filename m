Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2863C3F9C8
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 11:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708516025; cv=none; b=K1QYRxyU3A1GAWmoUmbXWGbB4tnN4gsZTxgK41LsP6NSlBZ9XpiSX8HWlX5KX8nrzKWsBRb89W0Jlw+MzCb5WsjRP0+DFxAVpt+PJw6i7ZzTok9HgacBwEqFZBriuzsCmlNsl2qJGm8cOMa4hNEg3/l2wDir+z5CZol03yxhVV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708516025; c=relaxed/simple;
	bh=FWdMoKjc5MLpmg8HeWz4u6EQMpgm5+6yYsUxzfXOOyM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BPdJAXFjeCtcXNGQ1CE68xc363GaBCIMvqtdoPAOFVD1KG42r18thvNNPTfQ9YkzBbvT6Nt1Wn40LcJZriNQTBUWSCwSxGY3kg2VDLDWrZiqp42OhBp4CEYGnXTktqtECfg2uj9TG1V5U5qZ+BJt2dWHzJo5wW8gWhxm5PIsE7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kQ3RLLu5; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kQ3RLLu5"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-7d2e1a0337bso3369141241.3
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 03:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708516023; x=1709120823; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hNZUljjF/JkBMt+TrHAzZ5pIFVJVqIo7NOkfA+R583U=;
        b=kQ3RLLu5d6hB0loXbNyg9OjxZ2rMfAcXKGM5Yqs4wWXTotId4FSYcQ9azPpDKJyWZ+
         3MHBscDoUxAUbOPoxik6A4326WpoAFXj08Hj1lEgea5XnypodDon/XEcE5mjWFEfMPm4
         /tjiZ71DARfhTcGLi+ZF8M3eSyzzXvcxP3yAFxJ/Z7PjGzR0yX9TsV1WBPTRbDcS7Fqv
         5f7YZP77F3YrxZ50TquPPxY0/WqUw8AeT8VcGhDMdESDK32YsTaeCHAXXqL1y4Zow0wa
         55wyg13Yjw6JZ0DtwgXF5P4pmn0Gnk1AluhKLVqFxDa9SRochOY2Sj2CNX334ZgZ+b+5
         M1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708516023; x=1709120823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hNZUljjF/JkBMt+TrHAzZ5pIFVJVqIo7NOkfA+R583U=;
        b=MBwQdgbbJE4QOqIQZs1UzSeI6TllhM4lldONRdZedteDPjSjpn64PRbtp1mkdc2hh0
         2GwfdkV6t66mlIH8aME57qtNZPHnOprp3KNcofn3vcyHn+Bl8p2gNtfZcn6RnIYjzqb/
         UyjBAqUqE/9Gqd9UXNYiJQwZwq8tfV1Om7lK1VSa4mDQyUiWggPl+SVJgLaGA3WHsd49
         69xX6rioPdWynJN8nAHwU55ufQsflAHYydnO4xCR9sSYHffOpFa0XdFsJ4uMmxnYczPD
         oRlcM6sithZSd8P6288N919SxjoCjq5CSU0BSnbk4rIJwbZizsRKC+ZxNJZ1bD2AI8xz
         N3qw==
X-Forwarded-Encrypted: i=1; AJvYcCUfIaz/+iXdaqOPnJqvEHpz9gGbbIjNE7EwFTa0EfHQVkB3UpAm/xdBMm71geqtE43Y66QUXl6ISRXYWmEiqJZ3k12eoWdnww==
X-Gm-Message-State: AOJu0YxQ1lq3j1j3QQcjKr+rovSMuuZqrLZqdQcTDJ+hKfKAGK3zSMNi
	0XtZxR5QFpGYFPaPVsWBHKJk84ZKhRPdFE6xbCX7hkDbdJztzxaQAD/9eIfREX6nhIZdd8aobXe
	NiFjOWCY6a14MkzxjAfUqiD2S6WNSbLVlVvHbyQ==
X-Google-Smtp-Source: AGHT+IHnD6ut4mdFu8GUqGoXoBNgpLaiZjv3AJvoUkNOuS/1MfekQhPQjlPllCV+S7OFskDQZnK7xdNpiymrDonZ2fE=
X-Received: by 2002:a1f:dd81:0:b0:4c9:98f8:83cc with SMTP id
 u123-20020a1fdd81000000b004c998f883ccmr8131187vkg.3.1708516022841; Wed, 21
 Feb 2024 03:47:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220205633.096363225@linuxfoundation.org>
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 21 Feb 2024 17:16:51 +0530
Message-ID: <CA+G9fYt6RVV=nySYQfk1XQDWjLdimcaKUX5qWTFOV6=+0H0CEw@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/309] 6.7.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Feb 2024 at 02:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.7.6 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 Feb 2024 20:55:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.7.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.7.6-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.7.y
* git commit: c40c992a3e2ef2cd425dd1628140a318e9ec9b23
* git describe: v6.7.4-439-gc40c992a3e2e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.7.y/build/v6.7.4=
-439-gc40c992a3e2e

## Test Regressions (compared to v6.7.4)

## Metric Regressions (compared to v6.7.4)

## Test Fixes (compared to v6.7.4)

## Metric Fixes (compared to v6.7.4)

## Test result summary
total: 252994, pass: 220458, fail: 2893, skip: 29351, xfail: 292

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 143 passed, 2 failed
* arm64: 51 total, 50 passed, 1 failed
* i386: 41 total, 40 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 45 passed, 1 failed

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
* kselftest-kvm
* kselftest-lib
* kselftest-membarrier
* kselftest-memory-hotplug
* kselftest-mincore
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
* kselftest-vm
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
* ltp-fsx
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
