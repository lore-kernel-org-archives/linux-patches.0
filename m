Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4401B27F
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ld/SHPs4"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6910ea9cca1so99686b3a.1
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 11:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696445029; x=1697049829; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ooOYlMNzU/nXOVXoJ797h2bTTI8LLLqoLCs+5/x9Ip4=;
        b=Ld/SHPs4znm7oLBpJMEj32a2nkeAcFjLtiDROvTSZh7gf2Silm7u3fpOkV0j9Z2o1R
         3m5KRlbdx/G8PME6pgCdRo5nNLeXu0QFi1izXmEqk/J2G+J4HxgWYe48oJ0Kz9Z7aVrc
         PixVZKwkdlhsRnRqHHhYY8Rpyj32a4k/DI062GY/pQWOL7qDdzB5HYfQ7gZMeI8ifXlL
         AivcMCGdjdgKyjDHqZ8urkV9D0E5RC5SOFKITRZBxYNIGhsiyTZBtl1iKKxG7Xejz7wb
         fjQORgjKMpJlNnW5Wi23INMGxqr30qf9K7m5LKAtGGKnSQN8CUgdkXkjQLXiG8yU3kIM
         twrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696445029; x=1697049829;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ooOYlMNzU/nXOVXoJ797h2bTTI8LLLqoLCs+5/x9Ip4=;
        b=d06L9/FRVb/HMu3RSeAICMITPMeNdAtwQhlAcxNJsUXRxcd6828RE/kD5jZR2LM/OG
         Ba7WQtInfy/ayMUD+7CZ8FMwfX/WouwAv6Lg0X7mbgRpGmPBhiNKifDsZv9+2ISBY22A
         wnZCjNAqly5juBXaUoD3X3pQyx4frQBPeG6I1tQxv4wi8kKpo6oI1eJurA7VJsAXUfzl
         tAiYquNojVg172v950QHkh/RbeXWkwxpl5MHfbx5ecyP+grkecw2PFXNsDFZrKB/3tlk
         v5zewHbFAAeUSDq+wbVOATyuNyfr3SxPocfuXL3Jd27UHBvwTNtzkm4HuAbS8QnxAWDO
         iGSA==
X-Gm-Message-State: AOJu0YyXMVfZ8bUf96FWoXlAuxK1QO9F4SY+DpI+C8BG2DCmSYQ2Fq1+
	k2Y90G9pYE5t/7JLCJmqlls=
X-Google-Smtp-Source: AGHT+IHiU5FJ7NyeBXXTb5/Pd5QfBu0+HGaAapZFd0bSBcl87BGZKPtg+wwrmtSgFOwUq9LSC+Xk2g==
X-Received: by 2002:a05:6a00:2482:b0:690:4362:7012 with SMTP id c2-20020a056a00248200b0069043627012mr3712536pfv.28.1696445029127;
        Wed, 04 Oct 2023 11:43:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x7-20020aa79187000000b0064f76992905sm3536129pfa.202.2023.10.04.11.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 11:43:48 -0700 (PDT)
Message-ID: <ec06c2fb-6737-489f-8439-307e0d84687b@gmail.com>
Date: Wed, 4 Oct 2023 11:43:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/183] 5.15.134-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231004175203.943277832@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/23 10:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.134 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.134-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

   CC 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/metricgroup.o
util/metricgroup.c: In function 'metricgroup__parse_groups':
util/metricgroup.c:1261:7: error: 'table' undeclared (first use in this 
function)
   if (!table)
        ^~~~~
util/metricgroup.c:1261:7: note: each undeclared identifier is reported 
only once for each function it appears in
make[6]: *** 
[/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:97: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/metricgroup.o] 
Error 1

caused by c1ef510a0f2a879bf29ddebae766ec9f0790eb8f ("perf metric: Return 
early if no CPU PMU table exists"). Dropping this commit allows the 
build to continue.

I had reported in the previous cycle that 00facc760903be66 ("perf 
jevents: Switch build to use jevents.py") was causing build failures:

https://lore.kernel.org/all/6a577578-8adb-aa70-1bf8-b1a4573152cf@gmail.com/

do we still want these commits to be included?
-- 
Florian

