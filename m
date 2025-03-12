Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B949023C8BD
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 10:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741775138; cv=none; b=WwV2gpmK/L/rCx307WDtxheWRtV4jZDIKnRBL7gtWPUJCrK2OviiQzliW5dfG0f/xv+QAibrB0EO6ETWNv5/XgiKlgNJdanZYoJzGnpToi7R5MIk93QJIAOu2JmlPVIxMxBYNjC/r28IIdi3aTUPeKSm840hx4XuV4/PB8ht36o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741775138; c=relaxed/simple;
	bh=PDHO7y+ERlJAnN05ImfV1yuUpp0i/lJuWqtTfGpzzzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SW/gjS2e4tWdIpa/nqEFkL8vh+nJyZ0m9x0+cUNQNs6fuzNY82MdzIiMtbQIk4P/RnadQ1ZyJ18HPoFyD+6bFQNGE1lpK/uwMj1VvFlzntdoHqrNHdrb/Q3QcmWoVDgwO1fK3M9Kn/uBjrUXeWF6kmDO3tnVDuCcWDIZTA0P5T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EU6nO7tP; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EU6nO7tP"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5240764f7c1so1498667e0c.2
        for <patches@lists.linux.dev>; Wed, 12 Mar 2025 03:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741775135; x=1742379935; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EGtpHZfxRNzO6OoMpHooKBsRfISaZAIh8bkBtSxi4jk=;
        b=EU6nO7tP0+gKINAmGwwzE/VfvmNYh9BhTtrUEE25N4/i9iJEUfn+PblSYzUZ8wruLO
         iR3H0O1F1gt5HFbFoAREMhfXjd0AQ9eq3wr1Yu+lKkPVc31mcgH34QGU8HYNeB2XPcXS
         aPpm33CoNCCe5a/cc1cCt503LLDVx9k0jQtpPsgvTCDCOBXkzxAvY6ADXpyI04Kj5ONd
         5orZgjwGoWEnh9hofed7yCATgfzh8owRCDevEHS1h0JPhTscaWetx6hfLNgcimW7FKEl
         mwkfDUnQQJWLOMrCGw0+gENxQKpE5/uPw/FVpdKSjJZo3w7K8lIc9DviVHkhvL7NAaXl
         57Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741775135; x=1742379935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EGtpHZfxRNzO6OoMpHooKBsRfISaZAIh8bkBtSxi4jk=;
        b=LC9N75lQ+3yi2ao6GmKUcXm505TUnEr53vX+zYtJrEBw4fjNIPdWjrgKeqiZTZAJDO
         bhqlgmR5rmWFqyKGNYWOh7kGePk5sxWbVk1ZllFPeHajtHCl1KZCphRzUk0P5s5Xk1FS
         ryOJolo9Sj6yK89vTbEr8aaazGERO2PjXy9GjHe1O3rqQPuFnIoOfjWRDGaJgEfjU10o
         Y2aIc2ZF4ZOgsAb2ptYBpNc7LW0BYKsp6OcN24WdHAJF/m+Q+ISDV9Q09e/wO/SPIc3o
         M7bLdJqRAJMXAV9WMNWMhBPvrxQHIVHYTW6aozSpbbX46rHSvd+BbPZHHv1CjVdbp408
         64lA==
X-Forwarded-Encrypted: i=1; AJvYcCUiW7AeRh6yvBQsBhuUHTnCjC2Kt+r27+c/8l2GZzlekY16f0JsNEZmt/yHvhkCQfBFX7XL7BjO@lists.linux.dev
X-Gm-Message-State: AOJu0YzmrrhGUaDNyk/fIipSL+6+4nBZXPyJNn8kB99hFDgtFa9dvQ/T
	CmH+jW3+n91jeuiNRFqKyxeHwx/dfcxP6Zg8ghIovor+19H77oh2PdJuIeuGDgbWwEvPWrCb9hp
	GFW6DI2GUAOt73cLCSzDh9xBN3Dtiox6MtHPa2w==
X-Gm-Gg: ASbGncsT8vCUcVw4Wa0dHbZKyY7jLDp6o7tR/2U++goMoirEQfNo9xe1PsAEvbsVHOG
	qj9Hr9iJrJR2fuRwSk8Vm7PPdCb+l9rEAZaWqnrvrzhGoDmNWFa6VWBpZFVurKf2IJgzsEtB3gJ
	84hezrHJdrkyjWxji782qS5hDQJngpi1orvWyZKfV2rz5joYqTVVYX6Ldg98s=
X-Google-Smtp-Source: AGHT+IFL0HreR/KlcTDMM5OcMZYgMMEODEZdj0hq7LqEb2TK1xUYjtp9ukuN5QzK8OoEYGp1qR9p2Zj/muGfbshTL10=
X-Received: by 2002:a05:6122:828e:b0:520:51a4:b84f with SMTP id
 71dfb90a1353d-524198002dbmr4416579e0c.4.1741775135572; Wed, 12 Mar 2025
 03:25:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250311144241.070217339@linuxfoundation.org>
In-Reply-To: <20250311144241.070217339@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 12 Mar 2025 15:55:23 +0530
X-Gm-Features: AQ5f1JocR2QVAetGvMUl47oG9R-0y5q4g7PNIHcghhHTaNTnPuThs4tcrPj0feU
Message-ID: <CA+G9fYuK2dHLg5AGVyN98eRKwZQ-aMByvhBLyasHuJRVLNkpHg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
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

On Tue, 11 Mar 2025 at 20:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Mar 2025 14:41:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.7-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.13.7-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: fca1356f3f511f72adfed5a76ddf17a30241474c
* git describe: v6.13.6-198-gfca1356f3f51
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13=
.6-198-gfca1356f3f51

## Test Regressions (compared to v6.13.3-552-g3244959bfa6b)

## Metric Regressions (compared to v6.13.3-552-g3244959bfa6b)

## Test Fixes (compared to v6.13.3-552-g3244959bfa6b)

## Metric Fixes (compared to v6.13.3-552-g3244959bfa6b)

## Test result summary
total: 131178, pass: 107823, fail: 3844, skip: 19511, xfail: 0

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 56 passed, 1 failed, 1 skipped
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 41 passed, 2 failed, 1 skipped
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 25 passed, 1 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 49 passed, 1 failed

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
