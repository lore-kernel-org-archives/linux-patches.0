Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F93F275A0
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 21:23:26 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6874d1c8610so1406349b3a.0
        for <patches@lists.linux.dev>; Tue, 01 Aug 2023 14:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690925006; x=1691529806;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FSkb1LatFo01kR5er2AkepZzOE9ufFWbUCqCUcrWwRg=;
        b=Tvxd4/k+ldaZr43vqe4RVnaY+c5ReOgBCT7JC+J1HYzGuey1mTjHt84IBWamfWmtPy
         mC0nomaz/Ipj5BlVYwegvYb9zHdpBu1JkB9o4jk4FIZGnGuC53SLJ4o3L6Ex4K6MkNTY
         a4alMgqE/SfA+BeOf3/9noRqw4FS/7EIXXtjUgxXU6xxYNE612gKAPlFmhXaSLh5/0BW
         +NYDZcyrelqcnCwy5fhbYcCTBcpzppqti9Takdu/8QkirBQlF/XWP6rSq/ZvuZ6n4TIw
         CDmHOS6KamxrqoGhH5wVmuXLMIZ/hMrgm1xTCN1o5kCpyfwitEntP3vLk6+t+Nk/VXEK
         xkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690925006; x=1691529806;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FSkb1LatFo01kR5er2AkepZzOE9ufFWbUCqCUcrWwRg=;
        b=EMIKu2VrZStzb7cUCiHDfNjBUjYGEEwN4T0PRCqarqSWlmMJlUcSuLB93jtTvNFPAT
         nt41wP0kFz0z71k1pg1Y4sqBd7VzNusrFzXFCvXG1mx5zeBjNlwmCA0EwSX2A7kdFikS
         GghJjFrCS4ldxSYVrcapUYJWK9qylFPcNXiVo3Ovu6lewGDY+ZUUM9BLG5z8gN+uVeod
         mD48bplePVg5JIw+e7zPmf12F90F89fhanxGXGiBIMrXKyVkgeELz2c/ZiuKHy5u1ok5
         oOuIsgORGQQB4gAi6BiXb2i+LOy7aWo3S8fVAhs7LWvBiy/KJ8YDshdi6rR1iPjav/zF
         rMMw==
X-Gm-Message-State: ABy/qLZXZmQrdZXZPwuyKR0JLD2uW6S1sLylmgaOyar08AcG/v1vwrz2
	8PiskqyvKBKvK7FSy/S6v+I=
X-Google-Smtp-Source: APBJJlEUQDSWiKITL7N+JSJRU4yDFDeczzCRVHuO5A0C0xOs0n74cZrlbzrWTNt+DYd7G5dZgEVBrg==
X-Received: by 2002:a05:6a21:4984:b0:12d:3069:69e1 with SMTP id ax4-20020a056a21498400b0012d306969e1mr11098258pzc.60.1690925006248;
        Tue, 01 Aug 2023 14:23:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n9-20020aa78a49000000b00668652b020bsm9741246pfa.105.2023.08.01.14.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 14:23:25 -0700 (PDT)
Message-ID: <3f3aeff2-0930-3be4-d9b4-0843d5fa3944@gmail.com>
Date: Tue, 1 Aug 2023 14:23:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 000/239] 6.4.8-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230801091925.659598007@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/23 02:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.8 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Aug 2023 09:18:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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

