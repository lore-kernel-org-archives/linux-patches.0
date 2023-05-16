Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EF31FB0
	for <patches@lists.linux.dev>; Tue, 16 May 2023 01:22:34 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-76c56d0e265so47934039f.0
        for <patches@lists.linux.dev>; Mon, 15 May 2023 18:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1684200153; x=1686792153;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ac0ioQ+c/agX0WRk7EeCUVraJoAhLJrQS8Kbcj9FXFE=;
        b=NYP3izrDKGFAKo9cBmRWpQKR6CChN6VnP0SWN/kKVdhE8JVMhJbMqbOG5sxG3UkdE7
         DjrkEm04JHWfQmwc3nITa+Fg+gDk80wTapsJwJCvMTNXET8oz231b8ldndv2NRXUMd90
         lD3cRBi9FWmhQQDSGlYpB6qpd0ufgBXbyCcss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684200153; x=1686792153;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ac0ioQ+c/agX0WRk7EeCUVraJoAhLJrQS8Kbcj9FXFE=;
        b=NalsvAsAYjJKuphfXhH/1QEZM0nKnWidCmOvPlaUMSdgg8rACB5BRCfuDj40dDIg84
         ZPI0XLz7+4+OnS0fVdt769QcWLrCQ5oTdA7udX+dEdENM3UzaPGrzswZExqL0+CZec/t
         EdJ2ParfSRNL8hCxpbm+6I7wrpDvtfXpoe/4j2D5vYFPdR6FqKs3SufBXTwGLVGltdSc
         qBLDo6gq2Uk36+dA2EUVlM6G3A01oMnmHdUkYsel0DyUuCG05zHmBp0m5KGqT1v0VkwS
         57Le1ftFj4yILs7rmwW8vlJRuHv76GXUwivT5Xkdn/LjURJat0NiINeJkDjlyMFFne4Z
         Lvdg==
X-Gm-Message-State: AC+VfDxRL3aSkQAii1r2GGyaUuAZcSb96m7XMXx3HdCnZFZDEFtMUIGW
	pdnjZdksnKcWJFPkW/qj5+0HAg==
X-Google-Smtp-Source: ACHHUZ7GIECJNU3Z41yOk9WmJnpNx2+ypBsPtv5STNILsOTiATWOHiIRettKcCXEe0mkzYZKBIGpjg==
X-Received: by 2002:a5d:9da0:0:b0:770:4c3:cd0c with SMTP id ay32-20020a5d9da0000000b0077004c3cd0cmr2083290iob.1.1684200153524;
        Mon, 15 May 2023 18:22:33 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u10-20020a02230a000000b0040fa32ccb0bsm7126442jau.79.2023.05.15.18.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 18:22:33 -0700 (PDT)
Message-ID: <1f28967e-19cc-4911-4e7e-4387a3093bbc@linuxfoundation.org>
Date: Mon, 15 May 2023 19:22:32 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.2 000/242] 6.2.16-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/23 10:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.16 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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



