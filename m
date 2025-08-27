Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682C23431FC
	for <patches@lists.linux.dev>; Wed, 27 Aug 2025 09:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756286972; cv=none; b=DMAtrenhf2rwyifsgfdlyQ1qefTRsglOsDRXzHGx+iTU/JmE21MQrR2pqhfUXXzIylWUSREW1f242b1ZXHBXi1rIrKJaDk+skmabAw0N1vmuUZbfGPcdWiELyXUtFjONAwFUXXpSdQCb7bheEAx8W0pZfhxaVHk1CoFs4nfkRro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756286972; c=relaxed/simple;
	bh=GcNpmztmTRqqdm3O9mPVD0ax9QU9z7NwP3oSb8yc3/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h1jdjccq+5CbEE1EQcvoMQYWqD0un5Xwhpt52Zep9674V7mNn6A6WGVkz/K4g2JlC1ahMgC6K27FmMqcrg1RLfAlnH0QJWQF4fTn/jrkdN/D1JCsJXGWPafXMtqSNfjIZDzeXX17KMklKFZRGyuqrSsPNhL4zGM43rVsKvKuTbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YHd6oxc3; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YHd6oxc3"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-70d9b07e163so13158216d6.2
        for <patches@lists.linux.dev>; Wed, 27 Aug 2025 02:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756286969; x=1756891769; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UqFI0TtuqmFQUi9Tx/zkbb9OSqCOCzVU0RfIWLMYKqk=;
        b=YHd6oxc3CysS/mmZZZQ7riqmqM92YX0sQooGZB0iWnuakU5+bCgJ/sAlLOG5/Rj2WB
         Fb49D52iA32uQlkgdkZxci0Rg+YsWIsRWmohUUSYRCtbTRD9aR/Ur7q15WawWBvCROsD
         B7NrhwKcjM6BAcHZXiWbazQRWCOiRVHViPqF4Uf8wYaIOwJtLKEvHgn0ZnJADQDnO1is
         ETRHh5T8mC2pfXyVpqdf2aCsqPOZ0npADfPGNLtboDtJ/tRzpBxQTG/jJBlll1OAJq/n
         EV+XpPNn5gIHaDX5u8y1flNh3BQfRdi/f9D3Wz8dgnpaLT+6avO+ZnIkXJ4+AYfluB0Y
         JkMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756286969; x=1756891769;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UqFI0TtuqmFQUi9Tx/zkbb9OSqCOCzVU0RfIWLMYKqk=;
        b=MWgJTp82wP2rYuLl7hI5H5yEqJVwSDnSTQE+0TdsUpAAUDuZBXqsggYIiwJNubfZj1
         OsQiLMWLjqC/1IopdLshF01d3kPFzQEJz+wvA6fOMLOh9NHy6CEemqmIXsMqscthk0q8
         NpaVfcS8aKK++Ue9V1iH4AjjDNRCCS4gtn4cXk+2NkikLhMABAzMO3S6mZhAUdBVwx6+
         OdhW9UolkucswJ0OexM6k2Sg40xH8JmqLXbB625W3Y/TS2ksKXv8/pDr3F4jX6GK3WSv
         wiEeh/NJDeCbT4Bd0f7DCRsrz7xTKqQdKdPlEVFD9JXJJZnBSh1VaVkSFHVTyc/Ze4/T
         y+BA==
X-Forwarded-Encrypted: i=1; AJvYcCXGzAOf//nGZTNci/0p4YtQXVeoXCqMZ2CDqJ9Y68Ca19tj9iMK3MNpQeNW8vOmnlJDeoXf/OM1@lists.linux.dev
X-Gm-Message-State: AOJu0YyeMv2rY/gpCXVom4lxb5BMjps/c1gg3hBCXp0rKwpC1tesM0z0
	GGp7o82P2KzAH3AdsuvsmfuivMp5ncdrkKajmPzt6xkYf2zW9rbcCQuIWuCfzNBPSyp6e4eFJCP
	BuJHoNM6JG7sWZKicKxL0GJXln0+FzJUjdg3zJ91GQA==
X-Gm-Gg: ASbGncs1K9C1Z2dx5uFBLwDcta6KYPYsFGmYcHJaP5MPC8WeBbDyS6NB12pt8eulKFB
	UvV84L2vVEIYpKMBUcke4mQWKAEj9O2TAzVaCOn9tH4VM2bUWOKW8NTUv317fiYp9OsGZYM8UHS
	apQVnxJkXjKySCvECE6NsOVj7OdeGtFQ2capow/mISH/a695o6uuVQ5ewUrV+5TaASIM+51IDzW
	HpFr/v/1IBH6GjM8vMlVhIEHno=
X-Google-Smtp-Source: AGHT+IFD5TPc+V9xOcpuKeQYiT1w05IlKqY8Kw5x0gWCfSNrEcU0JjpkY4wKULa1TQ52o/gR6PruOBApZ5D/oM+zlXA=
X-Received: by 2002:a05:622a:453:b0:4ab:76d2:1981 with SMTP id
 d75a77b69052e-4b2aaa5a391mr141324221cf.5.1756286969245; Wed, 27 Aug 2025
 02:29:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826110952.942403671@linuxfoundation.org>
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Wed, 27 Aug 2025 11:29:16 +0200
X-Gm-Features: Ac12FXyjR2_2Ap9DL_NxnNquyZNvutlGiFrfINO9_uWhwx7OhDnR1sI8UBJW6vU
Message-ID: <CADYN=9+-T2KM14LfXqCt-Vb2ubz7T2Oc31vk356iYGUp14KCJA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/587] 6.6.103-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 26 Aug 2025 at 13:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.103 release.
> There are 587 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Aug 2025 11:08:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.103-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Build
* kernel: 6.6.103-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: dd454ff512a6e333a3ff003fb0ab6297d90867be
* git describe: v6.6.102-588-gdd454ff512a6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.102-588-gdd454ff512a6

## Test Regressions (compared to v6.6.101-263-g7ec7f0298ca2)

## Metric Regressions (compared to v6.6.101-263-g7ec7f0298ca2)

## Test Fixes (compared to v6.6.101-263-g7ec7f0298ca2)

## Metric Fixes (compared to v6.6.101-263-g7ec7f0298ca2)

## Test result summary
total: 278693, pass: 259513, fail: 6340, skip: 12440, xfail: 400

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

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
