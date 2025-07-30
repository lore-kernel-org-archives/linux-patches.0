Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCBA21FF36
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 21:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753909223; cv=none; b=BWk1dL2dRgwa4F7Esg2go7t0i0lVDrC9hlgt5qjY6TEAzcRfHupqJdtryDlZFUegpz7AErke/6kfPSjxFL3oZhS6JwX25dYp9D9lLoQqK289tajWhpPJIH1EfWdf/hSBzkwwqPx0WcqmILw3DNtTiHwiL6wvDj+A5s01ye7APUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753909223; c=relaxed/simple;
	bh=qYO9XYMd9Ess2LLFsyadSHoQze0pFR9pSR+4q7JxSB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Goyhn1IuBdk9ndVaVyrsrhHGcmTK/qj83mtIYVg76hP8KtF+nb4uFwF+wDocPfsitcvwX+jPK3OuzB/YSBQZtE3zI/h0s5qV5HCRB1pJyYEwoyM08v9FrzacCGLjHgkICbbrt/1n1zN24NubNKiFjfN1ic1VoXh45CBE+t5V5gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgBwTBA1; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgBwTBA1"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3e3f449fa6fso1427285ab.3
        for <patches@lists.linux.dev>; Wed, 30 Jul 2025 14:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1753909219; x=1754514019; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6nTYoBlbWe2hufH9UN/C4sSrgwEPP02z/hVZuVmtCWI=;
        b=RgBwTBA1TMoJY7bC4357/bNWRFrz0Nw8/6rY7/J/nNDPs22DQpU6FfT0dpaZpYcl59
         rUcN8bvOMOGinGmK7dyaOpF7P5Lg6LibGaGI+Oxfx3TvHa+gzeAPJ+jUvEN/5Ibh2gsA
         xKZiQErlzuL1tkyVbs4V9qRBryHNXwgwHxkBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753909219; x=1754514019;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nTYoBlbWe2hufH9UN/C4sSrgwEPP02z/hVZuVmtCWI=;
        b=OI/C59rB50rrRc8+F4AuAPllrpo+fxFkYNXSwEXU0lMBppI31UDycH/CiDYMWzm6pA
         IImXUkMnX8kdNDMepJn1IoMxpaFi0gaHYTuWeHEK/7HptUmkqG1ODtzenU5toYdmsZpR
         2AT1RpOVUJ5edvrKDqN9uURDULUQ5j3EDohZI7wpJRefU1Dl3wm9Tg+V2CY1R5mGIs+a
         xfdJSbCZ/nZclQ4IrAd8dXO5Q7CHerjLwo5McbPk2XAZj9kyiSjJxLmJj+ez6MJChtxL
         8k2ym15HHv4yjJM9IbTcQevTODAyvkRe60d5mE4X5lRKOr53y49OEjvPbTcrdjLFU/tr
         tQpA==
X-Gm-Message-State: AOJu0Yw1W9E+2NgvbYXn0CoxEwOlrXZUWQnVTDmY4WezaKoVVXVE3mc2
	yyR457nZLqia+MXEAgGR4tlBzYUx6P74xuT9DPZmDIgGXKi+XnAKqEtAPQ2lHM9xBMo=
X-Gm-Gg: ASbGncvb4h2EIsgpC3MnhjQuKcG+74t2PmkGNVysBD0S1AjuqJ/CgOzcZ/R17cAFPSw
	Q1XGzaiyxzmJkT2ivMSffykfGbh8VlldjkzxCT+rAWwa2CkLcZV+7CV0vmxX4DdNKXkwJFCoatn
	CAdJQPe0pXTyapqKmpFwi206r/kEhIViTvlefAYq8/rMuqow341iNa/c0nuNkDi9bvtmeF/PviT
	sOifK2b56icQwGpJHWV65Z+DPYzHAA39FSDtHkSTUpfLz/5L5j4ypSdOqjfDhx+1bFekJhwqzXL
	HsNBHFvQ1ttu1s4OinMl5wptNWDecfm3cE98burlC5zaO6uPs9/pVwYaMP9sl0FcCFMg6SDuXug
	EWA7HEkL+pJmnvwhcjgUHAVZvN3JdFkfbtw==
X-Google-Smtp-Source: AGHT+IGjPEbPegqBnEDpd/XcqciAKEnaO2geFGrPEn0TWYZQKwLtS8S00ByN+2MQJrm5bjkEbIXPWA==
X-Received: by 2002:a05:6e02:240a:b0:3e3:d50c:d657 with SMTP id e9e14a558f8ab-3e3f60b6207mr86671535ab.3.1753909219396;
        Wed, 30 Jul 2025 14:00:19 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50a55b19250sm59262173.5.2025.07.30.14.00.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 14:00:19 -0700 (PDT)
Message-ID: <ba33d960-df47-441f-8898-5253e685ed2d@linuxfoundation.org>
Date: Wed, 30 Jul 2025 15:00:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/76] 6.6.101-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/25 03:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.101 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.101-rc1.gz
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
