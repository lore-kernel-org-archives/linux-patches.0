Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E29A498
	for <patches@lists.linux.dev>; Mon, 28 Nov 2022 21:56:02 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id y17so3639992plp.3
        for <patches@lists.linux.dev>; Mon, 28 Nov 2022 13:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PNE2hM5xuRQg1qTi7Jhb4FKs2enVjE/c6i2QY7o+wfk=;
        b=ggl4s4VnvSif8ARoD9mDKXN/FZRm5YDoU5oWpDdy9kdO32JLUN4xSZEOGPcHBoUWgA
         ZoObHJDHHhM10FUHSyjQt9Ko1rbfCGJ33K7Y72D53oR+DqjkBRyzeQMQC6YeWX5YSmrH
         EJkj3agiRYkp1hKpvei60t7y7yAvgJiDpYVA2xJg8rMMSb1docHC1Dlois7qzoRByu6Y
         CRXi4UnZa5+lwkQ7+N/3nzU93/3DLwmMfLLescvqsVP7gAUgcyU5umJCVjRvsryKS/rD
         gRe0/j/0UIxjoOkUpXVxvCwi8GYXAeX09/V+Ir8nMHBUT9K8JFeucMozXw+bv0QEFIBF
         CfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PNE2hM5xuRQg1qTi7Jhb4FKs2enVjE/c6i2QY7o+wfk=;
        b=p3m4UPZINxH7AYA4gCcpWLoKuHulM6Ov1p2BHL/lGnbxOW6OiWue82wfw7/9/1r57N
         vM71k4pKy6Rzhg60X1RzT5TODJCFABtqxln1IYfEQcjEqfOiuiZ7KphDmTzFCakDA32V
         OzMiMWJpZBrKgPy4nLYC5IjaT9Aac/hn+Mc0B8NGAHXfokKpfQqxNRWhQHBDpaXzgZwV
         oObx1cNEgxeTsaPE+09UQLyXH2SjeMEhIou9l9KFvM3XOuz9k28NfVras9MSo9LHL5Mi
         E2uCEvoRM0HlN8Glmakuw0o+MeSNW7ueOPBWUisc1PnU0J/yD2qJg1xQa8jlDwJIh1C8
         2enQ==
X-Gm-Message-State: ANoB5pkJdxSwqVeEm2MjIV44lYkgu6w9S63d1BUj5utqR9qo6VMxxjhZ
	hSLboaqomLjLv2k7t94fNDY=
X-Google-Smtp-Source: AA0mqf4Ic8U/2HubojmEHBWTW6lx07dDGX5ULtU6u+Lp5wFm6qolBN7MYcPQ0ef2hXtaB5KihKcTWw==
X-Received: by 2002:a17:902:ca14:b0:188:dcfb:f2dc with SMTP id w20-20020a170902ca1400b00188dcfbf2dcmr33894941pld.5.1669672561860;
        Mon, 28 Nov 2022 13:56:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v11-20020a17090a520b00b0020ab246ac79sm2641175pjh.47.2022.11.28.13.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 13:56:01 -0800 (PST)
Message-ID: <c241736c-f50f-97c9-f662-37b65d1b8a2d@gmail.com>
Date: Mon, 28 Nov 2022 13:55:55 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 00/76] 4.9.334-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221123084546.742331901@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/22 00:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.334 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.334-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

