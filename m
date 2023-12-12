Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78AC745C4
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 16:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Zub2e5xH"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7c522ea69e8so1507193241.0
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 08:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702398555; x=1703003355; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ySNEeZzkT5HeoVN/1lYVLQEQlZebmBvQl/23qCP/8ME=;
        b=Zub2e5xHN0UiykxNMrwpVKk1siO6U06SoXU+wzhNoGS7lvMpRsCqN6tpj2JlqbgXXA
         IRjFp8PB0SzifGTnF49cutx6Yk6hdRYVee03YFO29B8XfRBKA/UITjuytyM2++ccCWG9
         LAAOdtAbpa3bxipZL5JxNAzq3CR2tpOTjWzQHmL+SKyMxZ4uwS3jUosrsJ9eO3W8tJiw
         AGu0sX+bqQtCIbGzvWLpk07tYTK5bih8+NCe3oyEUIAZyoxk50tPousnB4JKJelGrQFC
         UlQOJv2TV9jWb5n4NeUabp6mgY8yOs7C9Ist45o7+bWCz9iiY5iBnMRoiA05a53dXynE
         Mu9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702398555; x=1703003355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ySNEeZzkT5HeoVN/1lYVLQEQlZebmBvQl/23qCP/8ME=;
        b=QpNNi+pmjODF3lH0vztBAzPh6xtzjy7+LNudi3jxLn1vaOMUmZ5FddBoQhgoBD78z8
         cpjuReh5pU/0iKC2zcVLiHDklRga2wg4ll8vz3bYI5zBK1TSw0IbCW+B3YSx6JpCNShO
         SZKpXFQlQUmJgph92SFXv7g9OA1Y5UTBtBfJA89gGNQDxTg1q4zEz9bHLZNHDE60l+Bo
         DTcC6V57zFyteFJkIXy/VcEkkYRkFRnk78AK5kTuRM8kwIafFOxevXbdtMnJy0ROPhPv
         dojwbZpjksDgMsEBmd2mQ5OG6ANk0a+aPMa0HoSpUDnDVzgtl6+MG7uL0BDHFd4SgU47
         SRCQ==
X-Gm-Message-State: AOJu0YxMuoR28yh4U+ynerfId2MlFptHImyJtQK3jKJk6V9lM2BJU3ZP
	EqSL1apiTd3cBdNFmdUEy07Bvh3oO4C3T9FklWKLLg==
X-Google-Smtp-Source: AGHT+IEeCdPmkS9YxQ3As9yyYKrZVxVAaQFrNJwqjtaPRa68f+SpKBnM0iLrZSbgFfbsfqiDcisLSTDDOCVZEegmouM=
X-Received: by 2002:a67:b403:0:b0:464:7ce6:9ba5 with SMTP id
 x3-20020a67b403000000b004647ce69ba5mr4240246vsl.32.1702398555322; Tue, 12 Dec
 2023 08:29:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231211182019.802717483@linuxfoundation.org>
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 12 Dec 2023 21:59:04 +0530
Message-ID: <CA+G9fYv24ydc8gV9u7O24hQFKscFF1cnWvbAzaWWcM2DyLxGfA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/97] 5.10.204-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Dec 2023 at 00:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.204 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.204-rc1.gz
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
* kernel: 5.10.204-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 670205df0377e191c0a123ecce9257eba333bbc5
* git describe: v5.10.203-98-g670205df0377
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.203-98-g670205df0377

## Test Regressions (compared to v5.10.203)

## Metric Regressions (compared to v5.10.203)

## Test Fixes (compared to v5.10.203)

## Metric Fixes (compared to v5.10.203)

## Test result summary
total: 89128, pass: 67943, fail: 3495, skip: 17631, xfail: 59

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 117 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 25 total, 25 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
* kselftest-sigaltstack
* kselftest-size
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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
