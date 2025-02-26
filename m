Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AA71E1E11
	for <patches@lists.linux.dev>; Wed, 26 Feb 2025 09:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740561431; cv=none; b=LaCAkdiByTG0fXEHrjqOrcZXTQ01AQEA78fpdMCJK9sUaOIi7ywqqfgtSHdq5VMbG/cwaMPLf2EhfkpWddSOQoe51kdv43hQ3XWBSP6uWeu2C3mgG/wQKFgSUvBy+MFE2lqdtttqI/kLe2nlZTTebNSXRg8mZwUnBTrc+vDa0Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740561431; c=relaxed/simple;
	bh=Hf+VCZQAkJT2meu1sdVN2NPdeG/wTQeLa2BFN9U1kK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aekZP5CzI9/JeukyxxDkpVLQrACd+sWAKwFkmIxZ6mGGm06Lxeb2XMTmoLVsq0ljcnvlXFh0IGGYVKgAx2eI5O3RuIbNpOUf86r22YSKs6jPvzcbEtODZY2Dtokwc5nd49cVtPkZsCI+LMHT1DFkkPv1lqXsFlKjs1My8+UhDPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jCdRMJ9H; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jCdRMJ9H"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-51eb1818d4fso4634311e0c.1
        for <patches@lists.linux.dev>; Wed, 26 Feb 2025 01:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740561429; x=1741166229; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nkYsziU56oM3MwTS4qzMUVuZRmIpV9WQpyZSvh+BG5E=;
        b=jCdRMJ9HNEnCe9G+7si5EjowhnwCH7QMS2iZG+5DFBWsE5aP1Qbzd5frh+ldxe8rw8
         x21mOmP8rQZ/jRuDMLP5SnLONosThUaVrTvqKV4HkZfDiS6S3R6xfvl6zqZfjl9+w/VT
         EqKzgtOSTGnBZdtTd0//SfkEcPgUvAyDUOe6FlNgUyqL5+Gnr6UPsNfDryVW0iZ4cH1b
         YyYa5ppCNOBlgEoRyJ1b/CJ/fMZE0zWkcMWA9apl++KUWTLS5v6I0VLFaRo25WdUS40A
         UoW/Qnfg11LLmWW+dhcgwVDBCRD2o665g5Leo9xdatmeqhxgcAdCWQQcuueJWuXZCNiT
         Vxlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740561429; x=1741166229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nkYsziU56oM3MwTS4qzMUVuZRmIpV9WQpyZSvh+BG5E=;
        b=aX1aXectrEyLLQyw3SEA7ilGxn6zgBYooI7BAG86zJAM1uL2L2KiHtaxFeJJC/DneO
         LXICLRblI9JpOe+VoTTiAJ3BLWXnJf8lp7aKyghqlkPa2npiqdpw169qniVUc1w0IXe4
         VQ+XorWbKhNs3/+x0x3VR0gQG8t4GVVLJ+BpmAKzaMwUserBfDcOQsRR6I3YTY5M70sE
         u+9mdop5t4AgCWu7QVjkqOwqxz8PVytW3LIyCP7G5R8rlN6PJx55Twc+ybC32G2+Vjw3
         c4Hhdg88NX7ftFXDNTkT9yM+ftGVFJ+XHnAC81p0JGd5OjGkaK74C7bBan/daYrWxDu6
         UrMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEs8SfWbx4RqkoYMUSc28UZBFjzda1qQz9kK2TdoT0BiH0gf1Ydmm0cHWu6oAOj3+pyMSPOtLy@lists.linux.dev
X-Gm-Message-State: AOJu0YxJj1csMCRnQmw1IBMf46gy1IRg/kfIvgPpMsaKDp6REzH7pPCb
	tPfQMaVY2B3dkTLFE1uiRD71e6UCqCAJgc/kJKeADRiGkbNhBvDmGpCZDT8YJn5B1P99EIud1dY
	8Zui9ekO2i+sgUpC8yr3V0y2GDrUvJqceur0hUg==
X-Gm-Gg: ASbGncuxeFEPS8RfS+1Mm+3OSzaonniTt+2JB6GwpgIM1+zLEnK8XyiyoPkSLL7tVHW
	6XaB7ZH6RHdkoLMiQpFQUHyND+Sol0aBLWKhE8mnWgE2xIiavxmLXNoccS85uwxMISAgfR3+tRi
	p8S4Dk1aidAHMs54WghsNJSA3uRU3TgKoufyPKkd66
X-Google-Smtp-Source: AGHT+IHhFiHsjlOh4HmrLEErJxo2Wlkw5Rir9/OPzCHMjsHipZPzDGQHYAiqeuDUwOBfy9pdIdakUoNmvIbZJ2T+Imk=
X-Received: by 2002:a05:6122:201d:b0:520:4996:7cf2 with SMTP id
 71dfb90a1353d-5224cd6264dmr1654324e0c.10.1740561428792; Wed, 26 Feb 2025
 01:17:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250225064751.133174920@linuxfoundation.org>
In-Reply-To: <20250225064751.133174920@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 26 Feb 2025 14:46:57 +0530
X-Gm-Features: AQ5f1JqZEZmcBTxhk-z2C8v138XsDQ7jKMGbCVbb5921NpSF-DW8iSkGlypOB5E
Message-ID: <CA+G9fYt8kOe_wkQe_iVAwc5qPKUiZWb1=COO88Dj3c8oVWkNMw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/153] 6.12.17-rc2 review
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

On Tue, 25 Feb 2025 at 12:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.17 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Feb 2025 06:47:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.17-rc2.gz
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
* kernel: 6.12.17-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: f5c37852dffd24f66248b4086ea594060f3299a4
* git describe: v6.12.15-380-gf5c37852dffd
* test details:
https://staging.qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/bui=
ld/v6.12.15-380-gf5c37852dffd/

## Test Regressions (compared to v6.12.15)

## Metric Regressions (compared to v6.12.15)

## Test Fixes (compared to v6.12.15)

## Metric Fixes (compared to v6.12.15)

## Test result summary
total: 125310, pass: 102630, fail: 4192, skip: 18488, xfail: 33

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 137 total, 137 passed, 0 failed
* arm64: 49 total, 49 passed, 0 failed
* i386: 17 total, 17 passed, 0 failed
* mips: 32 total, 32 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 38 total, 38 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 24 total, 20 passed, 4 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 3 total, 3 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-kvm
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
* ltp-crypto
* ltp-cve
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
