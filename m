Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F84190468
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 12:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731760049; cv=none; b=WmRcMo1hGTDX+pJiFOp6pzuGH+rKHSOfEfVPMXSDm7pjk4xhZ++GnuqIAOhRV1yyZU5AIsmFlK5qawL6t0+BtoyRsSjfaSmXoCmhyt+qlbw43+RAtQWqSBzlux6EJuuRl7ES6na+pr9ASqqz+wanRGQrSrvPQMDAeNg/gos+rS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731760049; c=relaxed/simple;
	bh=2E9nZHFjl8oof4a6rfKbtwFZcvQcpjWm1Ou++zytzqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hhhVEtf1GQ4Opo3YuLiy3dRptPHbeXKOaEjDzwz3ZARsWzRgCgKFtdudO+rQeY/6D87Eoi9k/Qnpc7ZhEiHATFihPxjRcpI7uZ222fiuV64//4PO3h2Hh+6aF7meouW810sM7Wd3gBcmjQAZdaTHk1Fk9p4JYVacNR6bYyI4Xp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=glQCugPb; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="glQCugPb"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5139cd0032cso667594e0c.2
        for <patches@lists.linux.dev>; Sat, 16 Nov 2024 04:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731760047; x=1732364847; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZbA6Ge2bM6dNVQg3XfhJCHgwJGQLdJKnq8DDbpsIgE=;
        b=glQCugPb4BXaRW7hi0L6T0R/Mm8B8vbMXm8FBfMIjSeknvmzDeh2Si/5m17yo51Czn
         tn3/v4QUNcPLjraOecoXLy+51I6fDLCKv23M248/7MCNEAEep2jDs7khK444tBORMRqU
         FKEZKWv+6RKyXcEZGJMwFnyRrR8QzE17klY0E+2FOstUZ005mw2zLkLglO/3BZKX4NFW
         sdGypNmJy5OUFv1yTBg19ZA2U8uxESjpDgAxiU9KJIzDqnS/2SBToS0GebSIEtwkJAoi
         Vt+0+zhw8uvEFyldES65ls3BPNPMAw844hlA4mJr9Orn3W+o696XvaGML+6cI5Mr/PlY
         D7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731760047; x=1732364847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bZbA6Ge2bM6dNVQg3XfhJCHgwJGQLdJKnq8DDbpsIgE=;
        b=gj7VDQI/ZiczNu4LRpG47VGC21+MsQhKz2u2AAwaPmJUKZJRAMT61ZVVe1vn5NkQ3a
         EKw3nl903PCalAJlhE3LvFrEEeLhBAlOXS8NN0nsReI5LkrZy7tCIrudy94wLuHzrBFG
         zKZOa8KgUL4JIuMiPcl9TtlGo93qK0wV10v/byVIfnYH0TP/9FWc7oqbaHMOXRSRFYT4
         coEv6/Znfx//biPYYOCW11jsQrDmXaSZRYSbTJre/mPPMYUEIjeRtQ8L2U/2zvbjW48x
         FmDjtXBmfb14xZ/k7Jg6k4WqVuHBu7glpuP9Q7yNzNYBQLGVGnvsr81OH1oOPhgTzpzT
         dkmg==
X-Forwarded-Encrypted: i=1; AJvYcCU8Gb4pjn0lvTG44E0ObBpK90mwcjgqu5lihMsnJe9XHAM/asqAnchgQVYeFmpMIQidUhH662nQ@lists.linux.dev
X-Gm-Message-State: AOJu0YyFLN7DFxnRHctmx9qRRXQSQRF7inPt4fMSCPvGREADeV1v4YXD
	W+yQlreSha2yrEMf1VBAMKo3PywmB+o4cqzb5d6xlz//Fy2MieJBz4n4PhU3frvkzfmZ8zE9Iay
	fLU6tn4Y2k6ETb70iE+8aqzUuTgSR4eKQKgh5Pw==
X-Google-Smtp-Source: AGHT+IG5fKIAQ937yzO9w4K/MNtPqgvtX7A/xgfxLuhsxMs44eFWIUzDd1lKKBWvUXurW/GgilQ1dJtoQHQ1CEkQxD4=
X-Received: by 2002:a05:6122:32d5:b0:50d:40bb:ae14 with SMTP id
 71dfb90a1353d-514781ac3aamr5475316e0c.9.1731760046921; Sat, 16 Nov 2024
 04:27:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241115063721.172791419@linuxfoundation.org>
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 16 Nov 2024 17:57:15 +0530
Message-ID: <CA+G9fYvjgM=J2KCcRPD5xQk6MYMaw4DVPN_-OFhHqBYY-DV-5g@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/22] 5.15.173-rc1 review
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

On Fri, 15 Nov 2024 at 12:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.173 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.173-rc1.gz
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
* kernel: 5.15.173-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 056657e11366d6bca8c64eb4d70bca49608ba8a8
* git describe: v5.15.171-100-g056657e11366
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.171-100-g056657e11366

## Test Regressions (compared to v5.15.171-77-g0ef052d947fe)

## Metric Regressions (compared to v5.15.171-77-g0ef052d947fe)

## Test Fixes (compared to v5.15.171-77-g0ef052d947fe)

## Metric Fixes (compared to v5.15.171-77-g0ef052d947fe)

## Test result summary
total: 60279, pass: 44530, fail: 1869, skip: 13807, xfail: 73

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 22 total, 22 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

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
