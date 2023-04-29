Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6EA320C
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 17:14:33 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-51b5490c6f0so973827a12.0
        for <patches@lists.linux.dev>; Sat, 29 Apr 2023 10:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682788473; x=1685380473;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=has88WGRnfc3o0+f60isvuPYmLEVsUerTy3zu8Pzwho=;
        b=EWusZYCbFV2qABjpF9fGwR6nUhkKJwaXEMN45SJ3x8WPABPKVDKZBoWN8CnQTlpk0C
         PKgCq4n/YgPqmXpnuuBXPDUt06SIKuBiOUEhuuZ4QrOPtAXh/Mx2Y0Tm7vk/rYqzI7lz
         QrkFjxC8f8KbHw4I63rKuzQOUCtz4ngtvltpVpGA0VKnuXDmLrAStKDOeCVkWMNiOUiJ
         JsxdPqe9hWuhBnuTjhhOnDeh5k3IfYnsHdqzOyxTs1iCff8i2SdSSgF1SXg6pvAW04ei
         G3SK8nR2x095/7fsj6fu0ms+c4vZEjgocCIoaRTq6fycQYnMKBhSw5n7UlUQ0xMWSlSm
         /7Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682788473; x=1685380473;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=has88WGRnfc3o0+f60isvuPYmLEVsUerTy3zu8Pzwho=;
        b=RN/PXe8CcH5AUr2kUSXj7Njhg/pG8oNKmAkCNSzjX7EdXlr6njC3EDwdD8K2RAZ8qo
         ECy1yw/qehM2bBkJCT1WeBzVznaxZ5RqspnppELmXRxFVvqSRh9n8o7e2yE1+qD49e1Y
         xM7QEWrdkDFjgwoeEBLeuRRcO5+weEIpdm1EgZRXPHTscs2a5CHE6SUsG62piNZdvw/U
         DO4mjiwsQyBpvCQAWvlS6tjLFbYqPq3dCm+iFi7Pn10ZS73UqdX3cNkZOSZHniZKFZpb
         5SwcMf0gJeFwTEfxds+fgmjYBOt5O6aFDVN/W9R6kGndydf/oUcDkJ6ei9Ghte2YeynP
         cRkQ==
X-Gm-Message-State: AC+VfDy1WMdbGxmew/LnuvAx9l91tSq+d1WA8RtqUX9peUCmt4poOrfU
	kZrkiguWNEFBKcKIMMpT14o=
X-Google-Smtp-Source: ACHHUZ4cpovANW6NGSQ4jBVaGEP80A3EOktzp9rOq1Q0WFsIqaaVJ/+/ZPx1/s/n1pnJoJE+ctuopw==
X-Received: by 2002:a05:6a21:6d87:b0:ed:1d7a:3339 with SMTP id wl7-20020a056a216d8700b000ed1d7a3339mr76045pzb.57.1682788472940;
        Sat, 29 Apr 2023 10:14:32 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:1c98:2538:93cd:aefb? ([2600:8802:b00:4a48:1c98:2538:93cd:aefb])
        by smtp.gmail.com with ESMTPSA id i5-20020a6561a5000000b0050bd9c8c53dsm13293006pgv.23.2023.04.29.10.14.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Apr 2023 10:14:32 -0700 (PDT)
Message-ID: <ce72b375-7e33-de77-eb2c-47200bc1936c@gmail.com>
Date: Sat, 29 Apr 2023 10:14:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 6.1 00/16] 6.1.27-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230428112040.063291126@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230428112040.063291126@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/28/2023 4:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.27 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.27-rc1.gz
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
