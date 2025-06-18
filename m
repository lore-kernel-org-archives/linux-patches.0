Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290EF2853E0
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 10:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750242783; cv=none; b=VdwgEFQG/HdT0l9bxJs16Ks0MqYbQW3Zgv0AznidoiYGNLrICP1bbAuwUzaUgfm6dfvxIIA0eOj06iHNM1AWcVdotmqFk2xa7uNQp35d1yb4QOOCmdUiSMyK323yVC2BYKtZquDTD1clUPc4JkaCLvXilObdtE4wDs49Yx6M4Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750242783; c=relaxed/simple;
	bh=UrYSDfsSo8jbAtRvRzWzGL/NZSe82kdFNONR7gB8P70=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bxl8zkt2/1j+n//lGdI0FTmTvsBZCjgbon7DJogRONbGvnM0R/3pct9Xh4Bq2m69+Spn0LB2tQLMrEQ65/t5XwhhtQzIghR8SIDrxz/adPiOJKTsB/LATKVKQT1p7oK2lXXUzSaDoSC8v+RwEYoS9N/5+ubvGJbOgtdsbOy4gE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OZ2Lmv5p; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OZ2Lmv5p"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-87ed676e631so4131330241.3
        for <patches@lists.linux.dev>; Wed, 18 Jun 2025 03:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750242780; x=1750847580; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aITcoDBlN7uXS1VgjgbrvDBeop4ua9noQuKy/Q4cyYg=;
        b=OZ2Lmv5pnkcRvLxY8Ev0gcU9rZcTMvbyF6f/jV4N2jcDPuG8mqPYHDPzseEysyTnPG
         JP7JjcHqkpZzTY9Y9qoxHERRfa749wKRigW/qZIk9mTPNqQMNcK5xcbL4iOmgRJI9xi/
         r63wAJacQq/OFcNL48VzmEen0fnogL3HgOZUJsveUe2pvioMr8OEhWwVDlbzMBjfgqU7
         RjnIwnVsE2AzlbUowgdhB3dGjVaxnjXiRUwS8hTpCz5rUAwgTB2r59KYPekUXaAEH8LQ
         m/Ac5hyMzyG+R0IfYVHTFICSaZeFHhdVKScgqeLlOKvDW7LP8f3/mSiZJ4K1VdisNypj
         biqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750242780; x=1750847580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aITcoDBlN7uXS1VgjgbrvDBeop4ua9noQuKy/Q4cyYg=;
        b=Ih9cN/uHwxP4syvmyzx03XAEpjO/z0kirLOxzaECxfn6oEkkcO79jfHUkxquSjvcFS
         5DJDLq18Dq/ReWTGx+rBiTB9X9wRdEc9RdDB4wDkE3LbBTmqd0WIc0072/2D8cHhGfni
         Go6Fx37fjoQBrPDs7lEfkHxewvbBki9zHFTYbUAjViokA9S+9KYv6jKzzo9CKh25/Cqg
         CshvcPzS9AGEleuQd3sieoN3GYscYA6FvvaoUXRxFV2Z91FHR8q3SSou6j913FVPEIuY
         1DFkFa59LODZVPldLf1rRyduDppqTZRRl+42vR9RfImXUiBnddtZiILQJona2ZGaQ3it
         ya0A==
X-Forwarded-Encrypted: i=1; AJvYcCX0WD1mj7CJRyfj2YDOsTb1cKeF6+haOBpU5eylrdepGO4qIDo2jFjvwfIhxWgaPaBnslBxd6Au@lists.linux.dev
X-Gm-Message-State: AOJu0YwyQqlI5SPibFGK0tKi6ciO93DehB0nGnHZf9xQWtNe5LJKGWV+
	6+5btfHDNE1RsqrUbFxtvqQNLJuZe2j/bFofhaCfdAf6L/Z0QShpJPBuUWO4L/sA7n0s1sOTvsz
	qeE/ZrM6mE1jnP6jGJqhXtmvzHfkNXrkCG5md0yWFNw==
X-Gm-Gg: ASbGnctgg/405JxKivjykrgD/F6EkojrmuJMESTo3D2aENjnCC1Snu6MqjvkaIWowk4
	2GN2Y4y5p6P9scH9E0rk7AmrTQ5Aj7czM2TSaibkm9i4JqCq1yMV1X3yiYIWGZntOTq+hr54N0M
	6tjDTk1NX4cfCPaa2gDsu5u4ypmOr8UBrYpfehXicVnco=
X-Google-Smtp-Source: AGHT+IEOhMxcalcExwDVkASvmUiqj8BpLqLOJHPINNMBGhG0xRGGjlY4gMGyxbaf8vTC3PowQvMp9pc8rPfXoq8SPoE=
X-Received: by 2002:a05:6102:5985:b0:4e5:9380:9c20 with SMTP id
 ada2fe7eead31-4e7f60f55c4mr14046287137.2.1750242780042; Wed, 18 Jun 2025
 03:33:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250617152419.512865572@linuxfoundation.org>
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 18 Jun 2025 16:02:47 +0530
X-Gm-Features: Ac12FXwvCnSSJUeypLbKfrwr_IFThfVnPumtJ2s-S0kqzXU_38IZ41IQZmYKQXU
Message-ID: <CA+G9fYsiW-qzcJgkooTwU2YzQydit6jW-C1XyT8VOUQCcBK_Dw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/512] 6.12.34-rc1 review
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

On Tue, 17 Jun 2025 at 20:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.34 release.
> There are 512 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jun 2025 15:22:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.34-rc1.gz
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
* kernel: 6.12.34-rc1
* git commit: 519e0647630e07972733e99a0dc82065a65736ea
* git describe: v6.12.32-538-g519e0647630e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.32-538-g519e0647630e

## Test Regressions (compared to v6.12.32-25-g6fa41e6c65f7)

## Metric Regressions (compared to v6.12.32-25-g6fa41e6c65f7)

## Test Fixes (compared to v6.12.32-25-g6fa41e6c65f7)

## Metric Fixes (compared to v6.12.32-25-g6fa41e6c65f7)

## Test result summary
total: 254275, pass: 231555, fail: 5974, skip: 16209, xfail: 537

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 0 failed, 1 skipped
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 47 passed, 0 failed, 2 skipped

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
