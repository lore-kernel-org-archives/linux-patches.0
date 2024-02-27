Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558A55102E
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 18:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709060196; cv=none; b=KZxoep1YyvyNEftVfHtqcAlrd7qFDLHcxywAk3z4+FbCEJLRsx27WuPMgs+OuJahJw/aOn+ew9+IQKtP6Xc/ibSZs8N4tVyWU1imRVIYaRRBcgHHT8mAinZD5xV1CdEcnMP1QAEfVeyzq3484Ufe+MW6aHMNcdE/H0rWwHI8oXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709060196; c=relaxed/simple;
	bh=joxNp0GzaDrB+Tqo0IVLqZ8aPuRQJFLXfeoomOYwaIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BFikdEdQNd+qBx0kZM9tdjfxBtmd3UemZTqG346523yMk1OOo2H0SMsRyBHHK2mLGSwi5val5s9/+yr4UlXG+kOppEJYzzTNmymXOstUO1m/R2kWJ2YQJAb3yigIrW2IJOfYbwY/is/Hwc1qWKp0s50XUKIM5l6lAI8Z8jOBq8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gtmc5q7t; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gtmc5q7t"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5a0680bc600so1094390eaf.0
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 10:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709060194; x=1709664994; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gZ/MgDmSYcNeqlWlA/LkDt8FR4v24Xer+dQHBBLw5yg=;
        b=gtmc5q7tmvWoTzQSKLfrGzmFLxi5IPNFU9fI1DJxNKxoQEveHabUEQk7MR1HFIXLJ1
         OBEmahPo0WN/7UVQ4viVVbikDlRMm/ut8iwZIAtHod4IgubVRMsefOs5L8DxNIE4DDUk
         1oG94VtcAlZ6INiXhRlJSPnAGHafYy/GliGY5SpzqX3Xq6NMuu3hUfnQdOH8YWxBLaOw
         Kl1/+/Fg8bhHM0dwd8XF/OP8BAhxj3PaaolxaCBvap20akRaqEIqiMTSqgM9xMw3SaGC
         Fvi9qZh+3ys/qUrjoyDw7anptH++LNfV5SZ+G2kX1DbL3J0JUfiSaLDX312QOotQe23X
         R87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709060194; x=1709664994;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gZ/MgDmSYcNeqlWlA/LkDt8FR4v24Xer+dQHBBLw5yg=;
        b=axVml14Gx1S27ZOxi77VaeVqMfSuZxB5dyOwfEKkMhyQQyvJEeiVZ/XGFa8AW0pn9q
         c+cV6oOgnHVn8IYeBftcaedOSYj1Hz0dx71B1Apf6fnEGydCvt2WUKTPMwIgwXJ6GYZy
         h2pL5mex8v7H6l4ySQWdi9bEwcNEJPwW7oDlaM45b1nXmUHUeNBlLseqfOqTsDecXKGW
         9k8Cb1KCp7aD9iSjh7HCrCcBWD7h/fVkykGfOrQyL2cU8s+ooI83zTtbZK4z12qQdq2t
         9bDPR6+wuyQ0gNmBAJExd1cWXNV+J8BlKax8BKXMc+66Q5YhG1GJdKzWTzt6oHgw6rSy
         2nYA==
X-Gm-Message-State: AOJu0Yy93xDfpscw8V9Z5qijTme5aH9QJ3EPWf1zPgEdJGjIrJh8DEI3
	TLJ9v1bY/IhWkvE1Lxh50lYDs6N84SC1pUtnnQ/402BFlqX6nz3pEHjW9uR2pvk=
X-Google-Smtp-Source: AGHT+IFBcdrQIWIklX/t7KgJfjyLYOQtoqH4hV/tzjIuc27CYI3IKgucuOxGE8u1vPiECk5Z2JE+SQ==
X-Received: by 2002:a4a:3053:0:b0:5a0:ac20:155a with SMTP id z19-20020a4a3053000000b005a0ac20155amr3057942ooz.9.1709060194427;
        Tue, 27 Feb 2024 10:56:34 -0800 (PST)
Received: from [192.168.17.16] ([149.19.169.47])
        by smtp.gmail.com with ESMTPSA id o12-20020a4a384c000000b005a0af4efa0dsm377271oof.21.2024.02.27.10.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 10:56:33 -0800 (PST)
Message-ID: <ac2c579e-4ff0-42e2-ab70-efb8ded2d257@linaro.org>
Date: Tue, 27 Feb 2024 12:56:32 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/245] 5.15.150-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, paul@crapouillou.net
References: <20240227131615.098467438@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 27/02/24 7:23 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.150 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.150-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We're seeing build regressions here with RISC-V, with GCC 8, GCC 12, and Clang 17:

-----8<-----
   In file included from /builds/linux/include/linux/list.h:9,
                    from /builds/linux/include/linux/module.h:12,
                    from /builds/linux/drivers/net/ethernet/realtek/r8169_main.c:12:
   /builds/linux/drivers/net/ethernet/realtek/r8169_main.c:5512:35: error: 'rtl8169_pm_ops' undeclared here (not in a function); did you mean 'rtl8169_poll'?
    5512 |         .driver.pm      = pm_ptr(&rtl8169_pm_ops),
         |                                   ^~~~~~~~~~~~~~
   /builds/linux/include/linux/kernel.h:46:44: note: in definition of macro 'PTR_IF'
      46 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                            ^~~
   /builds/linux/drivers/net/ethernet/realtek/r8169_main.c:5512:27: note: in expansion of macro 'pm_ptr'
    5512 |         .driver.pm      = pm_ptr(&rtl8169_pm_ops),
         |                           ^~~~~~
   make[5]: *** [/builds/linux/scripts/Makefile.build:289: drivers/net/ethernet/realtek/r8169_main.o] Error 1
----->8-----

Bisection points to:

   commit ac2871f646a8f556203f5b6be875ce406d855ddb
   Author: Paul Cercueil <paul@crapouillou.net>
   Date:   Tue Dec 7 00:20:59 2021 +0000
       PM: core: Redefine pm_ptr() macro
       
       [ Upstream commit c06ef740d401d0f4ab188882bf6f8d9cf0f75eaf ]

A revert could not be done cleanly.

Tuxmake reproducer:

   tuxmake --runtime podman --target-arch riscv --toolchain gcc-12 --kconfig defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

