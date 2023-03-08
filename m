Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7038BF3
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 20:07:16 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso3674928pjb.2
        for <patches@lists.linux.dev>; Wed, 08 Mar 2023 12:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678306036;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mxZitMnHBInsSAfz21jq6jIrKSMSSWlzGYGgmxeGrNw=;
        b=G3CKlFhOjkbrYLGH9Z/AJhydbKsD+17OebHrIOAZgVpuKSOEtjwbZKrBe94X0tjOYj
         eUb870pG/I1OhO/KoV3riMmlTssqszJBcyJ0J4y0zzKtOMkHiuxN7UAyt7Z90pXf93nF
         KomtLwDaV0e0cvH3Ss0qx0rHErdPQ35I2n7drKznDO7mUzreD4C1j1VQdgYKeryGcL3Z
         hr3puFGngP1iiLtYtftEq7eJvXB2xUzWOX+c2UdUFVifqDoBIG1tSka1Y057xFT+TB7Z
         nv5JKAre5vfn/T7EK7148hA4xkO98UjPF/bDypUkcYpZRgymiylXPIP+06uqrZ2ztmN6
         waoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678306036;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mxZitMnHBInsSAfz21jq6jIrKSMSSWlzGYGgmxeGrNw=;
        b=z1bch6v+S4cT05KU4CE8eyRnl146Ibq/GYRIxOYs/RnLO/Gw6dx3a4EY83fEu4nzqr
         OSWQQRM3dZgi8VJRd3I19pzrsIjkRn6Z5Sng8vqiDfid008cOyIZ21p4XGvfEWjUGekr
         LLWOU6sOi64XqEI2tINmIB3DC5fk/MxFL2f8QSN0NXNRw6Zk0JfydzFOegJvpJoyXGAo
         QQyftq8g0SoZ0WvFdrJTjJGM+M/q3KzPIFf/eTIKdfg674SFdNxZFLBNKNpKaPrWHW7J
         omfDyBT/Dx/DtmR1yd+O72lrxayT+StMPHO5rA90lksYJIDLQ968P7CQBhylAPfBaVOp
         8LAA==
X-Gm-Message-State: AO0yUKUWC5dE00BIQaqGB+WOISAfFkASSl0JNsBAYGb4BqAS0Hq20LZ3
	JxOUG57pzKiTJoFVluB+ouE=
X-Google-Smtp-Source: AK7set+P4rFoToFvYexEZCidnV8t9kTUxg0OQLI4W1PSFOYN2aMv9VMB8E8o+6OFrLjZmiY6O5axDQ==
X-Received: by 2002:a17:902:d48b:b0:19a:7622:23e5 with SMTP id c11-20020a170902d48b00b0019a762223e5mr24297728plg.4.1678306036324;
        Wed, 08 Mar 2023 12:07:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s7-20020a170902988700b00198fb25d09bsm10093393plp.237.2023.03.08.12.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 12:07:15 -0800 (PST)
Message-ID: <01c752b4-2367-86ce-a852-bd420523f486@gmail.com>
Date: Wed, 8 Mar 2023 12:07:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230308091912.362228731@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230308091912.362228731@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/23 01:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1000 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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

