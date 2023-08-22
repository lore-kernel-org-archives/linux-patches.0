Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEA420180
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 20:23:36 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6bc9811558cso3530856a34.0
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 13:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692735815; x=1693340615;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jqi3CURD1i8JRUxuB5MEXSey4Yu1NRacqMjmHXpb1qA=;
        b=aSXkQr2s1RA5cBAyhs8eZgXQWhEROgEBM1yN6Ve2691jUCUqbRIqt24CHWtZdWN9nv
         oEP/l6SIlZLzCy6JFtBKllAi0H8u5IZEDwdfyasmUeldWda3Y7cIGn2ldfoRck39fcZj
         AgUxglBO88vB7pFCug3egYT7c2FKX3eCM9sENBv/VjiKm8hyr7kLRuVWHTY6+81uuJAn
         J5r2kJ+7Jygi2TPWMSajEl9XHe/31i3lggdvO37mLhWbfKX42yU8k+xC4OQxQgO/Q+ha
         Vd0ULCrP7ophvNZw4jeJvKsJcA24uVw4jtYtlPy5ENJENGu8It1W4f98spTTCTQRdv+S
         W4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692735815; x=1693340615;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jqi3CURD1i8JRUxuB5MEXSey4Yu1NRacqMjmHXpb1qA=;
        b=NEgGwmtnjD89cqh1eIpCa6k08fmJ2l61kQZegOqe4xl0mSUCS4z12K4iNrBiCeeMqv
         ydTx0AVzjZc+jLq9b2ZcZmYjvAkEYBz4Aoo5SBOAYABI0nmQyDlltdp5x+uU1cN8cjPv
         Ucsi2/T08/TjiXYs39or6uIcVv+tlyWzlhYLL/Jp3dEaIR7xXOf5/yBuFQPBFX5Is7JZ
         QpnZy10uKSp5iUQOm8/OeRJbXWYcdetx5c6APkWFLhJTdhMDCs4ebAlouTJflOXUr6Jr
         CoHUppWLhFlxlumVqmYdbpqy40KvYXcQD+q4WoXNGOfce3tjOVl7BopJQfJvEQgD4JtH
         JjqQ==
X-Gm-Message-State: AOJu0Yx4J9+zzNs4IWo91r15gCUkMcy22a0FZn/8BRNAA6thqQ7B94A7
	mL0X0duYoHDDofmLoGT0Tvw=
X-Google-Smtp-Source: AGHT+IG/FGtyCP48fro2CrnwocGv7TDALAy+pryH74Z/aT+ZSu5UWrreZjVZYosdOw/Z/3FYMNZ/pw==
X-Received: by 2002:a05:6870:2188:b0:19f:6711:8e0a with SMTP id l8-20020a056870218800b0019f67118e0amr13111471oae.32.1692735815183;
        Tue, 22 Aug 2023 13:23:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b5-20020a0cf045000000b0063cfe9adb2csm3293671qvl.108.2023.08.22.13.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 13:23:34 -0700 (PDT)
Message-ID: <2333b38a-fe55-7972-0418-c5946dcda672@gmail.com>
Date: Tue, 22 Aug 2023 13:23:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230821194122.695845670@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/23 12:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.47 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.47-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

