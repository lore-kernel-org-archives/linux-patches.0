Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851C122156D
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 16:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746031782; cv=none; b=dQ8DoN23voiEiqtWBAZPYxXSqBSdCVTmRh2I1rkrpazOfO047jK6ClIfkZI1FUOl4phAfRn4CH1AuYawTjxEAVbV0NjqU9xkDcssLXEs/mlCqscq9J/MVjpjvFYOg6lw5cyq6YSSPS7y8prI3uanhb7GJ5NzaO3lGp2AaRzhEgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746031782; c=relaxed/simple;
	bh=3rnUtBbGRrj2GtfIBzxXQYWs4cLaMq+FIs5BosSWcq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nDjrzzL6iFyyvwRBOiqo1I1Pr7PsIX0rdzU2WehtRZTLPTUojzFCG69u0KOgFiESAuanrUMNh04043x/YoAakH5j+02ANgrmggeH/3OG+mRaP+lTwtVV/PvrRngnWJkCN4kMKg4ivDMxHSMAKpesC1t8JNCLCsd7ZvsN1P4HLOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lv+rI5Hh; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lv+rI5Hh"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5290be1aedcso793165e0c.1
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 09:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746031779; x=1746636579; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K6wGEOSopeYQzjMpu6ToZD/+3YW6eIVoWLjM6+vWMm8=;
        b=lv+rI5HhMe0q8iACJLpWQ1NaQv1xkQ8QnAMMVqFVgH8J47/iu6T1vq932R2EtJet7O
         LaTvacISNkuxY7m/ZuQa+KQpy6FOi0yCw8udd4o/UNr6q8PVJHVlccJTgBADrazirPR3
         +YNzrksFd57JjtErEUFMo9blxL0Cv4Tw0NTrLx2c1GydM3r4QBPpkDF0+NezZ4/diR+b
         uM/emownV5r8fRAYkr2GQqThp/qKCt7uOPHGROECcIDQCmTsejx6i/Cm0dU2F1a+OX2J
         YoXHpY0tNDVHh/mqCor8P3NuAr2VUXuWRhXD3KElPmgbqr0hSA8+R+rXqKXfH9Q+rw7d
         K5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746031779; x=1746636579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K6wGEOSopeYQzjMpu6ToZD/+3YW6eIVoWLjM6+vWMm8=;
        b=Kqn+Z/j13WoV3GuCTz7NMdKnDrsBaVrO9FPve1i8goxMmu7ZKAPC4/BTJdY9ZHtGqw
         bdx5096zmnkhkp3gY7hpOnH2ugDVyOI/SQccr6xsSIYc5t3aFqL0EclvVzt7/sIKVjpG
         8A8xExatUWLLigJ5FSqdzyDFPB3HB5KPCYwvyM5X85Grw12Saz1kGwKO8bI3ZiYZ/Dft
         GIDqHbdY8fqQWxrLsyPuEEuDaPww6NWwSHNuznQL7YZLs4cVH+u9IJBcNw3FtYpykiV0
         BmhQLGZI/RilWWPCtJCuotAILmQ3oT9eS35wapzERpqwzKcM1tyVw56hCz+XP3S1wgPc
         uc8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUWrCm2yOEDKm3nlxdyBc7rLlI/rHIjBaobKCow6oLgc4Szir+o6A+3WWJMEiN2Sv6fT1yf4mdd@lists.linux.dev
X-Gm-Message-State: AOJu0YwRDmI650wHX2KpzAlnAE73DGeybKOUIkOtwIFHbOBJbIHXXcYt
	oIbo5AZHG1nw8dL+NL7OyhdhqvDGd9BhOP/0J3SfjtYSP8s23xswvUh4ld5HMe5DGO5yk/U7fpT
	GbXaivZqDAj3f89jjy6tTh81MgMWtirEQeXI8wQ==
X-Gm-Gg: ASbGnctzWQjSiEwMV+ZBf10qX8Ls1t2eCMHOYnp78KYASHOqN5R8SPzV5DTV0CaehZZ
	0dByU9ubanXMgvJMqvKsfervmMUYAraSjVpCTovUfHh27R1e9aHmJGiijjT/VuLnTSjBZm3KR/S
	AhNd7UDGh1l76biNxLZkcKSXnr3vjA3TMLnrKNZBadaewb+c2StzKZRbs=
X-Google-Smtp-Source: AGHT+IHB9EAwLxpqiSSeqU27ovIV9mp5mBfnZNLtn0Kyqm5KskL5elpAVGIgTEid98G2EVBqt6/xAa/38um/Xx1bBi8=
X-Received: by 2002:a05:6122:1ac3:b0:520:4806:a422 with SMTP id
 71dfb90a1353d-52adbc88c7dmr243623e0c.3.1746031779296; Wed, 30 Apr 2025
 09:49:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429161123.119104857@linuxfoundation.org>
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 30 Apr 2025 22:19:27 +0530
X-Gm-Features: ATxdqUHDFBFjAk7YpA8kz6XQdc4Jmx2bsFw4-LGkVUjB74in0vBizWcCsZ4TzB8
Message-ID: <CA+G9fYu2_JCDFF+RtB2-nw_zcPYcXzNEMhZcM9cU6DcjHwTsTg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/373] 5.15.181-rc1 review
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

On Tue, 29 Apr 2025 at 23:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.181 release.
> There are 373 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.181-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.181-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: c77e7bf5aa741c165e37394b3adb82bcb3cd9918
* git describe: v5.15.180-374-gc77e7bf5aa74
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.180-374-gc77e7bf5aa74

## Test Regressions (compared to v5.15.180)

## Metric Regressions (compared to v5.15.180)

## Test Fixes (compared to v5.15.180)

## Metric Fixes (compared to v5.15.180)

## Test result summary
total: 62723, pass: 47525, fail: 2904, skip: 11880, xfail: 414

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 30 total, 30 passed, 0 failed
* i386: 22 total, 20 passed, 2 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* boot
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
