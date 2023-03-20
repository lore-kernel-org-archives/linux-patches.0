Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C898477
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 20:58:13 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id x1so14823612qtr.7
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 13:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679345892;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yoeChtzo2lWFrH5XgwNuAkfFSV3nOpgGzq4XPO44Eas=;
        b=FLFjbErCI/z0z3nasBQdIVv++X8I+lvgdo6KFZY8MG+S++cUNeUH9WXuJh7zj/kYYp
         qE0hqtTUBLa1nxmTd65+gbqd57y4ae9tz1+NkucBA2W3/e49NUPquTy5mS7L61iL/BDQ
         b2ckWuZqxfzkjwlR4BlwAFLFXKcUenV0Es5xCX34ZgkgvD8eLzQIsBW1JJxrOCcAavmm
         A78BoiYyYaAe3x9wkgNqunABRINWV+yRDPuQtz9SfkZW0NmyjQe2BY1CQzWUNcZYuj8K
         iCkgDwXfvOHjJHsW2FEnoO32vf5XwV5/XwkPvKMw29GU3vcCUC/LxNefV94kTv76N4J+
         WJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679345892;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yoeChtzo2lWFrH5XgwNuAkfFSV3nOpgGzq4XPO44Eas=;
        b=bgUg/gF3NabqVeoNplyy7uUeZuk6R3cdwgBAlu4cUsNpkkGHETRFk43whTUotqJvbq
         dSlTYXRqB1xEoOHI8a4MiAtUjr9m6fDortvncd98caxeToMQ5LRWRd68dCX3/D/E/xgs
         NqyadxoWCuxIi0u3kkqE7eTFybdnq0nGHNP+EZ3dMm2gDQ9z+9nebhlDSMTm5zdMSbJN
         9PvEFmogwumVzfDBp40niG1Qxf+HcjN6Cf98CXp3Y019XA+mC/PAGd0TqtUybMK0qPaW
         M5gJjQuWir12Dsn0r6UmZW6luVEWafSHRxWDFVwviIFVS07H18e086YNelLPF1Y1bSVb
         lVaw==
X-Gm-Message-State: AO0yUKUwaglPrva0phYOFX96DeUzIumznU0oyGmg5w0JViKYd18VY3oW
	UDiX+DOy1x+iTgHb73Mk1CY=
X-Google-Smtp-Source: AK7set89AGEw+qpi24l+uwt6mCVUfwsoNeY8Skw29NjmzPV/ZzgoHOZXSfzRZ2CV2terbeLji1FPCw==
X-Received: by 2002:a05:622a:511:b0:3d4:3d6c:a62b with SMTP id l17-20020a05622a051100b003d43d6ca62bmr1081294qtx.27.1679345892078;
        Mon, 20 Mar 2023 13:58:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m64-20020a375843000000b0073b8512d2dbsm7943235qkb.72.2023.03.20.13.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 13:58:11 -0700 (PDT)
Message-ID: <a3ed86fd-ac5e-3692-abcc-9e7849e176c1@gmail.com>
Date: Mon, 20 Mar 2023 13:58:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230320145507.420176832@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/23 07:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

