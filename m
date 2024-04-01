Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D5356B88
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 23:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712013719; cv=none; b=U1A9RTM11Hew37hyNvKqJdsE/VZqPBIagkWRfQPlOW2M1wad7v9o3L1KaOfAtyJ3QNFOyXM4xOUGefgyyE7lYhqfkp31lAH6ESM24/Uf88ATHNu2QJD6INy9K2zPvf+f7brBU1fMeB0uF8QB7ZEXBTvzbefg2dsNoTTH/ETWC4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712013719; c=relaxed/simple;
	bh=8MycgY6BBfBwIqPrlKKu8i5qHFblaOltdcEb722PSF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cn9RvOBVK03bzckGG/GdxPzpcn7qLplxbCcHW9TqN+/URDgybDkOI4gUbqwCjlDFQHPcfCTMumvva7vqAWQlo9rMOWK4TljYA+0/bWrmHJIpghhyjqGv3CbU8j4u1E8NN21lNxkFqb40zQOx40VKUriL4SZgMB9U7UYYnanX3AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvY+6dVN; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvY+6dVN"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7c8e4c0412dso27900639f.1
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 16:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712013717; x=1712618517; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sCZR9iH38Kb9dRhiV0AiJEI7O/X7Yfb+ffKd0ZTHNVo=;
        b=LvY+6dVNj20oMpRzpcWxjEq2/UjvxjJddAKxLMkpHGSOvhHtQg7R4c298Jn9fj8Isv
         nsNVKWrBRNiSbexqb2/KXBuBX8x9lAI+x/OW8Rsf9hunpRRcTcS7Jp8XEoO161r/sn93
         Ih78H+nXrSFOoCbyadwfnYtyaDj/60axC6NEE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712013717; x=1712618517;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sCZR9iH38Kb9dRhiV0AiJEI7O/X7Yfb+ffKd0ZTHNVo=;
        b=KJc7qCyQxOJfKllgk1JD9I7kdXG2wQy2umV145yV7r82YzQc+xRnJ6UkE4jiuGVrNg
         EM4FePDjvDi10kExQnPoX098v76v4e8F4kq/MyS8jj0qar6e7kzNcv3eKTSbbNfW4BHz
         9pGoODO3CfukGPtPPxkNVhVCqoLSPxjR79uW2TRGN12gw4q/Hp0Ki5r8R6cj6OP6Hfbh
         LMEtgvF4LXyWYIJJxtyfAfuk71La6M5o+dZhiGtDuu/MjsydRoFS6UR1B5klY/0iG3IF
         1iu4rOBzXGdn4c2MKSyWrCtetv501g9fW18/9rezPJIQzbmU6/YgNv9YJnT25WslOiLy
         ahJw==
X-Gm-Message-State: AOJu0YyTUzXFontsSvKdd0QMPuizHnJta+12bX8YHsJbQ+fz5mOfLECh
	214tfVg0DjYrHXw26ZqImsEe68IeDT0MplM+WCcvJ4eOCsdV94OZcCleKEHdSeg=
X-Google-Smtp-Source: AGHT+IF8ovOp27CLqqDuGxdKtbnjLY2RcArOFGplCXQfB5OLQmRKKrV46W3Xn7g9VqmCuWiC3TVymw==
X-Received: by 2002:a6b:5907:0:b0:7c8:d514:9555 with SMTP id n7-20020a6b5907000000b007c8d5149555mr10177279iob.1.1712013717443;
        Mon, 01 Apr 2024 16:21:57 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id r25-20020a056602235900b007d09c2f302asm2258679iot.39.2024.04.01.16.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 16:21:56 -0700 (PDT)
Message-ID: <8b497cb8-dbdb-4c9e-ac1b-a71c6c6fd939@linuxfoundation.org>
Date: Mon, 1 Apr 2024 17:21:55 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 000/399] 6.8.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/24 09:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.3 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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
