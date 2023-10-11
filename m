Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225F1803
	for <patches@lists.linux.dev>; Wed, 11 Oct 2023 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ODEZccVt"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-7afc13d58c6so2680138241.1
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696987142; x=1697591942; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qRQt0N2+eG5tTO7gMqIqRXn/l5QeFqF7gp8hxeFcmo=;
        b=ODEZccVtaXJP9d/Im3KIn65nZZX+7SlQ52xwZYMgMNvKFcAZRuhwRbxwl5wn3Q7pD3
         pLPQXB8XAz8UH9N6td/KYHh/85ryUa8DgOWtGATrLVUnPXaJ1wImKkFxMAQa7Di9S4zQ
         kWbJZ4QekGyEldAUdBPwn6qe9gfHJSagn4J5uy0O2vUNz278YFSGhC0m2H1T/Pvm+3Nf
         4MOQM6Q5EurZw7+/4Lu411kj8aPnpd//H+rANcNcJBxDJpRd+aCaqCK+FEW5VfpYvkvz
         oBC01T57TOdJsb2PgSzzN4NKknIPk50pS+LpJdmnatTydzpkq6nAwt6DeIEla0A5CRJK
         dOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696987142; x=1697591942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7qRQt0N2+eG5tTO7gMqIqRXn/l5QeFqF7gp8hxeFcmo=;
        b=kkmJ9e8x9aTeeeQ7dTYv15teBUtE01cDnopKAUYN65pA5RX6do4qMxCfRj2Noy0mWj
         n7wV9L6ap7aLzUX5K+iUu0uMOzl8prhaDXYOifQ7QA9klusisAyGkOXL+rcFFcSItzH/
         iyR6cdDgVVkekQ2SJbvlZ1CtqVxA4N7Oeu5DzaLLvvzK0zFHbmiB+5wzQyhJOsjn8r4W
         bEYHJsrrSeitWYLVh5mNAaw8a5tVbWecNrqYOYMO6QiIHJJxPOR+xOvy3xubAM0VHKiE
         AWCh26Qex+jch/puN6Yx+XH9imn8C+62OsvLm9VS9mIvdfgqC7leLLRtuolmEmwVm/hE
         bC6Q==
X-Gm-Message-State: AOJu0YxOyT6lYYxAe0CjZX0KscJVX9SBWfQUJoU26R3yQHMIjMi+gP0j
	C/lhIV0vDPyJCLMnZzk482IapA85IDk0Sh1EC6K6MA==
X-Google-Smtp-Source: AGHT+IFN0U40s7eLJzdbWkjJD3n0biSCYIDzhpK0Q+K/vj9v6AoWcKMHt7JPnE+eK53Su37ix2frrsX0CnZidbBWcoI=
X-Received: by 2002:a67:fa17:0:b0:452:547d:845f with SMTP id
 i23-20020a67fa17000000b00452547d845fmr18734244vsq.15.1696987141749; Tue, 10
 Oct 2023 18:19:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009130107.717692466@linuxfoundation.org>
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 11 Oct 2023 06:48:50 +0530
Message-ID: <CA+G9fYv2n+7yb6rDU3oK_PexRLUmcUyUnU1ZtG-ip6UcULBYHA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/55] 4.14.327-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Oct 2023 at 19:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.327 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.327-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.327-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: bb6db074be992e4cc085ef23dc81d00467ba2d29
* git describe: v4.14.326-56-gbb6db074be99
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.326-56-gbb6db074be99

## Test Regressions (compared to v4.14.326)

## Metric Regressions (compared to v4.14.326)

## Test Fixes (compared to v4.14.326)

## Metric Fixes (compared to v4.14.326)

## Test result summary
total: 52445, pass: 44239, fail: 1592, skip: 6580, xfail: 34

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 103 passed, 5 failed
* arm64: 35 total, 31 passed, 4 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 21 total, 21 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 23 passed, 4 failed

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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
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
* kselftest-user
* kselftest-vm
* kselftest-zram
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
