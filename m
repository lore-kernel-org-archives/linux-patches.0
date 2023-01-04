Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7358BA45
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 21:05:03 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id t15so37992903ybq.4
        for <patches@lists.linux.dev>; Wed, 04 Jan 2023 13:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/XU5THAQUA1jHs+rNaxTxSOMF8VC0zT6pdz99GRigoI=;
        b=QNQTAlWqkTt7pXMEjr5dKggBdONYZsm54uq3wxNmYaLB5KtSX1WuSpQU7+0yHf+VhO
         lOy4yiKsv1vTPQPTfwOgMS8NWZF2kL92ITX9drJkQSTp63e6/ZiXbCuis0W6oiqdQ55F
         SH/4c77fM4TG1VRYaKmr+QKKfbVYSp337iyTRZA5iDNAIMnbA1xzQUKuJQBq4mt4OMGd
         6rsluWnpvT9+/XDFg37MdUkAvfRnQND/QNpYPd20YcQzDMkMUrrCYHN9sZxUmcI6PWXD
         8V+qDMAndrAIUihwe1V77kC01V1fKUVrzVB2la1pDeYdFeMqTeLKzLvTUUctHsvP7koK
         dqXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/XU5THAQUA1jHs+rNaxTxSOMF8VC0zT6pdz99GRigoI=;
        b=JyJ3VHa4H8DALdbBF5G48jBGExHdks3XD9xWZDui4PIPKmPNYP41Sk3T9Gbeehqm+s
         GpnCUsHvwzHuybtwDDGDAYk5i6susadDcR9tu+hbIhvZahADfVSYRvRqIPX6gqMfkR/u
         K/BNfXN+2LnyNCHpb/TcXIrMVVdsxEEM30ktInqwdjzuMyWL2AllC94W0YGsZk3wgj6J
         DNdYZnRYwNFGzzqW1oxf7J6oXKvzlcjuqZz8X8Ib2mQ6LuNtaSppbHvEz6QROlbxj8zZ
         gkhPhkp0Lr9+l1hTe7r0zQYs+UbkKVetXpqNBJV9SchAgn9XaERET4mdgSUr2xvWuXDp
         HHew==
X-Gm-Message-State: AFqh2krVROXRBdt6OIshA55h8gS32vQei1MoPqoQViKn2GCQQ2D+aqNL
	iijdUXkqGjaC8Hnaua1iqek=
X-Google-Smtp-Source: AMrXdXvTw9QO/IAB66eho0erA4De+DdNxfVRIzOiORrFOjGYCjAASAEiJauOSRN9xVOyTgiK+2OAUg==
X-Received: by 2002:a25:7753:0:b0:746:3cdd:33a5 with SMTP id s80-20020a257753000000b007463cdd33a5mr46934846ybc.0.1672866302716;
        Wed, 04 Jan 2023 13:05:02 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h19-20020a05620a245300b006f9e103260dsm24653195qkn.91.2023.01.04.13.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 13:05:02 -0800 (PST)
Message-ID: <eee5c4fe-1dba-5fe6-478a-52abb37e7358@gmail.com>
Date: Wed, 4 Jan 2023 13:04:59 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230104160511.905925875@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/23 08:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

