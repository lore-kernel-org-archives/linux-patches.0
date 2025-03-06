Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203281624C7
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 12:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741263732; cv=none; b=dDJTYmlfqqLQzb7HJxFiFX7JcwAw2drZKq+A884cPStv3I7jaylpGs6PaTnxbrel2djKfeOX8Dso0KFI2cfNYgyNrV0zZ0mdJb7mK5zrXxD0EogPJhk6BZDylV25i7mYoI8WlGn6DnHlXqEboZExGaOfLtZhQxD2zE/pt7xijk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741263732; c=relaxed/simple;
	bh=8WpiNtP4SUsV2btOYYsU6TNjuaweKXpboF/a4bcaaGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B82AW5o8XgHMufjl17SJsXizfDIcmwDSD4lphI0HX30GSA/nflVKX0ftBKE8WdcAPFYej8NZnLXXtGEHUf/NwMZGjzF8VlIoWnl/VqEK08TUM4c6r1LeW2eh63Lkw+LCcjPdmxX8Ad5HSsqJXN9Xrr0DM09/BkYkzFM1nDwf7Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xhuWz//7; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xhuWz//7"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-523cbce071bso243584e0c.0
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 04:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741263729; x=1741868529; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NMaFzP48YFinEhiZrVchmGEvLHB/ao+cnP7Dht42RRM=;
        b=xhuWz//7wU9ShoTlEhfyyNoKsLm2Gr4gdI9C2d9wfios0E+0nqumC3NWy4c29C+SXO
         XpFJX4diFThJuFjXx/89qBX8LJn5lLjp8NJQzUthjabQiAjbWgWMA1z8+BEVDCbEtTTQ
         DiI2HlodnkfgHPGhulmLhacT+TBzeJvbD4RhjnzbSMiWN623KMc1uDmIEl6+rEalyj3J
         hmCw65ZETkOIQg1iKAA+LYiBeu9GnbwWp3PvpZFGbMVIkvVSa1pkabSrjfiXpYr8VJ44
         tueKQ31uTpkuH5t3I2oWWJhMToGGqnK64NpLc3uZyN4gBCmueFu20rtqiTERjk7+jHyP
         LAEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741263729; x=1741868529;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NMaFzP48YFinEhiZrVchmGEvLHB/ao+cnP7Dht42RRM=;
        b=bRPFnP7t/o4u5j0XTsvjI+3kO3zg0ffMw3t0a6VK7+POj1GTB30+2UansON8mx05Uo
         4+Y4tVEF6YMhzxr1QR1bmRbWXAHaOtYV9T/T2E/wXeh4x4T2C/Arb3grZCvf3WfkqWM4
         MPkyDOHoZRoandnvNpyYChlvIuMRYT09E67FnwmYDvoH43+wg0MR3JCKp9R9gGG80dao
         f1uDXz3l2b7D8D/DnQRQLyUa+BCu0YhdkCjSsT8g8vm+n+gD8B7J3lLcNM6qIWqJT/6S
         Zb1WxdmARbqufa93qUskoKEQX7ltKRO9AJC4xbUDakA2RiITBH5incQ/Vu8f/AmxX0dX
         MqsA==
X-Forwarded-Encrypted: i=1; AJvYcCXbhkmVT0sgiV58bb+cYYa7X+QE6BLPoXKKxi330itzj5qacMD5eGJNNZYjEdervftp7eU2gSeb@lists.linux.dev
X-Gm-Message-State: AOJu0YxrqG4WifNC+VwnK9zb6gSUN1rG0gsa+cj9S9hBcBs1PxsNQadN
	l0JcgAWEU2Qt9Xd2pyv9lPUfmMVt3LVWz6eOS2L6w4hFQnVCadX1NnJ6rRrFaVHtLD+Xt/Y7d3f
	lpewHaSGNk/EeB+Rk44fYZtb5HTIa5dWHNpFmUQ==
X-Gm-Gg: ASbGnctp+4W9kLYE6FBPw+9HrcfTbyfz6wxPkkgKx8flFm+mLdaMZmYf6DTc2MsegQ8
	vVA/AMZW02/YHwwqmhyivL6hAG9SuxRURuUOT4W6Rdy1KOMcJW8FkyaY0gU1WqT/3gZ4du1YRNa
	CRQxnWW4APstvia9PQaZvcUzSZT0rxpnaHhyUh/BtrYpkM5UAt3c9Fjlp/5w==
X-Google-Smtp-Source: AGHT+IFYww1kZHMpxt5rfe7etSrcj4Kd67QgSomHrhxf7n7GkfeEsvd0m/xOfmDxwX0pwVAOrU/zMPkV6Cfa8MEglrY=
X-Received: by 2002:a05:6122:d21:b0:520:5185:1c31 with SMTP id
 71dfb90a1353d-523c6281025mr4217547e0c.9.1741263728875; Thu, 06 Mar 2025
 04:22:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250305174505.268725418@linuxfoundation.org>
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 6 Mar 2025 17:51:55 +0530
X-Gm-Features: AQ5f1JoHOMnMdoj85LLhhqMa2z8QuDprDq4v5xGuh6PRQjSvUsaQu0qsUl8-2Ow
Message-ID: <CA+G9fYv9CcsWEywck9qivOVtThrmr9UUiu-RdPnrjVs9k5JxTA@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/157] 6.13.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Ryan Roberts <ryan.roberts@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Mar 2025 at 23:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm64 the defconfig builds failed with clang-20 and gcc-13
the stable-rc d 6.13.6-rc1 and 6.12.18-rc1.

First seen on the 6.13.6-rc1
 Good: v6.13.3
 Bad: 6.13.6-rc1

* arm64, build
  - clang-20-defconfig
  - clang-nightly-defconfig
  - gcc-13-defconfig
  - gcc-8-defconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

This commit is causing build regressions,
  arm64: hugetlb: Fix huge_ptep_get_and_clear() for non-present ptes
  commit 49c87f7677746f3c5bd16c81b23700bb6b88bfd4 upstream.

Build regression: arm64 hugetlbpage.c undeclared identifier 'sz'
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
arch/arm64/mm/hugetlbpage.c:397:28: error: use of undeclared identifier 'sz'
  397 |         ncontig = num_contig_ptes(sz, &pgsize);
      |                                   ^
1 error generated.

## Source
* Kernel version: 6.13.6-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: 30be4aa8b95762886fc27cf2a9931e14bce269d4
* Git describe: v6.13.3-555-g30be4aa8b957
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13.3-555-g30be4aa8b957

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13.3-555-g30be4aa8b957/testrun/27516541/suite/build/test/clang-20-defconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13.3-555-g30be4aa8b957/testrun/27516541/suite/build/test/clang-20-defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13.3-555-g30be4aa8b957/testrun/27516541/suite/build/test/clang-20-defconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2tuRCFN4wc8W1MqNki1qddcwCF3/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2tuRCFN4wc8W1MqNki1qddcwCF3/config

## Steps to reproduce
 - tuxmake --runtime podman --target-arch arm64 --toolchain clang-20
--kconfig defconfig LLVM=1 LLVM_IAS=1

--
Linaro LKFT
https://lkft.linaro.org
