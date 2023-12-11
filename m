Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8395F524AE
	for <patches@lists.linux.dev>; Mon, 11 Dec 2023 19:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XnxgmFAd"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-67adac40221so35181376d6.2
        for <patches@lists.linux.dev>; Mon, 11 Dec 2023 11:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702321478; x=1702926278; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9fUIDGd0KQpiVx0QnEq4QPqvvyyGBKsYPzxwNFGD4zg=;
        b=XnxgmFAdDkWsEK89yP3TXhoSgMyywV96BEsNC5W8ZuV2nOXPJ+2QlLQN9XTgK/Cg3A
         svExbBvL3llgHUW2fypeT80nCdGylNb9s8BOWjKhoDikWSXgLbvKn5lbH7W1qtUScEP5
         tsfEl+luAxK4aqkVOcItNXWrrvo42UlYprWgBn354KEZgH4fQm/JC2eBHGlxcYROXGcL
         OCvQx6qY25UxMdJhZnTr59gRYDLphgZlyucpaWt4HJxhKxu6KKBcClycXQI3pRid9lfO
         NzJe1PWPiqLYImr9Vtsv0ItUakaIK6yv05rMLx0i32Gy/xjMMmHD5yDTAr1eda4Ooy5i
         d3oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702321478; x=1702926278;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9fUIDGd0KQpiVx0QnEq4QPqvvyyGBKsYPzxwNFGD4zg=;
        b=dsVaLmCg8KpgGKwIqVvCNLTT23tYAM32XQ1Gd2t3c4kxrXDyRvc8IshCIMkBkf3Crb
         txQtMIFMKK9KGBbOnNTDjuwwOSnW1jYnghNczLe7nayjMSaTWT6j2w8k4Y63YCTc1V/S
         ijFQMdIBVzhsM1BCoBfOTpUIbm/sUwW/ClSyTbqzIR+dvcuiABa4CoFuMIkp4qs9jzfd
         XZAkqeNfCUoprE9NwrQa9SM7oxE+1/w79iNCAZMI1Kw/5min63v8FQ/xUyHeKBBYic53
         PdVPA3JAnwqUlakjrvAfJ4so0ssim3aaPagsNnO7CHi3AttbpNvHdXhXGEiJOfHlYRT6
         QdMg==
X-Gm-Message-State: AOJu0YzEcQNJgwCgD/ZOt5SMOto55U2DDs5SeMwBeRwbJCZ0ZI4mzrvj
	FSTumlZq7MfFX8+jWfSwBT0=
X-Google-Smtp-Source: AGHT+IFFPiRBGN3dmi5Ucvy2fzkixUTrsr3Dz8XWxnKWbsTXNEIqMUNXDyfefM4yxXdbkF5PghY9yQ==
X-Received: by 2002:a05:6214:b27:b0:67a:a947:72b1 with SMTP id w7-20020a0562140b2700b0067aa94772b1mr5326532qvj.13.1702321478398;
        Mon, 11 Dec 2023 11:04:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x15-20020a0ce0cf000000b0067aa31371ddsm3493378qvk.80.2023.12.11.11.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 11:04:37 -0800 (PST)
Message-ID: <031b2a9e-9b2a-44c7-aef2-191735da83a7@gmail.com>
Date: Mon, 11 Dec 2023 11:04:30 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/67] 5.4.264-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231211182015.049134368@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 10:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.264 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.264-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

