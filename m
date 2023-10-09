Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90AE37C8C
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 20:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jz+UWYh5"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5859a7d6556so3627417a12.0
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 13:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696883101; x=1697487901; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dHLtgNs/RgwJBT4RjvnNxunGnFoxHtAWIXgMjp/5w7c=;
        b=jz+UWYh5lYYuej1rXOM89CJVzDmjLMCi8G5F3aKV6zYz/miAuuXUPW9nL6AA2PuYGC
         9C5mvoS0BQGkTEokIn/VRmqSUADQUS2PMCyab4cIWqM24lJJjP1aMkcT8au+eORv4Mht
         vIY9T6p6YCPrYaiS+yfd9atQb7HbS3Fzx3mI6j1k7fUxikfcTEQ7UYocjIXDP4JvDeKA
         LbSRlkBAlbPkdu+PcrybhbfjcrkPhGHHu/l62NDgHmi5eJi94ftZFQ5RwX9Yl0Hm2t4L
         2+XOUQhWkXdIt++fiGugt2UeMSB/j+AlkcNLWU4vG5r0furgldceTZRKQcrP6jvOBqmb
         /GUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696883101; x=1697487901;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dHLtgNs/RgwJBT4RjvnNxunGnFoxHtAWIXgMjp/5w7c=;
        b=woXKJTM9gPVmh9A2XZ1clAA9whtBJ4rD9745Mi3R8e/6b01uzvgLiUm1TFrbDHu5Tl
         jjzd2e0MY77evWO6M/c1cXTapoNs8tdlLvglXRskFX3roYVyYCUsgn/mtbH4QXbMK9ol
         4IGSLPmOOrbZuaDg8AeXM6CEkI07wEJnKm8kw8xVLwjwixEfrZlAtom/zbevZaojWvuG
         8Z29CSOGYMwV3kJ7tyUWG6sXjgfCdyXKKgk1pRqa5GE4U6otmPLHB77Pa9uY0DSNeqiW
         BbgR8WofG/Cj4VzZsWEJ66ba9nyGRJuRt8Wtz51CxqKC4JQ7SD38mLASQkxHVz1ANxIU
         Mf+A==
X-Gm-Message-State: AOJu0YzDeNZCILL4thP1u9mmtFVRXa0cD5gbTIpqMTUw5cNO21yaqQ2n
	49jRwucup61Va05u6BRnS24=
X-Google-Smtp-Source: AGHT+IGz/SLuOVtpJrZrOd5rtyqvsTpUymuLyu7aGUZba6bIlpEhLM4AHh5pFHuAWQvOmmyU6B3Ogw==
X-Received: by 2002:a05:6a20:2583:b0:161:76a4:4f74 with SMTP id k3-20020a056a20258300b0016176a44f74mr18943479pzd.1.1696883100781;
        Mon, 09 Oct 2023 13:25:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z18-20020a170902ee1200b001c55e13bf2asm10060425plb.283.2023.10.09.13.24.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 13:24:59 -0700 (PDT)
Message-ID: <c63be538-b479-4eb5-a1c1-5f3a44d416ff@gmail.com>
Date: Mon, 9 Oct 2023 13:24:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/226] 5.10.198-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231009130126.697995596@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/23 05:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.198 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.198-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

