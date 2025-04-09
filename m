Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE601F873E
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 19:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744227721; cv=none; b=bA/YIxfckTczDIOLDBI9+hLfy+4hFAq/ORHHuzzxLlr5vUEhtB2FmrRD3tdLqyVDmizKGFtOveJRv05tWbUqW9lgIZreory/cauH4ZO9ZzvSLtNMfzNZfFpVbFEE6zixnV16+wsvEGaeZw5QBf4HOCo54amiGNBiMGEPd3+PrpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744227721; c=relaxed/simple;
	bh=U3oFCDrTfr+26pFGgVpn0F5xTOVdc1NeecTSuKMlKT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h/+f5MHIY5jqZi2XZ4kEkpVd6Yd3zj6ug3RLoFv8Whl/yhgY3ejRdup2CfivJggLiPFrVxXutq5dT65jQIOyfyOnJjDXIDkTwznrYm/PpvFPvFIjvip9kMVFLqSa6kf6nIybFcYQR6kJ2DGTucK1/TulbIg7nY32GHa1vjJyadQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oyv2Iyvc; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oyv2Iyvc"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-601ebdf02daso60170eaf.0
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 12:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744227718; x=1744832518; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4tUr7qMtRXz+rUF28WLYPNBW5AEre51JthRLN/q5ecs=;
        b=Oyv2Iyvc6iAxoNn5I3dwZ6DHwlUuFf9jgYfhuZjM2vz65+tBzUgV6x3opREdS2jFU/
         1M5hKFYCWBgnTVew3p4dGZa92NMuw0jDZxRXcE+9WLKZ+JXGToWIH2KfWSaePc+NFTXV
         xkuo3+/w4jSGR30wD3GyRT7plDP0zO8PrL8pHFm2YJS1AuvJpMVCSXXcjxqJHrHstkzS
         /+j8IlKZa/7HYkU4g0FqloXAukmwH/SjOPdbyyeRtp6bJ65BICsVWwBnMb8LElY72NII
         G2KhEGLBqhY8R6S491Hcp43jXiOXE0oktB2fy/v5RnA8D4u0jVvNjeUOzmH9r6pKhqod
         l6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744227718; x=1744832518;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tUr7qMtRXz+rUF28WLYPNBW5AEre51JthRLN/q5ecs=;
        b=q2E1lo5DRaZpcPurgZ9nr+KouVWLn8CYhOd81YgJo9eZ5U97XmMfQAK3F50hchmpH/
         Y6ox/KHU7OyFvHXytsh34adBHLoZbzOdCaylhClu9AtLqbNAMz8qvV3AAw+rawkiiTqN
         zRUbT7IhVpHbDWHUZP2VV4esAZ222rBjsBQTIta+jnU8jsTJx0ByUzjs0fTtFpC9R7dn
         Eja4NaBL36sacwH+sUrGw1fN5MdWDnAmk6CBxS/RkmSA4dmuNvq1gfKn8ojG92Y/jTd/
         4EwDoXm4IOLJtZpEsQiuztqsmKeSHtQaCYOxvOAo2BbAkuDx4tbMGWoQflVZrTHY6Oxf
         4HTg==
X-Gm-Message-State: AOJu0YxMbG5b89l2vCHyA5uy+KPC2BWHyyeSXOqXCjP74cEYMZ0t3yCG
	e7CR2C7VJ3KW3MwAQWyhzW9lhM8Hudtij7HVyuHC+pNVR17c6kh/
X-Gm-Gg: ASbGncsT1M9vHSU6Z+mKQ9tBBaCe9gG8jQ0N6hQm+ySlvpoQQrJ+4PMBfJ+By3sc8jE
	4phQH7jWTF0d994fC9UR2DvD0yOlT7bOItuCCOvl02p9RClu38b029ypIod2RK8HqYx1DZOAdtt
	ADln4HVXkl/u0WADctHv+1leKSzKyV9aclDivyKnCp2ANGTkOPOFittSOw4dns7QA5Ycay6G2gA
	F109xmF2hvJt9a3ND2yqDViQSSo87iJW6/5W07kmsMddXkMeEEidrAe/P+SsM/th79a4RIcsi2y
	LaaFavyfyh6sV+zqXKWi1veUxX1qQpU5Q29T7XbhnJYq95mBSf1LlkGIqxvuPoyM+6BS
X-Google-Smtp-Source: AGHT+IEHCrhFKEPNsBdOc3I2pzBKB+H6m2JHwv4fc6kRYP4wBEcTAD0FfYElixQKXGhRcqw0eVxitA==
X-Received: by 2002:a4a:e886:0:b0:603:f521:ff26 with SMTP id 006d021491bc7-60465edeabfmr22712eaf.1.1744227718414;
        Wed, 09 Apr 2025 12:41:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6045f5b29b3sm286608eaf.38.2025.04.09.12.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 12:41:57 -0700 (PDT)
Message-ID: <e55907f1-7c91-489a-a0fe-0814e13b1e94@gmail.com>
Date: Wed, 9 Apr 2025 12:41:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/281] 5.15.180-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250409115832.538646489@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250409115832.538646489@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/25 05:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.180 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.180-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
