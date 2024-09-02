Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B09E364BA
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725291738; cv=none; b=DCzeXLD7UqVTy3IDUvk+0py6FnLalPNoP+qJ8sw1F9k6b0A7vDjI7jJbgH+UEgEY47wFBxPWEdT4crzexqiaUthoWKZ2pbtqg4cL1puGrd1iAUzhGsGbHIRWysXbEYlaIZrJKYZXci5Uzj+MkaOM+zzeqpvQcaIYFk4WPDEivcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725291738; c=relaxed/simple;
	bh=lABA3YzICpkncJQbNddt+/lNOx87kqfXweax2APi0ic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qk5tZAtD7UznD296JKSmOyjpPtm9Eb3z2nTw8wmAYFWia+lohoOcsmyIqQJWnvSJtMR7rtH2CqqYrAdFA4RMKbjZBIzYJ4pRBfdWYIkwB0wfTJd1K5u9SuETZt4P3Wt7m4WijFu5ekzyBLCVPVgb8I1e6ftwdBXcQFDCr7j+mng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pnA+UAt/; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pnA+UAt/"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4fce2c0707bso1266285e0c.2
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 08:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725291736; x=1725896536; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S5/dmVfHxRGHNMTJZnAIV7TVo2AsaFh/Woc/rAPg2mw=;
        b=pnA+UAt/oE0Tdbf2SVckeoy+5T7UALumjL/4EvI2gdhZNHwy4+cWzjFCHIdmMWwFf3
         XoAyFa1mKu6xjpQkxEPTYFLZesPPwHQySFZxNOBJbDqn5XmBpqf3FTBWt4NMl0vP/UmB
         Yro0EYpKC7Z6I8Yppa4Ti1eE4gPsOGtzkSHSsfojGWhbOD9F5Cwf6XZKiiqZZGa+Gp+P
         0E6HwZQhj2/ROiOuE8U25Cv0I8gw4yNWczrRgXR0bOrN9U5Y25PNz0LVGGFN3iL7WjIh
         Qgb8W59JASwmFbg+cjWANUYlktCIp/kkwvuwbx6rTegD57AUvXBUoIH9wPl/jfhAyAjS
         xP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725291736; x=1725896536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S5/dmVfHxRGHNMTJZnAIV7TVo2AsaFh/Woc/rAPg2mw=;
        b=A3zMI/gFvsFpupdQkj6n9Tsaj+nDj09Xf70mtONdwzZLzFVe1LoGyh/J3Iq/sALhKQ
         Q/OY7Vl5gAeWb07qIw7QCPre+TpA0cJFFnbVP5qgKRTn+mb4VpSF2mY7YT4kQp1h3yi0
         0w9391lX66w/CqHAiqXdPJzN8eVofH1OOMXcXJ3nvFc5oO7iXND6+em07M9a11/NREBc
         50UzsuOIgVJSKNUwHKzwy4u5F32YyURGNCusexcBp2/g9F18MS85HLl3YGsgaE2AwHnF
         gt7NX4NvPOGpqm/n15X+mfHpT3PlSy8h/mwAAcTJyUCdXE+EqynWdLmbWFQFPlO27Ku1
         KXFA==
X-Forwarded-Encrypted: i=1; AJvYcCXe7/VzzFpYZ2M7OQiPPGVKON6168YiWEHGN3b39dzq1luF9sL8MbCADmA00K8iSjkQBtTSwb/o@lists.linux.dev
X-Gm-Message-State: AOJu0YxqJ6GROFwfHz4JoBdJpC5cx6XfcwBpcY7XiJ7FiI+ZcYPXcCQi
	AdoJ4k9K/o03IlKHioSI6ia7zhLtzRVhgUdiD1WD3rBInixe6irhE4u0euC/33jg1M3sCfAlgIT
	EUI516v2i7n4TmeYA1s6/iBrXF7fjE77J9qyaVQ==
X-Google-Smtp-Source: AGHT+IFO3hJIhz6L6Xho40w0YwGvSC5rj10Ot/OdPzNf3JEsAeZAK7czgI5AItxJUDBdRIkaaIaxYsTxGpRTrb3FAHM=
X-Received: by 2002:a05:6122:1d04:b0:4ef:678e:8a90 with SMTP id
 71dfb90a1353d-500aad17027mr6105127e0c.3.1725291736275; Mon, 02 Sep 2024
 08:42:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240901160801.879647959@linuxfoundation.org>
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 2 Sep 2024 21:12:05 +0530
Message-ID: <CA+G9fYuyyJO8hq-s0Fiygmdmu0_SaNQouhPv5o5mq3_oAeT7pQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/71] 6.1.108-rc1 review
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

On Sun, 1 Sept 2024 at 22:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.108 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.108-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.108-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: de2d512f4921c4dca7994119b4310089266a546d
* git describe: v6.1.107-72-gde2d512f4921
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
07-72-gde2d512f4921

## Test Regressions (compared to v6.1.106-322-gb9218327d235)

## Metric Regressions (compared to v6.1.106-322-gb9218327d235)

## Test Fixes (compared to v6.1.106-322-gb9218327d235)

## Metric Fixes (compared to v6.1.106-322-gb9218327d235)

## Test result summary
total: 157741, pass: 137087, fail: 2107, skip: 18325, xfail: 222

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* kselftest-kcmp
* kselftest-kvm
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
* libhu
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
