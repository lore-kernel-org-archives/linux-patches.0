Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3722749CA
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 22:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760134848; cv=none; b=XXl2SkQq0oWCFJD+uiJ93XBqWsiOIy7t9U/9O3djZ6Xns/ip6TizJy/8b2sThdYWmw8FZvnp4OKxCY8RexaUZ3BU6P0KPn27wodB0SPRque6pUiemrJr/rUoCG2XcV6vUcpJUZ7VATmrXWIgCxDmHJCBDy2tDlAcuAJhTuT7Uec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760134848; c=relaxed/simple;
	bh=cFf5WMYj7i8FlQb17nvjOopoXo8xhjRrXfWeuIY4meg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LHL2HALMupMXixriQaw0J4Q886E02DUCkkFTXQNiaWVbGPDTgtWPLFwW1arTqOaVhv/uODVU8J+Fg36yWQReFiNtIy5hoCBYcD2np6ngdGGbH7iOWshRjrc0cyFRFHv46DOeXg+KshpGpQ7y+++RUE/T9aV1TYoP0aYtP6Gaozs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuYcSg1G; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuYcSg1G"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-42594fb2fe9so6538845ab.3
        for <patches@lists.linux.dev>; Fri, 10 Oct 2025 15:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760134846; x=1760739646; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mcgyS5h12h/YMXurt2BySXwQEIYv+y3F4YEj1VF0AY8=;
        b=FuYcSg1GXLJzpfMITL81A9czEu1d0WU8IgkdGeZ9naLqMBpq8fcdhmwY1U7O/VK12I
         QTHymeOd9EkHv3VSvZeAbf2IMBm1R+4YJbqKaY+xHLL3E0QZSLs8zzdOdu0gqqK8vyka
         dN3eZzxOEdq8/FG21HQt9zxSj+K3vaeQDmXEQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760134846; x=1760739646;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mcgyS5h12h/YMXurt2BySXwQEIYv+y3F4YEj1VF0AY8=;
        b=rrZ8elDoXmPPpAag86yz9XU8j3deVOtQ2s3NgVbGwNji+2l8vU579Ziv9DK6jkYJzF
         TZlpFTRCk7TdtAp1GxwzWz0RetgaCFeRuHJwTR+biKZn4X/ULhSCqDnlPWCZ6piuXfio
         TZDlFvamKu1B1+QEZ6YY1/fY4twCVG2QO7MuL0AWBFYb84SxqN4KENQAIZWGIKh6NzNL
         Vui4LJFCLdC/j/dj0+lkb9jsRXum7jmH2072lzIq0/SizgSKQcYIsd+G1Oi+CmlLcNNX
         uySt10iXTaiQu1mq8CBarAKrot5t9BGw1zaUKuDZoEFs0oxf5ND6NpBAch/+W5MCYlB6
         oyMQ==
X-Gm-Message-State: AOJu0YwLO6lGDjsYCfrs668+GaDAO8s0auZ9aBMbuQ0c0v+ASakLGHpB
	vk9Bn59mheFTcaz2YN/510VNSQXWJNNk5IA115wIrBsTazVIgmIrbNTMBDi+3HaES8Q=
X-Gm-Gg: ASbGncuICbeoHOVEEYEwFTg05WA2AhM0WeFwmQpiH8ETU7j5dwdeowqctr2So1Ef7VQ
	ap3Im1NP/BN/+BTEvrZc51V06rlJWtUTaReZK3FbnZPUux/5O7CUET6bqnutkDZvPWvp4ngnSyS
	eNGLQJqXX6VQmE8Um+lmLQqN98OUe2t3ae5XE7PIJbiHoSaxb/oF2BBh3PZkpqahY/PI5WFvAnk
	xjK/0eg1NVkRiajY1c+8+sKAzEU23sVVY2HqdvhU2JIE2HpgS8huxmcqWh+VhmxenUjpxwxkpmM
	KReqBXlHVmvy6KI6h2A0uUsyqa2IxNwQw3lNI9HufnsZckWnmHcTw17AnCUkwWoXu5zRmrsfsGx
	ousBHPOTXh35SOiV4BlA5rcdMerpKRJ3+1FRx13pb6domA6DQv3otag==
X-Google-Smtp-Source: AGHT+IEzkaLyZxfVHWfPQPq+ejARtvPQr645Z5Tu8T35RonlMZrPGBKctzylzQITvc64Ns8COdYcqw==
X-Received: by 2002:a92:c248:0:b0:42f:9353:c7bc with SMTP id e9e14a558f8ab-42f9353c88dmr107126965ab.6.1760134845664;
        Fri, 10 Oct 2025 15:20:45 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-58f6c49553esm1299727173.15.2025.10.10.15.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 15:20:45 -0700 (PDT)
Message-ID: <10eb6d94-5655-4e8f-9b2b-728d14e91e7d@linuxfoundation.org>
Date: Fri, 10 Oct 2025 16:20:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 00/41] 6.16.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/25 07:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
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
