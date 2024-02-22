Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE9F1353E2
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 15:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708614987; cv=none; b=oZwxKG4jkw6FMEZ/M055OCEgYnDFqZJ8MMo8OCN9vU8Fgn/MkKXE7OYLYLKbFhovRFBeyhm2USO86vlE0d5cTgvOgfWcO5nL6waHMEueCHgLeIkGwMTEOYq1lUmojtdLaet5f3HYzfu5YHEcB5wpb1fR3jJtCN0fF/4bIitvNSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708614987; c=relaxed/simple;
	bh=icxcY8uc+o2IJThcPoIsSP21PpsdAb6o+f7z+Pdo2xM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I2btU7fjdu9cLuNpBFuLGuQMKj6DCtwgiSPAH4Wv0U2iHUQNG4T4HOJrwehaeear7EahwqkeJfyMjuieREtg/eMuxQX4UEeLwm470Ge47aGwhBevxzRnu66gXyo1WiWq50V3mCT6ITeL0r8NH1+ZKLjeGCJz3MSNMTzsoZYZGL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G7ONIskG; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G7ONIskG"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3c02b993a5aso4840472b6e.1
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 07:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708614985; x=1709219785; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uOdoTYWG4356EXT02DJVT6VCmhVf4Pj9aUeOKw00wQE=;
        b=G7ONIskGHk5tBDQPd2j6FQtpCKqVAt2WChfWOJAJLNV/6+9ZEYZewET6QKWnemIo3S
         +B0QVBQPqqe+5WvMo+PEvdK7A/scKqNg+f6JuaYD3dyjA2p4g8H0/D2nuYGsJhCbzu3y
         OunaCuXeaWvFJahCLI33Sq4fVdoZnq+6inPfwZdRLWs4aAqkPhzCeUGlfzk0N/nvgW6G
         rxoQUOA1YF8T2Og+rImUiYiCGvS9S8QtRjboi0sUI/KjcXmWodXNWEk2uJDoj8LoLtlj
         m5veJKdKBHpYkjnpYdXRCz2kMaLcbiRGvxLJ4jtt17FgkhM1Rf64qKDTbkjvlAod7qUq
         LV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708614985; x=1709219785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uOdoTYWG4356EXT02DJVT6VCmhVf4Pj9aUeOKw00wQE=;
        b=XbOYo7SMBcD4CJ9Ui2+X09NLQ+DkVicO1P0Z1mqiIBsK+OYVPG/GZJIFd2u3zHMrAz
         GqTjTp+mQ42GiNJe6hBnHZkyhD653yE4jgaOAc58jc+v5wxYfcuX71pEAc3mANEqjWF0
         oWgyMoBOobZyLJSBIpIBQxd4E4ni8/8NYlHyp4ZzHFkLdRcjJ6Fv0nMeVaoX+MxO79dS
         34Gz2XZ9LbCKuR84pJyXhJ8HYUwwzf676Wk3R5RV24840vs3H5CMjUSeHw2o6Aw0fgW4
         /Pi/Z2pPvgcaaYLn5ykyrPJ+JQ6evz1c9LE400yOhl9pUGSYS2a8wS5u+yEmaaM+k+HX
         ZKsA==
X-Forwarded-Encrypted: i=1; AJvYcCVu2vFMbbNosq1dGoa/C95z0OzTQyc25INhi4jnbJL3tcF45CF7dmhXMpboj5p9Nsp+b05NocmxEftMWmLJI+JCwec9m7n/Jg==
X-Gm-Message-State: AOJu0YzrwCZoR1ngbdymxA61t2yk0t4x06QRxlkXTeubHL3PQQD/9GcP
	6+0tE/2cK3ZLM2ecTilveZpqlr9xNDl9kP0h2XqWCF/R+Gv06qgjivk1sE7S9iHwm0hB99/ZIdE
	JrRC+vC99eTUXXYMx0qUptVCoO3i/78ULlO1uQA==
X-Google-Smtp-Source: AGHT+IGCT330ABEop5oo+JQQNQCzzjy/J0/pVrUJRTO4UAFq1whof9j5GRM6HGVl3q5ruQnmMDsqA0wmrtK8eiuZQa0=
X-Received: by 2002:a05:6808:1719:b0:3c0:33a6:bbfa with SMTP id
 bc25-20020a056808171900b003c033a6bbfamr23615419oib.48.1708614984711; Thu, 22
 Feb 2024 07:16:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221125931.742034354@linuxfoundation.org>
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 22 Feb 2024 20:46:13 +0530
Message-ID: <CA+G9fYsch0VPsmTTfR-VN+RDZCNC4F=3WXiN9KuK2yNWTK0sMQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/202] 4.19.307-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Feb 2024 at 18:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.307 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.307-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.307-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 05a45288956cb4f8bd2d47d10050520cddfa9063
* git describe: v4.19.306-203-g05a45288956c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.306-203-g05a45288956c

## Test Regressions (compared to v4.19.306-165-g6d7461510b51)

## Metric Regressions (compared to v4.19.306-165-g6d7461510b51)

## Test Fixes (compared to v4.19.306-165-g6d7461510b51)

## Metric Fixes (compared to v4.19.306-165-g6d7461510b51)

## Test result summary
total: 58627, pass: 50543, fail: 940, skip: 7095, xfail: 49

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 111 total, 105 passed, 6 failed
* arm64: 36 total, 31 passed, 5 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 20 total, 20 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 26 passed, 5 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-lib
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
* kselftest-user
* kselftest-zram
* kunit
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
