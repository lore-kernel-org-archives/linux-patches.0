Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC096813
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 00:16:57 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id y3so5624748ilq.0
        for <patches@lists.linux.dev>; Mon, 19 Dec 2022 16:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C/RaklnAfUfx6edHmjpBynJ3wYo4WviqyTuTdW1L/E8=;
        b=WtpMRvgIvChEqw0Nzb/Z+uxAbZjxr/zODgoyWaUiXFV0TNATKe1omN/COXMQDnRp/A
         HF3hKDY4l2C9HzDO0rWrJzqEwovOhv3i/7YsKleyJOP69U3+7IzsUXBX5AFZ1Zj6qVtg
         fdLspl/xVxlWij9yBHcgXI120mdWE8fqPr4Ew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C/RaklnAfUfx6edHmjpBynJ3wYo4WviqyTuTdW1L/E8=;
        b=sL+h7u1zpcNlDa42cjjlskMGkC2i8gcNi/iL6nKjiUaCYQ3mn3RRRTCsoffbXImj00
         2rYZPW0ovQYoUZobb8rtQDJ78QMOWiw1BI6ZQ9he2tfCn1+hlxT/XjimCubJ/zukwJ10
         a9V+FQmkNTI0KgrTlb99hOXXkqTysIeH4Ie1a7fVLkdEhZ2eWkjp26zLTzHxyHwjT2rO
         4tZ9Wewg2m+ZWcmF9lPcQRFnmnq7m+Bb9mHEDA6j5Z8eGLDeP2L35Wf5HI9GwCFF6If5
         sWKc5vlm+Ihur7Q/SuXnEbzgWDWvYtULxUXBIPzUe3mwVVo0l8UDdrVmfN2u+E5UeDs7
         wkkQ==
X-Gm-Message-State: ANoB5pnpFCgzrUvAG73s+AsJJRRmEB75KfTUrao1fm5QS/3/7qiafQME
	Swr1odGLJyJbTL9NVIicYLyAsw==
X-Google-Smtp-Source: AA0mqf48fLGl9MyVH+EY0ECIuj3ElIASjyO+JHfQSTdtV5EP1km3HGz289tir9wgfqxrmfUnpEV0SQ==
X-Received: by 2002:a92:680d:0:b0:303:8174:ba2d with SMTP id d13-20020a92680d000000b003038174ba2dmr4500476ilc.1.1671495416763;
        Mon, 19 Dec 2022 16:16:56 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f12-20020a056638118c00b0038a0c2ae99bsm4030059jas.18.2022.12.19.16.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 16:16:56 -0800 (PST)
Message-ID: <f1cd38c9-5f37-4dcf-894f-d912ca235074@linuxfoundation.org>
Date: Mon, 19 Dec 2022 17:16:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/22 12:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
