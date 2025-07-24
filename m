Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D0F221703
	for <patches@lists.linux.dev>; Thu, 24 Jul 2025 08:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753344094; cv=none; b=JavZbpeNrtgcqSIo/J6uKotqlTJhmSMje+19KPfDkasYbrfxQeVdrQeQTn9rhCp9rYIiWReK9Jxp6y36YTzQ1bNj66KWWzzg8GYn3gwAIcFTPDCSlfFrNR6uKiqfbFMKzPBH0PVK98zV5xAWMEnGYlFcwUz5QREcG/0HePeEaMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753344094; c=relaxed/simple;
	bh=5A3Z8slNVEBZE3CFg2MqlP9x7DnuosBp4IhM0ZpDKlA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ths/ahovgdHPSzq/84bt1zmdaEdtBRIhHXmF1x9iAyUuvniW4xBEEnPQTk0vLxhM4qE4mQdL4cxmJ+6Idq3b/vuLev3qc/MdcIMpxfon455sx0rhWrXwZIjxXRSq0L9BthcPGQpbI0q9yftQYavyN1BOs6SuTP105+P+yfhwBLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NbW1v757; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NbW1v757"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3138e64b42aso676762a91.0
        for <patches@lists.linux.dev>; Thu, 24 Jul 2025 01:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753344092; x=1753948892; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rm9KNNBxAABgp5gOoV12tf0eMIaYYncc2PwDjjv+oEY=;
        b=NbW1v757Yx4EX+5DRG5WjtYOyq18M3AXl3uJ/iq5DrB7GiVjknwg2zRBtD+Y63EB2N
         /aVhk+xd9o2huwdf28IaQQqaFu6eiOSLdx2cE6wauae7Ci9pPeF0+ykXwdkIA6yMvbBg
         l+EdtZEBWZRA4B7jeVmetrUPbRwDa3jfkOcFMUKJS5MBBFj71e4KD3JDC+KP4F8fy06k
         3cgkO/vBswMs01ACHIdTi+wL41HlLj2H6TqLQlVLpiAEtPBOl/jPbeBilePj08aoH9uH
         TSfu6LYRMGjDV2BETtMNhub9vnIePU3k2ZTY4Z6fdi6QiWF0bVIn1MyRicXyi3u82OFO
         Gxeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753344092; x=1753948892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rm9KNNBxAABgp5gOoV12tf0eMIaYYncc2PwDjjv+oEY=;
        b=iHFlEyD6sy6I2ihuFeDcslcma3DxbQvD/Y2LRH2p3y1j3arlXdZq+G286Hd0HzlsGn
         gT5sLnvZBfpbiv9BwuiQIG/aeGAjuxnKHqhz5gK3hF22HL42aiHqRx95Cg4z6ng7GAaq
         l+WTZYH7gdmzqf0XU0YyALAS85xrRjxO/HZskz6jORbqnYwoaaCqc2WJSZdVMKPmnqsF
         Ik48Lojiu2sTs2QO0898cbIShdyFxpU6vRINDipcVDFNe6bYEkISJJw8htZjXJe+6wAG
         wEQuUtZIuOR8E80SwIrcFhw8jTTOcwmSqQ1/FI1NsDeRBvW2ZW0AsN7iwPJAHHH176xB
         ntnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWy5L8YCvaM8UUCQccd2AZt3ai4Ym/+YMc1yPpKti8iMINfkgaL94eHPblDVtMmPtvuuWifsBhR@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4w8wChC7nXT4KYw3e59LQKQCj4eJGLT400x6Uun0lOJXfg3OU
	59267l1jHj3Yr6EE1hn1j+XwIztADmpnXjS8CAvnSreB+wDst3k5KQ/IlZz6sSoKhyMjwm8MHbh
	7W4sZ5pQVfOf4Upqr++i2N6KAsRtqfGZpHox4x3Wf9w==
X-Gm-Gg: ASbGncuUscxaDu0MdHGrIOHwaf0UDd2CfvlN0rDM/pzebw07NDy5HdaV/SyIuaJRBW5
	fFkZZM2y5FHTcGvw+Ln4tzgjyNWfiHFnD6W/2mK1vN/xOXmDUQxi9yf3gjA4OflG4XWlywGTfiM
	uQzfFxLOFqIXY2ZmuNxfUsjFMNjSIppt6gM/p3fMpYE5BHoRrPYMgZ3fshMXIMv0+NnMxsmIxGi
	F5fr/e1AbSASJvgbGr5lL1R+rfDcZ5koQ6Jd4e3
X-Google-Smtp-Source: AGHT+IFXFMQVdedGPzwZ8qOT6jbiIBrxpwBPcrccxmouRbGeo3CqtPlJjH+Rc35UCS+AMgP/xcts90SLDCaiAhef8fE=
X-Received: by 2002:a17:90a:d60b:b0:311:c970:c9ce with SMTP id
 98e67ed59e1d1-31e5082bbbdmr9159726a91.28.1753344091532; Thu, 24 Jul 2025
 01:01:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250722134345.761035548@linuxfoundation.org>
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 24 Jul 2025 13:31:19 +0530
X-Gm-Features: Ac12FXxtcOgLqPqroSSzbVA9m-CKAZYmLOPXu521BJctLr01UlzJ4sQIX0UGpVk
Message-ID: <CA+G9fYsh9j5qBXLgcnJ-vJXSQojhUQU8CH=1oGGBbj3iXApZpw@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
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

On Tue, 22 Jul 2025 at 19:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.15.8-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 81bcc8b99854ba689a8c85fb1d39d5acdce0385a
* git describe: v6.15.7-188-g81bcc8b99854
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15=
.7-188-g81bcc8b99854

## Test Regressions (compared to v6.15.6-193-ge6001d5f7944)

## Metric Regressions (compared to v6.15.6-193-ge6001d5f7944)

## Test Fixes (compared to v6.15.6-193-ge6001d5f7944)

## Metric Fixes (compared to v6.15.6-193-ge6001d5f7944)

## Test result summary
total: 329387, pass: 302234, fail: 7786, skip: 19367, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 47 passed, 2 failed

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
