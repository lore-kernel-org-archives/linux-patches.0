Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2762210F5
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 00:47:03 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-777a9ca9112so49629839f.1
        for <patches@lists.linux.dev>; Mon, 12 Jun 2023 17:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1686617223; x=1689209223;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lmjM/dRJidQfKguFBam2mPgsQsHoFPzaRQGo375W5P8=;
        b=gAMbBeMggeuiAjdgkrulOmgIVAY7V5E6KWDdOurzhW+Bc4BkbTjixYbFK3styWR1xT
         U2j5UzjWlNRKQ7iigc5MCrjlMEf5zXi2KiezqakvxZMDlyhld/4dimIkOd5qPq8qYuvQ
         6Vv6Us+h2VuC4J2KS2sW3jgKR1liw3O0lRhmg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686617223; x=1689209223;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lmjM/dRJidQfKguFBam2mPgsQsHoFPzaRQGo375W5P8=;
        b=ehBsRBf5vFXO/xhYSWg7uh0PYLdLmpYTMDWZ12CSmmPzVY1k0vATxFvw1TrOQ5KZVC
         5pv7SbMUeWGKRxRTbL6jn8KNOSFDuNVTz6dffKTjFWIf7g1g/NlRwZbkHlvjQROwSsmr
         m05ZtcF0bpR0QoNBYK/G427D5LRcPK6eQIujR47348VptDbSyTupxpMLqsteuMfZcSTr
         wOSssLd9vta1EZ+oXq4IP+TdJ7yqPFqpzG9Zy9fnkdJv/0smAxTx5hZEvN5gyTcRQDiW
         6PDe8+6MLpR2kLzNC0dgAyQsbjSLClCbxAYzsorQNy4hSbTbgt+yL+7xEOGSMaym2XQI
         2jgg==
X-Gm-Message-State: AC+VfDzXbaoNO7qFis9p5RIXccRQ6JVSxJAZpAry+Y2Z6Mf7b4NHvnzq
	brKoYjd45sp2rTMVbBF852HUhQ==
X-Google-Smtp-Source: ACHHUZ7Zt0PUB3W0hglufQF5/lfwOVJDETIXODth+qZK6FonW+iF851KtxvZ4jXmJx1VrNbqXjGXQg==
X-Received: by 2002:a05:6602:2e07:b0:777:a94d:a362 with SMTP id o7-20020a0566022e0700b00777a94da362mr9730462iow.2.1686617223020;
        Mon, 12 Jun 2023 17:47:03 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ee24-20020a056638293800b0041658c1838asm3082379jab.81.2023.06.12.17.47.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 17:47:02 -0700 (PDT)
Message-ID: <559744de-1f36-4b36-2dc6-c14354fd4e2b@linuxfoundation.org>
Date: Mon, 12 Jun 2023 18:47:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.1 000/132] 6.1.34-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/23 04:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.34 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.34-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
