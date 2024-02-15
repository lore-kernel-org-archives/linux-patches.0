Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45E411190
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 08:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707984525; cv=none; b=T9a9CreQgTzszsvUh+PDV+plW0jJQ/zfgi2nWK7DAp4ftvE82b49CaeUF2aHYg8phpBCLyNk0LWC/3P97te9KTptOc5Y7Cs+Sd3ep8wfdj6bRLlRf5wimgmqAZcVAfBxdjsQ5eTxv6Fk2Vp4lFE7W/btDdHi7P5qN80Xw9iZ3Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707984525; c=relaxed/simple;
	bh=hYgkvMsQtK+ETh0AblIROYVFdBFiUIh6qTlKz1TrFcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EEwrPGHFismd6R28McDAI47vmvVpeuiZZgBPCR1vXZw9nfG2x6JFb7hDXGIz3GjrGO71tzDUAVyaj8BtX6TuP71N08aUuJYDgGIq/zNb+GaGbJ3G3mVNAL3L6NfkXHWuMAhPdRgbAXSacU+HHyinns/r6dvheFmBehtiINZ62PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VCzhLBZr; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VCzhLBZr"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-7d625a3ace6so926547241.0
        for <patches@lists.linux.dev>; Thu, 15 Feb 2024 00:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707984522; x=1708589322; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZza9eXq/7qnw+VGazGn9BUZdsH6eOUwjl6kHoofvAM=;
        b=VCzhLBZrGu2o94+v9L0tmLrMMfw/yyOXUPHRss4S/aZfKtNa9T5rRAFdjXrSox9V8W
         LuDREveUqxMD+ddNEiB67DIG6/jPSt6UyC72HGgesuB0yT7mmwWNtVTcS59fF2plz1Up
         o7mCQmQBIvQfx/tgtaIMQxhhEAKOjv8BF2dcwFHFDN7NYIU3KQvZOFOETKrUu/LHTdzK
         O4dDDqEMyLARiUOM9eKImJC7BD4iv3i9c0meYIDv5c+DzR6BUwrSK4PoVp4CdQlvoOYG
         i0utuWjwzgigZx7OLp4AEQoKQtyzQC/whiNcWw7cDNRco69AImqFBKS6ggtGRflVIZrY
         XTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707984522; x=1708589322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XZza9eXq/7qnw+VGazGn9BUZdsH6eOUwjl6kHoofvAM=;
        b=qPyrUQgcl7UOXeuA1fpBDvtHzb/Fn1rn7DobsPf14aBu8d+T8k1DiYJ82uDHaDdE22
         OkZs1A0oronGecbeCRFGfosGVb1ayeE0lcz710zI1BiQO3mIBNc5FU1lxW8HAAANyBJt
         ndj0V5rLv+Ce8m8GeJ/UNPjDv2/yaquhRjyep93Pe4qdvVqW9VeFed6Dl0YLZbrqCpFj
         abArllT6JUGwS1yYC3DlzDhXKUoDmjwpP5RANMfVPjrRBEXc/scGjvUc2aQEgZJ3xIfn
         XapvwSIUfA0EuCXw79kjL2ncDqZaQF7RcYdFTHB93V3DlB5VP2LTIj0F8Oc7XA/a7jpy
         jTJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOk4pVE6npileWyUOmmRhJdyO29mJqRvC224PdOVEktp65Rdkx0OpFps/XQ+vjjwuaxRqRQFCUwE8Pke21CMiJ5QqHCWuAkw==
X-Gm-Message-State: AOJu0YwR+qCEdm/M9jPPMd1o5hrD3t1lJPAwanxDM1XKSdA2T+fh7jWM
	rD38uvPvtIU6Hp/gtOLbjbaSYUI1CGn/KUEZyExsvAZEfpBu7aAniJyBGGljuEzEnVohE8aGQ3w
	SZ654odZzf6GBmpg8CwIIzZ8nX/5uzYzPi/qInw==
X-Google-Smtp-Source: AGHT+IG7HQ61+CHPZ/gIKYILDONTh5/DyVTUTQl+3RmwxIjcHcYqksAx3lGqgC9hlU0YQ6qgXpB0Lozl6ba1nOUORdk=
X-Received: by 2002:a05:6122:4f01:b0:4bd:800d:7308 with SMTP id
 gh1-20020a0561224f0100b004bd800d7308mr4034158vkb.3.1707984522485; Thu, 15 Feb
 2024 00:08:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240214142244.209814342@linuxfoundation.org>
In-Reply-To: <20240214142244.209814342@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 15 Feb 2024 13:38:31 +0530
Message-ID: <CA+G9fYuy2iUDjzyQrdqVNdvjhgc_U40D9i8togAJ0kHCex6cLw@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/127] 6.7.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Feb 2024 at 20:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.7.5 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 Feb 2024 14:22:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.7.5-rc2.gz
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
* kernel: 6.7.5-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.7.y
* git commit: c94a8b48bd4bfaa53e96a60b980470dfc8465e35
* git describe: v6.7.4-128-gc94a8b48bd4b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.7.y/build/v6.7.4=
-128-gc94a8b48bd4b

## Test Regressions (compared to v6.7.4)

## Metric Regressions (compared to v6.7.4)

## Test Fixes (compared to v6.7.4)

## Metric Fixes (compared to v6.7.4)

## Test result summary
total: 152701, pass: 131930, fail: 2379, skip: 18206, xfail: 186

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 143 passed, 2 failed
* arm64: 52 total, 51 passed, 1 failed
* i386: 41 total, 40 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
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
* kselftest-livepatch
* kselftest-membarrier
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
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
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
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
