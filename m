Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C19136986
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 15:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712676003; cv=none; b=QWhPl840L8fA5kBcPFSGkHBYUbfQqFFVJvVx0Na7EXocuhKzVsdOin43vROLwqJCYxzy/nngQBkArYcwVHjLGqW9ZKpXpCg/shUv743h3PIMStiWmWzBBME1F6A2PDSLfuSaEO//hvH8guaTtj5PBjnzI6iqAbAoWzVx4AtT0dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712676003; c=relaxed/simple;
	bh=w7MuII56KC0l/QaxAt8QU+nRcQzqyGN/UzjQcR8OalE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PeXhgG6/3BemIuw1ksKj08uWnC3sj4ovA8RvxBeuKDnLvvzR4knbEH7Lmi++b50tq/nbo8YOmAzm8rCe6N9Stz/BNfhClC2vgjMc2k304wIi9qnUV+saEI0r4cBoW6YXJQ61Q/wscNI6UPZqfx+jZsR80Feh02+gm7ktNwHX2fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ns6S8rXK; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ns6S8rXK"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6ea243406f0so369822a34.2
        for <patches@lists.linux.dev>; Tue, 09 Apr 2024 08:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712676001; x=1713280801; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9zgd5TOBqXIkHIiprpxWQW1KnXD2wR1OrXXzWmsDxa0=;
        b=ns6S8rXK2SmuWBa+da4DSI63Uu+GA88SeXmnEnjku4Ul25ynXrwreySVKqCoHjXgFF
         ZMu8r2wLlP6f1z4QIqxuTjqRj9JD4k/wE7OdsRda1EyhxK9AVac7hOebwdTxD1oAmn3H
         Hku7qoFKjg8Z8WZthf9pith3w2x1/GxyMH7kh4u+/wG30R9+5jh4MOcwMk883nMdl8y3
         5HDKB8nlV09uvEh5Fp4tMt68QLlMv6z5LqyvgVPvkc9GmbA7HeFWNV4Gsl8maG6dU2qs
         2i9zQuFgH+WR5ONLHPq2zK7fHWtJcbdDIFAsZ8b5HP8g7X10x53emf4J6AKeferC+fDr
         HswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712676001; x=1713280801;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9zgd5TOBqXIkHIiprpxWQW1KnXD2wR1OrXXzWmsDxa0=;
        b=H6jT5e1hvM3F7X8w3h4MXD5gx53NdR5SDkAjYZu9hGR/i6yQ1Oj4OG3Zgg/2jaJLJw
         7o+gB6y0PJNnq8rEOGvkOp2uOt5G8NI/MqW7kQRZoVHtmMTWcFnAJUD8Bf0dhBfvmYVe
         82UPuUunR/fT3M286Pr9usuG0yREm5Z6Ny4DMWB9zlP2Lk2REszepwtSzoz1x+PM1ujZ
         0qLOMOfGNnf9bjUY+pYaqinNfg7FxJp2F49YEBO7VH/J9KmjgZCJh7FGn6IFfDLEiWS6
         KoR+0TCP9UdllZJXzhp6g61WL+m2eUiHXBbPIce0WBEx5iVk840eFgqA8mhexStZW6wt
         8v/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXhW1BaBk8/qAU9k9ZShOq1CsA0fw1q2GoWVwiXDmzkwcX/d6LpbAZRLqCB5g/+N2r5bWXyf/E1+uyse/cYPW7UO2qRLxLSDQ==
X-Gm-Message-State: AOJu0YwYyRKVG0JXvGisDt7rNlBonmmx4ERIgkawiuENcb6UsHufcS0q
	Odl8pwB6TfB8pqXiu6Nw6cEJxp1xhD3+tGiddAoRvmrFH0W5L1GHrRQWRyffyjUbadZ5372llwF
	4rmrcl2KNsfCboi9h1aRyiElLoeIu7Nkvc458uQ==
X-Google-Smtp-Source: AGHT+IHKRpHG9aqg3EiqE7UWmS5TF1Qw8G9pqcFx4N4CGX2gg1iJ1IwAhNWZo4wswyDMmaLjPUjJowwHQpkrkt5BEUg=
X-Received: by 2002:a05:6830:18f4:b0:6ea:133a:8eed with SMTP id
 d20-20020a05683018f400b006ea133a8eedmr38112otf.36.1712676001063; Tue, 09 Apr
 2024 08:20:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240408125359.506372836@linuxfoundation.org>
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Tue, 9 Apr 2024 17:19:50 +0200
Message-ID: <CADYN=9Lzq62s+LpXyZhGHThtVpTntsZ+huB9pUxSjComPTj5EQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/690] 5.15.154-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Apr 2024 at 15:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.154 release.
> There are 690 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Apr 2024 12:52:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.154-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.154-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: bfeab055fa437e2ad39c8b6a2e464da144479566
* git describe: v5.15.153-691-gbfeab055fa43
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.153-691-gbfeab055fa43

## Test result summary
total: 90684, pass: 72346, fail: 2213, skip: 16060, xfail: 65

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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
