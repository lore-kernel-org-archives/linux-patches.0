Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A718364
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 01:50:40 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id d3so378467ils.1
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 17:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c/phn+ucH2E5hiYwyWGqEcynq1CJyuXRI/MGTCfo55A=;
        b=TfYZg884i8XgJmxMu0km7Lf0jW7T5OjXUFSTukx1NYoRMCMtUP8ChfOQPflNg/o47X
         ULZPg3hCVBHRH7tpXlAAThHokoJYvodSqDlaDBRctKWKjgAGBRyeJmc9cswjnN3BB3mD
         hNgZ90rezKSi2AgmwchVihmPgjk53vjqh0V+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c/phn+ucH2E5hiYwyWGqEcynq1CJyuXRI/MGTCfo55A=;
        b=ClLvOKvZOPDlYudj6M+S9uax0rHonjbA3xTm3tm4noMvIMDqaLbBQVTLWqLgvnMxNF
         kAyrN3xkntHOGTNeOKKxXRaTvBF8VbGyxbyrV8Q2xqxiP/HkYYYP1POE6IjZsBr5ON0p
         6mjgF6l4FUHfJ/zLYnaKWjOVzAO3fVLMPliBO/RiW++lLQzqfm0xvjyMg+/3fv3zIxX9
         t/JASzd15v5uzHdSWmVTjusRQs5etlv6azsptmoQk03s6daOgew2mlj8A7gic+aY9Atn
         i8lYgavp0+5XQL7FcdeTKU/xgdWFCCApSOO6y8cY0WIxJrJKM8+InJa8zi8CHrdav5Do
         XZXw==
X-Gm-Message-State: ACrzQf2wt3BTsJTHCLulezh/WzlqFwU1n0cNkBarmneKjqZ2npRHzYW8
	QuL6JKkzz1BCsX0LLRzkyK7ntw==
X-Google-Smtp-Source: AMsMyM56Qd8pkxkQ9+Hc0MKeAlvKU8omVvSe5nU+nKpDdXeoy3SYIPKNvgyBxg7HYfv6Igi2r4k6+w==
X-Received: by 2002:a92:c706:0:b0:300:f49f:29b2 with SMTP id a6-20020a92c706000000b00300f49f29b2mr14424142ilp.207.1668045039602;
        Wed, 09 Nov 2022 17:50:39 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o15-20020a056602124f00b006bba42f7822sm5990373iou.52.2022.11.09.17.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:50:39 -0800 (PST)
Message-ID: <1bb739d5-4b5a-181e-b6aa-528beea8efda@linuxfoundation.org>
Date: Wed, 9 Nov 2022 18:50:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/22 06:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
