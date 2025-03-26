Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163C3A48
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743001366; cv=none; b=MuRibnf5mT3Xh3vOJkbTc6emdsozCr1JV8AwOroPtD2y105/CGbFRE8St2pxVuP9dB5C95+ce9xhxoIgL8bo8D10ucA83igYs7Lzd5d9032eTUXPvP9nN137ZR9wYi5spMEAx1iYs5B8FGsgAwDSauXmxUvTd1fke2C+CwHavXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743001366; c=relaxed/simple;
	bh=i5hMjU1U1CkBVthPy1e8u9OZ2c98Rx6n2+cQ6fD3/LY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rQbJ8N6XLA9UJ4HhOLM2DBT38Ixf9JlaGei2MGg1TN0M0EBJx02yBhdgPkEBCSS7T6ALZ26qj+b68zMGet0uxpmLim21ySIfujidoWdTUzyFoLtEnFBfz1VgP9YwAC7q8AkmZ0SNiy2puzAikeRjdCD4oo/4r5euNasCPlQ89KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=djSyFixd; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="djSyFixd"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3f6aa4b3a7fso1934739b6e.3
        for <patches@lists.linux.dev>; Wed, 26 Mar 2025 08:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743001364; x=1743606164; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VsQsH6ANdGylJ4qh5rKlnocfjpKm1sZHbMXP7G2f3lY=;
        b=djSyFixddKr05t6pm1y0EptdapN9cjVpRUguYnwylj/jB48u/o9tGkt0eyPp/SDwu4
         S/u8MIjdasfpsaO92sxhe0JChIwoUeCYIAo23web0qj5pjRXOPZQnD8Zj77UC1z8mO7A
         0onqN+LxB4dxxYs9BxH6jYANf0UAgiww1pf23cVgoLP86R/wRKNV0mG099xUJSRUWalB
         SlLkhtHL1/AP4uAbUehwaQZKzOKSMIzgnrvYNDssETGY8IOCDIFCzfRVLF6+8Q4zX6QL
         QmZwur9BtoU+nJ0GASVg0/M+z8imED37ry8iRPzqN4yxzfDnArknq9pOiz0gzpEEenoj
         JoLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743001364; x=1743606164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VsQsH6ANdGylJ4qh5rKlnocfjpKm1sZHbMXP7G2f3lY=;
        b=gjxW+Exmgk12Yt87uVDG4j+b0OtD9Q8LFtJ4vf+ImN4IwZbQL2VdhpaO4ThetaWgUA
         ln3r7D78XGabhTdX68pz1sv5XbFR6+u6OVRyUCskoYVezp6B1mL8JBYQQsiJecsTVqOk
         OxfYxXQRky8lrd1zsBVYo7OZYE3vhICed2ZqOFVJvBoeQZ9WLCLBitCH4WXoZ8Dmjxgm
         pfbfM1P+ApXSmMb0v6B5U8n5595Ua6yo5veBSTB8AryHeiKUr6nrIvBkmqPjdA9JU+yW
         Sku124Oci9JrgmumAgydobx/++6c9L65Tt/5TKIDE8oqN95eE1IwFkvNkd14z8uE5aM0
         6QmA==
X-Forwarded-Encrypted: i=1; AJvYcCUlVpYJY8AkpeOla/uqxCKjSkykW5CH8sn3zUE0kRelpoAAOmopvgiB7zy9cmIPhJQ1cLk3zBid@lists.linux.dev
X-Gm-Message-State: AOJu0YwWIlvcO4/jnVZprYTnNMdj+WsjcNmshdZjMv7uX+y6eGudYxqO
	M7r+jxxi9IxJXaPDd1FftFLOtonO5DlslFxAF2kOofZDbHPNDyZwHbV9vnMF18MP0fXMZr0GIP4
	aDEArWOISwLNdwNg/XiD34QupiTLBlUX2CZR9ww==
X-Gm-Gg: ASbGncuvpvU9XE9mNWy6sqbNs/JZgufHuxqlO6bsPh6O+cC2MuER+bOYC2VCuhmLExp
	B9wasN/TrCqw6dNmI166FPTBD6ZKiDGskC8tPU0/mhy99jyd6kJ8MMM553IT98kqpDN1YJUZeKI
	pu/P7fkyXPKoRUHlJkpCLjAjUuhI27NzSWxwGFfyBdgSoPaCEcM/AEGePfg0c=
X-Google-Smtp-Source: AGHT+IHdcefyjBpzy0SXc/gjf6ixzyEAvMSxlQARHmWO0KujbdT/yemJQiyccWHif1y+OoGvmwj/eDGDDvZ15smLS5c=
X-Received: by 2002:a05:6808:189a:b0:3f8:7c69:561b with SMTP id
 5614622812f47-3febf72652cmr12310211b6e.14.1743001363865; Wed, 26 Mar 2025
 08:02:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250325122149.058346343@linuxfoundation.org>
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 26 Mar 2025 20:32:31 +0530
X-Gm-Features: AQ5f1JrWdvxkbIUeJHzGZu_R-JluYE3DALzZRXxu_gTDRsdp-_SvEVbZdV9RPOA
Message-ID: <CA+G9fYvOjHPg14GCU4kLQF+PukgjsXUAY2sLCB=dwYMTa3iRmg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/119] 6.13.9-rc1 review
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

On Tue, 25 Mar 2025 at 18:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.9 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

## Build
* kernel: 6.13.9-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 3d21aad34dfa8c234590743dfbe06d6bdf633301
* git describe: v6.13.7-362-g3d21aad34dfa
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13=
.7-362-g3d21aad34dfa

## Test Regressions (compared to v6.13.7-242-g14de9a7d510f)

## Metric Regressions (compared to v6.13.7-242-g14de9a7d510f)

## Test Fixes (compared to v6.13.7-242-g14de9a7d510f)

## Metric Fixes (compared to v6.13.7-242-g14de9a7d510f)

## Test result summary
total: 130921, pass: 107776, fail: 3814, skip: 19331, xfail: 0

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 57 passed, 1 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 43 passed, 1 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 25 passed, 1 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 49 passed, 1 failed

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
