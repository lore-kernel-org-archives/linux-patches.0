Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402CF63D2
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 17:55:04 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso16979200pjb.2
        for <patches@lists.linux.dev>; Wed, 29 Mar 2023 10:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680112503; x=1682704503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nFMskmbDwPlyi0rZMeVPTGVdXdnjVvoj5ddZvdjzimg=;
        b=M0oRUUq3AEXq9SjE4Tww/aJLDdp4yDXUCOOuy9Tp4jTCX9DQw0oByObXolZ2A3c4hp
         qLXpUdZs7hYIqsghvbuZiVhDkkf/EGw815TZl38xuyplkMu0sXKjJKRMqq/Yw4/TJoen
         mCVemyoH61OHEUgohv3tKTO0En0hUmS/bn7k+2mCnAUeRkX2RdqdH5/3FxzuZMlWpaA/
         8XFNjSK1Iq2mPNqY3CZ+pazPcCFM1hRG9hUaPKbEUf/QYWKaNdPqUDxlyZgYpsI6v1/C
         8eOSHYeSu1qNOIyiGiWfRzyql0uQUASdD9OAygLFmy+EklLQo+2D60VHyXv7HwWrCoLr
         44eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680112503; x=1682704503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nFMskmbDwPlyi0rZMeVPTGVdXdnjVvoj5ddZvdjzimg=;
        b=79nWP1tTIedXBFKfNXTlW/TlW8GY4vDZwwHFH9XTWmeuW4sPxIgXf3N7HaYwBzJdyZ
         VsfThJ1qLCKz0zsZC0meFz6+evgIi/AYMY+FdXZHjGlB0OFRTFTDaa3WiedTVu+Xm07q
         CTxgc0Q+6ZgPlBIMVshc4wjwkRj9zmXlhRosojC548I+CzJKxMtGbrKowz8dZjPigZIx
         nB8KmoqcDDYg8FqIE44kUHx0KJgLrsG69JnSjlSLRVKqBFt3eFT/tuhRu66dFb8q3Twf
         YSSnd5DmRb+DQXJSvx4f4zu7g/31ZjcVbvH4bPN+yw7N5Rljgv8ChjKyjpkjuFCWWR49
         o0Jg==
X-Gm-Message-State: AO0yUKXbWSybSkavsxD+ibLUDOkWxyGBNv5iz58eX+DL6oaxFaUWEJji
	g4Pvqve0lMtwJ8r/6RGwZ1E=
X-Google-Smtp-Source: AK7set8Y6YQ8WF/DlbZ0mclLLM8Wb2iN3vrmxB6+UI99d2kpfyLc27k3rfTfXobkoiYzONoLMI3ohQ==
X-Received: by 2002:a05:6a20:be10:b0:d8:cb1a:f4e5 with SMTP id ge16-20020a056a20be1000b000d8cb1af4e5mr18322789pzb.23.1680112503609;
        Wed, 29 Mar 2023 10:55:03 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j11-20020a62e90b000000b005825b8e0540sm5682278pfh.204.2023.03.29.10.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 10:55:02 -0700 (PDT)
Message-ID: <6c54bcdc-b65b-1738-4d99-51b5d98e996c@gmail.com>
Date: Wed, 29 Mar 2023 10:55:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230328142619.643313678@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/23 07:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.9 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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

