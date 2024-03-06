Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708B65CDCE
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 13:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709731935; cv=none; b=g3PKi+8Y+MxK1IVv7monNQAfTjgRPOdkAbQCbPnBMf/0yHF22JzAyGjwudx9rNAE9tYiZr05OewVm0i9JEKm1V5vkisqqiJbnBhEyxPx9QUbvun6sIc+oy1w4GP3xkhEV/QuODS4uWf4mods5MQHYiyolgAQ5k1j25IsLUBOXqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709731935; c=relaxed/simple;
	bh=JShlrHlvSrWcV7xvzKNa8bOyHN6KPV5FA9UCm9W9blc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nF4UNgktwzqFlhiFUDU9shiGmDfYzTbvpEKkUv7Pv2nxcZ4WuVgngpGTW6LqUF5ZKDrm2uggu8gcDMvK6eZWp5648iMcXuGVrRlnWF+d2iigfo/0u21O2DjzwhhpUjepDTTuBqCuhyhS4to3yIAR8LuZePXXYKV5VdsWoz+glAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bD5rDNqS; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bD5rDNqS"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-4d34144d710so498857e0c.1
        for <patches@lists.linux.dev>; Wed, 06 Mar 2024 05:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709731932; x=1710336732; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2VVJliLDnPnfl5S46gj2IcyJBhJ9oBjofP72vxE2Gys=;
        b=bD5rDNqScC0CbHdJcxzbAo8mS3Y7ijXolhbBCHcClwPbGhULG7RvTgJJAcOUzkQg8/
         aCxTLp1gt6MWfzC5IOAh2kFebIOaqgcab0hyX6OqyznfEze8IuD8cYoc94Z80nteUemD
         noZm5B1n54H/REesxMaIT4LGnHPekCO2lILPGHcvoPIQdzxFZfVShOMaKA0kB7NyB3kw
         L2tHFnO1bTgjbIVxnhdfq646U917e/z/5xKmg1vi0s/rILn3Sy30suvcATNENE9xu5D4
         QGQPKlFzY04W8Vfec+xCSrnBjoUdJySHTe0BrlYgavo2IaqxyESP5qvD4Vac2CXCDBro
         JAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709731932; x=1710336732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2VVJliLDnPnfl5S46gj2IcyJBhJ9oBjofP72vxE2Gys=;
        b=TBMAc2T/sUSf2wr7gz1tJ8b/qqCjTMA35/5JdsJybXW3J+M/Uz2IU+ioUdh4yZS4ZM
         NHC3VA7sYsNnG/R0MqWKR+YA602mYoc0CP5EURU85JRRRxHCA7Tf26h9XPDHS4xiH2xi
         DBIoAsGYa0dhqq/rE9rdzK/0fIDnrn06eeUPpf1H03U+ElOd8cm0VRdt/npdZblJ9XFp
         MtjFT/9k3sOspFZNRXj3O6G0VDvQp9BrNtGGdNNpYetptuhhFgy+bGCq3CF6J60d2t4d
         ONr++2aMwt7az4Sury83VYBzHtlbybAm4OA/Fa32FzNI2fjbkN0nW09xJNDvQQqf9z/6
         NiAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsw7ATPVQn+OblQd8MGEoeLUrNF73GMBCDfll4ImXTCQfOegE7xm1ZCXI+EdIrUh/9V5POK5cB0777vfDRW8agtlEPI6c6JQ==
X-Gm-Message-State: AOJu0Yz3C+y8tFK+vsMT2vCV+Bg9csA2HXvlqu0XqDX360B3NZ5J/mFx
	c1ZaT1VQOyr2tjy1EQQAIvugTTAvf0w0w0aHRSfE5y/m8tAjP8d/aWk7ZAaATZIRC4lRh5EbY06
	UnqNGzlKhyNasTKfvp/8Isfgo7UMUAsnXzVzluA==
X-Google-Smtp-Source: AGHT+IGxrMfsJxszV9jZHqVuSGYENy3aeQ3AbkXLJV/S5S4sAwGbtxZR2+omrhWCMoCVtr2KbHbLbjE8sGzttOREOAk=
X-Received: by 2002:a05:6122:1c82:b0:4c8:a2c6:c2be with SMTP id
 eu2-20020a0561221c8200b004c8a2c6c2bemr170851vkb.8.1709731932343; Wed, 06 Mar
 2024 05:32:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240305113135.403426564@linuxfoundation.org>
In-Reply-To: <20240305113135.403426564@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Mar 2024 19:02:01 +0530
Message-ID: <CA+G9fYsAG=7Fx=8JZQPLqnSVWqU02d1DYn-GiajCND0xn_c+BQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/83] 5.15.151-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Mar 2024 at 17:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.151 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Mar 2024 11:31:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.151-rc2.gz
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
* kernel: 5.15.151-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 7466986e020d2a56ac0fd1d1768eb9c01119f652
* git describe: v5.15.149-331-g7466986e020d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.149-331-g7466986e020d

## Test Regressions (compared to v5.15.149)

## Metric Regressions (compared to v5.15.149)

## Test Fixes (compared to v5.15.149)

## Metric Fixes (compared to v5.15.149)

## Test result summary
total: 92511, pass: 73909, fail: 2625, skip: 15908, xfail: 69

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 106 total, 106 passed, 0 failed
* arm64: 34 total, 34 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 30 total, 30 passed, 0 failed

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
* ltp-cap_bounds
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
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
