Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD27222EE4
	for <patches@lists.linux.dev>; Thu,  2 May 2024 07:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714636170; cv=none; b=qDYOaz7R9t3WTJrGKbEPLF5CZ5355HAygCYueKLY14Yg/wLEEvXWhW212EjREAOOPHP3K+j4vr5ElFz3jvT/hdsvhoMoX3oyqRplsicU+DdsFEbb0Oc5Zv7TVGUzjVKktUxXkwnLeeCxkR6NYu2EalxOJcOkuaA4DX91nznPYP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714636170; c=relaxed/simple;
	bh=iA68F+rolBZJXO5nKHvOSs3bHRYMcxCkn6pFYHHPzwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lhH5oC1hGc/67MHpNiUwDqkVWFG/UUVqtD4F/7ob8T06AK2mtdsLH5QolMGlMUrZf9NzL6iSB8+Mdi7ptmHyniPgzMGucBHY29xW8tpA9yt/a3kofCsMfAnb2ECMZKtB+MIAvVaaQDc65goWjPTu4gvqER9wkGKdIAxeLmTrF24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s0lCuV4A; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s0lCuV4A"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-47ef11b1a31so77804137.0
        for <patches@lists.linux.dev>; Thu, 02 May 2024 00:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714636168; x=1715240968; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6kYlRErK1YBUSRqRp4uQ5pB7GNRgpJXOvW08NiRbyrs=;
        b=s0lCuV4AFzh9PTRZVJm+wU0OeazgbBbtWFNmuQ5USI2ns8VVVQnUty1U3ylHf3v0mk
         V5kiVJ64uQpIAU3gt1dE+GqzmDOhde0mTt72NvxqfbL3a+mpV0Gf46XTVsSwIaVW5RWq
         fSRH8E0lR7BGAlHiE/qlbdII9cegWiH0yrQEl/iEU1PuGS2yydM7G75MIz+7J+JtrDG0
         dzcVbhF6Pvkr+3QPasYOfocWJVsI2ayj2y00kUdicDWe7feGIaTArAiSdv0KyHJm1201
         k6M85W4pJ0Z2zZMmc1UsYWfBoRBCrPwYg7hh12CH8LOTG2VNnqoFPnU8MtbZAhsJhSGS
         PWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714636168; x=1715240968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6kYlRErK1YBUSRqRp4uQ5pB7GNRgpJXOvW08NiRbyrs=;
        b=U0kbl0y0xlCYKf9XfUrd5QRdql27Hq2tOEUsxCX97NW8V+0tm8JFpvjprIBsdgNNSu
         kz/DlxEhOX3lD/n5X9OGTF5N0psbaQtwy8lWlgMQGCSAzOoevy0r3MSkX0Qeqn1G5ams
         L0j7Pe2tq80+3z+UeBh5qhx8BdZNP7pa/UbCTX9dTU64bgxoM5gKlLFiAKrx+SkX4pTL
         WqFUc+905DwS2ojXRNStGLTwTKKKW7/eTK6Oox8YS3p8gGAOSagtCVYWdAqMEGQbeqBu
         UdiRADYIWXtdDhrCV2GlDBEljbE4lA7TSa+SMbEp0+XetT+k6hUbPXZQ82PBDmS9t4jp
         iLzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjHNjexCeZUb5CJ6k4wYHVYtQx/mGO0rs7cUovOG1PuGN21OWz2ta8wLoOODAXvzeM/X0Kn+01A/VCS1P/iZwflO2sfqM4Jw==
X-Gm-Message-State: AOJu0YwEgfkftO6rM0uUpNARr5OswKEj4Hwg1UbFfPuZF9u1fbnsPchF
	g+SjtyNA2MNzBpTxxUy5DqbUrtwa7aUsE49Z+sptlx+qVQJStBklI6c+anakjrlr1FHMmgsPmEz
	qtgt4tMD+lzpE9SWVYiiqpeCPF40lZqAbpchjMg==
X-Google-Smtp-Source: AGHT+IG/WtFFdu70A40C+YumlSi2AtUlDf5sl3ZyZPbvCoeRfjJUwghUfhnYfNUoTcZEQV24IGGKlefR+GwWI4HOlWw=
X-Received: by 2002:a05:6122:c9f:b0:4d8:79c1:2a21 with SMTP id
 ba31-20020a0561220c9f00b004d879c12a21mr1367427vkb.7.1714636167735; Thu, 02
 May 2024 00:49:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240430103041.111219002@linuxfoundation.org>
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 2 May 2024 13:19:15 +0530
Message-ID: <CA+G9fYu=HarRpHDvZkuWN1vviKj88ZTZy-6nGg5tQR7Ans=p-A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/77] 4.19.313-rc1 review
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

On Tue, 30 Apr 2024 at 16:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.313 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.313-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.313-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: f656c346d44e96711a4616bce8f1f313b63f9175
* git describe: v4.19.312-78-gf656c346d44e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.312-78-gf656c346d44e

## Test Regressions (compared to v4.19.312)

## Metric Regressions (compared to v4.19.312)

## Test Fixes (compared to v4.19.312)

## Metric Fixes (compared to v4.19.312)

## Test result summary
total: 58160, pass: 49914, fail: 1047, skip: 7150, xfail: 49

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 102 total, 96 passed, 6 failed
* arm64: 28 total, 23 passed, 5 failed
* i386: 15 total, 12 passed, 3 failed
* mips: 19 total, 19 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 19 passed, 5 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-lib
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
