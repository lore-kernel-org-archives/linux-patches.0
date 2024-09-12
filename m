Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BB623D7
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 06:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726121771; cv=none; b=Pjl7PmKw7bNgtpQhZNyMArmVT14x55E2aldo3bLLQhporm1EzWmo0/+lQqMVL9M0dpiP7J378DFHPX6K8PbwyhzfyzPLFCOcE5fRfI5mIt7BRoh0cmBG5DkO/botSvg+JE2B4YezGodE/HQH8rRaquahHrmaEp2bcQ5+s9KpjVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726121771; c=relaxed/simple;
	bh=NSZ0gFhmnSAWkPLIvkThE/jj2vyRHEZgjI1vgLBE5JU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W1QYWJ8TlV71Z3dYAnedFWecxiqe1Gai4u8IjVEnVQhuLjMvO6pVpFCNXxAD9EOJdyCC+aJfsVoyokOR2uoOQ4VOIu/riIbQKOG8Pl1vO8htPxhts79rWJ1FkkWGD4SGLXEtKiSnFX+ONQVEUfd8GZkclQbKRxLThQ0+wgoxbVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dmaUATn5; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dmaUATn5"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-502c8f50c5dso169108e0c.0
        for <patches@lists.linux.dev>; Wed, 11 Sep 2024 23:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726121768; x=1726726568; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PG7etX+XMtB4JyEWMR7RO6+kiYe96BaV75NlxGPDwcI=;
        b=dmaUATn5aqTDAPFP92yN36G7eNqpqYMnhBV/6Dp1T29Cg1ENCNsDWXxVaGIX9HKPi1
         UJ4HfAyrXbWBsQpwnukSiP6hI2CHTE4LcWL3g8JauoPwHN7y4YY5wlMBhYKGxkTVi6l5
         yamwB0u8w6QxfnIput+ZidtbfAf8rrCINwO02HBwOirDlX9YJ31kiWRfZspKn5oGhcM4
         sdgKjAUThGDjPc8HTdc3bZ2b++ttThHc1zdN7iNj0kJBI61oV6mlLCiGp7wvwo2wUnN6
         NHsh6SuFACvT2iPzjr5bsBDQUUbY71ADCRRgH0Hjbo4Ny4l01XV1PwnTX0ei2Znx3sxG
         qLHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726121768; x=1726726568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PG7etX+XMtB4JyEWMR7RO6+kiYe96BaV75NlxGPDwcI=;
        b=s19r8rT6kHrIhqdUpCaXOaw8bga2KkUutOZBDmRQtRc1Z9mfXq1D9fXte6KDeouEck
         5aBAGj9WeYDwnDuQEehno0AvvNKQDSlsHXwVOgxJ6cpn1e97kRdw3SuNCJaEgIuoo9k3
         bK2cebVykXalVcBIH8HrZRAlIMWXe8bItWENcfa09n06YhCQNDCyKGwCB+ytWvdqsllJ
         TWckUAyph7BsJSJ9alkS3CS5D4FihEcShRmRUP8vOZGgYPw7MIjUrSrrVC5PT99L4Dnb
         0VLlBaWSTv2qgGwqgIS+Jf4Hb0YUDNiyalC47AFgGlpbNL080diKcHmgdvykMMIlDaFw
         pozw==
X-Forwarded-Encrypted: i=1; AJvYcCVJ302PtkuflIy9mGO9yK6I+qhTmtCPlKquUFRbCoMRlvO4Hb0AwU9sNjCksL3we2rZkbzXFdFL@lists.linux.dev
X-Gm-Message-State: AOJu0YyB3CDy6lySc+TUPZWPEoPb106Xu6zlvDSlx2qTmy/OZZuKTvpW
	GNZLOg4HjJ8g26JduvMGOVdHRGAbkmG+uAB55lh1ahBuTcRuRyQPAOMwxc2QSsq6rS0LAf8stJY
	FpJRijgk+cFxQFlqQIAowAhvxVMQHOIZsQHfMqg==
X-Google-Smtp-Source: AGHT+IFnKBv5XJbS0vNasn1Vw2sANTpPRzyj0SqebB77rWvDXnyuPcbBolA73RD6RJwTdHu7xtKHHJGmKaO/CemalcU=
X-Received: by 2002:a05:6122:1306:b0:4f5:254e:e111 with SMTP id
 71dfb90a1353d-5032d40e6a1mr1568236e0c.7.1726121768215; Wed, 11 Sep 2024
 23:16:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240911130536.697107864@linuxfoundation.org>
In-Reply-To: <20240911130536.697107864@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 12 Sep 2024 11:45:56 +0530
Message-ID: <CA+G9fYvzUeEMf98sCDqwWDYksYgvRfpgTABEcWUvmjwE-aGa1w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/186] 6.1.110-rc2 review
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

On Wed, 11 Sept 2024 at 18:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.110 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 13 Sep 2024 13:05:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.110-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.110-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: b844a80a36a118a1da8965067142b0246fc2a88c
* git describe: v6.1.109-187-gb844a80a36a1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
09-187-gb844a80a36a1

## Test Regressions (compared to v6.1.108-102-gbe9ed790219a)

## Metric Regressions (compared to v6.1.108-102-gbe9ed790219a)

## Test Fixes (compared to v6.1.108-102-gbe9ed790219a)

## Metric Fixes (compared to v6.1.108-102-gbe9ed790219a)

## Test result summary
total: 208365, pass: 180115, fail: 2479, skip: 25484, xfail: 287

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 7 total, 7 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
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
* ltp-ip[
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
