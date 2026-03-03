Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AC02FF641
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 05:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772514897; cv=none; b=nOwimRiTUL1qbtG0o620qiNklwLmakr6wHTvI2K2eNU6jFAuwKm7DZiP/DyHDNFsljFNiTLrceIc1TJ8Q/plyy3/zhyWkQLAsOy5e1+daNaG6+G3Oo/9peNW/ojZUK1TtbxKD26525OMDKWqzk7jKJs+2sj2kDTlLZkrQHqE9IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772514897; c=relaxed/simple;
	bh=vk9qZCYAhn6+MzhJrnJMYcWMNS2Q3wjEbZOhACThAOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g4FSar0ya6VU38x+McbrHTUklTKsFvG7Q8S+YxE4EjVgBiLaoj8SpblI+a0nP6VN3SSwS/bgTxhz97Hsl/n1VTbpPk8JUKBELd3QJBvo3Q73vkMjEf6umfyg7XODyOVTcTocqqH7aCCTkVqyMA97a4j/2sgTZkXZpetKBhHCStU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lcgyBb87; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lcgyBb87"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2ba9c484e5eso4899578eec.1
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 21:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772514896; x=1773119696; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gAXxhZD66BOd5+I9IRvOirVw8kWuRRHbq9SiuFrJiWQ=;
        b=lcgyBb872so4CBVE3lqeJooyu/a4D2sOjqVsTJPKRG7Pm5H8/ZzOXW2cYopaIkTxin
         9utfjEzuNYL+BO1ZETF3O2IWEE/b/S3dzDr9o7vhrxSAMI2sFYD1ZvdScoEJwmQkryPh
         J5IS+RWmsRWIH5rvDCgkAOnpEyF4eXo7mfNw7tE9jIV6wq6zX5eBjMPYivIlYzfrYWUS
         qwZQsSrbuyely3rAYp2vy1qFNXmhbNpDiYWHH0kql6CeJFuZExHyfABTerwTZUAMqpNw
         igAbpyyHqnSB+tYWO1iE5WZCMJq2kJckb/fGg0vBLwdQr1YLAS60LozcP2UTu6Gie+aC
         352Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772514896; x=1773119696;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gAXxhZD66BOd5+I9IRvOirVw8kWuRRHbq9SiuFrJiWQ=;
        b=u9yYoNiCJjmulWNMxP/wp7EM80l3aco0jEgDLQ9fPXKBnjg47rkNedlzKs3LBu1y5V
         Kw2jJZQG+sR2GHNPBStj07wIlpEaBBELRlGWFHACNhJ8CSMoHRsZt4bH8B1RHT9WQey1
         dOsHosB3Sf6vVUbDB+rWozM6LQ7T7t25wprCxrQBWh8KcEeDvy7jjA9kALWQJ4ETGH5D
         xmkld78r482hxTvbfsqeKRi1UliQh4BdtrdspPF+y31HaLTX/ECvx+85wPXquaDjXr4Z
         xMDaJwKQn+bV3pts05csfXh0zeBnW2uGc6M7SlkfS/d/Fsm88jRmflgZaFA4Y50LNWHX
         Kd8A==
X-Forwarded-Encrypted: i=1; AJvYcCXKYU7ylkF/o/BjTo6ym8g24EZ7uaUisObTspt02HJCqZZH9J6l7q+PP4T6XRhWFNtmRAgDMv4V@lists.linux.dev
X-Gm-Message-State: AOJu0YzejfADT66Z0wWYBXhiE8Mch+2w7bSDirIHRFqdr2USmYAmQZdy
	mqMl11cb3l0vl5cHuqctSFjDrC+1sfW9XuyxhT761iw5G1oqYo8V4VD/
X-Gm-Gg: ATEYQzwGOnrUliJxIAuVw1dygm0fyfWAnpZsSoyTejrg+qZ0npg9qIvjgnK/EBJ7q2v
	jDug0X7YqvEGAAe9KlROCqLObP91og+XMOeI6Yp5j5eKYCC/tMlTLXtSDZ8IFldR/zQRAmq/BuH
	Hcimsm1VVUHg9M73AauoqrlYDm1HUT8zThwH6ahrDwRQm/fwK/JkGuegtoYHpp+kenaYwDMepHn
	cdLwX7lr3wkrYbMin9+jmjFVksZ0vPo6nocXKBH6EWhwvlObpfoiPeCG2Ns6zRkC9cz/R47oRTZ
	QXbTqKxRnMVeRcsAcPvxqqboXgoIyU7XZTwN64skGIGmtdncjGM/d+T5b6CQtqFhZZ5aXk7TnJu
	RddiI8smodmogmZ/v8M8sW5YFEYClmAlq0XF206/UGt0KIvZZ4/HOdSYot/vXKfWLAXcYLC5byv
	SvchXEDLaaW6nsWcDjD2z7gvyt+KHmTk5OIYtgdJ4y/rIpZABhLS8RfrAPy6iXuxKRtauXCpMFX
	oc=
X-Received: by 2002:a05:7300:3213:b0:2b7:f809:9c31 with SMTP id 5a478bee46e88-2bde1e77f87mr5650134eec.34.1772514895549;
        Mon, 02 Mar 2026 21:14:55 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdd1f7e955sm12378567eec.32.2026.03.02.21.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 21:14:54 -0800 (PST)
Message-ID: <1ca6d1ef-7c2f-44c3-bbd3-a69ef2989e3e@gmail.com>
Date: Mon, 2 Mar 2026 21:14:54 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260302160918.2520730-1-sashal@kernel.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/2026 8:09 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 956 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:04 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.12.y&id2=v6.12.74
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 
> -------------

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

