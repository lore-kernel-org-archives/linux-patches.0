Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A056624505
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 19:11:33 +0000 (UTC)
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-40fda409ca7so433701cf.3
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 12:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691608292; x=1692213092;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=39V1XP/MDO5emu6081lH6KVDmQxsvOMhi6iEGD0/k0U=;
        b=gjFv26sMM1eHzEtxx2MXwogocNkgovOz8URBxYoYe27GmwXNajwtgSm+orytKW12G1
         iISROCzHtKwuO8/dJMET4rnSkW/br8jXA2tigNpLSk8jr1sbD5ZcKT1uvIOAJL8a0dYf
         ZcXa9mrTBECaoh9GN4g6wxHAFGEImOCPfK6fyiOZ8pEDxUPLC87+FVFutkIVCgSPCmcH
         UBN6vqmqCRGM1HoDLT1pAnJ3ttlFvn+8wQadKZJu2LzO4p/SwT0jPNG/sxbvkYviqgmP
         2M7BMKBACmbL4CB0olPxXNTysUWXUOlbjxPL2F0OkTei02SBNKeUlVDD3Dj2T1Hd9bP4
         FQgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691608292; x=1692213092;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=39V1XP/MDO5emu6081lH6KVDmQxsvOMhi6iEGD0/k0U=;
        b=FKhdO0+MARtcJPWo85DU9K4yUHOvZmIfOY3YZesXQ6hQ+t/b2XkJo8NeapTf5jYB6f
         SEF4brRap09/93IXwtN9QnABVmh+Cknvs/wukDm8PJw4nSiCxMDo5rU3rqefIg7ukbuN
         TuW9DsJp+8XakavzV4aWyz1ox86UZp2jcDikUvzOUqFXHkPzlJim936k879w1Fx7Wt4P
         Syzn4T6FIlke2Ql6s27wSrMt72IA5DVeSkX8M+YccUjsYD4mbDHwuy7H35+MwtMKQNpu
         OEcXK2rm1VHZVi6hWaSADtGay6L+A+dKA+lzocRndRK3JKHYfgorHJaaAQJdMXHdJsUX
         9grw==
X-Gm-Message-State: AOJu0YylLlxdsKbRHUycMk6052NKpKAWWbYGrWSA7DP8upeDUGQu9D5g
	He7B2HssPKBO5NjpxdYWQtE=
X-Google-Smtp-Source: AGHT+IEoDHHTd4iwD5s8iqaRVMVdpuvTq6P/qKBXPGbYljLoS6mP0Z9g307sIC3SkJPsJckDQW1L2g==
X-Received: by 2002:a05:622a:5ce:b0:40f:dc70:fde1 with SMTP id d14-20020a05622a05ce00b0040fdc70fde1mr334170qtb.18.1691608292122;
        Wed, 09 Aug 2023 12:11:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z23-20020ac84317000000b004100c132990sm2538301qtm.44.2023.08.09.12.11.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 12:11:31 -0700 (PDT)
Message-ID: <a7457613-7e46-bd41-a825-377fb2266740@gmail.com>
Date: Wed, 9 Aug 2023 12:11:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.10 000/201] 5.10.190-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230809103643.799166053@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/23 03:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.190 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.190-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

