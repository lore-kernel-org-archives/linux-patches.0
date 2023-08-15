Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A431C13
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 03:23:49 +0000 (UTC)
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-635f293884cso26127326d6.3
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 20:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692069828; x=1692674628;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TdSSMCQkYKXbWs7lLhu/IusMxnT2JccMO4bwVUpL//c=;
        b=IsHYDJpNsVGUrUdiU+s1FyhfbkjFASiK8a4/h89WvVDhVqzXRWHz2kT9yIFCvMHzVR
         +7Ir88Hc/6bkY4jcNSXtUitw55gHZtRspyQBX8LiluabDbLGYipht7G0ge0IPnJ+OFod
         LUzC9I6HKaINLzChHDhvZTS2BoT4SriSkV1/2VC3cU1qkxlKvxaNVeX7vYpiAYsD/S4d
         zv2fNiBFlDKDmuaCcHU60LZBiSO+DoU54buOwjRzSgeVYREfnIQHddWHywGxd+luTmN8
         Cg0Vm6NiBCWfsM3n5B36Q6KEK3zCpY6twZeQPFNjLx8M/jqmxq7Rz6tTOonMM48OjF4q
         17Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692069828; x=1692674628;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TdSSMCQkYKXbWs7lLhu/IusMxnT2JccMO4bwVUpL//c=;
        b=QSSeDh+OzVxrwUH1Ru1dVwQUSadyV8smLQh+P2H0wbkDt2lBiDnyYf7/1obuRLUwOd
         oJqqXSR6GJEpv+DiGmZYpFmwVV3DzhJtbKGxGzCspr5Ibj53FOPK0HZULsD/sGSlVH7e
         6Z7z3uUwrbvP2kOvpCBL23FLmFCKDEN+rnUpOBlLaXQsDTqmKAF7H3J/Ys7Tucldl9Y4
         fXXox8SE3IBPfs6/w2wCqGVWUS/CH6ePDPqzRwDHe37hd+MYjL74wI/LrBvhOPnxJ9bi
         J4qYu5XFNg6RZRmNlSOqwL0M1AfS/HSADvosXLJFd1OoT2a2DT8MRUBu5pLossEYjZRj
         wHWA==
X-Gm-Message-State: AOJu0YwiD2nTCo/hAGpuelKFaHos4xdB3WsFr9vVx7p4JKC/Wwdd3Csi
	4VaeaYqfxPkxUGI7JR0BdYM=
X-Google-Smtp-Source: AGHT+IF0QkgNsmcp78aCqa8egeI0Kn1/DODZ0GI0qUhpkNdOWWV+26BFdryiE+MD2BP3mU7M7uef6A==
X-Received: by 2002:a0c:f00b:0:b0:62d:f170:f6b3 with SMTP id z11-20020a0cf00b000000b0062df170f6b3mr11831597qvk.19.1692069828529;
        Mon, 14 Aug 2023 20:23:48 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id z8-20020a0cda88000000b0063cf4d0d558sm1681770qvj.25.2023.08.14.20.23.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 20:23:48 -0700 (PDT)
Message-ID: <86601ba1-d89e-d4e6-5b16-437dc68adacf@gmail.com>
Date: Mon, 14 Aug 2023 20:23:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 00/68] 5.10.191-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230813211708.149630011@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/23 14:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.191 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.191-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

