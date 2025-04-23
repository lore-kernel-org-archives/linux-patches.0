Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C57296147
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 21:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745442883; cv=none; b=mJjT84Wes0DP6cj8tk1g9aTqB+trxCwj7Kwbi4dHkkxXnOIFt0me8XTvDLM9aelPHFQj1OgbLuiA/44umMQAV7yNPsyLInfvMmm1BJpAC8Qbp8jXG79LzYf8sv+5FhEi8XTV8/CLAida4I/Rmqfrc8bbtsKNF+s+JESNVOQQ4fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745442883; c=relaxed/simple;
	bh=6tq9Ua/xdZaRB1yMj385Xjabj8eAWItkrC8osTxEbew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ole5VxQ/0abnIKf3z7lZKdaqxaUeo/Z4yHu2b7zWoFmzlkEpFR+ZIVKC89GFvEvZOJk2B+upGIQLMjb7+S66N5I6DSHgJtgeJBw21/VhkJtrc1e5IbeqxK6M07QAbyOHbDuw25ke33Im/5j18UUXWzCXxivfLC8RV+wVskF3pE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMRa5w37; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMRa5w37"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-85e46f5c50fso32466439f.3
        for <patches@lists.linux.dev>; Wed, 23 Apr 2025 14:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1745442881; x=1746047681; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nk82mK/oVbn/gatmlztXyHlLD3lRtbsVbG0sPLQKW/s=;
        b=MMRa5w37jpB9kyOS2PbxjiCMGreHQLOJdgjlI7bc/jCv6tCeI8b8veLgYPoYX2chpv
         mDwocfr2m3nFyr03XiB65m4USlbzmMWJ2iV8QhcTKWk0WvyM6tm5e/WVtoA9u/15UXXk
         W/m69EDh35z2ZO4Z6gLyVoh6fu3JUR6q0C+YY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745442881; x=1746047681;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nk82mK/oVbn/gatmlztXyHlLD3lRtbsVbG0sPLQKW/s=;
        b=vgnFOy7/HJ4R6Hf49wIH0QXfCyVeOHf8STzoqZpk8K14/8VZHwKWQXDobPxoB6m0u5
         Pwx8EbPYwmdLUXoPbRgJ29+bwGKb5e2gUWO8pKypu9ZdoJuxCwXWtAxx8CqH4fEaAarv
         0toCrrJ4pczNUp1f4C1PE/3AeMpmxDRL45dwoAJWekqdiA0MfD1ES8pWJ0lVF3SP74Oa
         ELjO5wFYNpf2WwUjg4WDnEUK8fZrWkdjrChFQ1enOd9piImGz7duMJhpYDWUpGKl3zZa
         14SRl8sbYVPn/vyLefIwd6OWjQTF62GlgQQ09TAsELIy1OI36PKWyDKdgSUhz9qwtc9Y
         UDeA==
X-Gm-Message-State: AOJu0YzhMNlPGls7fPhu06x8IDUrzi0WDuu9AtXC8tLLOodh0+MRNB4s
	AufbIClZumV6VnJdUecpGwSc/4pZFmWNkscKQUApnvzP1b9S2heW9Vd4YU4R1ek=
X-Gm-Gg: ASbGncsUlz3CcLxCzGrKsKNLl81SRHSgn3qTtOIwpceAcIaI7BcsSZAE06MjRquzAjc
	S6QLubr8hLCvLv9HOTE9Gm5HndEF7zLuQofABkG66u9+Eogt7TCrjO19uKT8YCavJwBW6C/wFfw
	6J3d16/fy4HI+p+sg7IJx3D2MZd4yaCQ5+fhQ9k1kXCBhgPkrd8ysP95zlXKPBGqPwagAkj3uqm
	i1/oM1JrhFPj95bTSfZ5WPi8zsKvGPHFTQdVA9ZdCZffAfBF3blKVx23LNKwAoG9Ha9QEUnu9aG
	Zu06nzHpYl6Eie20ZwXs5hYHSJjNN3DuaaB5tiK7oNvwLMKg1178U6LzmE0pAg==
X-Google-Smtp-Source: AGHT+IG0txJrMUkch3h4xwE3V6S68H8BHmpzfqRZMXfkUbFBJk8lpVf5BrXiDWrlVfZA3krODMl4QQ==
X-Received: by 2002:a05:6e02:1747:b0:3d8:2178:5c5e with SMTP id e9e14a558f8ab-3d93040976amr1529665ab.14.1745442880994;
        Wed, 23 Apr 2025 14:14:40 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d9276ac9easm5458045ab.69.2025.04.23.14.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 14:14:40 -0700 (PDT)
Message-ID: <942e0d37-53bb-4d7d-accc-9cb2b5149d95@linuxfoundation.org>
Date: Wed, 23 Apr 2025 15:14:39 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/223] 6.12.25-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/25 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.25 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.25-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
