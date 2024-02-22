Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35745405F2
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 11:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708601091; cv=none; b=DFK1jC/X7p/9TLveXSxdu0o6+a5DT7R5XInknq+kw5zSkJjI+J2iMcvDM4cpQMG2+sFkpchhCLb0bdWqEeQrMTIboParzvtscOUCtu+Mqphux+RJDBYWmlc+rB5n9SrCNAscRxeifo+QGrjR60gj7qFmwNt6RMBsH45n8uX5EN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708601091; c=relaxed/simple;
	bh=Xoz66ZnLQBbD3szTzDiV6Z+dB78Qn4Ttq5cK1iCbsWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h8U/z34TcoqizgM/k3H3UuR/kMFMRY4AKSYZiOWRhol0FBmG8EI9PL2SYuo0MOGOzowXGgBm4tdbF2W1K4tcUFiySZ0RHp4+8BDNU/2SLd/7OlF7G2/WhPbOmEuTgQgbhabXn7UYQxuDfntCuJG470ZdOH0cP1aw7lhMwG7Q6Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U4k3J15u; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U4k3J15u"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7d2e21181c1so1035760241.3
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 03:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708601089; x=1709205889; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XiAWGn1x9YRhT+FJAFJSfVRs08+14Yiub1Es4TlGy6U=;
        b=U4k3J15uSrqQTT8bH3xivdTOVH/tS97k3HVfX+w/QHAv1ga8AF+jYzDurze9WFgbLN
         cTnGd8bTI91ihS0Eb4Pt6gTpk1siamnzuMBhO/SGq7h9AQeuP6nDfUtOVpXsILcPiSMY
         rrUtFGOe0rQcw7QQnYosErDcx4+BUk91o27oQqULyZyxxscDgF4w8t1V9b6HzAlGeXPI
         kK0w4IrTW52fhIQY4LC12MoFuTB+2z+Zi3USrEozNmf0mf2g5FqkDyIXuchI+xlYmhyI
         Nc1y19wZNuDQRSFcwQFBI0lLBU6IF85Z+MBzUXrBNdt5GkYjE4y1Ocn/ZlqEglVokrtP
         Z3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708601089; x=1709205889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XiAWGn1x9YRhT+FJAFJSfVRs08+14Yiub1Es4TlGy6U=;
        b=v9y9rAXRZk7R8123iwN2PU78tAjPN+mx29EVqu+UHciIWZy2l/ijDW3JxasYHfRmH9
         TfOGAhocTkjSyzsq6skboAskttMlkst94ysYuixUT8aNzIZpkT6A/beEYG9u+0mp4Byn
         WOetQ0hx1Rp6Ig/u1BHGQv0Y9w1YrAjBtv/grso90+xJ+XLI90kB87NW5Hn16XZSaKkc
         KSerlYhNYO4mFAPw09SYSSfQM6VwGyEWWENemCz1g6LD9BpjHJQ1WlOBxjp58UUfm7yz
         E4EubZhcjoFJY/CwFkuocalvhJcr8tLkhPqfvWx7sbyHsHO+6iwBp8noRGh6VQxKkZCt
         l2zA==
X-Forwarded-Encrypted: i=1; AJvYcCWfcg6skQ5nloTw60k4hO/iI7EbvP+/RPnOIZA8mrIxjakRTL9v/6Usee6R2NwlLonqzXwDU+GoO8m8+wO7qNbimjWNKj8uQg==
X-Gm-Message-State: AOJu0Yym7ZQvi3dEt4leQzP1tqIP1KPBKvg6YlsbTjrBb5y+UsnY5WXU
	NzxptpH0o+EN7b9c3av6jVsn5CnjdhmcoF6+XibN6C2ofdpDCB8mQameGFojU8qN03ltXoH7mah
	JZH/cnvhqD/LpoDTb0vd2ywhnZhMh7FE0ZWUiyw==
X-Google-Smtp-Source: AGHT+IF84OHokm7fFAzmyD+f0oXM+AwVxJ7Hn3QG/81nxJxFKr2eRnLqowU27o5dQZPEH439ofSxJoCmCTm3bjLAck8=
X-Received: by 2002:a05:6102:3566:b0:470:3f15:f1ae with SMTP id
 bh6-20020a056102356600b004703f15f1aemr17161493vsb.10.1708601088993; Thu, 22
 Feb 2024 03:24:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221125951.434262489@linuxfoundation.org>
In-Reply-To: <20240221125951.434262489@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 22 Feb 2024 16:54:37 +0530
Message-ID: <CA+G9fYuP26S-mLjBqzT=y_C3gXQFhWbz36v8kBs-rf9yAKm0Fg@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/313] 6.7.6-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Feb 2024 at 18:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.7.6 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.7.6-rc2.gz
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
* kernel: 6.7.6-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.7.y
* git commit: 028924d29f01deaa6bfdb53b7e5408948c909d91
* git describe: v6.7.4-443-g028924d29f01
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.7.y/build/v6.7.4=
-443-g028924d29f01

## Test Regressions (compared to v6.7.4)

## Metric Regressions (compared to v6.7.4)

## Test Fixes (compared to v6.7.4)

## Metric Fixes (compared to v6.7.4)

## Test result summary
total: 252135, pass: 219505, fail: 2961, skip: 29354, xfail: 315

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 143 passed, 2 failed
* arm64: 51 total, 50 passed, 1 failed
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

--
Linaro LKFT
https://lkft.linaro.org
