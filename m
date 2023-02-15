Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F4ED2E1
	for <patches@lists.linux.dev>; Wed, 15 Feb 2023 20:28:16 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id v23so21480526plo.1
        for <patches@lists.linux.dev>; Wed, 15 Feb 2023 12:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iCF0rShrhjTZo+vj/lM4nPombRJwd5wcu/hQkQwVY84=;
        b=c2p5Krc70fvqhISDXFNzyaE5N6FxoPIdUBrzskIjfAgdw7PFPikWZjqL1dFIR648bh
         FRvsx7cpoVo7B4ne5ApyWokvYH3K/BeQoq7a6lzlL9/BpwL02XHBrByZv8p/7YzLvD2A
         oPcX4RJN+CobB7Pf1OA9GwJRfVLfJOG28RAk2YslI+pAxHb1yfUxUFVTehJcjWBTmDsh
         48fmZbh3rRHVnUb/XRaT8/6MjtShZtrxhU2uiIK0yk17Bvr7471+icgu91/eIGH35nYO
         Wm01vrqEUEjRpoc/RqMoa69kLnzkwcfShOsP3LkpgHU+eTWKIxX+7wRoI4WwRgsgVtK1
         x6sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iCF0rShrhjTZo+vj/lM4nPombRJwd5wcu/hQkQwVY84=;
        b=yEcCpGl07CVE4oHwWm3K9freLWdCggYGkbmPenihSUaVRvgfh3IH9k2HcJfhsz6RuI
         +GmzPwger7DUCi2RTbnG/urQZrsl2CsFA9PP3uOyvk2rWla89S+JzsfPRL8QeFhl/Daw
         eXaSxTe91YXi93gUqTfK3/yWOrX2sepjf1IQJMsd3BWeZBnc85QIpoI4KEm2mzz8Lvkx
         OBa3tU5Ry0vdq+979irEuG+qyV7+fdgNP5D0HIrms39i+qUlP72GK1qnk7p89P1Vi6zD
         pVrt7tefu5XzGoMWt4PW2+Jje/VhaGKYP8z4tWrWh6zh2V5Vrk2mzQ7iZfEIE5o8pJKD
         w83A==
X-Gm-Message-State: AO0yUKVw+KxoX/CNgNl2Yz6vbL/TUxGjhvNq1QHbvdSkUsz24NxOP1Ps
	Kh+fHAQEDA4cKtSMcbpzc/A=
X-Google-Smtp-Source: AK7set/5mlHCZ1a8WvZxsf5np8fWLUT0k4t+PtpGK2rLJWs1iplHzlICGCdFH6Fg2mXvhMt2AStaoA==
X-Received: by 2002:a17:902:e882:b0:199:2a4f:be84 with SMTP id w2-20020a170902e88200b001992a4fbe84mr3903580plg.58.1676492895516;
        Wed, 15 Feb 2023 12:28:15 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ik6-20020a170902ab0600b00192a04bc620sm8608294plb.295.2023.02.15.12.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 12:28:14 -0800 (PST)
Message-ID: <3937ce28-e15d-1d40-caf4-b35ad6d5b0fa@gmail.com>
Date: Wed, 15 Feb 2023 12:28:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230214172549.450713187@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230214172549.450713187@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/23 09:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Feb 2023 17:25:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

