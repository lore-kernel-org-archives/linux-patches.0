Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6556A18C324
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 11:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717759836; cv=none; b=EQ430nA3aw2WzOUHFfRAmWn3NRmv6v/uHasu9R3nR5ELaYAFe8tPUzA7q92b1DQrBrNEjnDIrniHCKoSUTNHJMxVez3yejDVic8ovTwFaZ802h+zZLT592Y+3WWpQyNLdt8419D9O0+rRIU17hI3+NmgAW6vhSFUh5aMyCC0rQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717759836; c=relaxed/simple;
	bh=StGaEF7Uc4UFGk10SNqRzEBaNDnxrd8+sdjkMk1BlgY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IIN60H1yu0Ls0svMSjnW6K27aEei9htqTxEeCQEEhcmocERsQTynWk81tDq57n7uWEGB0bKt9Zn6nKaPYm+1kMrIDBCD1eth9WvaQy71q01LP37skJahJ67NlhJHpJ4xGpORX+RKXA4UxKxLHAjADJDNhAmrXyvDAKWqjrO4Krk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RujjzywZ; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RujjzywZ"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-48bc7efcc79so690590137.3
        for <patches@lists.linux.dev>; Fri, 07 Jun 2024 04:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717759833; x=1718364633; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2xzYY0svUoPJkXHA3ANkFOIm7crXu/iU7zTBAmDKAE=;
        b=RujjzywZr3LepUW/48H4RXWiEjF0DYwtd//YOtnuJewBe/USk73NiEJjtQFWfA7cXA
         w+vrHcpp0h1HIpGOKB0YdmbJNsdxYOHCChsCCWUP4JsLA4If+RlO3m9HnBx7AfwmAkG1
         toITyWZaHG+35uQof7X/+VUh2/GuQiBtF2IVIX65Iec/vrHkcdBnWPRvbBMH8byZVTXF
         Es+KjRqo6fYxsD1HMse28EDuGfjWs1aeC5VZyEgl+GAy2GOQTvvtTEL9AFbr/I0GcVna
         +mzLzaHei+yerO9bGCcZhlmpuu3yeHKjOYZ7Hi/Q6D6mpCOQgkWNL7MAEW2tQwhN54y0
         3xJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717759833; x=1718364633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I2xzYY0svUoPJkXHA3ANkFOIm7crXu/iU7zTBAmDKAE=;
        b=V0EjBzesp0lZg5BlKxbpgZJOD6DzbpPuVLHf31dgbTTzZzCErjlgpZb/3kwENb4Kre
         BHp1KYiAjLePt1BUrXFROxHkte2xqc7q5UMhgOpGe9TOd5+3UvI4zjW6a/VX5MCB7TYm
         X5wbWrv8KMwUSwK06LrSNNFu81Hq0xlXsfKojg2sCa5Kw0MVRz1l6r0j/raUGg3aT2ek
         lWWTdE3IeNsqIn2f9EkGNuwY53Xy0VaUrDxZQdvQeAiIoZcvkiohj4A511uzHACCkIwv
         wMAxDU/Q544K3fmL/XETScOafdeQzqertmWTP51nsBRC8VK0Qs6Y6EK6+9xjE15IyJif
         GUNw==
X-Forwarded-Encrypted: i=1; AJvYcCVq/Ki8N5zcObu6Nlr2ax99a7/UHMEbHD6Xr4RKhFBR1pqds6Gfc+9xHRkYhPOcuX0rzRrRlaM+N/aiCINiaU9c3uNJqg2u/Q==
X-Gm-Message-State: AOJu0Yw85s1Ll4InQ5rG0xNtOsFJi6KmHGesa5CfZxQLUHRosTldb+Of
	fyvKgwnh04BqdQtXjgdLoRPBpSbV28Y4bIxtsCQJnxcn7HgsckpzE6QAlL/sqSuowjXpTUufoiQ
	T+PJfxkt9Ral9w3oOqbCWSXVSXoXurxvCd6Y48g==
X-Google-Smtp-Source: AGHT+IGJ5cRdJaVJGpRXtDfA4+hmK7e78lIlYOpxeNoT6q5c/FGNN2WFodJfhF74Z8wqG4iqthsoDesIUVns4SN4bKQ=
X-Received: by 2002:a05:6102:190b:b0:48b:b9d4:2420 with SMTP id
 ada2fe7eead31-48c2759b7f0mr1971951137.8.1717759832991; Fri, 07 Jun 2024
 04:30:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131659.786180261@linuxfoundation.org>
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 7 Jun 2024 17:00:21 +0530
Message-ID: <CA+G9fYuWn7Pn6rQR5EsQf9hPuTB8i6VmBSoYqEbZLLXJjjDUhA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/473] 6.1.93-rc1 review
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

On Thu, 6 Jun 2024 at 19:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.93 release.
> There are 473 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.93-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Build regressions on Powerpc.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.93-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: d2106b62e22625dd85dc50e14677b07b849a13d8
* git describe: v6.1.92-474-gd2106b62e226
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.9=
2-474-gd2106b62e226

## Test Regressions (compared to v6.1.92)
* powerpc, build
  - clang-18-cell_defconfig
  - clang-18-defconfig
  - clang-18-maple_defconfig
  - clang-18-ppc64e_defconfig
  - clang-nightly-cell_defconfig
  - clang-nightly-defconfig
  - clang-nightly-maple_defconfig
  - gcc-13-cell_defconfig
  - gcc-13-defconfig
  - gcc-13-maple_defconfig
  - gcc-13-ppc64e_defconfig

## Metric Regressions (compared to v6.1.92)

## Test Fixes (compared to v6.1.92)

## Metric Fixes (compared to v6.1.92)

## Test result summary
total: 148502, pass: 115326, fail: 15709, skip: 16872, xfail: 595

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 22 passed, 12 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

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
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
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
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
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
