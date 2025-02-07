Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9172191F91
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 17:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738949803; cv=none; b=deSxCZcqmpVKvN5NLgMAJ4m6IhvvP+vBhExqW6ktTtXC4wDDmNrraOOsnk0sXYNsxLsvvGm5UZa4xyLqwWyCDc7XnuVmjKz4NOTN15M/emgd6gVtER6kCq1CJvg3un9M9p51FNgrBVbUWn+A4jjRjrthz0RL6tDpfZyH6ByjMmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738949803; c=relaxed/simple;
	bh=21qDGjiVABfPAamSl8+lYhl0Ac18V5VkNPgXfqK6F1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cYwhHl4URIkNrP0NT+TodOm+hqPCi5koPKmEsqMX0nSKDjcxaDF6ug2XQTG1RmPzQDYXHmrZ+lEhE05CpAWt4S1XKr4iKTVbQEz62DQ8Wsz9UKMCxPZqqE1DpWgNFjv+m3BHk5GDsOIBO6Vv91NiPL2HUEgQCz+0NNulCoMejRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e7ZhTBLz; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e7ZhTBLz"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5187cd9b8e5so611348e0c.1
        for <patches@lists.linux.dev>; Fri, 07 Feb 2025 09:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738949800; x=1739554600; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IoM7ay1yUEu27qZg6xqFFLuuGJrp63sCtx87CRTaTyc=;
        b=e7ZhTBLzR3u9VDbCE+Mk65Ks8Uo7n6M28XW5NOxEVAGTtJ9GwkxD4pidkA9+bnsb2y
         gnn++LOIG5Ky488U6oWFwJj3bbyTwgYnCYtYE0iUgi3EG+Q3xihjzV8nekEo5lmtTnVs
         M5i9aNCQ/HAcwuHtbZ7lTtWAnnS7rqvmqMe3lXTxsEN5ixbep4OsffSImgJh5aiemDES
         5Sv1ecmOkY3+V7U+xERnIYO79105uOQa62P9/JVjQPCbV8h/TLdVWOmGyDbju+VjcqTw
         A6GJnJv4KmJxLP87xallU4uklpzv5KUuXuTfq1hQwgRgT6X9EIHpUrrTSxqJNMo+7aLC
         n7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738949800; x=1739554600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IoM7ay1yUEu27qZg6xqFFLuuGJrp63sCtx87CRTaTyc=;
        b=d1irfDCj9TnYM/UHTUC4xNXWTftzVnrH145noYFD28u3L/ttiDUHAMsRETE67n3TjM
         zmVoaZKWU0OP/Ow1xUj0lRMcKdGmbzw6kQdt4ajBOyZPwS3XzWTxIBuQnVBOg35uGdOU
         xgqFV3pRgIgMO0KIFMtuZNdHdRZ7fZHTiEFUkui9rbRgnkAaVmjv0/a207EDhHb6incN
         6Nvq3u9+K93xOUGnUGLqjBO7trEKA9HBjsMvNDdGRI1uipq0O0Uq8c0xCbQXrq9+rdpa
         AUKy8JeZPG+AVHO8zaT9WHT058urILZiW6TTO7C3SKyft+1vue7lxvXGNnOPxaiiDeoI
         BP6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXs9SrBqG0b0BnIZeqJ+LmN/34eVwQPk4t8LS9eFZyCwIjDowKa7N9JSsr2uttBfanvwg1sDPnv@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+RujpCnmejdpeQVGGnV/Uy2MRvnEagTMGCUiwc2kwQIs7AI2h
	Kf4aL8duqUXkMBtjq+bdTL7gTQSYgbIF0184owerj7vxzcnKC4uPqKLEBLgjtqEGMB5UZ5un75i
	nSWx+pwjp5JRJ+ZqidNT4cyVgO374UzG3rTea0w==
X-Gm-Gg: ASbGncvM77pkmRpzqOwAPAGg1E2clyde9F40DwxdjAbGpticqsZTo30FPP4RQMRQsj4
	hF3qOxRMo3Zhlc8FCIhZc7lD47ceVRo1XX/uFsW324fjhGZKN4w0cs3KPpWNAA6qMUsTaId+Ylt
	VPA1prfbGmr58VSjbgOM4GAQSgaJ2D
X-Google-Smtp-Source: AGHT+IHD48I2AMSpA5+mvtWHG2ePtTqKNvefiIOSowMRXyVSROEuTDkAlvM1BbSf+cJUy+TNOcgESamf0qrSTV/WsvA=
X-Received: by 2002:a05:6122:4986:b0:51f:306f:f35a with SMTP id
 71dfb90a1353d-51f306ff9camr2275253e0c.5.1738949800534; Fri, 07 Feb 2025
 09:36:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250206160711.563887287@linuxfoundation.org>
In-Reply-To: <20250206160711.563887287@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 7 Feb 2025 23:06:27 +0530
X-Gm-Features: AWEUYZnVhjZv4-Pyf-2ceZaRTfyWavFrA0p3FZEzdjxW3fcO1g2Uupo5JGJYVpU
Message-ID: <CA+G9fYvs9GUK25mx-v+Fh-E55v2F=he8v=pSbPa_r4Zw51CNuQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/583] 6.12.13-rc2 review
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

On Thu, 6 Feb 2025 at 21:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Feb 2025 16:05:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.13-rc2.gz
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
* kernel: 6.12.13-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: c4de2ac60676d8cbaedb6e7a4b422c65b911f12e
* git describe: v6.12.11-627-gc4de2ac60676
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.11-627-gc4de2ac60676

## Test Regressions (compared to v6.12.11-42-g4d14e2486de5)

## Metric Regressions (compared to v6.12.11-42-g4d14e2486de5)

## Test Fixes (compared to v6.12.11-42-g4d14e2486de5)

## Metric Fixes (compared to v6.12.11-42-g4d14e2486de5)

## Test result summary
total: 1335, pass: 981, fail: 267, skip: 87, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 113 total, 113 passed, 0 failed
* arm64: 9 total, 8 passed, 1 failed
* i386: 14 total, 14 passed, 0 failed
* mips: 32 total, 32 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 33 total, 33 passed, 0 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 20 total, 16 passed, 4 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 3 total, 3 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* boot
* kselftest-rust
* libgpiod
* log-parser-build-clang
* log-parser-build-gcc
* ltp-capability
* ltp-commands
* ltp-containers
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
* ltp-sched
* ltp-smoke
* ltp-tracing
* perf

--
Linaro LKFT
https://lkft.linaro.org
