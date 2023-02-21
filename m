Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431788C0B
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 20:10:24 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id d5so5471804qtn.13
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 12:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vVNMp/uOSdgm3aiZQpiwOdbJXNSKmy2btwUw+ZwEUns=;
        b=n2rBr0dr2k+vbUeHlb52FLHaxupPq+nfLIDleIBQcCYsezWrsbl87kpa2d4bhHwy3g
         WjcfbiABvUYySCkYnV9X19SH9+L3Ep5a2NDfeBErpfDqZ/oc7CGl4MLm/JdUgbLBX1tD
         Lwk8Uzk5hDzX0CUGrmC/hEjOTQc8xppTEL/8ivfMZ3wPY6elhJWfhc3oBd5U2zcyKZmV
         4pwJ777AhONrQ0UIcTbVSHpH+sLDNfAeVZdpasaqJoB43WOeGiqZ/9MCmTZjakh/WA/H
         dyiRpWOvg+p8bIqkxjGQ9QYk26JVUupWjEFZp6WN9g/ozXQR3Riq3rzsZ88HUIRScmMO
         uKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vVNMp/uOSdgm3aiZQpiwOdbJXNSKmy2btwUw+ZwEUns=;
        b=BJ6RLo16Bu2qdinyYgUKeNT9VqclKwAAJRnv0j3/Qs/ErLRLl8mheSwVVYCYhYbWla
         1elKtbm5EqyGKzmUoyfO04VtNAv5740IvTgzfXuiQf/9qadyA5xl2vNeE1y25CvQmQfr
         6fOmBEwU2YLCwTWH05qcuk79gmjeWmrE3fOV9zLo1iF3UQlHMcLLHgcfYTY8MnAzcI9O
         o14BupY5rBuPMQPzkse0tRbkIVkCm5YCPBc8ghVPSOhWsz2auzdhRwXaERT9+qgcVJQi
         YfxhvgAThpSo+vf1XG/aGofhCUHFZEeUxWV4vvYot5oRTtNavabIcrvCHgDr9FfHZ0vn
         gsQQ==
X-Gm-Message-State: AO0yUKWp0tW4Jg9obYdKwkF3H9O9airo6CdHKYa83BlrIInijJ1wXH//
	cJwiinCjxTSUs/hle9X2KKs=
X-Google-Smtp-Source: AK7set+J50IPVaJ5yju0iO32/mGE6EcOt40t3k9qF6lUmEXOQ25ZiGXGO2yKwFdvHWFeLTrOIRdrTw==
X-Received: by 2002:a05:622a:1a86:b0:3bb:7702:97f5 with SMTP id s6-20020a05622a1a8600b003bb770297f5mr11745606qtc.15.1677010223102;
        Tue, 21 Feb 2023 12:10:23 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fw13-20020a05622a4a8d00b003b86b962030sm9273726qtb.72.2023.02.21.12.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 12:10:22 -0800 (PST)
Message-ID: <10d63bb2-6d49-d7a2-a5e8-d9114efb72d9@gmail.com>
Date: Tue, 21 Feb 2023 12:10:19 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/83] 5.15.95-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230220133553.669025851@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/23 05:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.95 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.95-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

