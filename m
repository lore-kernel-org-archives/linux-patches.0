Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F275C2F5331
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 17:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764870959; cv=none; b=RksJyg3ZMlJuQ27FVIe0fKby6B+55XVgFmVmUK1RmpOSZ+dVJ7s9uAP95S2AGTpPm6JT+SjNbU9EZefZD6xnHHh04sHehqTD8j9TCxUU45gXvFj19yQBJvw7RHa9lMU7Dc2HbVgPYvaU3WOedzgX0nUV0K0kYoaV4py4rPdmzII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764870959; c=relaxed/simple;
	bh=5vLgtYok1A8ceoMP3lg7slRGOGBZ0jrvCBTqvED1JBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=okHbEzcQIALPr7lDSZsdNrLltvhZqR903hQU8hMyqRqbX46sxgV4NQI0sp5eiTS9E3fjyQEAk055qpB1sezWMBVFClTt1lc35uDLxhCvBMEmHj5xrcjJWl3VUEH9+t2b4Fs1Hzdh1sW9jVbyuFP8k8GwcB2v7o8TTuAHpoc4ExM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=fail smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XbZfmVBQ; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XbZfmVBQ"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b98983bae8eso972227a12.0
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 09:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764870954; x=1765475754; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q3c4WoOG20J3VvX18sn2KxsV9WDaKR21PbQ36MIoHyA=;
        b=XbZfmVBQ2s9YCHze9eagIzmANNY7NpifICgvlUihnUv6yfhToOXDq9gfQFOo5kXFmy
         OqkhgEejrEt/gVUyr45Sb/g+KN9/BhMotgcHC+j3h2kVya6HeM2cSxRY5ZKmqO2O34zZ
         sCD7l6yC9T0AtoNMsR3WPRJJC1hgNL430pk4SC2BYH3Kk4XWrsQkT1LGX3mM3seuy3AY
         qOIVIv7La5VMMzUHauEtmOutUgxhkG6kMp+inweeCsOIEFnBfUVfmgyQjIdiNhmCm9bw
         Rm1FbDgKgwbjmqHf2hWDhEOhWQ+waqXRsAM3VaMLs/VbVzaMR8HTou7IEzHlkcOL9akU
         7Cew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764870954; x=1765475754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q3c4WoOG20J3VvX18sn2KxsV9WDaKR21PbQ36MIoHyA=;
        b=dIy67R7bY07BQtj8nmS9QsdEpOAGcUCFjqiC8zuoRW1HdiBqBakG0pAGHW03yOkKqA
         etXrbb1NBe5izI6EK/DZjBtkYSRVzVDMl2pzkfjSG7x5hJCbB9+WQiR96NV15ehDWQ/y
         Nfr7pO10G67TB94QACyEiHBcjYZh66sdbCqZNMRyySRjDlMXegL+JBEJB+Zaw9c+oh4I
         f6By7oprAdMdeI4gd3s3lKyBLGVER+fyOQco7yHBgaRejUmkyvFo9jezIpaNvChGvf0M
         5GAMOOuTXKinWLyMNTIcqV6WXBwbQ2bNmU9ak+ABPuFORA9iikin2I2BbicWbFRog7ia
         TpWA==
X-Forwarded-Encrypted: i=1; AJvYcCXSxNQJGJw2P6Y9l5aZ8xhP66bu4IXAeG+VPpLeuGqv4C3nam9ArR8lyBV7696VoiLVqCHMyz3I@lists.linux.dev
X-Gm-Message-State: AOJu0YzsrIHWmxgwRd5lBmA4Cx771AJpCETYf7LFFRzJ58gin+4Fzn3m
	0vEbwurK38AO+uE3iackfu7DIzNAFAyhcREOld5zl9DrLwm0hj61ZnLofLUg/cPnUzFCddAmVH3
	KR1nTBFWNBAkx7iv0jDgvr/7Hjh5oQvK6l8Ff16rX7g==
X-Gm-Gg: ASbGncuBEAulSQkueue6d9zGN1/330e+O4pdz1hqE3cOzvaB7j5Hmm+ZC1WbhYEg4dr
	B+v6ed+US+8+v3ozmLdzOZoyiPil+lnKByEpSNYMKBjQu0eeSbc7WB3M7mEwVRrNgT5Nsp/+b6L
	kVBwXJmxA0OVJbxSeE7LRhpTFUrWcnu6N5a8H+NQQwh9dq18420Z6tunXcpp89hG5mnpxFfoAZ+
	+yg2FgxZo7I0BgOhtDGeqZ0DfmMo56XqS+AEzWBHVkU+xWw1qkV/swN0jyAfd1MsnD7KsnME1y5
	6oT6AIxX/nX0HjolIb/leZ9sbjTY
X-Google-Smtp-Source: AGHT+IHCerma86MyvJK9SIrNon7cU+mRDt57gJnpXxtskmuXTz7OowKZyHDV6eFnHDPTqEMYFwOAeT5h/i4kA3917fc=
X-Received: by 2002:a05:7300:f403:b0:2a4:4e40:7c89 with SMTP id
 5a478bee46e88-2aba44fe0ecmr2654885eec.28.1764870953779; Thu, 04 Dec 2025
 09:55:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152336.494201426@linuxfoundation.org>
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 4 Dec 2025 23:25:41 +0530
X-Gm-Features: AWmQ_bn8KWrUmUf22xvnCznWOUjCV9YFp6keyqaUF1hgEJJzjp5DWV4V9B-mFl4
Message-ID: <CA+G9fYs4g-3C3UihfxzLzKWsidKaKJh8usp1gJ9_A=oTRyP56g@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/93] 6.6.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Dec 2025 at 22:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.119 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.119-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
allyesconfig build errors:
 drivers/leds/leds-spi-byte.c:99:26: error: variable 'child' is
uninitialized when used here [-Werror,-Wuninitialized]

allyesconfig build failures can be resolved by a recent proposed patch,
 - https://lore.kernel.org/all/20251204000025.GA468348@ax162/

## Build
* kernel: 6.6.119-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: cca93798e4cd9365a29b85a0d56a0332912fdcb8
* git describe: v6.6.118-94-gcca93798e4cd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
18-94-gcca93798e4cd

## Test Regressions (compared to v6.6.117-87-gdd9a47301c80)

## Metric Regressions (compared to v6.6.117-87-gdd9a47301c80)

## Test Fixes (compared to v6.6.117-87-gdd9a47301c80)

## Metric Fixes (compared to v6.6.117-87-gdd9a47301c80)

## Test result summary
total: 111140, pass: 93968, fail: 3457, skip: 13425, xfail: 290

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 128 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 14 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 34 passed, 3 failed

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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
