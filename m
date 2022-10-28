Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA5D122B4
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 22:01:30 +0000 (UTC)
Received: by mail-qt1-f181.google.com with SMTP id e15so442500qts.1
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 15:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DJMZPHVTJnFr33kcUUeOBhHNHfNHRBfcq5bdTAYqszQ=;
        b=dSwF0cYukDaPvmbFrNBBPzHX8vR8DHxft5aDidoyQOCak61NDEn9WmEoeISvCDdbMJ
         A+zZzHBAko7IW+yqo97Wjlr5KDigVv9+OwX/q6QgsyCJwJRyG71Xux4MXpIfACYYDiGr
         OkFgYAeGOvg3EqxfE1CpDKCIKKGFv0ToX1Ccy0DTzPGp1qtL6zvjOM1hb2GqepLzxBmL
         D6k5jFHIOXhARxvSqwtSgpZb4Y4O5awIF18oVgAbmkF0hhlvcCVC5FonoChhYX2tJlLK
         VVpWI36knkRzxZhmUOXL25cKGqb+eCm/Xc1voUh8aOINa4LPGTRa6hWzzaAUc30+wN41
         xK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DJMZPHVTJnFr33kcUUeOBhHNHfNHRBfcq5bdTAYqszQ=;
        b=bLQBSqT/mMkVxte0s02kmrMiQr6sIUysNgJ5DjQABDmFLYbhGSo7yihGyo1UPJYg3O
         mwd19+P8GJ6X+3ENLp3dRi51CPvEWfSZfwUrJ84vZ/HkxGspxyiSWe4pDls5d0V2R12b
         EJbyN2YBEZvns5DoTOFkJ8d7QHJGlIGrZ11g4M7SI5NS8WplUx9JTrdmlp9+5tcAcJB6
         RBQbYW3vfC3y2ycW43kFx/yZtoJD2vn1a6jKo3cshK/WzZu0w6dJ779M7sJ2Ft8b51Sq
         Z7vy5inNvLkKiE0kPWrdmMxNIsrPaZPqPIb4SeDO3fxDRdCsIetLPTYkKZXRjVttdQ1t
         0wRg==
X-Gm-Message-State: ACrzQf0h/bI2C9NzRted1MkyUQLUJt1xr0F0xK5G2QKjPa4k9DCfX8uP
	uGGocE0LfIcFU8f7alIeKuA=
X-Google-Smtp-Source: AMsMyM5z7TnalClyLz/r/L2LC0f5nKSGHK9GEBBHZiIv+u4dnDnbwWnT4BJDbU8JnTxhyMxfHy5wag==
X-Received: by 2002:a05:622a:1710:b0:39a:cc1d:1daf with SMTP id h16-20020a05622a171000b0039acc1d1dafmr1517035qtk.394.1666994489025;
        Fri, 28 Oct 2022 15:01:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t11-20020a37ea0b000000b006cfaee39ccesm3676635qkj.114.2022.10.28.15.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 15:01:28 -0700 (PDT)
Message-ID: <b048a478-32a7-6d3f-a104-c7123c93826e@gmail.com>
Date: Fri, 28 Oct 2022 15:01:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221027165057.208202132@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/22 09:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.6-rc1.gz
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

