Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89123A28
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 01:00:30 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id i80so157616ioa.0
        for <patches@lists.linux.dev>; Wed, 30 Nov 2022 17:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gq418pOxGsBTfRyr8gCSPbFR3N09kGLIlLy3UXEsQeM=;
        b=L3Xy+1GjYg6llIu1tdWJwoUyaSwgJMiWCAIHwKXgf4CWBAxkskW84a7pOq1CxpUStK
         tTcmTQbCzmwIYPDWOtM+iwWzkWcCGYYiNNzEeoRTFQ8gz8LOMoSQKKNZyS0wdZOMDrQ2
         oHVg9MVdMQe8C7gdWEpGZAmlabz4c4+yMVHSE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gq418pOxGsBTfRyr8gCSPbFR3N09kGLIlLy3UXEsQeM=;
        b=x6gTpaTxE42DORtb7S8lpkmo1GgnVDG5eWD4zeH0m3P3QKjVnbFsIA3B2X4CNXJZk9
         lvyXqbp1/4Spw2SRlu9VukaZNYNGqS8Jb2/544iS9XEAR4/+CylvgR/cGNQOLvoyoSjW
         8qZTSw9mtkxTCwKlLJqk7XPOvMiuZdCm3abqcv0eKzL1uu8oTkXobCuUWATrsnwHUpVk
         WKO1Uh2lGiqnstmI8NmTS0XYXRcXhnUQYb5oscmDFP0AgkuCc6u3iTsZA+mzfcQNOiUN
         keA9iAe0Y+liWjNjbi2tLSMJsb+xebdQKFv9vdmL4KK1TY8g0PIvhRo3TH5IM/tC2Txj
         SHCg==
X-Gm-Message-State: ANoB5plhs8kt2bDQbGqjncumKU6TxiCDNsvZFhpzFNj3VWHqE34kBY5S
	9+u7aqlG6oUSp+s+BKc1MMxJSA==
X-Google-Smtp-Source: AA0mqf6D3VNev1EHeQDCHM26HLKhO/W02AerFY7qEtCLM4S7Cr2KVt4WH6uXCoIVBlnC5RdCVHs0Ig==
X-Received: by 2002:a02:3f60:0:b0:375:2d83:f970 with SMTP id c32-20020a023f60000000b003752d83f970mr29200510jaf.205.1669856429573;
        Wed, 30 Nov 2022 17:00:29 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o1-20020a027401000000b00375126ae55fsm1104248jac.58.2022.11.30.17.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 17:00:29 -0800 (PST)
Message-ID: <58bf2dab-0832-86f9-9cee-c1900c862cda@linuxfoundation.org>
Date: Wed, 30 Nov 2022 18:00:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/206] 5.15.81-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/22 11:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.81 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.81-rc1.gz
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
