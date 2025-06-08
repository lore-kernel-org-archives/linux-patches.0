Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8FC1F1537
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 06:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749364886; cv=none; b=RC0DMTLSOIs+Wo0Hh0AqWGcO/4LUDFrUa5KIG24ZRJzn8iESFN3vaHzwlpJZi27e9XJll24Z8LHo8VoxbhTgU9gqKFi/ujYavEZJ2Q5OamZynqkDTKQwYB+3A26GM6exHm3Y11IouDEmBuVxZCSJnjbUBrknGdulRsGqiyeJSqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749364886; c=relaxed/simple;
	bh=cXHevK/ajj4mr4JnqEVggiQfI4w+UzwLggNOaT079ds=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ApjLhNwp7ZkFD29kpYE1MS3759fV8cyHCHBVLdIch2i65Ez9+/QWMXYA+gY0YjFrhRpvqISUx22jBdud+9t2zIpNllX/4TkR84nEFhbohPcWzjiFRUKCoMUcCIhAzgQHshdcgWErMfhrrxDVL5YjYMNUPKfEnYjvNqIGXGyWHao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TXKTw2gS; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TXKTw2gS"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-530e4ba1032so523279e0c.3
        for <patches@lists.linux.dev>; Sat, 07 Jun 2025 23:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749364884; x=1749969684; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OWp66g6XnahKQ1kFtBfhoQLOuAaU5itfCC1skHGxrWg=;
        b=TXKTw2gSnybfnr9FsGoQzo//iVbdDYWME9e59tK3i2lQE57O7qoyr80R3tvxbEshsc
         dJsIcuu4hSUT41ikW6TWNOER7Ocio4dEfAJA9PE8HJoDD6+fe3iEOf7u5551Ox5A6iCq
         HReHaDVRP33AZ3cGILLXXs8kZFG7lvVhy4mXegCLboU3aYzbfVhlZpdL7HIh7VKbyCux
         JjB8OGeDnhlhdAcmxVFdTAbasU1VDW9ttHn2MCr4DqA/LntBlzlHBrPZBcIK6o0iPrU3
         6Ud4wY1xPDWvMgCsF178IeXveZOKiHB53CZj87npP9RyvfAn6gt9ezHTI4IHHXT35HIj
         zfmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749364884; x=1749969684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OWp66g6XnahKQ1kFtBfhoQLOuAaU5itfCC1skHGxrWg=;
        b=C3SI2CrDzyEGBgbuzCq+0pnPlbq+tz5anpyUtYz8dQavDU4ORhvkF2IxcHddsd94lY
         2mEK1FpCHmdmvyyBqZ6tQBZIlvs2GFPN7LmWdTEsCTSeRP2zSqqGSRIWdlFNjDIQlkwd
         pE3ibdP0CxQWDBqlaRVINbGtsCGJnnFonaxkiCSSKVjzuvZDF1Z4xtPGvzq/1h0R8PUd
         mPV8k0D7QZ4v77q/z9RS8DXKW+3zqivLeqVOvKxlcfG/YUxx9oIIFwHWz/LaqyyJT1nn
         Wa1Sq8wFTQyFf7tiaoLn+JnPvoG7aTvDpWPbc3SHKOyx+MXLku9TKFatllD9gCOJKcde
         XJ7A==
X-Forwarded-Encrypted: i=1; AJvYcCVd0J2GI0gxAxailjNlC+WxwUUlRNF78kqWa1nHEM+PLdD84mnCCdGz4XqoBxelBGjEkTRRi7Sk@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8ycFDfiZskOFMsLLFNZenDpihf5QLBVfbS9lXqXS88MfLoHSe
	bKUpH21TzERoMY99EzT8SWsi0pNicOxk9TcBWBbh9PqJDB6y5OW5+els5TA5QhVEXvYMdC8QcL/
	ux09PsTPhnwMfSUaIqe6BJW39J6laPL7U88F9rC4XVA==
X-Gm-Gg: ASbGncuFBGU/DSlCnTUY8NN33ircL3KRQzmhteYpOFCDlRK9qUZzgMmAJnsP0I4Uq5W
	txmyZyn7boeTZwTtuAj0MUNoKRk5A6mWscVwnRxaCXP/CjNCnAhvf5w4HXHPNOnF8Ns5vus7Sm4
	PjebP55vZxgYqEYaaTI1wPGX9m4dmGb6YHlccMzwWtVldiVlgIrnE1wUvfyFA0neMYhg==
X-Google-Smtp-Source: AGHT+IFOKDB/terG23eiO55r5zzzHyXTp9etD1qhfgoM4E3JRZzcfdv2fw7BXZF0LrrfUQXe0aHjYIKVWPr5xmSUpk0=
X-Received: by 2002:a05:6122:800b:10b0:52c:44a6:4801 with SMTP id
 71dfb90a1353d-530e45c3597mr4823131e0c.0.1749364883827; Sat, 07 Jun 2025
 23:41:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250607100717.910797456@linuxfoundation.org>
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 8 Jun 2025 12:11:12 +0530
X-Gm-Features: AX0GCFtNto2E0xHBg-g3bevE9-6Wg9W4bXyud4ke-3IqAefNOa9zs31uP7gGpBo
Message-ID: <CA+G9fYuw=+hcXhK4WBWxkMckk+u6hD_3Cnv-N1J63+hs=SXFhQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/24] 6.12.33-rc1 review
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

On Sat, 7 Jun 2025 at 15:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.33 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.33-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.33-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6fa41e6c65f72599c662db2b1e70f04205b38eb0
* git describe: v6.12.32-25-g6fa41e6c65f7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.32-25-g6fa41e6c65f7

## Test Regressions (compared to v6.12.31-56-gce2ebbe0294c)

## Metric Regressions (compared to v6.12.31-56-gce2ebbe0294c)

## Test Fixes (compared to v6.12.31-56-gce2ebbe0294c)

## Metric Fixes (compared to v6.12.31-56-gce2ebbe0294c)

## Test result summary
total: 250901, pass: 229133, fail: 4639, skip: 16564, xfail: 565

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

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
* modules
* perf
* rcutorture
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
