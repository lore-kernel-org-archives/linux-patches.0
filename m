Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D403C200AD
	for <patches@lists.linux.dev>; Tue, 30 May 2023 20:21:08 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-64d4e45971bso3359379b3a.2
        for <patches@lists.linux.dev>; Tue, 30 May 2023 13:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685478068; x=1688070068;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=of/5JX7VoIfv2vkTLNC734+oWn6zTGlkdNIC+/hQkxs=;
        b=YbF1y+09eGaHy2Xl3Ml8zXD0Azdj2fIUxummi4R9sae43co5UZJ5o6SAFb5FnXnDv2
         ci5trNLC0NwMjK2jgf3mOKrzILCOr3zKzwlL1FKL4LD0jiTLnJK7Kz7X5owrDFF+9Ida
         9BiU+PsPOcrbbEwhU14LBf1b1YcEBx4rEgIzUIfoCAtayRN8v6YHWFjUZbV5yCAKS2E5
         2yzLXHTSWPR5ZfGvv8K1UlQg9Oa0eFqCoXQz87nHMxOKFCS5DZw9A8pbx/X7iwqSNTDb
         1P8YCWI9cqJp7AvLlNr7IsND8MRXSqZB/7KqkCttiHtstpRCAdt5iVBV4Co3wdHMFxds
         FlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685478068; x=1688070068;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=of/5JX7VoIfv2vkTLNC734+oWn6zTGlkdNIC+/hQkxs=;
        b=WDRm2jeYDbZrPTI5sCoR2UeioaU1JKnXm3FZA2dBXqcaFS6Fm+uzq8x3T+JiRFQD2Z
         wWIwsyBfcOY1+AZoDfnlWv7tJj6ZMOvpSAkbe4zkAqnimcHn/Ub1FCvLdkiGmFdIGhcA
         VwseB4dkpu6HeYz0TNglLSeEl/oXea/oXpUhgPOKzOCgwWI3A29G2F1yJOD1A5tk1b2F
         F6PX7ptp6fvTrfdvr22OI2/5cL4sQXxYJbXoH6ofzes/4OeC2aSPrGfqGHSjR4r19+LQ
         0+v+S7RqfVQ5oc17cmGowtj5m6u1ytpMF6COAHZPVdWxbCb024ghDCashsTUqAirf4UL
         WjOg==
X-Gm-Message-State: AC+VfDxUsaCtlRUL4kf/jxBQNVPMLIiARwBiXqivLL4s7gIggzfZCRKx
	8Lc9BLhqNZFyWsCpyU7Vl+k=
X-Google-Smtp-Source: ACHHUZ7jRcRh4P3u2z+95acFIKMHna4RlASa/Q0HdpnihncQw9jnZvn54oSpx187GKhPpaYM2PW9fg==
X-Received: by 2002:a17:903:1110:b0:1b0:2658:daf7 with SMTP id n16-20020a170903111000b001b02658daf7mr4010622plh.36.1685478068122;
        Tue, 30 May 2023 13:21:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id iy11-20020a170903130b00b001afba6edc8esm5645126plb.166.2023.05.30.13.20.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 13:21:07 -0700 (PDT)
Message-ID: <99bac91c-eb98-91f0-cfb5-c198b1c747db@gmail.com>
Date: Tue, 30 May 2023 13:20:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.3 000/127] 6.3.5-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230528190836.161231414@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/23 12:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.5 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>

if there is a need for a rc2, mind picking up:

https://lore.kernel.org/lkml/20230530201955.848176-1-florian.fainelli@broadcom.com/T/#u

Thanks!
-- 
Florian

