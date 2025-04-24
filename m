Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A495521D011
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 07:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745480073; cv=none; b=nQxlzRFKCToUwzF+ewxw0XBZFQOThbKzh7/z7Jbcr/kSge3BAE8GoUSJ6/NvQRcRCCTBkzYloXqiLtQg1U5aKCaYuzeqvLJUKLCtHUvBQrkcP9ewvNZ6IyeSOPYdlIUNT+l5E3U32Hu+I169PRzEH+F8u+bG7myO8X3vomOEY+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745480073; c=relaxed/simple;
	bh=Dj1Lv1vYfLYfue1RADdfX9+Lvh8P7qLve8owX8a0Zq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MHAbbWF+45SLbRm/YyidAuwFUFjXqTMa/sxRb4JmjKUm9VnNRp9rz377VgQVyoGptfcan6HyAR/9WNkb1raja1qWEUKbVLzOXn34JLAvBWkHdSySWFQImCl59Ny2h2znbea6ZnO9DFjaGhkxJPyv93CaHNDYcb5KDtt9dmj8ujU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wFA8BWh9; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wFA8BWh9"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-523f670ca99so278832e0c.1
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 00:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745480070; x=1746084870; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hg1fJUqFPUmaQAIOsB514eMr/+6dxVQ5q9mfZaUqhwI=;
        b=wFA8BWh9Jq7SOZcg+oTtiiuqHXhSOititUSGNyx1XbeESzhuJihzE1NIiSsLKqS5mJ
         lW8OgZeRy4NjMSUwVeWbcVRDzfXBBfhCdrCy+PQsRx99ZTGk5eIOiFYsyjEPKyQvnjNu
         4hZha+HqFy6jf/ZI9FRujlhfpwk+E1l5Sa7CIvbsJqZuYsvDCxob11UVC5s+oRru4uMv
         JzE0w9KMSIqfBpuaJHN4fag5/RH9IhrFbU1N0q3O2JtXa4j5UUrBMPzGuZBVItmARUQS
         J3eZp2mieS8zUkRbjrqALuMwcVazeMZ+IUXcj0muL/oueYXonjU27caCZzIS05FboYFm
         cn4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745480070; x=1746084870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hg1fJUqFPUmaQAIOsB514eMr/+6dxVQ5q9mfZaUqhwI=;
        b=HgIY5RQDbn50KgbWJrRsb0j4IVk9EjP0Evy9ybNITIlsmIzYf9jQP1wGyEAr4a5jII
         iLYbtBBcvIDB82VgzKswpdSoKwD4vHq5KBlNHiYCsQk0NnFAOCfKx8l+h27cYaRp39we
         KX873hULqDOTQvAGsSpod/q1IfptWFJ4vPpcekh39MiIKKx04fesNoOFbi0k1nTcGD62
         XfHvacKy0AB4YCsIS61eOt2zdNoD2QHjznJANJmGFr7C8yr1SJdZMg+sv+QQDjWImkNd
         PeWS2SikMV3ILVG5UbZb74geTny2VFqZiqS8wqbvdCZ/9NvKYC0NnUfP5aNXokSCZRcN
         awEQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5JfokBTiVHKijQgb/EFyqnzjTrxwO2SdK6fEngMjZqdM06/AROqsuQ9xujYvlTGHcnG0p0cnr@lists.linux.dev
X-Gm-Message-State: AOJu0YyoSIk0fR3AjyVdd39Z0wWmIV7u4Ftr9JenKsMRkDzwp9w9S3Oy
	255Xx9k/Vg/sibG1BXrNwtOKamHoJ0uaIqSjLMA1CDyByfx2bmhRbmOHCsiUrhmdF5scRAv+fTj
	RgdVuQV1gQZEu292kxwX/c8alerrvAPjwy5aAxA==
X-Gm-Gg: ASbGnctcf6BHmHvkkVxSb227lyjVb9o373WGYBXUB9U4afOQ7dpA8ggb94fLf/4bJ7P
	RDMl9pXt+U8DC4G9t1B7RaW547cGT8lfPzjU1ynKepuND4MZTsxWKmQAFPe4OyDRspAXXaTzT59
	Jpzs60J7O6kH/XA2fwDcULidGdcGqNf/mm0Ystn25MNGxBhFYCUCZj9OSd
X-Google-Smtp-Source: AGHT+IH+AZQn/RXsq4aIiZBGFx6kcOfNTWST3Ud9lzCO1h/OKWqCizwpNOX6zINAICkkJCKhYFL2SJd/kzv5SZujIxg=
X-Received: by 2002:a05:6122:1353:b0:526:2210:5b64 with SMTP id
 71dfb90a1353d-52a7840b1e6mr978639e0c.9.1745480070478; Thu, 24 Apr 2025
 00:34:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250423142617.120834124@linuxfoundation.org>
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 24 Apr 2025 13:04:18 +0530
X-Gm-Features: ATxdqUF7KMwodSuA0qtPO12X0tglypY1DQaBNL6jLImWiASW8rwygFekJbp9zOU
Message-ID: <CA+G9fYtT4eEO8Bz54gsvhA-rLp2yP=LDFV-evO2Dacm45zHX9w@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/223] 6.12.25-rc1 review
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
> This is the start of the stable review cycle for the 6.12.25 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.25-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.25-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 56d2398227a26c9827858b438ba125e54ae8b9f2
* git describe: v6.12.24-224-g56d2398227a2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.24-224-g56d2398227a2

## Test Regressions (compared to v6.12.23-393-g7b7562936f80)

## Metric Regressions (compared to v6.12.23-393-g7b7562936f80)

## Test Fixes (compared to v6.12.23-393-g7b7562936f80)

## Metric Fixes (compared to v6.12.23-393-g7b7562936f80)

## Test result summary
total: 126085, pass: 105995, fail: 3148, skip: 16539, xfail: 403

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 57 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 49 passed, 0 failed

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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
