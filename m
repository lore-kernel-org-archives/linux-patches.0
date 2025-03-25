Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9986257420
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 15:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742916173; cv=none; b=sLc0KMlWGarwOsdy99MkgPuDwZUryz6hEqwVCR8N9+tFEeAYXqaQs/PCopoNDwJz/aKGtOV/PO5rOMnn56PfWnyQm1cfIz67kRueIH4lwrx+fchkNX2XGFdlKVSj+Od51r4Xa2RzXAQbg7Ml1jxC0kUqRxmCJKoWSUhxx3t+ekY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742916173; c=relaxed/simple;
	bh=vs+t2NdfqiK4z8GbA1CIrnlz9zIFlKWM1eLzsT7vTkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dciKh9gtlSBDpdn36iSvWDErpQ3AgmvWEC+ewgdq2riGCZN9gC/tk6x4uTKCSxWwfFV66gS6fnD213SIXMxAJxr09Tx1IZvELqJkiVhCF/ZjJUZqDJBJ0Te/daVeqveTwGc/8xZ4WQ7tpIrKKuFttKueGHwob0VSMW9jxWMIqy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GTFamy+b; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GTFamy+b"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-523fa0df55dso6302995e0c.1
        for <patches@lists.linux.dev>; Tue, 25 Mar 2025 08:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742916171; x=1743520971; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FR1psq8rYb0jVgAPAumoNgxnKTwTi/S55HLEy0wx1vw=;
        b=GTFamy+b/vKelsGRQZOZQc2Ekfsa70tJ5BS/dOTmFolkfC1fbr4hg+oBUmVPee5jwE
         kurXG6AfwGk3HbWJYmaQ/sGT5AV8W4Va73u74g57MsD+jdzZF+kJLmxhInBP6QglWfiR
         OZXs3stLt2Szj9Mjfw76hxCCyuQyzVYSze/y8HpElnyrMBTOgdcPCUc6dnQF9FouJk7l
         Nsv2hpd3PZZ5wzBPYJLhd3TpycTk1V18Ld6rZJBbWUJz977maM62y4ClTrSt0cs5iiol
         winalZdRu1vM7geNVc4WD2EppDCqakXkt3d4VB+2T9z4acqU3sgUSQ6dDuZmjLzI0O/v
         2u7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742916171; x=1743520971;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FR1psq8rYb0jVgAPAumoNgxnKTwTi/S55HLEy0wx1vw=;
        b=jjGPfzAtP4BdaDUf5tgGKWfhqHSOGtlHXpWFsBEXAg9jntZ0LdySj6UiW0YDJN2z3L
         4X2QCZf5OruqzGXLAPtUfbmsCvDb8cMktYykyrqYMF9T+qUiRtsvrYkQKbHVQPcJKfI1
         i/M4t4vSktLnfZt9lD2V8LYbrwA1Ow4ncJWbgLGBTwYhw19b+icdAFPHXYQuvGsAJeaJ
         UdJoy1YfRPk9nE81MT2/fSAaLnHtXvrx1yqxoSa7o1LK5lsVYcq0bgZ8rNqnsZ+TJ8vG
         eK1nXIjuq6g//feJ9iT1vS58BDYxIM/sK6lC0F5eJs4zw1QOsZN8bEOTucXT4ix45WUh
         SzEA==
X-Forwarded-Encrypted: i=1; AJvYcCUHncBf+w/UKS7mdwZOiukCN42GXo2e5TWur0/ODmtlak0KoNVL+n5Sb/H5NEy6BnEeGixuF5X6@lists.linux.dev
X-Gm-Message-State: AOJu0YyUjIHnbzC2LcdHTc9mdzcdySoom3GZuKGsGNMMbVBj9x/SEquw
	84DWdIM3TmRp104KaZApMyS5/CdUIxMY6AKoaX1eBKLSzQ4xyf+3ccFOMmPb1OGHg5/z3c3Ygra
	6rzu+2f+M9hlm1zBF629rsPsRynf4atLhgMHVcbk678aI1fzYoKs=
X-Gm-Gg: ASbGncttzSf+dqX1PmZOB/vKbn/T4/BSFSivyqw0A9sHIt6Ush3Gw3o9itBjJKBn2Zw
	Jqkh8FnPm0R3HGAeHz508UMdt+zvLupyQ1Byq86TsJV/nF0sXFRonq1fVMfT7dH8JnoebEpLPSb
	QSB08wwN74RCeIoGymgiCk74JaaMeThOAwI/zOHSvTFBy2ztp5AC4+qr9srziyBenV/XW/uQ==
X-Google-Smtp-Source: AGHT+IFPyQveoVq2SQJDsUBSx33+PpHB6pNXsSERn8w+t52W+nsQCR7YrtRu8eLNlWuhbuil8gCmDMnrysGjzJPJ4tM=
X-Received: by 2002:a05:6122:a24:b0:51f:a02b:45d4 with SMTP id
 71dfb90a1353d-525f0acd8a5mr202640e0c.1.1742916170612; Tue, 25 Mar 2025
 08:22:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250325122156.633329074@linuxfoundation.org>
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 25 Mar 2025 20:52:39 +0530
X-Gm-Features: AQ5f1Jpu_5veFnVwrvzd6ONxa6kMdH0QnKmtM7yQuJWdcSN64QgsvR2p84j7Rx0
Message-ID: <CA+G9fYss7RcH=ocag66EM4z26O-6o-gaq+Jo+GOUr2W773vQOw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/198] 6.1.132-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Dragan Simic <dsimic@manjaro.org>, Heiko Stuebner <heiko@sntech.de>, jorn Helgaas <helgaas@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Mar 2025 at 17:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.132 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm64 rk3399 dtb builds failed with gcc-13 the
stable-rc 6.1.132-rc1

First seen on the v6.1.131-199-gc8f0cb669e59
 Good: v6.1.131
 Bad: 6.1.132-rc1

* arm64, build
  - gcc-13-defconfig

Regression Analysis:
 - New regression? yes
 - Reproducibility? Yes

Build regression: arm64 dtb rockchip non-existent node or label "vcca_0v9"
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
(phandle_references):
  /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"

  also defined at arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:665.8-675.3

## Source
* Kernel version: 6.1.132-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: c8f0cb669e590c6c73c274b9fc56270ec33fa06b
* Git describe: v6.1.131-199-gc8f0cb669e59
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-199-gc8f0cb669e59/

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-199-gc8f0cb669e59/testrun/27755718/suite/build/test/gcc-13-lkftconfig-devicetree/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-199-gc8f0cb669e59/testrun/27755718/suite/build/test/gcc-13-lkftconfig-devicetree/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-199-gc8f0cb669e59/testrun/27755718/suite/build/test/gcc-13-lkftconfig-devicetree/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2uoE2WrLPnhBvFm7ejgwd6QJxk8/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2uoE2WrLPnhBvFm7ejgwd6QJxk8/config

## Steps to reproduce
 - # tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
