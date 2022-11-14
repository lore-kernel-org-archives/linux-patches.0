Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28838490
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 22:04:54 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id 136so11462057pga.1
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 14:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d2jCM4x0/Tsu7VY/bbamaZRgsKGNu6Ft17DA28cP44Y=;
        b=jNgLQ7fEF1qPFVYF35Amg+RuRI4kaanMBTnQwI9xPcNLpg4FzUrSNB1CUubyvvx7iN
         fYVBVYuJQ6ei9LpGQzOECPO1qqszpLpnVdACfWgh/w1IJjcmMFIu3t5n6Pl69VwRNjEg
         YXRmy8LWtOdxtZ4FjlEOISSRsu79ECnqbFmeUONXXSUJ5TIBeNyF7x5T2zmKlOnUVx4q
         NCpElZ13XaAiRrgaL/ytD8oh5EfXoREdEi14xIA4RhMCAePVZzMLi9zs/OrrTssUPNZA
         HjyeGLsIuyO1QFinhpf4mBzraFntNvYvrfThbGGbpDmyQNIEzJxqJU/ujWTfg+AsCt8/
         PPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d2jCM4x0/Tsu7VY/bbamaZRgsKGNu6Ft17DA28cP44Y=;
        b=eltDyvUbG1uWZ8iCPPNmibBIVhhlYcWTdI4LKJX5+TsOmrc/SAq65RHB+yQrsOLrGu
         PU7KCwipXw+QhgW8JcpQSY727l3hRzwMV0IrAqfJkLXDoURi8Ju/qbIqmr//NEOXACX2
         RuyLvsDTmPBHTllkDT8D/+6tFZClG//VpfVNlSecwaeVp09mi7aq9lhxMjQhkzU+ruKZ
         wRGHDTgmRgtMxhK9MX9or88Nt1eGKylgty3KxtiXGo09AFAe2p4e5+S+8GadDv7Syxqo
         9+QxFVBm5XS6fUkhWFo3FVfHkhgwMigtWcG393N5QQIBtUvfffR39bCch4436DbLykcX
         ZdGg==
X-Gm-Message-State: ANoB5plT9uFkj3S8WNPYzJ52VQMTIwvJkURaI8z5LfM5SAvQ6Eq3YIVl
	yhWiXdky+2CgFSUBmLBCp1Q=
X-Google-Smtp-Source: AA0mqf5gZvxJ+PlhS1niYMXC1lJpGF2BmAFtkrU73IonlIMrtJoeDnwaK5eXLlu/bCV53h/bnF/Tfw==
X-Received: by 2002:a65:490d:0:b0:476:aad3:90df with SMTP id p13-20020a65490d000000b00476aad390dfmr1101273pgs.159.1668463494165;
        Mon, 14 Nov 2022 14:04:54 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id kb6-20020a17090ae7c600b001fde655225fsm122912pjb.2.2022.11.14.14.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 14:04:53 -0800 (PST)
Message-ID: <82e3211f-34e9-976c-98a2-ccbdaf8f4ef6@gmail.com>
Date: Mon, 14 Nov 2022 14:04:50 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221114124448.729235104@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/22 04:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc1.gz
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

