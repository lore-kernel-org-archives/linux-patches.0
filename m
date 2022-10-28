Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1FC1FAE
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 21:36:26 +0000 (UTC)
Received: by mail-qv1-f41.google.com with SMTP id u7so4889349qvn.13
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 14:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ptgKXNOvVB6PbV53scvMtsEClwOJGtunD6zgcLta/DE=;
        b=XK0mKE5zxjsWxlXxLJ+D4Nz0OWg3zHauWAMaLwfwCMYfdWnx7FCs571SJGY8r3ZV8s
         t8BrKHDe/sHIzgr2FtoPvjASTR00bJ0t/Y8m4w3KoahSmT3XNAup2J4u7yrJeZ6QJqik
         VQhIFNPnYvAyFk6BraWPLCHpXKZaNVARPXEjcRaTPXuGIVMy711HI1wdnRd+AcVF3gjB
         hiT9IG9ItEOMdKTstaTIR0KIxpPoeOOxMM+hR2HZEtekJNR6kC0Vp/RXoiqsDE6Btn3m
         E8Ogx0F892+X3YNqzqQtYOfm7p+g39qgERSEhp4NNrJlTGN/EYzaDJZAqkmH2Hh7IHau
         89bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ptgKXNOvVB6PbV53scvMtsEClwOJGtunD6zgcLta/DE=;
        b=n8sfvBDoJrdUxlY6rCHbTtko06k7qJ1OAb5SJu7tJzgYaR03AOY8fzlgIj5CIxeu9c
         chjgcHwPJOk00fluZD7TfXFFN+VJ3UQqBRgJMC2DJ8EM4MUIdPkDjRzFLiJlySle+Zwx
         oRZLTCqnbXxFjhYFJzlLrzwir7PBn6ziAgw/jT5g0EOv7S2FXMGVOcL+mR3B1YmxojEP
         ozjRO7kY9rb19mNs9/GOjZ88Lw+ylwE363u5tYpOTYn7MX+JHpqPrLE1K8UNJr20INJ/
         P1C4cHMqYC0taRO1V+h0WSepfxUc5NASA3wIUROvzOBTwOtULvW6/3J3dcTN29imjZ+I
         r16A==
X-Gm-Message-State: ACrzQf3NomwoKM0qSRTwUOGR5lKtst7gjMJ6TSuGfvMNJg7QphV8c6qo
	cJQjafCHdhRNbtXIKN9b35E=
X-Google-Smtp-Source: AMsMyM5ovq+HR5dxwlw797hJEH1SpQL2aktfFDkfQUfuthmvN4hAekR5L4CJy62/bZ/Q3AsaIBqVSw==
X-Received: by 2002:a05:6214:212e:b0:4bb:9ad7:296b with SMTP id r14-20020a056214212e00b004bb9ad7296bmr1396366qvc.20.1666992985722;
        Fri, 28 Oct 2022 14:36:25 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dt5-20020a05620a478500b006f9f714cb6asm3534788qkb.50.2022.10.28.14.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 14:36:24 -0700 (PDT)
Message-ID: <d3c97307-04ca-6ec9-90a2-5a27e895c98f@gmail.com>
Date: Fri, 28 Oct 2022 14:36:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.15 00/78] 5.15.76-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221028120302.594918388@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221028120302.594918388@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/22 05:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.76 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Oct 2022 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.76-rc2.gz
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

