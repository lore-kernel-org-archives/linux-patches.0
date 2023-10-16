Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CF12770A
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 21:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ek1TZK+5"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3574c225c14so7094295ab.0
        for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1697491988; x=1698096788; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v1cmLjYtXmkTukmFQ8B0vWtZyFMXkEqPE8NrYHJmnr0=;
        b=ek1TZK+59ulp9VrOGmZ8cxukQN4k8JJqQzvXJ8dIk4ovCMC9KFNd9iJd+3dyQ4w+em
         lYcUktCRVQfPHkJmv8EyiA+GQ4cdT0sLlx+vdak/U/WqIE9/4Gllok4h3Urkmo2Ebz8/
         /8QPF4zla9DKORMcDU261UmR0grWH28xwzkb8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697491988; x=1698096788;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v1cmLjYtXmkTukmFQ8B0vWtZyFMXkEqPE8NrYHJmnr0=;
        b=T+94kbQDlo0hG+MhZNMiJfkNMHqTu3Vjn14b9I+1f4EIItk32iWSmEfmRyKI8RXC5o
         lbBZy47CFL+G1Dw8cSr5OYec3wNvY5e77PbDDUBhZtnnjIbcb+UjcRqkOPA2uqa+Izyn
         AF3ECC3yoPJQvMyH2+rKwPNJmmBq5nkqlY8N1YZ/Oh+UZKk1e35Z086lhbiSnp09SlWk
         dMtCbDD9JPT458i4EmzJYXF3BMBvRn100wkYQLmP3gjZwX8ukbSq5tKFq7w3Vw1eWuSi
         HFxF2G7VRnWNtmz2sdB9NKx5qCmrSPlHlmKOtadkevTplrX4uzxbJkbVmdWfQBamj9Cl
         pkgw==
X-Gm-Message-State: AOJu0YyrsmxmLnMFoW+pImUAO41/ONgwmjoX5/qObbmcnRExCuBlF60X
	qLmbFF5A6FjlNuTbXuVWvF8pMw==
X-Google-Smtp-Source: AGHT+IFRgiYejT5HFoheHPppn0K20RqywRgI4lH2JKT5HNjMtQZgmHUAKp0ePrq/e+KvjLnVDxvycQ==
X-Received: by 2002:a92:5213:0:b0:349:4e1f:e9a0 with SMTP id g19-20020a925213000000b003494e1fe9a0mr675550ilb.2.1697491987759;
        Mon, 16 Oct 2023 14:33:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k8-20020a056638370800b0045c25ef9a56sm58767jav.21.2023.10.16.14.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 14:33:07 -0700 (PDT)
Message-ID: <fabe5bf2-e870-44c5-b4dc-79fe44a2288a@linuxfoundation.org>
Date: Mon, 16 Oct 2023 15:33:06 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/102] 5.15.136-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/23 02:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.136 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Oct 2023 08:39:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.136-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
