Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F514211C
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748888172; cv=none; b=bKrNbHriryCWMlKWJGSnRCrw8v3vzGhfyGUSrG5erKSTnRGsmBA8IkzQpfLtXnxcAm2b4uKcUo0/XBul5Tj0BhWu3or6K2gjnuBG24Xg2H37hBIRbAKPiiSuGsNKgHZuxFPwnWCfmu+T5zARb1d8Tb3L9tsj8ANAR7qV9w6zj3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748888172; c=relaxed/simple;
	bh=Co5GERlpdWDkiji2O8QMJh5TNTTCEbKdFnnrTwwjduk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SBqPzgSMZiJKcK7miXMMmofBy0lawhKLD3cqlaq1CWAFakya3u2Nbb8kz4HM4GwnQ08tkfqisfa1rd7rdOb8QAPoIg06bKwf/BNot/RdaF0Khk9oNPO+6oQZyWOYvRkLeXVjJQmRsvwSsS8MAoGaIj8f6TQyxcrKM5AaGE3w9xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WASJhnOB; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WASJhnOB"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7406c6dd2b1so4635085b3a.0
        for <patches@lists.linux.dev>; Mon, 02 Jun 2025 11:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748888169; x=1749492969; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UyqNwvUqQhnqEGUWsWmeB00ROtyy4Hj45n5IuqVHRfw=;
        b=WASJhnOB4gdr1FpXLNWCpKeqqmyy1BLKnGSpVv9NIQHks2jkp/gPooVx7Tjv6EDmuT
         PTQyBAYcstvBDxDDdC8bWaqfnuSVTu/HllqOAlGUe/9bV05N/5keKMCm8flzYaXOGmtD
         /Z5GwkLfajO/ZfiDpuMYBU03tJ/wpSgf/mT7fsMuY+bLYTQ5gIZHUrw4h2U5GZ/5M654
         fAwvO2i/dvCX1TRIeKZBHOBLh8ReWLW7z0C6BatjIBCf09kTu87BLWq1FLpbMjMh8XYt
         BamiVGHhZ+7sItwawLbf4C6sO6t5ocuYfoLTwtXLgL2oxX/KpnfG5IMg1wsdeCxWKTwY
         qKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748888169; x=1749492969;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UyqNwvUqQhnqEGUWsWmeB00ROtyy4Hj45n5IuqVHRfw=;
        b=AzsGsT4xZNXmybvepfAPnZZAiG+b/0YBbzWnKVMOMVQmsPksTAvqsId4+bqkS+g6Ky
         Rmzawn3/PcOoNvaQy3LATOgGLYqqwdxM976+7JYcAtkuo4/G9S3zT+AgYnvw9eyDos9n
         qn+T+Dq3D9QhH40Iwr9XnrL/rm4BbGLegNx7TeHL8/pBlwIghWsEtLOxoUk8aw0vWhly
         cDS5GUYI0slMR4CkVuv8BXVFf00E4qk/+Z3DwoyaTdIKsolaFP5BGWatb5iHw90lXixw
         qlsPsFCVeOHx19nyHtd71IDE65FT4Dv+hfzQLG8khS5qZWCSMDDWfeWbiKe/QFKue4l/
         vAzw==
X-Gm-Message-State: AOJu0Yzua5SDIc0gZJj8TlBEZ7+lOjhAAtcPk7v63EpKf6yGd9oGB2eJ
	WeRITvYrlIfS94mvwG9+WzOIByT/kBJjgFyIK6cGmv1V55s2BJ6jyfDo
X-Gm-Gg: ASbGncvFHhSZseYkCY3lH8uVIdHLOdFNnPTYXlURQfqRWGYNBPPxvrXoq36x0IqdPsU
	Mv4Amhno2uufHZvEtVh3eBN22RO/G3iHW5kCKbHtsjbDEd2AX6gi/eCzkzYlO5/x+8sE3pLq4XO
	cbPmcyToP+v/1D0nowLYHCMzlNhAUywsmMfUjwTGBx3M9oylOEtBJ7CHfu/XM2Ykq1c6R5ukDQt
	iSkgKVK/yL+M/3/3oVFkBbS8g6jTAEJOlA2SDRFyCXvjysDAzfFeego7657zh7yQSFGtt9LQc9i
	YKOLYRjdDqPqkljpQgOXNVysk5tLT9CMUP6qpZwKoNvoSM9ihd/0CKGn3k8nKynWRgblaetDT5g
	ZdSKCboonUgVCrQ==
X-Google-Smtp-Source: AGHT+IE6NLTKTpC6GtHj4EgDT76b1zDKnEQQQlNtkMqV5IiX48QoDmFLvqM7upnX4DnZWuYBYe7VsQ==
X-Received: by 2002:a05:6a21:9991:b0:21a:cc71:2894 with SMTP id adf61e73a8af0-21d0a0d64d1mr543065637.17.1748888169501;
        Mon, 02 Jun 2025 11:16:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-747afed33casm7926329b3a.73.2025.06.02.11.16.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 11:16:08 -0700 (PDT)
Message-ID: <a0393fe4-4072-437b-a64d-f040c98bcb41@gmail.com>
Date: Mon, 2 Jun 2025 11:16:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 00/49] 6.15.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134237.940995114@linuxfoundation.org>
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
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 06:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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
