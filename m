Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E161DF99C
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 22:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744149920; cv=none; b=lNSkNNXYk4ghgEKedd7m+bxQd7HIn4XWlaVfvTjOGdj0ipjSlhgMGgoo8PGJblNDJKXDL+Bcs3kfrW2Y20SsV+OaKqqor73vavCXnri4Pq8OjtH9ZKFrqIuY9VX71SVOi73/EO5diLgfQPG14BSuzJKH2tMMAqzJWxCc4pggy4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744149920; c=relaxed/simple;
	bh=PhBczZJ8hsG0pnUBRsJWHROfM68lA7GD5Xh33hyqQ6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tqcC1ffoVy7Cyeu+nBWjvEMlGXpuWGv45VvKLKibDuYMRp/XJA2tKTSNk9uYDYNdIUlVwLzurR3IpKD4bWXAyWh0768UepNG4s9JEWGByEhLMWbKZeWll2pDUPrjD03TpvymSPS8sRquzMa44pNflSxBMlUTFEF39/VMpQpeygk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UTT7hUcB; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UTT7hUcB"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-601b1132110so3274405eaf.3
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 15:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744149918; x=1744754718; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UUwi7AgniJGPUbtu8jHbN3YuZzZjaK7SIDC37luIQ8A=;
        b=UTT7hUcBrIHSm830jLcQ4yj8RO7DXuPNFforFaZzxZ4ecSNK8XNUQHahkXJMNnv4Da
         R3tKcCTkZGY/YxeG6k5X7Zrg76nIYcAKgHXQwqyaJZV/xPLGTGMEsByG8xJwZp92r5mm
         bZrpW27WvGUluYMaO0GAZBIN7K7iJVQ4aQvSvz09moE0TqAUHm3/pyHyGVYSi9pY1Cd/
         f4LB2DfLC/06a44y+5GKpOmaQ+4JggttgugT88V/WEnD7D3GYield3UbYy8xjrnz1VYH
         hMv9TXuDNxSxKW0y6an51YyQJA5hX1g1hXjEWP4G8CQeOGJjOgUa/G5upTiYFTA3xf/K
         OqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744149918; x=1744754718;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUwi7AgniJGPUbtu8jHbN3YuZzZjaK7SIDC37luIQ8A=;
        b=c8ZHF1dva2cM9QmxoFolM/SkpnzwT5iezFZN1xvPDhhOTQZwae/lCzzN2WYp+el3yH
         go0F6NqAWbKCF973sN/qhQr7jB8/5ADKIhBVCpIyQbJFXTrqMziZC2lnRB61jiGcfBP2
         kiBbTT8dgdJFY8QEzTc7mCfH1TOIrNDrlNwa+9X+Xj7NsfOs2fW80nUrTfu3OgfnJxgl
         Nfnjo1sIt9nLR/UOkkm2epcUZKQry2eEMwo+NqUF+qiVc5vdPsNw21C0UgJibXFnvMaT
         K+4B6kCQhHLaQOslNBQtGXFjYi9yp5lhF3g0bfyHuHWVESCXtj5CkSF98JSqpQ5/w+tY
         +y9w==
X-Gm-Message-State: AOJu0Yx1kANSZ0EdQ02mH64rzySmf5d51r/lu+FCzaJzHUzUvPuTo4Zi
	wA1jyVA1IFgm017uBf9MSO/8DpMIpTYULosCqbLxi0598EO7CDPL
X-Gm-Gg: ASbGncuMXrd2/sha8d72Od2I37So62379Ry3s90Jq8+syub+ILtFssJXs7isr5VolN7
	zCNxG9dlClkfnaNvoUpINsPerR6BqVPJCnod/Bz/fPcuNlm9hqdsWKuXRwNBprcQbhGK5THkIIF
	MSrU/49Gnlfl1hyC+hoasqJ71sl7B5giBmNzxMk/dfpgUMXljv20HYsUiIiFfzzOQKlsznrYnYu
	DLvDsVatA8Db2uSicMmXrmDAennbW6y3tFiHCwziEoMdilLgi53GbewGieqZS3Q3R612Q1GBoxK
	I+CMhnrRFZOS6pEeXCYc4kf1ZnenhLtZ/peeSaMIBW4NA+hDtxw7yr8Pt1yS8F++FsBml0th
X-Google-Smtp-Source: AGHT+IH5Q5WDCvGV51bJXtpInSnx2BroalxSxCQ7vk6Dfhz5SkD8g0if4xsv/JZ19NpXNfWWBDndnA==
X-Received: by 2002:a05:6870:cd94:b0:29e:27b6:bea5 with SMTP id 586e51a60fabf-2d091b02393mr110384fac.25.1744149918016;
        Tue, 08 Apr 2025 15:05:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2d093403f98sm2465fac.32.2025.04.08.15.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 15:05:17 -0700 (PDT)
Message-ID: <9b85acce-5f37-433a-a5b9-c39125eed8cd@gmail.com>
Date: Tue, 8 Apr 2025 15:05:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/204] 6.1.134-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408104820.266892317@linuxfoundation.org>
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
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 03:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.134 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.134-rc1.gz
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
