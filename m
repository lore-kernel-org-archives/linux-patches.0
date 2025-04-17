Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6651FE469
	for <patches@lists.linux.dev>; Thu, 17 Apr 2025 19:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744918535; cv=none; b=PudlX8xpz53j36L+PR99e7c0KS9aqQqxXI4MXa937CBhTkenE5WfoIWK4x4MZwzV3ecwRRJgd52bYveur+mI71WDjBsomTzliagPjPVX4pa2qyJIaCFlWK6djD6P8IQf9eOrJEEWtZ/dWwFdjwBVKa9JE9q167MgHdSdjtG16fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744918535; c=relaxed/simple;
	bh=BAOISx48rjJq7IQaBpn5ODFoXd6SCvxJcWCanWkz8OQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eymhSj+0LOUnozroxg5XnQ1BxZ2+Xpvap6bNi8HeKYff1pnBCLvoqrqJOUEMiw/1MJkpwUJdTChonw8Ugi6rKt72foQ0626OYVVJtQFvKJC1dAwFvqcMIXXfLAfhZjMED1gRZ5+DAK9GSf/Ktk/wosf5KI7OP2tHK1YeBfcLOIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2HydNbU; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2HydNbU"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3f8ae3ed8adso597290b6e.3
        for <patches@lists.linux.dev>; Thu, 17 Apr 2025 12:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744918533; x=1745523333; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=I71IbShK4x2IV5ReFc2t8KaWcQJo7NJsWnOHXb/D8s0=;
        b=R2HydNbUGs38v+uVfbMNwPl1PEUotRUaf7rl8Fmz8wO5xlzvm9Q6j8DwxyTazGgWp2
         QVcCFU9S3iW2mdjOYfjCpvegfMJcG2BCF8jnj1+kcToyRAvEhLjHlnIW9PuEewxejiY6
         MEJtD+TPhoIfeIHawLJfQq5tO57+l1OVTuiRo4HvranipAvDMpLAS99HWTysMOmSw6Xh
         LSiBJDMc4B7Ld53O3+Vq6S1IGn4SG0LLwrqLh2AFShzSp13vKfRPVtmPduDV519xNTaE
         59CXyCZmvo0WxcaPnw0nz0xMZ9NkIzM4ZMHwIpkvFxF98cX0qJ0tQt2geOOywiP0ZdyF
         cS+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744918533; x=1745523333;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I71IbShK4x2IV5ReFc2t8KaWcQJo7NJsWnOHXb/D8s0=;
        b=s04mwZmQHQmCdvr2a6z/6mE0oSavPlpOAjvkijdWV/+6EwLHvch/YohVBMfwdlAtUJ
         UYH5IrWTaMMEFq7cnIDNYPGpIaPnbOS78oePTtegipnB0BTayNH8YKD/ZrJnXREKH+OH
         fYg1MB/NIMmRBOC5EcLSNGu0yB91YtFoLw5U3YsoIqTkaAWBJx/YvRvaooKTd5vbyhLX
         /NbS4Yg80aFFTn1DuzGKXc9Ey8PiO6GBm7zg5HhbjzoBjZsc6IhSs6jvhKdDAqfmaGlH
         EzoSeoYXhxu3IJUemCMSp5ujlm2iolOP3yOoX6spLQakxSVEettLfiGptTOucMROQkF3
         svaA==
X-Gm-Message-State: AOJu0YywYpADVRNLpjUIJ786WWhTnCklL63lo8qDLgyHC8HkkeFXLSln
	n4W6MGw/bhglCib76rTWe30GEV0xNgbHfXw6HrMU1lsLHff2PuLs
X-Gm-Gg: ASbGnculHnfnMdrHsRZ4YMent6Jg/DnXg8ai3/7zIjrRpEHR2rD09WhNlxtXaKKL2kZ
	xOvPzDLAikJy/Jg5m+zeJYtvjp8DT3jdd6I0EdGmJ9RP/PmwWRDHh3Qhc13tiQ0jIWdGO6JonfT
	CtxzAyUviSqXIxTsE30/kyrRLUX2Y2gK34Om+yF/Rb+ZtldRzSpdwf7fzLSis/eBpjd/t3rCYl+
	qKlteOi4hzBVDTlQvm996Unch35McbHogh7kobbBrV2wKutwr0Vv4fabsOgy5anVpHtWAYOqHVE
	bnoPMA5VwnVkHYA0WaSg+N7MZa7RIahIVFQ6AwLrVFIk9UL9pI/KH1zXkGog6AzBAFj8
X-Google-Smtp-Source: AGHT+IGszmx4+xzRGy+CXOF0hE8k3wbfVdz1bLM2ZZI6ogviD4Pp15opJ/D+TIpGtXIwcH2TjUmj9w==
X-Received: by 2002:a05:6808:4e01:b0:400:fa6a:6726 with SMTP id 5614622812f47-401c0605f81mr31765b6e.0.1744918533509;
        Thu, 17 Apr 2025 12:35:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-401beee90fdsm52304b6e.21.2025.04.17.12.35.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 12:35:32 -0700 (PDT)
Message-ID: <19b13524-c654-4216-8421-34dd825621e7@gmail.com>
Date: Thu, 17 Apr 2025 12:35:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/414] 6.13.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250417175111.386381660@linuxfoundation.org>
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
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/17/25 10:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.12 release.
> There are 414 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Apr 2025 17:49:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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
