Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60581925AF
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 19:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741720305; cv=none; b=Yd96kENv7bJctVr+vklGEl7StS0apxmYfvTNszFlkN73pUID+bWbMS3W9+7E8UbH38rFswvpl1XJ6vZM5N3mA9yROQj8ymByrKrnlz1a0ZVH99f2l6REuVGN+owKmALnatRxVUvRx0+lq+ln3+6ZOwMnttKK+61bHAasuAZ3wno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741720305; c=relaxed/simple;
	bh=9Cenk0RJF+NXyoIucvW1nCyLgk0A8k7LysRs0Ukvy3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dvRYcv0BbWFPShA3gGgdkA3m9MH09VXB49u9GxPhk++5dhKUYYaD0j35X4fkT1I8nEQlmu4oMwUkzWaKW1nC8n1/Um+YL5LAz3wsJPHbCGRb3zORi+O55fktX+a21/OfAUMN3JNuw80cF0R7S5/2TQcznDEhz5nnnUSKnrGs+Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OGEaZzvZ; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGEaZzvZ"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7275bc6638bso1173072a34.2
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 12:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741720303; x=1742325103; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dmF1yNUo+ggsbU/6nKz3KCl2C/94nft3iJGJcrNcTT4=;
        b=OGEaZzvZ0s6oJZl0RQoYGdzkLnLvohb0sEu1GiHwb3jg4Z8EIQv+gYuM0rHG7lIlYj
         pyjTClI0Bvq7WWSeI3FrMu79ynRjrBkEA0neCyeZMYb5ebhMt7+WoPT6KzJia+mKkbdk
         ATT/uHLEC0/WS2x+eQi+tfUHhrTN6XaKBJ8nClgvmveS78QFTyoyobv9YKrF4nC5UhAE
         E0drr21I3JRfoc9eYUaXv5GuA+jo+M7mRwJa8MVvVHmj2q4FvoAoQe9kPALD5OE3UyVT
         tLk23Jfl+i6l8t2bkA+F6xQ/8pIItSjNJsjkICK3pLmr+fveBKfB2TJoZk9BqD7ldwaa
         2oBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741720303; x=1742325103;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dmF1yNUo+ggsbU/6nKz3KCl2C/94nft3iJGJcrNcTT4=;
        b=UhpQTqPJyxtmxkcKrmhgRpiuruI4iG4plcS4BPypd3gNlEmFQbr+EaLMPDQ0jnmRtO
         jjWby5ilCyF1at3BG8D5TdeCbT8nUXjxwlIy+wFpD/52lXFPJf/ds4x+XMqJrA3/80AP
         QKy0t/mymBwt28sBHL1iEGq3lDTUdbl86IsRdei/C3bZUAno5wrOHx7Ox+DIZydC2lp2
         MTdNrCC1lIT1w7cqzIPhiYwA8Voi5VsTMC8CvBwur3HISw8qowA4U/MJSgmLAm/lD+Ua
         tuXeYPKnXCFNrqf18ER4SihQM5x+PNOAjp+qq0IUDGmrUd/qPL3P70029MXg5qmLSSPK
         gNzg==
X-Gm-Message-State: AOJu0YyWEMUpuGDtONsNq75wMFaJNO0IB3dH6rSwL8DCKrhw7VQgzWg6
	BFzDidQmHIVEKGWmqzRprkc64Dydob9KCyqvPBbFypNB9ups292rMnOCtQ==
X-Gm-Gg: ASbGnctK6OnJrJN1u9upUcPuxonp6cumHfyBtdE3z1n4ipOZufQdkyfJS/CR7VNBadh
	Hdq3x5U5TPSp323ossulgQ5K5UHfVtj2xAj773l6Z7h5+e6keS/AbaIHx55MQDx592SeCc+vsAw
	Q61Kl57I8BCJY5kL9hppyZ8+YpzkGExIkR/fn2Wx9bBOXrFFs+Gi1BJLgOXC7ZFsu+bvZjC97PN
	9eoEkJYH0Ub3ZpquW3khIw+w8Q1fkPLJ3T4tCaPPnSD4+XB3SwpEGqYj0pUcwq5FRtzWwUXpDsr
	A4N8dTuceKAXiEOVeMii4kXhd2nOyJEdLxsOESzlDCXzZMARNJNVwd/R4ek7sFjXzeWiKBpJB8N
	04hErldU=
X-Google-Smtp-Source: AGHT+IGO8BCRXctWglwCc571t0NVoaIZgvaZaD7VL0BHwXnJh3s8NSQE2hXByipqSycd4grqrCS2Gg==
X-Received: by 2002:a05:6830:348f:b0:72b:9d2d:809 with SMTP id 46e09a7af769-72b9d2d0f64mr1847884a34.27.1741720302759;
        Tue, 11 Mar 2025 12:11:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72a2db9f92asm2517059a34.46.2025.03.11.12.11.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 12:11:41 -0700 (PDT)
Message-ID: <1532136a-19c4-4647-bf43-5ad3d22e89aa@gmail.com>
Date: Tue, 11 Mar 2025 12:11:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/144] 6.6.83-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250311135648.989667520@linuxfoundation.org>
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
 FgIDAQIeAQIXgAUCZ7gLLgUJMbXO7gAKCRBhV5kVtWN2DlsbAJ9zUK0VNvlLPOclJV3YM5HQ
 LkaemACgkF/tnkq2cL6CVpOk3NexhMLw2xzOw00ESM+4EhAQAL/o09boR9D3Vk1Tt7+gpYr3
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
 y5arMQorqTFWlEOgRA8OP47L9knl9i4xuR0euV6DChDrguup2aJVU8JPBBgRAgAPAhsMBQJn
 uAtCBQkxtc7uAAoJEGFXmRW1Y3YOJHUAoLuIJDcJtl7ZksBQa+n2T7T5zXoZAJ9EnFa2JZh7
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250311135648.989667520@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/11/25 07:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.83 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Mar 2025 13:56:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.83-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
