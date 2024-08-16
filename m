Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D54137903
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 08:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798038; cv=none; b=rCCJMI2d9EIXZbNBe2YLswkkMP8vG5jfoxZ3SOjagUXkwQ9f/uE4g+o2uw/gBn0THMirZlTmTNaH6Qjbw7nHUdTDWPWdFd9+WGmJLkuEZJ1M0ykMNwsma923PbZweEBV4BacePTOX6O/NI72tc3umuKrWcU/vYoMs5AQLr11lqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798038; c=relaxed/simple;
	bh=X+mXAbQqboRcObqzKQpaXGDJkEEX7ypQ939Nh+mB3n8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NGJvd9LutlWzY1yz1AAjlayeX6pARjUFVb9qtBS7XKvG3Ull++b01xruYV62w92jhgnjn8Q5jb1bwfoE2MpfwVhqGOYBah0ocrEOTXdNnUqN/rPhghHStFx0nCI5jo/NTZiw2Gvl25qHhqGhXUYSCnI7tw9euHH8k3bs47cwaXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xw6+0+r1; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xw6+0+r1"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52f04b3cb33so3908565e87.0
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 01:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723798035; x=1724402835; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y1wA22C8XYQ9wdJsqDDaxVdz3LjGATSDMDKJ8K3/NQA=;
        b=xw6+0+r1ApFKcyR2DWRciDfP5stzGpoALdBfo6woKd0tvDXCDACqBLP1Y1AEPO46iE
         l64k8pVwD2VLDPimYwtGUxBZ6VxRCa2wVIqhtXkbCgX08VArSfTq8Lr3F1NiYDHwzUc3
         zRyXoKKR1ENJFkiCb/+eceYW3+PA8Bhdg5ux/BdPAIZiKw4VM4eOy3yt1Fla7Wby82Y+
         /o92XznsRQdLQ8ZR6aW17vSPPBXLLLAga0qYgusR6//Hz0Ri+Mcxb55dMrcu/SOB4pru
         r6xnIxAoM/tHePKpvLNKR71NSepd29qb4i2Lu0nAHEnOCuqp2+1AflmGg2vdFtdcm4mZ
         AF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723798035; x=1724402835;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y1wA22C8XYQ9wdJsqDDaxVdz3LjGATSDMDKJ8K3/NQA=;
        b=xHZA8vem3r3HhXKXK1xWGNcyIikv7K74kARFTTu+d7/EJMpFihC3uKxaxNJqqOpCzR
         9PwbUHxKo2jJsouie7pxB3bzXT+kkzmn1c660bONMtGDjIUQzky8cwWpn1/Mf8VSCf/u
         KaNuvzmguZEIYL/zxygxiClzKNYXsToUU9TJwa5wPKTFOA6an/EidXcg2LPWBXIR9yKc
         +Spcq6iIdJmd/m6n6HwNsy5xqsii8GV+ItqD2Anc84GIYTnCcKYbGfCFKn0AUav/B2lt
         6F9ThFPBxWR4e9q6nlHJe/JGNBJ5+eeOjfyCtfQ2ea9rcXoZZ9zlukgb6Vj294NCxsXC
         wxcg==
X-Forwarded-Encrypted: i=1; AJvYcCXlP8aF0aaeJzRxODMKazgu3dGI5bj5xclKIC43SXMTF9zHvpt9u0gBJQf0g6mKMfkMiwDf6v6TbWqP26zKLWREqeAkbyxtnA==
X-Gm-Message-State: AOJu0Yw0zR7Pv2yQjpHDiDUnISgjUdoT4I9zYAcdz2dDN4QY2524CJ/Z
	Dj+JNK8xHRMeg1kzswsm7U2pz/XRCN/K5i/dVsYW6i2j38Hq0geLbBFHVK9lu+5CS5WIZXjKHeb
	lhyFFdmmgVt2dFJDapI/XiVOcCetbjca81uqHcA==
X-Google-Smtp-Source: AGHT+IF/yq4eogQpb+KVB6Upi7DipVo81AdBqPCKVZbN7W1SoDT364gYIxNe6Qhgng1hz/D+R0Z49KDYsGPcDoS7noo=
X-Received: by 2002:a05:6512:2346:b0:530:ad8d:dcdb with SMTP id
 2adb3069b0e04-5331c6a1931mr1836355e87.19.1723798034663; Fri, 16 Aug 2024
 01:47:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240815131838.311442229@linuxfoundation.org>
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 16 Aug 2024 10:47:02 +0200
Message-ID: <CADYN=9KdnuT-ng_pyL_NtB7vuYwBRyFxBP104QAGJWtMjGT-pg@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/67] 6.6.47-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Aug 2024 at 16:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.47 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.47-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64 and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.47-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: f44ed2948b39fed7ff60f13f1f4d810c88380e65
* git describe: v6.6.46-68-gf44ed2948b39
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.46-68-gf44ed2948b39

## Test Regressions (compared to v6.6.45-190-ga67ef85bc6ce)

## Metric Regressions (compared to v6.6.45-190-ga67ef85bc6ce)

## Test Fixes (compared to v6.6.45-190-ga67ef85bc6ce)

## Metric Fixes (compared to v6.6.45-190-ga67ef85bc6ce)

## Test result summary
total: 208016, pass: 181890, fail: 2308, skip: 23462, xfail: 356

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 28 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
