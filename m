Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B175EC944
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:22:34 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-760c1762f7dso10959839f.0
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 14:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681852954; x=1684444954;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WcviQLFSJefqWXQI0Sw/y5jsQNLosOLMfA9+eAP1G5k=;
        b=Q7Y+AFM+IJbRAiluK3jPNhW0uEV87BtRxioYeEjB4pTcClisZZ+0pmFGx3CwuswAk6
         p3LZ1YzvQNF5msNQdZ4ehbMwOf5ob85a/6xFLSAD32m8Gx+vCHFm3hKUuCTiX+UDHE0m
         +LisCc/XWXxpBDrx6llIs9zIqMyOZDczq5taQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681852954; x=1684444954;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WcviQLFSJefqWXQI0Sw/y5jsQNLosOLMfA9+eAP1G5k=;
        b=EbClvQelBCLuzQ3ulQniPsOyZFqvoODHdVDDzvoXxXNyPT0YtU0VSaCH7Ou9mUexVZ
         D1am5x6FQJqgs83sK4BQkfRT3mHfszlX9p6Y5V0K25R7oDHVQvxsF4k6zlDy1FpARawV
         AMpGjdh4yEYs9qTfW+4zovOW0fKaYlq4ZVD6OmclGi6l8sJprv9vHh2Phd/d29GiAwfx
         d3lB+NWiAKmnx5XfOkMOb0ApIzFtEk2m3kPeI2oY5D0bXa7BOhXsI1GZArOtxlYQ741R
         uQ5eFAzyLjrjN7aqx+8hEopIhdZvc+kKsE2NYdOjanGneXFmFpejZuA4ofVv1D/OOLwg
         ve7g==
X-Gm-Message-State: AAQBX9encObvOCFpEA0BObGUDOBP7B6acxUGDExSLwAj5v/uh57biCmx
	WJ+4yiGfz3ScUPe6L4jqWXA2Gg==
X-Google-Smtp-Source: AKy350aCvYFGp8Vv3l630pIlNlO5+37VseErc9/L/VQKFbLy1X6omO7RRHvHHa1RwX01iQV0M2GSgw==
X-Received: by 2002:a6b:14d5:0:b0:760:ebcb:957 with SMTP id 204-20020a6b14d5000000b00760ebcb0957mr6750240iou.2.1681852953733;
        Tue, 18 Apr 2023 14:22:33 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i4-20020a05663815c400b0040f91082a4fsm3040680jat.75.2023.04.18.14.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 14:22:33 -0700 (PDT)
Message-ID: <fedb0259-3e98-15ba-3af9-cc3729bf48a5@linuxfoundation.org>
Date: Tue, 18 Apr 2023 15:22:32 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.1 000/134] 6.1.25-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/23 06:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.25-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
