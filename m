Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E0718A6CE
	for <patches@lists.linux.dev>; Thu, 16 Jan 2025 10:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737022806; cv=none; b=KolMrAqZ66MtUQqET+FeGesA9eWuZuxWAXzFFAiU2tjNvBirL8xbg+3yQn6btTSGTSK5y+4OYb66gEjc0D/uNJ1eeaayJFRQkLnFjvjhCDOUg4kFTIvi9ncRPCKU6PNGg0wi65EStT+JFj3hY0nnwLszlvBmEC6oWw8BDmC9Xic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737022806; c=relaxed/simple;
	bh=r/PdQZCIiaSOmdTKkSGIGRdKH8nSCZ430OLi3pjld0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lYDl4ijLPzD96Fkd1iC+q0EL9ibygcVgyZJ/P9L3KybQFT2JxZr6sMrnoph5MiVaYId+8LGxGV+jNOb/uorHoVM4tvxyLp7fHCDHu9YdLcWbhdP4JDbqKH4X+i7bqYOeVrEEIh7cZLukUOxSibYGxBgvXJFdAbsUgY5c/aPDAOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UyYCL7+G; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UyYCL7+G"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-85c4c9349b3so137031241.3
        for <patches@lists.linux.dev>; Thu, 16 Jan 2025 02:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737022802; x=1737627602; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWTcprBJAJma4CuHivwxMfhBEdMs6vyqa3RMxgQxWEc=;
        b=UyYCL7+GXpWDDV0EaAitazbddjkTH6F1l0YB91ve6hien9CUNeDgYWM5JUK2Mefxht
         hMJSNPxXtDVntkp9FCwWcT8OywbASjvhMOvSaqLR5TCnzL7JqSVJaqa0bJWxUmip7Wam
         p5/syr7h2UtNdp+ehSb67OApg9J+SggjuI+KihsEshXMDZ07TCxcz/hQsvQHI++j1WuY
         L1xcu14S8td6TAAysJD1oEemMd8M2V305KaWazQ7WS+GxkxX1kRTQKvXZddT9G4F47YQ
         rkFv35Bg1E/QOUK9N9pnQMUJ99FR/9Loi4QxNcuCRD6JLLiufvVVPONsXkdJsAA/COSZ
         WoLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737022802; x=1737627602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wWTcprBJAJma4CuHivwxMfhBEdMs6vyqa3RMxgQxWEc=;
        b=hP9Mw9dki7CMtpAvmS0QhUNRUFfTEqLzq/Wh46iZFZPUyc29jhZRzFL62wZr7AGB9Q
         BM+snMTRxJH/2hu2kXK+qLbf06+RuvKicJwsMuroL2wX3QNdCJXYZ/lNHKGnLt7Z2CoE
         kVcvTbS4O3lOYR44zWDh6/cWJCT+11zAvbLt0i447skJ10SC3KEsMDdq///GwpWGV2TQ
         WJ5RfJ3PGDwj82ELQIU6TVeS75p6AIsHzbE4dxAIjnT7m4fgXMQcHXzc9F8dw1otSagz
         Ac5EprV0kPq2uHUaDw0MhbMVMHYSXG+RN98xdvHELfzqVIyiqvtCx/QiuUWaEd+lxB6h
         Gn3A==
X-Forwarded-Encrypted: i=1; AJvYcCX+1nDrsWc55+p2J9QjvWrZgyUlvqP+yxT175RCzJ2t8phnhHO6Y+lk/lhEMX6Z+QqJ4aakDQ2A@lists.linux.dev
X-Gm-Message-State: AOJu0Yyms/Q7rOaOHRlRQWQzU/TRy5HIdH3vcKdr7byBmqWt/b2hKDEd
	+Hwt5l9s9yy/xrVHtHOmHS64tckscti0h/zmIbIx3Hp5jRo28VbZh3Almn14bW4oT+PaH2XQ6jW
	bCXtHqbYeosWASlo+MSLxAN8PQSPux0qGdlexIg==
X-Gm-Gg: ASbGncubahwgUAmzRj7ll55kTKty1By8C8DjriIXnXLfKp+91xLWcETMwFxscR102dP
	raQIIinQiMdoCI/drbi0bvYoxFjQmhzllI0YzjUE=
X-Google-Smtp-Source: AGHT+IErC7T/bZRIDZPFx3j4uL/0qHL4VIXPJviQj8dD5wqQFuUWCOuFA8M5C697TCUDkU1kNzeILJe38Krp0m8mcUw=
X-Received: by 2002:a05:6102:290f:b0:4b2:5d63:a0f3 with SMTP id
 ada2fe7eead31-4b3d0f2d89cmr27621975137.15.1737022802183; Thu, 16 Jan 2025
 02:20:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250115103606.357764746@linuxfoundation.org>
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 Jan 2025 15:49:51 +0530
X-Gm-Features: AbW1kvYgOTGuVDKU-uEsiPEWyUP5JKx5iTOKmdYD8p90NPG3Azs5Y5IdtGW2ALU
Message-ID: <CA+G9fYv-AgeUpP1yPDmy48T869Ms80jgUdjnwtBNoJmCKQvZDQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/189] 6.12.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, clang-built-linux <llvm@lists.linux.dev>, 
	Nathan Chancellor <nathan@kernel.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Jan 2025 at 16:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.10 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.10-rc1.gz
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

NOTE:
---
The following build warnings noticed on x86
vmlinux.o: warning: objtool: __static_call_update_early+0x33: call to
serialize() leaves .noinstr.text section

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.10-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: d056ad259f16555e7fe0d129820d01fa6b6c468c
* git describe: v6.12.9-190-gd056ad259f16
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.9-190-gd056ad259f16

## Test Regressions (compared to v6.12-4-g11741096a22c)

## Metric Regressions (compared to v6.12-4-g11741096a22c)
* x86_64, build
  - clang-19-x86_64_defconfig-warnings
    -- https://storage.tuxsuite.com/public/linaro/lkft/builds/2rf9vPfX8BaAN=
y9mq6s2tWqaVJ1/

## Test Fixes (compared to v6.12-4-g11741096a22c)

## Metric Fixes (compared to v6.12-4-g11741096a22c)

## Test result summary
total: 97783, pass: 78194, fail: 4177, skip: 15342, xfail: 70

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 56 passed, 2 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 40 passed, 4 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 22 passed, 4 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 49 passed, 1 failed

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
