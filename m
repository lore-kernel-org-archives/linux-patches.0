Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2E38460
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 20:23:34 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d3so12845397plr.10
        for <patches@lists.linux.dev>; Wed, 30 Nov 2022 12:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7UaFta4NOMMkNLICFxV78XM9pSfzAhcmkG8cBVb/uXU=;
        b=TbFcaqIctEOqINXcO6zjYXoWgY/o5kTxAkN3J4FPM0LuEL2af5sbtdYbgMmE98tJto
         KCbyGgNVmViFo62SLc51ljH7c2itlj39bWa8L+/vRBiGcJ0A8gT1rFityTlevqLlTLIg
         VdbeEM+BCoQ12tpyqpM3mT4vupLTXmfSk4eq8XPNyQIciHKlhII3v6/z7EAwK8RCspro
         uX6SQUoy+xz+ODcrKpEVSctDpodJcESFl/NJR28XE3cEMfXupHEct+zLa0C66korbmgR
         /akoNlFnyIOJHYMrA1b7YjGDPOyM7ejSZGgnJCuNjgI2Ud3NFCjIJJTBxu4a8yPU7scu
         oxQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7UaFta4NOMMkNLICFxV78XM9pSfzAhcmkG8cBVb/uXU=;
        b=0vWwHG6tobJ9EXUfT1oCrZwZpkeibzvsvYpaUEf88C8RXKc8Xv/fUjIC01fZd+VVzv
         HdEzLSRwQg0On1F7tDUxUPMoleJ8IC4b1mth/RkBndCICJaKICkAfX0LvqgSoSzcSm14
         /YXEkPtK0EygX8dVaoAGD40cW39/Onwmx4bukWqTntyvMxMF0ROjlQ3pMglQvH8xKdQm
         Kzrdlas++uoh1vKJHd00n6B7tD6zvTD1uPuDCpkkVbznzcpgi48C8vOE//rsxUiHMssZ
         qGmZiXrugpSNCOBTbOEj8GrgzTFRZ/unQDx9eiOWk5tkOrrH6R+Dc724xY37tD+4Ufkz
         Iz0w==
X-Gm-Message-State: ANoB5pkg6gka6E2eWBOfNvyBiNjZyLHrDjaMedQSFVU7sdoFCNNc8AHI
	tVvVj3qJp+uIfKu7mTHOdsM=
X-Google-Smtp-Source: AA0mqf6HGg/z1hOIyUiikPDhAz0YF/+jDjPa0xUzKXn6XVp7dG+QsSwDXahw8mdeFcY3XdR254xomg==
X-Received: by 2002:a17:902:db09:b0:186:f36a:63b2 with SMTP id m9-20020a170902db0900b00186f36a63b2mr43060023plx.128.1669839813762;
        Wed, 30 Nov 2022 12:23:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p13-20020aa79e8d000000b005751c5bc237sm258548pfq.128.2022.11.30.12.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 12:23:33 -0800 (PST)
Message-ID: <a87ee919-0687-ad50-f9d9-ef4a52426e7f@gmail.com>
Date: Wed, 30 Nov 2022 12:23:28 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/206] 5.15.81-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221130180532.974348590@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/22 10:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.81 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.81-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

