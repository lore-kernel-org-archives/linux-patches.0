Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24DF18E1E
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 11:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707908885; cv=none; b=lFHj72fTeGugIUNYI7jP7yLlBsy/F4pIEfDBsDd7K3TFYt6THS18llgssLa0wqVaKnDuieR/seak1S+DEwu5CPj754HzdZzBQapW1yuQfguwDtpYtDdr46PpOSm6QJUDxX0EMsRpGJ+WH1DH0iIGdPUbwbQE06ogPcUpKCxFkTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707908885; c=relaxed/simple;
	bh=A3p6dvBkfrPe+QYcRYOO0BIOw+bilpkXrxJFPkswnJs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mu+BKcRRyB9PJIpzS2UgNZGW//hWT1CypgWpi/gsPknyMo3wQLeqI3tswtFlcW08l6KgnWnYzekjGBJDSsYYnoHW7MNvFLc4BqmKvBNcozO4viKFZ+RDIT1IYLtN2AE518SmA/8oaneLWYVUFUfW1zpMI7YDtidxZKhyavPS6hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nZJkDGci; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nZJkDGci"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-7d5bbbe57b9so2117040241.3
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 03:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707908882; x=1708513682; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72WvijmG/p/dIh/NSuC/Lvzmr8cJPzL16ZxCDMhhDUU=;
        b=nZJkDGci3XnaHPExZWE83jg3W1gXWnMvt2+1/HPUwsTpArWXiCsnDfpoIC2hZ9MUBF
         F6VI6ttI8l5cn4s2jLU36/WGdXEIoTVldO8AQdKs99+nc9hEZVDPCbDCtDJ3Lu79juOg
         BlnOh5WMTyzeDvnsf78rXIzjNt8Z32gj4HLv7pao5vNIasPawEqEogYf6QrjSHx/di9Q
         d2/AwZQVO6u072903thR1Qf0ZSTbLJTnXVzqYK06R3O1PHcBa0k1xWaTKBc//0389zrt
         NCZC2vO0spa6zZFjqKbbytu8mNoLezfHdYrq9vLl/2gwEHDaO7jTn3oVqEXbR1lIvyuX
         OCsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707908882; x=1708513682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72WvijmG/p/dIh/NSuC/Lvzmr8cJPzL16ZxCDMhhDUU=;
        b=T/fx020i2tzAUz3Flh0TOMs3WUvCG+94fAzoYb+xlK8HV7PGVH8Yu9mZKmSdcpHX3t
         lWMbsiQdDPt8TrPwAE0WpHmg+fMMq8UsZLgVssgDgaAid5aLDz3eUZ5AuV3nIxhxt9Tt
         M64t0m0v59SX52hFIJB0q5vMMLIyhPHyiI2l4sEhMJSfURaZullVov4U1icmqTQGI2cL
         sbOLk3+DzMvqJeRiBXiLWeNkX4+FrVboehFmUcYsaDHmIeday8AIX5cYK6MRfyH9hhs9
         yyYvX159BlYDU5l/f5usfEVBUGxejVJe5NPvfZYGbElzoYrAYWMGsPdJXnKEudshNFjs
         VBYg==
X-Forwarded-Encrypted: i=1; AJvYcCXTqUJQD90Ui6HEXhxOn3E2qYLLyukLwBVIcVjubLtadVk/tX8QBVnlYiKuysJ1asb2edz7FIqEHcFmW2D15L6sr2MM8GCaIQ==
X-Gm-Message-State: AOJu0YxcCPj6c83I3xEnGRPTurpdYVYNU7/6Ps+Z6a1NZTNS1xdn50Zi
	P8O90i+vRYO7xmtXDx795c0QUzsM2IMVkVqNeAs5Tl5EMHk5bEx8hCqdDXR4bEW102c4cfpdQ8D
	m1TuJh+dJCunxse+9Lt8L8rzrLE7P6oQjpx3oUg==
X-Google-Smtp-Source: AGHT+IEQ36E1X3jer9pbjUng+y7hZJGp3oEbnN68Y5/nwPhnD/gymeIRPC2uUIDzWpO9yfPCrh/JQu65JbsQVsdRi6Y=
X-Received: by 2002:a1f:de44:0:b0:4c0:d28:9557 with SMTP id
 v65-20020a1fde44000000b004c00d289557mr2020482vkg.1.1707908881598; Wed, 14 Feb
 2024 03:08:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240213171844.702064831@linuxfoundation.org>
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 14 Feb 2024 16:37:50 +0530
Message-ID: <CA+G9fYu1ycnmEymAuAWLwdRQLUL9gAnkw-zPAFoGDQH+YQShHA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/64] 6.1.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Feb 2024 at 22:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.78 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.78-rc1.gz
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
* kernel: 6.1.78-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: b29c5b14893f8c7e4ce99e7ee1c69848798a686f
* git describe: v6.1.77-65-gb29c5b14893f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.7=
7-65-gb29c5b14893f

## Test Regressions (compared to v6.1.77)

## Metric Regressions (compared to v6.1.77)

## Test Fixes (compared to v6.1.77)

## Metric Fixes (compared to v6.1.77)

## Test result summary
total: 134243, pass: 114089, fail: 2705, skip: 17286, xfail: 163

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 135 passed, 16 failed
* arm64: 52 total, 47 passed, 5 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 16 total, 15 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 45 passed, 1 failed

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
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
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
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
