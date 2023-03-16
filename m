Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C005029A2
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 18:58:53 +0000 (UTC)
Received: by mail-qt1-f182.google.com with SMTP id t9so2910603qtx.8
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 11:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678993132;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wlCRV7G1Pgp5HRqOyDJ5n/8HXIVn3jLn2OEG+oEehvw=;
        b=dicNdp8Lkt+cSW7Czak/MMcRQyKpZQc2ZR3VTYX44XbPyo9z5zxhl0XGCTvHEEIjbZ
         Jva0SXJzb8+mXjilatGxaisM8E0x7ZVqfFnd2MmnJwLG6SCSOPmHkoiqp1v9Yvvyo/LO
         e5cQTe1SrQPswkyc72UXz8yNwV16tD7HZJ2ukW6pj/J550NDidWmjabsfnPL5rhHuED7
         x/zBwGHT3ikb96SBZWrCR2luLarhGVkImw60AKaI7lPbjiUGNe0Mv2vMoopWf7BUF5RQ
         +B+WqpYSpAMP+VBZ5+zlT8ACQNZ11Ff87US1u8IHBwTR6vyWc2jnn9FtpSPtTPne/onP
         MpcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678993132;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wlCRV7G1Pgp5HRqOyDJ5n/8HXIVn3jLn2OEG+oEehvw=;
        b=yzFQDLYmY/3sPOsanRP32NjfLTKu5LRWa2oV4j4n9Zn44lcsPWvvhqGVsF0aK2cEQX
         nm4jcwyOEQGRhA4bhRIzaJbgGPUgcNQ/DyhCWAjfiOn0Jp+9YoL/7BZ8TT5n0n8J/2OD
         pqh6tTQSux3PXlhhzt1S9GGBzAVfX0lizK+Cj4jlfmJSXGHTIZrLH5ebWP3vjSt9gOhw
         93YT7/V6VONurmNcC8FzfBRcgA3tAGpPtfYE0DSPcf8m5BWLnW5dnIbdqPRUJfNE9+dt
         i85DnelPC5NuRdniAP/nCyAQlKGr2bpFuzilxLpcaQ9r1U+tUDZqroR4utlHngw0AIFE
         SScw==
X-Gm-Message-State: AO0yUKUiPrUz0t+2TEBpKm69Yu7uY1Uns9ct2PS4Et8N9HmN5u/GrZsF
	DgoaYzJQQJKDzX/7rxQddJo=
X-Google-Smtp-Source: AK7set88kxIDx2a3+4F9yjKaHVtSZATvUTFAOszrSwqdWRp+PUy6Dz6mgwa+oCgfJdt+aSLoZJp6Ow==
X-Received: by 2002:a05:622a:58a:b0:3bf:d13f:207f with SMTP id c10-20020a05622a058a00b003bfd13f207fmr8052190qtb.22.1678993132637;
        Thu, 16 Mar 2023 11:58:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g19-20020a05620a40d300b007290be5557bsm110251qko.38.2023.03.16.11.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 11:58:52 -0700 (PDT)
Message-ID: <1df7ec63-5842-4589-3a48-89eb7ce76766@gmail.com>
Date: Thu, 16 Mar 2023 11:58:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230316083443.411936182@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230316083443.411936182@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/23 01:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.103-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

