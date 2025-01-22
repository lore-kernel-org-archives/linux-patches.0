Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDD6211476
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 10:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737540270; cv=none; b=FniwCsJbPr7Ax4y1tLbthuO8ZUo/9mUqVdJX0AtiVSBKkDTTyz/GzV1qx9RNGHAIxuKt10taIMaBbVX6RykVscWQ7FZ6cjPl0Va8BGEQe9qVoEgwJrp3CwIdVraElzuvodDYgkPl7rhsIJmRX76DEkOugdgBUrrQxoJZDLB/2lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737540270; c=relaxed/simple;
	bh=TYO7OD20HEO7SPVt1eQ/rFJzC0PYQw7oX0/Vic77MkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OV8l7vhJq35OfsODRzTEBtybiuckhXqmpEfsCWb8eBVtS7eR79VsxYVsGA1rpkO+xYURoHayyV19FZQpzBbSYhhmy4vlWtk/QvL6c8cVdN1Q1E1T6TOAstGMi8BZ0EMwJXXuDPSM4Dp+NhEqv9WWHp2hH/TNwxqO320iKpPVorE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tlxDjCgb; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tlxDjCgb"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-85c5a913cffso3822540241.0
        for <patches@lists.linux.dev>; Wed, 22 Jan 2025 02:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737540267; x=1738145067; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GRfn0r/U9iA404Rw4hsKMCrM4zID6KmyAyoChdxbvbw=;
        b=tlxDjCgbLd8LXMRW2Dgy7/mozAolZID1xPWlRwguq0/nRfF+PYtdRDImwAXTuLhazd
         8ZR5q0SwdU6x7OlHuNmjKBwBHFNTUsSEE1mNO5bXNpcsM9OBOkt0KT2RXpx4QYrnPaxQ
         OZFqw3a8ycKDs0AuWmMGy4ETjxsw3k2xc8V0F89n10q0glxiXLRR1ywUzHAoJXdLTleA
         oDK43Viv3/QnEsTmvKHjCwM2bsKoOvzfzejjI1DT2c2gHq41kNgW6Ga3K/piDPY4xtRG
         kVOCS3WSWYGiPff2TCefZOLVv4K9owgCBRMiku/5b1q1noDzyJavXVVaQ5tFbNklzOvB
         hEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737540267; x=1738145067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GRfn0r/U9iA404Rw4hsKMCrM4zID6KmyAyoChdxbvbw=;
        b=BZ5I509oIUDsgWKRcLz5dDS8/lPsUzXXnqmmaK28elnLWoBVLWVxHGjD0RL4cwwvoM
         MociuwIMPNG6efeexnSPlhQpA7oDcxv5/jMZsYSIXbe+wU/NNXJRHO9/DaWdJHKK2UIY
         cRZEL5H/6p2EbepzR4efI1C4f6X9NJf3rKKUE2BwfIouJIg7njeLKmNmzL4gsGuHX6nD
         /IQaJ0yW743Dchza6DVG8vQx1o8Jl8VkrRJ7a824+Ddv8rmyW0vWuLFqRcMwWQ3W3nP7
         OBzuFiYLUBxc3LzD9aMz5EWXKMWFYG7mK98076iOfaRJl57CF+dt2qzhN6eihFkKoSgi
         5JHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaxHddfyeR3ReRn9jHDmrg1WvNLT0ugHGrSXe7QpghQxjstjzB0AnEjmxTy2GL6xWM36DKDNwD@lists.linux.dev
X-Gm-Message-State: AOJu0YzPRVVYKxG9re70aauOLaRrZ4pA7qQH7EKJkeJBNEK+WDE4E5fp
	fhI5lE49hJ1ssygUzsFYoUJ3GtLJKjkbjmci5fc9JPgAiUiWjn0qjWu4bYQzzmt1gnKTHp3Vp5v
	krO1OHqze9if5+2q5D1ejfzVE9GP1T9gpTI3KLg==
X-Gm-Gg: ASbGncuuIzADX8AFNBoRCxY/zYkE9AAqKlkVkx2stw7ShUw0baH2nvjC/26dCU6cqqt
	zKwzlHK7SmD1YlpwnqvbC+Dub3/g+lfswHyoc5btbLy+QVacYhtuG
X-Google-Smtp-Source: AGHT+IFMYkg1rVatq0rrai3BrQCCWJ02FKn0eH/tY+sWWy7JFr9ErCSqIil0DBVX1rTYulbm2A9LhrihKlCJBieYgdg=
X-Received: by 2002:a05:6122:4011:b0:515:d032:796b with SMTP id
 71dfb90a1353d-51d5b39a9e2mr16320561e0c.11.1737540267268; Wed, 22 Jan 2025
 02:04:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250121174532.991109301@linuxfoundation.org>
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 22 Jan 2025 15:34:16 +0530
X-Gm-Features: AWEUYZmnR3RBMl4S3H_S1LMO9bgcYNTfkea50FG88XW2pcNB6YKexkR-htbDk6M
Message-ID: <CA+G9fYtv3NNpxuipt8Dxa_=0DhieWWc07kDgCDBM+o0gKRi4Dw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Jan 2025 at 23:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions on arm64, arm, x86_64, and i386.

The following build warn
WARNING: CPU: 1 PID: 22 at kernel/sched/fair.c:5250 place_entity
(kernel/sched/fair.c:5250 (discriminator 1))

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Boot regression: exception-warning-cpu-pid-at-kernelschedfair-place_entity

Boot log warnings
----------
<4>[  160.693155] ------------[ cut here ]------------
<4>[ 160.694179] WARNING: CPU: 1 PID: 22 at kernel/sched/fair.c:5250
place_entity (kernel/sched/fair.c:5250 (discriminator 1))
<4>[  160.695257] Modules linked in: ip_tables x_tables ipv6
<4>[  160.696471] CPU: 1 UID: 0 PID: 22 Comm: migration/1 Tainted: G
   D          N 6.12.11-rc1 #1
<4>[  160.697345] Tainted: [D]=3DDIE, [N]=3DTEST
<4>[  160.697903] Hardware name: linux,dummy-virt (DT)
<4>[ 160.698415] Stopper: migration_cpu_stop+0x0/0x8c8 <- sched_exec
(kernel/sched/core.c:5445)
<4>[  160.699330] pstate: 234020c9 (nzCv daIF +PAN -UAO +TCO +DIT
-SSBS BTYPE=3D--)
<4>[ 160.700189] pc : place_entity (kernel/sched/fair.c:5250 (discriminator=
 1))
<4>[ 160.700827] lr : place_entity (kernel/sched/fair.c:292
kernel/sched/fair.c:289 kernel/sched/fair.c:5177)
<4>[  160.701267] sp : ffff8000801e79e0
<4>[  160.701601] x29: ffff8000801e79e0 x28: fff00000cad1d852 x27:
fff00000cad1d8c8
<4>[  160.702716] x26: 0000000000000000 x25: 1ffe0000195a3b00 x24:
0000000000000000
<4>[  160.703741] x23: 0000000000000000 x22: 0000000000231608 x21:
0000000972092cd2
<4>[  160.704817] x20: 0000000000000000 x19: fff00000cad1d800 x18:
1ffff000100f2ec5
<4>[  160.705954] x17: 0000000000000000 x16: fff00000c03a4d3c x15:
0000000000000000
<4>[  160.706967] x14: 1ffe00001b532adb x13: 1ffe000019c18922 x12:
fffd80001982cc21
<4>[  160.708052] x11: 1ffe00001982cc20 x10: fffd80001982cc20 x9 :
dfff800000000000
<4>[  160.709043] x8 : fff00000cc166107 x7 : fff00000cad1d810 x6 :
fffd80001982cc20
<4>[  160.710037] x5 : fff00000cc166100 x4 : 1ffe0000195a3b01 x3 :
1ffe00001b535b92
<4>[  160.711016] x2 : 1ffe00001b535b96 x1 : 000000000000029c x0 :
0000000000000000
<4>[  160.712071] Call trace:
<4>[ 160.712597] place_entity (kernel/sched/fair.c:5250 (discriminator 1))
<4>[ 160.713221] reweight_entity (kernel/sched/fair.c:3813)
<4>[ 160.713802] update_cfs_group (kernel/sched/fair.c:3975 (discriminator =
1))
<4>[ 160.714277] dequeue_entities (kernel/sched/fair.c:7091)
<4>[ 160.714903] dequeue_task_fair (kernel/sched/fair.c:7144 (discriminator=
 1))
<4>[ 160.716502] move_queued_task.isra.0 (kernel/sched/core.c:2437
(discriminator 1))
<4>[ 160.717432] migration_cpu_stop (kernel/sched/core.c:2481
kernel/sched/core.c:2540)
<4>[ 160.718309] cpu_stopper_thread (kernel/stop_machine.c:511)
<4>[ 160.718871] smpboot_thread_fn (kernel/smpboot.c:164)
<4>[ 160.719699] kthread (kernel/kthread.c:389)
<4>[ 160.720382] ret_from_fork (arch/arm64/kernel/entry.S:861)
<4>[  160.721092] ---[ end trace 0000000000000000 ]---

metadata:
history: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/bu=
ild/v6.12.10-123-gf6b51ed03daa/testrun/26866897/suite/log-parser-boot/test/=
exception-warning-cpu-pid-at-kernelschedfair-place_entity/history/
boot log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/b=
uild/v6.12.10-123-gf6b51ed03daa/testrun/26866897/suite/log-parser-boot/test=
/exception-warning-cpu-pid-at-kernelschedfair-place_entity/log


## Build
* kernel: 6.12.11-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: f6b51ed03daaa30e4c3b3969505cc9b1625babca
* git describe: v6.12.10-123-gf6b51ed03daa
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.10-123-gf6b51ed03daa

## Test Regressions (compared to v6.12.9-190-gd056ad259f16)

## Metric Regressions (compared to v6.12.9-190-gd056ad259f16)

## Test Fixes (compared to v6.12.9-190-gd056ad259f16)

## Metric Fixes (compared to v6.12.9-190-gd056ad259f16)

## Test result summary
total: 117171, pass: 90748, fail: 8735, skip: 17614, xfail: 74

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 56 passed, 2 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 40 passed, 4 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 22 passed, 4 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 49 passed, 1 failed

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
* kselftest-rust
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
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
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
