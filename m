Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E509C8827
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 06:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718434033; cv=none; b=TEOpDkcFXNf7ke+dT5GAwKCETeluEPaVSwOsIeeJVccB3sgdclkSlc/grSk8HOQ7++geWGlQRpyD0xI/kEKOA19jmCmrB8fxbTi/ld0VqhwNnoRcp6dnicskQ13hFyRv3ESMu6OCxE5u+u9imixKWZQFxzUXm+99XrclGoehs3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718434033; c=relaxed/simple;
	bh=znnbojbn7bV82M7iK5JAhEnZ3lVFFlNFEcHsHJkwCKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZwbWqTc0q7uJONIsAXLukVxuvBliWdDg5Ejs5WLi/vG/djmcwq9573oX1Cdxw6CAE21SxL2NL869jJ25VoyPhPNXv1np4BvT9a3Ew/gHBPWjWPuGQPSNn8qt9BfcMsbLrLmQh5lq+ax2z4/F+ACYkx7wXXsjDcWFfQQCmK55OqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cnfIb0C7; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cnfIb0C7"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-4e1c721c040so997028e0c.3
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 23:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718434030; x=1719038830; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y4RbldOmyuB3cQWDkIPG/+2f11O33ZLaDT0kxFu1pIc=;
        b=cnfIb0C7od+MrSgRQ4+p+HuB5JKvuLdd5N4QLuFSQW3U7XqGoBJaFnXXbtCbN2nsTM
         09YIGuoebnbNsBMOCwoY1u0iB3CfTmtJPuFccoocq+hVm+o1vFsmXaAaMZeu260nbGU6
         1Je49T8FjfzBPADpQ4L9lBKFb64G65f5rCrC838jbodL3Qg0tLfN+vohjyeASqXgyrTK
         0oQ80RUibBgdKTOfyyC/ss2lCMK1MYFmweabsiSVJ53Vxe2kCO1bS3aJD8Vpw9zPvc2m
         qt2q5O/ZjjIms4q9X5ppWeMNeVyxWmaMOLB3a7iy1/tadmpl/OVZaYHM16hsAVS+Fg81
         lR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718434030; x=1719038830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y4RbldOmyuB3cQWDkIPG/+2f11O33ZLaDT0kxFu1pIc=;
        b=lYNBfS9muKUW4pksxUODijJIF9Ym3p93QOuy2+rAG6CAK2QinjdwWzieLBHNmV09WJ
         ShKazWOBGwzte8Gdi2D0PH7LS/n99r7Y1Q79B+1tArcxp5qjUAX/dM3jVgLzXwHfvwO+
         HHQlsR3QN3prx4Cvu1i/L0joBvbMaLhNCW/NUQP5EWDn3rivYteB2noenXnhp1KnMzKr
         ZpFWjJf9v5rjxUrN5bQOCFCaDsZ3sQbwOsao7Isv9OcOY6LWL8RBzzGQ3/GNl3g5atJj
         jTPotnt0iKb7+hlOuxgJMFLMk4SNSjiNFehZOwEI/bjke7mgk6fX9w1IHsW9A64H7RMP
         obKw==
X-Forwarded-Encrypted: i=1; AJvYcCU+8iqlX6bAtbkn30LSKkpS5ljLd1i2ya29vnnduXZ83ZUGDKYTHWvYEE5RVmyl0oPJzMnN1EuIfvMLBe29XIYOGYi6wgoCKw==
X-Gm-Message-State: AOJu0Yzb2hlljDEeUdD9CBflh4LzjKdU3Vg7kbFgB1LI0c/c/nYRlK7m
	OiOE4ikAMHKa2QGJMgDfKHi3OJoG6FAE9QpojxOQskeE2TEyFvNS81KJZQOVrsS+hlOQ3LXBGS5
	ud7Uztti3S9a7tEsux8XbOK/BeXUmzWK4BRo+9g==
X-Google-Smtp-Source: AGHT+IG9UQzi+/x6u3a0CaY7fNyxTDm/VpR28UpB4I3qr8yCgEap85fJlxSVUf2uR9MBxivdeIvjkY1RaWQ/j/8Eb1c=
X-Received: by 2002:a05:6122:2a0b:b0:4ec:f183:c9a8 with SMTP id
 71dfb90a1353d-4ee3f757840mr4716374e0c.9.1718434029824; Fri, 14 Jun 2024
 23:47:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613113302.116811394@linuxfoundation.org>
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 15 Jun 2024 12:16:58 +0530
Message-ID: <CA+G9fYvCQ1afo2s66UUDGMKGoTAe9BnONg8LqgzOnY_HC7FFHg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/402] 5.15.161-rc1 review
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

On Thu, 13 Jun 2024 at 17:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.161 release.
> There are 402 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.161-rc1.gz
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
* kernel: 5.15.161-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 382eb0c7888246aec43f7bbb93ef43abf816ec32
* git describe: v5.15.160-403-g382eb0c78882
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.160-403-g382eb0c78882

## Test Regressions (compared to v5.15.160)

## Metric Regressions (compared to v5.15.160)

## Test Fixes (compared to v5.15.160)

## Metric Fixes (compared to v5.15.160)

## Test result summary
total: 87886, pass: 70665, fail: 2514, skip: 14636, xfail: 71

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 104 total, 104 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

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
