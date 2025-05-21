Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0862609D4
	for <patches@lists.linux.dev>; Wed, 21 May 2025 10:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747824757; cv=none; b=Vww6YjxaDu53Oc9b16bEzdRIrHRS06tGwsA2l53hzGkWriD0NFXXE3U/zk7u1e8XVWFVRNOMZ8gHiacvhfzGzbU7WdhN/td/wMOlw5QEZvEOFrS2KG1yVKvpPzCjiagim6MwmzFKCCQSn8ONpKGwvdSsgczDChIVBMGtOijr3Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747824757; c=relaxed/simple;
	bh=4BFLWPUAMSInPQdAE9fgzFRSdzO/MJE0QCcVjoTiJko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JUKh2aIoeO3GbiM3uRgcXCJzXQF28D8vvYvhNcX3Fb5Ehi06TrC8g+0+z60oL9Yh4oczJKwM30RQqJ7YHLQi7pZLbBgnfAx5KLod/5N8SVPaA7bN6eYnAdepbX6xvXjyuXQxaS/4xxiZtEl42rIxj8WiVmHobPn/BeIB3tJCY0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i9eTO7al; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i9eTO7al"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-528ce9731dbso1477630e0c.0
        for <patches@lists.linux.dev>; Wed, 21 May 2025 03:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747824753; x=1748429553; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dZHVJ3+0s5VJ9SAEbzNjGpliuVaCZn6/g9D/MgHcJ80=;
        b=i9eTO7alCQ7E7uWM6kfq6zjNePJrIvm/MCPohVQl/0OCUotDn0das8r/M5kjOnN0nk
         +izpZQglGcLy1V5+tFzGBSLTFIRbjf7rZ3Gze6xT83wtzbo61cNP23CBp1nHw/kgSwAz
         yxJEsIvltwKsFCIHTMFtChnvz3G2N5mxtSrUMuJRmlhYs/n6fhDS+IBNrnQ3KIiccpc9
         Fj+P+X26b/h3jeuY0d0KMNXnoM52BPPfIvUeR7pgHByeq/54H41rBN/7JSU5BjZGXmfV
         MvoVwU6qm4HpaOUjkwhcvPpa1nI/ss9s9leckF/qV3ty06lp4naZsaEZGu1ugH4MBlNa
         2VWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747824753; x=1748429553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dZHVJ3+0s5VJ9SAEbzNjGpliuVaCZn6/g9D/MgHcJ80=;
        b=J/JHYElBj953O8cwgzojCoLpdlgmzMb5ZFQxkGp83NJ75vUKNgsURUojfURoBqhqTv
         FN9nxcnfvINRITyn5L85S0YNSXwjGmLGcAdJYpPy9sVKnoDEdKmDYQxEIwnHQwowpy8m
         epPedB+btfXayFgKG/lwSnit5mMPofWynyE/wt+O+wE74C74SLB4M5Sk9bZCjNBF9tXl
         eCw+eELZ8mqIGuNZkxV87FawCsN6/BKgbEKPQY/Rwdg9k+LwNCj7NYaxOXBz4D2/pWSO
         2Jqyw2UEgK95zrHumJvwYIQVPfeiXi3O8iQOKJxAB1Ecs8dG0ZT+5EB9yofAbWYp/F5q
         vj5g==
X-Forwarded-Encrypted: i=1; AJvYcCUmHaoEgcLMTrtSIObiBCWCjA6c0gkybWOwgpFjKdhV98mLo/WqjOuIy//b9n2N+OoBy0rWLruG@lists.linux.dev
X-Gm-Message-State: AOJu0YxWG50QC3+TvJVQkVqYfJdBCZHIhBzr01euCZ7Jwul2U7IJxlMT
	+mUVigDKu0TDKjdPnW2iZLY/wA4UjbBJLj8i//VgeJZnUqzuIyjlDHk47znQQ5K1BgjKsj0HpEV
	wTC+9aZuG1QEtOfpohVnuor0aH/15Jq0hieH19D1WdQ==
X-Gm-Gg: ASbGncvg7tvrIf54djkZV1rZ4zdoqzDgpifQdc6jLc8Q9u9Y3iiRHOgobHThxY6G8hG
	Q/MRAsqn/0RqFJQHUvW9W5858al3IzBu8hX06aAmDeNKJJCaKGNFsLF9je3NVUj8BjNYywPtVsb
	hsZgI6XPe9ijAcm8Bm9aaCVUCgbO4FmDZh1Dbm0YTFKh9X2e0pTr91usw1FGifmOTHPA==
X-Google-Smtp-Source: AGHT+IGTpet3tvuo4dVQk5bLwsNjz4FVi9021yTbDrQQwYKO6Ii2Esq7EdmHZdrJDV4Fl+4399BvnJRaMflLdZbEFEg=
X-Received: by 2002:a05:6122:4317:b0:520:6773:e5bf with SMTP id
 71dfb90a1353d-52dba800001mr15970869e0c.1.1747824753137; Wed, 21 May 2025
 03:52:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520125803.981048184@linuxfoundation.org>
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 21 May 2025 16:22:20 +0530
X-Gm-Features: AX0GCFu9JDvT9DPHZ1453In-RQsb-9FyVMa4i9tTQ2pJYOokOVyHxxYrKkbN7O8
Message-ID: <CA+G9fYvDbn66=pss5UeMtjU5rYTG27nr-s5EV3Z7U3TfxSkhWg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/117] 6.6.92-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 20 May 2025 at 19:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.92 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.92-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.92-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 18952a1fc4ac790deb4faa116f18310d7010a9fb
* git describe: v6.6.91-118-g18952a1fc4ac
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.9=
1-118-g18952a1fc4ac

## Test Regressions (compared to v6.6.90-114-g477cfead3566)

## Metric Regressions (compared to v6.6.90-114-g477cfead3566)

## Test Fixes (compared to v6.6.90-114-g477cfead3566)

## Metric Fixes (compared to v6.6.90-114-g477cfead3566)

## Test result summary
total: 236734, pass: 211762, fail: 5845, skip: 18530, xfail: 597

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 23 total, 20 passed, 3 failed
* mips: 26 total, 22 passed, 4 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 20 total, 20 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 33 passed, 4 failed

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
* kselftest-mm
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
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
* ltp-ipc
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
