Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7502105
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 20:52:38 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id d16so4553933qtw.8
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 12:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v7UZeg8WZH4vThWTlw3VjelHJJ+pjC2jFdvq2/134J0=;
        b=HKrZAuFxYvG5Is33K7J62e6jnU9DKkjx6vBIQ+mO+IxIN5HHlIpAu8lnam2gSnfDJD
         xzdUnjiBS0R/SsoFFXUrwhmTStSv1w3nvPR4yu6EBxENXBvRHfWmlnxPTUxY2vV3AA+U
         0U4JGb8JSlKdL8HMv/Ze2XbX7h2/IEGqRkOQ4SoZBCenw+QVQdTqcBhe8+3R9rds9ruG
         jm8GiNdHhBNKuMRi/mFiPGkqbhyxZuGG6IjLV0pTH0YFUDWugQYYnrzjADfiJ6WnoG7W
         dBcTWQCc0UzY8phyT9V4HFgwIKhztIqOTOsPZKXZlfRSEpGi3q3Q8wVQZh9SZlD3Jxg2
         BRvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v7UZeg8WZH4vThWTlw3VjelHJJ+pjC2jFdvq2/134J0=;
        b=Pqv+/Up4i6OA4EAYi2qvSljXjwhNlxS58B3u2iRnNsWkC9XP5+RUbTEJBjWXaSzkgZ
         dwEUHnTg1aURXoVH0dDBfxi361BQItbvWGfzVNITCH+lfEiPHp/F54D/NjLA4uTY63hh
         IVO/uTuy6zDB1zoyA6B+YBgi1myh4ImZ0co4j74G+2LVkvA/xwkmX1TK2SB+H0yGMeXN
         PwqAAHAqAjSaS37Zq3aCT/6ZGXO88k0CsGvVdPD+Dn+nQSNbm2c1V02cB8PxrW2754aH
         YoChcNRDyJwg8g/Sod9I3PDLKUN1eEPaU53pmvSCmkrNWW8kMTCz4VCdfIrFbc8a8aMZ
         Y0CA==
X-Gm-Message-State: AFqh2kpR2VSNPIi/Gvd2Fdkrgu5Mq548opx2khwM1W/ImuhUu251wwe7
	4h27XmA4LCkTvp1jRcgap4g=
X-Google-Smtp-Source: AMrXdXvBg6hye74elpjLgIPaScfZlEZs+P2nrkYQPhY0bFkyjFk5hAvoryoIsF7oKRLYsOlHQcbQkQ==
X-Received: by 2002:a05:622a:801b:b0:3ac:77ed:3995 with SMTP id jr27-20020a05622a801b00b003ac77ed3995mr26467607qtb.26.1673556756951;
        Thu, 12 Jan 2023 12:52:36 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ci26-20020a05622a261a00b003b1020128edsm2540482qtb.41.2023.01.12.12.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 12:52:36 -0800 (PST)
Message-ID: <21962784-53e8-4305-d934-b8a5a8bc20fa@gmail.com>
Date: Thu, 12 Jan 2023 12:52:25 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230112135326.689857506@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/12/23 05:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.88-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

