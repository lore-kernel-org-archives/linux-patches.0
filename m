Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3692D022
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709131637; cv=none; b=YXmk0snztxBbEwJvLa5AB3AOP5bvJB8u/PCmiqX6YVO43/DV4ONre5JZBTG5kh8ZCDf/2s1WJ6KanbHesbtUrLkKf7AdyTgIuxyIbYjbGeJzvMlw/xe3kqem9CsVOKoPrtoRTKuAwtDjwOS09ErXFEWfti7zaV6IjhBMI8mn554=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709131637; c=relaxed/simple;
	bh=GSUDTICY8C27ijnOdt8gTGfv1+oA5wxqKyWyUbVbLl8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=COs1hSoJ9GvXpNrKM9rvwIU6DA2fTbw4PdK04cYgQx1WYDwSmbOOat90+d4FfPtoR07JiLiGhNjl5r18OQsyDbLORQ3FiCIqj824XQgMoPyLdQdKrCH5eUTsEhz7CloqdBHX1gjNsrqFJd6f/SBe+cYG4idZ3gB+LLTF4mPwH+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zx4FJc5B; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zx4FJc5B"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-4d33829e9ccso330402e0c.3
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 06:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709131633; x=1709736433; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G0T5YDBQ282f9/2GXVWlIN3H27ES4N8CI9531Muv6sQ=;
        b=zx4FJc5BqGsBwV660pOR2KEwI9nibWL92XR8YIMl+aafn6rNaKWKhwSVUIc+bQp2Zo
         Zb0UNUQ1cCDb3vsSwtwTfXHUSdQBckhpcagtjrJJWohC4YVlu1pWa5+uh/Nn6PGgEj2N
         /hd4zCcAdYtHXmLn67kfvJYssknaQIuIMo+htcVbUu+MrrsYtptGlnfHlIseLZKlOfXE
         Jl3qgiZIZuLqN2XHOQPgIB8BkdJuXl1O+clkFp4MsNEAhk02ZsPgdILjyjlPIust9VWS
         ivW+pcjlAiZ+gTtDdUNV5W3AD6weprqUFAaKaDVA1Wi0k3pX0JG04XESuCQhHo9zOKWh
         HooA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709131633; x=1709736433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G0T5YDBQ282f9/2GXVWlIN3H27ES4N8CI9531Muv6sQ=;
        b=kV/6z/Vq4niP4uDKIzLNhftjbIxlG8rJ4z8FhlegsxV5FgVL6gbLFU5uCsONXCiSf2
         P9tpCmPqkRqJ+Tm9/dXaB1UrQPuf5u6rJc8wFx7fOtaSI/gPHXIoorsq3+aRZfat+DNm
         OG3HCngkzTCSip4+Msv5qgjC/6Z2fv92tUPfWgILv2Aky7tmfec2H6kpJVuqwQQwG7An
         h4pjkklcO7wsLTJUvMoy/IMu3+RIqpMT5uw9R6VLYRkPcsSfGx2fhNyMRvU12aFunoVH
         PMpis9LBw5i6l+rv1qGVQx70NpvcBjtk2sL0YU6NdnXjKh9+JEXY7w7L3PrjwFZZHG/p
         hn9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWcLtOTseACIbas5DjzqMVTHu1WjeQPaBBHZh/+eFwOSnf8S+JC4yMw1zhqqC3VK2pQUwlCtHCQG1He7Xx6jegOIYlHGD4rgQ==
X-Gm-Message-State: AOJu0Yxi+XtkGttdhETdDqt3DXW7xWByjti4HuM4fDBogVAogVP8WwlJ
	mof8rp2mugSCwN9EJHaPVm1KVC0/SlHXbFt5GXBoy+/ydda9x8A7N0L2QF310HgA2D3xtbYsMwJ
	9S2WdNgHwi1ZKX8injdjwD5rmvyHloVcWp9C7Qg==
X-Google-Smtp-Source: AGHT+IEUFGTJnvQ0yWRemsmFVF6KnZXwWf015zjxG0AplIMTRp+lycSyzH+19ULfMMZpPzzciMODnQuSAtywiJBADHU=
X-Received: by 2002:a1f:c844:0:b0:4cb:56c5:5816 with SMTP id
 y65-20020a1fc844000000b004cb56c55816mr9250516vkf.12.1709131633465; Wed, 28
 Feb 2024 06:47:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240227131630.636392135@linuxfoundation.org>
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Feb 2024 20:17:01 +0530
Message-ID: <CA+G9fYuQ53GqKnWU=UokDWzZV9Z0waH4UDLaLn6mrMRM4A18=A@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/334] 6.7.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Feb 2024 at 18:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.7.7 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.7.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.7.7-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.7.y
* git commit: efce2e6615798a9e83b7a4798f3713414938ab6b
* git describe: v6.7.6-335-gefce2e661579
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.7.y/build/v6.7.6=
-335-gefce2e661579

## Test Regressions (compared to v6.7.6)

## Metric Regressions (compared to v6.7.6)

## Test Fixes (compared to v6.7.6)

## Metric Fixes (compared to v6.7.6)

## Test result summary
total: 264420, pass: 228013, fail: 3651, skip: 32434, xfail: 322

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* libhugetlbfs
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
* timesync-off

--
Linaro LKFT
https://lkft.linaro.org
