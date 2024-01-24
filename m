Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117931AAD8
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 11:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706095522; cv=none; b=T/fUcWyv+3pwo+Kznc3CLNdXPJOxiGvoIsnF+GBxkEZ50jQOs7zFS+zmfKkLzmdQxbrHv85C88k4gAY+j6oPzPi17AaicNJUWGBsK0ISkxncMq5U/8dqeE23xCZTiGQuBLNe/Z0pjjjcaAQK4PccB0RHNbomYbnO4ID2mWto6p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706095522; c=relaxed/simple;
	bh=Q/fSTePB+3gjdfutjWEwnj0KX3hxqkjjqVpjDkIE8t4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kEdzKZvdUNxebQmVa8LacXllUEVM3uR3SeZ6jOfZW0LFBYDksaXYx6/zCtoat64wYzk05YgwwcNk0Z93IZ6Oy1QYMulFEo5wzr4wMI4xx0kMcD+PuMu77Ef/CdRBxfxUOqUIl4Sj7m16YNyU2kyUQTj8gcpQhHo0J8ETBMO8gKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f6lk1JM3; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f6lk1JM3"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-7d2e022ae0cso1198548241.0
        for <patches@lists.linux.dev>; Wed, 24 Jan 2024 03:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706095520; x=1706700320; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GYsYwsp+NkgyZ5+EVTa7o9fxzZfD4HTv/4C7j2PIB9o=;
        b=f6lk1JM3Ls4x5+P4LTJ/fl16q/0M7hRvOpgH6DI5q6dibYatqVnO4S11np/EMBlqBS
         Rk44PQnppxRVL8TaLnRPdk27xsrzPHlzfKQZWUuQLKCSDd+1f7pybeexUxKrx5uVekZZ
         U+B8CjwY9ySC/ZbrR0XL3a6UGmoLsstsBrp9R3+2/dttTudQxOF75pFgAljZ4xSeyzMM
         FwISJAAlVwBwrY1yXph7M+KD+oUimpu8+O7F3WhxPp7VSxH++B80YFs4uenkzggLuiMz
         UVOJ1+Bc9n3zmhm+O2vV61WyimlIbesNlkAe1uSI/rvEkoAOuuzhNBqwEi1WdlRz3jnT
         zezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706095520; x=1706700320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GYsYwsp+NkgyZ5+EVTa7o9fxzZfD4HTv/4C7j2PIB9o=;
        b=GLNDXPw4sGHMUrt6pF2nOt+fgkp1g7xI9yho62y5ErxpSBdUMGuYoWxi1dFIe59dyy
         vP7MSI4JI8SYjOU+Mj/WQtYZKW78HHoGzC5BEJunBusUwTqkKOMoEKbmTENwlyAgBjJk
         ALb5oCq1BRnz7cHhCqYkDB3vKa+2t2Ba8S3rY4hhQj5UD0HYy67uR25UVKLc39lPNXkS
         9hkSsukcMuIewLb0mHQ4xSkqKeIV+e/Kew/KN3BJVP1R9meHSEp5xSqlXWoWbZ+f6AO3
         z8LJTmhK68yvS0WdK9RBIUe3KvIpKPTI41MqLyElVhquw6Tzw0PVKcoZARC4q1oKiKc5
         1wnA==
X-Gm-Message-State: AOJu0YzPFMnJJ0elVwWpjAGRs1fG6CYj9x+t5wvELxQrJMKz9doXk2/F
	GCXBJ4FWL8F73PoFwOqI4BsE5UzE7Un0vNu4MJSMU2VfXgCSgsmfzBm4gIFcUb+WRjH0s5+yjo9
	Vd26+eZX8R2aD1Lu9xeItlbiVvx0WyZGloA3ZfQ==
X-Google-Smtp-Source: AGHT+IH+zPW1kXjwOmU6aKTrwoCCH2LCyOpmcVd4eYPgVGnBRq7xPsRdJYiffRebfw9EjAW6iZZo3MVPFbf5Bg7cw4I=
X-Received: by 2002:a1f:7c88:0:b0:4bd:4184:43c7 with SMTP id
 x130-20020a1f7c88000000b004bd418443c7mr858398vkc.29.1706095519744; Wed, 24
 Jan 2024 03:25:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240122235732.009174833@linuxfoundation.org>
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 24 Jan 2024 16:55:08 +0530
Message-ID: <CA+G9fYsHg1GwoT0v+cTVymvxRUFAVexpTrVomRG2eHhiS2BLqA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/286] 5.10.209-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Jan 2024 at 06:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.209 release.
> There are 286 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.209-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.209-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 3c264a5f70c74960386987716dab9e042db1689b
* git describe: v5.10.208-287-g3c264a5f70c7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.208-287-g3c264a5f70c7

## Test Regressions (compared to v5.10.208)

## Metric Regressions (compared to v5.10.208)

## Test Fixes (compared to v5.10.208)

## Metric Fixes (compared to v5.10.208)

## Test result summary
total: 97987, pass: 74379, fail: 4011, skip: 19507, xfail: 90

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 117 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 25 total, 25 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timens
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
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
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
