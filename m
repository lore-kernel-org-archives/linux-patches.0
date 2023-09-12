Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F1AA5C
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 18:06:44 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-564b6276941so4609463a12.3
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 11:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694542004; x=1695146804; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b/FcdXt508wzlUPKZM2U2Z4krLmys9jD7gjAAQB1Fak=;
        b=stvktxgp8mIVVkDWTZucqw9L+i1vt1/834ZZKZSjgWeQmEkuAuwq/U8Exu8vhaR1nz
         VkiVI6Zq4cXeH8f4l3/j+uJGZEOk8/8QMDCixcowt3/Sn0MwQA4HTaXDQfi63/Q91xEE
         nKVv2ukHAmRA0YiknQpQZlQHEsLKDHACvd2Cz3geHkAd55SwaysQc75a2vsCSka68d/s
         QIjOYVuYn6GeAPX7d4TLXOf9pcArYaoHwCTRVPyPuHiGy7P+T1aqFL7K8JPRtaA7tB8n
         R5EYqDlJMUiVRIDCYDVQEfkwuSGAVV0S7SrQxGdxPZF6tf+y+UC/aNgCD0S0+trA3yrV
         Sz1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694542004; x=1695146804;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/FcdXt508wzlUPKZM2U2Z4krLmys9jD7gjAAQB1Fak=;
        b=C7aIho7rDwwkTdLi/vdGiWSYdmsDmS44kZuYv1IkH33Lk1NMobJPIdUWZMoitQ3Kl0
         B38bTwe1rBKNnoqVGfE6/mn/PfXKL4LRoA7gN9MMUmxRs3KeI1bssqWzF7q6o/CUZ3Ls
         TYatbr9S5cKQt9nzsrNpXpNdyg5z8MSSfbd4ePdr2lnefKhnmibmmPtZO/EpnPsLnh94
         qJAvx1DM58Wj0GwUXGsnWCfz/ooB/3x0v7Vsh9QrOJnTY7JDiA4k82MWdb32hBD+t2c+
         0AdaIsYYtu5iksHVuBQm1rf0pt/p4M5pJH8KzeN2VxUzW+kOqD9YXUUKxWus63tjOr3y
         A/pQ==
X-Gm-Message-State: AOJu0YwNL/6n5ruqO4LpNSJB9lNVYxT2XT39vFZk+HtjQEmley2MV6qG
	7QAJgw7bO+cpc9ixSJeGc6A=
X-Google-Smtp-Source: AGHT+IF1qy2cfIn54//x9+QFzFdq2dCQpP+A7JwFxYGlzyHdW63t3FsaKm0KYnTcxA7a0T1vP4p3GQ==
X-Received: by 2002:a17:90a:520c:b0:271:8d4d:d046 with SMTP id v12-20020a17090a520c00b002718d4dd046mr58739pjh.4.1694542004044;
        Tue, 12 Sep 2023 11:06:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l3-20020a17090a72c300b0025bdc3454c6sm9449911pjk.8.2023.09.12.11.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 11:06:43 -0700 (PDT)
Message-ID: <0903ba48-643b-7091-0ca3-e76b95c7e822@gmail.com>
Date: Tue, 12 Sep 2023 11:06:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.4 000/737] 6.4.16-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230911134650.286315610@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/11/2023 6:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.16 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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

