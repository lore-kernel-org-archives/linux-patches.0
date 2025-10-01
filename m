Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB05285CAB
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 10:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759313721; cv=none; b=oypfKZry3ZbMleFf7ed7Dqg6obmqU70RjOKszMYCsWiF2yVB+yYsUf++mFdKRzXL27qB5+dHj4siR8m+9y/5Mi8rEjj+oII96Q2TaEkFZ++DDyZsZA7IvQIK2bs3Ocoux6Z9WYzufYYLfyqFstvNe8y75a5DB7MmKMfjaBmGEnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759313721; c=relaxed/simple;
	bh=sgsnwpn+D8fIoDMYNzRMuhajAlNSiIkq1gS543cZsOI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DhFSqtBs9295N2GXtjs5HIBFocz9O6IpgOPDQ5GGZBETITMC9eWo+sMttUKFfzVEgJbktkUGg/tqYRxDxhxW62yxcxMmJI8Y+TBz6JujihsmPDbebF0nZ41GxytW36u5KS/P7/s2C+lCpycIcRpOP860oBISKQ3XylICxcmmQXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JuAQfRLk; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JuAQfRLk"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b5507d3ccd8so5961497a12.0
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 03:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759313719; x=1759918519; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVlD7cbNAbeKP408bV/3WzoZZwwNa15/KSPYB9rp1ZQ=;
        b=JuAQfRLkLhHYVielHRIaLQEXRkivOozOd3F/HoDoLqaMgsUyGcvRZnVcY+LTsHAqIh
         7lqHTwkeyTfCca5DHkFhAOM6KwGSRXCQcLyEHujRhP5BVV2vzYM+KjECNDlwYpd7+331
         7aPgpkYUbtBh47bJPa92pd9OR4hXaVRvMLBWf3W88IGb/RdtnFn3YCarvUBr1BbHq4f3
         n6IyWkWfU9YcYQt8+Y5faBIqUdlKCcurcbCJRkTLnAGgdT5wmZQzoTza0x7XaYHNtnEI
         vSFyW/qt3BBay7wdYKfrfK78dvstJLx686nfDfjhHzuoAoAbO4/B3kPWzdNi2d8AYjMd
         DiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759313719; x=1759918519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TVlD7cbNAbeKP408bV/3WzoZZwwNa15/KSPYB9rp1ZQ=;
        b=XZpSxnLjofg1nq2U1lINhyebQT3gcw9Lph/IbTSkZPRYLKUL1GOFllEX/2+zHEZWbT
         uXF79e7oC51kPtX6Hb6x8G2KRMu5xcaJ5EtKQenwez7rGoQr0D3SakdW0VIQEHBTD7Eo
         7S7lRRP5GKIlg39YSMToGwmzw/WFzVYGT0mkJCNPIVNmAmVxprriPbEXBIBpacZddfA/
         FI5eRhV6UPejn1TUnYkvarVRrvdgoSfbZIcZT8uZSLeR16mD6QDkNIH4FlDPkjALXQ0D
         XQG368TxmUJTR3P6EV63BwnVMyBY+GBsP88uQ86YtPtIWQAjdbRvHvola2Gdv6gjyLLB
         Q+vg==
X-Forwarded-Encrypted: i=1; AJvYcCWnF/n6xTZhIK5/oc/xqNHfi9oXf5BdO8tY3cywIaWOKZuRdfq+HZuBuVTgcq13xlnx+3Hmhosd@lists.linux.dev
X-Gm-Message-State: AOJu0YwKnsupRhb80eQjMdFYqlqoOQ+BGWNjCrlcyuLsKf2GhD5zv9lh
	+oEWUnUhCADpzDoL9GYGEk648oi/r9kxN+aSSentUy1qB3nzefsPVi+a4WK9XL6itn/4L26/29u
	biG7p0BzWs0hqdTY4DaUf1yq/XTsNhpkmWmhYuHp+Hg==
X-Gm-Gg: ASbGncshR2kxVEFyBL7TK8oUM2dkcxx2q+DYSc6lUhIZJm08OSStpsoACFQBY98T7z6
	r6j2jCydsVWJdLad2Z7R9gXUdvVhKSTcyyJg9mngrys/0y0ezmgxQSeQY1RpwyG6OkT+xAYpylI
	pKgvyAJUK9iIfjupGd07qDUmAO7O5o2yr4gqoo7syySvg/XzepkHHy4j+XAgBfl4Fv18g4QItJT
	BnHColZf5K5tKRt/plzDVTTPbbTMqwhBn0swf63CSqusbw/3dRPypWfrYKfTbe9mRZz6srlWWO1
	jSrGqDTMwx6qEdnQoE1D
X-Google-Smtp-Source: AGHT+IHaka1yetBuMgYwu5Pa2p5NOCL2qvRKz87P7uR2CFad84AS5RAu/HfztqmZ4Cvd3NgFL2DNLwmbV8O/6aP2JRA=
X-Received: by 2002:a17:902:e74c:b0:269:b6c8:4a4b with SMTP id
 d9443c01a7336-28e7f2a11f7mr39919595ad.6.1759313719090; Wed, 01 Oct 2025
 03:15:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250930143821.852512002@linuxfoundation.org>
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 Oct 2025 15:45:07 +0530
X-Gm-Features: AS18NWB3zSzph--UG6gBX3s5sPRY069g9F1bXa9Mqzp5Bw4AgJ2DL3Pxh7JT56w
Message-ID: <CA+G9fYv1jfBiG-bqDsbbAWY8gUhoajhw_LpWu1hJfHDSiCbYZQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/89] 6.12.50-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Sept 2025 at 20:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.50 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.50-rc1.gz
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
* kernel: 6.12.50-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 8e6ad214c7b34b9022784193fdc71e1561cdf11b
* git describe: v6.12.49-90-g8e6ad214c7b3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.49-90-g8e6ad214c7b3

## Test Regressions (compared to v6.12.48-106-g1fcc11b6cbfd)

## Metric Regressions (compared to v6.12.48-106-g1fcc11b6cbfd)

## Test Fixes (compared to v6.12.48-106-g1fcc11b6cbfd)

## Metric Fixes (compared to v6.12.48-106-g1fcc11b6cbfd)

## Test result summary
total: 325661, pass: 300251, fail: 7071, skip: 17840, xfail: 499

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 144 total, 142 passed, 2 failed
* arm64: 63 total, 62 passed, 1 failed
* i386: 21 total, 21 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 54 total, 51 passed, 3 failed

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
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
* kselftest-mm
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
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* modules
* rcutorture
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
