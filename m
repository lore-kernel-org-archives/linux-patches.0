Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5466E6FC3
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 21:05:00 +0000 (UTC)
Received: by mail-qv1-f48.google.com with SMTP id mg14so1801550qvb.12
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 14:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678914299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HhB1eHhKNybt7fmqo/e14U8GDGgKPuLXz5imrXdqBM0=;
        b=U/XEbURniFfeRL6bJBqVPnzxsAuTuxlHyPhhbSPpa74fQl/jJQNSCzYWmi5hGcPeDy
         SUQ+2YsZgCCSuf7JR+HrYgDcmgRXeTf0DR1HXBloe18js1RkzBCd6rxYB0L3KWJ+JjRR
         imevI/J3wc/706FZcQF3IuEN/pajngrQItmJxg7zGoTGiRZdj6kJUHkqUxmTCJlVoudZ
         W+Ai07/6nNStkqj5+mbVnneWJPPf+5nZcX8jrMR5F9+j0byZh/DtzIoSuCfepTB1FpbU
         QSkS4PFxJ028zb9IzB6ou6c/TKzeShPNtuv2eAnhuJWBUHniRHqZHHCdDIrKu1cOfisv
         VpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678914299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhB1eHhKNybt7fmqo/e14U8GDGgKPuLXz5imrXdqBM0=;
        b=zx2xYBBUZRF+WOxaNUcIliNIMwsC0gCkmTZYpwRMT8ejp4q3ZSERpjoZ/Tu5/stPyB
         ZxGAIRGmHegXWSVHLIqRzzEJ9lfQ4ofkaLNg0GcsCcZ5zl+jD1wFxQDtQXqxgLUhFxqr
         pxQ+IW9Dc4AufF6e3TJSNdxUmgHn7SW10txUS2/1/Z115GhLEEHg7EPlUwHUbpKxz+n3
         AfjG0OFTLf+XmUwPsUaBhRX4FCS0LguDwGXH2zRpf99NrjQOQb0nhSXEjAwMIjPnMHod
         FuuZbO7nCWRIa65J0CwGgXl7R006DpttHeDg2K0DMQHu4iL6ubjJd155zL24ab4jGqZ5
         TtpQ==
X-Gm-Message-State: AO0yUKUmCpsNVrMx95tCYDOccyH58GTC3OguIEM8I2dZHH5+btMeNpoe
	YaVlRumSY7F51+FF1PYNF84=
X-Google-Smtp-Source: AK7set+1/1fKijypVrC8Dgh8Dn7sY5apPvhBycX+NHOd3R2nYSl7ce9c+pyW3Cd/BPaEEjhECT24qQ==
X-Received: by 2002:a05:6214:48f:b0:5a2:abf1:7d33 with SMTP id pt15-20020a056214048f00b005a2abf17d33mr26055654qvb.50.1678914299257;
        Wed, 15 Mar 2023 14:04:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g28-20020a05620a109c00b0073fe1056b00sm4400863qkk.55.2023.03.15.14.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 14:04:58 -0700 (PDT)
Message-ID: <75bb3ba6-c1cd-d38f-0e0c-b4b1916aa1f2@gmail.com>
Date: Wed, 15 Mar 2023 14:04:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/145] 5.15.103-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115738.951067403@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.103-rc1.gz
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

