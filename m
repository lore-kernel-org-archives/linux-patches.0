Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474A71F0E2E
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757433630; cv=none; b=OA3FQlKqsJ6wRpRZtD2QP1SVhuyZf8cQnXkyZeOxtSPiGtsF2L3M6F+UQz/IZAoEEy4O9d9hGR4X8x+YF4XH7WoLjHPiMAf3gDqImpSHx75RQkU71y7j6TcsHg+cVSBKaCUtm1N+IEnrRxIzVmN22xUvPvyclEO2QPSp2r/ClmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757433630; c=relaxed/simple;
	bh=OT68X7ddtT7YFMXudE4r9KbWAxtMHUHmMLhE1LeEVW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JG3SP6iiGZMvUBCrxLNu48uyBbXlBqBvkBWy7COPXQ+xEC7J9E0DEfcEsaEVpJISRFTpEp7jWLWCPxsSPrRB/pZ2TMIXkxvpuztaH3ozmKlq+3ziNoDZJLieoceJnMIqG0WEIFaZO5kBTUHTJmTmSRfMF9HK/0x3V95IiaURZjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ixz0yQJg; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ixz0yQJg"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b4fb8d3a2dbso3660285a12.3
        for <patches@lists.linux.dev>; Tue, 09 Sep 2025 09:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757433627; x=1758038427; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tDeRj9T/YQzmrKmM9KG2qMZkdT5Vx7PWmyDh+IIGUIY=;
        b=Ixz0yQJgp4rdbo3ULimO6vrnJW2NLmeRoxR7xZxHrUoDrtj+G2pQXSnsferGpSxI1J
         3bMEs6DC4yO87fKw8Q7z+gqDVMhvfkYgwq466Wj6hGD7HjTCxNEsU+ChjrkEYVJIFo1r
         kx8ho4zZdXP5mttntLkxqopLy6AU+GIz+j1CkoUYiolgSQHjz3WaKSVAKXBYKc9JAaWL
         KGwOF/GAMi4XjsNnNe1fHznxfcEYfTCXVsLuuUSg96aQvu0j86EuEYDhrIRSRCOCgYsc
         WzXLI0PRUSvwzOhPDcl+SK2UDVtH+cmJfKzcAFHaEG1d58jRP2C0T+zxKGc/JtTeAaLu
         7ynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757433627; x=1758038427;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tDeRj9T/YQzmrKmM9KG2qMZkdT5Vx7PWmyDh+IIGUIY=;
        b=kBx7RfmV8yrKvN87IesWEbuZai/4Jf0725IuvRrTJQt5BuIYmJFZVHYs+p2E8eYlte
         gyl5E2CKEuyVRBzXGKi1430pRItf3oN7r5vgAsI8+1QkJGXQvI+EwqhnhMl0GJWE3FND
         EeJnGuBuy7oiDl+yd8t3mHTiFT3fg5iuhhhw9CTCemJ4VZr2VuM3+j1Chv8PjGzb0oG4
         UiRXDoOrpiL3izhap03pai2adZKkznw/qxc7XKfSdhcyvmwu7+llwTYevJN68SAMaSql
         v4fzANDdnWUddOTBG5t9zCexQoHIzJNrngKj0fcK+QZX78+g3qWjsO8kIo/S8C+Vt9Kf
         3yIg==
X-Forwarded-Encrypted: i=1; AJvYcCWWbFuJ138k6g49hPXBByPF5ApG9VpepBgBbPAYUblfDic75fWabN1LGNSuI+Ds2z/2i9KDwASP@lists.linux.dev
X-Gm-Message-State: AOJu0YzAC43/DKRH16FbGk1oHYc1eca3Sv9yhZgIsaRt04r0CTzdFeC2
	ZL9MFq4yC+HAu9M74zCuGcPYBA0S485Jg6eV6Hj7RwpOQY8rpP0IDVL0kzUdpIJPD8Q0ykq4MKo
	lCqVGF/uRSXL3k+BShBI5HoUgTZzz2lqTLBHrm2R7Gw==
X-Gm-Gg: ASbGncugSg9oqjXta6LLtsC+O+ewy5mTa9xf5iH4CEVeFqAgz6N5/jUuodqGLDo/ieL
	m0MGh0bFXKD8/Y0uoz3ftLNMnH+xz7DM1g6jBMU5dgpjtwqm/gu3R808zwi5fDDBThj1MSNBt6S
	2lAa5F08KqT+ZQGHbaEdMW9HPO3248E7yGToq57LBIs/0Kmru6qIX1vu0Z+Th0Kq65yuOgfLkJ1
	UjatKc4v6oJr95/5c4YASzQ/t2b6gV8g8pc8vCgd2nljezU1SvpHICYJSSBpPtFQ10tYSegYmcK
	seNe6Vw=
X-Google-Smtp-Source: AGHT+IGZzH61MIaUFy8zJVfSBVL1H82O2zYUWCN/hlLSbHubgLtxnw5msVUplQ4ZU+h2eJj/ZD4md9riteaJJn13d+Y=
X-Received: by 2002:a17:902:eccf:b0:24c:b69f:e4be with SMTP id
 d9443c01a7336-2516e97ed9fmr184003715ad.6.1757433627187; Tue, 09 Sep 2025
 09:00:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250908151840.509077218@linuxfoundation.org>
In-Reply-To: <20250908151840.509077218@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 9 Sep 2025 21:30:15 +0530
X-Gm-Features: AS18NWC6IvddbOLNpzm0eJCZ4FAnP80ysOBODFHUVbcwjOBxuVRlrvBxFv48o7I
Message-ID: <CA+G9fYvg-eNjmQVC4Sj2EgFcuiZnSHUyCcrTtE6rg2oYpKjc1w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/101] 6.1.151-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Sept 2025 at 21:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.151 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Sep 2025 15:18:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.151-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


While running booting Juno-r2 device with Linux stable-rc 6.1.151-rc2
kernel found this RCU info followed by boot hang.

Regression Analysis:
- Reproducibility? Validation is in progress

Boot regression: stable-rc  6.1.151-rc2 juno-r2 cpuidle_enter_state hang

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

### Boot log
[  975.847953] rcu: INFO: rcu_preempt self-detected stall on CPU
[  975.853724] rcu: \t3-...!: (5249 ticks this GP)
idle=25dc/1/0x4000000000000002 softirq=1901/1901 fqs=0
[  975.862973] \t(t=5253 jiffies g=2077 q=8479 ncpus=6)
[  975.867862] rcu: rcu_preempt kthread timer wakeup didn't happen for
5253 jiffies! g2077 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
[  975.879192] rcu: \tPossible timer handling issue on cpu=5 timer-softirq=408
[  975.886079] rcu: rcu_preempt kthread starved for 5259 jiffies!
g2077 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=5
[  975.896453] rcu: \tUnless rcu_preempt kthread gets sufficient CPU
time, OOM is now expected behavior.
[  975.905601] rcu: RCU grace-period kthread stack dump:
[  975.910658] task:rcu_preempt     state:I stack:0     pid:16
ppid:2      flags:0x00000008
[  975.919035] Call trace:
[  975.921482]  __switch_to+0x154/0x1f8
[  975.925075]  __schedule+0x494/0x8a0
[  975.928577]  schedule+0x84/0xe8
[  975.931729]  schedule_timeout+0xac/0x19c
[  975.935662]  rcu_gp_fqs_loop+0x1f4/0x808
[  975.939598]  rcu_gp_kthread+0x70/0x238
[  975.943359]  kthread+0xe8/0x1cc
[  975.946509]  ret_from_fork+0x10/0x20
[  975.950096] rcu: Stack dump where RCU GP kthread last ran:
[  975.955589] Task dump for CPU 5:
[  975.958819] task:swapper/5       state:R  running task     stack:0
   pid:0     ppid:1      flags:0x00000008
[  975.968764] Call trace:
[  975.971210]  __switch_to+0x154/0x1f8
[  975.974798]  ct_idle_enter+0x10/0x1c
[  975.978384]  0xffff00097edb0640
[  975.981541] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 6.1.151-rc2 #1
[  975.987912] Hardware name: ARM Juno development board (r2) (DT)
[  975.993843] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  976.000823] pc : cpuidle_enter_state+0x16c/0x444
[  976.005456] lr : cpuidle_enter_state+0x160/0x444
[  976.010086] sp : ffff80000aaa3d70
[  976.013403] x29: ffff80000aaa3d70 x28: ffff80000a2de000 x27: ffff80000a2a5638
[  976.020566] x26: 0000000000000001 x25: ffff0008222b4898 x24: 000000e33511dfc8
[  976.027727] x23: 000000e334d58fb4 x22: 0000000000000001 x21: 0000000000000001
[  976.034888] x20: ffff0008222b4880 x19: ffff00097ed72640 x18: 0000000000000219
[  976.042049] x17: 000000040044ffff x16: 00500072b5503510 x15: 0000000000000000
[  976.049210] x14: ffff80000a9020dc x13: ffff80000aaa0000 x12: ffff80000aaa4000
[  976.056372] x11: 1ada3b6729410000 x10: 0000000000000000 x9 : 0000000000000000
[  976.063532] x8 : 00000000000000e0 x7 : 00000072b5503510 x6 : 0000000000300000
[  976.070693] x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff80000aaa3dd0
[  976.077854] x2 : ffff80000aaa3d08 x1 : ffff80000905fdec x0 : ffff80000905fa90
[  976.085015] Call trace:
[  976.087462]  cpuidle_enter_state+0x16c/0x444
[  976.091746]  cpuidle_enter+0x44/0x5c
[  976.095331]  do_idle+0x1f4/0x2c4
[  976.098571]  cpu_startup_entry+0x40/0x44
[  976.102507]  secondary_start_kernel+0x12c/0x150
[  976.107053]  __secondary_switched+0xb0/0xb4
[  976.111251] Task dump for CPU 4:
[  976.114482] task:swapper/4       state:R  running task     stack:0
   pid:0     ppid:1      flags:0x00000008
[  976.124427] Call trace:
[  976.126873]  __switch_to+0x154/0x1f8
[  976.130462]  psci_enter_idle_state+0x5c/0x7c
[  976.134747]  cpuidle_enter_state+0x118/0x444
[  976.139028]  cpuidle_enter+0x44/0x5c
[  976.142613]  do_idle+0x1f4/0x2c4
[  976.145852]  cpu_startup_entry+0x40/0x44
[  976.149788]  secondary_start_kernel+0x12c/0x150
[  976.154333]  __secondary_switched+0xb0/0xb4
[  976.158530] Task dump for CPU 5:
[  976.161761] task:rcu_preempt     state:R  running task     stack:0
   pid:16    ppid:2      flags:0x00000008
[  976.171705] Call trace:
[  976.174152]  __switch_to+0x154/0x1f8
[  976.177739]  0x0
[ 1039.195951] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1039.202056] rcu: \t5-...!: (0 ticks this GP) idle=e028/0/0x0
softirq=1512/1512 fqs=1 (false positive?)
[ 1039.211296] \t(detected by 2, t=21087 jiffies, g=2077, q=8483 ncpus=6)
[ 1039.217746] Task dump for CPU 5:
[ 1039.220974] task:swapper/5       state:R  running task     stack:0
   pid:0     ppid:1      flags:0x00000008
[ 1039.230911] Call trace:
[ 1039.233355]  __switch_to+0x154/0x1f8
[ 1039.236938]  ct_idle_enter+0x10/0x1c
[ 1039.240518]  0xffff00097edb0640
[ 1039.243661] rcu: rcu_preempt kthread timer wakeup didn't happen for
15764 jiffies! g2077 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
[ 1039.255073] rcu: \tPossible timer handling issue on cpu=5 timer-softirq=408
[ 1039.261957] rcu: rcu_preempt kthread starved for 15770 jiffies!
g2077 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=5
[ 1039.272411] rcu: \tUnless rcu_preempt kthread gets sufficient CPU
time, OOM is now expected behavior.
[ 1039.281555] rcu: RCU grace-period kthread stack dump:
[ 1039.286609] task:rcu_preempt     state:I stack:0     pid:16
ppid:2      flags:0x00000008
[ 1039.294977] Call trace:
[ 1039.297420]  __switch_to+0x154/0x1f8
[ 1039.301001]  __schedule+0x494/0x8a0
[ 1039.304495]  schedule+0x84/0xe8
[ 1039.307641]  schedule_timeout+0xac/0x19c
[ 1039.311567]  rcu_gp_fqs_loop+0x1f4/0x808
[ 1039.315496]  rcu_gp_kthread+0x70/0x238
[ 1039.319249]  kthread+0xe8/0x1cc
[ 1039.322391]  ret_from_fork+0x10/0x20
[ 1039.325971] rcu: Stack dump where RCU GP kthread last ran:
[ 1039.331459] Task dump for CPU 5:
[ 1039.334686] task:swapper/5       state:R  running task     stack:0
   pid:0     ppid:1      flags:0x00000008
[ 1039.344622] Call trace:
[ 1039.347065]  __switch_to+0x154/0x1f8
[ 1039.350646]  ct_idle_enter+0x10/0x1c
[ 1039.354225]  0xffff00097edb0640
[ 1039.412051] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[ 1039.417488] sd 2:0:0:0: [sda] Synchronize Cache(10) failed: Result:
hostbyte=0x01 driverbyte=DRIVER_OK

- https://qa-reports.linaro.org/api/testruns/29825860/log_file/
- https://lkft.validation.linaro.org/scheduler/job/8439988#L2145
- https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/32QLuLpnnwp9AnZEJVgmvKIFxXT
- https://storage.tuxsuite.com/public/linaro/lkft/builds/32QLrp4K8PORz7gTLeqeiSIGTKL/config
- https://storage.tuxsuite.com/public/linaro/lkft/builds/32QLrp4K8PORz7gTLeqeiSIGTKL/

## Build
* kernel: 6.1.151-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: e60b159208e69c485efd270b6bd1fedd07e1aaad
* git describe: v6.1.149-153-ge60b159208e6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.149-153-ge60b159208e6

## Test Regressions (compared to v6.1.149-51-gcdcdd968ff27)

## Metric Regressions (compared to v6.1.149-51-gcdcdd968ff27)

## Test Fixes (compared to v6.1.149-51-gcdcdd968ff27)

## Metric Fixes (compared to v6.1.149-51-gcdcdd968ff27)

## Test result summary
total: 231778, pass: 215616, fail: 4719, skip: 11160, xfail: 283

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 21 total, 21 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
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
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
* kvm-unit-tests
* lava
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
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* modules
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
