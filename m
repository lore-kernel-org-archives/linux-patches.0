Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0798490
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 20:26:37 +0000 (UTC)
Received: by mail-qt1-f169.google.com with SMTP id a16so3597547qtw.10
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 12:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rcRx1iOzeEHZanYkE8bGhrElsG764GjfvNJrIdjSpSE=;
        b=EH9sGORcrxPkpJIGgXTqF0bnLJRWC1tzRxwIw+Q8Whlrje0bhyAePt4u67Tg6vzTxK
         satVJ9y6zXFvImMyMjYekSi2prcvcLgdEMYd4SKJGa1uD88pfJK/xXIU1Is1T+VXdg7C
         GPJU+15+hJNMeAbbl80VSF+T6dsHUfYYhvc57ct5ZSjm93vUe0cEbekFdnx0CF736RaD
         mw/v4XQY0T9EZvHT/SBc8Jl/GpF3En61LQMbIIo51RP1AHtXcV4kR+S3qP5Z1j11LDt+
         4r9bKXof6XKdoh+qKRRrQVbuLuXV/XvTlAMWSlxwp1UVHFQkzNL8pmKeiltFwYOX5BxF
         Optw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rcRx1iOzeEHZanYkE8bGhrElsG764GjfvNJrIdjSpSE=;
        b=3XmybzDEzatNQhxaEnD/5OWmHSv5PBCwNFBkZCkIpCy85EvN2I+gaBuiUnNPmrBtxU
         SMYjrfMUy7ksQUc8CYyeRdmNU9p1BUGyWCbnA1khHuhsCWnXklzqS/2DfbD5ToPzW+57
         Y5hT0xESQSZNnPHtEOUHKfTAp0qAVoLL+TExCo3OurA5oyFiAXqgWdIzOhEAhcSSXe4E
         bb7WH7TouPN8ZgKCoNHGiyFDl2dpzeutEJb55nmxnWWkrsBzcCdY3iiUepqai29MUvZ1
         KGpRaM8HYy8rX1w9hoHLrsrDoQsuWiOGfWBiK3XKApunKz6mA31Ki+FKrO2VDLX7OIUi
         DjVA==
X-Gm-Message-State: ANoB5plH+sO6IRLyJPmfyMjl62ZSiqxRkey8tG8szG167L5DrGGFOvF5
	URemHnJ8fyzUJEKfjHcP+rw=
X-Google-Smtp-Source: AA0mqf68KfR/QxmkWifs6d/s8rQecBbb0g1rZ1GJPSQzTpEY2hwym72KmjU2IHEfpwMYDOcwNUZTEA==
X-Received: by 2002:ac8:4d01:0:b0:3a8:28d1:4541 with SMTP id w1-20020ac84d01000000b003a828d14541mr17595036qtv.66.1671222395956;
        Fri, 16 Dec 2022 12:26:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f1-20020a05620a280100b006ee949b8051sm2170694qkp.51.2022.12.16.12.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 12:26:35 -0800 (PST)
Message-ID: <925e3609-7bba-2045-1184-a6b0bf8f2b45@gmail.com>
Date: Fri, 16 Dec 2022 12:26:30 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221215172906.338769943@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/15/22 10:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.84-rc1.gz
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

