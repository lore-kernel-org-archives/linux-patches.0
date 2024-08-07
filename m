Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FFB1487C5
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 21:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723066802; cv=none; b=sW76XvlE8VAteq04vuakucE+mWEn+4DdnlBOewe9m/vi8tW8AShBcPWVzurel0Wi6eV8L7pbMaejDEggH7a6jBGvUMwDSutWogt0peByFJFKu0zFMi6DU2Q0gRKguw8zFWvaWAgV7KcIi3LudKsRTzt51rgTYfw24/ThxxaYadc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723066802; c=relaxed/simple;
	bh=GDAclEoOcEOWqSuGrmy+DM2Tp6zu1/nfi5udLfWAGYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=byaURkgS7XxJOKEZndG2rnFUEKgt9JtScsTiDsHNMV+M+b1pjuiF6NUlHxu5yMU2PukLm+x/zEx5bNUjchvERnBKc2ZUhDUU9Hg/AM/iGd8vorM8BOUKmgA7BsxGSMJq1b4DaxRhI2JMsu3qyksAwo3Qy2QBbCUXzla++tac1r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxPtBRMt; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxPtBRMt"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-81f86cebca3so371239f.2
        for <patches@lists.linux.dev>; Wed, 07 Aug 2024 14:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1723066800; x=1723671600; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2+yt4eOqI9n8STlMoFI1L5lm8J44U6xP2uia/Ec695s=;
        b=dxPtBRMtaJI0pvtX0EhuwIXMSuzfEeSZodwJys6PD0NMUuYqR3XqBRMJEoY0hEOy6Z
         bH5czXoCQjjz8taRNAeAPDkJpM9QrlIrjpJiz/eoPTaARW72F0YybTrdEkqKXwdlwDlX
         MyE/GL8MDgwRtz8ikXGuSa4QMOJ44ubFwzf5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723066800; x=1723671600;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2+yt4eOqI9n8STlMoFI1L5lm8J44U6xP2uia/Ec695s=;
        b=gNHjf7l9dQ8N01eHDzUzYbmh4WzMsQtyePfLI6DSvQtDyG31y5Gl564yuWGQF+8gxW
         gCFeSkFpjSVNOZCR8bmgjmMfJCDDm6NI1GWULU93OTRnD1LNdW85v7dhqEI6+ek9vuhr
         jxSeD5Xykrrq6EN6s/XMLb3XJ3Vf+dCS/QXRrYRoEBvEn4mm6Z4Y7cvmrmzvIxX+LWL/
         UGGSxPbhHmUS89wE4RmeTczbL+UcU0bfy2+0OOGfsak29jEGvn3e1JjiIg4xaZAA2HPX
         2460juWCjR1Xpq0kWJ16W/tGp185DV2PJHdIQPvquD1vIwMYPrRD82XbcuVIbBY1oRKa
         rc4w==
X-Gm-Message-State: AOJu0YwBD+on2TR15bpeCJrjj2CDkC1R5I7wM+f2KaPNXfk8zahIY0wJ
	I2YhjnYtboi9fJQDO6xcMv3U0oOgT8DdDdyozYUMK8m1ENHFCzKUxAfGRqvBap8=
X-Google-Smtp-Source: AGHT+IFVLcmbz9Srv9EE1tgNm9JYUFhDPEqrp8BTfDtkNgf7sBQXucPNQavpPInt+I5wDtcoPYzQqw==
X-Received: by 2002:a5d:8559:0:b0:81f:8cd4:2015 with SMTP id ca18e2360f4ac-82253826ac3mr5374039f.2.1723066799915;
        Wed, 07 Aug 2024 14:39:59 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c8d69a6ea8sm2984779173.54.2024.08.07.14.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Aug 2024 14:39:59 -0700 (PDT)
Message-ID: <6ebacbf5-2f86-4861-bd15-478e156c9948@linuxfoundation.org>
Date: Wed, 7 Aug 2024 15:39:58 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/24 08:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.104 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Aug 2024 15:00:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
