Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2BA1E5707
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 19:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729538433; cv=none; b=qA2B5WTB08GgD0NNxO7RKjWG6oJaUKgzifJm1RIiKhWK7JAHS95esB3ueWItcfLVKxEt/Hlwq95JwX5qC7tu4XWxN/owZn5trQ596N/lZnqNRhkvSww1bxaHeYoeifUsp+fiRcWDIzl136c1CPk/h5qCHhVhUr/Pb/1sW9h7vjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729538433; c=relaxed/simple;
	bh=X+BqB4m3qGiikLAH4c0bPLfQQ1ZnoUYOSeFkn0/BV1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BBsxTGd64FrV/85z18EnUJaPBsn82xRULXhubY1W8bH4XaZXWLXL/WtpDBjDClkv5TnTCiBblYKchp0CrdHBhRMgvlMOqcWxH5SQeM+/LjoXweau8FiuFVt+vwlP/RR6Eqew0Y4mQ89FGJ4nwtwU/7W1D3gyYDwFwDYOfvI9Clo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RCHzt3Dp; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RCHzt3Dp"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-84fc1a5e65bso1426446241.2
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 12:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729538430; x=1730143230; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vert6VuWRQoFH6tsezfjZ9Blc9TeqIOBYLRy1ol7FKk=;
        b=RCHzt3Dp+hG07qZMof1NaGlSTdk7ZMh0W7cuDR5MNyTExCiidApNnegt7jjxL1Lvs9
         dP6wTg+Vgk2YU4MJdD60aai8S6Fm3BQwXacpiLBytzruEzJ0HZ3t+2NHNZ06jeb9YN+5
         JwBhPb0nquh/J7W9XPspN9warYubtc9rf8P6FidNiPGl3nFgThXq/E6vc7hs8BIyTiRI
         6S8my7Nk9mWpWgyjCbuwlVrF97mh57e7cKgQiGbAUq4cRDWvi+5GK4wUEhG+fO8buzBd
         uf1kB8jXo/AAXAOzOlVnv0CEtKelftHl8/5b8y7R3PXYGyP2wRuyD/nxk1/8zATTxA+W
         SyLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729538430; x=1730143230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vert6VuWRQoFH6tsezfjZ9Blc9TeqIOBYLRy1ol7FKk=;
        b=VpRmtPQO6Mq7P/m1mhI1DcEIHaTYrTSl6wvCJgcr78x8duQJn4aPOc3XxmepZSme+u
         wepiCu5qrF0msPk7PkiNzYEEiT24uIhUZiBOPRUFHbpll+NY9nmu2LDRuzhQGEJ1vppr
         HgRjlBN2UieFUnnCMvtK+J95hQ3fAfq4EKWvLnLtHrijS+/JNdnO47IdQCNUGQxwHhB5
         Pb5piqliVvQ3Msi5kusxz/jIjg0Hy0xSwN9Z1jHPoNwSjFaOnOsTgaxHXRi3+KPxR0tw
         2pZ13dfgHYCrwK4ncNvJC5GW5L70gXIeJ/o7tA3Ws5g8zMDccza31P7CEqJmZcjlnklp
         +NuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeTLU1MscZUzPM+Sub9MQnc6xSk0qaT0QdA7jWyfM9oUCQR3nbzDTlmUavvYgh3TQQnId0c5Lw@lists.linux.dev
X-Gm-Message-State: AOJu0Ywyni5iUxvgzP/hj1xmc9f/bgHUzw8YandUiBQSNvAzMjLKipn0
	XbWOmr1yihv6+WqsLDRqeIgSOMDU1IN8cj3D/YKGqw2uTKx4ndiWcrhzDSwTIpRUGqMwUyz1oLf
	x63UKMDnar73/L5CCIALdFk8ybc9t8axL8yBU8Q==
X-Google-Smtp-Source: AGHT+IFzrHON7EUJ5b34Xli0Mwpct9YMdi8X2Xx69LaqV+Tdl8QUb43GqBLOD5tk37yRZb6XyiauK7V+SVav5ptOpzY=
X-Received: by 2002:a05:6102:2ac7:b0:48f:df11:5f28 with SMTP id
 ada2fe7eead31-4a5d690eeecmr10795506137.0.1729538429893; Mon, 21 Oct 2024
 12:20:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241021102259.324175287@linuxfoundation.org>
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 22 Oct 2024 00:50:18 +0530
Message-ID: <CA+G9fYvfZEBkAwJ9AMFcfnyMNfqDnce4xk-v6VkKywV3Y7t2qA@mail.gmail.com>
Subject: Re: [PATCH 6.11 000/135] 6.11.5-rc1 review
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

On Mon, 21 Oct 2024 at 15:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.11.5 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.11.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.11.5-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 96563e3507d7fd82e448c6803ed8e07bc6e5ec86
* git describe: v6.11.4-136-g96563e3507d7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11=
.4-136-g96563e3507d7

## Test Regressions (compared to v6.11.3-213-g9e707bd5fc59)

## Metric Regressions (compared to v6.11.3-213-g9e707bd5fc59)

## Test Fixes (compared to v6.11.3-213-g9e707bd5fc59)

## Metric Fixes (compared to v6.11.3-213-g9e707bd5fc59)

## Test result summary
total: 140250, pass: 115901, fail: 1938, skip: 22411, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 131 total, 129 passed, 2 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 18 total, 16 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 35 total, 35 passed, 0 failed

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
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
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
