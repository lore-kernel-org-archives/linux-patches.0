Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCDC5381B
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 17:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725558731; cv=none; b=FqkvRS1JOh6CmISyxSgDqCKvgiZZZQX3wom5879Lc1rO9XxKswvmULfyr+43lgvylTvdS3fmVGQ4bKpCkCJ1yDq1atyGuCJ3YFC5nAybWQe9jYmeKoXyz/kV4Vt6yHLwvBCZZFRYdqI9iHtGe6sF90DyGFpI0YLuTm2TB0nC/IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725558731; c=relaxed/simple;
	bh=zyBfW0Tco4IThEnlAHhtYiZVmZaFd2ymNn4UAK6qYYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WIOBbGr+FXJy3MSdylCxDkyFqDQtxZIrkR7SNbWbmCTUic8mj7atM3p0SCmXQNkSBPg6l0pJz/Mg02HyEwnNiI/G/UePbuURlvOBz8wjJoWrnNrLBYheVBjMney0EuYpjarlT7WtA5R01jbs4OZ28urZzAhymPsi9y9wuQ7s2cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fss8+Sxp; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fss8+Sxp"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-205722ba00cso10717835ad.0
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 10:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725558730; x=1726163530; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=POEvdg5MNJNP2xrdrnmN+ih9E3dB/pXUEq+0r2f4xEs=;
        b=fss8+SxpdXSck+2iaMXsRx+aPZ5TbQo9pqsgwOz860jO7P6QsRj34KHzEc24wXL6b5
         gr9hIFwLXBnsePso6qsA3/sFdriRtT8KU78HxHgCbuPK599yUHBWtt1ZjwAVsaaDjCw8
         kq42DJCr6RMFISgQ6KJNmUGfeKSRl4k9K69yU3WKmT7/gmRSa9+d1neECJ4g1Td3/reZ
         C+jlcMELS9jYifnQxTwgfwbaIBZhnAV7PkCvenG8osmdqpZprvtomOLixMoIIQmkJIMI
         2HZzVkn6pA3Zvzr8ktIdG6rAUhBZ2U/q3O5cIDtwI2gz4n1uSm60+tXRntouT7NShfBv
         oQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725558730; x=1726163530;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=POEvdg5MNJNP2xrdrnmN+ih9E3dB/pXUEq+0r2f4xEs=;
        b=HYyfXtJX9dXrZNToKTQY0ZW0cArrQLIDyLpABddUh7Xv4is+jjJafTqQ/nkEj6mVNA
         /c+MmKmytV4mAeNm8hjwbPoVjrSLdiY/X88PY2vOprzw1wjASLgGe4yyiWvHSxmiVQmg
         XMrTbh3lzeV4S0/Z9YOJEBCmw70Y/S/rrETe88QqNbHnJ30ncqbciHzQAZ6rEIIZ8n5o
         UOKUEmqEZK94KvDggAD+UPn4PR8FpgdBbavA4jLxDE54hLCaxD5moEI/x/iDx/NZRaRa
         +uW+fZMBZw1iQpfzME5BU/wxCjBq/X9LOS4MCQPoJAYoqrcA75/BbMvTb/t7qYCHQjif
         oqbQ==
X-Gm-Message-State: AOJu0YxskpoW9dB0zrQVLrQIe5eIBc2dY0EBfhqjcnlvx/vTFNtSF5MV
	URn1TH/NyAivOzEULgQFoNl54QpxwZt1oyaPCH/0aWZ/8Sa4pdoC
X-Google-Smtp-Source: AGHT+IFh7evhUz/1N/ZF/XZcMHAy53GFewpSKpQhs9rzY9X3KyQGDCfxgodVg6adKgiVrH++7gcvhw==
X-Received: by 2002:a17:902:d2c2:b0:205:3975:5ea0 with SMTP id d9443c01a7336-20547642f99mr182433915ad.45.1725558729524;
        Thu, 05 Sep 2024 10:52:09 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206ae968f78sm31107475ad.119.2024.09.05.10.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2024 10:52:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <092aa55c-0538-41e5-8ed0-d0a96b06f32e@roeck-us.net>
Date: Thu, 5 Sep 2024 10:52:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/134] 5.4.283-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, broonie@kernel.org, Helge Deller <deller@gmx.de>
References: <20240901160809.752718937@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/24 09:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.283 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
> 
[ ... ]

> Helge Deller <deller@gmx.de>
>      parisc: Use irq_enter_rcu() to fix warning at kernel/context_tracking.c:367
> 

irq_enter_rcu() does not exist in v5.4.y and v4.19.y, resulting in the following
build errors in v4.19.y and v5.4.y.

Building parisc:allnoconfig ... failed
--------------
Error log:
arch/parisc/kernel/irq.c: In function 'do_cpu_irq_mask':
arch/parisc/kernel/irq.c:523:9: error: implicit declaration of function 'irq_enter_rcu'; did you mean 'irq_enter'? [-Werror=implicit-function-declaration]
   523 |         irq_enter_rcu();
       |         ^~~~~~~~~~~~~
       |         irq_enter
arch/parisc/kernel/irq.c:558:9: error: implicit declaration of function 'irq_exit_rcu'; did you mean 'irq_exit'? [-Werror=implicit-function-declaration]
   558 |         irq_exit_rcu();
       |         ^~~~~~~~~~~~
       |         irq_exit

Guenter

