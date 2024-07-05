Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF00A39AE7
	for <patches@lists.linux.dev>; Fri,  5 Jul 2024 05:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720156622; cv=none; b=PWX0RkYuUxjVa8v94a7U93D88HuDI9uSOiKO0s25ec4OI97jXHjB0QuStZpRh/BXM1AWndqoqNsn6j/UUUL7x1j8vExJ7xXXgNyhwaRXIe9ZUUmbf8PDc+klfLqq23ho2f7sUW0srnSBfSvOeC/sViMMTRroIobxwuv0UpoAHss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720156622; c=relaxed/simple;
	bh=eV/nkZdyqZdInofMqMPDmfgFsJ/TeERWl7Ba9KOUmS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oTUrd881j3tU29cAJLh5kG+kybtVAm+lbqHHBISUk8m92rzVecbrGoxmKergIUYI5IxCkrFs+6FhhxDZJtkvKC/OQA65E+3QAEzfyF7GysjrfemFonQeeWQzq+ukqS6utfXj6LM6Gk1UknQxzNOBRkzcYH+YdiLru2+OKITtq4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kTbHdv9A; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kTbHdv9A"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-81015861ca6so292246241.1
        for <patches@lists.linux.dev>; Thu, 04 Jul 2024 22:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720156618; x=1720761418; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1HMKJv3AgpJkT4V8tfr5qb7gG27gguNgb92GAH47WIc=;
        b=kTbHdv9A+qNApNN286zpWp+bKrYw1xN23KwXp0avbB1kjRVAsRsczk4P+RQe+BFCA/
         5/8ceOyS+2FiER/qyBftB5wlMzfaCZSCX1rf3o8eMhunmquMJjUCCnEcD0o6MelZrVu5
         zZf2PCHtFzNdTeq2gqbbzMH8mckKiHcAzhSHazUTzpDtCyMf9b+01me+zAJYUW8Buy2e
         D/vu57gOFvc+kOzT5bN+DMWXvPn15bvv6S5vWey/FRjYyl/xRHRHsze9ZJqpqcVHaLoN
         jcC0wn5Y/QET7eVnTUA9HkrLe72BugL96BR+Lr8NfCnq7rtbC/56w5Nssw5Rr7K6yhtt
         CHTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720156618; x=1720761418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1HMKJv3AgpJkT4V8tfr5qb7gG27gguNgb92GAH47WIc=;
        b=MImDStzP1HQ8kd8ycU8gCrCekX/pK4k93AwsKah+DfFFLPCamYRa/dkQpoqfRglKHJ
         BDVNLGQtm1Mh1A5krq09jTYoizpdkM76PVaz/DH8uFa6duyY2eSH+U38aIqd18x1PUqH
         +t98tiUXJsYe6wS/r01kwpfVYGW6NZcegGUXGWsL2+G/76eRGhBQkdZbjWhmF9YDpDQX
         WHt8zlMaHVhQqFSmj2XK3HudduxErM6tV+ef8UVNVD70dJ6DgDiioQ7d5u4wt6TDEq8L
         4f986hSUr795Ygseq5x4pEDIEAahs00vc4HV2X+aWeqoaXGCzqwcMylktseoQl8vqEyb
         EV1A==
X-Forwarded-Encrypted: i=1; AJvYcCVpS6bZWZ24FnipSFw9eCXVnWSuKOQ/6k16UQOWJsSpiJKlDq8OqJ8pkac3ZPjOceZQWynhDvwVrdPo1bZeWNHR9mUdK94NGA==
X-Gm-Message-State: AOJu0Yyyiw6eKz/3sfyzN9B0bTiyvV1baLnZE8Ld12GOXbodCovYT52A
	sLiswnlA1tKxMZGAXeDj4zm6b/p+VWG5UbOfwp86ddZjcAHopYpL6o8vDPj76ze1E0CpAXgYyUR
	d6MGs6A63Et1+LC1G5Auo//b45JIjwe3sjaFNgQ==
X-Google-Smtp-Source: AGHT+IHjWh2hS9NmXKggVNHBGdL8yXRhq6f6T+0l/r+u4P93qIEaL8OXkoLp5kLhkFi2eygzh9RpeY03jYDK8twIAHk=
X-Received: by 2002:a05:6122:400e:b0:4eb:5d5d:6add with SMTP id
 71dfb90a1353d-4f2f3f97b3emr4087711e0c.13.1720156617842; Thu, 04 Jul 2024
 22:16:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240704094505.095988824@linuxfoundation.org>
In-Reply-To: <20240704094505.095988824@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 5 Jul 2024 10:46:46 +0530
Message-ID: <CA+G9fYswG=vrfp1SFmhsbM2Qno=WchrdyFzgEvhoAKVuyOS29w@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/284] 5.10.221-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Jul 2024 at 15:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.221 release.
> There are 284 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 06 Jul 2024 09:44:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.221-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
clang-nightly builds failed due to following errors.
  scripts/lld-version.sh: 18: arithmetic expression: expecting EOF:
"10000 * 19 + 100 * 0 + 0,"
  init/Kconfig:65: syntax error
  init/Kconfig:64: invalid statement
   - https://storage.tuxsuite.com/public/linaro/lkft/builds/2imFeC8AXBH72Ay=
uJQzpKgizG4t/

## Build
* kernel: 5.10.221-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6db6c4ec363bf8c7cfbc8ce2aa96d56be3bec0dd
* git describe: v5.10.220-285-g6db6c4ec363b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.220-285-g6db6c4ec363b

## Test Regressions (compared to v5.10.220-291-g4d0fada143ed)

## Metric Regressions (compared to v5.10.220-291-g4d0fada143ed)

## Test Fixes (compared to v5.10.220-291-g4d0fada143ed)

## Metric Fixes (compared to v5.10.220-291-g4d0fada143ed)

## Test result summary
total: 219123, pass: 182165, fail: 3108, skip: 33676, xfail: 174

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 204 total, 202 passed, 2 failed
* arm64: 58 total, 56 passed, 2 failed
* i386: 46 total, 44 passed, 2 failed
* mips: 44 total, 44 passed, 0 failed
* parisc: 6 total, 0 passed, 6 failed
* powerpc: 46 total, 46 passed, 0 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 50 total, 48 passed, 2 failed

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
* kselftest-sigaltstack
* kselftest-size
* kselftest-timers
* kselftest-timesync-off
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* libgpiod
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
