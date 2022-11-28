Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86333A492
	for <patches@lists.linux.dev>; Mon, 28 Nov 2022 20:55:39 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d3so6405104plr.10
        for <patches@lists.linux.dev>; Mon, 28 Nov 2022 12:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Aq/k14hHxyqv+R/E0+ZIRLUsEK+p2/petQlrLB89kfU=;
        b=K6bgp2Ndbt8cB0g+NYsOVuj9p8BADh8negD17Pb9B7vzIIu4nezQjaxRFY87IeZZVw
         vJ7lsGhQBj6fb/UGdc+NY09xBP2tZ1u/KX6Xs7yz5V7JMEC90rlNP/VREF4ke0jMTNTz
         BaJO9SeUFy6GD4Bq8pQcuXFfYDnZUbwpmQezqqslq0TRlaiWeGzDa9FBwsa22rYBdBxt
         dkhQ63wrfvhHdGfSdXB2omz1Pex/ChXOcL23SV+bK+vAla/CG8e3RZ5kYptqN7MZLcFo
         Pw+vouFfmW5itJtz0EiIAJQ4wkI0J21NZMWjDhfMn+cs2VRC3Vo/RLLVX5LzymLJi+Nv
         wUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aq/k14hHxyqv+R/E0+ZIRLUsEK+p2/petQlrLB89kfU=;
        b=kSDLmN+QBNBZQjsAwb+ocrSHYHbBuRRSdIpyOja8HIMEkGVUzl2XaBPDGuAaVMIQbq
         wn/zEYbltG3870UHHZsq/rjNu8+nOWbatDekoJHltmAIwhYDGgctcK8brKxQ10sQfdXM
         UkZTrEA3gX0G/B0QSwmbMTRYsJxwWARH96evBELfaxCV2jJGC62WDIhYkLnQBoVxmcn8
         IZkY8vi14hkx/QTlSS8b20GfT5U/t+OVxyEI3KsTvUJRCy20q4eoybjPzsDeP3BId4gI
         WVsvABemBonj7nTvTdgxbwKQpqoQb+k8DUAuXF7JoawvLLEytdjOzZs5I1UJ5nhY66+K
         3ETg==
X-Gm-Message-State: ANoB5pmPUNylqCkYLxpDY1odcRzpyBWyQK8UI8oiY810jW8TgBVwBv34
	KTTubYQEbcEtGOGX9uUpU5Y=
X-Google-Smtp-Source: AA0mqf4EmPJGQk9BL0tECBExCJGFn+d7sIW8KY71HLgIBfLHHjRTd0PRGwlA6xERrn4SCcY3sBVliA==
X-Received: by 2002:a17:90a:5c85:b0:20a:92d2:226a with SMTP id r5-20020a17090a5c8500b0020a92d2226amr45039647pji.155.1669668938878;
        Mon, 28 Nov 2022 12:55:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b13-20020a170902d50d00b0017f73caf588sm9260002plg.218.2022.11.28.12.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 12:55:38 -0800 (PST)
Message-ID: <1e5d85a0-6edc-bde4-6493-c2b2ac25c760@gmail.com>
Date: Mon, 28 Nov 2022 12:55:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/313] 6.0.10-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221125075804.064161337@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221125075804.064161337@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/22 23:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Nov 2022 07:57:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.10-rc2.gz
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

