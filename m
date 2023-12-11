Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EE248CCD
	for <patches@lists.linux.dev>; Mon, 11 Dec 2023 19:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NZbGAjk4"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6d9e9b72ecfso2557053a34.3
        for <patches@lists.linux.dev>; Mon, 11 Dec 2023 11:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702323969; x=1702928769; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ImaO0HiB00KnmVvwdifGKd5anpGyBP2weFFw/cHgfm0=;
        b=NZbGAjk4YRx9KbvoqtXIuoHDEYY/hTReBizlqyyYsakDlNNH5U3/NNbpIbBYMVteHG
         CXVltEF+brvTGXzwveAZQKPmbnodn84FSfPLMA98KiQ2KhJvRjV7fn+ysjatRtvoq5GU
         BGLwg8WDwxwwZeR+WCzJdwVNoNU8ZL3AW3MRsVUg2fz52IGnNBGFQoUwNyzCNKwc7rgF
         Z87Oag66BPpQWNspRJP5q+QEcYlnE+YisQCelXPIBtENLrjRPRq/n4MrVEBf5aBuw5qs
         uSk4+s62WsvaD1Rn78fkk2oe5X8km1GMcG9vWKG2Xtv3YQbfE4y6aRG4eUqdQDDQvnvX
         MW9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702323969; x=1702928769;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ImaO0HiB00KnmVvwdifGKd5anpGyBP2weFFw/cHgfm0=;
        b=NZpA1l0o9CNNK0VYcCFDAPHYezkwJiRQp7c3OpeStHmrBjJCJX8xSigL+8ix38OPiE
         RCobLpDruy8qaMf5Q4Mhcht3FJpe8iaPJhZzW2b+tKFH7uVO50AYvAA1JHJYxn8v0Ib+
         3rSSw8Wk5BXyeR1I1Ud+M4xRQtYuxZOBISFn1cTSuhQfWJSR0nZ+mIDhqnB2MdY5QcZH
         IhVOa1NmCU1i4g4Qm2TQl6mrGy8zjan2sDtPiYYo+yWk5C8vWc4ouyLmafQLcSaN0FdF
         MeyNQwWybmRb/o8Zkva8Gh84gY4OvAyQWGjOzrkVMpErfOi1N0x74dsOoi/OmaTJS7Xz
         8w6A==
X-Gm-Message-State: AOJu0YwqiCqOlrelS+2GqgLLa7iZcJ5duoMly6OlFhpvz0yhyFriEdG6
	PaxpEFoOr6UnYZYPPFpnUWw/5A==
X-Google-Smtp-Source: AGHT+IH7YlVHb83oEeaYR5yfIB5dT4KgPf8C+yd99M6a4B7imAXNABkjzoUjSei5n/PxEabG+OtZsA==
X-Received: by 2002:a05:6870:c07:b0:1fa:f0ed:6865 with SMTP id le7-20020a0568700c0700b001faf0ed6865mr7000027oab.5.1702323967203;
        Mon, 11 Dec 2023 11:46:07 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.113])
        by smtp.gmail.com with ESMTPSA id j1-20020a9d7d81000000b006d99cb99f25sm1835434otn.81.2023.12.11.11.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 11:46:06 -0800 (PST)
Message-ID: <f63a13c6-7e19-42a9-89fd-c37249a855eb@linaro.org>
Date: Mon, 11 Dec 2023 13:46:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.14 00/25] 4.14.333-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, arnd@arndb.de
References: <20231211182008.665944227@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231211182008.665944227@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 11/12/23 12:20 p. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.333 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.333-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 4.14.333-rc1
> 
[...]
> 
> Arnd Bergmann <arnd@arndb.de>
>      ARM: PL011: Fix DMA support
[...]

We see a build problem with this commit (at least) on 4.14:
-----8<-----
   /builds/linux/kernel/sched/core.c: In function 'sched_init':
   /builds/linux/kernel/sched/core.c:5962:30: warning: the comparison will always evaluate as 'false' for the address of 'cpu_isolated_map' will never be NULL [-Waddress]
    5962 |         if (cpu_isolated_map == NULL)
         |                              ^~
   /builds/linux/kernel/sched/core.c:87:15: note: 'cpu_isolated_map' declared here
      87 | cpumask_var_t cpu_isolated_map;
         |               ^~~~~~~~~~~~~~~~
   /builds/linux/drivers/tty/serial/amba-pl011.c: In function 'pl011_dma_tx_refill':
   /builds/linux/drivers/tty/serial/amba-pl011.c:657:27: error: 'DMA_MAPPING_ERROR' undeclared (first use in this function)
     657 |         if (dmatx->dma == DMA_MAPPING_ERROR) {
         |                           ^~~~~~~~~~~~~~~~~
   /builds/linux/drivers/tty/serial/amba-pl011.c:657:27: note: each undeclared identifier is reported only once for each function it appears in
   make[4]: *** [/builds/linux/scripts/Makefile.build:329: drivers/tty/serial/amba-pl011.o] Error 1
   make[4]: Target '__build' not remade because of errors.
----->8-----

Reverting that patch makes the build for arm/u8500_defconfig. We'll continue looking for other things.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

