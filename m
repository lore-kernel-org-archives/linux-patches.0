Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E2320CCCE
	for <patches@lists.linux.dev>; Tue,  8 Oct 2024 17:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728410110; cv=none; b=hGzvJ6g12YlfVlaCjVf9YxK+Igx7EN9QDBFDrrm6oQaxjZ2zFJYyE/JepwjMiEcorC9bKLzIOQ+Fc3lWymYRo2PPGARHH2emN6mpFJh3mAEteHMHf3ZCCj+KemV5glWQu/tudLl5xhgIZb2fzRyaI2XF59lZi7wsAgKeD246tBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728410110; c=relaxed/simple;
	bh=+opyFkO7uTdSM8dRx1T2Wo37V3GQcLzEs4HdjNu35kI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a3fuO43rRKLX6UNMps7zKXZook78LRXuBlQgLRyKiNDPNdBGFGN0L9bl8A5fSVDEGhgO76kW0QmGWU6fgQ3g23jaxTnloHSaembcOD5pwRHFiFiqxCYG9fTNXOm0qgK4SnocNHSPhWKmi8naLbicUAm1DMs+OSETk4myYXyDHhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gt2rl95w; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gt2rl95w"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-71df8585a42so2500415b3a.3
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 10:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728410108; x=1729014908; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=C9Llx3JgjxdZ1E8VvxGopT4ijmhNNKcWyl2diOpaG/E=;
        b=Gt2rl95wbX8xg9sfFt3ehpfKci+cqa7wi/OWTkCrFerB+pvkfCiEj4QVMfIYoXSrBW
         /4O/7IbwR5RAHzRGoCjEkvnKyQ2qeXi4kK1JbAA70eEmW8FFb+G6T97gqIENjaRI/VFZ
         JQ0m+WG++csLTIHui1t+p2Zm64qxWJiqmXDao0ZbjsvPhfR6eblltHzJvc2pjBXwJl5a
         UxBXSKepQBF0id5/Oui2GQeuHjYKEq0CngiGSSUoStwjdRbW85QOPssqKh+4TE8SiIkY
         FGxu6X4qI5G6nc7JFLJm12TR2A/HQ+9+rtQEFYCliGWv2H8hJs+pDEoN01YBGp0BqRFq
         fU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728410108; x=1729014908;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9Llx3JgjxdZ1E8VvxGopT4ijmhNNKcWyl2diOpaG/E=;
        b=jL69duKcxDaYtFa5q7/xuDQ4ICYK1FBDvCTrCIGvOfV419j8k5AN2LRHR9j3VHvz++
         gbqXyYRLfPs/Gvev9AJLa56hAqhUduw4nL94VphKxgMXhDIBb6MeJO8yfIJNJCagIUoG
         D052QeW1OG9bdPJDdTM78aic9YT/7kLpuNBPcO9AGOqqQfSQ7SmAcPp8dvfPKkMSDa4P
         Zic0Ucap78HoAd1qTLhGKRNFz0tdnC5+by3CN7eDx4/k5cYw47FBYPZfUItifk2NWEcw
         2vk5lVZfWsqID1NH/61mV1O3+9dDU/KGVn6aitdq7U5ZczuDBZCJX2iC7IQ/imXzpfnb
         CGJw==
X-Gm-Message-State: AOJu0YwPPNTIThkbMBTLckDamSWIiP6GBoY3qH98Vt6qMxxMoYE+zOkr
	Wg/huaNjUwTGsxo5V3JtnlrkZM8vUnMbMB6xRx1Te73PPoR58Sum
X-Google-Smtp-Source: AGHT+IFrNvPHqmXges6Z5ciaB2kspbjVoQxshzoDSQNllpHgEgAeQoiK4yywR1ZdAO9pV2E6Ayiy7Q==
X-Received: by 2002:a05:6a00:3e1f:b0:71d:fbff:a4b6 with SMTP id d2e1a72fcca58-71dfbffa5a1mr16614080b3a.28.1728410108136;
        Tue, 08 Oct 2024 10:55:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d7d439sm6365504b3a.213.2024.10.08.10.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 10:55:07 -0700 (PDT)
Message-ID: <f7bbebca-4da4-4270-ba6c-659a4c40b430@gmail.com>
Date: Tue, 8 Oct 2024 10:55:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/386] 6.6.55-rc1 review
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Vegard Nossum <vegard.nossum@oracle.com>,
 Darren Kenny <darren.kenny@oracle.com>
References: <20241008115629.309157387@linuxfoundation.org>
 <894e27c0-c1e8-476d-ae16-11ab65853d1f@oracle.com>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <894e27c0-c1e8-476d-ae16-11ab65853d1f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/8/24 07:58, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 08/10/24 17:34, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.6.55 release.
>> There are 386 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
>> Anything received after that time might be too late.
>>
> ...
> 
> 
>> Ian Rogers <irogers@google.com>
>>      perf callchain: Fix stitch LBR memory leaks
>>
> 
> This patch is causing build failures for tools/perf/

Yes, same here.

> 
> util/machine.c: In function 'save_lbr_cursor_node':
> util/machine.c:2540:9: error: implicit declaration of function 
> 'map_symbol__exit'; did you mean 'symbol__exit'? [-Werror=implicit- 
> function-declaration]
>   2540 |         map_symbol__exit(&lbr_stitch->prev_lbr_cursor[idx].ms);
>        |         ^~~~~~~~~~~~~~~~
>        |         symbol__exit
> ...
> 
> util/thread.c: In function 'thread__free_stitch_list':
> util/thread.c:481:17: error: implicit declaration of function 
> 'map_symbol__exit'; did you mean 'symbol__exit'? [-Werror=implicit- 
> function-declaration]
>    481 |                 map_symbol__exit(&pos->cursor.ms);
>        |                 ^~~~~~~~~~~~~~~~
>        |                 symbol__exit
> 
> 
> 
> Thanks,
> Harshit


-- 
Florian
