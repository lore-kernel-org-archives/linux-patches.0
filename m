Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F69E328C2
	for <patches@lists.linux.dev>; Fri,  5 Jan 2024 16:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x+CRH7U5"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6dc83674972so935928a34.1
        for <patches@lists.linux.dev>; Fri, 05 Jan 2024 08:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704470692; x=1705075492; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g/cqkHT4FbEcLpTCBsflcScZ0SAC3mcZJQ2qbWtluSE=;
        b=x+CRH7U53vO1sOEa2ti1Hv7uNVrIGSilhxg8MsLK1aJEJXLSZex8qdy6EcKcZm99cQ
         8Rb0iE+PJtgi901ODSaVe32KErnSopChvX5WRrkdo+dsydBxO/cRjhT5686ihTJtIvcO
         23lA0n5yyMbdLranHOjsG8kKfAzaMIg8gd51OeOs4yRvJIyPenPJL+ttJsGE+A+zaBt0
         ESHL7mtrkHb/icKUTvpbtTO0yqq7py3tnN/Qzm567i6pIOr2x71dftA+SfnBgQjPa2QK
         b8xfKg7xhfDb6JRQLof5XWLk+hcXBuTxjdgGjZWrnZ4a+yBePGPk2Ci4Fk/mcSkj0Z6V
         +2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704470692; x=1705075492;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g/cqkHT4FbEcLpTCBsflcScZ0SAC3mcZJQ2qbWtluSE=;
        b=ScqrrC6ItWKKQItxr8ypBOkrwKwPp5qrjQyt/gti7iorPfvyR3G4v2kyE12Z1i5lV2
         RyMMUeJjItrFtWu5ogft8XuAI9yH7B9GXQlfRgafKf3YbNyS0EBEP4SUJjZtgjnNlzTI
         mjdCtr4lA2djtIQvCNJi/xNKJrjS5hiI6ULFq4hn/Xw9pgamRcsCsy3f6Uq1Uy00sLkh
         f7RpVTyUG8O4ayCuFImupL8OIWNPle5OlfEPLgTOQMoZjkpMw0t2b+xoCrIRSUgqgTsj
         g5cr9sTd1o6df2ITrEbOqMUNATUJtiOWBGFip8uaoOwiHGLFovw7+Z1h9UObIdG94fQx
         k4sg==
X-Gm-Message-State: AOJu0YxXY+Ma9jJA8oanfDH0o0PjRNyBP0GM0Iz/8hDz9vjr9C1GtBSp
	NEsdAM7/UCNjKQuLafUt+h51pU9JDjXmtA==
X-Google-Smtp-Source: AGHT+IHoqgc/4KxOLgqUZ3DBIB/H9/F5fTAwUyj3GQ1drQDOpDweX5+WGWBedMdanPP/4rhq1Xq6UQ==
X-Received: by 2002:a9d:7748:0:b0:6dc:a1:90bb with SMTP id t8-20020a9d7748000000b006dc00a190bbmr2385822otl.69.1704470692568;
        Fri, 05 Jan 2024 08:04:52 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.70])
        by smtp.gmail.com with ESMTPSA id c21-20020a9d6c95000000b006dbd51a58b8sm409667otr.37.2024.01.05.08.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jan 2024 08:04:52 -0800 (PST)
Message-ID: <77569e45-ab73-4049-b90e-cd60cbb872ef@linaro.org>
Date: Fri, 5 Jan 2024 10:04:49 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/47] 5.4.266-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240105143815.541462991@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 05/01/24 8:38 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.266 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Jan 2024 14:38:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.266-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Quick note that there are Arm32 failures:

-----8<-----
   /builds/linux/drivers/bus/ti-sysc.c: In function 'sysc_reset':
   /builds/linux/drivers/bus/ti-sysc.c:1847:4: error: implicit declaration of function 'fsleep'; did you mean 'ssleep'? [-Werror=implicit-function-declaration]
    1847 |    fsleep(ddata->cfg.srst_udelay);
         |    ^~~~~~
         |    ssleep
   cc1: some warnings being treated as errors
   make[3]: *** [/builds/linux/scripts/Makefile.build:262: drivers/bus/ti-sysc.o] Error 1
----->8-----

This is with the following configurations:
* clang-17-defconfig
* clang-17-lkftconfig
* clang-17-lkftconfig-no-kselftest-frag
* clang-17-omap2plus_defconfig
* clang-lkftconfig
* clang-nightly-defconfig
* clang-nightly-lkftconfig
* clang-nightly-lkftconfig-kselftest
* clang-nightly-omap2plus_defconfig
* gcc-8-defconfig
* gcc-8-omap2plus_defconfig
* gcc-10-lkftconfig
* gcc-10-lkftconfig-debug
* gcc-10-lkftconfig-debug-kmemleak
* gcc-10-lkftconfig-kselftest-kernel
* gcc-10-lkftconfig-libgpiod
* gcc-10-lkftconfig-perf-kernel
* gcc-10-lkftconfig-rcutorture
* gcc-12-defconfig
* gcc-12-lkftconfig
* gcc-12-lkftconfig-debug
* gcc-12-lkftconfig-debug-kmemleak
* gcc-12-lkftconfig-kasan
* gcc-12-lkftconfig-kselftest
* gcc-12-lkftconfig-kunit
* gcc-12-lkftconfig-libgpiod
* gcc-12-lkftconfig-no-kselftest-frag
* gcc-12-lkftconfig-perf
* gcc-12-lkftconfig-rcutorture
* gcc-12-omap2plus_defconfig

A reproducer:

   tuxmake --runtime podman --target-arch arm --toolchain gcc-12 --kconfig defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

