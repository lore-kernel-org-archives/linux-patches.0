Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519461A257A
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 17:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724866197; cv=none; b=uSm5DpPtSzyhOSkLb6UKsva5l2ATyC0mLzz5nhYy0NaN1hxQJvwz+PQ4owhXMVtiDmdWeL8quK7/haTqGYMrEQm9bXMBKKdeLWE0VmV41qktqJm55kFZgHWIm0mhvOlICa9qvlb6suO89/jagDW4dylVCMrUXpjrglE70If17hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724866197; c=relaxed/simple;
	bh=xq2862FC2H9fTr3XeCMmA8f8ZF7zdMx9ormtEYxTxxE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JaLzAj4CZwPUck9golaJP00UxKavQkZRm2x9QvuPKxC7sQnv7WjCh48pM60U4hUsI+OpTYu9a7m0atSZ9G6Sh5iso3M+DDMVi0wzGO6fIv08lg+4UZKShklcknO/RqiEDygOOlCCTTz1D5pcWyHIjLlh0PZ+lU5RWJFjU3d61QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V+/ar37O; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V+/ar37O"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-498d2645902so418155137.1
        for <patches@lists.linux.dev>; Wed, 28 Aug 2024 10:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724866194; x=1725470994; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jO6WbuA2uYR9pLaLcnV8sYv7zeqotikN0u6aKu20M7M=;
        b=V+/ar37O+YxmQpzyXQ0tJoY9Oo7QRAfopm2eRqjJS2DY3sIUmNJvW6lJcnEUGaCdWs
         /xxRYIqxvUdwp0wQyOPAfzefz1j5UnwyO3W1LdSfdVKJTUH6BBtXVK5LYEBmHNDvR8h0
         aoyvisJZJQhwHgmURdvguko0UDBWEVAsUqg+yRSbNNep810km+yGExwaVYpqhQRX2oYB
         qGgbC749xC68s8/znXhKu7zVn92lPQQn2ql2ZlTdhMPxiCEeLEUfkgCh1RH6yKqCqf4d
         rSyEBml2GCXXGTb8OPHxVmt7IkuqP9wnZT7TxUi+9eOBQ06rlkOHajvy49Ukva8Ti1wC
         eUlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724866194; x=1725470994;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jO6WbuA2uYR9pLaLcnV8sYv7zeqotikN0u6aKu20M7M=;
        b=lsfOP2vBYwymYH1aoV3keTfdnXHE7HCikjlLQuNJSP5Xn1NABuuaPhWPQR7MQ7XHZc
         LIpRrLb5XxqeS2cVjS0nU02qqOhB6goffDJR6ZC5syBd7m7gRDXOpyr2wY/kB0/m6vNX
         JSGT8Zgqv2NtqzU+Vec9Zz5AxkPlkvAgToErn3rgBSzAWi4sQLCRg3OnnuH4UZPcovtZ
         /F6Osyo6Gm2GiVWvfk+CcKWwgQgxUO8y8iJvYwvENvAlaRvgmZA3vugOvzdc/EautQzA
         cjlhBX1/th7MCh0/e+AqXnrLcPW6ixswmb85YMs1NM8iuH03rCF/ET15Us6nLC5CuOMe
         pZ1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUoSPjZ44u5S6a5I6vr/KnLyBaKhP/Bs1GhmPfYh74mErUBqysDrYPQMlvZ0EnX9x3BJ8GpIXaC@lists.linux.dev
X-Gm-Message-State: AOJu0YzfxDnYBacNzLqcfxddXUtTm4GFYG4tq7hPFCdbuxFLp802hcGd
	jWlcdJUyoYTLj0FQu/2TqH/LLAeVx5Z05+Yr3VEd5eazhWj+QAlPzc4kI7LbRlunpNmQe9BEvxm
	YeYvYxB7w5bNyLo9zNrh7H+9yXu4emCh3N9KW2g==
X-Google-Smtp-Source: AGHT+IEiCFyB3OZw/XIox94ixhU3xa+nvwgNWznRK/vYEYi1rvpOzRrq8hn43RDFNhXIlTGReAClTYmoduDr2yIbeqc=
X-Received: by 2002:a05:6102:3051:b0:497:6ae3:e541 with SMTP id
 ada2fe7eead31-49a5b5bfcc3mr398727137.14.1724866194092; Wed, 28 Aug 2024
 10:29:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827143843.399359062@linuxfoundation.org> <CA+G9fYuVcn734B-qqxYPKH++PtynJurhrhtBGLJhzhXoWo0sWQ@mail.gmail.com>
In-Reply-To: <CA+G9fYuVcn734B-qqxYPKH++PtynJurhrhtBGLJhzhXoWo0sWQ@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Aug 2024 22:59:41 +0530
Message-ID: <CA+G9fYs40THj+m4hWqV3ubYBPZaWQE44SXOUYYuU1T0x6R83Ng@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Zhen Lei <thunder.leizhen@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 28 Aug 2024 at 20:00, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Tue, 27 Aug 2024 at 20:12, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.6.48 release.
> > There are 341 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> The tinyconfig builds failed for all architectures on 6.6.48-rc1.
>
> Builds
>   - clang-18-tinyconfig
>   - clang-nightly-tinyconfig
>   - gcc-13-tinyconfig
>   - gcc-8-tinyconfig

The bisection pointed to the following is the first bad commit,

bc2002c9d531dd4ad0241268c946abf074d2145d is the first bad commit
    rcu: Dump memory object info if callback function is invalid

    [ Upstream commit 2cbc482d325ee58001472c4359b311958c4efdd1 ]

- Naresh

>
> lore links:
>  - https://lore.kernel.org/stable/CA+G9fYuibSowhidTVByMzSRdqudz1Eg_aYBs9rVS3bYEBesiUA@mail.gmail.com/
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> ## Build
> * kernel: 6.6.48-rc1
> * git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> * git commit: 0ec2cf1e20adc2c8dcc5f58f3ebd40111c280944
> * git describe: v6.6.47-342-g0ec2cf1e20ad
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.47-342-g0ec2cf1e20ad
>
> ## Test Regressions (compared to v6.6.46-68-gf44ed2948b39)
> * arm64, build
> * arm, build
> * i386, build
> * x86_64, build
>   - clang-18-tinyconfig
>   - clang-nightly-tinyconfig
>   - gcc-13-tinyconfig
>   - gcc-8-tinyconfig
>
> ## Metric Regressions (compared to v6.6.46-68-gf44ed2948b39)
>
> ## Test Fixes (compared to v6.6.46-68-gf44ed2948b39)
>
> ## Metric Fixes (compared to v6.6.46-68-gf44ed2948b39)
>
> ## Test result summary
> total: 175487, pass: 153815, fail: 1637, skip: 19813, xfail: 222
>
> ## Build Summary
> * arc: 5 total, 4 passed, 1 failed
> * arm: 129 total, 125 passed, 4 failed
> * arm64: 41 total, 37 passed, 4 failed
> * i386: 28 total, 23 passed, 5 failed
> * mips: 26 total, 21 passed, 5 failed
> * parisc: 4 total, 3 passed, 1 failed
> * powerpc: 36 total, 31 passed, 5 failed
> * riscv: 19 total, 16 passed, 3 failed
> * s390: 14 total, 4 passed, 10 failed
> * sh: 10 total, 8 passed, 2 failed
> * sparc: 7 total, 5 passed, 2 failed
> * x86_64: 33 total, 29 passed, 4 failed
>
> ## Test suites summary
> * boot
> * commands
> * kselftest-arm64
> * kselftest-breakpoints
> * kselftest-capabilities
> * kselftest-cgroup
> * kselftest-clone3
> * kselftest-core
> * kselftest-cpu-hotplug
> * kselftest-cpufreq
> * kselftest-efivarfs
> * kselftest-exec
> * kselftest-filesystems
> * kselftest-filesystems-binderfs
> * kselftest-filesystems-epoll
> * kselftest-firmware
> * kselftest-fpu
> * kselftest-ftrace
> * kselftest-futex
> * kselftest-gpio
> * kselftest-intel_pstate
> * kselftest-ipc
> * kselftest-kcmp
> * kselftest-livepatch
> * kselftest-membarrier
> * kselftest-memfd
> * kselftest-mincore
> * kselftest-mqueue
> * kselftest-net
> * kselftest-net-mptcp
> * kselftest-openat2
> * kselftest-ptrace
> * kselftest-rseq
> * kselftest-rtc
> * kselftest-seccomp
> * kselftest-sigaltstack
> * kselftest-size
> * kselftest-tc-testing
> * kselftest-timers
> * kselftest-tmpfs
> * kselftest-tpm2
> * kselftest-user_events
> * kselftest-vDSO
> * kselftest-x86
> * kunit
> * kvm-unit-tests
> * libgpiod
> * libhugetlbfs
> * log-parser-boot
> * log-parser-test
> * ltp-commands
> * ltp-containers
> * ltp-controllers
> * ltp-cpuhotplug
> * ltp-crypto
> * ltp-cve
> * ltp-dio
> * ltp-fcntl-locktests
> * ltp-fs
> * ltp-fs_bind
> * ltp-fs_perms_simple
> * ltp-hugetlb
> * ltp-ipc
> * ltp-math
> * ltp-mm
> * ltp-nptl
> * ltp-pty
> * ltp-sched
> * ltp-smoke
> * ltp-syscalls
> * ltp-tracing
> * perf
> * rcutorture
>
> --
> Linaro LKFT
> https://lkft.linaro.org
