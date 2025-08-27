Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F7B322757
	for <patches@lists.linux.dev>; Wed, 27 Aug 2025 08:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756282317; cv=none; b=LhFwmqbqySofvn8neHN3YML27u+F9iDTll6wS1M1VPzsEksWwkbEC415UVGLlgP9+wfsRZSBHpRag89kKCOSBQbJEz+rAcIogc3FFANThNFN/3zRYtgRa4PD3Y5pnO4Nud/xwfO6GeELK4+2YQ7nDK3rYtmvt9+BI1iU3EdB4I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756282317; c=relaxed/simple;
	bh=jOoLC5GpPdKtCOkN4m/zgPw33LJxJ5I73DN/I9tbbWQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qI5ilVUpNQt0nJJhw7d1GvL8t0ypTB3KDRRMtj8he2vk1MvnMJDSxBNmEUZi+HA32/Ebfez/udcK/e2kaVrruoG1E4Ks1i3p9t70K/4uo3TgumKDbpir+/xnGlTdbjQY7UKHLkaHucxuG/GRYbyPkmXuEfr8MEOZv20S4JrJazM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O1NDV5k7; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O1NDV5k7"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b47174beb13so4449306a12.2
        for <patches@lists.linux.dev>; Wed, 27 Aug 2025 01:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756282314; x=1756887114; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B83u6UCsQHtIoE+ppMxK8f8WCkMt55tIYpEVdEAzh70=;
        b=O1NDV5k72CJZ0PoLJoEmz4N+pWm5UP9/uG03J72H908hdbJnzti4/XR4v9XIo3dR1+
         R0azTtIlGgvx1HAqrgVPSmrMNY2o942O6iuZnCG61CfhwYqHZEZkGA1lA46Tr7bEJbmg
         wzC5ejKOC6QbZkf4zqgjGjikh2sAt6YYwzQy6jc1skQYW5kS6XN/uskqeu+4ljnX84DS
         Mu5sRs/5u/AUgk9n0EpGxQgMMuHE3FtZSVSA92U0LrCNVuyNu15qIhM8s7xrZbCm8Tx4
         yS63yxkYRK1czj3FgMjc9jePjpcMneTrD0WGAiKc+wI5Jec6bYwnvThc+r1kGX71w01R
         REZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756282314; x=1756887114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B83u6UCsQHtIoE+ppMxK8f8WCkMt55tIYpEVdEAzh70=;
        b=gWeHpBlxhfPELdmkqPqOFnzLCxQjFchHy7cxY3uLGvhffUbaophpT3Ah1kLOBDd5/6
         SYTVzGzwPVBawWG4Gz62NJsdunEQP602gBnZSfA5iK7L9Pj9VqfXiZGy8R01PHjZZdQ2
         +iLsuDU6zamAda1aLFaJ0UUEZD+R9KxNHAV+YcOM2V8CQWtwTh5Pq2Zu89QQQRVss9sX
         CfoxFoo++1OKV0sKRwTeuMLIJUCb/nSb3qvXydf++1SJ+NBiGdcgTBbIj+5XgmZOTQ+n
         SmAbOFdZGWpadrnkeANEBhXKS7WzJyv62An/4TxgOruBEOu9pU50Ugf83ztEb8dOZe6O
         EsLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDoypvS3li0hxIjPB0LqNMyAo0iP/LFWjseUM5kY7ix8elkrpURh0SLQOEs1w72wKXWfiOR8Tk@lists.linux.dev
X-Gm-Message-State: AOJu0YxobQscOls9VLaPwWf6SqoViDyYDd3488hrtloqw0k8fPccsCqe
	hUFrV1VywNViHGTc5KnVak+YiaDiDodEYTGHEFA6JPIpadcZ4lFR8yOX5hSSWghpTv7kB+VeQjw
	GPftDDjrTuDmM7sJr8cPKUin1aX7EYS72tMcp/HOSJQ==
X-Gm-Gg: ASbGncuj1eKrjwHAqtEPaA0gEbuCob55ycI7SPfjPKAlugDECO0dNMiN1Ed5LqeQceJ
	/1/hJn5UHxlIoIpjnavv9j+h9Avn6cGupNEVbLzOkoLvTb3w/RGcfBqIo0MuapLaQOW3khDshQy
	2aey/rRFEEuAJGoTdOS56v28a75xGie3BxGPFAQ9S7WjHTB8hlPEUUaPVh+Qz1o7+0UGF5I9GOZ
	2VOB74/JHW95x31UlzvGfKGO0hxIZTIJg/IMt8L
X-Google-Smtp-Source: AGHT+IHDCckS2GvgDg3rDQSosFDUnr9S/UaRCXlraeNDTOGtJ1FdHBVbfzE1VsmrTB2K196QXG+a/QAuc80Hecze1BQ=
X-Received: by 2002:a17:902:db0c:b0:246:2703:87ae with SMTP id
 d9443c01a7336-2462ef08e1dmr213164435ad.30.1756282314497; Wed, 27 Aug 2025
 01:11:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826110937.289866482@linuxfoundation.org>
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 27 Aug 2025 13:41:42 +0530
X-Gm-Features: Ac12FXzNZVkmP27De3ESl3_w9jJo97pXSGB9GkNlHU7vxAIViOCe9v8deHERbMM
Message-ID: <CA+G9fYtjpQDKwsBPM50kZ22h-dcgy1oZiywEvDanHJd=04ks2w@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Aug 2025 at 16:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.4 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Aug 2025 11:08:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.16.4-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 2894c4c9dabd275ab1a7338d9631bc10e5649c91
* git describe: v6.16.3-458-g2894c4c9dabd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.16.y/build/v6.16=
.3-458-g2894c4c9dabd

## Test Regressions (compared to v6.16.2-10-g3fb8628191b4)

## Metric Regressions (compared to v6.16.2-10-g3fb8628191b4)

## Test Fixes (compared to v6.16.2-10-g3fb8628191b4)

## Metric Fixes (compared to v6.16.2-10-g3fb8628191b4)

## Test result summary
total: 344576, pass: 317202, fail: 7069, skip: 20305, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

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
* kselftest-rust
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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
