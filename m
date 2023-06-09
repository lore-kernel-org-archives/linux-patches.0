Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C91163
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 00:06:55 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-65131e85be4so1229586b3a.1
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 17:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686269215; x=1688861215;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r6hN9wMbwSLIBDVcm5SJFo8XQzYymvLuNabBXcg6nBo=;
        b=lMuAe2pfiTlWHpbbqlhaUJ80LV3jx0RHi/pmv0Tp6XhcAKCxhOXrRwe4/wGcMQ+gnI
         RycsIGbbBD2Gu6I1doizkO1fU4gOLLQc9vKRUgPxu77Gmr/Jow2aFk0VwzBVroQ0ok04
         lChqQoytYgOWPGKBdVPU2Fb8ye5GGdzHXmIKLYpCVPw/2x8H0SNz8NNnUmo+QGSO+WgC
         JFNCZMWoLM18CdWJZJiE9fAV+PvAbl0yw4DjxBtUmAULqXlaPwwRrcJMasww4ck+zwfV
         OSJikGzFaQzOb4LLZqA5yRfQ7voB9I8Zjsohu+5zYCoOn4yTvUdv5SJCi83WiGRlQAtV
         WFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686269215; x=1688861215;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r6hN9wMbwSLIBDVcm5SJFo8XQzYymvLuNabBXcg6nBo=;
        b=Dr7KTij7KI8soHAvAZOWTCsQaxIN0L6XPN5UgYRhsVsQKKolSmOxY5g4anefaMPCec
         AETNAsIXsk+5ERgvi1K+nr9bAEwpmAO/t12jk77MsW6HdEHTH1FFehOjM/ZZXxsh9WtR
         9aMEVBE5TGx09TPd1T/k7ionhug++Ybnx5ugYbqLQ+ycaGPgBgrRnDTG90V4XTlcLHQC
         J7ysuMwBno6dxYHwjAiAPaizmdC0M87+i/Q8bUYZoM353mS6KhODbdK5HCMwY7qNPtfM
         F0aWxTmMKcma/yLHX+8Gh+KNNE9oJEWzC441bOfUwCdUvrlLAjhR60bi+dEtk+K1ighS
         OBRg==
X-Gm-Message-State: AC+VfDwAfvKUJoXb8Da0zpVpJRrYGVxJrJ0YKV70EaoHOk+e+pYGTVPo
	ks7jZhX2mC3y3RsLWJPzhtM=
X-Google-Smtp-Source: ACHHUZ5SaA1jNX1L0MT2FtY4lXGt69R0JbYE7bx+vfgGKpSfIxkre59gAPAChXVOrqUpwqH+OBDH4A==
X-Received: by 2002:a05:6a20:3d21:b0:118:e011:5e44 with SMTP id y33-20020a056a203d2100b00118e0115e44mr3766465pzi.48.1686269215264;
        Thu, 08 Jun 2023 17:06:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 17-20020aa79211000000b00662610cf7a8sm1606588pfo.172.2023.06.08.17.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 17:06:54 -0700 (PDT)
Message-ID: <d37368c2-1800-f4ed-427d-ef1da822fba1@gmail.com>
Date: Thu, 8 Jun 2023 17:06:37 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.3 000/285] 6.3.7-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230608175722.489602717@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230608175722.489602717@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/8/23 11:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.7 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 10 Jun 2023 17:56:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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

