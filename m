Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4AC8F57
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 19:33:10 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id i10so11147603vsr.12
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 11:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lFKwihPvKMpcXpSVULfJwtDOJkGorAbMoBn7I+sY6j0=;
        b=MLghucnahrx3YDWgHuWWZd07q404MGwEweT67Hhwy9Mse2bTbTBCkpUXIGdA/8v4ec
         1hLzjsajdPoFMOu7MD1rpCaxUjgAp8lmDbA3j7e+3r5LODLJS/qoZk3HQzy+W+HgCshI
         8M8J/lENYW1k1SYb3WcIMgEq7jUhqxJInLlswtvwhko2f2RfCeTL4kxXSMheydlhYgSX
         utYi0EpyEzcOL4rtiTN7AS/3pDkkWcRBI0lmepL/N/B7V0T2RGGkseHHxF7Cm/zB3obg
         QY73jJJw3dRCHR5lij5STBkKFY0/D2STodTRITvFeAD+Cg0yuuMBNRHZmRQd5TsaxOzz
         emUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lFKwihPvKMpcXpSVULfJwtDOJkGorAbMoBn7I+sY6j0=;
        b=abmkUg42Jpt8MkDpHZT0TLs+LHy0ZpTrr8+uRsiaaeSYyTpM5eM9NmLAiyqCCgLgPD
         URJK7wtfuAwe7+fJoYk2oJuMkiDQkv1UvZhUUC275FGnEYy7pxdtbfjDQ/xwBpNnWH1Z
         Zvyi7uoyUectrJUE4gAXzLSYFu+FkoGzPMluhssbJT/gNXc1um7RiPEz47ylr2tXtoLz
         VGTk99BbWL8pfBBjXt/VdFeOsjHbHIgYWGyXbl5ouvVuIcQMBEEWU2TcpozEI8TmBslW
         EPp3RhTdaq1j4iyG9Ns4UKGQISVN+fTiwOZI9FjyTlAuWT5M86MyGxinj6TPJdhkcvuH
         q6Gw==
X-Gm-Message-State: AFqh2koZDSTuVJ69eQq+cyFIc0fInqzf0tUseO2m+LxZPdxC3f8NfDYE
	wQVb4rlawEdEUy5n0Yts88q0AOqf4ic=
X-Google-Smtp-Source: AMrXdXtaT5qDQkHma3K3lFnkjH3J81z2ePBPS7emp/cK7CZwix+GhyYG9AWUw3u6dD6vVMYvL062Nw==
X-Received: by 2002:a05:6102:185:b0:3b5:1edd:79fe with SMTP id r5-20020a056102018500b003b51edd79femr18416073vsq.21.1672774389337;
        Tue, 03 Jan 2023 11:33:09 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r17-20020ae9d611000000b00704c62638f4sm22439767qkk.89.2023.01.03.11.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 11:33:08 -0800 (PST)
Message-ID: <26f54e70-0453-9a0d-b032-5a97fc4fb6c8@gmail.com>
Date: Tue, 3 Jan 2023 11:33:05 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230102110551.509937186@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/2/23 03:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

