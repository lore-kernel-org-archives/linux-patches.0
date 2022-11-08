Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B888BFA
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 18:43:17 +0000 (UTC)
Received: by mail-qk1-f175.google.com with SMTP id 8so9652320qka.1
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 10:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PtoLKDqZk6YGo4O6fsSrtf8fgQpGeTylIRV82dKCceU=;
        b=C8XvKhCySh7qziSygF7VPkutQL5e8CtOU0eQeJwdPS2chWOlyy725difZTU/vI37z5
         WxUv1iWx+Vn3I+SCL6FZahIKZ5rWe2PJXQmbFpCQVafH54tfNLLJqVCSjebPUfKZFq7z
         Va5RKWMRFCycsjvPJHzzOB74/I8BwHPntPRgfKTMqWuMDGip0DN7YeIAT26p7n7c3s6K
         vglDYpnHLyRlK8SsZF8iO3HhWavjI/C6ZuNQP2u7SwicTQ07w2KcdS6QUjK6TYbf+YM5
         gtAkqkJYtNcNKnsbCzBsmDGIHgN3gVu7yGn588Q2TdYTSgBGT8YrTTGI7OMXxtH61ozw
         5e5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PtoLKDqZk6YGo4O6fsSrtf8fgQpGeTylIRV82dKCceU=;
        b=e7tYymG16EkBy7ramHfC7RbTyPsTcRHhyR02wxPDsULcQS+FabseY2VZPsIrllhKp8
         2tMpTCB/r6adcnxjja1GigkYaEIlIg9KK08PgdfJDVRX1mYQUb2cVBoruuLVraJg4SMC
         jF7rKJW368puRFO1GnqUsTq/Guil4TJckKyZGCZZypzET+14uDxclm1k869Joa2YvAvQ
         yt0V+FndwYGCh8GbSiC3rOXMGpmUjzXpjfpGy1/SzAroBMwPoJ62F3LlOTdnQEifDzL7
         vr1ZqYktjP6FJF8zX/7WSFVVlnnxlXMr73VRkAWLw3XcuhscOkmc2w/9K2Bb89ZrFUX1
         X0FA==
X-Gm-Message-State: ACrzQf1Y+r5n/CPJsKoWIMFKLaP5YgA4nV/v92w6tQLGPExvxAa/DYTg
	IbO6+p3YJpJm2u9yGnTuJnw=
X-Google-Smtp-Source: AMsMyM5a1hT7ZIubLdZ92WzBUadXmRMI+jFp+dojXhAVyeA7i//2eKar0AAdkVt4gOCb3KsWTr2AJA==
X-Received: by 2002:a05:620a:1529:b0:6fa:343a:17ac with SMTP id n9-20020a05620a152900b006fa343a17acmr33504193qkk.632.1667932996118;
        Tue, 08 Nov 2022 10:43:16 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bq33-20020a05620a46a100b006eeb3165554sm9532256qkb.19.2022.11.08.10.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 10:43:15 -0800 (PST)
Message-ID: <ec67df01-43c8-ced0-01bf-7d64adf2d69c@gmail.com>
Date: Tue, 8 Nov 2022 10:43:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 00/30] 4.9.333-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221108133326.715586431@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/8/2022 5:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.333 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.333-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
