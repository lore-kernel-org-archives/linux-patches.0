Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE66212292
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 20:06:24 +0000 (UTC)
Received: by mail-qt1-f171.google.com with SMTP id a27so868357qtw.10
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 13:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cpn6PgpH/B8a8nYankJVLNowGT2ZkREma3yqGiooSAQ=;
        b=B+O1SK60peeYYFs3b2JAF4gyW90Zfo5Bg3AXn1pyODIHPCCXWOzNTLkyAQ4jz1MCYq
         rTSG6EHhx4y1XzzlAShRZEwhJ5mTsL00KLxVg5Rk2VzfuMJggiQCfUaaujrDWEzL64zh
         dNShAzxPPvtTihG75J9Usc/6YZwQS3aNDBEVZ7NyxcJYzibp/46sa2GI1/vxpNQjnbDv
         JSChDTyzDGny6JZqvCdbtPPrfFBX6XsPd/87FtGptAqkGiXeYnp+ZkhUMImBbQOKMlYm
         3ci35Mf7+oNZpr2kVvKT290jHS50epcODfPeAZqNGKqX/OGG4s+f703UpdyGJINfXL2E
         vWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cpn6PgpH/B8a8nYankJVLNowGT2ZkREma3yqGiooSAQ=;
        b=pPkzZ6LDqadUF/4dDVK0Ech+zJekJfXo+hmxKm82Y1ezlZwd4KJlS1cfnUQmSrEmQZ
         WWet+trr1iuYkqjKNac3u7ncJwM70HY01m8MKT+KJsStHhq5+VDLnUy3QsZREj5yelfG
         nzXDu/FsZmWxGy7UvVeig/KoSR2jGFAlhKxu7Ll4PbHL1EI3IYR/Ep9oZzzs8gHbTLCs
         b3zjhGdQ/5OWV3pySVigaByI66GgCqJSxwKfcmghDH0LWLj5yHFC8+38CDR8Ol+YxMHP
         BkvuB95VRGrM4a0NXwq2uV/R2eBqXwBX7OXphFyeBTsbsiuVhIi9ts+jhqYXQtjQserd
         7EbA==
X-Gm-Message-State: ACrzQf0UVEUj2HCTkLIjIAfvG2y26jf1+OI9ZWPy2pwvR5AOV7+TX7Ms
	eZ/MdcvRQITe2VTW0C5+RkiJdFeEeGsojA==
X-Google-Smtp-Source: AMsMyM4VGe5aWNBH5jRVYBWfOHWmm9O2JhL/QG1gyqpMfaD2w7AXAK43Lfd7LPByXKV4w6snM+xxgA==
X-Received: by 2002:a05:622a:355:b0:39c:cb1c:e66a with SMTP id r21-20020a05622a035500b0039ccb1ce66amr1134903qtw.22.1666987583628;
        Fri, 28 Oct 2022 13:06:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k26-20020ac8605a000000b0039a55f78792sm2806569qtm.89.2022.10.28.13.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 13:06:22 -0700 (PDT)
Message-ID: <3dd0af6d-af86-ab65-36a9-d5b068977641@gmail.com>
Date: Fri, 28 Oct 2022 13:06:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.4 00/53] 5.4.221-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221027165049.817124510@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/22 09:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.221 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.221-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

