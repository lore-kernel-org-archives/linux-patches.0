Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218EB3D78
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 18:37:31 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id p24so12564072plw.11
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 10:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wW1tsa2Hnp3P1GWVwzdIWLM1NxPlTw0S2OAEx5AhVoU=;
        b=AQXptRLJFz9FwQXcENcl6AV6MZOehry/yk0yhw4JBihaLWNOkgBRnbKYQCWwq/amr9
         jXj4JN2Pr4z+79/5BVReJOmbHFHGcs9/5MjjG/JlNPNWCBA/bNVVLYDWFvHyPjZEoPaL
         VvJkbkSrDGL/prZSRPVfdFcjdUxeeQuP825FrHYV7FiZZB+be7rj7lmfrh4i9S9KS6n9
         MqR/eDMOX0OnRnCboBXNJUxX3NwkYgPW/hbcA52VYpDX3aQInsrxWUKUaqR+ShawnuPo
         1tIGpYxshJAFOUg5CcMCqXSOZyyGPm/E92k0Sxw5U2+0AD6CW4+eORwxhuGdhIhQ3L/6
         KYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wW1tsa2Hnp3P1GWVwzdIWLM1NxPlTw0S2OAEx5AhVoU=;
        b=SutVHDBn6Rsm0VOBUtBQB3vB07HSjH7Gl/8hGVL6jGkmK6TqlaEUkRsHfNSlu7MFkv
         vN+uGxRpr6DgRHJZ8DXCF3+ylPZuxBi/eu4gpTLzqLqLi/lxykKEBaQXeiJbg1AELpNh
         6fomfLM9L+iAS6bb9i6IPeAHAqKSUmIz9QLESS/MP6A5rHNK6uxCOTQAZKeVy/EOEs3o
         E3yAH+gDGTvepWtA26n9/YkmTN6qFoa1BBkPN9YmNBiS+RbF6iiFy1+vGHbhFusF4lWr
         3mlqqjNGUkmb8WqtM1pNvpgXYeAV2qcGQt2H4YRNdEokUmmjNS5wjCXDgHanN+cWVVIb
         8dHA==
X-Gm-Message-State: AO0yUKVDjgw/YgKUbg3lr1e0zRdona4hmdqtYmVdXwBn3aCrj7sFYnRr
	SVE6fRjE3CS7vXMd+imlrVo=
X-Google-Smtp-Source: AK7set/nxjDGie9fQe5omE8Qq4tphgF+RSMeOU2xClnZVYV7qhG5A1jN28MGTSmAvLl3/jkFQ44pPQ==
X-Received: by 2002:a17:90b:1a8a:b0:22b:b3df:d970 with SMTP id ng10-20020a17090b1a8a00b0022bb3dfd970mr11020832pjb.44.1675103850407;
        Mon, 30 Jan 2023 10:37:30 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d5-20020a17090a628500b0022bbad75af6sm24743804pjj.1.2023.01.30.10.37.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 10:37:29 -0800 (PST)
Message-ID: <34681bd0-2b66-fa6b-9ba1-086fb4a66969@gmail.com>
Date: Mon, 30 Jan 2023 10:37:27 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/143] 5.10.166-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230130134306.862721518@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/23 05:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.166 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.166-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

