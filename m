Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7EC1A262D
	for <patches@lists.linux.dev>; Sat, 15 Feb 2025 12:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739621541; cv=none; b=LbP4vn2eAL/44P4Oj7/O4mq6rt2ZMulZdLTx+Hua6inw9fXgnX6KiVHv1gc6M/rf2YYkrTge8LRGJV1KMmFYtjjO8Ic9NVR53Sjjv7bChfJ133Ftrb1VkUaXcFMUJWpp93A/PJHQvO8UDiqTy6ezG17O2UEPAsPKwXZwb7jSooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739621541; c=relaxed/simple;
	bh=qm7JqI8ig6K5eAnFPE39CQ1/XQZUUQaMrkJkh/owUOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SdjG7EtA4vIqkna9KaY71KqmG9tVxuBC4DFw+hS1e1SK3fCE5KbjRUtVi9tSegSoXsFZdryQ7p5TwmMiUOYH7Z+fPe2Rm6a/a+/OtEEEKGM1+bJNo9w0xK1xIAixxeva5DSknPuBTAwIBlZOAus6t+xYzjsXTaObP5N9eYxiiO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zMIlEAmB; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zMIlEAmB"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-8670fd79990so832286241.3
        for <patches@lists.linux.dev>; Sat, 15 Feb 2025 04:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739621538; x=1740226338; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzyW5lFbonLTH6dEaUk/CVs9DpxDfukUfwlAaCnLwjg=;
        b=zMIlEAmB5zmp+F2Q7rm5IB+/GJ2d2O6HxE2SeRc0oVlRPUq8BMRxSUe8gk4Rp3YtAW
         XshkCa2xeUSNASPab7wy11nNNmeZ2RChGqbex7LE1YD9yjDyU42+KxRZev/NX1LBh9WJ
         28t8JSUoRpHeAnHaP+XH54nutoDVMPUZd3vcd+1jTKkxXVqnyIU15piZ/WxivYAqbJtc
         x4ofEUBrFNMASjObfIOVsdOac6Up8ZPKP380oRuM9QJKzM08jNCIuNzQ4kB830OyytgV
         1TgfAQs6S/xEsWZ7eDW31tiFymL6uhrIOSq21risbHt8oJ+TZ0YvWJ9UUwV2c5B4ULNj
         w15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739621538; x=1740226338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IzyW5lFbonLTH6dEaUk/CVs9DpxDfukUfwlAaCnLwjg=;
        b=XV/m/zsAITm1hYcEJOSdFdqoquKxGkG+wQ2lkY7mBhN5/tJ0bA1tLLjeAnx3imOP8C
         nfqEF3QJxBtRkY0GxIuvSlz5/D8fBwTp3IKrUnuiw7oeR3V2LoS1QypP40264XbXil1g
         rja32JBsJR16mDJ0xVMygdm8K8utpmnTyIrITnTaIqwp+2FAEcmxktSc7iu5vssEOf9s
         +6nGH82/V8HSEmpv4N1SGLd8zbYaLkClKFAzfSl185SoBY3wwgFjn1PbNpEpoFFTPOgA
         DFjZItrNYRRmTSQh+ZACYEGOp49yNp9GsXcR7wU0nIIGyfzxE6+8bmO3aJYsa8NyKnuY
         mAyg==
X-Forwarded-Encrypted: i=1; AJvYcCUk5eQsGc35VRtWFlWTmNJQvo0nRo0k3M+Ydj55p8qR6Ff6JLiuRdAy/UoYI0prBjvqKegXnv8o@lists.linux.dev
X-Gm-Message-State: AOJu0YxYQ+xmmVCkAV+8QGEJSpSuCyugO+LL5y8T6va+Dgl3NrwZQK4v
	h0YySf+SvzFnOw7cqE8k+7LOLuk2aUOJzSO54ICEOe600LeVwMpXY6f3g5Xj0cEs3xy6lI586Xp
	80kmSO/6vsOT77MzVXkcTjxd7oHfmqAUcD2W/Lg==
X-Gm-Gg: ASbGncux414ricJP6MFh7WGRCrIAPkbijvg9p6qKYfCuuYAqx0LVbZGSIdmbpcIQTog
	WGXg8KkLYJkeHTbh5k5iTlcxMfhRjilp8N9po0rJSrkCCe8WxbpL+9LEqRxo+mg/ja+sAYuXmzi
	6I6NlS9f4AcN8rSMONphMcHrAkRqBKJaU=
X-Google-Smtp-Source: AGHT+IG+qAaL9INIii0CYjn4sxooc4GBiJBUznHaqojYczUXsH1b2QBXbNmC4WxQ129FZ9ODjRKh+gTNEJ7w4OX7SZk=
X-Received: by 2002:a05:6102:3fa8:b0:4bb:e6bc:e164 with SMTP id
 ada2fe7eead31-4bd3fe8d0d1mr1766320137.25.1739621538337; Sat, 15 Feb 2025
 04:12:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250213142407.354217048@linuxfoundation.org>
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 15 Feb 2025 17:42:06 +0530
X-Gm-Features: AWEUYZlYUCeB6Xdq7w2fGkp4n_51VEaKcRaaeoXlSkD-V7Bi0gZgwQIacbP_7zA
Message-ID: <CA+G9fYsnK2+tfv3Oy6PoVuVDn52dPEejb68Gh7Lx69GyJzOS8w@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/273] 6.6.78-rc1 review
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

On Thu, 13 Feb 2025 at 20:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.78 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.78-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.78-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: e4f2e2ad0f5f9ba880bae6771875ab6c3b9eb64e
* git describe: v6.6.77-274-ge4f2e2ad0f5f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.7=
7-274-ge4f2e2ad0f5f

## Test Regressions (compared to v6.6.75-390-ge5534ef3ba23)

## Metric Regressions (compared to v6.6.75-390-ge5534ef3ba23)

## Test Fixes (compared to v6.6.75-390-ge5534ef3ba23)

## Metric Fixes (compared to v6.6.75-390-ge5534ef3ba23)

## Test result summary
total: 56711, pass: 45681, fail: 1533, skip: 9334, xfail: 163

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 38 total, 37 passed, 1 failed
* i386: 26 total, 24 passed, 2 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 12 passed, 1 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 7 total, 6 passed, 1 failed
* x86_64: 32 total, 32 passed, 0 failed

## Test suites summary
* boot
* commands
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
