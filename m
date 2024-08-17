Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1958812CDB6
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 05:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723873073; cv=none; b=IWZ5sJWwL80F3c+DzX1f3JlqWw7YLKDBV0mfDRFMBrJVYI+yIecAFWYkg4xCJvckvltK6cJEZIqN9SpGWhcfJrVnRD5INvW0Hiv68SUeAorQYIhO8Rpz+5tAKWavCvby7JG0wxA1WtJ0j2gkcgo4eoW8uf/Olju11qKsK8QQ/eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723873073; c=relaxed/simple;
	bh=ujOztsrgUtLCkTBUlHipOetZmwwdWGPqzCzxoHRIJX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E9Zx+TRQIo3GBpO8Dui/SrlVyijfvKZKUSiI/sJOu4frmT4fUWHmwQuilUxPu0RPqeR+gAzphc9qmDgkpofZ2Kcx8w4a2+FXKhsjwriFVl0RWNpXfLHxyBE4KAIDVr/ZWNaF917383zNUP9htegBCA6M6C43ifImCMeVUvKkfVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MwqrdYC2; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MwqrdYC2"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6bb84ac8facso13085406d6.1
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 22:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723873071; x=1724477871; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B9dSjIaAHGCyPPaVCWVW6TuKrm6s6S4lX4QXVFVhLL0=;
        b=MwqrdYC2elKjC5bdK3eYbksvOAnKZGIjfbNKvZjvRUs71uZ3HqTmUXBrQP14wIROAo
         ggZBNO6b1HiW1QmuLARU5ZXT6tB2SpWrlqPDaksQ9dca4qRfXej1TbqbFfp36D2uFsFx
         PrbNf+pnFxoXk7DYmIcT7xOIKywQMbIqsg3wkAcw2oqjUOG4rlqFxEE35jGJL9iiCsAI
         wutUf+lMYd4XhoPdbrm2lXEsU6fujtL/LVnstSkJ03HEZwd/VJ9TtDWA4D30myCWn5QE
         JGllg66sVWjjwVQa4OAsson5nUcTXI9MP/UvejzqFuuYqvgCye0bSz4sKK2HkS89hRyW
         nkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723873071; x=1724477871;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B9dSjIaAHGCyPPaVCWVW6TuKrm6s6S4lX4QXVFVhLL0=;
        b=wW/CXKqCE6CEdQargt7vMCnIY6hnOJr5WmuXQvQUjZzccLKfEbWEj34GXeO3XYmN3A
         WGkyxoqTXlNzs0+vQ6Me7nAYjGhCZdMTPP5rDopLmMb6xc9R5b5qLqXqWgXXKgeLhYG1
         zATub+jcbq4nkb6aJIZfK+DK+449x3wfCjtD6dusbB3+e3UdtcN+kozpXGCL+mp4bZj5
         iZXo82nazgn53vWXzxi1oa2nLcoI5B/9d6Dl7cVo1yJ3J5V98SIJ1KxmPoTGkwbM2UWt
         vKj8IWdUtKsbtnp4+0jWL5yBMmxFVTI71kPMDSDgbfn8XY0zIysHIEdA0p8gYBF8/+ID
         1ujQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgmj/IA0qJ3cKTW/VaGMVb5Hikg1Cw/1QYmM0iXo4/aJGrYa8wV1ePaedpj03xiBedIQq1i44B47Qz5z3xWa5Yip7O8C2Nrg==
X-Gm-Message-State: AOJu0YyT1zckpK1A1bbsoY/n4rnIrj4UOkqViDK3vxy3m7zKtg0hhgzx
	Z0hwqXWlk2QALVtlTF77jnPnLvIoGtRQ4Z/j2cGXefjkmVC+D4XlQY51cnmvqYdaeKJxQ6TT70l
	PiqKoIFgyPxsrrwnnY/zYYdLur2LyL/EdrUAuUA==
X-Google-Smtp-Source: AGHT+IE41BzwdEqIQUO+1LkM52qPPXRw28C3Cm6JIiY2t7NJfcA7rB2LPTC97GSof/qDgZo/9EYft+CrYFvMBzjyX0M=
X-Received: by 2002:a05:6214:5f04:b0:6bd:80f0:42c7 with SMTP id
 6a1803df08f44-6bf7ce5b4b5mr59785926d6.42.1723873071026; Fri, 16 Aug 2024
 22:37:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240816095317.548866608@linuxfoundation.org>
In-Reply-To: <20240816095317.548866608@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Sat, 17 Aug 2024 07:37:38 +0200
Message-ID: <CADYN=9Jhe2+1Uw9uMQxaBThuR5wudFXoupLduHc0-u+Vxr51XQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/255] 5.4.282-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Aug 2024 at 12:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.282 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Aug 2024 09:52:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.282-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64 and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.282-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: da98fb7f23b59f6e03a312fd33f84927786f36d0
* git describe: v5.4.281-256-gda98fb7f23b5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.281-256-gda98fb7f23b5

## Test Regressions (compared to v5.4.280-45-g6b3558150cc1)

## Metric Regressions (compared to v5.4.280-45-g6b3558150cc1)

## Test Fixes (compared to v5.4.280-45-g6b3558150cc1)

## Metric Fixes (compared to v5.4.280-45-g6b3558150cc1)

## Test result summary
total: 91832, pass: 75526, fail: 1471, skip: 14777, xfail: 58

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 33 total, 31 passed, 2 failed
* i386: 21 total, 15 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 29 total, 29 passed, 0 failed

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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
