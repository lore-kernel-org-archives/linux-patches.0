Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D7920C028
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 16:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740068028; cv=none; b=C9sQ8W8XT+2qVT8PD5GA4cD8NxNErkL3Hv0amSmULIdh8Lmbbn+KqOcv0EuEgPRVES/RIbVIJJmcBNuiadpT5AVjhHTW90DtoeoN317n8YKLcOjdhlQuvkIzP+MM4r2dKXCNfEF8ATJAM//6wyUQKfdn8Q4gc+LZcDLZfCWw2vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740068028; c=relaxed/simple;
	bh=8bQ+eHlnlUU17DnVx6Tg/96s0TIWsZ8zu20MAi+7+NY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tJ3htzvdBXc507eginmQAy32dNPAtepoCPJRoijBaI/nw6YgRiNT8Wwc947jkgK6gd9RLPGas3y4XoUmt8ldWjtnvQOWE/CCngp6RSpRNwjXvR+72oP/JlFpGnFJx700s/2ZVufs4hfcZ1/PojOmQtQN1/aM4kyAdSu5GV9ciYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ps2Ypx+m; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ps2Ypx+m"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-855184b6473so79869139f.2
        for <patches@lists.linux.dev>; Thu, 20 Feb 2025 08:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1740068025; x=1740672825; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7/Fj7ezvz/oB9SkmTl6eJBk1br7rLRHa//ITeH4ze3g=;
        b=Ps2Ypx+mz34YO58gnff1r77JUi65yi+BnEUIQjxNJj3q/U4i7L0xoeVeQAW5ZPbKpQ
         RS9rKmy8FHy3mBeVllGCn0VOjhkTNXdF7hjhAlyQC2hF7irKvNRjoqmMRtmWqkbSUABk
         JVSU2KEPJjGmxsQyVI0ZPplBu/kOSsp2G9OAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740068025; x=1740672825;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7/Fj7ezvz/oB9SkmTl6eJBk1br7rLRHa//ITeH4ze3g=;
        b=loWZr51awssg3ZqpVX1qwfkBROYCQlOC3EHKcNCBoLmTw2PrOCCrOIKwoZwH+GYBtp
         wJTtUUdBppkzlcDcPiQkuoRQwaKhJV5+VyLsBU63k5H7/TCyikDGaq6zrIhTclDz5lrY
         Mul+NpRS2bNJhCUzuVLAluTvwyfyaYteO/dpqpON9eofAaOkpTg8xXaZWXTldW+o8hQI
         J7vEgE4v/IdQORWO1/+GYweR/oxwN6vKV1PT2N/nXT/pb6Uo51u0cq0C2jSjZaev9M65
         jiE/ENNHys1+j6EHWvpP0Bq8wu2n0E1+N/1N/C99IGdoRFcCLeiT7quvSoqw+2Ebqsiv
         166Q==
X-Gm-Message-State: AOJu0YyidJNcJLgpc71dYfao6Lslz5hChE1bM3pCYFzceJghyRv5QDg0
	ACA+657f/k9jFixCV6BnKNzYvpUP4IV9AylShTJ4ACktY8fs8gqRcS/Jcf6oDlc=
X-Gm-Gg: ASbGncsbWdE9vlGo1yNaznQwVX2DemyMmBErAkk56h/oUVLVmwrm79fQoqePE3+jqlc
	OptXRTd9CNRjK8bIZd7y3Hnio/F20og8BPj2EJFf9/muUJiOPTK9AULLUXxwE5a7m5W6CFXEvL2
	6OX/HQdd2daBzUjDHUtgJHAfjP54l0E2bXSuCl2BczrtX4A4fcWvAHcPnEL5ZcZmZXCA/ta+A+c
	cYF5ddJ72lC4wwWjLCokkaemQ59YTATpYA6nAjapR/YeRJVfhCUFl8egdnhKN8ypNRQX3bNP6zO
	jg3foEaJ7bPXJ55OIjqBnL77Pw==
X-Google-Smtp-Source: AGHT+IGcSeYu2MQaV5yGR45eedGFuM3Cc5su9wfHeFkMoBkw+wHJEoPeb8gbQCzXu3GfMbmvhR9FQQ==
X-Received: by 2002:a05:6e02:1849:b0:3ce:8ed9:ca94 with SMTP id e9e14a558f8ab-3d2c25deed3mr30899665ab.14.1740068025107;
        Thu, 20 Feb 2025 08:13:45 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eeb9359772sm966464173.60.2025.02.20.08.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 08:13:44 -0800 (PST)
Message-ID: <2861e7f2-1f53-4107-8386-e8268d3a2cfd@linuxfoundation.org>
Date: Thu, 20 Feb 2025 09:13:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/25 01:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 230 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.16-rc1.gz
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
