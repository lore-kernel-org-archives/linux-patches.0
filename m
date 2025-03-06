Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06712270EA5
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741284277; cv=none; b=U9CkHtKFzOtE3C+hq7PQVjyWoRg1TYBiYAMg94faEg8VIbbmmcnfzD3WG7CEwVNu99BK7GCO8/XTnKxuRcxuTrhcrrVrFF7rfFtxVoKuS9pBrqgJvY7fMS7b9eH8VnkuH/S3xFKuW4QYTfS8qmJgmtpE+eLFeNvJnpL30joDMlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741284277; c=relaxed/simple;
	bh=ZBMP2bJ1Hb/boW6eVsTEN52GV5YqIAox9RyMWEK6NMY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=K+/uDS1qoqk6+3Tzi5M15fFGx2i/P6fL6bHtTALSszr6rj6+7UK+0iRtCqL/8Q+htzHB0uBIpnnj0z16hEm2+O9WAiYTOriz5VSFIu4Hjap7Hlu0YmbzkNMmecSQHMS1OFpuOaD87hkT8vMFTX6Ty4eUBu5XFphaPq3FfqLxLt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k2Eso8Ot; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k2Eso8Ot"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-60047980fffso97321eaf.2
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 10:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741284274; x=1741889074; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rCLTrWZbqg8TymbUHv4E5FIaJnj6NcfTeBAZhUCsnkk=;
        b=k2Eso8OtI4Oz3lApGkcbWT+YsW65YDdVqyFHcf5DHBOLzgegvqIyNWJuz4sGAum4w0
         OAxO+STfxJl8XRmPFqizVAHv6mYa+Utvl16sXFp5n35FOcCKrng72Qa5qvztF7puwOr6
         RR3CcNuzSbDgpFFtjh7+mNcKBTpPQ4BtZBKdZN2+1fk8COv7KO7OxUoow/tKNPpJ/f55
         6AovI6geWzYpI80laYF66xB0JcH75KJsIBtzCp8BTiXbY3LMje8P9MBbuOKLOLqwsXp0
         Fbo2UUGZb5dZBYJ4o1bDlSyH7VabOlYBS5js7/m1v1zg+p4sW09RiMEefQjF0ZPWqmDT
         b1Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741284274; x=1741889074;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rCLTrWZbqg8TymbUHv4E5FIaJnj6NcfTeBAZhUCsnkk=;
        b=CR1aSTI5jjM7V+UBdoE/4d7lZ4XW710rK7i/jtqZpqclIFxXX5qr/aOgVSqWVGJ/QZ
         /R/nFnYhWu3JhmCsNKblZh8Ky+M/m6lvNWLjKWIWOM2jAks2mRLxIRQlSVpgb3ZqvH2T
         p/sbq5FCQLwjEsvd8Bu0fIbDOLcESlfipJyDtTB8WGasJoxwy1Gv1GsuO1M3FNwyszi2
         FXDeCKmUkV7nwXS1nImIz9SRo6T2zppDgJWMQYyJk64HIuiyT8z1BE6itWyeLHQ2IDEy
         IJ2cAwo0OjELMJr6FxeQgHu+XlIuSTTupLF/qE31kl6XWFE7SbRSpEMPmI5cmTCvlPip
         fuGw==
X-Gm-Message-State: AOJu0YzWK1lAQqqiMAJSnhn9IEoQ0EElqSsY/1BGbMK1qEDZ/l3rfdHb
	ADaeoGZru5xNlEn9BLpC+tcR9BFlomgp0Qs71LKwoeb0NLC9axL8
X-Gm-Gg: ASbGnct1oqATBnSRUa2Dx0ffHfsishM9ZMCntg0kI0m79Xtn96UVzJ4ux1lngEF3psX
	Ms54Z0gQo92/f2ewxLHVyRn49oHxa2pvi2vIx662YccTmDWLTiw/kqJ/lrXPfpQSiDpJb/U+9z+
	XO2b/eeXNnXI+Nt/e856siRBDoLEcUb63bo9oXq2K8/D5HsSwv+1nwWq1jMXfdDdnjW1wHM/P7N
	splPoIr6vWY7aAcciyeoPOq6PTs4WZFajSgv6QBfmvK7ccn8zLYJwv6tWR0pB0ey5O8QHXipkaw
	jREn1/qcRd5HeH1X7RPnvlhkijv5YFCqf+wY0SLCXw6AI2RNePWA6g7ghyxkgw8JnDRTKtz+
X-Google-Smtp-Source: AGHT+IFn/4SRrNfmhgiQP91ION0n0sqnjvDsCkPEk07pVdOQK1vpodfR2dENFvXII7UHkxR3kqxoNQ==
X-Received: by 2002:a05:6870:c111:b0:2b7:d3f1:dc72 with SMTP id 586e51a60fabf-2c26133ddbfmr126648fac.29.1741284273900;
        Thu, 06 Mar 2025 10:04:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72a2dbc3457sm337298a34.60.2025.03.06.10.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 10:04:33 -0800 (PST)
Message-ID: <aa8ec6cf-e8ca-4f5e-9982-a432fabe2ebf@gmail.com>
Date: Thu, 6 Mar 2025 10:04:26 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.6 000/147] 6.6.81-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250306151412.957725234@linuxfoundation.org>
Content-Language: en-US
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
In-Reply-To: <20250306151412.957725234@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/6/2025 7:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.81 release.
> There are 147 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.81-rc2.gz
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


