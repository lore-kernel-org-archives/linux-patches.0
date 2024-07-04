Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FA71AEFF6
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 14:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720105124; cv=none; b=pk4/erWKKicrKS2qvliK+GDAmqfFaW80feb19x46OvSmdHJm+/ZUxtNt4G8DVUm56XaD8T1JT600GhjFeLQyjSZigCCJ89dDcZW6tIkemA6xZL2cs6MI3CJ3GUYbs1Jm+ji00SYwdn+zjg7Ac41+OYGSDwTTOcCTvuFf+PS2JMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720105124; c=relaxed/simple;
	bh=UQioMozFHDM1+kS/PtFBz97UMMIoujK4ddPbYIen7mw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JqtYY+i+fgUOu6n9vwNyoN115DBpO/Jx1hw/Sq312WZ/LgHKvozWrg3kQzgABiVRNLZxrFHOveEOB1J4uC9Y7ChjaC8NKyFHA+IdWnMtfKrwpOGZFNZEn2Eo3/co6IPxi5fbd+QNZ4PgXRbYNhMQeUkqFfDXtUI/p2fKKpjMDdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DvIcSDMx; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DvIcSDMx"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-445e1f933e0so3301561cf.0
        for <patches@lists.linux.dev>; Thu, 04 Jul 2024 07:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720105122; x=1720709922; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QxRuBmbbA+ACQrxPn2Xt6LHP+upfJxuKfzAJQRiego4=;
        b=DvIcSDMxaU8Un8jyZxaVt4x/H8yBrhKLnDD5j9DLD3XEJe6273xgJtgtgRi6gczjqi
         I2se7XY+vhzpp1xkY4di14Xz1uBkbiC8fpPiAVDwfZXotx4YCVWqve1LrD7v9JbL2tb0
         u8CQSl0l3U5zAt4902MOLu3utObP5l6EzfSYk/ggQZv9ukv4UqfSofyhqrawFOsDn2ie
         sZuqn/Uk9G95dFxw1SruLB7Nf5gBhzX3lRvNIf6u3SjnWYr6BsQK/zcAHug9vUHbVF9L
         +ajujQYvW2YRkAsGlcZyRagKAkF/FYCNRE06ADErVvtBki/HwB4aW6nm2YkwP0xT9/u7
         V+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720105122; x=1720709922;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QxRuBmbbA+ACQrxPn2Xt6LHP+upfJxuKfzAJQRiego4=;
        b=sL8hk2G9Yy3pJqTRBPrklXinsLPCGJbPKtjXEL1vj6+jTvEessxW9Tl06JXmjHw9dd
         vhZgaP8LZ2TJNGUwR6rufJ7sk/IEn6mObiWvlg+/g2lz7/ruY34zXZNvxY/L8YuU5vUz
         grhcCyFlSHBLDBkxmq2YVQYkZ04cu42ynaTHRFMGF+/DaD6V+RBNfNybwu+odS6Vk2T7
         zWck8pvwUsTjK1CSGAe+G2HipddNmFxQwvDPJ88Z+qSKtST3BTwrDpCGvAVvzoJ8X7aE
         VK5gieqpeFm+d/W0vxFf4DWcJSSJ/FdC7Vw2YJA7ywV5Md2D6v9L7m6ej+r8nS3mT+14
         38BQ==
X-Gm-Message-State: AOJu0YwRBrVrXx0GhuAktcMYtl1ES8i8mp23D0h3xBkYzDL9sdCtLV+p
	LJ/ziMhdyg5+UF8b8YyKBfnzBAYh+eUja8kB37jyYW2hjvw5SVNf
X-Google-Smtp-Source: AGHT+IFAYRiMHBj/lkpze+LjaEBMFFdXps4/uk2fNKe+05RGS+K4mxCNRNrcRDcFCQEZtg/DG+CuTQ==
X-Received: by 2002:a05:6214:53c8:b0:6b5:4e70:5a19 with SMTP id 6a1803df08f44-6b5ed19c3c9mr22754116d6.50.1720105121895;
        Thu, 04 Jul 2024 07:58:41 -0700 (PDT)
Received: from [10.40.5.113] ([89.207.175.15])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e5869bfsm64867196d6.74.2024.07.04.07.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jul 2024 07:58:40 -0700 (PDT)
Message-ID: <271a1cb3-7234-4d24-b714-e362c1acbc8d@gmail.com>
Date: Thu, 4 Jul 2024 16:58:19 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/128] 6.1.97-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240702170226.231899085@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 xsDiBEjPuBIRBACW9MxSJU9fvEOCTnRNqG/13rAGsj+vJqontvoDSNxRgmafP8d3nesnqPyR
 xGlkaOSDuu09rxuW+69Y2f1TzjFuGpBk4ysWOR85O2Nx8AJ6fYGCoeTbovrNlGT1M9obSFGQ
 X3IzRnWoqlfudjTO5TKoqkbOgpYqIo5n1QbEjCCwCwCg3DOH/4ug2AUUlcIT9/l3pGvoRJ0E
 AICDzi3l7pmC5IWn2n1mvP5247urtHFs/uusE827DDj3K8Upn2vYiOFMBhGsxAk6YKV6IP0d
 ZdWX6fqkJJlu9cSDvWtO1hXeHIfQIE/xcqvlRH783KrihLcsmnBqOiS6rJDO2x1eAgC8meAX
 SAgsrBhcgGl2Rl5gh/jkeA5ykwbxA/9u1eEuL70Qzt5APJmqVXR+kWvrqdBVPoUNy/tQ8mYc
 nzJJ63ng3tHhnwHXZOu8hL4nqwlYHRa9eeglXYhBqja4ZvIvCEqSmEukfivk+DlIgVoOAJbh
 qIWgvr3SIEuR6ayY3f5j0f2ejUMYlYYnKdiHXFlF9uXm1ELrb0YX4GMHz80nRmxvcmlhbiBG
 YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+wmYEExECACYCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgAUCVF/S8QUJHlwd3wAKCRBhV5kVtWN2DvCVAJ4u4/bPF4P3jxb4qEY8I2gS
 6hG0gACffNWlqJ2T4wSSn+3o7CCZNd7SLSDOw00ESM+4EhAQAL/o09boR9D3Vk1Tt7+gpYr3
 WQ6hgYVON905q2ndEoA2J0dQxJNRw3snabHDDzQBAcqOvdi7YidfBVdKi0wxHhSuRBfuOppu
 pdXkb7zxuPQuSveCLqqZWRQ+Cc2QgF7SBqgznbe6Ngout5qXY5Dcagk9LqFNGhJQzUGHAsIs
 hap1f0B1PoUyUNeEInV98D8Xd/edM3mhO9nRpUXRK9Bvt4iEZUXGuVtZLT52nK6Wv2EZ1TiT
 OiqZlf1P+vxYLBx9eKmabPdm3yjalhY8yr1S1vL0gSA/C6W1o/TowdieF1rWN/MYHlkpyj9c
 Rpc281gAO0AP3V1G00YzBEdYyi0gaJbCEQnq8Vz1vDXFxHzyhgGz7umBsVKmYwZgA8DrrB0M
 oaP35wuGR3RJcaG30AnJpEDkBYHznI2apxdcuTPOHZyEilIRrBGzDwGtAhldzlBoBwE3Z3MY
 31TOpACu1ZpNOMysZ6xiE35pWkwc0KYm4hJA5GFfmWSN6DniimW3pmdDIiw4Ifcx8b3mFrRO
 BbDIW13E51j9RjbO/nAaK9ndZ5LRO1B/8Fwat7bLzmsCiEXOJY7NNpIEpkoNoEUfCcZwmLrU
 +eOTPzaF6drw6ayewEi5yzPg3TAT6FV3oBsNg3xlwU0gPK3v6gYPX5w9+ovPZ1/qqNfOrbsE
 FRuiSVsZQ5s3AAMFD/9XjlnnVDh9GX/r/6hjmr4U9tEsM+VQXaVXqZuHKaSmojOLUCP/YVQo
 7IiYaNssCS4FCPe4yrL4FJJfJAsbeyDykMN7wAnBcOkbZ9BPJPNCbqU6dowLOiy8AuTYQ48m
 vIyQ4Ijnb6GTrtxIUDQeOBNuQC/gyyx3nbL/lVlHbxr4tb6YkhkO6shjXhQh7nQb33FjGO4P
 WU11Nr9i/qoV8QCo12MQEo244RRA6VMud06y/E449rWZFSTwGqb0FS0seTcYNvxt8PB2izX+
 HZA8SL54j479ubxhfuoTu5nXdtFYFj5Lj5x34LKPx7MpgAmj0H7SDhpFWF2FzcC1bjiW9mjW
 HaKaX23Awt97AqQZXegbfkJwX2Y53ufq8Np3e1542lh3/mpiGSilCsaTahEGrHK+lIusl6mz
 Joil+u3k01ofvJMK0ZdzGUZ/aPMZ16LofjFA+MNxWrZFrkYmiGdv+LG45zSlZyIvzSiG2lKy
 kuVag+IijCIom78P9jRtB1q1Q5lwZp2TLAJlz92DmFwBg1hyFzwDADjZ2nrDxKUiybXIgZp9
 aU2d++ptEGCVJOfEW4qpWCCLPbOT7XBr+g/4H3qWbs3j/cDDq7LuVYIe+wchy/iXEJaQVeTC
 y5arMQorqTFWlEOgRA8OP47L9knl9i4xuR0euV6DChDrguup2aJVU8JPBBgRAgAPAhsMBQJU
 X9LxBQkeXB3fAAoJEGFXmRW1Y3YOj4UAn3nrFLPZekMeqX5aD/aq/dsbXSfyAKC45Go0YyxV
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/2/2024 6:03 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.97 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.97-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
