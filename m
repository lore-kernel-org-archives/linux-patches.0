Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0976A4087B
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 10:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712919362; cv=none; b=scEtjqfz3OFbvcc2Mj7SaWbJCAcZWQJ8HlZfrem7n6sLTvlNgwwZFsnjkc0m9RAKfKGtFqqz0Shrir3Nvy2PpzKa77rmIEgTAFlklq59QbcOGJl1CWDvP10NPmnNE8kL/lRaElYQcijXUSMHOCMBTN9a/UnDZxrxqtqQYWNeF48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712919362; c=relaxed/simple;
	bh=5whlkPZbuuY6dV+m74XUpzk7gd2mVagag7ouF0AoZb8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T36DzW3ZLKPTd8jEzUHqsajwGcH+PgD07rBie5ajGpW+e123Ur+sNgfg0WwTj5W7s7xauSRrowJxyU+D42hmG/N5qP3RYO1A4uNcHjE6g2Ne53OKD9xIMPT4e3D37w7dsE9/IHh8hpzGvZ5XqNusv2PaRU4nCeBvdM8Ojuiijz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IIa8f4H0; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IIa8f4H0"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4daa2b076beso327130e0c.1
        for <patches@lists.linux.dev>; Fri, 12 Apr 2024 03:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712919359; x=1713524159; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i3EGTLIR5OVTb3E7mRYMzjSIGw18/H+l6c4Ynvz2kO0=;
        b=IIa8f4H0d2Pd3O59KKEhhFC9farPmsE8czgPvmdyN6xZy4HmcLRNPKI4jajcKMCPsb
         lTNmhqcH9CkLRnB2M+aX8SXCZejH4uNJFOuuO5BaVgcD6lb5h9QJvpMbtr/a8WbGTtST
         1vyaMGG+8/cNj9FgyJwNXvszOiZLsSk17FBa0j26XnCFX2C6offl08+e0oSY8fz52nOT
         t4mPLSL2umur77kU458FyRvHURn310Mvv+4hPxwWXT3TlhafMAwJG+XNWXUD9tti2CZ5
         jpd52pn7jVgnXmxIkjI1xEPbcqH2h6+HboozvFjfgg9ye8eFccZx/yKuJzEX4Bj3AsEU
         nOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712919359; x=1713524159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i3EGTLIR5OVTb3E7mRYMzjSIGw18/H+l6c4Ynvz2kO0=;
        b=S1ZXbldspJsurYMCsN93hDeDxl9UZPjrZxh+CGhnmVqSd/ZCgIfy0Z+rZ7M39KAeCS
         0z6Wl4AxbysvQPTbn0qvCf+x4XOENfz/ohNDfu+wb4Vv1Ov6TUHDqUfjt2jK8I95Fxuw
         xE+rMdpaWMHVlqnlEm/6KMYMkgzz6YKnsIEOrC1tjEw4l85BxLwSsiCnZATG5CxKgFuY
         HCZEmsvPcgob6PnWeJbPklp9JzajJUmxYYHwOsemF2kj4ENEEuThSVs+7Q4Q5mvwTs4n
         0cGnUor1JY/o7Z6XQFXp7lk/PyramPkoI74UnXBv0/fydNRb4ySGygBDwgrX174O+KGM
         TRlw==
X-Forwarded-Encrypted: i=1; AJvYcCVWT9P1p5mjvOKHJoN+yx+L2m3lKLjA0pWsuhdXMaZKXw/HmK5bXk1QwpAGa5JdGF2THpurAnQo/C9trMcOOwF+B8Flg4oBDA==
X-Gm-Message-State: AOJu0Yydlv+PK/dYiivxem1rRqv1+ShgdDc2mtqKYe9cUXCdY/ZibJKV
	kdLcOdM44AUqkTbrFtu4BWQJvQegDU5F/1D7+ErxctS8zbBchJ/pxK9AfVWvttEX1VST2mRgZ5k
	nYBcM5vADctc+2tPv4kU5gEu8ZvvguDKnC20LIg==
X-Google-Smtp-Source: AGHT+IHArFFDWYA5PGv0cHaA7Y9RyWZ+Omp0MmnDH9oGtj00laZjIblsjHAaMGU+fC2ydLPLphcuF7dLgKMLSl7li3k=
X-Received: by 2002:a05:6122:46a0:b0:4d8:690d:c02a with SMTP id
 di32-20020a05612246a000b004d8690dc02amr2421582vkb.6.1712919358949; Fri, 12
 Apr 2024 03:55:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240411095424.875421572@linuxfoundation.org>
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 12 Apr 2024 16:25:47 +0530
Message-ID: <CA+G9fYs9ipnaJtizZ+rEj=Tns_a7T=E0oBWZ2DtxXmZmUSkFVA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/215] 5.4.274-rc1 review
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

On Thu, 11 Apr 2024 at 15:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.274 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.274-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.274-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 82d3ef7640657b7e1fb7091841ba7a47a7a29ab4
* git describe: v5.4.273-216-g82d3ef764065
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
73-216-g82d3ef764065

## Test Regressions (compared to v5.4.273)

## Metric Regressions (compared to v5.4.273)

## Test Fixes (compared to v5.4.273)

## Metric Fixes (compared to v5.4.273)

## Test result summary
total: 102739, pass: 82092, fail: 2618, skip: 17956, xfail: 73

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 35 total, 33 passed, 2 failed
* i386: 23 total, 17 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
