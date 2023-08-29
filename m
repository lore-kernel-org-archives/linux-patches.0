Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BD6174E6
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 19:44:22 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-26b41112708so3110075a91.3
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 12:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693338262; x=1693943062; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mToAGNYEJndzIg6op7Xj1XSTquaaHAfcvA8BaN3iBy0=;
        b=Gialc4JKcTW3su0sKwgGTOIsrrXpdjf8Ak2u/vZZpN5LocDYqVLDr5xQaFaoI6f7zO
         pWjh22rFUBlWU3ogAP25sN5I6s+FBpc2CxG0eJoBlztnJQeG6ITI/O9rlVVujiRcc+Jl
         Et3KjySL+F7vXRInAw151VCRnFIEr87AHPKiMElm2izVvdozkuvEaBdntiIpP2YtB1LD
         zvE4jVOjWrDmfGQUDmhRfaomjMAAYONdwC6D+gQvarAl19DCMPF5DglrVQB1UvTQggIe
         CqV9yW62+5W32GxmSq/zD65z3Luy30bgYmSrd//QN+Scg87SVeINinkasshy7PxBvmRU
         d+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693338262; x=1693943062;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mToAGNYEJndzIg6op7Xj1XSTquaaHAfcvA8BaN3iBy0=;
        b=dni38pvNBlYkHHKie7kv5AhaJ8Jpr3zZw8fLf9iz95s2AmKXqKBk5k23RZGWnl556W
         5TdgBy0mPApxJhEyqLysqWAy37K/2XjTK3ciECFRiEfit9o6Z/Qy4c/JLUgKZaaA2DRT
         yuSfu9QEtKwNfnARcwN4gjnVbkZM69idMUV/DNPJf8+tvIS05PkzSRUQoOcSiJ6Ld0Dg
         TuzasxUyxALysRXqn7cr7vgLpQLE3++Ij4AY/l3rnZ6R7uiQ/wNfb38aFGL2TMqyXnxi
         wuwP9EAltr54Ic8SC/o4D2U0nZUb1RFfU1jS2pzzzYf3DXya33eNLfNi0r/FdSale/So
         K9gQ==
X-Gm-Message-State: AOJu0YyMBO7Ka3zbwkvahesPPMqSrr211bmiHgOo+7jsgCoWrX6489Yc
	mvzNOT+m51V4MVeAJ5Holxo=
X-Google-Smtp-Source: AGHT+IEuYiWzg0ugLovZhtJNHSU/a5jwe8SZ5NHNAbiCIDtyarZHLuEQB46PS7VQ/FctISB/7BBvVQ==
X-Received: by 2002:a17:902:e883:b0:1bc:422a:b9fd with SMTP id w3-20020a170902e88300b001bc422ab9fdmr159983plg.13.1693338262206;
        Tue, 29 Aug 2023 12:44:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ji18-20020a170903325200b001b9d8688956sm9769305plb.144.2023.08.29.12.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 12:44:21 -0700 (PDT)
Message-ID: <d58bf5ac-7b38-a5ec-ec54-0148e3bc80ca@gmail.com>
Date: Tue, 29 Aug 2023 12:44:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/122] 6.1.50-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230828101156.480754469@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/23 03:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.50 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.50-rc1.gz
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

