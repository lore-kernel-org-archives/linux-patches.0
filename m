Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406C625A2C1
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 15:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742915277; cv=none; b=qD7Dg63ERyiS+66VGQdbtDf3feGvdXXs6BLdmJr0y/oyCoiwfRexHWrq7dbyodor9cyA/fmvFigymwFgN8gW8dl5gAWQISqRgwE541vwskzvyG++yZFO6uP59FDjRavX11p/JSSjfTatEG1Zdk/AwFs8pXVxyoy+4QbBql1QkJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742915277; c=relaxed/simple;
	bh=iSmodtdY7Dchcz1A/sUPS+H3SHiLLQyywM4beAv33u0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=edZPr4Iw27Z/A7BlS75+b80bSL1etNpWWb7pZNFKdxVhq7p6Atj6YwaMKHHRjWBbEHrzgsIUsuv3wBQYu3WrMJ5wBeD6P3wjtG2g/l/7ogI2M1n2x5xGOrxVu3Bwljk1J3Rq0pQdTOY2pnOAeBNw9S2/1bEGZZAQEcZgmpMqExg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s8idBTH1; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s8idBTH1"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-523f19d39d3so2756310e0c.2
        for <patches@lists.linux.dev>; Tue, 25 Mar 2025 08:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742915274; x=1743520074; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ASRZZn4DjAVCiGVwyErb4eVcqvprss3kx2mpnoqQ/Aw=;
        b=s8idBTH1IU0c7cm3xdDM2AED2OmuyUZwcQxSmXlfq7eQ/eOoEq4VtPVuHIOGzlFne0
         ik8IdXm2G124M60mvRo3K1zMHO1qDWkKZ0e6X72zKPJVi+bl21BRyEplKKZQHE0Dm+qY
         baC+0egMufB11hLcaZfCRNeQ61pQxX5fRkpNnU3HGU5b7HJ/arNnG8zpzgJ8/6ylN2s7
         wGSXIfb8xVZrOVZDf2V9EOtTOzEWQT1OUNXi/TxVMD1z3WmzJDaI0OVTC7yhpX6VfMOS
         woQ1ZP5fUZhe8e9EZrOvwEbP6/2tdmiDL8XyzCCSOxNjZnP7NgojwYgBobbbDKGDDXO1
         haMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742915274; x=1743520074;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ASRZZn4DjAVCiGVwyErb4eVcqvprss3kx2mpnoqQ/Aw=;
        b=bfGGy97NVfHAmLeTV6c2k/YNQ5Rm3ojWmynWFtwJs5o1ERAiL+bbL27DL3j0P/5QXe
         X7+jkPFWkVGdPFZvlGtynDeYzK7YT+8u9vxjMdjn3S7BqagqjV+bi5RtybOIvaJc8Wn9
         u9OBY6TpugVbbn1ibXCnmdHgtYjHVNE1N5u/wIGddT2LNDuyOmChfXb8zpBvvDKd6Flw
         f749/1fhzrbxgaOR0BnUz7KI7ObE3ekh/DYVvbysjSIshyKzC6eogB1hKSFbiXylkRzR
         umSwh7R+Ruhgb8OhIyNQqm3O53rhfn8R3BBghl5YUzhdZaNogtj7Js9zgT7YGI1a5kbQ
         KqJw==
X-Forwarded-Encrypted: i=1; AJvYcCVp7jftAgefNp4q2oswtEK26SEP/gTUL5r0wTMiXBaCY/BeRGL5ILhZHXzsHH3pNcgrnEb756wD@lists.linux.dev
X-Gm-Message-State: AOJu0YxHNvSe3mEIdYQNK7DHJNqjI3lQXnkTXhhWjX3FI3j2LyCz1+2z
	9Y5hZczmWiz4HZu/OjdbtRNpA9moHoio/+aAP8eYjMoqzt5wBBkn+vR0nUbFWvNfNzR5TZfgbe+
	FhD8j5Vd9WT/Xr0FJabSn5N8FqpMbEYz+1HWYWw==
X-Gm-Gg: ASbGncsMs9r6v4jWKBTJsQu+3AZPbSi5f9RMEn7DB5JPasWwEeKMfFmR2N5MggwLL9T
	wRpMJFdnJzQkYz3jpav3qQ8pi3aewoEvBL6QhsWeTqlvd/fZDR+e2rfmD8SZiR360Vphn6/5vRp
	bHIwtbG7LYucDNwfpdFOEIdXvTKD6AwMZrcZbbfRHeN7FvqwvHralCtUWXlzk=
X-Google-Smtp-Source: AGHT+IGJxNNn58Pr6BXkc8yTC7dt3Dz8oYa2jVHYnOw8DdFwyMT+9nGnrZ/TQ+Sepc3obyBo9xvaY36PFzfQAXxFVmo=
X-Received: by 2002:a05:6122:2810:b0:520:60c2:3fb with SMTP id
 71dfb90a1353d-525a80d5eb4mr10912049e0c.0.1742915273945; Tue, 25 Mar 2025
 08:07:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250325122144.259256924@linuxfoundation.org>
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 25 Mar 2025 20:37:42 +0530
X-Gm-Features: AQ5f1Jo5lbttZtSAb6LnZgDq3AuZotqFT2rixgG9lx0L7Z-hkj4vcw5915tDF-M
Message-ID: <CA+G9fYvWau1nC8wmpWkxG8gWPaRMP9pbkh2eNsAZoUMeRPgzqA@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/77] 6.6.85-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Heiko Stuebner <heiko@sntech.de>, Dragan Simic <dsimic@manjaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Mar 2025 at 18:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.85 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.85-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Regressions on arm64 rk3399 dtb builds failed with gcc-13 the
stable-rc 6.6.85-rc1

First seen on the v6.6.83-245-gc1fb5424adea
 Good: v6.6.84
 Bad: 6.6.85-rc1

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

  also defined at arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3

## Source
* Kernel version: 6.6.85-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: c1fb5424adea53e3a4d8b2018c5e974f7772af29
* Git describe: v6.6.83-245-gc1fb5424adea
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-245-gc1fb5424adea/

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-245-gc1fb5424adea/testrun/27760755/suite/build/test/gcc-13-defconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-245-gc1fb5424adea/testrun/27763720/suite/build/test/gcc-13-defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-245-gc1fb5424adea/testrun/27760755/suite/build/test/gcc-13-defconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2uoHmBcVLd60GQ0SVHWAaZRZfNd/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2uoHmBcVLd60GQ0SVHWAaZRZfNd/config

## Steps to reproduce
 - # tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13
--kconfig defconfig


--
Linaro LKFT
https://lkft.linaro.org
