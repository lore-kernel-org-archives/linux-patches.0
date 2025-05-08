Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAF728A720
	for <patches@lists.linux.dev>; Thu,  8 May 2025 19:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746734372; cv=none; b=pOHuNFNPLQ66EPoISx9Mia94fTcf3GYj4A7Hv9xTjkw1NFcX5f7PnBQLCBEI60XgJMw/xKmK/0BXaUVZBX4CN4xdNvyY9+5y/iv8xn/aEXtAF5jOtpJ57442QmmQzmDpgNHag0+KjwpsakMcS5OjBEthBijTDtdxYcOHmJ4/0B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746734372; c=relaxed/simple;
	bh=D0eTZcDHThj7wFmuGHzLws3kPES381HlOCH3BoO5xv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=itNiVnKwapISUp8+GYu7ZCwcPTdp+9oxIwCGbWiC5gxzUlR2wGNBc5BQZ7TiGT7U4y6BkcedXg3VCKlLCME6hjRB+uys1exaQGEJRAGk10ZRoQ9ncq2RAoHejgsZO5RVJP0tPhWwzmOoCheu7kgKqUiHmCKmnsrSDhbi+oFvnBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FUVEvpvO; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FUVEvpvO"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-30a894cc07cso1451013a91.2
        for <patches@lists.linux.dev>; Thu, 08 May 2025 12:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746734370; x=1747339170; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=XZ1A/jnQKBKmbW0+4UxhQaDHonKrklw/WpsEqGyizjs=;
        b=FUVEvpvODD50RfNaf+nvSTcv0Bd58Cj5IiZCDh+sSYLEDmyhPk5CRNedLrfPDaONZq
         cuPe2ZCuLFLLjeYvJB1wpfqFBWkS9bZeZy4DR05ZPphyVb14zMwfqYPPoUSXxxVf/yS5
         GwSPOGEEgso2mC8exM/zSJOo7m/CeuMaOTNlaMGDYDQHsqKNv87uHczTioBKGmwXDhBT
         XhvNUf+LuKp39eZ1WVU5D4lVgm093IuxvARx905zVx86Y6SnQwvW2xVCEdKSFo456c6t
         R1MJelnSQGVALPKbLkB9wY8uqG1F0Um2CMIgRYkjp8NITsHCd1jh6fBuL4wgtsna+xhx
         FJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746734370; x=1747339170;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZ1A/jnQKBKmbW0+4UxhQaDHonKrklw/WpsEqGyizjs=;
        b=oT8kIaNPVGjFkEMeI3kd65HbosBx2aDm7Hzw/iKCFsRr0nxgm2xIT20jSjUgQayeuN
         U+pd9/vlHSeFxQX66nwoaL1YDFHvf0wGVcXRwPJID7Qf6ptga+rmbfXjjPmtJDDWoj9H
         EXXK5K4cxmthVcBzc57I+uI/VJGU87AHvze2wnZdrT9XvPxvcE4tR8U+XHpo4/jEqzP3
         Za5VVDqT3FhyI+UPRA4t5Ws7hZp4HdP/X0vQHaXhc3szqre6WX8L3qvI79ehbheBIspW
         jeFZft5d9Mr9BHM5KP8iNSJtgKS+5NnMxzYdVq1gromFqxtLxBiUultFEF2ln1AKjiqP
         FyMg==
X-Gm-Message-State: AOJu0Yw36aa61cRj6u0kBTarB6pVVzBmI3UTjXJmRj7EEH/XyCh+5bUz
	kkWKCCrAoKNUNq0Ucl+OZVprN48vcdOr/iY6GgISNn4EfrYjWIGa
X-Gm-Gg: ASbGncu/n0L/Ma5ar3faLNbKEA3/SL8kqFl1jUXWCEYLlKp6gyOM+KiWZD0anM/IDdb
	YgtjytdY21nNb7rt0KEU+d6LTYxIlQAK9WgkFjntu+sSoAPMtw72VoYOW5F2vZfO2o04TqaRrav
	MrS+UzOWaKCO+BCdsAW61HbLln92EMSuVbhnX9MH0i/XZN9jdkGyTd5mB0c+s9PkSqYEtnJy4DA
	5Z6CUnysjyrivAbvexet8S8fWHQKnK+jl5xCOBKU1cwAP2z5112S7cXJRxmbDU1Ax3JzjgE1GMQ
	Rd2LBFHqpBvmgArMliAQ3BgV8NSmoS/7AxFM7b7PTSzPCypymYQHHGDpvKz58TuDYZM+1uqyqTB
	Rrxhl7Jo57LCBJc4=
X-Google-Smtp-Source: AGHT+IFVUh9N3HJOvnWcBK/H0I50OtcuVSPhl3G26tmbv8P7V/BrHlWrxEtmYbS8nKEssB5lL23tpw==
X-Received: by 2002:a17:90b:1dc1:b0:2fe:9581:fbea with SMTP id 98e67ed59e1d1-30c3d6580famr1139524a91.29.1746734369785;
        Thu, 08 May 2025 12:59:29 -0700 (PDT)
Received: from [192.168.1.177] (46.37.67.37.rev.sfr.net. [37.67.37.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30ad4d2f3f3sm2635327a91.12.2025.05.08.12.59.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 12:59:29 -0700 (PDT)
Message-ID: <34c70ab9-bbc3-4e1e-8840-8ce8eec1d68a@gmail.com>
Date: Thu, 8 May 2025 21:59:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250508112609.711621924@linuxfoundation.org>
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
In-Reply-To: <20250508112609.711621924@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/8/2025 1:30 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.138 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 10 May 2025 11:25:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.138-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

