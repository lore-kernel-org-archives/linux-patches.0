Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23867179A3
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 02:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730946407; cv=none; b=heD38O88PRnURW1jJzGen6lfBw5me86OGHMQKzRMv/JUrqWmym304xzI48dg4E5wgvzPG3Ic8ZAgoG6HLi8o9wTwHQ6fpYO7SZHBlI7cZ0vDYd01ZxkU51573SO5osbIWu6zYQVfP7hM+swhAMdrv5IYGi/0Xq7YNNIhCZh0UZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730946407; c=relaxed/simple;
	bh=cJpKnGUFX+C25uYwW5TZdZx0NvQknnN0YhJKq8SGgUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RH6ktDGLfc0QGdEwrURCm8FwWRVN7u4/Y0MVQW+xyUruphqW6FlRdMQhmUZfFktfmYgvu8w+AzYeOc4a6Cn4658cpqHKC+k8z+RgSwh1Vu0rhRCrj7b2hVzdaQpjeCC5ei9Zk8W12HbtyF0V3KHAiZKiN3Wb+5BuGdUJio2BVAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdYcYFtr; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdYcYFtr"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a6e960fa2dso1139995ab.0
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 18:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1730946404; x=1731551204; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fsadpb/yTYe5Ho6eI38Uu8IKjOHgtGbPDaakrnLV2qs=;
        b=PdYcYFtrwfYomnXqKsZdP+qn2eT46hmQ4o9itzk9+hl+AX4Bq9sAteSdxhMNLs8BrY
         yBJ1HTx++Bv9fXVoo2mc+9co1zHRcZBK0FSpDvy8uWOVWartcx0fRF3K8pWKApX0tIjP
         QNz4uiQDUJJlh/F7b5+N4ady0ZVXMw3J795D8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730946404; x=1731551204;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fsadpb/yTYe5Ho6eI38Uu8IKjOHgtGbPDaakrnLV2qs=;
        b=jFJpKOOJeggrDvzDj4LMVKdz4y89BYMS5hKVNJyrE12PytCO8BnqGMTxs1trMWS0g5
         Ww9gYmZ4NEXdlDA9LerfLEl34w1xdNv7nt/gkrUGXQl1S/9C7vu6AcuLNASXjfLHJjV3
         SW544zIDk5lExoBd60zHrlphzYLMWiUdYSHcBeEDMdDv4KjncPCP1pRAyNjXs3kdMko5
         p9u4clpM0Aa9mL5UbvEd38ZhQ6FlNrIumid7hInpklE8EPgextvdmRS5k0THQqoQRdbW
         L8FVr8LQNLWaL1HM9koQmSg1iDdVrUi07mNivSmuXuLgGopiIKf6CyzLlJSu3IrubiDJ
         o6lQ==
X-Gm-Message-State: AOJu0YwQpYyknNLfaWgGX04LsyZBlUOo0GF0ATxBUroKNqTFpbg4+JDN
	ZczdOy4zQaLt4tBvyj4tKXtebzCkom7fnKdMXz1SAFfy2zSV2JzU/GjkqHWsFCQ=
X-Google-Smtp-Source: AGHT+IHNpB4MmvcSraJtYl8rbwJori6zmReEqGUf6w1IcSKoGYmZTjaRiv9WOGWUPCv7aothCGkPhQ==
X-Received: by 2002:a05:6e02:17cb:b0:3a6:ae3d:920e with SMTP id e9e14a558f8ab-3a6b02cf8famr249558485ab.13.1730946404158;
        Wed, 06 Nov 2024 18:26:44 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6eacbed1bsm697315ab.35.2024.11.06.18.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 18:26:43 -0800 (PST)
Message-ID: <26da61ff-524e-40c7-80ef-49c6323c629b@linuxfoundation.org>
Date: Wed, 6 Nov 2024 19:26:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/245] 6.11.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 05:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.7 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
>

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
