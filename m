Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2208E8460
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 20:13:24 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so3418459pjd.5
        for <patches@lists.linux.dev>; Wed, 30 Nov 2022 12:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nKOpOs+nm7ZzH9JjlfBkovi5sBxujs0tny+wQJDoQrg=;
        b=p05GXhfJD1Dz4nT+H9iQPs6s28q4PBydoI0JM6DXF2VvA9h10HLcCM5+kJ80Ksij0C
         8omDXH7ZIzEgQwP4BThhIHpDeNe2GdHuJAuyErQ6pGtpsrf9FXp3zD02gMIFzKCPHNXm
         FI2QXOmx9Or2SMHPufLnrE57RkPYjPfetzQvyxvSKXURywO58EyfGEzezvx8ZzB4EgrZ
         7DYEvHUVjXCzGGhclaKVBpndVnbZltwtBbR4OVGYo7MHNKLxT5/4Fk3bzNqhXrtEiIBF
         blB9vnP990lxbMJLNNtSBfR57HV+TtU7SjmxAI0Mx3z4kXvbnb0xNzQsZ3othOb/cU8k
         ghJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nKOpOs+nm7ZzH9JjlfBkovi5sBxujs0tny+wQJDoQrg=;
        b=pSdYfiUJoajqs+Op4cQTcH8c1t+DNoS/Yn35rnbFejtvO9B737k+pjG9ZADuF29Oao
         E5u+KAdFHvqxeh8QczQEqLksdWWG8rVNDx/AScPlhjL++38bRNDaBDvnT9GoAFjiwoWO
         MTvQlff4g0fgCR/gMt2z6anRAxhqaYlII6BZSD32qHhpCd1Xd/emoDyBuuX5IqEHOwGh
         ftxlNZPr9DdvtWLXhvsbJUL/L2ne5qY4DKYX/jniX1p0wSHlCAGi9r5/+qEbfXSwE04V
         /thLTSQl32PGczfTFBpmGWRmTeQmorKX82rj8mUn58rD0okS25XOfRDkBjyQVSYZ97nO
         a94g==
X-Gm-Message-State: ANoB5pkoRpblEiFLebv4SeTHtbCthjfSUbXyKV90w/nbCMaWAXfxiEfW
	00wuNV14I9D0FpSvU3CauZI=
X-Google-Smtp-Source: AA0mqf7ZcYjKFLIMP2LqvtdUyjalnj4NmE4TYogKrlRqJyYddNSDk3DauBBh5BDD9Jd5kKqnEAUmOA==
X-Received: by 2002:a17:902:a9c6:b0:188:52df:769e with SMTP id b6-20020a170902a9c600b0018852df769emr43061154plr.30.1669839203509;
        Wed, 30 Nov 2022 12:13:23 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id nn7-20020a17090b38c700b001df264610c4sm3050895pjb.0.2022.11.30.12.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 12:13:22 -0800 (PST)
Message-ID: <607a25cb-a121-1bb5-4203-e9e526f49fc8@gmail.com>
Date: Wed, 30 Nov 2022 12:13:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/162] 5.10.157-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221130180528.466039523@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/22 10:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.157 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.157-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

