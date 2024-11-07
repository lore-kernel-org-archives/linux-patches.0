Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECEC15B0F2
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 11:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730979966; cv=none; b=W9Tq/vtIa+rcDeCbcvb+eUHL8FNDIUUBWPqf4fbDRTEfTiTEt72OwQoFbJ888fg2XsD6s4GDq41io3YwK3PLEe09BY5rNdCek1DDjWIkItCewWutYx2HB3GW8QQZDSqgHivHM+uXDudJLn9DqPgvg/W4FcyQDlXL8k1KoC4sjNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730979966; c=relaxed/simple;
	bh=wC0dbBRtbrAeN+fJ+d/gH5t/Z+cCqsSulIC2DhQYfT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uA1KgEBxAedvasAaqeoNSZrQBsoNt9GXA3iPHXdZPcCRNgtVMCEzQE5cy9/NgqxU8XdaxNKZ355AZwKF18bOL8G1mbVdwvRdv/b2Q+UO+d96JxdQGZ3HEXnJINZVqY9sBIQ++y7PX3TawHRv0TJcX6cmdPvDKV5tyky2GcPGPFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fVjGesh9; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fVjGesh9"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-50d58e5bfd2so331569e0c.2
        for <patches@lists.linux.dev>; Thu, 07 Nov 2024 03:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730979963; x=1731584763; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCktawUadk5I3Ui5sjhCsvj1qspJCjEOYVbOqkLtmDo=;
        b=fVjGesh9ww/In272WgYCPTAwp6grpGYzEhuqxTi5n7HpsG5O+Qmu0Ihhf4eaqX7dSw
         AmLWRQsJu/w6pnBeG328a+4PFrpeiIzITaTcjdck+0CRWsWsbnw3xmes+VVAJO3Ra14t
         v5c7zl27yl06Zt92bXk/HaNTc3HE9l+AAqNnELC4yZT4JmG3LGMsBRPzt+ZsqRgP2bb+
         Jyc+VXv1tdtXnS/EPTDVenEHCPE54AbhfUREqOzytLaK5Vyy/fV/u4xcPnfDtVHMIG5w
         A8ks7iatcLEkTlzHVyr5n9qfC0GmDyqyXUCv6A5obkSo4oSJ1OTzUnmEzzxxywPFhLhX
         VlsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730979963; x=1731584763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mCktawUadk5I3Ui5sjhCsvj1qspJCjEOYVbOqkLtmDo=;
        b=Sw5W1sv5JGW5IhwHlEj//hK0KmHYgaW2idlr9YAa4oRoOSEW0aSS+3vEx3+gMId/6p
         ivrrvZeLac9cLQAgyZxYHZMzD3WcfUpjx9UuZ3LfxXSWq+luLJ5QqS27vRTIlUMst8vo
         K4YlzCycZNU/jfrrAlG1OfEHO4IMJCtK7jrbJRZCT85NlbEz7/jGelhi6t4JDXItgUhs
         zum+6rywv98Hnj4+deGf54hrHR8x+X6nPxpL072zyIht710FY2cp1Cj92YgmA5RSIyC9
         Wj3rPhto4jUQLpVGbq/K/B3ZPEyB6JrcE32gFCQ9hX9trZr/efQQ1CvgE2z1JPMqcoUR
         STgw==
X-Forwarded-Encrypted: i=1; AJvYcCWM42B4hgnQOjc+k2oGYC7SboGqghUO+aWqk4wZhGs0Q5SCfSTbkerEMGXgPV/bSO2yxFtvn3A8@lists.linux.dev
X-Gm-Message-State: AOJu0YxfwZ67MaK9FQl6iE3e7VuUZI7Igp6bG0Bu8poXZTDSk0zFqxKh
	Mcwsno9wraVg7MzSyzbsaOrtnEJv/oOyTj993Q9EGuBtYQEd9Xu5mULRjTJzvKahIkmKce1DFdr
	dzjxbbInVRLXMChG0qrV6oFT20pXbCpA6V6W1IYpV9yGs38lU86XCJw==
X-Google-Smtp-Source: AGHT+IEwNFkllsRapImy9s6NO7BR7FJd1K8pYIzeIKnABE215cUBZo3UBfhHCQwvCiO9z4nEwHJ1SFmnvxqTSC1Vwk0=
X-Received: by 2002:a05:6122:a18:b0:50d:3ec1:1531 with SMTP id
 71dfb90a1353d-510150e1e84mr42209137e0c.8.1730979961942; Thu, 07 Nov 2024
 03:46:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120308.841299741@linuxfoundation.org>
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 7 Nov 2024 11:45:50 +0000
Message-ID: <CA+G9fYvk8HbUW7j9bDUm1oDZrQCd6bnvRozAE=ZgEk-vhLvKOA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/151] 6.6.60-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Nov 2024 at 12:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.60 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.60-rc1.gz
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
* kernel: 6.6.60-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 2daffc45f6370a4bc2ed3736053d864ad7324f3e
* git describe: v6.6.57-484-g2daffc45f637
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.5=
7-484-g2daffc45f637

## Test Regressions (compared to v6.6.57-334-g02900c91433b)

## Metric Regressions (compared to v6.6.57-334-g02900c91433b)

## Test Fixes (compared to v6.6.57-334-g02900c91433b)

## Metric Fixes (compared to v6.6.57-334-g02900c91433b)

## Test result summary
total: 149914, pass: 123278, fail: 1553, skip: 24990, xfail: 93

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
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
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
