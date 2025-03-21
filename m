Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7183D1F03D3
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 09:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742550572; cv=none; b=mZkUaCeg+KqhuvsF5gPzNIS/PYEq6IrqCa3acYsgAmQt3REwISi9/cv29cGSKGuwVOh6xu7za1WsqFxM0zU9s/1bsNjJ9uq0uO37fKshVlOUr5HhgUFI8S2EKuMD23Oj/IRemuWHl6bFJGRg0rnDoCvVwN1xGy7cA6CZ5W61f+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742550572; c=relaxed/simple;
	bh=FBNNN1T3t59Tmpv8LEr3stQJ8rv7s00/+6zV37RZu2g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CmUqPVXrvx7p6mMzo5nNIPyiXV+2fkzoFtDAFGSpiH+Eg8mr5QY/sOyD3RHb41Yd9p4lCGHiHrRcwk6StK1ompx12ZwdDvJHuFyI37qeR89lPvXC+EqEwPOOCtBi3xTd6ItnGIXhD95uysFZctL6dg1Ngvy/OBLMvRGF1cG+qvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dawHAn7R; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dawHAn7R"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-52403e39a23so1626388e0c.2
        for <patches@lists.linux.dev>; Fri, 21 Mar 2025 02:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742550569; x=1743155369; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rK/B5DzwT3J1GRA+EoLqTvc3oEK9I7okqvwd1BTbP4=;
        b=dawHAn7Rz33uqO30hnFRfD94FnDfJIgCYAXL3N/JB4vA6cux8zXVtEGuiPRJ4dunDr
         c4VjHPRETHHDZcH9ZlYrzGmJW5b62qnZN5dhfhFi1vU4IxWpCSg/bPbfpbA7fLAunoDl
         Z8TMBTasBsz3YjI0PH82MRWgnzyj4TACa0yya2q4JuS0doiTOqmgbPAm10DMwhMLqI0N
         4Qlwzqul2WI6FJ2P6U/6ddJK5E6AQiSWy19MlhiZLsfImYZNTwv3nD3TA6f7WkalALXg
         NrNLG2rh8EFGbGuhoQ8ocbC9LLtmMaid6Lad2miHy/k74D4YlrYm6ZHtFEtwD5yajcrq
         70iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742550569; x=1743155369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2rK/B5DzwT3J1GRA+EoLqTvc3oEK9I7okqvwd1BTbP4=;
        b=okaMEDaVDEtF6mClAefhotiFoyMtwUlpoBaXpKxCZD6p1BzEv7gdvAQla0hr/8mxKP
         8ffQA57bwXAAq6sW4OYr3fAcD52W48RXjJEtXsnPtZZR+BNQbYKX8T40xumrs+jiYk8j
         clniTYJUALnuikv2MVk4/J6Lmu02UPC21tsavqPd+7qZ4ROsyF6TdJ3S65oaDM66r/n4
         4WPEr5+BrxzqEVxqP5GsI/dzXfx6xyYGGrE131zgBJrhmmOjoKtlxsTpq13fHbe9Gi/K
         pODZ07Oo3pA9RzUSGnLW9ePhoPIkkYSAqfLCe79L2azrdTVDV230JL/7lsTcczl9da3Y
         qhOg==
X-Forwarded-Encrypted: i=1; AJvYcCV4luXsobTqtoTgyGl4WG+mgQVX9qCeNJo/QHkpBvdP5L2Ht+KUcpTDi99e4Xy4rVong5WwaUDh@lists.linux.dev
X-Gm-Message-State: AOJu0YxAO60YqC66P+bVWiw6ePPHzZK+75V0vrgnSt86wuhjswzyXXvl
	KcA9RII+MERBJoMAUM34erq1oBy/B7L3mDVqbZMf/s1XobZ9hiXmJiEpq57pMIqdLQ6blWOQR1p
	HUYUZaft3odxGKCHxwQqB3Nzb57UqvZHB8aX3BA==
X-Gm-Gg: ASbGncs/IID4tjn/g6GW7QFXJo0wZl+7T9KfDimsuvx2qTudAvjuWmvJgKInTO8L0U1
	t6iKUcIbXZgEEZ0gZfDXvnQE8urKCXWABXxbdw8pSpLcrHOW/yB7hEMIHg9+jxhWkyTRJNjhlad
	SjQFCGC7yg68lake0yCm2VDF8EeuBwYkiJCFhPWt0=
X-Google-Smtp-Source: AGHT+IGdqoAmjUZRBYqe9DYKyE/4py+xLqdJc6eJ3pKGIusC+9ialfwtptmVRFX5uDkAPwEKoscc2iWLcC0KHsFY6CA=
X-Received: by 2002:a05:6122:f1b:b0:525:9dd5:d55a with SMTP id
 71dfb90a1353d-525a8503a51mr1933130e0c.8.1742550569080; Fri, 21 Mar 2025
 02:49:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250320165654.807128435@linuxfoundation.org>
In-Reply-To: <20250320165654.807128435@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 21 Mar 2025 15:19:17 +0530
X-Gm-Features: AQ5f1JpaG9WtwrsAMyoghNfS-3hKzliKLZSvBSeYdymXpnaW4rCJ_budV-dCn_o
Message-ID: <CA+G9fYs5n0NVPKok7bNwwySMEpY0EKrdDYF03yxHONTuS3vDuA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc2 review
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

On Thu, 20 Mar 2025 at 23:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.84 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Mar 2025 16:56:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.84-rc2.gz
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
* kernel: 6.6.84-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: bddc6e9322072ac3aa15bd972c5bcbf9f447d246
* git describe: v6.6.83-167-gbddc6e932207
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.8=
3-167-gbddc6e932207

## Test Regressions (compared to v6.6.81-152-ge7347110295b)

## Metric Regressions (compared to v6.6.81-152-ge7347110295b)

## Test Fixes (compared to v6.6.81-152-ge7347110295b)

## Metric Fixes (compared to v6.6.81-152-ge7347110295b)

## Test result summary
total: 129260, pass: 106043, fail: 3203, skip: 19527, xfail: 487

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 46 total, 42 passed, 4 failed
* i386: 31 total, 26 passed, 5 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 23 total, 22 passed, 1 failed
* s390: 18 total, 14 passed, 4 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 38 total, 37 passed, 1 failed

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
* ltp-filecaps
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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
