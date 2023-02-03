Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB95AD5A
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 20:17:11 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id m12so6857749qth.4
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 12:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tz0vkX+QDBEXSWfMljU2RoqMurA9Jj1S2vJ9oKVLxt8=;
        b=aXJoYibQR7crF+jW9fEGAoKlJ/KsYWmA5ifgHpQ0/K0l8n40v9AZANBPYjnQ2d5IQn
         1di2VGiN+y3Is5q2/dc0EQjaAtmQaHNeNoUBO0+BqlHXE0Y+YoHyZHMps2sXfS8y6QBs
         2sT51xEeRu5weYRRGgQJqKmZeuWvIybeAtOUVajqbvt+fm1y+rKLJlt0rMs1D1rwewux
         mlszvBjqFy8Dg7ZPbtbo70D+jePKpRZ6SxldplVPlZVBtqXwMNPOC3c7725E4aROxbPt
         YSa+El7DxBDUJNi0LfikJBPmBdIrA0AoGzfhcNvI9mlxodqJAA0C1xQD1w2FEuu9/p34
         WjvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tz0vkX+QDBEXSWfMljU2RoqMurA9Jj1S2vJ9oKVLxt8=;
        b=JiBltq8zMzmRfY2B46A+/eps4QBZXTAnUvec7zdqZ5miZA03CWvFmf0cMd9zSpGUKq
         ygTujiYdMlgTWb8c+JVg6Jk7/ASP1sdmlUx9tq5c7AQv+bZ0lRv64jpElZYS8R0iI2Mv
         SvGoscMFeartWAfqCg2kmpHeT0tAX39HuC1ArwqxjhE5ZqX/u8O4Cw/ocOyc2PUtpTFb
         SQhQgicRrinZrSHNNlbsZWgdkKmf+07ORbyZbfqixiwItemo17cQIJ6yNribtXAa8VxO
         3pyl4ezwBIwskakXNRwnhgpZ3FoZYC7MKz8S7FgOVY4+kEdMiO60tdB1JxuDoeJngwD/
         PcFQ==
X-Gm-Message-State: AO0yUKXhuSVDWibYDFZsQdqDwWlkMe0LBMUQLvFuM9a4bLR5aIFC8M1z
	UNG2u6cPeAQS3uEsUbvbTHbk7rFd8ZlqQw==
X-Google-Smtp-Source: AK7set/CmQZEZRWboM3v9kcrW+AxXPaCGo0l2YSRSUATFBKPk0vu9Ry5Ooq/EcVNGZ55Sz3o7olD1w==
X-Received: by 2002:a05:622a:2c7:b0:3b2:e2e3:df2c with SMTP id a7-20020a05622a02c700b003b2e2e3df2cmr22328219qtx.57.1675455430620;
        Fri, 03 Feb 2023 12:17:10 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 3-20020ac856e3000000b003b86c0046a0sm2147233qtu.20.2023.02.03.12.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 12:17:09 -0800 (PST)
Message-ID: <c10eefe6-af9d-94da-dcb5-a8f0f5874dd8@gmail.com>
Date: Fri, 3 Feb 2023 12:16:53 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230203101009.946745030@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/23 02:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

