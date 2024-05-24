Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE1A84E07
	for <patches@lists.linux.dev>; Fri, 24 May 2024 10:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716544818; cv=none; b=fusC9JabA2WL6jUmviH1wseDib2Qchy36WZkdMzESokpYYd+AcMJO23UkHMnnmQm3THk26eWjG5agepFWpcD9fqvW80fPjmj/bUHxQ71MiVUV1uQVwBhfZnGgwlYhIx2OsH6uWkKMjKjx61eW62l8FM+GWfusSG/7+xiJ/CIanA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716544818; c=relaxed/simple;
	bh=hpFk4i8PrS/oMwXaQpRjkhgzk3MJuGUia63i9iOJwsg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FaiQVgjmtW+4JmZFZI8j3oG3tXSCE9Zm/EeEOumzNZlbU3d7DhpBfrBQgBVehtDaUVhY5U7Are8BQBsyxO+EAFJo74Oc6hq+n9WYrP0NYZdu/gKSbQerwONtQRNhXnwxt/8zEP0ZbLfk0h4tPfk+b/Q4IdB+rnqFnwBGu92cM1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=P9HcDe6C; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P9HcDe6C"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-df4dda88ce9so3287504276.3
        for <patches@lists.linux.dev>; Fri, 24 May 2024 03:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1716544816; x=1717149616; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRcxWj+6/ERB3xCr/ehuFxoGCWgvX4y5qnf6mjSxHVE=;
        b=P9HcDe6CC26DTQIm01Hqu9Tdhu0l0jtXyrDZehv3w5JsolZl7D96ux0NfStVN9EayZ
         QBPwEz77EaYtwFsRmzwjtp76JybGtW1ogdvEhD1dr00ncEhE8Yxew0cGqQM+H5JwgPv/
         HIWhsCdDwKwwRf/i+aRWLTGSVeVa7FhG9pznAHPJ1Ppt8swujZ77hXzmmzTqMScUGjA6
         koHnWF5e+V19+wF0pUYITceDKOz7a2cLHD/BIb6SmQlodJnWkVNMSQA3vLs7VgZUQ7DW
         c9xmgexTgx1XIQ3cakFczyXBPT20XW2BcnJ/Q60sptZMhn/bgVJ+aYuoj47XnqG4E3hR
         ytIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716544816; x=1717149616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xRcxWj+6/ERB3xCr/ehuFxoGCWgvX4y5qnf6mjSxHVE=;
        b=RQe6EoLWinkgSd5ziS2l8zfAEnsHf4P+3VdXiIkXRIFdB/om78FBuNmrEDn9I9dRol
         DQqr9m0Jd2z/O79ZWHQYefcKj78V+eMWmZjT8GzvoeW5p67DfvmQnUHCm0M5Sd2X/z06
         hKXE4ywuPMoLTNugQNFqBlj9h/XGT/1EgdNcT5wh++eHiSzSyKj/oHTaGddW2BGQNDy2
         Zh1Li2fQewBppsbKmX8l8nHjkC4V3gR4Q+/vShGSmpdm6nHAhwgtW1S/CJW/qCH+aukB
         /JWeBACWyotaHmd9kSGekg6TOQ+Z3y26FUnUjKWFdLO1hOhjoW9p6/kp3iHsSTtbQXPE
         vloA==
X-Forwarded-Encrypted: i=1; AJvYcCVopV7ue+9BmVVs0pTXignaKwCyewmmF5ou+pf8ckREzfqLc/XO6J9diK3Qp4Z+2NCJMxv0sqBUIHY4RswSaxJDAFe5BP+NPQ==
X-Gm-Message-State: AOJu0YwCrrWTF/RntMY/lNS2X2vsWCXD9VJ4Un8+MYic8Ykinytbyntv
	AQU2MRGI/F9o8cJTejC9UtA4I0rDceXun2/Wc1ZWdFAIoTr57lMXMKTYD3KVVTJkcvZvKKMnF4L
	a+0rKRy+RCgtrMM5PP0dZREcYBdkoLM1oYV6PVg==
X-Google-Smtp-Source: AGHT+IFtBXY/ppt8d5YadN9gk4J4si+b0ZW1MOxWyhajukvI0/vvjnxm0TIeFxPO6YclPlY0XTEdYPFBCUF7/UMrYeo=
X-Received: by 2002:a0d:ea47:0:b0:61b:349c:817 with SMTP id
 00721157ae682-62a08d933a1mr16976087b3.12.1716544815763; Fri, 24 May 2024
 03:00:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240523130342.462912131@linuxfoundation.org>
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 24 May 2024 12:00:04 +0200
Message-ID: <CADYN=9JeKd=5f4Vud2ahbe98PaFBdCqjzq++CzFpit255+myKg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/102] 6.6.32-rc1 review
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

On Thu, 23 May 2024 at 15:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.32 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.32-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 128 total, 128 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

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
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
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
