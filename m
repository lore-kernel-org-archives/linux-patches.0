Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55DA1E47D1
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 11:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731066281; cv=none; b=ZVe7sxHEnQQEqkI0I+gScntMBkHuWsA28+Plgf8ZR8oQZiqYz3GkE18NY/wfpzD8WAsjFlrRYBjxu2zZrNB32zr4Qt78v42taztynBeEnPlqkUbEo+/Iu2D6HBfu1fS7dJmK3fASxbL9OKauTyFo11s70VbFQtQebasHzepWWas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731066281; c=relaxed/simple;
	bh=+OKAoz88ppfKCnr6rPAI6mS9UizP4kyupQi780jyc5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b8Ld2za1oVOWeHR48aQg7Rb4ltXw2LJ5sLKU3/b/9Uy6bXcoKBj4/YqVlzh+cst+dYHDgqHEvRXoi43xqCGvnz9cUpcc2fVUG3wtdDdACGv02P5XZoxDVvjoqvSkTwjnwuJvCFgs0WLjcA6/o069PSVbO1EP2c1pW0UkTi5Wl0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VcqSp0cZ; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VcqSp0cZ"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-50d4a333a87so854936e0c.1
        for <patches@lists.linux.dev>; Fri, 08 Nov 2024 03:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731066279; x=1731671079; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MkHXmgDAc7wSG/2nmCt5dHpGxnoKoPhVGd8Ic3kCUA=;
        b=VcqSp0cZcRHQD7sIBV+HXLcdVLk47ZBZU3CFVkUpR3y4oEwyj5mkug4drtncUTzE8D
         MCm0rvaZ7xqditvcJ6EncIR0jJA7tuu6tHq5XZvlH/+g41X+tRq5J7uAC1t5FC6jVra/
         mUYeIQQxEfjyi8ywH4ouM4lfMWirfTt2wY6tmC98/wKcrNx3NSLLgMBO9thEbZdVceLZ
         5sHanJpWb3WYoYjUMv4rFeKZO/FRjWyuUPAdlUG6SYlT5hUkHXblCGYhgXy1Py9nMJuu
         d5FxVJpSeBchhtKebF8VNTeJ9aVVLFTPdxdON/PMxbjO7fqdXem0XRLyL8AIY1aqqPQa
         dIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731066279; x=1731671079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5MkHXmgDAc7wSG/2nmCt5dHpGxnoKoPhVGd8Ic3kCUA=;
        b=I907joYICUaA+kX312hUAGXn9vO5KAfLa4Dz+tn6wyDUABAXvDbI/PUR+Cax5FxuSb
         5nIaf0BCqk68M3QD72chVtiW9XN7geRj/k8+XstBkE0RRhG9pmvt6ksSETt8ZXiezHR/
         CCc0wSj69gEFzMCIe1uQvfWxhRs7nQDM+9lCbM9WlAQ3fRnNJkMO7XQLxQAXfEci4qdX
         fVDeQgfQ9Glyz6dqIcG1s/pURM2CpuoXSbbDv+Oo5syHAbKwKW9VoXVk9S0MSp5m0+aO
         NrzSj7cauH+QegCdnIelTJFg/tso0SfuIOovyXA7UfmQSyeBZg3TDrkdkNCMthwSM/sP
         7GlA==
X-Forwarded-Encrypted: i=1; AJvYcCUQ3TwrJKnHqINJBrUwFOLdE3zCnOswyBA7pBskBr17i6AfUzCYJolIJAbsBxgF9/FVCBn4w72w@lists.linux.dev
X-Gm-Message-State: AOJu0YxIr46N5rMD3P78XoesoyVBt+YHtiESevZDeODg5DQ+fwaqiZFT
	36aF6ed4Dk7QKY0eU7YtUi3UQeTtH8oXNTUaDtBGq6cvREOWeeZkfZU1NxsnPevVpdmaQq+Rvva
	C8UtjjlpJS+hTkpV8eIlgIXBXlRhzm2Qe6DrGNA==
X-Google-Smtp-Source: AGHT+IFAZTqKzcVIqRu2qUNfmV1XxJQHNHEolKZ0j+1gbYX4fXqaE1L7s9c3g5QIBoKkgQslJmlu4ncQztgHZ+I8dIc=
X-Received: by 2002:a05:6122:3c56:b0:510:185:5d89 with SMTP id
 71dfb90a1353d-51401ecb673mr2320465e0c.12.1731066278880; Fri, 08 Nov 2024
 03:44:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241107064547.006019150@linuxfoundation.org>
In-Reply-To: <20241107064547.006019150@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 8 Nov 2024 11:44:27 +0000
Message-ID: <CA+G9fYtr2V+noAMBzyCafOMOeZf33bo6DKMcGOqsH0-C+0xPEw@mail.gmail.com>
Subject: Re: [PATCH 6.11 000/249] 6.11.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Nov 2024 at 06:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.11.7 release.
> There are 249 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 09 Nov 2024 06:45:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.11.7-rc2.gz
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
* kernel: 6.11.7-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 504b1103618a4532bbbf6558d80cdf3545a2c591
* git describe: v6.11.4-646-g504b1103618a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11=
.4-646-g504b1103618a

## Test Regressions (compared to v6.11.4-397-g4ccf0b49d5b6)

## Metric Regressions (compared to v6.11.4-397-g4ccf0b49d5b6)

## Test Fixes (compared to v6.11.4-397-g4ccf0b49d5b6)

## Metric Fixes (compared to v6.11.4-397-g4ccf0b49d5b6)

## Test result summary
total: 610158, pass: 505466, fail: 6987, skip: 97705, xfail: 0

## Build Summary
* arc: 20 total, 20 passed, 0 failed
* arm: 524 total, 516 passed, 8 failed
* arm64: 172 total, 172 passed, 0 failed
* i386: 72 total, 64 passed, 8 failed
* mips: 104 total, 100 passed, 4 failed
* parisc: 16 total, 16 passed, 0 failed
* powerpc: 144 total, 140 passed, 4 failed
* riscv: 64 total, 60 passed, 4 failed
* s390: 56 total, 52 passed, 4 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 16 total, 12 passed, 4 failed
* x86_64: 140 total, 140 passed, 0 failed

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
* ltp-cv[
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
