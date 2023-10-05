Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA37374
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 00:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qc3f1xMo"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7a24c86aae3so7688339f.0
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 17:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1696467560; x=1697072360; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fixv2Hf1UsG/w6NMbxeKghikSwWK34zVD+OdqdFjjpo=;
        b=Qc3f1xMoAFn9Q4iUyGGWiuSxqZxFZsfMQeMwVATrpKoN6gHwRSLC094XZfqLwUr4jL
         w5Hour36XEKv6hLYzq43rbyDPc7m+qLKoXhDE9fJUFChIJdIFNeV3KqSVnwoW80SDrUE
         LsKb1pDTINs1yzZHFUg9gXx1VDSVy9xdFvXtw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696467560; x=1697072360;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fixv2Hf1UsG/w6NMbxeKghikSwWK34zVD+OdqdFjjpo=;
        b=Em/GjeFRhzH9FU0l9If3ZGtO2R/3afRRLACmQ4NWfobPVXNumswHgJRxGAcpT5b378
         tYB0psqbRcriBDx66qlLjwIKZUZJCquFh7eBVFe2FU8Zyc9ltzroPhxZ0l6V8SKEphJS
         HgEgY8zJky3PXaHJwttwiOtkom5KQ1Anj0722pqDEbHRQmz303C9XkFaApWGQKmtWm51
         noYn4h96HPBU4Pa7nIPUs6e9L9V63DsWaW+7Wv/zBCm6D8nOFWpC6b7bXXf5/S/Eipl5
         CTl9RRAX5HGeH8k6Gryanq20EIP+DucPV3LALRCLdbzjvJQrx3M60H4NizWfQR6Bh50j
         1nMQ==
X-Gm-Message-State: AOJu0Yw29jdSin6kMJrKlh5SAHNDUhKWnYH+ua43isXJX26iea1xfQRx
	iIPcuoTXyctShsF3R9EKUHcKAg==
X-Google-Smtp-Source: AGHT+IHF38mxXPuGgNrncsbu0//1ttTQuV8kZCZOiNVzflvIZHlwoBno7oJnsMGeh3v09VdW7c4NCQ==
X-Received: by 2002:a92:d1d0:0:b0:351:54db:c1bc with SMTP id u16-20020a92d1d0000000b0035154dbc1bcmr3791663ilg.0.1696467560212;
        Wed, 04 Oct 2023 17:59:20 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id l17-20020a922811000000b003513b7613f3sm104924ilf.3.2023.10.04.17.59.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 17:59:18 -0700 (PDT)
Message-ID: <6137d647-f1f8-45e6-b2a6-2258cc90e75a@linuxfoundation.org>
Date: Wed, 4 Oct 2023 18:59:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/23 11:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.56 release.
> There are 259 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.56-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
