Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E6935884
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 15:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PiPiDZNY"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6b201a93c9cso3638261b3a.0
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698162383; x=1698767183; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=broF79zHCDHtcT0lMzk4mTNTLoYN8J3GX3kjH8mcCUM=;
        b=PiPiDZNYxOs3vqkZ3JawzXYkF2kX4HiZ+/pEk5WMr24VU5ghwniglfhfhHBtgbHQy6
         +ydy/9pPrwyPOoqHsIPbg1w/AtAIL44xzH8/EvGAZ3LHp0+bkD08V9w3EzNuDtNVwOTt
         8xwZrOZm8kHAl06/2y/4LNtrM3EQ/L2NFkxQ9rgCaaKIR39Z1dCp/8nxAaeEFnoqTPbt
         aAJwT53Br1BtzDO+pR4R75J0hB/pnnFP/lK6b0PRv3KM0fxIFW89lsaUXK8q3A9CRv8h
         v9jNHVCLSJ6vWzgpy/OQdowdM1O3t99orKSx+we7EzTjqtGrjmLJvZ/GZVDPm1lNSPoL
         gzEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698162383; x=1698767183;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=broF79zHCDHtcT0lMzk4mTNTLoYN8J3GX3kjH8mcCUM=;
        b=gMc0Xr+Ja6zt0awtsS3Uvxl2ADyXwzwl0fCLXhmv18ANY0TigrOrVlIKdy7izyGey1
         LfdPkjXvTOD/3wN3EtxQtahKz65IBGuiK46P6vumKHNQKaeM1BnU/iAa6X/o7PQTUHxi
         6g8FSvrPnkf776NWpw67PqqLZ0xSi1Q0/sC0NF0uwCUv7f2LPk2k773W5MZikZH7+iPP
         EXz41it1OLknqUdbgYCx+45B3xbqsfccfAy3AZGnIOHx56pyTaTtaMsPdnvyQ5GvOESR
         xpaO5UrYn9j7HDUT84TdGxMvIl1mRoeoPJcqDpCkZktZWUERYySSqFJ8eKUxWDOTv7OK
         OBbw==
X-Gm-Message-State: AOJu0YxIsafVkoK+48/V+TIo5tlvUBSHy4z++hlne9asO3Y9FOGqG2JK
	mFCYQ76PxUt7JueTgdLLXKY=
X-Google-Smtp-Source: AGHT+IEOtVboZSjZpVV9kZKORPcgmgBeOBXfWSWLkeVvGDprv0+eboKjsKz1pxeoTGPqG3Dau9h9vw==
X-Received: by 2002:a05:6a21:7742:b0:17d:9da4:5eb3 with SMTP id bc2-20020a056a21774200b0017d9da45eb3mr2894397pzc.56.1698162383021;
        Tue, 24 Oct 2023 08:46:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j11-20020a63cf0b000000b005afdd58bab2sm7398084pgg.30.2023.10.24.08.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 08:46:22 -0700 (PDT)
Message-ID: <42a345ec-fa05-400d-bc74-306241bc324a@gmail.com>
Date: Tue, 24 Oct 2023 08:46:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/120] 5.4.259-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231024083306.700855687@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231024083306.700855687@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/23 01:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.259 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Oct 2023 08:32:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.259-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

