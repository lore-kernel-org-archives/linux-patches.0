Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609A2A23
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 00:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705625040; cv=none; b=osqoOWVUEJo4ZQwbR9JbfGCTmcZ0KxtoUtmXYZnZqbMpjFxDya9csKtvA/1qgDPg/nyK4a0WQXmO4n+RMB4ajqwie6yO4qH34WYuWprJuY3Vs4STUx970R4TzBsAsnDDJufg3PMTAS73VIV+f5Yw695qFdQvT0CIWBDepVZfm8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705625040; c=relaxed/simple;
	bh=iEOt26FHv1dAFpGXqs+FEKRSjCiULGc3fJ9ltubgUvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pSex2A/37Lgd06KUHHK9JTfquXdT/3m7SLnx4aMHmnwr2f0CurowhR8feIfRreSxXJ+m8QX7p5Avjtq85oayuZPgJyIXh7Jd3MFmpdbZYx7FdwGYL3WqCzMjxEXQgsqFIZvBOyq4Zov23vK7ZFJyZUubhw8SMTZL7CsK7WseYM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boN4cUed; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boN4cUed"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7bb5be6742fso3553639f.1
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 16:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1705625036; x=1706229836; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mqk1y/5vRcF2I/Xwt0pfdoXrpTt3gsfqcyccPyGpp3E=;
        b=boN4cUed9DT4K9qCwEcGy/YKOXrMmxpzURCHu+VdToRQ1wMsD4n9/f/RxHRmDDx9cv
         xy7yGetGk60tFmPad/yYRM1p3iK/JyMmKCYu9UG6u+3eCpcy8Q2FKBF3isMlNpMBdkjR
         6S55eIRzAupZRwj9lpTOdiJzpAecy++r7Nuh4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705625036; x=1706229836;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mqk1y/5vRcF2I/Xwt0pfdoXrpTt3gsfqcyccPyGpp3E=;
        b=CEasWFTm3Rh917TPTPvcMykrea/76RC7c4jwbjVb8cFIiw8mp++7GBUSJQEdzFvaly
         1SQoTRqb4YGzzcXcqpppgA+w/+wU87YqTUADCWUm/t9B5fkypY0VgaTJwTPMWbtDadPd
         lcGVW6QFRK+XUnRDoFGkeSvutRvRUttRYBjAIcXtLnkYJYudu/61ZgOrX27V0aZ9xrAG
         0hyR2+vDh/kTnyua01lDyeOId5Cz1ze0ZlCGeU3V28XoE81XH7bfNCQVJLMqigwUNdU0
         XRa3ZDMC1F2mosTC1uj9/XF5r7HZaPtlyFiYuXUuOSCpGk1QwCDgR6o6KDOSnGZptghF
         GnFA==
X-Gm-Message-State: AOJu0YwGkcqfhEbBGkrghISiP6BEDw7voGI91f0YLU+XpGf+L8kbAz10
	0pjIEesgM+dCrIwvSiisuR4J7RaUV67VruExREraDWuodq4rOqZx4eP8dpai4NY=
X-Google-Smtp-Source: AGHT+IHzM1Ap52QP7u8OfoImncqXOWPvCKiXEJEsJqEihmXKRNLtszw7jjYTegV/B8ONiQog1sV5vw==
X-Received: by 2002:a05:6602:255b:b0:7be:e080:6869 with SMTP id cg27-20020a056602255b00b007bee0806869mr1122277iob.1.1705625036599;
        Thu, 18 Jan 2024 16:43:56 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id l10-20020a056638144a00b0046d18e358b3sm1323950jad.63.2024.01.18.16.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 16:43:56 -0800 (PST)
Message-ID: <beb7c9b9-19a4-488c-98c6-1fe2d8172c5b@linuxfoundation.org>
Date: Thu, 18 Jan 2024 17:43:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/150] 6.6.13-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/18/24 03:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.13 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
