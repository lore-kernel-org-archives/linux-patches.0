Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE2738E129
	for <patches@lists.linux.dev>; Fri, 15 May 2026 20:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778876032; cv=none; b=VyXY+lGk1ipazyosFO8CTBIQU0W5LLgUUKCD6qvAy0r7q8jHexBQumuTs7qwqRTBTHvbFrBguyDEQI81WGXe6Su8jmTR/1zUddgyxpRjGZr8FLnc5u9aUv9WmXLLNmOAhLReOuVMeglAPFkBY4Y0pJ5vujkCNsTZANbhE1efplo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778876032; c=relaxed/simple;
	bh=qSLAYRFgcD8HemAM/3vpyq3v9PCVAzUa1f9ESlzdo8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mb3hJlAUzsU5TB9cEeldu6+HfYxWS2QBld/c0+lzqy8KOTiHgCZdqJlpir/Jfi1crrXwu0BKEL+LiG/AZ3ytNSXJUHjLx5+ns9gde88zx+5+2Yzky4o7nKjMtO5Bs6bIwoKGZqdMfZAOsH0QcQF4GkQraJqctKS1JmPcudfOoV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dyt777qY; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dyt777qY"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-910bb291688so39439885a.1
        for <patches@lists.linux.dev>; Fri, 15 May 2026 13:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778876030; x=1779480830; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1I27Gap61YWLp9iMgpMvGpKIyvaiXyPWsvjhQp/5f4Q=;
        b=dyt777qYtvzOlrFabqT4wcriAztR3i3MVMTqRFq55P63FniM99icZw1X/UBIKENxBR
         pz+xZ62BJ2iREdIFsOHdHl6+VWeWHwUC6UBEbxFE2U3n6B3kW6//2eJ+nL/DzjIHC7u5
         k0TeVllKCMZeWgA2HS5iUloy+Pi533tRBMYcDPaCKX/OmzlmTLiccaBe/hOI0UJs48ZG
         dJnMzH90qvToBVRXT0/NYKItVIRjnGpGln8NigkdbZyjAqPky1S4GOjWWDfmSkIlYczM
         GvzUiatoF08PfYmhg7qJbHZBwVl2Hc2J8pm80f9XFmpLh2R+OXbcmj6igT4qIa1ux1Mb
         lUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778876030; x=1779480830;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1I27Gap61YWLp9iMgpMvGpKIyvaiXyPWsvjhQp/5f4Q=;
        b=qAZgG6yRRF7jGMiNQgx+PqhccqdGvEER0ULIZfQ3KyS/b49Dypxe17Bg6rofgg5iE9
         msYWiiP0/0fN9yL3bxapytsRsulOJACSRWUI9DS6MkQ9KLAXX5huCLfUUCle6MD50mKe
         rVIy7mpMaaljOPUFnYGwqIq1QaZJqCO32+BJqtR8F1pjmIsVzDQWgsdr7f0yYFkXtu1H
         j2EnkPKxh+u1Su7N+r68fnH7IolndTI8vpVHcCpbOe0XZrNnhBBFlf/uIudWw8GELP2Q
         folhXf/uoctLlGYee3ciZITVGeEaxiBMSbywTuSx3rtOAF5cMDjDDMRv8+BJkvgiW0Ru
         7T7g==
X-Gm-Message-State: AOJu0YysqGoLY9KHvi7UFSeI3SB6Kk+A1CxiLsNQ2/TRjyp2mSV2H+hO
	EjEM0gp+S3TvbsCHl4GRZsSqi5gpV26IBrjKrT5aBhrPnRs/3yd7hbNC
X-Gm-Gg: Acq92OFjykBAuQw2qzKGqv0/1d0z5V5PhJ6UNMIQf3f1TvIHh8pfjJpU7KZyZzxrU08
	gdgvb5bdNSB/LZ23nfjHCCQr/rInrxp5vGv81BQimKOvZhDLrHCESQdp7gY+aFPM3tNQi6FIy0G
	XjNFauy6dPVvnRMpYwC9t2QoIgWUHfPdOgrCa1h83hHwXq5pOgO5wiYUTRA9pGVf5l/ZwlV7b0z
	h0YYXg0xABBxrR3c3oee/qut0kWVQ6CPn893wADfdkveuBNarDWs03EEM7ko1MZuyRPeH2IS+Q2
	qMJ1e60VchfHEcA4gHHd7qJQktpe4Eih557It9gDR1ioYVq553kEreT+0Ss+QyviilsQG7k3UBO
	DE1rIFlAB/xCLRnkuV3PJUldv7fONvQDr0+6xizKUeH64pzli5zZc1LXDkeX1eKzUsTGujBPpNM
	NP2eEySkuJ9OgpZV9YLwhNpq0O6oKDm0rSX5gQQgL/NI9kt0tIUk/RfSZT6cb3
X-Received: by 2002:a05:620a:3708:b0:8cd:c01f:fd25 with SMTP id af79cd13be357-911cd07b23amr915110485a.14.1778876029646;
        Fri, 15 May 2026 13:13:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba36e638sm647870885a.9.2026.05.15.13.13.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 13:13:48 -0700 (PDT)
Message-ID: <c8cb8168-7b49-4820-bfa0-7ce7e6404d91@gmail.com>
Date: Fri, 15 May 2026 13:13:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/144] 6.12.90-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260515154653.469907118@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/26 08:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.90 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.90-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
