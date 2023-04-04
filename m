Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ACE7C
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 03:08:15 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso32549319pjb.3
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 20:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680577695; x=1683169695;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MRnkaaj/cVgSaagBe9PehnJgOMpffWqdnxqVj0DdFK0=;
        b=MBoIRhcYmwFydDMClcg2UreRmhzz7xW1W3ifJjOObZVq84h7WmE/Le3zwuFS+EwjSw
         61/b2Cqr0rxDzHpSkqF6pzhykiZzzwseuoI+ACxkfNEHZayWd1c4hRe3OGnUIHJsFUFZ
         Gro4nuRj9Sz7107JS2qefjLg+ZO8miF2mfaSnULZTZl897mooDXzcDsqdewNPakI/I6o
         1wISUI+tn47fYLaHs/EmBPcFhVE72O5oCQ3P9oyUoWEQ/TvtaWEK4SwjLurFbL3s7VFO
         Db9j3SOsmbsb42IuYu0y7AGFdRNW+iEnpxULLZUbTJ/Pd9gA6WZ0Ba6acbY5Og2dhrLN
         iMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680577695; x=1683169695;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MRnkaaj/cVgSaagBe9PehnJgOMpffWqdnxqVj0DdFK0=;
        b=ock90mIGU5x3T5gHp9B0pANGuYJzVe0wOUhKGUgG8v1zsrs1aVv8j9G0VqgUtQ6BTV
         NDOfUncjcdJJdZ4v0Eju3rQ0gXnk4xOd+Z8ASrgMX8YwtYCA70BBjBdzkX0oBnk1rhfG
         GHaPhie+mTzGTNaQ/nyru9fTWYAWmgBgjbNAhqhjy5LZPsMtCjwJiuQTrnKrIK6UtFeP
         6PLlHq8lLcY6FbXxhDQDBVl4T1iVm2YIBObW1M5u1sQtejSh26poe0L6aa+rkvQ63EWJ
         MYY6/CII9jVuyDD5HnWCJVdvq5QQvlA10MjqlRT9QFWKZuN7MAszL/Ag0MDlSgkbTEIL
         dgHA==
X-Gm-Message-State: AAQBX9eNryOnho7wH2cJNSgYxRCmX0qEqV4xJ/tZpwvzn2R054sOSi7Y
	mfz/kgQjm9ANf79m+ppA6pM=
X-Google-Smtp-Source: AKy350blamQxgHaeX5hc8HPO9IhB+5+NqWBQpJrec0j8+FB1pQ3uAr2PPmmNHy8w06h/XkTUUqeXnA==
X-Received: by 2002:a17:90a:4146:b0:23c:6713:45b3 with SMTP id m6-20020a17090a414600b0023c671345b3mr1398826pjg.7.1680577694750;
        Mon, 03 Apr 2023 20:08:14 -0700 (PDT)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a174300b0023f545c055bsm10242115pjm.33.2023.04.03.20.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 20:08:14 -0700 (PDT)
Message-ID: <134bdc4b-e62d-7892-68d7-24f917e1e7e9@gmail.com>
Date: Mon, 3 Apr 2023 20:08:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230403140416.015323160@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/3/2023 7:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.10-rc1.gz
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
