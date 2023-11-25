Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3002D03B
	for <patches@lists.linux.dev>; Sat, 25 Nov 2023 19:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nI2eSCsk"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-1fa22326ad0so321575fac.1
        for <patches@lists.linux.dev>; Sat, 25 Nov 2023 11:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700939046; x=1701543846; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dVLgTfi8XS7NzCAGMfCjECNo5pKytb4Hcwd/ayxLWKo=;
        b=nI2eSCskDMVsfq+PNqu1TqlexL6WuPM5bImUkWzYSte4/HqF68+oVppygzo2xFFTTB
         SqNfx+VkNhC0ZlEnwPjBwtl8W8SZ38p/NU9xbhH7Y+XS6PlFwx/VlL3m8ttemTQ2oaHc
         ZcW7wJcSK1q4DEFgltOBKdWLhqohhZGv0E9962BT2Nr42sn6OIi2CewnIiFV92yYSJ0t
         eEmCHWAGrWbf5odnTAf4uFs7Jml2SuLsbm6RgJJgxv6aSDkmRcR4jRvg0paMFoWm7Fti
         t19byMAVNmYgTD5S09xx8BHCqymMBg4Jld6oE+c6i/yATYfnFtvTSVsolx0x425SzcW0
         XPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700939046; x=1701543846;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dVLgTfi8XS7NzCAGMfCjECNo5pKytb4Hcwd/ayxLWKo=;
        b=xUgWyZMPMFQkA5yQq02LJYAaJ2G3SilBG8WtbOm1z4eDrRpgODgOz0ZN55P4JVPPFw
         aU9CwoMGrs9H1+mVGs8LIGTBuy23+BO/j/oKhzxpeWYl/WTsGsksy7/kUZV/LIE4Ldbx
         B7FLUWyjvshRNVvtKrMn4u9eywb346zY2uTSW6ZjEexrlbh0mTz/432oR5V2ncK3U7+0
         y6L455VnQQeE40Vsng+5fCAFx7kbJW0L+p9MXx/xocI0q+ED+dHqzSIm1EnOyDZpd7lY
         ESKYsuegEWSELnrZG0VL70Py0GwrLpVLAoL0R6HjovXlhETRKWkHlV4IIdKqUHuYfBYi
         SR3w==
X-Gm-Message-State: AOJu0YxCShbuaMeTXSo6XEDiMzR3oH7Wz4kwTaIAZeyK4MHBtRPUmCCN
	6dgkPVJNj+REBI9UWbzAgAlOtA==
X-Google-Smtp-Source: AGHT+IHgZdgP1on4N3LC80KMS2IdPjMpvNSJF4hrYp4qKVG6WSLUKFgvqub9oOpsaT5uF79VJ4IXnQ==
X-Received: by 2002:a05:6870:209:b0:1ea:e36:70d9 with SMTP id j9-20020a056870020900b001ea0e3670d9mr7900604oad.20.1700939046155;
        Sat, 25 Nov 2023 11:04:06 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.70])
        by smtp.gmail.com with ESMTPSA id le8-20020a0568700c0800b001f4b1f5ac0bsm1412893oab.31.2023.11.25.11.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Nov 2023 11:04:05 -0800 (PST)
Message-ID: <e819d653-8a1e-4088-a4dd-a093356da8e8@linaro.org>
Date: Sat, 25 Nov 2023 13:04:02 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/528] 6.6.3-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, hca@linux.ibm.com
References: <20231125163158.249616313@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231125163158.249616313@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 25/11/23 10:33 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 528 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Nov 2023 16:30:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We see this build regression with System/390:

-----8<-----
   /builds/linux/arch/s390/mm/page-states.c: In function 'mark_kernel_pgd':
   /builds/linux/arch/s390/mm/page-states.c:165:45: error: request for member 'val' in something not a structure or union
     165 |         max_addr = (S390_lowcore.kernel_asce.val & _ASCE_TYPE_MASK) >> 2;
         |                                             ^
   make[5]: *** [/builds/linux/scripts/Makefile.build:243: arch/s390/mm/page-states.o] Error 1
----->8-----

That's with Clang 17, Clang nightly, GCC 8 and GCC 13, with allnoconfig, defconfig, and tinyconfig.

Bisection points to:

   commit b676da1c17c9d0c5b05c7b6ecb9ecf2d8b5e00de
   Author: Heiko Carstens <hca@linux.ibm.com>
   Date:   Tue Oct 17 21:07:03 2023 +0200

       s390/cmma: fix initial kernel address space page table walk
       
       commit 16ba44826a04834d3eeeda4b731c2ea3481062b7 upstream.


Reverting makes the build pass.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

