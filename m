Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C78281AA7
	for <patches@lists.linux.dev>; Fri, 24 May 2024 08:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716538393; cv=none; b=oV0cjkGcmVYpsakUUivjkLuiGdlEf/Z2kSQ+A6krA+i6vtVOp62RnBGnlHVTsW3wRuJYKXxAWpdpUYO2OLG5zU9wrY/EwyjYhqnK5aOPpz48aTg1UjlGwArFEsiBvlixCIJfGmw2TEgCOIyLq8J7HTVMQMVibZJMAzpa/Ym00cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716538393; c=relaxed/simple;
	bh=iDZO2JEbL9dapjSXJbuqTSFdvFd4rrdn5qoCA+BDAFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R+lEcsshkiXDkgYo1anvsHgw+4JPv1YelcoPsOcwAPQh13NsQVTsIh/R8rKk34Ga3smxz31Yyw4tqTQS3gFrBHsVNnXpfBykVhJI4AGpdLwRiiaOre9UXGpGJUoW00d7zbj7bs/6rRvnWAEwpZBQs3GMglPhGGqNTZV+TQqA6mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kXPFcnnU; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kXPFcnnU"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-62a08271bf8so6651447b3.1
        for <patches@lists.linux.dev>; Fri, 24 May 2024 01:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1716538391; x=1717143191; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C/vZiBjXa6s1sOVi/WrPbknmQ7jkRff7AyHNLyA3ytY=;
        b=kXPFcnnUuT3nj2dUJdFQhISE2EGSUAw9773WufJbD+hYCl2bApqtheQGXDqSWGcIVY
         hNAYFa00TJDPg6tzOHWZv0cQSCyJa8vTHE8m5FksLTaFbaRdvQ1dRd4GyMzxtvzSc7YT
         +clTHhbF4EFa/pJft5tbBM7e4aAfKtpDOkZRueIMAu8mKly5SmAnqcnwfgk0sowLNx+w
         FxAoX2lMBY7waFnCW6G/d8QdJ1EVflUbBz1BmU5thnj8LObiKEjxCEPBQ4NDSUtzdOTi
         7GN1KeYBywh1GUekAfMtKMNXTAkK9ox2wtr2ytaL4AHDYOpptkJTEYyYWnyAcWsGXtbD
         EK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716538391; x=1717143191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C/vZiBjXa6s1sOVi/WrPbknmQ7jkRff7AyHNLyA3ytY=;
        b=jH6U8zJSdBi3b2ULN1ZEbo8ZsDBh4l9S/65WugTeGFB+YBkCxMETOdy6cfavySetrV
         XIf8I0f3gP/D7u85Bf1ccQ25vX4oJjx0gtlH3lGWI0RW9WSNSVfkx7HN6GIJpuyxvpvX
         +N9Yvfco2+3BEDiygOKdC4UopTpvlmYKnlBKkOStsyRCswnYQ2ALszp5upXSPSjNA5AX
         M0aFV8XOxBMQx8+NXpSOQC/kZuDj3i3jGRA4ve6RyudxkqzXFHkgwCwW6MIJ21tFAN4K
         lifSEjJHXl4BDXoKrQr54M9s4r0YwUgT9ZDY7RlK5u6O/IyAuMMul7vG4Lj7ReVPNJLn
         S3Vw==
X-Forwarded-Encrypted: i=1; AJvYcCWT0qKQIdHiAvBk7R1FSYTeD/Dm/SkVe+tdT8b0VjJhZRj7v47+g7YzdR1fU0G72hsXcAL5kr5HI/BC3HSad1d4TInPSi0Abw==
X-Gm-Message-State: AOJu0YzWA29IN6mqKUOiRuCtzdM+v3yI7bqg2jRn/FRPXSNXHK1P+94h
	QzqZOq1j8d2b3b0MiecurghwZmQAay9O5U/jfKUD8BXwxxi/DNUl7hGwrvvoPv8Ywd0rvGsCcxB
	XpP646VQ07TpnD9ct14czt7KJk3JSa+bho3F9Yg==
X-Google-Smtp-Source: AGHT+IFCajKrEg1yHLorioSNG5XEJQo8CoJG16SVt9J/QKpooT2g4jaTIDYwb+RVF+olXqUkqj7x97n5zEGdlOCGaeU=
X-Received: by 2002:a81:9201:0:b0:620:33dc:8357 with SMTP id
 00721157ae682-62a08d7eedbmr15040307b3.18.1716538391212; Fri, 24 May 2024
 01:13:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240523130332.496202557@linuxfoundation.org>
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 24 May 2024 10:13:00 +0200
Message-ID: <CADYN=9K9tbiLPSx9Xg+dMA1WsZNj4Z2cLT9LLYQZn+ckjJzu7Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/45] 6.1.92-rc1 review
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

On Thu, 23 May 2024 at 15:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.92 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.92-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build Summary
* arc: 4 total, 4 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
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
* kselftest-kvm
* kselftest-lib
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
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
