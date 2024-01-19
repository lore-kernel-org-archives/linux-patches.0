Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3B3EC7
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 00:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705625067; cv=none; b=gIVIxBt2nUS7wJEQmJkLtzoXki77vTf+XYRKmaVaHdgBhlvuzm9jFmtI8pzAPHS0fMu+QxX85jSsB4uOz31Jo5Kz5VY5tLYU4owhKwpgJCGSmqlq8cpOpzkAU7dyQVvBTTOJmdm30615D2eAqBXxBcgXLXBRcHcsvFz7a4q+M4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705625067; c=relaxed/simple;
	bh=NhNSIFSj5aUXE+QTTjNv47GccG4WWL8n1fqMzGxB0Z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DHDWGl2Mkc+g3t1LHDCkeK/B6MQ8plWgd66lCmXAQfUMgE6JSpqQtZ1LBXA/szjE45AkFYuR5sL5Yv1kXtnJGDMqIPD0WaiI2ZlzsB4sU5K0nWpVlgjtM8/NNCE6sl3ott5BJ9Fqw1HiXJTRmZrovWk3zixhcH6Vjs/N4E+s4Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlxuXiM3; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlxuXiM3"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7bb5be6742fso3559139f.1
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 16:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1705625065; x=1706229865; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q4QJjs3CBTSn4kYRm7kePCBqPYpjZWflZ8aVDGne+Lc=;
        b=OlxuXiM39WxvMwTMJriI2wmD4iJp4ZCVWjnnVCR5BTDAh2m5+15uhKG8gHiI2kRfMO
         bBGjmm8EppH4l9HtkogjACJXEvsU0Yn6c6YQ6Otcf4LIczR6O2FLwkGBxb0SpZxTYH4I
         dJWES0prLZJO60VWELmhuY+pGxNAS4AtVPqIw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705625065; x=1706229865;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q4QJjs3CBTSn4kYRm7kePCBqPYpjZWflZ8aVDGne+Lc=;
        b=f5LFtD2BwXq4qeOq4NmU73Xwv6Q/dvjAMEco7YtTqXwC174TwVreCwy0p61IzgCqBy
         fqBzv1VjpV/LMyKpBwqK8QOSIZuwFbsSrqVTbRwAjbv5dX0q3GeW3qIXUGMpbzhpT/iT
         0ggZJF3Lfu/efIf3CnwLWAnW5KFzoZF+MD51KgUDrGywVmEecln/Jub9sSAaud7Xy4dR
         FEvj1el19Ow2lPI+691q/jecE6aVtlAt2vEvrSHVDfBmHI762O+cep02R955HAQUFAMF
         SUnYlalKvTnbhWKv6dWkCabJy5SjsQQkWnRuagzbxXb8CDax4cebs0rHzCAZl6EcSa0z
         akAg==
X-Gm-Message-State: AOJu0YzG8RAjyjC6UC5NDvrOO5UxpqqBb7Ne8L0pWUD58Q8jejol7LNH
	f9JUbeF8u9uY7htCEGY5G6hWekQK6Qb4Wxo3OQ6vcGHBAMoBYCd+UsngML8eu2A=
X-Google-Smtp-Source: AGHT+IEzKBDhU5ko5vWu4xZJmpYcfFyuo9g09ySkVHfAtQDtjkz4Xi73BJZ5kZmOang3z1mK3rWCLA==
X-Received: by 2002:a05:6602:255b:b0:7be:e080:6869 with SMTP id cg27-20020a056602255b00b007bee0806869mr1123197iob.1.1705625065102;
        Thu, 18 Jan 2024 16:44:25 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id l10-20020a056638144a00b0046d18e358b3sm1323950jad.63.2024.01.18.16.44.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 16:44:24 -0800 (PST)
Message-ID: <1c27da34-1134-42ae-b6c6-925e6e94e64f@linuxfoundation.org>
Date: Thu, 18 Jan 2024 17:44:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/100] 6.1.74-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/18/24 03:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.74 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.74-rc1.gz
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
