Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515813C463
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 07:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725607511; cv=none; b=dyFOw6nVywAOpqSv2GSSTAgElEU/XR84DdWqecDKklMtk/6SKYyj9qm4HNfNcntO+nwmbWwtLRtLcooY96ZI8rH5Vm0V2vNm4Zfij7zQzdaHrHJdtaXBg6p6cOXyXH/28KRd9gUFB/tztzdk89sAxzqzthKV35C3OFUS7WbtBWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725607511; c=relaxed/simple;
	bh=hHUTo+F86clv8hZFGy7Nfqc1RnwVYm+ghp9EyUqyEy0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MIewyBWlohM2DzHjUVKGvB0qHv36v860wO7g/F6Bh7LWl2d5Sbbl5RZcfMwrvGqEX6B3uu84y9jolnF4BpIDPEjIid+wN2jjHqfY+k4BGBIuh+NIusWRs0WkQ198nmWm7jJPe8uv2tQC0fICXPsG9HAVi3DEf1aHTdIrEePKnH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EkbGU8Ck; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EkbGU8Ck"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-846bcb525f7so462918241.3
        for <patches@lists.linux.dev>; Fri, 06 Sep 2024 00:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725607508; x=1726212308; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bD4jIp4EiNuoDLnWdNe8iCiwLr9Pmo5WVVfCTYbkDFU=;
        b=EkbGU8CkwP25yI52GJFAXXDcLUTZrXT8UuNFJpMZ0BMLSeTA52FnQnzeqP31qFy7/S
         VgrY/h35lwGsxefnztucGbiLYoF8oayv7pPil6b2ssoU/35cbMGnIbW3drcYZ2nRKdyt
         zfrcEN3Wt/3stn3r0m6x7TSMjjA5srZoFnSioPLeSvhrDwDoQFbQmRRMUpI5QdEdPQ2Y
         WkFAA3rbU5jqG14n41Ec1Ps59pSvgQw7Khmp8xOB1YjaXbWVa+PbPp++3L5TX9OwxP7l
         /zzSIS+1KlQEF3y6N5lqFWms8gEIc22OjPDZq9u43owk6t4IDnMmz2PJ3EgCv0BU/mYB
         WkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725607508; x=1726212308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bD4jIp4EiNuoDLnWdNe8iCiwLr9Pmo5WVVfCTYbkDFU=;
        b=bHqrEdWJ6AC097gV90/FhGUh5i54NaMipYgxsv68eXmCfaRO6+sVEjeW1JBfVhyFhC
         AcDitc8Q5/j7ZL0SeDU5E8kPef3sGhxHsEl8zPRV4SGKwkvB9djlRnS6v8mpZ6zyu6b5
         iBi+DKfnJRkbnN1QqXrLoxI30+yFcFCvdxnHDLk0vrO9Bv5O9/90SgAtI4aOQRAfehMd
         zgHnqdAyfLmdot1Six8GzwM5qk4bMMXrhSgIF+FYj4P6nRVcFxfB/PjYDRfQbLzh4/Da
         rSok/m3m9i+Cq2SRUevbpuYoseJ3EMJ4Iktn1GI5TshCebccXL7upmuSMdce14/o+5Dy
         YgwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfcXQHfHy5ebIZhrXTh2rNYguTJUrnebHOeQqmGDcd+VHoeVhsMqvRE+GO9ip4IFm2kM9MLabc@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+4cq/vUFmnGfSF/s7CwnEsdOAuhEwWV8qf+sjP0g2gE3lioUe
	g3ceJioJB1Da9SzUon6jr0OuZudICjxcZLRvu1eFWatJndjsQMB6l/s3KrKz//J5iCViAXdVBVi
	PCmflb4dH+2kqtaYPyO74w3jg5C3PQH5nyF2rhg==
X-Google-Smtp-Source: AGHT+IF4nW4PoHkQCEvOaOVGHqi5BQRRj2GwYte8sgX3gQwSDWxI9YXWWLzI/UyejNRPmqA+w8HxjUgtuAYIqnX0dUs=
X-Received: by 2002:a05:6122:3104:b0:4f5:1978:d226 with SMTP id
 71dfb90a1353d-50207ebf230mr1549004e0c.3.1725607508218; Fri, 06 Sep 2024
 00:25:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240905163542.314666063@linuxfoundation.org>
In-Reply-To: <20240905163542.314666063@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 6 Sep 2024 12:54:57 +0530
Message-ID: <CA+G9fYvciWJimpEX+0iRRtwC8qNKx7n3U65aqdNrMWRQLwtFNw@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/183] 6.10.9-rc2 review
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

On Thu, 5 Sept 2024 at 22:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.9 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 07 Sep 2024 16:35:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.10.9-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.10.9-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 1f09204bb539e1a60467c14bcc447a5f4575fe65
* git describe: v6.10.8-184-g1f09204bb539
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.10.y/build/v6.10=
.8-184-g1f09204bb539

## Test Regressions (compared to v6.10.7-150-g88062a11f41d)

## Metric Regressions (compared to v6.10.7-150-g88062a11f41d)

## Test Fixes (compared to v6.10.7-150-g88062a11f41d)

## Test result summary
total: 233159, pass: 204972, fail: 1882, skip: 25816, xfail: 489

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 131 total, 129 passed, 2 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 6 passed, 1 failed
* x86_64: 35 total, 35 passed, 0 failed

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
* ltp-ip[
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
