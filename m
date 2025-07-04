Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0EF246798
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 11:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751629694; cv=none; b=fXXQgOxoWcmXADWS9QrRDzUiydprIXMGiTrd2ujvddiOlfyZmUMvsyKNcdMA9m/1GwbweQ9seG+7S2FIYu3WszFu8KEJ+TEjuN5gF1JnsGhHVlvNv5uczT0lx+VDeLwmxJuDAdShbTNnJYJHhYJ87fzGT9JlaLuFsZz69dXhbyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751629694; c=relaxed/simple;
	bh=BLt2e4gYJDfFUIoqp0C1xUglnvplbIMHK+j3HeEZ7T4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u/9127PiEQmN0y3Zzc5+uEHAzpg5a6fM81ZUrupycT8M+gLBAzIend4YBAWaSi7Qd4H91sOm6Nxf3Xi6LkiQN23huRsZyI5Hsb3gO7jSk9wBMRjGTXVXTnrmBDv61DY5YuxOw/IlLDlei3EAV4hvp8ixDMwWYSOXMquFpNOGEjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Pti6m3VM; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pti6m3VM"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-234b9dfb842so8514775ad.1
        for <patches@lists.linux.dev>; Fri, 04 Jul 2025 04:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751629692; x=1752234492; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DUjN4QXidtuC9MgKWPzYZIK3wmGJF/NB5v4vy9SsyI4=;
        b=Pti6m3VMHUrpv4cJbdIj3olYL4zi4dc1oaITeOVXIT0pRtVdSksnyC/uYSFonYfQks
         t6owe9QKuwpto9nyAb1bQScqKZKOOlROz/HQrDZuyNwVSRoZBm4gkidw/NnUjGLVgTKh
         Im5DJfID+PqLb1ZO13LvCSoDvDiQgYb4/wVO88p5wWtNIRF5EqTRQQetwvVHKpt7Rot3
         nVlJ+BQeE1Y0H1z+BC7C5cYavYRWO7bJ7EuldKEZlm25h+hZrqpgVeH3C5S/OajwLbML
         nmKV7toEF7JAwoTuRwciHTBq6njxmrcCT/FFfchruJ4J320EhV8bj+kH2RsiGy1MeQIP
         OWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751629692; x=1752234492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DUjN4QXidtuC9MgKWPzYZIK3wmGJF/NB5v4vy9SsyI4=;
        b=jX/dKjd592ogiqRLAOTrI9I6vqKSPJgTA5G+MwDFDlxnNM+hq+RuKqd7abtg/BUXh+
         IjgQyHYajDkrffGESqj19q017yfQCQH0RA2PV8X7a8s10hK5xTrU6ZEi0rlYxTVVMqf/
         rjoLGQZ2S5o3Ot34/np10M+757CyjV8P6yqUb2vWMv7rg8a/JeJDRJzD+g6iC4RsKEzH
         b9+PPOb54AX/b9Hw9rjyaBqBigsxrXRJ8TjTyFia5dieLO4ozFJWvaIPyr0MBpUdDyZd
         /2YdDhmmaS8Qz0pj4SmLhuODE93jH4eCb+65kcQcc0UONcWGEcyNOmQtlZCfu3f6jf8H
         KcYw==
X-Forwarded-Encrypted: i=1; AJvYcCUR2GGYTfteBuMjujBdyTBhJuLaYfq++pp7zAiT4LpIoEtGbVaoxq7kzsFzFo3CwaTBh6/pYnCY@lists.linux.dev
X-Gm-Message-State: AOJu0YzZBsAPmKfHObs8CVgZxFCA4+r+EobPQvjyt3lBRvIBZXxhHQIl
	9aJbdK4CT2OQVe0zLvEOaMoYODRME6YvIVHRPLKjsYo9Q77lId4szqMZtY/PKqZwciiJqw5Mzsy
	5eO3ClEsIqa2HDZ3aT4Wes3zuFO/MGaY1q77nck5VgQ==
X-Gm-Gg: ASbGnct+CrY7YyuRHmwpzEQtwAp31ySbZII5h271wfA7ckFiw3yBUjeorDlLwys872+
	7frHavYdUF2KZLyqYzCyJ9ddREUnM2ehVHTaXjyuAHoP/uhbpO0rDWfti5qqISll3SEiRPyi8AS
	Iy6SNyNdeRhcgbyEycEyl8mHN3C7OcSK++waHIXT5OdxRkPK2wMQpmYeT4YwHBgAcg5s/gpnAsB
	XlU
X-Google-Smtp-Source: AGHT+IEZP3iwLGUJFpqwoWWIOW6UVQ23gWdyxZYmObiHJnJt2wQd7+1nwt5UYR1/ti449dFIgpH/kWfqiz/Bd7UHlwQ=
X-Received: by 2002:a17:903:3d0d:b0:234:dd3f:80fd with SMTP id
 d9443c01a7336-23c87465293mr33713885ad.2.1751629692416; Fri, 04 Jul 2025
 04:48:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703144004.276210867@linuxfoundation.org>
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 4 Jul 2025 17:18:00 +0530
X-Gm-Features: Ac12FXybOZIGHC5PyPBUj4nRBTvqSKaPmqw6NTEjvBZOrsk-eVQnQskIsVP5bTI
Message-ID: <CA+G9fYuk8=yLbdUv7ngQ0b5_p2-w21D6JdOYDcsdx7XUK-aQ=A@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
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

On Thu, 3 Jul 2025 at 20:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.5-rc1.gz
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
* kernel: 6.15.5-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: d5e6f0c9ca48c1efb86783db4a2b4e457118c27b
* git describe: v6.15.4-264-gd5e6f0c9ca48
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15=
.4-264-gd5e6f0c9ca48

## Test Regressions (compared to v6.15.3-590-gd93bc5feded1)

## Metric Regressions (compared to v6.15.3-590-gd93bc5feded1)

## Test Fixes (compared to v6.15.3-590-gd93bc5feded1)

## Metric Fixes (compared to v6.15.3-590-gd93bc5feded1)

## Test result summary
total: 261397, pass: 239055, fail: 6046, skip: 16296, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 136 passed, 1 failed, 2 skipped
* arm64: 57 total, 49 passed, 0 failed, 8 skipped
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 0 failed, 1 skipped

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
