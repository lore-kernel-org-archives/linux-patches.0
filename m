Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C5E350A06
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 10:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762858094; cv=none; b=YVhFsShXiitQ+tkCUSX7+GEksuD8ie8Cw7jf8TszMwAWZD/OcjrrJhB6MrBOpjN4jz4a01X7jjCwGN9tDeqbTnhPLmwAkZEbcayILThbbNjP54lX588ujr1FgzuwEBljhXGLlYjVTGvulSB75//0M9uIw0t37C8uHwHLFaqNdO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762858094; c=relaxed/simple;
	bh=bD+R5u9IlPvwBZGtlBwpRrQZGIJ6U/j8hSw8QCdfnSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o7hect1EVaUqo884CBGYf5r3uZyIYZdAbsp42bpPWn5JBOY1z1d4NR9EniLF27VeLvwGTBqSQJPj6bzcQu6l6dcrzYX/XFzxQN0fmQjZDyWK6s1jqhPuEGhdleMkDTCvEXhAQ3ittuDIbTMUinnfj2lOqEFtNWpfY3s+9Ts0QkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BzY0yvkI; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BzY0yvkI"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b994baabfcfso2515945a12.3
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 02:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762858092; x=1763462892; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ma0936PLaG7xVo6vcy1wxniBnOai4MhijJryYDzlRRA=;
        b=BzY0yvkIYS6a22fcCDpHFiauuyB8qQWhJiO/7DRVKSyH62Q7z7I/VgiXGQCrFANh5r
         7XK9dkSJIOqWt1HurvMhRSHrV8iMa6CzXRTGR2gL4DVH5AQGDjEqi6LjzFl1QBY4Swv9
         EaDCSB1JR3u5SVHhbjU45Jiif7yLL6BKWl6JRXHZLNWqeSelawEjCBQpqtN28csh4iXP
         ax16D0xRzR2l0kbt+HMxWCH3cwoBxbwLcmstusl98MH39vIsod2vEdfEOFYIk0ZNjuSL
         X/8RkkFk/1m1+xK7o6l2019bLLqd7djuS1jNdJVvhlVXMP9IYNy15njBvFsat5orhhZ1
         gkdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762858092; x=1763462892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ma0936PLaG7xVo6vcy1wxniBnOai4MhijJryYDzlRRA=;
        b=W/d9+tlv/xS1MPKPttlLcD2feqxyZ0pYzHkoJtj4OUyoa9YiAes4nGmnJMj4Jzctic
         HKTXzLrk6WMKasXqcyvSSSCrvf6wQg/dfQ3w0dSoBT3QrtXlXQfGpseZjqDFgdoPiPTV
         jXKfAiYk5t2p9B8Q/PwPDvHqkHmTTuNU5TgCBx+2rF9agUczK7OMEIzheaZIJkgDfmkU
         i9Bm9kF4djx4CSdbRId6JjocaiDIUh9GT4d/9WZ7ExYgwiTLctTzbFEC+xvg+mv1ihDD
         DjI8b7OkYRGT+T4ku8+8hCXyo1x0i0zStF8ingrw9PTB2kSMfhUyyTwQMqbcicLLQKW8
         836w==
X-Forwarded-Encrypted: i=1; AJvYcCWZpSWdtL2akhupAroe9x+xe2txU2sfGepLLwdlYGkkncRK1wnHL+rBnvutc8B0/Ugi9m337db4@lists.linux.dev
X-Gm-Message-State: AOJu0YyHmWUzzE7LV1kmnjh/LFIdAj9U2wD15CqDFg5K+ibzKohhO1w0
	qxYJfwfJqiQfxSbmhjohQ/0QyCuclkEz+1hxYXZZGDjYTqgEBC7oq33Xxcp9pbufu4HqU2MuasR
	hxSQKR0PNpilDaVUPEFXsNO9I6f3ciwr0NhHo3r46PQ==
X-Gm-Gg: ASbGnctyx7cPXJSrnfXHKpsd+7ypwpDajMEDF+vG35Kz9t0iJV0EfnlOwxjRRo+XKbs
	9MlP3P6FU39hDhUkmM1z742uEx2u9Ihe0LyfmEN+olFc9ujV76bq8oB+9KsxJN8noMJVpqBQDaU
	sAxQFc4x3OFPgaSKvpAUPmHtIpoA4i9hgRFmzz8YhqLhPQwNSrJxj4snfnLSLpZDqWJOH4lwkfE
	gUo8he4pmY7/xRqpvPhnRkK4QkWUekivf+7VIX44ye3Bx6WgxXRQhrEvJncYKdeuHggJOToLNQi
	aKnqzIPPLyylkT/aryqYUxkmOBjn
X-Google-Smtp-Source: AGHT+IGlxZ3D/M8Qal50sIGorQGC2iE46S1vgJuEvrgOBj6Q/H48IKlRoDRYSyp8cXr3EuE7VIGJ78ND1PHoKyJVEVk=
X-Received: by 2002:a17:903:944:b0:296:3f23:b910 with SMTP id
 d9443c01a7336-297e5619f92mr130510975ad.9.1762858091667; Tue, 11 Nov 2025
 02:48:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111004536.460310036@linuxfoundation.org>
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 11 Nov 2025 16:18:00 +0530
X-Gm-Features: AWmQ_blF9FjAmnxDm-OEcifjrwJ-MY93UlczB0ZdxrxOQ1Q0-Lu0Mfk5wdB590A
Message-ID: <CA+G9fYusa6ihh0LaYkFzZLoRMbEVm0U6DkHOxY9kXnh2mvB0mg@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
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

On Tue, 11 Nov 2025 at 06:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Nov 2025 00:43:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.17.8-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: a0476dc10cb160082a35b307f8dbfe4a066d41ec
* git describe: v6.17.6-886-ga0476dc10cb1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17=
.6-886-ga0476dc10cb1

## Test Regressions (compared to v6.17.6-36-g7914a8bbc909)

## Metric Regressions (compared to v6.17.6-36-g7914a8bbc909)

## Test Fixes (compared to v6.17.6-36-g7914a8bbc909)

## Metric Fixes (compared to v6.17.6-36-g7914a8bbc909)

## Test result summary
total: 126378, pass: 106987, fail: 4241, skip: 15150, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 57 total, 54 passed, 3 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
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
