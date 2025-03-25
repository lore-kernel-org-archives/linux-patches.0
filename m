Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5958C1A23B0
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 16:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742919271; cv=none; b=RGrnCkr9u5lgKGTYYZuGCaueQLmq3txEMB1zaov76YA78X0bU01IkFJSbKJEG8zS5HtDIFxpf0bsVD8wTySrYGxAxJZIrJ6lx/BOb5h/ttKUEVL5m3y7pylt3ZrUfOvD/KHLP3CFOivyfKLZ4v6aCCtrDrRBH9BTOTV39pz2g2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742919271; c=relaxed/simple;
	bh=xXcB18cHItpKdRkh30guopUU49ZVJxSa+x01vlmZgrw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d+z83YiByF3QpxH4+6BrG0+YZs5K/vpt0S+QYN7ee0uH1fUYgJAeNXkC8jnzYzSUgVZ9rN5/sBftlb7ACmOLY4ShHo/oDSnS5GWsAmsjfs/s0/eanzQKJQTRK1RDU2s0pRJQGFgEIhwRh4QLOoRx/MhO70b+Zx+bzix5YfKfS30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VRRDmFb1; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VRRDmFb1"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-523d8c024dfso2283266e0c.3
        for <patches@lists.linux.dev>; Tue, 25 Mar 2025 09:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742919268; x=1743524068; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BaohcKTCwY8+VpwM3aapzTE/kg503pUIVGtaPhgwj1s=;
        b=VRRDmFb1sJqtOiJQ0uXwTxI/SoSJOhnzKqbrJx6HRt+JkXtvxPI/vaxNLoHjrtmvgH
         uuBet6+u2UaAd+7hUTxeiInfoDEVU9litRoCbaovoVhzEDJz4JWaWif9YicFaeG+Nhdx
         OIYb0knbqX06IxK0xeoveKaC+RR91TSLKqxF6B3UF6tLLfqvv4nd86RQtZcU4GzIALXr
         T5gmAxCGAiGtaH6zQw8VjLdKeNgFAIh4hRJIgzMd57LygxhfgbkUxxdxY7+NHNp1LUpD
         UASmfEjKM3I0F1uJJBRwB0hspDC8yUxmqIWfB9xBy+Sv8dAEfoq3crDAegFYR4Z0QcBQ
         2YsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742919268; x=1743524068;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BaohcKTCwY8+VpwM3aapzTE/kg503pUIVGtaPhgwj1s=;
        b=ZGJPV4u7GihHrX/vbOr6LzyD5LAVt4FgiUcDqhqhUVP0Ob40WPv2yi+0YDsGMtc3dd
         4ofYpSl0bgPVwmB+UndepCrQAKm4KIIikoNc1q6bEdDDXYMnTCaCc2BkujRrjoSX1gLd
         KvL6n71xwHOgr81zCjJLmLvxg1BpZJHm3nkZ9tH/vG8pFEaNqFUassA7yPQ8f2p1bnsT
         1SAw9svKB03paO11Wna/+HOX8EN6r8q30YjXe0zV0b8JoXQ8lwBfhokODWOexecxaEfX
         N2fWYbWSwmXeTL+c5BSo7FJmUCzdn53YIyEzqT6fATbGZJr73p0PHykiUoCdFwj/lGUK
         IMtw==
X-Forwarded-Encrypted: i=1; AJvYcCUftHGlmSuv4Vm7697hMTema+SLLoq8F9zWtvkRMrkgrsXQRISatl1CCZ2NYvszU4lwt5EdUIFq@lists.linux.dev
X-Gm-Message-State: AOJu0YyV69bKEKavFniDmHhdayEn1KtJzQq4lugeqXIV6VAr9XybXasJ
	AbpZ7Qxr61yD/4mz2UjBwAIu5dewfQfWn5LwevoLmlDKFKzZc/lJBCjz/KUQ4OXr1RlYzWSqCl7
	jxbl8RpnmJxqvjlrNMPNxteglMo60owLunF1/NQ==
X-Gm-Gg: ASbGncstzWDGLg3qpoepegd5avh/zjGs4Vq1KpCie6QkguEjFjhJ0bb5okfLKz2imG4
	ZnKqijvkJsYQBwbDR6pG/ckV9rI1oXUdsVa7Q4q1Yql8RL6J7IXmR9Hqz7MSNdaZLljNd9JjnBQ
	THge7K8WaaEN5bLmjMFKspOiasdh9wlYPE3KsSyCLdqFIvwzBlhI2WS80GmuMPatmBu+TnKg==
X-Google-Smtp-Source: AGHT+IEPYTodFqcqF8Efn8cEBRGiITyGd0BPRmWJhgYjQS7JJvpdV/lixW5XnmBOn5f5Fk8rQGTqZ+ByuVXZYVxL/bQ=
X-Received: by 2002:a05:6122:6184:b0:525:aeb7:f22e with SMTP id
 71dfb90a1353d-525aeb7f2afmr7300952e0c.7.1742919268062; Tue, 25 Mar 2025
 09:14:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250325122149.207086105@linuxfoundation.org>
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 25 Mar 2025 21:44:15 +0530
X-Gm-Features: AQ5f1JqspNdi-6TlUeHbfzfXwOqeSMIOZd9HQXTwahnt1Erb3i0Fy8v8uY2WGpM
Message-ID: <CA+G9fYvaziw0a60idsSbDdSQLL2L+W7VnVv9VJHc-2M5p5qRfQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/116] 6.12.21-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Bjorn Helgaas <helgaas@kernel.org>, Heiko Stuebner <heiko@sntech.de>, Dragan Simic <dsimic@manjaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Mar 2025 at 18:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.21 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.21-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Regressions on arm64 rk3399 dtb builds failed with gcc-13 the
stable-rc 6.12.21-rc1

First seen on the v6.12.19-349-g8c2b29e24438
 Good: v6.12.20
 Bad: 6.12.21-rc1

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

Anders bisected this to,
# first bad commit:
  [b3d8759e5e8530302831e24232cb360388a2d62e]
  arm64: dts: rockchip: Add missing PCIe supplies to RockPro64 board dtsi

## Source
* Kernel version: 6.12.21-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: 8c2b29e24438f0439af527927ea2989df3a41c6f
* Git describe: v6.12.19-349-g8c2b29e24438
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.19-349-g8c2b29e24438/

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.19-349-g8c2b29e24438/testrun/27759652/suite/build/test/gcc-13-lkftconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.19-349-g8c2b29e24438/testrun/27759652/suite/build/test/gcc-13-lkftconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.19-349-g8c2b29e24438/testrun/27759652/suite/build/test/gcc-13-lkftconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2uoHnrrOWLw0FMCQJDU4Si0cD9n/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2uoHnrrOWLw0FMCQJDU4Si0cD9n/config

## Steps to reproduce
 - # tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
