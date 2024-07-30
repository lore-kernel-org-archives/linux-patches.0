Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7091E36126
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 23:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722381514; cv=none; b=VeQWnIbmRXZl7jY5GwAA7tqxjs/OyjlDYv766TPa8o9L9GWT3OaGcq9oE6RYCmm1kYHCFjcculH0FjNcneYJ3P5oDUzCTFwCyZ1VkZrZgoFUU+OzBIOqsHtsvFYNHlOYnDLugPadEySCFQP39H90eI56XOh3blPVXDrZluN/uV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722381514; c=relaxed/simple;
	bh=BHpnOjHsaw3hGBR29qRjNfSHbrZWROLb8eFVAKfMx6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rkWiRSLPfXs2TR9ibGw8lyOTgA84tzJEOk0hOz7R/JDsgnReBaqMxztMTjmtTvzSQB6PkmH5kRTJRhhsEyws2ZO53KYdki3GxQKUWruIzqVWpzuZMC8mkIZqc+G/yPG8VCDVRfGmGeohCjDLyFTkc0gA8SOQg7amFT6ygVueJ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBYNHFFv; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBYNHFFv"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-812796ac793so26894739f.3
        for <patches@lists.linux.dev>; Tue, 30 Jul 2024 16:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722381511; x=1722986311; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pfnz1Mhod0xB0jg/7UultOZotMIwcjsz34ryNq1e+NQ=;
        b=ZBYNHFFvggJLyEOyzQQ8Fr2liMQ9I8fcF3TQgU/tOOeXXEL19u38a4KQE6na1Ebgim
         6rzL9G4HR04U6nsiTUj3qT6m6+RiA+NGzHIYKup+6xL2jiyatDR41dD1ZBr/GhMp7xdA
         KlJl4IrAGnGCoiB61gIUw0HHtJXhotjZ2UVzM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722381511; x=1722986311;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pfnz1Mhod0xB0jg/7UultOZotMIwcjsz34ryNq1e+NQ=;
        b=S5bzJnd6eP2OMpFPfunzDrdFo0PdB8c9Fig93iyG71Hxi3v5AADgaeeO4aZvPXKgKc
         Wy03UoDMv9+FWhrc8lKx2o/Oo1CQ4mamNWDvS8wwOYGz1mBB8p43UqOpee/KtYxf/rNq
         TjYajhhNJPJNJLF5VqWxespwf9gOsFQrabvJBDzDn3KsuZByoyq2WqzchtdIjK5jkzl2
         uNGcpN9thxK7ty0CNAvGwhm2yA2+vZRMnbHzsyX2amMNS4nqU2nsKbf7YWwM0Zg4UxY9
         5BtqwzvL+gDPgyRozEzA+WxIAjB9aXIRS3QCqDEVaXgi5wOrkFFFkvbFBAat/DtjTRkD
         /eFw==
X-Gm-Message-State: AOJu0YxIPZGs8qUNye6n6RKNADy3Kn4nvPyKcxpJC6bt4QLO2WYafzFN
	zNTmdDyKsObeNlid/IOulvPBX7wjd6PBScPsPlFTqCkm2TchpKz6Hq0LwqrFYMw=
X-Google-Smtp-Source: AGHT+IFPYVEDGwXLv3ojVCIG4y5kw975DDdJ1Ftcw9CCAG+4ZNh4B/SMv9IBFcQwK8WwRKd2Y5lOAA==
X-Received: by 2002:a5e:c116:0:b0:81f:9219:4494 with SMTP id ca18e2360f4ac-81f92194514mr840008839f.2.1722381511530;
        Tue, 30 Jul 2024 16:18:31 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c29fc5c850sm2935042173.167.2024.07.30.16.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 16:18:31 -0700 (PDT)
Message-ID: <061886f7-c5ec-419b-8505-b57638c5cf31@linuxfoundation.org>
Date: Tue, 30 Jul 2024 17:18:30 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 09:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.103-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and failed to boot on my test system. Panic during
boot. I will work on finding the problem commit.

thanks,
-- Shuah

