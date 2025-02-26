Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F7323CE
	for <patches@lists.linux.dev>; Wed, 26 Feb 2025 08:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740559556; cv=none; b=d9Bz4oPJSJ24nTly00l+x+iTxIYucpCpilN7jgGVdok3wIDyftYzcUhM0bImHaitBhlpCxlAf4MjK+quuryMoXesFNN5/QjrHI287sJCoIJJ0MpvrXJtHFHY5Wv31U7J05p7lZh/6aHSshR2eN4t1yGaEcu2tsDZOqgGA3RwfUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740559556; c=relaxed/simple;
	bh=UENyK6nf1sqkzjJ9uKX6c6MBHZH8oAEzlZrBi/B3ayE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p5gq192as5pzqXKHTO1w9ZTXXEA3vR7D4YPZCTTW4vl14itlsrS9DP6MFF3HB3t69ZIjaCV4JZAfsQiW9FUwlE2+ZyBqhBNNSHf9qAgMTicdas/+xiMVgP6vJzpekabPUGZn/TSxQ+rwiaL65f4aQlQxErTctXL/vrYeXSSe1Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Re8KX97e; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Re8KX97e"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-521b1b8cdb6so1756709e0c.2
        for <patches@lists.linux.dev>; Wed, 26 Feb 2025 00:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740559553; x=1741164353; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XaQtfK1ctsYhz+bqcOdbV6RX9cgXfU4dyosRcNQlmSM=;
        b=Re8KX97e6N7MF2466sNkYKLQZu5h7WhHRAsMmVhctJmcM2Gyv5c2IOf/POOm1+kvYT
         UpS0NhxnIbpdoYfJVk6XazBxRARXlAJxAk5Ig69xJXjehmk8Tg5k0V/tBdJyFX0H9i4x
         vgMa3yYc2tW44vqZsV0aaDUSJ4rVl837Ir3XzyLqpeKZ4CmfO16KibhgJEGJvzYa3NBe
         qC49VxYjNHVxVnDMzg1CKSIR5qdfZUms1hXrNzKApRJ3s+hCMbJKlDT/vLS+uqe3fHKS
         IdGPq0JD6r/8jdvXz/AwND6M32EB56GpY8O9cCOqtp0kB/jXeEkJaQhLH7vtpXUp/Jzc
         ffGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740559553; x=1741164353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XaQtfK1ctsYhz+bqcOdbV6RX9cgXfU4dyosRcNQlmSM=;
        b=Uydx91ESQjIP1ul4tfhp36WFJ7ANOe+5o2yjhGGKny6qCQ/hu66oN/PJq8fWKaorck
         XE6+NJbtsEl2YiSVYPQrKl1wxtmyi836JbfDD53kndP5Bzdoff+H/NpKR5wee1gYI7jc
         kmo4y2TA/7WHK4Fd9oMIIsu4smaKieLhQUQb0qwyyIkCSNZ/WGhSXqi6zy4yD4Kb8J1A
         nrG56FN3Hu6CUaK+MPoSP1KjJKHSVKyu82JOlu3FG/jpSL9ZJU2RrCAq9VlcCdQan8t8
         5l6z6Oom1VtDEH3flzWJsuKhDEApZMpOoNwtJ4n+90aZlnPcn7AJzQexaM610T69RF2y
         NSGg==
X-Forwarded-Encrypted: i=1; AJvYcCWFY63AGS7hT9j0lGHk9btBbdkx6QHkgmnbNTA83rbvBZ2c27oSFTEGlxP5oUiarq6PU8fXbybG@lists.linux.dev
X-Gm-Message-State: AOJu0YxO3l51I7gP1p7V3rxFOJFxKTUnGwxEqzbuTHLoJujJCdCIAF/8
	n5gTrYfzGTEjXJZOh5ithvvILR7Q1ahvMg1jfD2PI3z/+1Fv/OB7MAiikZHybmxhzqcRGWns46I
	r0lE5YxB9V698Qv4eaAeKH68rmqfXptqUmI0xhA==
X-Gm-Gg: ASbGncsyD9akivIIQ7D/R8d6jszg9fDz2/zh7Y4FZMPDNvBMqCPQw39AiZghU0F4/1D
	6xtk6YQMLs9o/29ESzltr0WOxQilkrm2nj9nLQd2b+dlBeQX7vTtMlRO15wUJ9MFJsv3fD9wimN
	yeCPnboV8ayFRsaqmsEbltl5xnp/NFJuJlSoOp5VX3
X-Google-Smtp-Source: AGHT+IHlTWHmx/PR+pAg6v0zjV4nAI7mL/7+NhbjnE90ZG7dJ3J/mJSI9AvKQBNoL98EdaRoCDlUqdYVK0tIYP4I298=
X-Received: by 2002:a05:6102:41a2:b0:4af:deaf:f891 with SMTP id
 ada2fe7eead31-4c00ad0bf53mr3858141137.4.1740559553235; Wed, 26 Feb 2025
 00:45:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250225064750.953124108@linuxfoundation.org>
In-Reply-To: <20250225064750.953124108@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 26 Feb 2025 14:15:40 +0530
X-Gm-Features: AQ5f1JrJY6iKijR8inxTrQ5QwIT5PIXgHcc5gyMzNTXahEI-z93knUfSfRHeZtA
Message-ID: <CA+G9fYvH8nowEkm9td-HZi0C67i=uChzHC7BDt6AhQFNGGDJbw@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
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

On Tue, 25 Feb 2025 at 12:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Feb 2025 06:47:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.5-rc2.gz
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
* kernel: 6.13.5-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 1a0f764e17e372bfc20424b8e79ca2594782924c
* git describe: v6.13.3-397-g1a0f764e17e3
* test details:
https://staging.qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/bui=
ld/v6.13.3-397-g1a0f764e17e3/

## Test Regressions (compared to 6.13.4)

## Metric Regressions (compared to 6.13.4)

## Test Fixes (compared to 6.13.4)

## Metric Fixes (compared to 6.13.4)

## Test result summary
total: 125711, pass: 102863, fail: 4064, skip: 18784, xfail: 0

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
