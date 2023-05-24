Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7860319BAA
	for <patches@lists.linux.dev>; Wed, 24 May 2023 15:51:55 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-64a9335a8e7so745049b3a.0
        for <patches@lists.linux.dev>; Wed, 24 May 2023 08:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684943515; x=1687535515;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FoCJgGw6RaF5aBLZX0Urv93vncHZezr0uY9aoDQyptk=;
        b=r0poMKa+YNTBTvFt0B2CThjvDnIHIu83bN9p0TXYIT5lfBncPZz0SHQ5sKLn60JLbk
         YRqxSs0jwlV8gbdnxVhiE3Wk5WkF6ArJtVDweX5rSqovqtqla7wJRmiik9RkP0QCx4pP
         NFVKMNQn44fJMmJu2diSLYuKy70Q39KkofFEzZpG3RxAHPEb8gvWkIkThmFkqjC905A2
         07pI1R7eKRL4sQtQ5CLI/4loiVE3Q5nJJ/92ScQ9pAF5VdcMwCHUovOqUjvDO1xYMPsx
         62kweXBBE5MghU/wQWj8lb6+Xk6JIbkqrxbnHl+PviHtSsQWQEIjk9sXNuV3sc3Wz/sf
         foVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684943515; x=1687535515;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FoCJgGw6RaF5aBLZX0Urv93vncHZezr0uY9aoDQyptk=;
        b=Ifx0okspZ3+XuKa0o0/Hv36yGpzmiz0XPLcVGwBwb2/FZzPOCJWM0n17565ZocTBT6
         VGzAtX/ZIzpaGCIRyj0vOXb2Hl54nIvxzc4Zt4qMXZdIBuyzLNb4y9se7y9q3Q4CvDYG
         bhaom5d44bNZo3JQi+Bfjrxp/mnjBUeb33LxtMAjDEd9+Rr4lAtpkA42jrgpQFzOf4Q8
         2ZlmyZaTUjsKRk/02R5OWW3eXQdAjZvzEl+C+OEu7rF2/AMBRH7ntWdT6E2siXHVYE3k
         kP0eNjO+M2bOpMWB4ZVEeGcx/BTnVrtdsRkwi+/IcNULlaAYWwKKnW5ObqFV14VuUZj5
         7k2Q==
X-Gm-Message-State: AC+VfDz4fmB+/yu+u49WI12clKXNvReK3bP+7tKzcRuj4Hv8pYCqqOya
	oehcgLUCksSMMDd2J+FiA6I=
X-Google-Smtp-Source: ACHHUZ7cTcMk2I5ELHxKwj/ybsdZ2jdxvXQFRt9m/rkXb4UCKNmtxALrbyymkJ+pkuesKKukBOaq4Q==
X-Received: by 2002:a17:902:d4c2:b0:1a9:6604:2b1b with SMTP id o2-20020a170902d4c200b001a966042b1bmr17809754plg.20.1684943514703;
        Wed, 24 May 2023 08:51:54 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id i3-20020a170902c28300b001ae57277a87sm8922057pld.255.2023.05.24.08.51.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 08:51:54 -0700 (PDT)
Message-ID: <52e30fae-36df-f098-2b1f-e7e9d00c8f0b@gmail.com>
Date: Wed, 24 May 2023 08:51:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 6.3 000/363] 6.3.4-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230523164950.435226211@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230523164950.435226211@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/23/2023 10:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.4 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 May 2023 16:48:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Greg, could you queue up:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3522340199cc060b70f0094e3039bdb43c3f6ee1

thanks!
-- 
Florian
