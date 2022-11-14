Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31F4EA2
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 22:33:18 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id g24so11453328plq.3
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 14:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ObnPkYP9VPHLOLvmYFnfmYoPmSZxQGJ5X5zELinPx1M=;
        b=YymYRK9EE+gX1+Ek0dWAYwMDdT6L4cpJL9lJQsMZibBYAVVIILjUdgcu3jP1tc0rzn
         C3mxhtEyu+DIRjVV1ZYypjaSBKxQTjmNvFT7ZUqBUh5cFeaIY8lPHXWy14u4MRTJYjeB
         xhnY9E3I++2vkE4sxLGpBdmaa25iYG0yiAuLPz3B+JaElSaBEmlHIr2Vbp1HPX6Kxcfr
         mrX4XxVZB1EaQYpewL5bBDO1APQLiHJfXWVO8jvjRD7+hb2ML1Xt+T6bT0qg5PqxYWwe
         tNBJdFh4XUYFkmoUIBeDFiKCChzTB1hugux3/ZGbdFX1tpAIPUaMIGt/TobM0pURE7fM
         z9bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ObnPkYP9VPHLOLvmYFnfmYoPmSZxQGJ5X5zELinPx1M=;
        b=aKfm+eF/cKD1UuSLaFPTRt1w0qjzLDDPL4JRktVK/BqzFO56AsWFhuK1lyoKH6pxIc
         A+Wz/qkoYdMK92NDhbWADgCR9z01QYZb/Jb5m4u3A4LJVeL9zsdnzZB6T53bYhvICuqw
         k4OtblkFDHrij+pJozT/gAelFJCvtiuh3HQbMfqOegJcf8MIFBOAVuZTYb1ojuaoMIVC
         LIKfgXAJdHpjG8/ZvHN9yUXF+bB1hxFEB9piC3riNwTdwud4fb9e/qGNWqJlx1jKv6cN
         DpMhDjv9dTElXX23WJzh8lU6pQIEC6P42YToWSElRcLfPdFuL5WZA5fyY5Q1lCNolpil
         DziA==
X-Gm-Message-State: ANoB5pnwOlhq4l7EmzBLEjEDIu9oa2tOKvQjs+flB6x8R5h6kkM+rCtT
	i3D5j/0oTcmCn5ZXSd4Mi+Y=
X-Google-Smtp-Source: AA0mqf4n2XQ0bxWpFtbCviTJi+M2vDFbL3p8vni35A3arpiMnRgs/2M/jabQQ4FkpqszwFQIhw3qMA==
X-Received: by 2002:a17:90a:af92:b0:212:e307:b59f with SMTP id w18-20020a17090aaf9200b00212e307b59fmr15887409pjq.208.1668465198236;
        Mon, 14 Nov 2022 14:33:18 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z25-20020aa79499000000b0056ca3569a66sm7242901pfk.129.2022.11.14.14.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 14:33:17 -0800 (PST)
Message-ID: <b42b369f-827e-5ac5-664e-c70fb4ed82e7@gmail.com>
Date: Mon, 14 Nov 2022 14:32:53 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221114124458.806324402@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/22 04:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

