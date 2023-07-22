Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3F7566D
	for <patches@lists.linux.dev>; Sat, 22 Jul 2023 02:52:35 +0000 (UTC)
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-63c70dc7ed2so17601336d6.0
        for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689994354; x=1690599154;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qUG04+YmfFxE15oDzUSXYZTpUikUCYUSbud9spAPUKE=;
        b=QJejqC/MF21jTryUqaR2+bZXjnaEvbpaKy6QMlAaPuq973fUT8j9oKAr4qhiiDItpj
         uKro3Z9Mzn+PvvRFW/8czGi44c13JWggwh6l4o1p35zHGGI/Ijh0wSegGHweqLkZ4Ax3
         1Fu5uP5WgADn2hER9EuwCejtMlJYvV1Q8NGtQpbiBmGeRmbkv8UC5ZRWmEahpYw4PUpi
         1h7l486SqUVufjbIDY2ZDBE2zSn5ItSDKTZLBZbGHuFDn7zFAADTSxxlRfhx00dGRhSi
         18/WMbJRcP/L11JFnroIQVDSuhfgTJTmzjxV86tpM/J+KZPQESVfp7xz/K6j3EXdgZfz
         0LcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689994354; x=1690599154;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qUG04+YmfFxE15oDzUSXYZTpUikUCYUSbud9spAPUKE=;
        b=DNbIddH4HqBj30kCZAFbLdvK8MxglC1pORas45VmJi7T5mlIwobH9YfFLjju7f7FZK
         hejOjGTC2FU/wlvtOPrcmnJla5ysb3JJWowVID2OG5FpE5svLIuoAG5TmMObwDA1IFE3
         V6y4cjK8384A2F2NP7WHl0sVI8/ktZXdzISmGKU5VZstROdel+Wdv180QfPf5ZdjiGYy
         httuMGS1yxNWYjgCiGa06p+fjeFPNJ3NZcJyD+4OnS+zpR35dFzKeXQ0MTueGK5yGQcw
         Uwdr7ZGKwL1Bg8Yg1irPI3XrAfMf8Yo7eDAOPNauGWfN0H4GZ2GsWEOsATTeuG/XbJ7c
         z3Qg==
X-Gm-Message-State: ABy/qLZY3P/1LVWNOPJp7XNyjAw33r26tSo9wzOOLPIE44FziIm4ihEi
	I4vbhraKt2zp16kuxXV+dVQ=
X-Google-Smtp-Source: APBJJlFZg+i5rB5C4vliqzg095KXisFSeRMfMysADhQy5/P4UyCeJmD0fz0+zQvkU5Dat3Hl+wV0Vw==
X-Received: by 2002:a05:6214:122:b0:628:8185:bd6e with SMTP id w2-20020a056214012200b006288185bd6emr1770270qvs.5.1689994354354;
        Fri, 21 Jul 2023 19:52:34 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id o10-20020a0cf4ca000000b0063cbb29731dsm1750238qvm.66.2023.07.21.19.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 19:52:33 -0700 (PDT)
Message-ID: <b171db67-3a3a-577d-6fb9-cdc3be5f2ed4@gmail.com>
Date: Fri, 21 Jul 2023 19:52:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 6.1 000/223] 6.1.40-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230721160520.865493356@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/21/2023 9:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.40 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Jul 2023 16:04:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.40-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
