Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863402F48
	for <patches@lists.linux.dev>; Sat, 22 Jul 2023 02:28:22 +0000 (UTC)
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-403aa5d07caso21095051cf.0
        for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689992901; x=1690597701;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B7uGHFjTE84Kh/AyzNxtyl3g/Y2MUZcAKzPcw06Ai+M=;
        b=QxZkoQDdmHa6SXNUxzIdk+9+scbuRhTzOBKCROB9MHPQD6lCjRNyQ/rGbtffqx3drW
         bhP/mNyZCF0DS76vf+ISwIR7rOyQaCLqrn4b3k5bQs1c5izS8sXOzQuSpnmf+CiEKr+a
         EtV2jmn04j9jQxvIjto98OTxmzMpvRzvBPmu1sBk/PUtIQS8xt1XGThgzyEl5OkcgrbT
         ImAI1nqYJ98ubTt0+Z/ZiAtwwr4HOq4vXKTLUXXpHwJWSkupaHWpP8XGe+5pf6Zh4Anq
         pVyWe1cRuJdPhTO1et6MBIpWGSXtxEb+f+bHJrC4DTD68MfZ2MxBFEOIdPSaB6tpVy7o
         bCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689992901; x=1690597701;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B7uGHFjTE84Kh/AyzNxtyl3g/Y2MUZcAKzPcw06Ai+M=;
        b=FW2Ih5UH/zlZhLy5B50qi99ovYt/Zo5GOW3oYajeK0P1L/PHIkCuD3r0w5FRh8hLnB
         eTGgC5G+ZrHyajBBGbizzvTUAOkf34TyGo2/mipARg41bvINIKQSEUCsgp2NmOxMnd9O
         JdKVWWYzTfILkvnIsFFnl0pcK4MfHuz/i3EIjLOP/bzAl80KfdlNYDtIMrP1fyybFiWC
         pAQxgdNix25MrCuwoWHJiNKbd2jEQSRaqLJ4ZNzfgZ2+ArJwMpinz4iRsUp7j/aKY4EI
         angqdytP1X9IMOxPG3P2YI6NEnQcq3t+hpepxOyvemjLtRDzKwnAtSgDlqwcMgG0vtk4
         Jvqg==
X-Gm-Message-State: ABy/qLbinL8ui+VhXime2IEsNyYjduv7zUCvLFMgpdkHAhTIVeEgbWOK
	KzdeoglViArx+sgf/WawvQg=
X-Google-Smtp-Source: APBJJlHa+px1NVCBOQO/Vi5EAq5O0Lt591JqTG+T2NeKAUCGjsp362oGRgRiId8NMg9YDUBA6wWwlA==
X-Received: by 2002:a05:620a:d8b:b0:765:40da:4444 with SMTP id q11-20020a05620a0d8b00b0076540da4444mr1943221qkl.10.1689992901092;
        Fri, 21 Jul 2023 19:28:21 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j3-20020a0cf503000000b006262de12a8csm1738616qvm.65.2023.07.21.19.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 19:28:20 -0700 (PDT)
Message-ID: <32fd768a-a11c-44e1-1b15-a4bbdbb54385@gmail.com>
Date: Fri, 21 Jul 2023 19:28:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 5.15 000/532] 5.15.121-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230721160614.695323302@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/21/2023 8:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.121 release.
> There are 532 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Jul 2023 16:04:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.121-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
