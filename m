Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA5F2232A
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 05:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727934095; cv=none; b=DyGcord++6rO+DIDarHpyldU/BWW4mPVg8QjJ3fuLzSSiCfrwzyyEGH4CCBiG9rne7OqyuVMaovNHIaUS02Q6DPzODKf2E6zUTQtCNTW0vGgQApQchcB4PaqeaHa1cmCzrAJ4b3cwjVh7qAwpqx6G3MsZO3Kb6/xzPWHRkxgru8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727934095; c=relaxed/simple;
	bh=CSw5R+SeMa/89bVBrTfXW9kIJb0j6X/wpefM0qMqZDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OrnlhjES4hLKnBNpOjijbcZZg6mZy0LhFmnIx59YgCOGcEX3yY2bsjA30BwDXPbip8+oyLAF+nSF0SyK5XdAiW42V/5GN6eDRdMZd+0esDRQXAho8hYguHQpXT12oiFRvx8q7OzDiSPRgyo/2gEKYy5tR+vE0xnA2TTmv5pM3hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qdjjNlW5; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qdjjNlW5"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-50abd42a6b2so874378e0c.0
        for <patches@lists.linux.dev>; Wed, 02 Oct 2024 22:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727934092; x=1728538892; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pw8iifuRd9HoKi6IX0yFjdpQe9TOeP4uYleXmqHMHNM=;
        b=qdjjNlW5GCZIekQUxbPDX9Ey52I4FoEV8jgfK+s5sqMfhf3Q/VPCMrBR3bjwpDDiDe
         H5NuJF9AJF7f9kBHstkW8BjMnvWsbljx2jNZFmRm56ccBChlIHy+43QjHSkb1PcE+nra
         GlnbCdoIVq8rkcvYzcAYj1SgrQWMPIetZznwE6Cc4aYgsl4/e5XU9s5MMwKruf+1ndwk
         V7URM8v1zh7dskyUDoJd3OaGfpVp4ijqt7JKp78pFsa74HIxRXbxX6hjKWgYBT/5V+ow
         YVsSYk4/tGc0Ilz+c41qn3hKiJYfze0R4xqppzJ3n7Ma3re7jGARJC9dN2EurhTZF/bU
         RQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727934092; x=1728538892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pw8iifuRd9HoKi6IX0yFjdpQe9TOeP4uYleXmqHMHNM=;
        b=PM/3IEyHa6NsahwXeLF8quoZ7Q3E+F48zfzPAweEfy0j0hiPUGxtajzxfqM6fVevFz
         uiDKwgJrhi7P+CBhbuNfw55i+846MTEbP2VlkODmasqERboqFHH1wz2QilNe2Tbt4DCi
         dJicOlNI2r/LgQhRAUari1+9h0hjqNW5X4+L40fjz48VJe6BMcdBXxfQwPRMRpAn7ao8
         LUJiijGJThftD+Qh7+1IfOtvFHW/FuV7A1eGJG5l69tCIprfxFbv/Srqfx0gKzyzVkUM
         089ifzLfZpk0+lWO1r7F/yVJilk45/5Ok+IVrL3gB+ot6J5IvnCF/C6oaXr1UZ91b+iy
         TCjA==
X-Forwarded-Encrypted: i=1; AJvYcCW+maVrcbetz4LCSUEcNc0gIfWCwFJmbBWVThQh8OFGFELr1NHHZgEwGbUjFTlbRekh59xTnFq+@lists.linux.dev
X-Gm-Message-State: AOJu0YxfiKdZ33bernz1QH66MLLKndpc4Syw/HUMAF/gzDr0GlCWyywY
	gu0+m6ZPOi+MOzpg4nv/MwdeRbYkulMi3HPx9Tp/iDrbhmhe+IvsKjzQy9OGslBrdtgUVNn3Y1J
	hmapFrhewc/j5eK4ACj18SQWBAVSlgioZgRicRA==
X-Google-Smtp-Source: AGHT+IEGU1yRfjAOvrQ+R9qsd6hUhN7cp+HCezwPGfSb9CdJGNzR/0DM1TDo4J7A7MmL/xBqG01CdMt0AV3gn22Wsbo=
X-Received: by 2002:a05:6122:31a4:b0:50a:b54e:79b with SMTP id
 71dfb90a1353d-50c6d122840mr1317582e0c.1.1727934090887; Wed, 02 Oct 2024
 22:41:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241002125822.467776898@linuxfoundation.org>
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 3 Oct 2024 11:11:19 +0530
Message-ID: <CA+G9fYtrdanK_XVgTeT=Chj7TL3xaprsr1Kw4yKb6Gs-BjSSpA@mail.gmail.com>
Subject: Re: [PATCH 6.11 000/695] 6.11.2-rc1 review
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

On Wed, 2 Oct 2024 at 18:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.11.2 release.
> There are 695 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.11.2-rc1.gz
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
* kernel: 6.11.2-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 10e0eb4cf267e330d1d0841845c7cad394de439b
* git describe: v6.11.1-696-g10e0eb4cf267
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11=
.1-696-g10e0eb4cf267

## Test Regressions (compared to v6.11-13-gcecd751a2d94)

## Metric Regressions (compared to v6.11-13-gcecd751a2d94)

## Test Fixes (compared to v6.11-13-gcecd751a2d94)

## Metric Fixes (compared to v6.11-13-gcecd751a2d94)

## Test result summary
total: 219050, pass: 191331, fail: 2547, skip: 25172, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 131 total, 129 passed, 2 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 18 total, 16 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 11 total, 9 passed, 2 failed
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
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
