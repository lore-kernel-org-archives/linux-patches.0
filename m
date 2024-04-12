Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668EB1487F4
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 15:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712937066; cv=none; b=rF1tU5gIW5c8DU6SxJZxglUCrJ8K/5xWMsU59i8JuMKjXN28bKtVL4+PWygcRwc3cXzzXE8Z/GKlBkEyD/h2iW2woa61uO0DB1PqIrUbZw8exqp5lDPeN+QQAqer5qmZ0lH3K1nVHfvX7Qkf1V97/Iby663/C1C2WtqN9zv6dxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712937066; c=relaxed/simple;
	bh=N2PKhKVj4vOuIqthZ0upvvRLqO7t9Ims4RxMuplTs4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aXmdxWIO4WYupfdEJ/yUPXKNEA/npSSWdqMRn1flgwF4DmnpA6Cy+kNz25TjTtjzN35/Z/SJ4bhQGoi/G7jjgHnD1H6Sq/pgo2SQc1wey1zqoDg6AomOKZuwDYkCt73zThNw1c9DVwmj42coTnFtUD3HRcouDu94W5JxKYu7LZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jeGOdWUg; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jeGOdWUg"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-479e8e4ab6fso460997137.0
        for <patches@lists.linux.dev>; Fri, 12 Apr 2024 08:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712937063; x=1713541863; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92R7Tt002+szgQqwlNMaYrd6FqA0RwfRXhl8UHoQOco=;
        b=jeGOdWUgWxDe8ppNaz9eMPhAuccNmOX8Gk0exM7B4clEb1mKtMMxtp5HviA7w8CC7i
         OhMjsp32yMyuBI7oJ4RueOsrd8TJ60q9pUYThAmAnNgRwGVI9JVdXllTpBJXjpa4Becg
         w+VoyEEXtGmH/skTM/jjRjIqoDyqrPXkOLbQPoguPmTuujMnVgJHVx2uJ+jIZS6R9dwz
         lMM8ppAqGF7ezsv3sjQzOlGnAEnvvIYWN4WD2FfXpfaTuWJnPcw/Mac+TQPSciORL8Kw
         eST5zSXDLKZD4Jn1o33Q27gSA6QyNt+w0IRk/pSlmTrDsODtHEWYO9tGoTa7HR7PmSjb
         AEag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712937063; x=1713541863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92R7Tt002+szgQqwlNMaYrd6FqA0RwfRXhl8UHoQOco=;
        b=gag7unicTZ9ZR/+9O51zMPS8O0FtcMo5mbAC8z7IX/+6jyBv5uzHk6IQp2Xekl6K7n
         Fg2w/v9Rp8PWsDszq4YjVbaW7EAG4MumVuFFk8YjXO7qqC9hKy9slKMihv3UYcfYgmZH
         DEYh1KOzgt807CAIxR0y7KzBeOtQlyr1q6+k8QrV3GlEAsuLRZtBXPPohi2ZFHyyc1yB
         0Uku7GKH7mGRjlP+JeZsOzDqqk4R7y8o4NX9KaPXOEXQD+1DsF1+rMgAtlwFpMFVxo+l
         FN4Ftd1IlCRG/FK5510YOUqE8amT8GosgBOVuelj9NmkUkFa/LQ6WmABr94/bJ7zAFGM
         TBjA==
X-Forwarded-Encrypted: i=1; AJvYcCU25i68jfNTrMtFyrh6YMeXK02IXfGn968dylBBgXShEvWfte2nQogJMJGteBsOV6BlEfTm687lZ8zwG3DwhjIzHakwdDbZRg==
X-Gm-Message-State: AOJu0Yw+2Jlh/wle4Oi7rGYFeMYypHm3283hS1UlQeE48S8ttMuQ3Fnb
	FEQMX5lhacChAubapr8Fjask5iu7AHNaJ9B6QM4jXL4cN1rCFg8GRiwlDLRbXkhTwOu8UPhZOIZ
	HVUxYkaGrxRRoUNQmvdIdgKhkNa6MKLdrfAtjcQ==
X-Google-Smtp-Source: AGHT+IE5gWWw3tzQD7rDayWyxRVTVHjRobGJko3lvmoSOOqVtUUWsz435Qtri/FpaqKsxh9mMM5R1F9iQ3Ac1+c45bo=
X-Received: by 2002:a05:6102:38cd:b0:47a:28d7:55ba with SMTP id
 k13-20020a05610238cd00b0047a28d755bamr3842878vst.0.1712937063266; Fri, 12 Apr
 2024 08:51:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240411095435.633465671@linuxfoundation.org>
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 12 Apr 2024 21:20:51 +0530
Message-ID: <CA+G9fYt7okLBbGsSoA=Pyv2aVKmFEvttJywmJEUJ+FDp1SA7VQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/294] 5.10.215-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Apr 2024 at 16:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.215 release.
> There are 294 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.215-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.215-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 244ca117cb3cec4bb8f936b136312bb8482eeae3
* git describe: v5.10.214-295-g244ca117cb3c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.214-295-g244ca117cb3c

## Test Regressions (compared to v5.10.214)

## Metric Regressions (compared to v5.10.214)

## Test Fixes (compared to v5.10.214)

## Metric Fixes (compared to v5.10.214)

## Test result summary
total: 94495, pass: 74097, fail: 3307, skip: 17023, xfail: 68

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 104 total, 104 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 23 total, 23 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
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
