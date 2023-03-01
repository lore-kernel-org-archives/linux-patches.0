Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76755A4C
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 22:16:03 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id m20-20020a17090ab79400b00239d8e182efso784238pjr.5
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 14:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677708963;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+VO58BJFY6nm+jljRMOtrXaix324GdbTWzVJl2d1Ygo=;
        b=SK0zHrsztUZZbSIQbKAlthpoNzatdboI23fAfedLQfI4p3p5MbMv+aabfAg7pIJLtR
         edLWU+NFy3x7J0MGreVaB1I1QslKUDd8KQMF7/ERa8XcorlyEJXkRlMAi3PehMoi6x67
         PrfmY1kEsbpggxt2eLWbxFCswrYvqUaH26nv7eRb4NboW/InL3ODfAy511MUdrM6IRcJ
         2ZV4bkabwc5DfW2pNCSCIL5nDBgZyHy1Uv0oLBv70i+Wunrma9ORl1eB8ERwl9g0R9EP
         ZFtHZIzMzDsxrlAOIHnqEdp2/NHvxVR5td0o3Bc06hNbFgCVTU4nbeaSnHRnikQWy4TC
         Oshg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677708963;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+VO58BJFY6nm+jljRMOtrXaix324GdbTWzVJl2d1Ygo=;
        b=x9R4JB0PiI8D13qdefm+zx0NdnOarpV9ETExVJJg0GG6eUACNvcwKEjmVenOOYslXY
         YcRRQ6qh2rcrUIiulFrTQiFTeHUa87AzTZjBTCxrJn7rLskHFWLiORQKQBMT/kHDLpoH
         vkAP38b8jo8pkvbYLhFxMdiHeeWma/PKMFIXarr2peTbxm+3bdQCn1D4MDjz9xR4SWkh
         wfvH/qU063vts19kFg+AqlG6KNNrKfmznjyIl2dEPpJicFySjTbmDt3xWXGkJ54WCThs
         sd2jvgB4LxIrLF7lJUQ4E8483SfvXvSAzbfLsMU+PXvkZRRnCkV3swIDyz4sTvln6P6a
         cPWQ==
X-Gm-Message-State: AO0yUKXcSKs+ytFfQc/cvoD9Va8EGWCh+hrI9LhTgPhXVhEYGpe+lSKT
	GmfURmIN0M4BYvUxZMeeP5A=
X-Google-Smtp-Source: AK7set8i9ZNxm8L9u2i8JxWX9ntNvTWJs0PlAnbX7Nq/QOJgGIiVo/wcHYUPmRlcsuxgNbmNBxThuw==
X-Received: by 2002:a17:902:f54c:b0:19a:8304:21eb with SMTP id h12-20020a170902f54c00b0019a830421ebmr20056plf.6.1677708962636;
        Wed, 01 Mar 2023 14:16:02 -0800 (PST)
Received: from [10.69.40.170] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w16-20020a639350000000b004f2c088328bsm7898818pgm.43.2023.03.01.14.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 14:16:01 -0800 (PST)
Message-ID: <7b4b962d-c001-b78e-439f-86d98bf1813d@gmail.com>
Date: Wed, 1 Mar 2023 14:16:00 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230301180657.003689969@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/1/2023 10:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
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

