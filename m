Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD0D270565
	for <patches@lists.linux.dev>; Thu, 11 Dec 2025 06:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765436120; cv=none; b=odyDzNw/Xscq0g2ZmSQfLz/aGzR6Lum6r2azuWx+ceLE/dtA6nZUG8mrCUTV2uVQ4mAHMtNCw/si16v8dOnXMs2iShKpViEKKPD4BA1mwZHxRZ3oiAG8Xbl4Z6XjczFAv54dZ4ePjyUl9pe1erWOCOUIGnib0Ov5qekDXaf3oWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765436120; c=relaxed/simple;
	bh=zLi29bNPMscrpkND0dGBlbS2YU2Q/WBcwTz5UAK+Vuc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HtsOhnR6yJ3CsP1I7VkiGW7ufPozZrzUkLLN6+EyiT/WEx/rruSSezFoctW7O8KF19m+t4nly4D9ipKYsAklWw/XMQKEYn10aZjFVq+F1a090hH+rC0QHlLED7ucAg4O1Or26Yv2vOmbJR3ebud4R8r8hL3QbhBiFG1Vi60sewg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rRDNh8ps; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rRDNh8ps"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-bf1b402fa3cso642256a12.3
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 22:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765436118; x=1766040918; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WRjgoNaFh1qvJHAkZNDs2Z3lEI+Ypa7L//zyHW7li88=;
        b=rRDNh8ps0j4OFclrfItpAgkt5Sf05QTblJyorOLqp0NyZR9olziAsvyzpeoc62TqtJ
         4yROOOvPcHkVCuzCnXnOzNmKeTnNQ9rrRJgCLphNBkINn/Zv0DdE9naM1AxqWBqRpbJn
         quLBNXp9XiEeoQQ/eIxg80md5YsZnbIQPSHF9qL38w3J0MTSVHiE8k1iIbefa3RjVOAz
         9g7SL1UBwk0LNp61iN4zKHUtfdNZQVtQhICkCgwMcmyRFuNEDQM0ERUcTN9AKnMqjCWx
         BJVT808yQGswjk1eZa6RJgXdiVPkclV8tIrIxWS/yPuKKeRsREaZqhR92YuLOvOYbMbY
         jJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765436118; x=1766040918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WRjgoNaFh1qvJHAkZNDs2Z3lEI+Ypa7L//zyHW7li88=;
        b=gB1UAKNbSDA5Im5Iw26XXPbGV6SzI00d7jJzg9/LOZQQjVe3VucZVEBfhqXw+TPFSi
         WcXjcOaNjDLQmT7uH8hWKTCHFJ3uDmykn1jbJ+/RavmDNkpKgjHjpwLvZkNIujedu03S
         QStjuhqQmh1oskIlE7+U8P6aaU/HgVAzIfR8QCD8HW9LY8FmpJkpt7tK37t6anjZhfNn
         Rsj2AfPShxniIX1gcMG5ZXf5UjjfacgyqoD4AbQn8u9J8ivhdzPJ83vgPMqhLygkTDk1
         1LyT+VeYfUwcyNAjbhyVsYlkX1nG5rtQvH2pQetFG5S9d1U7z4VQey5v2kuRLu3LX8Ln
         fCgg==
X-Forwarded-Encrypted: i=1; AJvYcCXb57GhjfazjHjjSARowdO43Ohthy5FKtr8Q4f2hAdWlAs+KN0ukYMshPbXX7nn3gd0jnSdlPdp@lists.linux.dev
X-Gm-Message-State: AOJu0Yz94M3AwQxurtSeLZWfWoLzxlsjBnNc0OyOL7uuN3QR3209boP4
	Bngi0qeJvZTzkPRf32kqRWEXbG+shBIbhzUGgsM+y1g7ilQyOxeMcJGo0P6uAxDMImfBas9gsq6
	/x+bH5Z/+dsqVHEh9e/zd/Ts4uytmriRFKYh1xq8Bog==
X-Gm-Gg: AY/fxX7PgJJg+ONPinF/pib1eEhyAiCuRGfjUhcmlyVqn5Z8r7ZNMToUIp8ns/QS15j
	4YDTPTVysdH1pRdhP92Jd/Ir0Rkgo9QYYrNxx5C7tAWdxiUdDohlph3q3XY/xXIQ+P9SDbUbG0p
	0pFUufX6lNxzqanZW2RBYHLkKkSFMW6pySPjTxMGdlCM7jwVoJWcG/vz/97vUeAg4OnuYBA7hpA
	N470Kch1RM2f2MQ0cN9Vmsim7PHMqk8v8CS8+fpI0dIBGbgG2ZcgMuW31BGBmMcE5lc18KZceNL
	wZn6FZD06l/+MNNZnewq7WMj68cr7A==
X-Google-Smtp-Source: AGHT+IEK9lMZU75iBuRom2ZiQbpD8X35wlwGqwstNR/EfSk9pcL6vP7Kd8Q3/CfsM5+z3Hy3eX3dcxL47A50j3+nOTs=
X-Received: by 2002:a05:7301:fc02:b0:2a4:3594:72e8 with SMTP id
 5a478bee46e88-2ac055fe09amr3058131eec.23.1765436117675; Wed, 10 Dec 2025
 22:55:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072948.125620687@linuxfoundation.org>
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 11 Dec 2025 12:25:03 +0530
X-Gm-Features: AQt7F2rJVFMic4-AFitD_2jlPPFvgeLqMlEXw7fLa5w9eV_te60dn_zVUCuBXBk
Message-ID: <CA+G9fYs9fLHnhKvoJ3vuEMFqxA4mSuV_55BUEVPpdib70gY=OA@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Dec 2025 at 13:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.62 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Dec 2025 07:29:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.62-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.62-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 4112049d7836ad4233321c3d2b6853db1627c49c
* git describe: v6.12.60-182-g4112049d7836
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.60-182-g4112049d7836

## Test Regressions (compared to v6.12.60-133-g8402b87f21e8)

## Metric Regressions (compared to v6.12.60-133-g8402b87f21e8)

## Test Fixes (compared to v6.12.60-133-g8402b87f21e8)

## Metric Fixes (compared to v6.12.60-133-g8402b87f21e8)

## Test result summary
total: 106188, pass: 89612, fail: 3189, skip: 13145, xfail: 242

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 54 passed, 3 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 21 passed, 1 failed
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
