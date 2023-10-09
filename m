Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D043328E6
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 23:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PuySDhBC"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-7b3828115bcso1495057241.1
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 16:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696893843; x=1697498643; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cA2IGKu/7FNKv/PuZySh+4g16dqwPNHFTAWtDeYeE8g=;
        b=PuySDhBC5CDvQEDL06BhODSQmJ5fX+p14TWknvikvNA9TdHykEKEx42z0K3/ZAH9uE
         LlyAscfbLMGtf0KERTdv2br+h/VxU+MGpcml1rFDhfL+X7fzAEGOifjGYU9oFCxdzkLO
         ehegTtxsW05tJCLmYSmSua9fPCOsyroz7NgmAwGut67x4c9BVpPguihKa11jzCdUNCzX
         Q978ktX+SBLm7FL+uo4zsuzsH8X5RUzi8DRfbbipNCDUhOmNGmXUrl0DPRTf9ls/fdxJ
         kCKHiPd55SXWSngtmWPoZy3Vx1XLkqCCLy3fvT0VFz2J60icADdePgj9anklywTNG77G
         6eoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696893843; x=1697498643;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cA2IGKu/7FNKv/PuZySh+4g16dqwPNHFTAWtDeYeE8g=;
        b=tYtVBlnnCUWYaQl+QCbZgWEuzH/qhNiV+dq6ZoIpZ0fWJCu8pZ6nWSKeyI+fRW+NVq
         O9Tcf52ctgmShTDYJn5lv4FulkeiBuU6yZz7gmgmN5CaxySt7bW9oe+VA+EYpSh9LDDi
         TwBsaCvgFnk2ceEBpLx4i0UibclK5bQe2v92O8JNEHJ0adXrBTId0I1dGRbyd//QRwi1
         yd9QIRKVjHe+QJkgx8Cs2E93TTMK+SIN98fhMVHfrmdblET5FNOsGzhoxSoj9ZBqXxVq
         r7NW1EKImchYS3NAuuOoC+3NIshmGH0aTGwvRj6gk9wzS5nGk59VKYegLo1x1MCo+IN7
         Sdsw==
X-Gm-Message-State: AOJu0YxYuLCEr5te4+To2bVay9M4xatqNfJ8eDGMySUpGh1CkATBpsi8
	LZOop0zPQBKjR2BU8LodgY0=
X-Google-Smtp-Source: AGHT+IHP2HhxMOnlmXGK+txRl7Q9zJjy0sGy9q8G/opaA9agV7Dw8UPXhRzE49CDXfuCShdQ5cJ5CA==
X-Received: by 2002:a05:6102:441c:b0:457:7138:fa74 with SMTP id df28-20020a056102441c00b004577138fa74mr5156466vsb.35.1696893843473;
        Mon, 09 Oct 2023 16:24:03 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9-20020a05620a166900b00773fe8971bbsm3887010qko.90.2023.10.09.16.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 16:24:02 -0700 (PDT)
Message-ID: <99e90f84-d95d-4438-8b4a-03c3956644ae@gmail.com>
Date: Mon, 9 Oct 2023 16:23:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/162] 6.1.57-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231009130122.946357448@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/23 05:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.57 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.57-rc1.gz
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

