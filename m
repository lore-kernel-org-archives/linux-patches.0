Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02EC3207
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 20:57:47 +0000 (UTC)
Received: by mail-qt1-f174.google.com with SMTP id s9so3686546qtx.6
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 12:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Tq44ENuJNTwNFqV9Umj3g0CTs/gvpy1jjgL0KsglCw=;
        b=IurxWDwzhju0yBrCTyOjro6yRV+2x3oVogyEeOBs9mb9OyX3S54MsG2tXZZZzqy6Wz
         jqLIQfzxU7+P8ouz2cGWJfh8/BkI9nS7epLVMN08AcnLOrbPUT6tHk6Yg5Kb3bIL7/b+
         qr8TEBVE0xSKu8zsLYExFns/mNl8UQRTMeZlzajjzdqg533vrzT/mX+gc1VXTdCA6gNb
         SubFY4Or6E7z5CV4DgxUAD1h6Il24ZoUNf5hc8nF4yoHRlHat6Hey4Ge3+zyz35ZieBy
         4DkyuIkmE9TFfciT/bJxrSAdIgSZZBAWgM4yl5VxFDt8Y691UmaR1tkA82EcgCHzdFoi
         NjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Tq44ENuJNTwNFqV9Umj3g0CTs/gvpy1jjgL0KsglCw=;
        b=FCJCrMCVzJgu+SUO12dXuxKV9AxOZbZfBkgHdnOHAGr/MWPZy2QvWsI/hDLkQyIMVE
         r9YdgyLVNlYmDb2gBgUh/LuCb63C2Gr/w7Vfz84qAVPAucfEngQI4fGyRqzBGRZXu6Mo
         Sk5EZJpXf/EVpGrzQg0Fvi741Je8YPTIAlGoS8zlpaC7+PKz0VykStw7Wzzhz5dMaZAE
         uoKJSNH7LlYh9FsJFv+GHrDt2x5LO4/BIAtnKpPPzv4wTmXLcZwbhKM4jYKIj54icNzZ
         MqqPv4CLqOQCv4bvt+OdBcThsTio/1ZAaH+zhAXoaxmn97UcKTJC95MyPggSjmAha0Om
         utmQ==
X-Gm-Message-State: ANoB5pkPSO+kdZltIYzdS60A4a1SqPzMZDDjTFC0kT0UuN+HvzI63ILd
	LYkJSpAOt5KdgMy2beQueRA=
X-Google-Smtp-Source: AA0mqf547f2Hu4M5uur7kbkgW7Yfu1GZG7SjCWDfA5Y3kln7IVH82UEcT0Y+FDNOxl2JPHC1jFYVAQ==
X-Received: by 2002:a05:622a:5149:b0:3a5:5f3d:f866 with SMTP id ew9-20020a05622a514900b003a55f3df866mr48127319qtb.42.1671224266631;
        Fri, 16 Dec 2022 12:57:46 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b4-20020ac86bc4000000b0039a610a04b1sm1899334qtt.37.2022.12.16.12.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 12:57:46 -0800 (PST)
Message-ID: <c8509fb4-6e09-cb1f-c49a-dc1e4473beea@gmail.com>
Date: Fri, 16 Dec 2022 12:57:41 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221215172908.162858817@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/15/22 10:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

