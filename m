Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F971CF284
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738337045; cv=none; b=H7E3Yc+NW9JPQKoI0fa7bfTbTH4wm2wkzNDTuw8eCkJB+p94mI++78DpOfxDKBEEHackunKO8VML5XBP3krpmVTmFxWYIQUOOd0QM3yIJOLW30QVyCpcVdSRPp2FO447HAvzpzmnfUg8bdxIxOVCRUMkNb6uomnmOclvS3fncQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738337045; c=relaxed/simple;
	bh=TgBVuZbqmONVp2cBCwO+GazV6gt3oAzqH+Qi4bWhabc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MCOVEmMe95xN3lze0cRHERmT6NJxoRL4LMqqUn3JaPNbqtnFdUrI23eWUBtMKYTFeSzfLNlIfI23Fild2A9oK68kz5XxUX40nno1GidMumZSv1abpWwtFltJyAl/BAmPJZJQbwQsfaqHL7WAOfa8SG6oaOVfPuLWTUMg/KOOoFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=M8vSt6fI; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M8vSt6fI"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-8641bc78952so532980241.0
        for <patches@lists.linux.dev>; Fri, 31 Jan 2025 07:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738337041; x=1738941841; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MmB80dNlZ/Z5Y29wc6E85ls0e6J9rncIwWF25L4zaU=;
        b=M8vSt6fI5erUcl6i702rWAGlBK3uWyADVD76FyXDI+QRbSFBAjKanV3QUa3kkODlAZ
         3ZC0A9xs5PIObFsmUC3W/Urm0rl95SKiVz53yygWc71S3IKx/iVTyFeo2aYn9C7pzKKt
         t1Ko1+CgDZKoC6B23YUXolRq32lEXvyBjVUw43yPOxMNC4lIoyHmg4egyF9BRATsW58/
         z+WpM+D3ck9huT3rU7MTqM/oRO3v/5+plo2s4HhjI5yz2PHtiKw6K5R9HCVPxKIbWNHW
         N/bd8MxcUZX4CMOUDGtMFsYzQMBB3i40L6d8DnABtTajjfR0xpeNzAmmjXwsuAI/xV9D
         6CcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738337041; x=1738941841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5MmB80dNlZ/Z5Y29wc6E85ls0e6J9rncIwWF25L4zaU=;
        b=smxBjMSDI3SJX269iLYFkdmeJOkzUqdaamyNaIOJJpi46lBYOWXJeN4VrK5Wv54LYg
         PbcJBMFrfh2Tm2ON7s9VoaHnso5APW+sXI1qv1wD6/jBUzrzv5n1oprP1pKs6NdpdBJH
         wkAgAqdmCfTChPXiAeGDU18DPdOysLLAPscqH602nwJqPDjApao2bH3PQ3CneWU4JVpz
         x5WjdRRydleqx1XMqS+e/5RorwrudcRi2vteZPwZ0SI1aAEArXxe7sM/3z546RSFbTvQ
         H0Jd1Umg9Fwl5QcUObtRgYKTTyBiBg0LVSpUYj0Vhao60ah/Ki/ghWIa/4hWkM13XVPB
         7Jug==
X-Forwarded-Encrypted: i=1; AJvYcCWWE5bflcGmnwh/8VmReS9gU6nsBak9XajeNVF5ysTl8Av+LDDUYVTbIZefn/3IcuKFpMS3Yyce@lists.linux.dev
X-Gm-Message-State: AOJu0YypOuR0iMjdt5XhoCNlYBg8+Ap0YF+f4BA3IMdg1wFMwYUMTZXP
	RB4ZwMh1ZrHkC/JPVW/eJWl9gtOj1w1umAscPIwD8tCaF+z43Z4MWRZPO3GhMndVzcBHEo4f3na
	8NOXWynWNUssHfWHBqBCdvsop8KRs1jdj8+r2IQ==
X-Gm-Gg: ASbGnctQjAbLarFuC3Lzok8f0q1QfiB9csqBgzArKXsY6J4mRMqmYGYQyaBcrKiKYyP
	IKm8KOV/2G/PiUCUwCHPudXQxWWlf77v8em2TOauDh3rl9zNuLBe1BaAl1uIdXUNDp78G8R3S4c
	r8Vrmiu2c9ANfRf0c/UgMDHeLWN+9ojQ==
X-Google-Smtp-Source: AGHT+IF7h0wUp9yKsdp71mMvKTkAx8g2V0RVMq3BeCI0OtZi8JKdX/kz++4pwR/QvuGJZGjFqCuH08TtA+D2g9xEv+4=
X-Received: by 2002:a05:6122:8c2:b0:518:965c:34a with SMTP id
 71dfb90a1353d-51e9e3d2831mr10218805e0c.2.1738337041648; Fri, 31 Jan 2025
 07:24:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250130140127.295114276@linuxfoundation.org>
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 31 Jan 2025 20:53:50 +0530
X-Gm-Features: AWEUYZmodaflHy0FpLJdmZ8d6jjAWwVYtcU0AZZUKH1TGmHeKkGEWQYQ4fvFlbU
Message-ID: <CA+G9fYsi1EFDWOM-7Si5PV2HOi7ShcPtyM218jiWFkL64uZyJg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/24] 5.15.178-rc1 review
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

On Thu, 30 Jan 2025 at 19:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.178 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Feb 2025 14:01:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.178-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.178-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: cd260dae49a375098c2120ff1618e6bdf874791d
* git describe: v5.15.177-25-gcd260dae49a3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.177-25-gcd260dae49a3

## Test Regressions (compared to v5.15.174-52-g11de5dde6ebe)

## Metric Regressions (compared to v5.15.174-52-g11de5dde6ebe)

## Test Fixes (compared to v5.15.174-52-g11de5dde6ebe)

## Metric Fixes (compared to v5.15.174-52-g11de5dde6ebe)

## Test result summary
total: 61427, pass: 41406, fail: 6650, skip: 12892, xfail: 479

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 105 total, 105 passed, 0 failed
* arm64: 32 total, 32 passed, 0 failed
* i386: 25 total, 24 passed, 1 failed
* mips: 25 total, 22 passed, 3 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 25 total, 24 passed, 1 failed
* riscv: 10 total, 10 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 28 total, 28 passed, 0 failed

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
