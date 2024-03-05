Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF1D53E03
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 10:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709633314; cv=none; b=VptOA6xLknMwg2e6/cxDHODXN3m4nHsGU7eFQ96nD1lK4i64AARrHM2dTZG7TMqOI/PS9hzcPac4dwrDbEnKmLnQTFpfICukEBPf9ekZIftlKLyCC4fHXptMlZwG2CSwzr9bGvGPco2OiDjZdPN6z4/r9RfZ9m1W7g/S9+Q1fE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709633314; c=relaxed/simple;
	bh=AAT2HVEPA3dM1HBiRM7N4VVxTR53mysqKg/WAuUxMG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S4AFz7pR0A7XQmmrAtwB+wE+8GhNyCBlY4WILGUY6qrEAjSx3FlbR3VWN/F76nJNnDsTzISs2dS06omGiLgiAtEBHfpBhsI4Xm4q34fAcoKcKaZqvnaR6QKu0aijYJVIb7Gu5HE369nV4w7COFv3yhx1MmUc6GdkWw/0Q06yTZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=R6rNR3Ac; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="R6rNR3Ac"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-472746606b4so1007447137.3
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 02:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709633311; x=1710238111; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RcQYPt61ZswmG7Ltk4aqTMqKV2Gt5394DVr+HiHAY7c=;
        b=R6rNR3Ac7Ko1qnVi35ffDMYaJ9S8VGddNXTLDs4eCjVIQ3MncvZBtI07IHZ/FvRz8I
         gKmVq74cC0AEITjaZAnTqwtRgvoAaLXVTGikL/kyGXg6Vo1PSz+woJV1YcGUjc/TiixV
         DhWsyzLW3/LoN8kGopZxA5eX8PvRGX6niOdiiL0JoEkOBOjcnkiNbqxZxAsH+kbMj3qu
         dLq5365Po7tJ+vDGN1GAEHvgz/2NTMGBtHqvhwRmRlwntC1+Rv/k9RvgyuHCSr9+rsdI
         Wszw+MfSpOOG2w1va2LOgwoelYglOkLll2x0nMqVKqmdafgVUWWeTO/1iXvlfK1nalyb
         /Opg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709633311; x=1710238111;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RcQYPt61ZswmG7Ltk4aqTMqKV2Gt5394DVr+HiHAY7c=;
        b=ebz78g7nKOQOlCyytD52IN6qmIuyR3iopVvkpg+60fZQJn00fa23NFlmGgARxYWrHb
         7KzjUFVsziYYQsSEASvGg4twDKaVCNhxJzeE5mX+R6XMu9cCivU8O6QqwSzTCQ7G37nb
         zLBChYOCDiHFcFV8UkSsW45fe0TdicMAQt4zerVwmva+DXr+cIEz/OobVYLl8w0evSiR
         VH4K9nIA4+CZKIdtSU5wICB1xjUxVY5heZ9A6+qLyOnvY7a7j/8SN8ykuz1eNOOeG2Vu
         cE8ygdqlL6IvakroDRo6y/2BFXRS5Y3G6PqG+srNtWNP+UWWDKwqj19x5JMQij+j3uhX
         +rfA==
X-Forwarded-Encrypted: i=1; AJvYcCWpck1gJ+XRvp4LVhOf4VIcT85GdqhQz4TJ7pMFN1NTZsymM6Pf5CcfFfEj0R7kvsz2qpo5m/At3uxjWxeHBRFAP6bx8t8bvg==
X-Gm-Message-State: AOJu0YzwBXm4KL3MCv2ZyzQIiDtKITOe1AUi17eAXA4wiNwnUG2uhyRF
	qWNotP1nRvpZ8r7uvHrrXz/WIAdvL5oPm0LixsFX2WdfvXqjyNo+E4USz7HHo4vvrVxOXPfWWLU
	t/WFg1w47zyoQWppAHqym24X7EhYmdvcwaO7rjA==
X-Google-Smtp-Source: AGHT+IFp0tE8IoMcXWbHzzy6DSzTZLssOhqBeRslDbpiAMOBFY2vsJQqIa8loedxuKNtQwny5IBMpPE/nnJCa8ZQ8/Q=
X-Received: by 2002:a05:6102:49a:b0:472:b056:1264 with SMTP id
 n26-20020a056102049a00b00472b0561264mr1218311vsa.30.1709633311370; Tue, 05
 Mar 2024 02:08:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211542.332206551@linuxfoundation.org>
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 5 Mar 2024 15:38:20 +0530
Message-ID: <CA+G9fYvOpuVjEe_0E5bwsmP39VQwdybDEoKTZGeYC3ULtqmViQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/84] 5.15.151-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	Zong Li <zong.li@sifive.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Mar 2024 at 03:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.151 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.151-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Following build failures noticed on riscv.

The riscv tinyconfig and allnoconfig builds on 5.15.
The riscv defconfig, tinyconfig and allnoconfig builds on 5.10.

linux.5.15.y build failures on riscv.
riscv:
  build:
    * gcc-12-tinyconfig
    * gcc-8-allnoconfig
    * clang-17-tinyconfig
    * gcc-8-tinyconfig
    * gcc-12-allnoconfig

linux.5.10.y build failures on riscv.
riscv:

  * gcc-8-defconfig
  * clang-17-allnoconfig
  * gcc-12-tinyconfig
  * gcc-8-allnoconfig
  * gcc-8-allmodconfig
  * clang-17-defconfig
  * gcc-12-defconfig
  * clang-17-tinyconfig
  * gcc-12-allmodconfig
  * gcc-8-tinyconfig
  * gcc-12-allnoconfig

 Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

arch/riscv/kernel/return_address.c:39:9: error: implicit declaration
of function 'arch_stack_walk' [-Werror=implicit-function-declaration]
   39 |         arch_stack_walk(save_return_addr, &data, current, NULL);
      |         ^~~~~~~~~~~~~~~
cc1: some warnings being treated as errors

Suspecting patch,

riscv: add CALLER_ADDRx support
commit 680341382da56bd192ebfa4e58eaf4fec2e5bca7 upstream.

steps to reproduce:
---
# tuxmake --runtime podman --target-arch riscv --toolchain gcc-12
--kconfig defconfig

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/v5.15.149-332-ge7cbbec10c6e/testrun/22942335/suite/test/gcc-12-allnoconfig/history/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2dF68wn0dXbU2xGLRyzsxGdXTyB/

 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/v5.10.210-166-g4b0abedc88b0/testrun/22941782/suite/test/gcc-12-defconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/v5.10.210-166-g4b0abedc88b0/testrun/22941144/suite/test/gcc-12-defconfig/history/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2dF5ke88GqtfanduGie1JGLUbVa/

--
Linaro LKFT
https://lkft.linaro.org
