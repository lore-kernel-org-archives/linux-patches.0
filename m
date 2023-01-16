Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728AB8BF0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 23:58:53 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id i70so5005652ioa.12
        for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gvce8byWraezThlmNd8HU9XHmnQc8tfuTqYSxzb2BIc=;
        b=HYh6mzDfBWKp4lyw7GXWGOELICipwkoygLnBm8gbOO+SwTNBinHf6qP8aKZnDy+2Bc
         Q/w0eQbzhS660Qu3DBbmBpWmSvqVz2Eg0WGwJbmO9NteYorPYV9VeV3Ixz3XOQGRO11P
         xnOe1UTLg7mgibBT+Or3qj6AmXI8DxsglzeSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvce8byWraezThlmNd8HU9XHmnQc8tfuTqYSxzb2BIc=;
        b=8NB3GtoSiJgd++uAFkUMweKx56C729Yo+IYR6bE0i0Xt6Mrj/myZUYRVCdTF99FcnR
         0mlRsPthvg2N18cHukpqK/88hsfxYmjh1R4pGDZTHzf2JXncIMy7qs3uHMQapuuFAlwt
         df9S6qjvymhy07DB4O3V/6YNVfEGCX1i6J7SyBcisWrcDQk22wd04+Tyhea99+X8lwPz
         No18wvvX9hLW879NrC3Vl0eul/gNvGryZGbw0KKmJTh4Ppqkk3XdTQCef2zx3q5Bf5Z/
         cA7J/EwkDj8TUffZBDqA0v9MbwA4BgHLdZl3u3Uw4Ds9Y1USlk7diuECh6wDNDqF+JOu
         tpQw==
X-Gm-Message-State: AFqh2kqdEBO8QffumoPFcoM4xjEVA3YiVRdzRZL6NJ7Ehji7Quyzczbt
	xSAJ5Kb7HktothFKodld49Bu4g==
X-Google-Smtp-Source: AMrXdXu6sHtAAXL8Xvb4XXBKVeSZvhiMTxdi0Zr0P0D+1nx81UBzloPHpx3d082GkE99T1gq/jkItw==
X-Received: by 2002:a5e:c114:0:b0:6ed:1ad7:56bc with SMTP id v20-20020a5ec114000000b006ed1ad756bcmr153584iol.0.1673913532588;
        Mon, 16 Jan 2023 15:58:52 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k5-20020a0566022a4500b006df19c8671fsm10030960iov.27.2023.01.16.15.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 15:58:51 -0800 (PST)
Message-ID: <8826d3a3-a81e-d16b-82a6-aeacd6738ccd@linuxfoundation.org>
Date: Mon, 16 Jan 2023 16:58:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/23 08:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.164-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
