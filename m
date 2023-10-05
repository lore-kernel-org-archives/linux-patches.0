Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8CD374
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 01:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jw8bOH5Z"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-34f69780037so699325ab.1
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 18:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1696467716; x=1697072516; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NEnsQWLeaft+J62oGzu134FsAlbV6Xt4/uQ7daj1HXo=;
        b=Jw8bOH5ZNf6kEv5T3QmxqTSHLNnpg36bVf1K2p8jbGpDSKkH/DNHNJW/Y9IVghWOsv
         Xrs2WTkicQ/wS+J4rZM6ZTTceyt35QCUmjrMyKFOH43fMWeVXm7Yl895Ez7fNj/vs78k
         CH3qEhVmB0BYho2uAeJTF4mzDkQ937+yNiUWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696467716; x=1697072516;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NEnsQWLeaft+J62oGzu134FsAlbV6Xt4/uQ7daj1HXo=;
        b=Z8XNUn6uLab4tVvmiK0wGNZEX8Ea5EQtCNBvWAT67hVbUTRilp5s46OTnGFbis350M
         VJ8iPN1FMmBqBrFwkibxr79//9+tv/KGQGAF7/Fw+qhD9QQFdH3CmIeQicdnZ8m0Jtpx
         agoIuHcHpFuUokr3v1Yq3jPkpJl3JjU/X0A1N+4YW+wG4MfCaFV8ZkVVQZ5shtNevCuU
         faRFJwaZx0ZuUbdHQjrYfDDnQVuGrjpRwlZDldgK7nxo6eBHKc3zpv5Ctj8KEl8b6S2E
         Q7n9SmVaUDa5dlq9Qpf+upwvtFdLuJd7BWT8n+UFX7lvk7Vjp2AUxWyNcEJSC7LjeROI
         DqGg==
X-Gm-Message-State: AOJu0YyOgzECbnGpqglQxpW9icM6GCe/cAos71uXF+nri9Oji4veu3Mv
	yQhu47hsc59bVdURF2+i+qwl2g==
X-Google-Smtp-Source: AGHT+IELtAlxB0w589CeZedI82KQxlHVq6CHeVvwJf9537KGpS4YfFd6poKmDUGMkVZ0CWNB2QgycQ==
X-Received: by 2002:a05:6602:368c:b0:792:7c78:55be with SMTP id bf12-20020a056602368c00b007927c7855bemr3794431iob.0.1696467716574;
        Wed, 04 Oct 2023 18:01:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id fx13-20020a0566381e0d00b0042baffe832fsm139452jab.101.2023.10.04.18.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 18:01:55 -0700 (PDT)
Message-ID: <00d307ec-105c-4cdd-a8b1-73e4ad030cf9@linuxfoundation.org>
Date: Wed, 4 Oct 2023 19:01:53 -0600
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
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/23 11:53, Greg Kroah-Hartman wrote:
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
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
