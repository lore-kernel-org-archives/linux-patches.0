Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F73553AF
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 17:14:58 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-63b5c4c76aaso786833b3a.2
        for <patches@lists.linux.dev>; Sat, 29 Apr 2023 10:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682788498; x=1685380498;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A1ACuy/osQdCjo/PWg2MRsM2W3CTWTDNQjv55mAPc0g=;
        b=FJvRi4nCQ7TyhpaQDMnrGMSJEze+SpsPv3qSPMGiXK40WBKKbacnkQErP1I3JpGqnA
         TYFmG4mUT34g8+ygzmSjS0BIED2isLzz+rNQOeldkxPAZhJBACWpysNAQiaSfrgOWyd5
         qXcLBtmBcSGbm36C732DDV7Gi2pg6jyQIZONy99YKglr1UidvN2paQ+TbLKj00+MIS2u
         EFv5yR1Y7v35uJc+MYAiXAD/DPncNYn9AHD4if1WjuDo+K1e9vHi8tNBNN0zgXuwlTCn
         b6Nnd9yhjXvVyGbbrjzCu6EO3OGnS7pgqKMgYqTetJOlr3w57UWa93QsR2E/NhNDrH+/
         al8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682788498; x=1685380498;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A1ACuy/osQdCjo/PWg2MRsM2W3CTWTDNQjv55mAPc0g=;
        b=ZJnjX6UaEWuK4C/kbNzdmw6VoBZjgYw6HQMNmDZqlzMkjkpidNxPPmlVLRLN/q6K9f
         ATT8fsRDNFDa5AHai3JiUjUBLv7s/5n9+h2EWfUg3CWTGpwhIqSBfxxopm440RdIQT61
         jtUs+tdYIJYJwVXynhPIyfPyFOTWDVamWBtPey+qiLNjvBR1EV9xQjJa5Hh67jVzT/bF
         UakDslg82BZB1khxSEQD2tNllwFh6gSNVe0Osf7voOwMerQB8VArRwYJNoIjadWMcQw/
         VtwdBL5jxRWCH4M3eA+LieDXLj5jPiCHnZTqaopKlbPWw3emTDaxsfu5WAI4BVtZ9k0U
         rGTw==
X-Gm-Message-State: AC+VfDx4o9mWwXccnf0D5J8hEG3eCcqKRSjAQ5wP8BtkjvPcRNYH1ZeJ
	+cFAmInaYSYGLLxxjQbIr6U=
X-Google-Smtp-Source: ACHHUZ5/zMXaqvvU2ATe1Cd0nE38gDYHd34xkMfhwXouXnro4NcP/N5HAywZopxkIQ05jz+jswqTPA==
X-Received: by 2002:a05:6a00:2344:b0:63d:311a:a16b with SMTP id j4-20020a056a00234400b0063d311aa16bmr11895723pfj.23.1682788497815;
        Sat, 29 Apr 2023 10:14:57 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:1c98:2538:93cd:aefb? ([2600:8802:b00:4a48:1c98:2538:93cd:aefb])
        by smtp.gmail.com with ESMTPSA id i12-20020a62870c000000b0063b7f3250e9sm17072699pfe.7.2023.04.29.10.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Apr 2023 10:14:57 -0700 (PDT)
Message-ID: <4f7efcd3-df6a-1140-e60a-736c56966059@gmail.com>
Date: Sat, 29 Apr 2023 10:14:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 6.3 00/11] 6.3.1-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230428112039.886496777@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230428112039.886496777@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/28/2023 4:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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
