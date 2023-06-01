Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2576323DF
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 20:28:00 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-3f6a494810fso10712411cf.1
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 13:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685651280; x=1688243280;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y1RjFi/W1f7sgl3paboD1lV9ocRDdeU8mWNevIj8PnI=;
        b=deIrJkmBVMrCX40M5BJOR8iYCSxiDkZCKsrjkZAKVj0r8UQdByGpzDeM/bV5KhJwc5
         G2rJBNBXvoHfKiDq/vJ4mBaLAbWgApmJlv4PMIiPIyLMDXn0wDTN397aCNEU4uaIMVb5
         OehkcgwugDIc2WKH4nkTw1JAStW52LI2iyfiYZ6LQfkNVhlJ4BK95jG8jAq7IbZvMWMO
         gby7vu47BDCyThVfV/z7qMQ2w+JhUIjCRUIB7P9viu7vZ6DiMDt36PQ3EnmypY6ipFtT
         24Kdh7NWFwb9uitqYhcKaETGC//PPHKwBmy3HPidL0YFbqh/MrARoaii2DBFb2LlDPCh
         kc3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685651280; x=1688243280;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y1RjFi/W1f7sgl3paboD1lV9ocRDdeU8mWNevIj8PnI=;
        b=AtVbdtlOhN5Es1I1/rxwvlMvgf+VJwzeKTn3czBIcL/LzjKZFAvc3EAzINfhst6cGW
         IPy4+ERfyiSXxJZaGYzwqaSwdn3ET4bSn4V3JI+La2Ut6MicwCJzY0/vuOnEhouQo0Il
         rFegpGEupgbkrSeOUsVrXlBKCMmM9N0X2ZVywAiNWRpfFOqIix+aXvfKRFHLQBPyKKO+
         VJ3a/9SvtQpReWs7oh0enIDpMwuK5/cqcAtEDM6huj4dLWpTDlFcy/VVbRxw9+a4egxC
         HQYmFJK9pHbYvepa9BNqTIUtyodayFt1s0McG+N/+0BLka1PABbDLFan5x6VBXAxaTux
         IwsA==
X-Gm-Message-State: AC+VfDyQyGO8T0pFq3c0WnQILZb4S0bBOTf4q6sJ/L200QxntQhdGaZd
	e0DP5UeC++9IaWnriVu+XTU=
X-Google-Smtp-Source: ACHHUZ5/cvGVkwLNFFlRJq3DKluDvjqrm8soF6cmznHhcr5TQ1rvyJj5G879SQbZZ7w/u1z+fbL2Iw==
X-Received: by 2002:a05:622a:188e:b0:3f6:aff0:6df2 with SMTP id v14-20020a05622a188e00b003f6aff06df2mr13578861qtc.31.1685651279861;
        Thu, 01 Jun 2023 13:27:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l9-20020ad44249000000b00623819de804sm7918165qvq.127.2023.06.01.13.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 13:27:59 -0700 (PDT)
Message-ID: <4a25a67b-ed2e-02fc-5f01-ddda7234c9f7@gmail.com>
Date: Thu, 1 Jun 2023 13:27:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.3 00/45] 6.3.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230601131938.702671708@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/1/2023 6:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.6 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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

