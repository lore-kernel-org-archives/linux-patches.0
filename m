Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C399C1CD13
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722015199; cv=none; b=GMTue48LD4Mw5RwrSkKIY4/raWYhahRipmqKshVYBQYSKZ/bdfOeGkV1TWH3HkqyVhPbeSK9S1EEG6rs2iZaRcSm9h+HHW3M8loYvf3wxKmCWCO3uWFCADnGoKCbsbk8cpzwUNux/RpHGTSjk+YqEe9uAsZrvWuT8eMJyYBgPDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722015199; c=relaxed/simple;
	bh=9CgK1Ue9z+VUAagKzCIPsMBjEzs7eLVbbZi/4euGvjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HP/kL/Z1XE+MlLclnwQViAUsTB0cU23XIHLSsp9UN1L9o4KzIYnD9Ecn/JKcsbM0BlzoIBaCWlJ1TY/K1jMTIIJlm6bV1x6BN+mLw9LlLaMDAZsUYPNFq9qBtT7e0z/9NeJLOjIcsXnXNZHn6CtTqEO+fphA4AyMBmuQmN7MdE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=T4m+WvYm; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T4m+WvYm"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-4928989e272so802186137.2
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 10:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722015197; x=1722619997; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqsc7KoNh5LaQFIPWsU8Ii5R2mQ1JpnvCyqvzMOylK8=;
        b=T4m+WvYm4mjcZ8LpMnSJ/f379p0jzn3PHA1bNwirK5vB5bRECKXMjHm7UWK42Fow1i
         hbCl//5dukmeIj3ceZFrVRX40Y62EjvBl64xSwcb8Mt1g095AJJtS8/7LLLG8UmKzwQw
         4SENUIKsFPcoMM2cEun6ZYnhK6ky0rAvMtf5IkpdOzJuUnzZ9vfhoRzLgNOkshsOgZzZ
         /ceA55ztB62TI7zFakxkToqRfGJ+ykQzt1oYTQvJdY3HvZ9NHtRqp6pklv7gYXJKD4qH
         4xhF+qxeotdwcvCiyNosewUWoErabLO6+j/3qWnP7gq+7uo0od9PzCoXqB2GXuP5s4t+
         l6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722015197; x=1722619997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jqsc7KoNh5LaQFIPWsU8Ii5R2mQ1JpnvCyqvzMOylK8=;
        b=vgHwJuC+8EoSgygMERsU9gPk0JMSU87WMbutCjSZn+HbLX5nGg4R8lpuQu+Zuw+EGG
         58hjZ35d1OZ96sij0P50uIliMV9lvZj9cUohny77I48+9HfRUtlvWuDzTcF5pcCq6/fm
         Ps+SvYU1uxx5e1CSSS46HWnwsAZ2fw1d9L18ukTK+sMKOtRXZIqL3/2IWipvjD9ARxAp
         776Cujoi9lMXM+KezUfQb0lqU5RUIRT3konHeUrrAuMmSd3aREXmX483FrhxbzL7kjPW
         J+J8Micl1XFxbYofU3LLVRH313gb+08qjoGMz8ZsUfWDcR8ihAj8zglP4q1EybvL8aOH
         3XiA==
X-Forwarded-Encrypted: i=1; AJvYcCWtMMYtDCNgtx/Ju0uMcy7cGvw3tjh1dnpM9eLzMEzbztTz1uUd9MeYuv6Y1LsUbDPzK2cq7PXnTQBEVNaR91kX7w65Fv2GuQ==
X-Gm-Message-State: AOJu0Yymqtg87V0sUIQeAuIj4Q40qA4vLe6/ogDJC4ntjZhmwo2jI2dO
	VRnXt5RfZJ0zak3FUvLpbgrHK09WY27rfXZzftfp9kFf4QnUYVytom6DbxoS1qGjhFijesmCYjS
	/rJ/6mDCk+oR1GtYXxX38W89cXi4Wv4vBkJMQTA==
X-Google-Smtp-Source: AGHT+IFNC1lguyEpatVtrcm8FCHBK7XQaB2Y6jWPiH1DApVuXYlKniVVzU3PfXglDRl6FFTFF12m1/pdl8xsVTMXF5g=
X-Received: by 2002:a05:6102:358d:b0:48f:c062:75ae with SMTP id
 ada2fe7eead31-493fa819b11mr488034137.8.1722015196600; Fri, 26 Jul 2024
 10:33:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725142733.262322603@linuxfoundation.org>
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 26 Jul 2024 23:03:05 +0530
Message-ID: <CA+G9fYv9MqRUxoAaUsmi6Hq3xp5LT8vFyG+ZovgaNwcPowy1vw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/59] 5.10.223-rc1 review
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

On Thu, 25 Jul 2024 at 20:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.223 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.223-rc1.gz
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
* kernel: 5.10.223-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 0f0134bb137e987ea2c432d03486a58a70840903
* git describe: v5.10.222-60-g0f0134bb137e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.222-60-g0f0134bb137e

## Test Regressions (compared to v5.10.221-110-g3fac7bc30eab)

## Metric Regressions (compared to v5.10.221-110-g3fac7bc30eab)

## Test Fixes (compared to v5.10.221-110-g3fac7bc30eab)

## Metric Fixes (compared to v5.10.221-110-g3fac7bc30eab)

## Test result summary
total: 90841, pass: 73287, fail: 2151, skip: 15338, xfail: 65

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 29 total, 29 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 23 total, 23 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 25 total, 25 passed, 0 failed

## Test suites summary
* boot
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
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
