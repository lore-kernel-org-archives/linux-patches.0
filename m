Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD49E181B9A
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 17:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721236502; cv=none; b=k+JYvggj51ru0wxjeybzNfKll6/nlW+RtJNil8BkAtHD5yBiSF6I/eq2A0jf3cbmpTiYSpuUZkuUeVKN5RgczEhtzm7gLrTwO+AllJb50KYtKF2aaHkDXJqyTbqs71ekN2XnbUkZtXeLOKAPo0CDD28fsiDCm0X49R2Vlje1zSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721236502; c=relaxed/simple;
	bh=cw30YfvidqMdAX2ktCxRyPLr2LugrsLeMrCFFWIhdDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h0bZlsBPSEm2gn3rEyR32JH1ovuC+R78hx45T/bXPSnO1wB2AgFc0M82JK2ih6N6Rfpo7xuPAeB4WipRdR1nERXV+iwYFQMOuwctWoLc+AsAd6xMUbn/DjJ4xzfrdeh7n7rI1T8q/HzEcR91DB05eNKwPw6ptCV8f1atDL30+Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aE6D2L6X; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aE6D2L6X"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-821b8d887b8so57164241.2
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 10:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721236498; x=1721841298; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4pDlFW+0uEtRWgzfnhOmL6Q4bRT/kPk7C9hXwCrZE8o=;
        b=aE6D2L6XwUXV6lc5Kr9CS8Zc17LS3zcF6kWG4Hv0XFuG+VnFTtO16n/mDeXJ3HqvAN
         Cvujz8wcjRBnv77jgWJyW3jWFXmzKE7guxGjIDIuxRpKB1hs25R09r06nLLKn+kPV2D2
         EMChM8W/EG4rUeZ4AmWz0XPPWfLWQjkiPrsBYFOqozJN05YrH/W1UeSBBgnKgUDu0M/4
         5rclUnndiosJJk7Sj5+WdA5Ov5p/Vv5jQDzAGat0Kl6El7ffUG1EACyApAiQXqxpNcye
         zohfBXKncWE8SVbkW50ukvh1UfkE/CQZql2PdAyYUYWgGxBMG10udF6WCKzjTuvGZhom
         jMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721236498; x=1721841298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4pDlFW+0uEtRWgzfnhOmL6Q4bRT/kPk7C9hXwCrZE8o=;
        b=Yj9t+KkFWmXyijVwGpg4goatZi3WX1xi9zo97Z/uVzj1QzAh4LZIA24NCgFcN1IQ5n
         88LiQUbTu8VrS/FqI+/dVjGwrdZavfwiv0ArozuKjhai4M7f+1do/BCZNO65qzwFh0hm
         21LA1ekVLbGhGD8VQlcZleJyazG9TUAsTmK/e9PLewuUzI0jRaT8KQ/Pl/m22c93TdBZ
         lZ8WWAr1lOWOf2/ST3cmte7h3cedFLlCFMCW2FI76YBWLl8XeNd6eJJYmEFEXWJ0Xy9Y
         6KxZSfNpF6zTO87ALt2HpfiCiUP4jGn9vYLmizaXLUYiliRuOi2qSuPlcIhx/cfCIxfJ
         bPbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjAWaxlzdymTGZjv/1YDj5HCWo9OicQB55rf/2oT9JxeEzXwlzoNaOjYP+H5IW5QPL1ejP9RX3WH7nXk2LOvifVSSy0CdJNA==
X-Gm-Message-State: AOJu0Ywsn8ehPJlZT+r1V0gDPawj0w3E5Ak1eZ1OjNGjGCENWZ4XmEbe
	eTupSA4JvcyTrHU2/Agt+YkGFssjZStAOhQ82j9ReQVHl8Giv3OfSTUT4GYAiXEu4BH4tul95Tx
	2ZREGMktW4V9574bZZ4CewufHw3lKaSbcKeyfLQ==
X-Google-Smtp-Source: AGHT+IFV2Rs08vOtSHS/pIuDotDwNtFl5dP1U0UR7bwlPlrSRd9Kbn7q6Oa0g3IkIkOG730WdUMEEkNczqEwG3hcXfo=
X-Received: by 2002:a05:6122:d97:b0:4e4:ea24:4c53 with SMTP id
 71dfb90a1353d-4f4df63874amr2705262e0c.3.1721236496976; Wed, 17 Jul 2024
 10:14:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717063802.663310305@linuxfoundation.org>
In-Reply-To: <20240717063802.663310305@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 17 Jul 2024 22:44:45 +0530
Message-ID: <CA+G9fYt51XWL7Od2wno47hEGTiOFYJ2JfhdyZEha7GwjN1K2FQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/122] 6.6.41-rc2 review
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

On Wed, 17 Jul 2024 at 12:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.41 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.41-rc2.gz
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

## Build
* kernel: 6.6.41-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6b4f5445e6e6e806a7e9bfbb1e1e5cb73c0e07fc
* git describe: v6.6.38-261-g6b4f5445e6e6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.3=
8-261-g6b4f5445e6e6

## Test Regressions (compared to v6.6.38-140-g3be0ca2a17a0)

## Metric Regressions (compared to v6.6.38-140-g3be0ca2a17a0)

## Test Fixes (compared to v6.6.38-140-g3be0ca2a17a0)

## Metric Fixes (compared to v6.6.38-140-g3be0ca2a17a0)

## Test result summary
total: 140936, pass: 122778, fail: 1053, skip: 16932, xfail: 173

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 126 total, 126 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
* ltp-sm[
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
