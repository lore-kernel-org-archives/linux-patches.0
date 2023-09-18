Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F562AB4B
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 22:24:22 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-797ea09af91so32794339f.1
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 15:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695075862; x=1695680662; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9RqMXMvzJ54l6rW1/jkG7Qf45IJeJi55QA1eHCfUXCU=;
        b=AJq3DXTiHG59BuN2pKviZnI8gbvK3NLDwW64g+Nj1nuVOF8eK3KHRTiuzghamT4mxO
         Ei1QNnPQTGx4CYX//00cHBQYQC/46yhpi5bxcp10LtP2rcVTntK9XQK1oWc/mXMNzL9i
         vZ/3fMO8aSULs1eqHj/Z7P2WnC/qDPGAhqctg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695075862; x=1695680662;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9RqMXMvzJ54l6rW1/jkG7Qf45IJeJi55QA1eHCfUXCU=;
        b=nfq4l0fYjxqC07WKzImfN+FxbwGwNXlaEc/7CDo1SUpdJme8ApRJZEh/9P+qospIMi
         eEOWQ9uTeB1Nqn7YxFUENUny7gvyJiZo9nP0WlPdf+N95IhuzdfTmrDwlbNgHLKCA17q
         ZT4mx4VjJwpuU6lWOVDeRNRVyVIrZaOrwtmHjtLLL9HXAvgpyehwoAxEDqiSNtceJxwM
         UWrblWAI6Z00q/qfmodXxMdv/wwQdG7nY6LK15buJqJjmWqhIlFGabYblHHItwRZd3wR
         lKA2yiPkufFrkfYR6DYIQokPNOgOPYnkLMFcPGsbEfgzu+Sdo0/HQW/kEvpUq+BPeTIG
         sBLQ==
X-Gm-Message-State: AOJu0Yz3Jjot0BCNUxjxxHPVtp4n6aXt4p0eY9bKljuw3yCQET1RVx3a
	5OJ8RG8GVz7pLXvsYPdlHvAzZg==
X-Google-Smtp-Source: AGHT+IEmtCaZtQgtls59oQZpAxJpiYXqY4y86H3T39IG52afnMK42cZB9aR/M3OM9LrWBKmola8Z9A==
X-Received: by 2002:a05:6602:1681:b0:792:6068:dcc8 with SMTP id s1-20020a056602168100b007926068dcc8mr14432162iow.2.1695075862083;
        Mon, 18 Sep 2023 15:24:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id h23-20020a056638063700b00437a3c128dfsm3133587jar.108.2023.09.18.15.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 15:24:21 -0700 (PDT)
Message-ID: <5b3db5fa-0bc6-f455-cf08-c5495cfe434f@linuxfoundation.org>
Date: Mon, 18 Sep 2023 16:24:20 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.15 000/511] 5.15.132-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/23 13:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.132 release.
> There are 511 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.132-rc1.gz
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
