Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF421FF5F2
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 11:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731497310; cv=none; b=Mki1zGEH/ZvL/VExqBsaIOZ0C9ZlnO71O0co7W0h1wbfgyMysnaB7+6tddjUAIfAHzkGp3TzGvASPVkzef8XQ40bDEiUvwfyvoK53vfVLBoNhCKI/zBLSkwKGazL87YpyWnDs4+KmmamZ9sYaOA8LLCdpgU6I6CzJK3jHjoQyCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731497310; c=relaxed/simple;
	bh=Vks9sp8KQO13fnVv1WgRw4i3Yp4B6y1XL2G/W8zMSNw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ahaPzYMJDXmwYbpuu4jwQ9rHV1vR4CpmPpR4Pd+uYRrwii+Mfrfbp2FGv2asHBOKUymzGIJigDYVeqtbhoXL3R+EBIFbVKkb8AV5c5f2pz+OReNZrQhbI/1iHgCL550Chg2fNim3iioxmz+AWmRTYf6X9GcPumOUS0/fR1sB0gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XSbE3dkL; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XSbE3dkL"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5142468fa79so1563747e0c.3
        for <patches@lists.linux.dev>; Wed, 13 Nov 2024 03:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731497306; x=1732102106; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibM4ruWPAege2vfzEi4k/k+Sw2PCbdPHy12ELWoxDXY=;
        b=XSbE3dkLhS1UL1YumuuadFc+k0nzpV/uaCFr0pzciJzH05c5YGo8mmUfRUEN78kdXZ
         usCsP8FJ9pXla1ZVdJhvllMsqXn5HMrx/867gvc1J+2eFSFTOlXdXxxTHEmOCbMnlTgm
         OkvlltEoZgRw2MQByuqGmqJiZRinC3+suU6Zc/paRDJbdVGJvAgAAoyK2y44nhI7vMtl
         qPwZjPji2UbNuf7aPUtoY4r6V7AIuy3LoJU2GR3pI826WLJMUUdFP2Sl5e8/nB2cxJsf
         Kr3zLTS2pYimvk1Sqo2zWPZZlnJ751ttkObkeGWTNObmaScFPXC8Rm0Cs60ruriwx7bs
         B3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731497306; x=1732102106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ibM4ruWPAege2vfzEi4k/k+Sw2PCbdPHy12ELWoxDXY=;
        b=JRTKtOzOfB32Npp/TGPGIS1IKlx1opjFoVwPjv2wD/6Q9UQTLtWK1ZAp3RgUyJcD6O
         cGRmrgc1R9NOVUBjEihxi7V95G1mll9yE08t92pjCUt2Bwd3ccMd3MbNE+GQ8AFSb2o1
         NycEQ5/Xde85UbkJAH7vryTkfdCj8A/BwMlTJXiNxP5yVqPFxQjozy7quFr47cW45WcP
         vFFcRM3LZ2Qd3PxVOrKMnOZGtWLPpQt8UBdXt8j/4tRyH71+xekVC0X6CZxxky8OKqRl
         b/+zWLaKSEdTf02lTkDBIoJuwhWBmwuV2XLTN4o5fjZgAjo+YvdwjxQ5U4tLw+ugjxwo
         blpA==
X-Forwarded-Encrypted: i=1; AJvYcCV6VuHvQ2kqfYEBJ0Q8O0gkps/YIHBulR2P/RO4lOG4ZIaa1K84rTYuqptX1ei8QDNtbtMzyx/p@lists.linux.dev
X-Gm-Message-State: AOJu0YyETJ8M+kA7z2TCyqZG9SglJ2ENzRxseN/mH2IGRekqq7MBePCw
	cc/AvoGLFPyjsmP5Zs7+EA9CR/z4pAELAHJFwNPuctWFK8MXL07nBiKK/ON251iTksvuDfba0dE
	rxTmGEXk3Yk5+cQEgkJIoLaZYJeBs8d4jJt0RbA==
X-Google-Smtp-Source: AGHT+IE5XV1UJGSOQRX/qQMMlLJ/XPYR/3FEYamReEoaZPK8Bd0yQizWVt8DCQvzbDo/J6sVtG6e0r6gr6tGnujdFVQ=
X-Received: by 2002:a05:6122:32cf:b0:50d:2317:5b61 with SMTP id
 71dfb90a1353d-51454270f84mr2974738e0c.6.1731497306370; Wed, 13 Nov 2024
 03:28:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112101839.777512218@linuxfoundation.org>
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 13 Nov 2024 16:58:15 +0530
Message-ID: <CA+G9fYtM3KGHE8boa1nvhJn-JNTtMob93KGubiXA+f-ak0OSGQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/76] 5.15.172-rc1 review
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

On Tue, 12 Nov 2024 at 15:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.172 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.172-rc1.gz
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
* kernel: 5.15.172-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 0ef052d947fe31190128abd44cbc8cebc7657c48
* git describe: v5.15.171-77-g0ef052d947fe
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.171-77-g0ef052d947fe

## Test Regressions (compared to v5.15.168-239-g7a95f8fff07f)

## Metric Regressions (compared to v5.15.168-239-g7a95f8fff07f)

## Test Fixes (compared to v5.15.168-239-g7a95f8fff07f)

## Metric Fixes (compared to v5.15.168-239-g7a95f8fff07f)

## Test result summary
total: 100973, pass: 77106, fail: 2830, skip: 20889, xfail: 148

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 203 total, 203 passed, 0 failed
* arm64: 57 total, 57 passed, 0 failed
* i386: 45 total, 45 passed, 0 failed
* mips: 44 total, 44 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 44 total, 44 passed, 0 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 49 total, 49 passed, 0 failed

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
