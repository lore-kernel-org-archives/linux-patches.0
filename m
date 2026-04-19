Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AF340DFC4
	for <patches@lists.linux.dev>; Sun, 19 Apr 2026 14:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776609080; cv=none; b=shHcWEBNaJwg5yorPIHtU9sl2s8P61Swey8QExihnczOkkoCTwXJqrkEKLYwQGg5M9yYozmYmtSWKG0Mp4KNRbYeWIMfPf8/jVnGjO4+cNiRdZOeKZrI23mJZup2BI2P61Z8rlRPb8jzWL2mbWzRqlpGvFMeNWg2szDh4Zcwzfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776609080; c=relaxed/simple;
	bh=Y8GyqGgQ6kl1F5r5RC/hnhSUBsUKP/zHaLDSWr6/bYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bK0XfSxdWdSSM++rFxFj2dlbhR+bR6W7dBfb5wCdIinuMVTupFOrf/wC/q6s/vCYAAm0M1XltNCEBJ+Tp81cCNgTxD0875tLcaDcxAcRQFwWg+rN5norBpHI1s7hxji40roHU+Yxn5F0OEFUAiqprWx8tBhCjeSgW1qx9lo5WR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=htZBX/Pt; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="htZBX/Pt"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ad9516a653so11169225ad.0
        for <patches@lists.linux.dev>; Sun, 19 Apr 2026 07:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776609078; x=1777213878; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=r/McSDssSNdwq5LcpMkr7nlq1QDVqsyyBhUjejRX74A=;
        b=htZBX/PtigL/MEOnu8VxUwyt7zOvGn3Q/0zEkJWfyya2kOwF3hD5Wo2u6w6jINLaTB
         agqMwu5F4ezvXWnMwr5DCF1SgvI4eDRMvxKyiHP2pf3zzpYyIGkMYkGsFodIbdLtuYoe
         cQzM5nc7JPZ9E1ECVD4GheRaFq2TTvANLt8uaVWQkopWG1zg3p/eJG/EsMtPTPvJKqCr
         SOjRTX3/mqp9W7f+slAvErDHMEs8hXPYVeXr+ruHKs/X2r9CunMtCwMz89x7rBcTbZKr
         D8+nT3SnnPl4bR1dAKqfBIhUWxLzQVv+94gxWZvsf7F0M26ZufLQW1V6YRsxHkVNAEUm
         HJMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776609078; x=1777213878;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/McSDssSNdwq5LcpMkr7nlq1QDVqsyyBhUjejRX74A=;
        b=ZDeuG3buJli8Yv007DsU6QMv/HYpqAoi1a7gpCC4B6e5q2mzWa8vvBXGeZ4xdMcnDl
         AbaojDqf3nAHxYyMV8ABgfEDl9oftOngKf2JtprzZTQub1OKiaRV5eJ+VKjcXTrVmLU0
         /jCTvv57vxG3f+zkJOJknXAG5CRXRVdbQ2gImJS79eU1YpXQTC5v0DlHWLatceI3S9wJ
         VLs3wt+uvITltV68E1JL046XAH64lemb0qyagGKbxwwWoley1/9cxN0mchU9hYrSf01o
         wBNCjWDRARMrvDpAa6cG1th+jrX8/w+gfW8QHbbatjmf1AnHjT2Niy9VDl8yAch9qnvr
         +LzQ==
X-Gm-Message-State: AOJu0YwWPEkI3K5Cqwxg62uUGou0ifsPRvunwXI9NWh7gBL4AQJ3cpoV
	n6WCUOcrkzRFeCetpOss7OOdGOrdytMf0r9cOS8ofXeah5s4g54AWjjy
X-Gm-Gg: AeBDiet0uYa6k9m5RQVsTqxOCRtvXxuxBb1xjbR8rscQiwjogjvrfWZJuQzMLYqMLjv
	SJAyHaP+4aVWJEKufvsw8kH57+vTD2JloMGV5d6CDMA5Q1W+7rI1MsrNlag8n0JUWUYchRx+TiW
	CNLVnPE0SdCn8AGQwE1OQhJhhq6FLnbZtDSB8I7UXei1wMZ6fguiGtIoNbBENPB+E00k+4Z0oK4
	Mv6gH1/eusrRZ7ghZjCEJoLaIvMPvog3a6UzCHDXuJURlb/EcTY4u0zz1oE89aQMZ4Db4VhqzK/
	Pc1nyEIvjJhSamzEF0PB6th3SM+AVUTOvNjtejIa0lhoE/fIeynyAIqboK5XTlYb/oLCScRrrHI
	xNKrr7kMYA9H55YAOst4JzRVfRv4ZazSGdIjnOZAHbAnVVFXRGJWJOAaK4ykR0nkQ3twhCdsFfP
	DEHboB6fBTTgTvXHMqLer/6GV6q4m6SdhfHlwtT2veX4fdEAz5Njw9JHWftPuW+d8ds0fzI/GNe
	STJk4xpSfQ=
X-Received: by 2002:a17:903:bd2:b0:2ae:826f:2c50 with SMTP id d9443c01a7336-2b5f9e8996bmr84030485ad.12.1776609078236;
        Sun, 19 Apr 2026 07:31:18 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa3073asm71740385ad.27.2026.04.19.07.31.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2026 07:31:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8bb67921-d8e7-4535-bbec-249e9702ce62@roeck-us.net>
Date: Sun, 19 Apr 2026 07:31:14 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/55] 6.1.169-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com, Linus Walleij <linusw@kernel.org>,
 Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20260413155724.820472494@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 4/13/26 09:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.169 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 

Looking through my test logs, I find that the following build error has been
reported since  v6.1.166.

Building arm:ixp4xx_defconfig ... failed
--------------
Error log:
drivers/net/ethernet/xscale/ixp4xx_eth.c:390:39: warning: 'struct kernel_hwtstamp_config' declared inside parameter list will not be visible outside of this definition or declaration
   390 |                                struct kernel_hwtstamp_config *cfg,
       |                                       ^~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/xscale/ixp4xx_eth.c: In function 'ixp4xx_hwtstamp_set':
drivers/net/ethernet/xscale/ixp4xx_eth.c:408:16: error: invalid use of undefined type 'struct kernel_hwtstamp_config'

Backported patches in that driver are

5195b10c34b8 net: ethernet: xscale: Check for PTP support properly
a94d5447f6bf net: ixp4xx_eth: convert to ndo_hwtstamp_get() and ndo_hwtstamp_set()

where a94d5447f6bf introduces the problem and presumably was applied
to be able to apply 5195b10c34b8 without having to resolve conflicts.

Unfortunately, 'struct kernel_hwtstamp_config' is indeed not available in v6.1,
causing the build failure.

a94d5447f6bf can not be reverted on its own, so both patches would have to
be reverted to fix the problem.

The same problem is seen in v5.15.y since v5.15.202. The commits there are

144dde314698 net: ethernet: xscale: Check for PTP support properly
612c622ab8ef net: ixp4xx_eth: convert to ndo_hwtstamp_get() and ndo_hwtstamp_set()

I have copied the patch authors for advice.

Guenter

