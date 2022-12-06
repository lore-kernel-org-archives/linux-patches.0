Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D17220EA
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 22:14:33 +0000 (UTC)
Received: by mail-qk1-f182.google.com with SMTP id j13so7171212qka.3
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 14:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K2zu23twNKS54cXNdL78RlekF8d1xuGtuL1+G3LtJiY=;
        b=U6yX3xI9s2oaC0HxMDnJcLgU0zKMCKXHyXtw/lRJaog4VmLf/HKrketdBslIoMVEdU
         6I4oPOhPmChSRL8n52y05OvyL0EovhKCbJqwVtIlI7ui+3GV3GnOdKcLJN+uNa7WvjHl
         5XCA/6Pj/KJpXTW8RFgKCeHKqbq3DSrjtLeC7CmgjmWba2GbV5ImqTOqPnjURf2O94jk
         Do/H2Vyj7erufXPy7IfJykTQ1BB8nz7+CjJDbzmFOCbkTDN7ERCBs008vBEXQg0IwcnV
         NuIqd/aPOWi3vLrtLKcbRspouDiK4DVNow+nqQXCdafVigzcL/qjfpsnrbf0Y2iP4lT1
         ly7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K2zu23twNKS54cXNdL78RlekF8d1xuGtuL1+G3LtJiY=;
        b=dktLP2AO63zFeFp/J10m7pHcgTMioDSHXcyWQ/mQr7V9KSzT2op7cq09fBb2xafM4X
         x1mLAHOsiHVMoreZp8kX2YsiCxWIucnlW3hoSCOgpPVrSOKpXtDImWwWJ5BXsvKKY1kj
         qQ0crX9Awc8Ifur/jQK2+tsVDJE8T5NrGhOzN/r/0Q9YZGmWfyrP6EXs/hB2+qyh3uWI
         pAPDnr33EsXmsgs8KxdZLPpen+e7P4TlKhh49M53rKk3A5BZGRK7008h5O4sXHuU74dK
         coZd/KVNZTHQwcfZS33xzavEEsbpJiXLGrl4T08IxeMt6AV+5a53oAH/TRCwY3Ze/Vt0
         33kg==
X-Gm-Message-State: ANoB5plWBg6sOydib+q2JWiLLSBpiSZupq/KT1wQ0B3kM/R5+A2tB6fN
	4txqWavtLClH4087hajkO5U=
X-Google-Smtp-Source: AA0mqf4prugQ/SUV8HMwy28gpVRMbEQ3kHOT98e/LtOYHRIQYKwLjisCad+0hsMXRFB95KVhwkmapg==
X-Received: by 2002:a05:620a:3720:b0:6fa:faad:2008 with SMTP id de32-20020a05620a372000b006fafaad2008mr62815393qkb.668.1670364872274;
        Tue, 06 Dec 2022 14:14:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bm1-20020a05620a198100b006fa2b1c3c1esm15931304qkb.58.2022.12.06.14.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 14:14:31 -0800 (PST)
Message-ID: <df796897-fe12-4470-8fe7-63d11eebf5ce@gmail.com>
Date: Tue, 6 Dec 2022 14:14:28 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206163439.841627689@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/6/2022 8:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.82-rc3.gz
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

