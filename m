Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C1B5D494
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 16:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2nQO1Xv"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7b7684f0fe4so6785739f.1
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 08:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1702397532; x=1703002332; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/5Os7Zf9xtGAEMMOdp6/zayB3XH/JTR+GaEqzNPOqhg=;
        b=P2nQO1Xv8itCOO4PRNkCeYK02QB0eLbzARWrbjSdDdKCTKji8cIWiCCvieWCyWSFff
         CxZHIxwWFIs7X+bBamvveyt6GL1aMCRQMnIhiNKdgpOQeLtMmiOgCa+AtsfLxm0ye+0x
         zaCWADdePJ4SxoCot1dFkT+tXc1krhIfJAAps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702397532; x=1703002332;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/5Os7Zf9xtGAEMMOdp6/zayB3XH/JTR+GaEqzNPOqhg=;
        b=SnaQNKRDQp9Q77E6FRDDg5jBiGX81XEuCAgqIqLEpQz0kEnha6RItnDE9oT7tRi60U
         FXk8VAUPy3stsIakwvIloOP4VNwXYgEWWAMAW+8tmdven+Gf47JgM8tC31mRm7vVe3gI
         x8OWANHeYM/D1icfY01AWetHjSvjvqG0WoMKG7ED+50SnpdUlQdIBkQrO8j93beoRIQJ
         1FwOKjNJF3f7YyRGYjGTBDfB2cjL5YNwSGu7nST2TKbHZ98zOsYXu32l1kpzSRPyA2bS
         Qh4U7ZuML+zsRE0Q0fJgMPs6DLUWIPvIq5gDzoq/KTN7C7lDznTolA/ZI9mIqCH0/zQ8
         VkXQ==
X-Gm-Message-State: AOJu0Yx+Dz9XoBmmqbst8MZR0HaV7uNyqMkZmrn4naQD0Wd3mVQR8EtB
	AJofiXT29o5TKryoAutEtj043w==
X-Google-Smtp-Source: AGHT+IFlSd4M4f9h4XhHCPxW99K3g5dTcdwVKKOFnFzgm3FWCU+oaqjyDCgmSCas/3F7i/lOzxlxIg==
X-Received: by 2002:a6b:fe09:0:b0:7b4:2e28:2343 with SMTP id x9-20020a6bfe09000000b007b42e282343mr10516554ioh.1.1702397532654;
        Tue, 12 Dec 2023 08:12:12 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id t1-20020a6b5f01000000b007a6816de789sm3012606iob.48.2023.12.12.08.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 08:12:12 -0800 (PST)
Message-ID: <8dd78791-bc0a-4aba-a205-003919164834@linuxfoundation.org>
Date: Tue, 12 Dec 2023 09:12:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/194] 6.1.68-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 11:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.68 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.68-rc1.gz
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

