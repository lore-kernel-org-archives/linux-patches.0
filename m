Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6CCA938
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 19:40:10 +0000 (UTC)
Received: by mail-qt1-f178.google.com with SMTP id t9so3049937qtx.8
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 12:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678995609;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n+XnBvJUJTWnya1MYL5S2OxPlwdWv53niurueuHio0A=;
        b=iKh1rPdqlbX/xxnDzvT+UE4aKcURGs2yU+4gRJG6ggrk8Cmwyv2qfv9IFoqHuuhwdc
         0KyC9APq9eqmjaVejcn3ghNaS0ZK1MDOmM9yBZm4RaiJR4gTD4wpkAB/SBODbvR90MXX
         S1TQtjzfSEwLnNESZbo/OCHhhkqIR76eilrvYjjkvTkAl4UcZjB4qZ8wru79tI54ysSx
         xoEMkeuXoFfH65kssricsPaMuZQqBpy24rapG8g0nzDvTfUG0EegdpFOdH6CQTXbolXa
         Bd7XFdGvBRK7lDAahfr/O+xzD2S7tWVWAjBP4JSegNu5X1LBY9qbBZRXgm0EWfHp+ADg
         +dug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678995609;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n+XnBvJUJTWnya1MYL5S2OxPlwdWv53niurueuHio0A=;
        b=oHxwxX+IWn/LULg6kjrvsywZGVFEW9HEbsZI6lZ53bP+xafo1erhAFlGo/fopj4KBN
         9oXX4n5wmuNJ0arnZ2oT4g1HmZCPflYt5xJyvYh5RCu9IWVz7upcRF69RJrguCG4L+x/
         BT7ky5ze/dUqxKcyQFZQiVcxNxll3DPrLTDGCLYnEthAli/W1JBIsKYszcTds6zylQWh
         uxUAcj6FbXwZY6nv7tru4KdxijR55PRs9v2pU9vprW2rSA0eMNHE+i2d1auWQm/Gd5G9
         wY6CrweVLzMbySV6nIZpoaZcsWxAa6EuQb0XRESkxM/rxZIVLSkX0gBNTzHDJNOJj0tn
         ATgg==
X-Gm-Message-State: AO0yUKXPjsOrV1XUiDZ09DgA9H4GPs/J9Kr4jsfmpagm0OijMNX+NEQK
	5DUqNqSAelq2eIZsADX6y4Q=
X-Google-Smtp-Source: AK7set86hl32NSuisw5Js5aMqBkxp8RbQwciHk8OLlHpwgoKYJK12tcqN/ArZ0Lt4IoynMNeUBRDQQ==
X-Received: by 2002:ac8:5f53:0:b0:3d5:b00b:13e4 with SMTP id y19-20020ac85f53000000b003d5b00b13e4mr9520125qta.34.1678995609516;
        Thu, 16 Mar 2023 12:40:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s128-20020a372c86000000b0074374e2b630sm135748qkh.119.2023.03.16.12.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 12:40:08 -0700 (PDT)
Message-ID: <709c7168-7465-9a55-e2cb-d24071ef894d@gmail.com>
Date: Thu, 16 Mar 2023 12:40:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/140] 6.1.20-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230316083444.336870717@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230316083444.336870717@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/23 01:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.20-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

