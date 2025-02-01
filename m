Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A956C1C1AB4
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 15:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738422910; cv=none; b=rFE3QZIlTzmz80B8H7TweAy6GfN8uPG0NtziXZt3pLElcsHsTjMLCB+AZqUcN9XyZsURRjWVguTdjkOuyRypBAXjkk6HbSNhVBkVApeC01wApgtwlCEFohadcOHWv0aG01A/wq9KVlpsOxvLck2x9NZm8Sk3fT1OJAy4O2XIyYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738422910; c=relaxed/simple;
	bh=grZzjOTp5UoxSAJdG19Iv5CHEy0RSryjcZZhcpUC39c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nh5LOSDgJ5rsmKtibGStOXEy5vbuaJO3Aa6LEn3UMn0n5mdzRrQyQA+6g/Q8qEApnPY3IcvXlwZc2uLIlrKWoFUc1+oLHq/EXu6cQ3SRoHbcv6JaSB+uDGGKRFrmWoulXPDN2VqmmuaxykmcvzzrldhOJkxwbZq1IOsKBCkzpiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HG4zGazT; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HG4zGazT"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-51640f7bbd3so954336e0c.2
        for <patches@lists.linux.dev>; Sat, 01 Feb 2025 07:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738422907; x=1739027707; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QqUogr6li+EQcK4KgEU6JhksjMQU+YKI3tRfrBxh9Ck=;
        b=HG4zGazTt7rVxn1JGcH6uG2ZkD3YwsEjJMiP+0T9FHDYTwPC9cQXiqw9WGEaoqKp/4
         NE4Fnjn6M+ZqBl5r75gnCAcr9/dleuHy5bBQNuVs1JhGaODqgEMv5Nc22XoJJ57iVJnl
         2VFEyDmn6PnO+w59WBfJrQ6qU0qMqMg7mhQ0zhuJ7o+EEHvdpZz3TEAD8nIGUlHBc8Uy
         3WzDfRtpoxK0BdpbGo4EF92LYn/RYetU2fyMihpiJTwOxHdNYms+dgffu0yZYP+bmlxb
         tOTzQ1OSvickveunvQPpGRnNvwFb8W/If9ON0avZytRCEocvol9MkIsX6Hf63Emfpuor
         fWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738422907; x=1739027707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QqUogr6li+EQcK4KgEU6JhksjMQU+YKI3tRfrBxh9Ck=;
        b=mOp2v01wm89Gvhj5Hmz1nyxACMhukeSefr50FG2dVu3IVresAbz+K6ACDWhp7Iwbsf
         R1ZK9ZmyptVCXtXJTPQdbQIRIyqO/HTLpHG7h0o7ge1t+N/l2s8ONRUvGxzt499CDG7e
         PbQuh5G6say5s7hGD4v/rxallNnWI/SuEyPQbLeRNNO7GUxz1S5wsoXF9b3PTRdLr7qV
         SKto0UYF9h120ca9TIllNN4n/CIqUqmCWAf8S7iMwdrSBBQy5hKzCwn8I4glUQSd45YZ
         FlmOUjHGP4jFYmFqmBtyG/Zhdv+aJFLSImzNVsT8YDKlyko3tOaszNYMFD0e4gaQUqEO
         Pk5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVnA6ZHBkmoORMnJvO4VCdebsNH2dD53+vc9j19IAZDOUin7JLWfOFUWo+dRc+LH/0oTPtS/qF1@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7LVYF1LpBNFmauL27+E9U458pDMN0aRQZuMe0BhaRA4Rhjdce
	vkaQd0E6vzkyyfwcS4tRXBNNgeZjeRYLbs87xBIfk1zPOfY3rIaz0FL3TXqfzi63xJYDoQIWkAM
	GtGAQtxU5KKn9Y8lELJsZusXbusf+wQv5UxTUWg==
X-Gm-Gg: ASbGncvhfZ3AlKOHaS5liZRk/sM7buJqpRWbC6MP0pDPAt9oXN0IspUea7jg0t+TXwk
	TIh9sxoJhmHe7X70M4tmiZTgpfWG2THFbiP6Pr1Iui/trZ6/AULODdEvA3knaTHYB8O5JTzcZc7
	s=
X-Google-Smtp-Source: AGHT+IEaV7VfecG2k91AzuNc19uCZEV/4HVYuQHZQcoKg7q1LxaxbqmhJg4rOW4rp8U1tUb5bA/SK4fZn79dgHO+50s=
X-Received: by 2002:a05:6102:3e15:b0:4af:ba51:a25f with SMTP id
 ada2fe7eead31-4b9a5233a2bmr12955902137.20.1738422907554; Sat, 01 Feb 2025
 07:15:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250131112129.273288063@linuxfoundation.org>
In-Reply-To: <20250131112129.273288063@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 1 Feb 2025 20:44:56 +0530
X-Gm-Features: AWEUYZn186bX7d-ejOshMMFJpRDXth8s7NIOuvjxj2MaiDp-6eYGDEBP2ddGFag
Message-ID: <CA+G9fYtW7_LA+ZZ4=bw0m7V-UiSyQaztCw0YY4X45Efcjq5f1g@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/136] 5.10.234-rc2 review
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

On Fri, 31 Jan 2025 at 16:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.234 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Feb 2025 11:21:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.234-rc2.gz
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

## Build
* kernel: 5.10.234-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 99689d3bdd980ed74fed764babc35d90522391ac
* git describe: v5.10.233-137-g99689d3bdd98
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.233-137-g99689d3bdd98

## Test Regressions (compared to v5.10.232-139-ge0db650ec963)

## Metric Regressions (compared to v5.10.232-139-ge0db650ec963)

## Test Fixes (compared to v5.10.232-139-ge0db650ec963)

## Metric Fixes (compared to v5.10.232-139-ge0db650ec963)

## Test result summary
total: 103553, pass: 67752, fail: 13776, skip: 21285, xfail: 740

## Build Summary
* arc: 12 total, 10 passed, 2 failed
* arm: 210 total, 210 passed, 0 failed
* arm64: 64 total, 64 passed, 0 failed
* i386: 50 total, 50 passed, 0 failed
* mips: 50 total, 44 passed, 6 failed
* parisc: 8 total, 0 passed, 8 failed
* powerpc: 48 total, 46 passed, 2 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 22 total, 20 passed, 2 failed
* sparc: 16 total, 14 passed, 2 failed
* x86_64: 58 total, 58 passed, 0 failed

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
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
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
