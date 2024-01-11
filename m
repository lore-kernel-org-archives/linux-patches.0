Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A6359B6F
	for <patches@lists.linux.dev>; Thu, 11 Jan 2024 23:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nFSDkJP9"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-28c9d424cceso4193253a91.0
        for <patches@lists.linux.dev>; Thu, 11 Jan 2024 15:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705015495; x=1705620295; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9zoWmFoYkKu4HBJVGwO275SshfSpYBWqc1pCmIP2iww=;
        b=nFSDkJP9NRQR1k3KCmHcDHRaGTZKCuZzpwCudVXYCztsyaZTfb/cHUXohQ3NsC8Nr4
         6V26qUbEy09nsVpYeDmMsZY66IB9CCTXFGwXltDfM5PExPq3ldauf0CdYf7fOt3PD9bg
         DRG9ckFFcEPXzqQiNC6sLcA6TeLc7hn6LWwr1e1RwOv16ttWJ3sZSZm7cy0yZZLJZGb1
         idEs35OFMjHe7X9YVJ8EGhG7CtQp5q4vnuGJB76/J7dAx8SCRYgiOYcXAyRib3uMIHA9
         dncaVWCYrqZiMg1z2lXq51R6UoEfXA/TNmE/WHWrQmCztMFfIAp5/1Tepu4/I5fOY6ai
         A6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705015495; x=1705620295;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9zoWmFoYkKu4HBJVGwO275SshfSpYBWqc1pCmIP2iww=;
        b=GZUg/o/+nYOiZvGZ02D9lQTkaN8Kv4sPVZ3rnc1USvWwletBC3MrNCFaWtALxeqcN/
         HaRsMYb0VjvJzaxaHle9hqBo1hctl9oshBj7p3hXuINwnfCo1Mo3FIQYHfoFE2br1DLs
         LJhf8Pmix9qy4BcB6PFgk2p3RYIRVRY9QxWLObClCQjmW6aWPNcBcHNdxbjFmSvxQn3z
         sCL9ZoCUMoa0yhwun6Eu2VAV0hMU0cFBHcNK08peTr9iWsfsbGdrtwaT0CCMrgXUnviN
         bVx8poYT+th2Q6RpJSY2zTtjvBEHbs4OQVn6Ly+CDyMeMqOLizC33TZuypqDnXntk2QD
         rnvA==
X-Gm-Message-State: AOJu0YznBKiIooaN58vN47zCs1+5BSJwX1fvx8ywbMPmGDEPzeFo9/w2
	8srnbhJGnX1bfSSoVyfwJww=
X-Google-Smtp-Source: AGHT+IGWZE4gB9+B2RUPYypL6rlRC93oxdf4Aigp9TozTAlb2bl06PhD3Oq3MZkBSEJqJc0a7CXCRw==
X-Received: by 2002:a17:90b:4b03:b0:28c:7e73:2485 with SMTP id lx3-20020a17090b4b0300b0028c7e732485mr2181349pjb.36.1705015495237;
        Thu, 11 Jan 2024 15:24:55 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h28-20020a63385c000000b005ce71f1440bsm1781548pgn.72.2024.01.11.15.24.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 15:24:54 -0800 (PST)
Message-ID: <29e54f0d-aa80-44fd-9fe8-311faf87cd09@gmail.com>
Date: Thu, 11 Jan 2024 15:24:52 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 0/7] 5.10.207-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240111094700.222742213@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240111094700.222742213@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/11/24 01:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.207 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Jan 2024 09:46:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.207-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

