Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C463B17C7C
	for <patches@lists.linux.dev>; Sat,  9 Nov 2024 01:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731115690; cv=none; b=JL6zZve0jqDrl4kkVvXODCf6I/e+k9jRaWHMiyxBDFeUeXTDC/kQOSD0ZZk5bfdNwTJCk38UnUFut1ML313TvEM8Fg0kkD61WUGUacWRpt40Qs1++tWflUSw/TiWYgmDxYqZObt6KkxanT92yN9IS6+yrLnFaECaCcvAUu1WWWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731115690; c=relaxed/simple;
	bh=0qOBjDBFQ7/bVy1TcDES0h9C1kh7nE15LzRGiQXWB0Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hE+pHZtyGbVh2+sxg+NALHItE9KPRrcUV8ngB4fGLzjHHRE37LnG15wst449yIJceaCAVoXxvbccQFyX3LU6A0s5YkDFlibjSnGPSZ9VAcVIQu+9fbDyoUXRSdHcdCWxSC8R1WGxWn4GdCoCpYtNIQi+kL/EYM+7uQOVPC9zRWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f3EDywhJ; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f3EDywhJ"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-513de426863so1052494e0c.0
        for <patches@lists.linux.dev>; Fri, 08 Nov 2024 17:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731115688; x=1731720488; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/PJTkVlX31ldHixqsdMfMAxssLgGROHTxQckOiGCTc=;
        b=f3EDywhJgvLCJVDx9Rb8ufLfnZ2W94ugYKYW/QxkIt/OCCfIbhZ/SigDk7+WfCwaUh
         TGUYhq+3joll+4Ilu9FQ6nRYoHbfhOZA+HCbmSCjgaK+RlzDREzVkA2UipCXoW5q8OhU
         1opvuzO6GaIWhTIYZtuKdb5HanhrkrufbSRT64jJ0lWq6s4zmfI9jF36Lrnh6JSxVLRi
         sIIrstLcI4WUE5l+FuQRGZNn4KS+ryuxYx9/0u9PUcrhxHPVD2t5W3/Sd4WgVchbBnm4
         rplTeoTunaH1cMR7p+K3FH0pQsQFXgDE33D/ho1m8qmKXVIT262S/KGN8rYL23U6Q6PS
         +0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731115688; x=1731720488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X/PJTkVlX31ldHixqsdMfMAxssLgGROHTxQckOiGCTc=;
        b=A0lqDQjZikUTGY88GUM2i7tGhSBwhIf9lgFwOplJo0dO3tCHq/SPwidQPP6AtOwUoc
         YJjYMrsYUDhKN+MlEupguiUoyH+pMyaoLc+sNS61Yp0g3PPf3yIMbdE0A8swo+ftetV2
         MzeSHtYvu+BbozZy4BcoecZ7VRcyjpzkuKgc0ZVOE4z7WRc5GZvmlU3hN0O1mIgOJoyr
         YKq1nUpuLykXKsO8G+msNoWfWNa2DvVCFQriebZ9TutsxrFp9DOFuTEvDFkS9l2yaj6r
         8grNQ/6xFGBlLzll1M7Thjk0xkxyYGmlNfWpwos8K785BRHxhX1xJqzdAwKOSsrYXKOd
         lxHw==
X-Forwarded-Encrypted: i=1; AJvYcCUDEh5If6frTOZ+P3F3zfpxzol0DnjbaGpz0HVBdS5qBywt4ZU9RZJq6KqCkvp+HVj+TRO4Miny@lists.linux.dev
X-Gm-Message-State: AOJu0YwDpiWMgYCyacQVINVrmPtTjr4UAwJuA9pykZrikVS8cCrR1MXH
	QjdmR42DLMha4lI66Apl2ka0tmBphs2iHvhABjNIy2yKV7+3j1HiTBva94hqlqsLaOQatIZdZPG
	1x3U6xgfYgbEVGSXcoFluqTZAGOH+BsnsaiNPMw==
X-Google-Smtp-Source: AGHT+IH4A0WlCjq74/Wfa1EzS4MKy9Vj7qJ45SzcSoIl1Y3odqZNyIYgD5QY/H+Ea2D7ncIbYc0XPx9spPHgk0g4z2M=
X-Received: by 2002:a05:6122:2a02:b0:50c:99da:4f70 with SMTP id
 71dfb90a1353d-51401ba15c3mr5317685e0c.2.1731115687671; Fri, 08 Nov 2024
 17:28:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241107063341.146657755@linuxfoundation.org>
In-Reply-To: <20241107063341.146657755@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 9 Nov 2024 01:27:53 +0000
Message-ID: <CA+G9fYuXK1LYzu++g6LUBOEhbOMQSO9Zz6AhM7100NMMEZLuAg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/461] 5.4.285-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Nov 2024 at 06:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.285 release.
> There are 461 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 09 Nov 2024 06:32:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.285-rc2.gz
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
* kernel: 5.4.285-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 5dfaabbf946a8554cfc17ba8c289fe5eda8a3e1c
* git describe: v5.4.284-462-g5dfaabbf946a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
84-462-g5dfaabbf946a

## Test Regressions (compared to v5.4.283-122-g10d97a96b444)

## Metric Regressions (compared to v5.4.283-122-g10d97a96b444)

## Test Fixes (compared to v5.4.283-122-g10d97a96b444)

## Metric Fixes (compared to v5.4.283-122-g10d97a96b444)

## Test result summary
total: 52133, pass: 32970, fail: 2420, skip: 16682, xfail: 61

## Build Summary
* arc: 15 total, 15 passed, 0 failed
* arm: 399 total, 398 passed, 1 failed
* arm64: 99 total, 93 passed, 6 failed
* i386: 63 total, 45 passed, 18 failed
* mips: 75 total, 75 passed, 0 failed
* parisc: 9 total, 0 passed, 9 failed
* powerpc: 90 total, 90 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 30 total, 30 passed, 0 failed
* sparc: 18 total, 18 passed, 0 failed
* x86_64: 87 total, 81 passed, 6 failed

## Test suites summary
* boot
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
* kselftest-mqueue
* kselftest-net
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* libhugetlbfs
* log-parser-boot
* log-parser-test
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
