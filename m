Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18558F5A
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 23:55:26 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so14753942pje.5
        for <patches@lists.linux.dev>; Mon, 19 Dec 2022 15:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ewrt7Tu2dG2I0FDKOllwvcmNmcWnML9QPNK8CLYeRiM=;
        b=HQ4EnrT/s4nPHdWsFql5skdCrRXLk+L9dEu9OCOo2s5nq3JyYMRL82gh07objuJFUh
         suP333QZs/R69wyT2xmOMR6daoN3MbLuH3AGKrS2Xw05ZOI9OY77fOJO361p5Sq2R3uz
         urLQvJh+IckaOkmPvPTqjFxvUxijvHo2kWaMllRfCfLtf2Acam5xpJV4j65eMvmOo0rF
         RHUcqDc35LcdPZ/DJBIFLHGZPnIZiGyu73E6nlOZOljfjsIzs9JnFoHHxhwYKZ25xFtm
         A+or1LrEzvk9HcqT3p1cuAEZ+2I95zywp4xTP5waw/VFdB3ax0viEPUExD74FK+HGtwt
         /YVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ewrt7Tu2dG2I0FDKOllwvcmNmcWnML9QPNK8CLYeRiM=;
        b=w+Cc827X/vqYV3qURJEx+jseDFPika0dFq74fcl84Ljt3uuod6fniRx1LYKaEte71V
         0WO0ZI4Af3yEj4YLzh5rXFtTHk9Q0wscZkMxOY0KCislNqTf89ilJRz0kzOcZPyiBUDH
         pAoM08YsqpgksXH/cOlpycGXI131DJEFfoIooe4uJw+I7QxKCiYPhKSbRi0sSX/yvt3r
         L8/r+Tlqc4BJtGvItEjlPYwPHOKYW99JWrnIjNr0N3NX2s2VIE462mKzLVb0vZJbEiAT
         CKTLqcoMlRonDfuD52KYn7ixoCD/s7jLql6OQjZSqCok/Tp0weZ3MStEMU9k0tpiFvbp
         6brQ==
X-Gm-Message-State: AFqh2koAnhXtSmv6M1XJS4tNwgpcHr4cHHALvVueP+CgRoqzXA6fmu2w
	i4NFEO30zgltDnenx6Zt8XI=
X-Google-Smtp-Source: AMrXdXvhmocJXGxcf5d36b77n0hJTZQQff5bxeTe0wN+6jnURk82dg1oAL65YPAlzlcuSJqhiW7eyw==
X-Received: by 2002:a05:6a21:3a43:b0:b0:1e9b:e932 with SMTP id zu3-20020a056a213a4300b000b01e9be932mr10533668pzb.40.1671494126062;
        Mon, 19 Dec 2022 15:55:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x35-20020a17090a38a600b0021896fa945asm9840431pjb.15.2022.12.19.15.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 15:55:25 -0800 (PST)
Message-ID: <bbc2f1de-0fc1-27b1-3d3f-3f0b87017046@gmail.com>
Date: Mon, 19 Dec 2022 15:55:22 -0800
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
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221219182944.179389009@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/22 11:22, Greg Kroah-Hartman wrote:
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

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

