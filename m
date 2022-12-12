Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178877475
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 23:00:47 +0000 (UTC)
Received: by mail-qv1-f52.google.com with SMTP id pp21so8443629qvb.5
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 15:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Ht/LlPGljFDR9dH0x29jG/ENJFXH6Mx1h6XvRtc6YI=;
        b=ordFqPmFcutAQwX0/fkW7+uB3h2qK8+JmcXNAkZVMrfx62sPR/Lg9/4PkG7o7RdcH2
         1lBXNODperIsg9yRXqLK5S+Mnph5tKUHiganeYo5vmnPgqWsef29Fa7taaw8ZhJa6J1a
         cH15yPHCpyEUIFv7bTlsMlfFkh/mhQm8aLMLo5azCMLWztH0RKg9w325SNsGtxtnlJca
         BcHWKrSnCcTbZ8YSoIhkNylFAoZJCgCsUKUzNEfAQG/kPDMX7Hch98Nle/e/LnHbHgxs
         OiMlqfeKRi6GyvmqYcE1UknDwCD2AfjagQ1LxK0RM0lOerjVSrG10uuiz+ABpsWd45hy
         4ltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ht/LlPGljFDR9dH0x29jG/ENJFXH6Mx1h6XvRtc6YI=;
        b=Tje+UP8uaQFM32wWKY6domGto0zHCQAH5G+13nGStTi6MCendKmtH6CVMZQpWbSjKn
         LCAo2dfDrCa8i/rNv8GQPiy29zTqaNLWh+eOjzfPFu1aRok8iBkjq/2ZxFvAR/gjpBXD
         gD7kM3kBmVs6L1RAIFGMYc+wZ6/9VW0Z9KcWzO8um21tCKSugIn1ugMbs1q9YbnS/rsl
         IeY4eIqezjqwE+vVV2ZVfQKpuIIr31pYspJ6dGIFwh6UVpmdJvCRrmZgGc6QX/gm2cqY
         HuVB+fzSuoQZ+3APM+dkCP5/KS5r7gFXz8rLXXKLZIzlL1QFgimVRN48H9d6XE3wBSAI
         EBnQ==
X-Gm-Message-State: ANoB5pnkng2lgxCa5gFqm23Ww9uQCCUS5ESCD+c4FI8u+snFTL1lbvLv
	r+aUkPvDIcHxYQ+t6G7hRU0=
X-Google-Smtp-Source: AA0mqf6KjJzcgbsIYYVqJ1MfuqoY2x0qrvgAgw1NOsw149Ed/RrFl8NXhWGVNm0jRoHH7Ip8dXzGVg==
X-Received: by 2002:a0c:f8cb:0:b0:4c7:539d:1992 with SMTP id h11-20020a0cf8cb000000b004c7539d1992mr25365659qvo.27.1670886045953;
        Mon, 12 Dec 2022 15:00:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t30-20020a37ea1e000000b006eef13ef4c8sm6635816qkj.94.2022.12.12.15.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 15:00:45 -0800 (PST)
Message-ID: <8a2642df-647a-6fe3-4c78-4c602bd5d1cd@gmail.com>
Date: Mon, 12 Dec 2022 15:00:38 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/123] 5.15.83-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221212130926.811961601@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/22 05:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.83 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.83-rc1.gz
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

