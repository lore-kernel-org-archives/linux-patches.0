Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEA4171A2
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 07:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706081785; cv=none; b=KUegYnwU9jvWDH4FJZsJUPYh551uDbADULDRIaV6UPukawCQ9Mt5zcWwx5VRzbmCgDvoCfaNz6Te1MvegCJ3jjTF0PXiGOoYnXdCewMYJ/kc4RvZ/cDBCK11y/pqfd9lRy70IAYILib/qze8tOOtYPFFdUQI4Vs4foiPT6+ANxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706081785; c=relaxed/simple;
	bh=e0BbWjmXTF4mDW+eBPrjFjLN6oi3tqAJ0DmGgPhLp9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VVV8bsZbgYEBOw3BjMhzALmxncH8WViSAj3hh0fGoCvT5AJ8PdmzMQHwtGGnRIbRkwHwMhbKxwgeqP+AKqoBb4MckxXU2x3QyjcS2GAHHhbG9KKJw688bg3eVAgsJys/NSu4YSDcLJP9sbKGTShoXnPvGijXfGqpQURn0oLaQOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D/cZ0AKL; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D/cZ0AKL"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-469531dd926so1174173137.2
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 23:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706081783; x=1706686583; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+tnlKPFQfe226jCabO0DUQvdKB30ImwOaBg4mp/H49k=;
        b=D/cZ0AKLMDjW1i9WZg0TEAr2VJNHDq5rwndnpMuOjLNcDB1QK4eIjv/2uPUW3aClti
         +6qH2uBgHGMpEPomOhFQVFUqP6CTYmzolNIAusfAaFpzv1LdUgnxbNCdO++jqGd13ZvS
         B/1DL2nVl0rk9Ea4AAp5XYc609hwHa/qP9jSxRm3j/RPujzUDp/gu4J9LvQyxTq8eE7m
         3FzvPYRgEqzBmKFqqfZedT5nTKxQoH0BdWuurPWc2CQhQprhyDhKC2Te4VnIzYHGd8sD
         zKSi2S1ZRZIUzHWUX6lfnGUCdPtzmfZU2ab6YhgysxBaiHfomoOu5JDEc7domz7/V3gJ
         8b1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706081783; x=1706686583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+tnlKPFQfe226jCabO0DUQvdKB30ImwOaBg4mp/H49k=;
        b=Xyv5J9WXXfO2iYko1kiKNitwZAE44yZXsTqzS38er/0yUKQpPQzf99QCHee1Okn66E
         neZHWNFUnSsKnZlc3k3x90wn0YWAjiJOz04G7+Ds7B2xljMuhjh4G2pKXbnkzAHXd8Oy
         imhjPtes/8BzPC21kT2kUYxuIQN7bOvxAqCeA+00vRJGM1DC3r5NWByGggaif75igslF
         cEqFiUsaHnvrNOU9gI7QHtmpyl+tDWyHosI0qVS4+8Uge61ikz2u+sEZirtSVrvBqoer
         wujiHfyMf5sNHHKDDFLtburCQoUEt7qYhl18uGc/+490AAV0NMSHcvLYaNVWTO93npbQ
         dKlA==
X-Gm-Message-State: AOJu0YxJGqECfS16uH9Y3keRdfWYUxfVde4UQmJlj45smP533kwlWCa+
	eSEPsT5oNBMtK6zf/2f2AhctDTAc17Smi2uTMngnxm3W7Tkew1utcxARcm77QCAilKabPkoQ0Dt
	sCVQgH+jvrnW8pesrU4tWUN6s1GkOGE/KYbxfCQ==
X-Google-Smtp-Source: AGHT+IGFlsBJwlAN5HEFORTByTKreth26xjwcga15o9ftsYVovMY0UJ34jdMY7lM6EopfZGcrjAIX0tjKN+xMDljZEU=
X-Received: by 2002:a05:6102:3753:b0:469:bcbe:b10a with SMTP id
 u19-20020a056102375300b00469bcbeb10amr3503077vst.2.1706081783017; Tue, 23 Jan
 2024 23:36:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240122235712.442097787@linuxfoundation.org>
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 24 Jan 2024 13:06:11 +0530
Message-ID: <CA+G9fYvhkpjBgZ8XaSVJ+c_cdOU3=PYxDK0u-1Q1BaKDsVQfFg@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/148] 4.19.306-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Jan 2024 at 05:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.306 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.306-rc1.gz
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
* kernel: 4.19.306-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 7d9c60a8fe13297cfc26524269c271688d817a98
* git describe: v4.19.305-149-g7d9c60a8fe13
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.305-149-g7d9c60a8fe13

## Test Regressions (compared to v4.19.305)

## Metric Regressions (compared to v4.19.305)

## Test Fixes (compared to v4.19.305)

## Metric Fixes (compared to v4.19.305)

## Test result summary
total: 55285, pass: 46655, fail: 1600, skip: 6997, xfail: 33

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 114 total, 107 passed, 7 failed
* arm64: 40 total, 34 passed, 6 failed
* i386: 23 total, 20 passed, 3 failed
* mips: 23 total, 22 passed, 1 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 27 total, 26 passed, 1 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 34 total, 28 passed, 6 failed

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
* kselftest-kvm
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
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
* kselftest-vm
* kselftest-zram
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
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
* ltp-syscalls
* ltp-tracing
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
