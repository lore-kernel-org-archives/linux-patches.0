Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6865118EFC6
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 12:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726059468; cv=none; b=QOeNCtYxig2jgdturGKu7gZlON195vziplRQXI9CQvhCX0DeXJlrXiUb3uMyOcw4jGBFPwha3n1tD8DZBguYsT5BBhgyXcdzSxREmGSZlJFHLul6bBFRp0tnK+scFKIsuqnEnfKv1bKclno4GRQ74mpqqYGz6gsjNxk8yeNyPLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726059468; c=relaxed/simple;
	bh=py2pD0Pq0vpzfrzDMAVzVk57MagcEqVYkZhs4XL3Rjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bTpQgdiVmNrAG23hFhwwnBnEj3IK/EHtAlGRQ8txxMuZxCkykU0o5u/UVSXzWM8UpDxAm0yZg+KAhAM9sg1YXAMxMUQSKySZ2mo9bBimGxqdmsG45UfZqyBIEKj5vDtDv9qXvEENX4rV8gyaTIvyLRloOrt1nz4JG9nY+tNsh3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L4wJ5nsw; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L4wJ5nsw"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-848b77c89e0so1041107241.0
        for <patches@lists.linux.dev>; Wed, 11 Sep 2024 05:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726059464; x=1726664264; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J2zaI7UZ7RWDNU7AWz06LrHmxPf0VmWUXHRPF7+e9M4=;
        b=L4wJ5nswbKy0BYZX5FciUlPu6Oh9r7FcUxnVNKcaCJLYhwadMZW/wUxaSCfEGO/uWi
         PfaH/iEppDKyahOIaE0BRxPOtmyavqC/ODe0B0tF0z0kKMVza1NXZ7wHhaM0PQnCaKjS
         cIilJJEJu5vwN1Upy7NkEFj/yY+aeeDajqz+MR9PJpP/oIUblhQGDxrwbXv77Vp8PIdH
         iTqfIr0QSd8IKr0l4bO6sWJwntKO7zYC8VBQKMDV0eokMDePpMdJeFlHtfeE8cwFMSQg
         giYRueuDCQLBQ1dFN5bnWhvx7NLAo+kC/UrUTMGm2srzefqTm5vwl5FFDNCAm+4rHOq0
         i02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726059464; x=1726664264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J2zaI7UZ7RWDNU7AWz06LrHmxPf0VmWUXHRPF7+e9M4=;
        b=nZYUXO9qUCL9bZYbkXupEIk3FG//PSkfzAFD6YmYKM44eO9oDYCkPEsJSKDdQajeh4
         9th5DZdmXMTJ6g+gg28j+fnaf5b5TMwqDewZAfqg4vKx5kfINLSjKmTDKFQJsV7wuN4/
         MM+FLyjmSy+6VduE7E1ZgEF4YtFLc08eDUe32ypZK9Z3qiNmzlX8kIE6FPmNvIgzq385
         hdI5F/fs6zhENIuGyrrlUm3mGpwsh/9hwO1Jb8NF0LzdWW03g/NEbV3mA+sMYwmjog9E
         YGncwNyv7ItcDZNHnSvYWlxB424d8N6cfe3L9fHOr+J7IjF6Cx3TWaeFBwF2wN73WmrY
         FJ0A==
X-Forwarded-Encrypted: i=1; AJvYcCWwIX7bu/L6mXy/8H+dkLUfmx4epfMAAImfn/g62GTFAahEp9prAnMQbY8Y4fts6V6pZrjZz04/@lists.linux.dev
X-Gm-Message-State: AOJu0YxR3Gcg3+PPSy+GK5g3GS1pfZs4wxm8V2/sFKuTb/GclR/sssMm
	Q6iwvFGhXMlMrqIKjSdqQZG5oWHrhTbNsq5BwM7kgMUC9ZtRRRI3qWqEJHqVHngiQCPGU72PgAB
	NULL0SC6oZSdD75oTVcD7OvvBWT6LQfC//eE9yw==
X-Google-Smtp-Source: AGHT+IG4WUNGKSQ48Wdrr5DaQdJ2TLeXFlWcx8SVurf0AX9TOtlE6d7X1xwM0BWuWDG48CdJ6Uy1+Y3ww1VrqumTpHQ=
X-Received: by 2002:a67:b918:0:b0:498:c4e5:bc4f with SMTP id
 ada2fe7eead31-49bde1e349emr15829954137.17.1726059464250; Wed, 11 Sep 2024
 05:57:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240910092545.737864202@linuxfoundation.org>
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 11 Sep 2024 18:27:33 +0530
Message-ID: <CA+G9fYsutqeYt4YZnEQR++7N6pmN4BqVnZLZgyKpCZm85y+-Ug@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/121] 5.4.284-rc1 review
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

On Tue, 10 Sept 2024 at 15:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.284 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.284-rc1.gz
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
* kernel: 5.4.284-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 310fd584bff35c61219eedf5a30224c65506d8af
* git describe: v5.4.283-122-g310fd584bff3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
83-122-g310fd584bff3

## Test Regressions (compared to v5.4.282-135-g6561e7052c34)

## Metric Regressions (compared to v5.4.282-135-g6561e7052c34)

## Test Fixes (compared to v5.4.282-135-g6561e7052c34)

## Metric Fixes (compared to v5.4.282-135-g6561e7052c34)

## Test result summary
total: 101817, pass: 83941, fail: 1379, skip: 16415, xfail: 82

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 33 total, 31 passed, 2 failed
* i386: 21 total, 15 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 6 total, 6 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 29 total, 29 passed, 0 failed

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
