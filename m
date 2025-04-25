Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2545140E30
	for <patches@lists.linux.dev>; Fri, 25 Apr 2025 04:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745554754; cv=none; b=TZP6J2CVpuiWPyM5io40Jwb51wtyIgB47+vYPKPp860Eo5C7am8prEyyd+yGYaf+IZhbhpMlA/IfEdrH1qEUf3UPqCuNehRgV/5E6VRn8Ry2fS8UmIDTVq7Qc1sVIdzOYsVZVGavB6zut3bwU9TU5Kq9M6E9jqveHy2TYuM6Y0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745554754; c=relaxed/simple;
	bh=MkDiSjZZ/0iAAfFOyK6j0IGGc6Y3lJb9LactDURdW4g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MOyoCSn6Qx5uH0Tz1qHNoQhx5Q2JBlgZChxCjRq0j/khsYFAMKRRGyDC0A3nFjljn0AHVdL8Xy+3Ovn/OXNNSJgTjPcIH0/WiioC73F7j0ruCCqh2V9rlTtduJsKzfI3gFF0IqzfpIOwc7Ctj2bh3Qd1XUwpyxHIhabOUxyPSuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nKP4dLjV; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nKP4dLjV"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-51eb1818d4fso2371940e0c.1
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 21:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745554750; x=1746159550; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3kk9yJMheVJ5fcTPuvXjKALo6qxlbGvpYZFmOVqtbw=;
        b=nKP4dLjVhG9JA5FnTE8/85bfu32Ij132UbiRcFsNPha0XlEwuG2IGHAQya0v22CMHQ
         MObKtvNpUscpt/s0ldg1jBS1sR59jkSuWj/+5G+zSSEElmkhyMK7gu3gny4Tyejhtl5N
         5FvLYne/5k5CL+IlmXf0Xi1DvIX2aQE8hM9xu3ch6tRfF2eyPuMWt40oKbICNoQjL0TX
         NkEmx4bDTrzioVUFGxEVneFrGfc8KAsZXP1f1iIJxB61yhOpOtb1ruYEAtm/l3aztzPo
         G/pQd1C2iTBUkY+kfsDjZiiMYKdIDxCOqqYWDvf98zBq8c6RgrhHAQfHSeEvt3Ag5zBW
         OFKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745554750; x=1746159550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t3kk9yJMheVJ5fcTPuvXjKALo6qxlbGvpYZFmOVqtbw=;
        b=cFNTeE4PdQhm/YoLi72biT3c3u+D3c5TBCN35Q4W2JImkwGMHc2cHG7szEWnvxR5BV
         +tBKa/l+62PHHkuzkNUyRBeaPR57xJSn7Nc4ematM3nHHzQpHOTGqQVyv4AhcBfl5o1u
         PQ7Gj+rzgBNwjStrQ7IIoelEp64wgJoFKssKJNgGKkc57tIXFm650DI0lzsFxQWZLa/I
         t/z+zkYCS1MtseHYO5xCm5CdoICdRsCSHi1jRW87EhQreNfq3mgoQlfYz4hcZyFzyMgG
         XHUu6/v3ed1NM7W0c9Vg1NStobsrUpkeL21VA/0DvF61f/10Di/JVYAZ+tP6yWmT3tBy
         a2PQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9S2pii6cmmAIwBNsTkzhbcFUXzgPOMInMbx2K5qXNfKt2sFvX4qbz4C+5N/A5zFC6u9jjIGmO@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3Q4A28lG7WacukyTsLiOE+IyukA+qLLFnKfor4/CxB24tweCL
	LD8JqCiacERSS8iW6g+XO12ejEap6uxgz1ldDdK9K2H7iNS7g29kpUiZaPkzzP7u+gGlfPTXgAW
	0iI67Cf423IFusWvqTA+OjDhDlOiSXXwWUF0/aQ==
X-Gm-Gg: ASbGncu1dLAkZk1XTpfGgQReC3j6ca+3BH0eDUT/n2Oda0C938hDx3QCU4Sx2AkLXHL
	bD6kNFGiAI7Qb6yJHPXW1h07FF+dIAODlsGb0fs18Fvm55c37W87m5CkU4lZo7nkfd7SopGXrHI
	45AgiMQgXvzJMAvZV55eLawzmAs7lNXn3xnmmjbcsNyNe3qYgclEM8JxgpqlsEHeQVywI=
X-Google-Smtp-Source: AGHT+IFIYRceIoCnN621cqMGlWwEG92deWxJ9yoaz0m5Oi2fzhMnTvsvMOdi2oQRc8SZ+44d4Y/vnujmBeCgUrJlFFo=
X-Received: by 2002:a05:6102:3ca8:b0:4c1:71b6:6c with SMTP id
 ada2fe7eead31-4d543ac5dd6mr275821137.7.1745554750320; Thu, 24 Apr 2025
 21:19:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250423142643.246005366@linuxfoundation.org>
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 25 Apr 2025 09:48:58 +0530
X-Gm-Features: ATxdqUG5VErkrlfJIDEFZLkqsJY9LmUOuwtsoWkPAPv80HHqYIoYzj0mTCfuYsM
Message-ID: <CA+G9fYtRbNtqBB5d6w=exBkWa+KgYqB0qA-2qXd_LhHsx-G_5A@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/393] 6.6.88-rc1 review
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

On Wed, 23 Apr 2025 at 20:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.88 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.88-rc1.gz
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
* kernel: 6.6.88-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 2b9f423a149b8cc7f21741efb02e56cac442bb92
* git describe: v6.6.87-394-g2b9f423a149b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.8=
7-394-g2b9f423a149b

## Test Regressions (compared to v6.6.87-1-g268d2a7e4698)

## Metric Regressions (compared to v6.6.87-1-g268d2a7e4698)

## Test Fixes (compared to v6.6.87-1-g268d2a7e4698)

## Metric Fixes (compared to v6.6.87-1-g268d2a7e4698)

## Test result summary
total: 123381, pass: 103202, fail: 3126, skip: 16595, xfail: 458

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 20 total, 20 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 36 passed, 0 failed, 1 skipped

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
