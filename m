Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BD725936
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 20:42:13 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-666ecb21f86so5568639b3a.3
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 13:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690317733; x=1690922533;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MQmJ/m2T/ydxcjfile7If/e4KOGCFPlQ1iZlkwg8KdI=;
        b=ZTx1BqZcaa8x9126EESFJ9eCw2x2YHm5MpXp7fNkpRvehfLHMQiyKDZp6K5seJ02q0
         D1Sk+7R37/Qvm5jz+CQJPMRWOVXL0w2xSavdoktlx9i6HhDFX7/8NE0M/FdSmemLdCKz
         Y9YYIUaXJox8uMbkyTWfeD917IqIh/tgAHxSJLNbRSczQpQ1Ere/p2KPgowDU0U2t1hn
         QEvIB0J4kQQm73XqTx/DqCD3/tNRQ89KBMk5etIBTVyuvUa6+gkoTReAFMTcte3Bp0+0
         o8Jblij4548dpo2/F8OuNwoRRQfYtlTly6E25PII9lgIRff+zew1hSWVLe0UhjMaLofj
         XvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690317733; x=1690922533;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MQmJ/m2T/ydxcjfile7If/e4KOGCFPlQ1iZlkwg8KdI=;
        b=TOrkpmloD9e613hKj3OrCZjWhbXrHYUSzR1tgtTCWygAvMkEJRtlq6XlLkX62Q2jes
         u8rYfOE1G4gRCC9XL6T2esY2nlEYx457Q5ULuD6i241K5ajLR07UnZ0obcqhPd+no+Ji
         45Hy736WYCyK+CRwD1XvFwobobkwNogYwzOeWseFo0wUcDPI7jiwsl4P2YnT2I4iKVyP
         uSyBmG/fS4BvrWBCwbbv6lOSxYzqPVIamx1LbB6ZPHG/9n3cTbF54NelCy8JIsm+29to
         8DU9ca4RSNGAznAPKd45ITFb4MrN4jkixhoqCLkrcXbY7zEziQI24b9Bd86okz96EaC/
         YjFg==
X-Gm-Message-State: ABy/qLahhnHB7KF/G0EMzuOeKpB9Kp0TyAEcwqDRMD7Yk6XEjallWwnI
	rX8CEkgp0kX63jBHqHJLIbw=
X-Google-Smtp-Source: APBJJlGCgl8X3aUEZlPeeAoAG21g/VkFzj3agq1zYPsrFu6uYCaZjbOHh41AK/Zr67xCbEHs7RNM9A==
X-Received: by 2002:a05:6a20:8408:b0:133:96c9:fb3b with SMTP id c8-20020a056a20840800b0013396c9fb3bmr189930pzd.45.1690317733116;
        Tue, 25 Jul 2023 13:42:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z24-20020a63ac58000000b005533b6cb3a6sm10962157pgn.16.2023.07.25.13.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 13:42:12 -0700 (PDT)
Message-ID: <f96821af-113c-0f56-8576-b84616db4233@gmail.com>
Date: Tue, 25 Jul 2023 13:42:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.4 000/313] 5.4.251-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230725104521.167250627@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/23 03:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.251 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.251-rc1.gz
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

