Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2C1D53F
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 20:12:02 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id k13so2105293plg.0
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 12:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eUVREAeuxi0yYQ0P2vbR9fitxXN9smQF7SNOFKwNoSM=;
        b=cMYFMH8GXe3w9/s8TthwcET4E/yGDk6e9TCH9M/cZzIY0nl0cevHVq9dmclhbdFZJg
         riP708G5VdFkPgdSJbKeRsEf5kuLphuGICN9KIWUoQ4EyNmF5XVHAp9cjO1XA9gpMyIf
         2nOjPihV7Sz9S/SoE18NQceO+KCDHHPTxfTzqJsN3gIq3imPOMTvWqKEcoPrAlNRYfQw
         jWboUf8nRmXwTW+qDClvxJlHUetoalQeCh6FQGpR/SUdOs+aVxHvBx05ygTXxffJb6EB
         +PyptjY77DHrsTwJOkfceh0AKeHYjzC+PP+LInvJ6jMMwA8/ZBGaqmgFZvGZObYg+G1n
         0tww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eUVREAeuxi0yYQ0P2vbR9fitxXN9smQF7SNOFKwNoSM=;
        b=sR6ZYxA91/gONaPlqkKeEn0FuSJbkpLyXokuV05UEJyCLn63nc8kLOnlw2cRLvAJg9
         XThyTx5G2G47jw7Kw7k7tERPW1TywS02Y6LvSd25oxJB6AfjZlYtmXNah2nMPYHBUal4
         4E39P0z3GWXxflfxVqYChC8eLX/f5Juc55pgTrOCnobdOXtFy6JgJsJ3sDGg6DgZRiDi
         6qmDBnKnMeNcypa82/8wrULiWMLMM4sgLkizP4xlRnLpWQWuPxLyBEBgDeXOSJlN9S31
         MK210yWWUoJfj/gLUXl1LKgLd41qh5Vio2a18JgmALo/mG6XRbI4pIt+3X37e2lH0Nwh
         5XhA==
X-Gm-Message-State: AFqh2krDYCCA4oVxJ5qVqwGt7tEOIA7m6E0C6liLQT5i8GPT/8WqY61V
	XXETQB9tqYeHo5MseZLuRo0=
X-Google-Smtp-Source: AMrXdXuJWsG5EbhUVDSXvJVtmwFi5ddTzDmkbmib3gPrkId1EwHxnBH76KIciaxn81Mil/yTa//s5A==
X-Received: by 2002:a17:90a:a402:b0:229:5e73:78ec with SMTP id y2-20020a17090aa40200b002295e7378ecmr4830694pjp.34.1673986322059;
        Tue, 17 Jan 2023 12:12:02 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 4-20020a631844000000b00497c1399b38sm17636994pgy.78.2023.01.17.12.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 12:12:01 -0800 (PST)
Message-ID: <3584ba9e-9c15-977f-7e00-ec89ddf2a0f4@gmail.com>
Date: Tue, 17 Jan 2023 12:11:59 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230117124526.766388541@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230117124526.766388541@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/17/2023 4:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.164-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
