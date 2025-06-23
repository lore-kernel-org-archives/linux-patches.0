Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8501F3B96
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 21:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712759; cv=none; b=pFBqeGznkiOzLQuDH+eXW9b9Y+uv1TmlLaU1nBcwylyXp+fGors+yJwaU81GZ5rh2Ci5rKHAmd8tKuTKmhVhjtagVyKDUhByzmu9TpnSSDkjcbUnOGv5RUawEFl9S8DVigKvMAWbvPr1B777eRAmlvrkp0qiY+kyiD1dzJlYeeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712759; c=relaxed/simple;
	bh=QJJddcvfb4kRHAKMSa/fFV0iFteug7n2v+ZY6h+PamU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=INOen7rOYUJrJnn8elFjy9zRD5GBH1rhMNERWAdxVZsO/2o90JwLiKacN/FVAqcfa9Ebw05JZfto3o5gb0j6sp0K+27+v7PVoBvvpjTbHkIwgHqE2dG0OHYXTNDqdDn6Dy32bx21dptLfI8UUPQJ5yKF8nehSQ4JrVSw61HjZFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=P0GK7XBA; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P0GK7XBA"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-313b6625cf1so3292979a91.0
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 14:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750712757; x=1751317557; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pHX9CXX2jp+sc88nWffGW5R0z0vn6Lx1vW0giPA6MfM=;
        b=P0GK7XBABI8sWF5WY8obC7w0r2hJCb+yIiZsw/CnENxG7vNPooJ5NDa/JH1RtG66CS
         SF0F0UpuBF63rfz7bY0iHU2upvzoK/pCEeQkMmwY6ms/vMf74OT83dInLnlz9m6NyQoi
         /uayarypfU89FQbZwUYz0Mgp21DpYCFOlZW/2O+mK/jFh3F+86blhFpp4SUBvLVBSi8h
         9JJnGwTFWSRVu2SYWe5UaV+fj4cnooQxgXVcHD/oLzNTKTA97pvNbz08nfA/Rs20hx6R
         wnt/tSlEbJU3oCfaofw/Xp9RKxCx4vTgN2ic+GUNB3PUhFS6Shu2T0MafQCP27k/yaXy
         TT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750712757; x=1751317557;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pHX9CXX2jp+sc88nWffGW5R0z0vn6Lx1vW0giPA6MfM=;
        b=LLexT9KhnDnYn/Zj1VrZR8dpd2hNlUX1D6Mxb6/bE7/rHAap3KPR4MXSqrnpkHnTMe
         R3A/A0pjNkpM2auAX42PcjXCXNiAxAbIBXQ007linUxq3zwzpDa1cGZnRVPTrA2zarhM
         x+t9GxbesizuZxScmSD1Ub9QaPBu+F3xkyMV7tqpxosQ7B3JyNW8u9xV50jOvLRXdRYp
         LnoJbFHE5Ga2yWoVK3elaULQiGoZ8WD/t+l+MELyqy3I8dgJDRCHy8ZRxflnJjHXEvQC
         tcLiX6kSMmb/4PwKO/Ag4XA1/8kLsbJGSokf+cs47Dep1DtvdRJJMMyf3OrW8WHEwj5X
         BXfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoPkS7+KL7V2zyI4uVKUrcHQlmhFUOk4oUIumkZFou94Q+HvekwTbQ33trBLSLDdozmb7SLrGp@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6jPwWfegW+8nUBTVYt73MSyjGWA1eVSldHwVSZvlxJ0C2gulM
	p7zH/dgx/nqsjEO3rALHZPqjT+8KB71W0CVPWeaQhxbGqaBepaMkZ7H7ANArykKdLTAQ2IbO3ME
	Hcx0wtOxZwPoJjiol7wCELID9vLGlENDS1f/GMoW39w==
X-Gm-Gg: ASbGnct3PZCp8THt4wRkhG7fOrY0MBg7oAibxAl4MtyOdM5alGBR1uf2GRlaJvUXh23
	212LgBBTjFocTfAsPz2OEfsqC8Admli5MjwZokp6dJljjr5lhz7rzD4jESMToN9Bhp7bozKFlgK
	GscKFqrsGEQzEX4k2RuuomewXzFrU7JYV5AvQ4BbAoZsj7ln0vftnEwy6Gd5KGvRjrH7BPEmvPF
	lms
X-Google-Smtp-Source: AGHT+IGluWyWYchA0SWpbfOmsSY/NlAvWI3AwaiTmC73117pQczqsC1IpuBOq5vhAW9oC3+ZWrshJwcLG3IOLcWQkbE=
X-Received: by 2002:a17:90b:5586:b0:312:e73e:cded with SMTP id
 98e67ed59e1d1-315ccd7261emr1387255a91.16.1750712757357; Mon, 23 Jun 2025
 14:05:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250617152451.485330293@linuxfoundation.org>
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 24 Jun 2025 02:35:45 +0530
X-Gm-Features: Ac12FXwPGqqVTvOIk9rFpxKVJdoOnBMvXrD0aOMgF5kEpGyYgKGtnJCwPlmxBRU
Message-ID: <CA+G9fYtUjjrzghRQVUJ5ct9zNK2ROcRVOizpT-ZyjzZGRSUz1Q@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Jun 2025 at 20:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.3 release.
> There are 780 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on s390 allmodconfig builds with gcc-13 and clang-20 failed on
the Linux stable-rc 6.15.4-rc1.

Regressions found on s390
* s390, build
  - clang-20-allmodconfig
  - gcc-13-allmodconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: stable-rc 6.15.4-rc1 s390 allmodconfig
sdhci-esdhc-imx.c 'sdhc_esdhc_tuning_restore' defined but not used

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build errors
drivers/mmc/host/sdhci-esdhc-imx.c:1608:13: error:
'sdhc_esdhc_tuning_restore' defined but not used
[-Werror=unused-function]
 1608 | static void sdhc_esdhc_tuning_restore(struct sdhci_host *host)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~
drivers/mmc/host/sdhci-esdhc-imx.c:1586:13: error:
'sdhc_esdhc_tuning_save' defined but not used
[-Werror=unused-function]
 1586 | static void sdhc_esdhc_tuning_save(struct sdhci_host *host)
      |             ^~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

## Source
* Kernel version: 6.15.4-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: de19bfa00d6f93fdcd38a5c088466e093af981f2
* Git describe: v6.15.3-593-gde19bfa00d6f
* Project details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.15.y/v6.15.3-593-gde19bfa00d6f/
* Architectures: s390
* Toolchains: gcc-13, clang-20
* Kconfigs: allmodconfig

## Build s390
* Build log: https://qa-reports.linaro.org/api/testruns/28840725/log_file/
* Build details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.15.y/v6.15.3-593-gde19bfa00d6f/build/gcc-13-allmodconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYQdocMC494e6F9GTIAK16EAg/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYQdocMC494e6F9GTIAK16EAg/config

## Steps to reproduce
  - tuxmake --runtime podman --target-arch s390 --toolchain gcc-13
--kconfig allmodconfig

--
Linaro LKFT
https://lkft.linaro.org
