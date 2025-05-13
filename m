Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F8F20E03C
	for <patches@lists.linux.dev>; Tue, 13 May 2025 09:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747128592; cv=none; b=lJP1gln4y67KoT3i2tRnSK4kYQEDL5RjQc9j73/+yiuCPofEmKRNKSHgUrGNFgCGL8iK+p8e2jfw7etfH2Zm+FYHXQVu1ejxYPMxtqx/9QOZ5e5QKfW3DbuaNR5zVZNhOdyVcRwQj0JHjEX4ASN+9Alg7q+AnUz9JrsvX3M3fC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747128592; c=relaxed/simple;
	bh=lwuNQzkVZY+r3BjYV69YcvGsn1lcu7z4FuHiHAtN86Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nCLI80sOik6eLMuVubliYvW19Ck9/1+0ozsrG2svG7S4Gq+SfVvWvBZqChd4b2/G9bI6Khb0rDmgWVcp94WlIySiGYmm3YA5IC7jAUlWD8cysVZmY4WMJ9BpfmD40b6dkgg7GwXXan+AUhM6VrNwRm3Gn1DoujXaYr3QmTI/edM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HCnal39V; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HCnal39V"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-23035b3edf1so16169195ad.3
        for <patches@lists.linux.dev>; Tue, 13 May 2025 02:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747128591; x=1747733391; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=g0FbxF4j+yV005ArDJfZEQRtUEXUG2HW1Azh2TjM6qQ=;
        b=HCnal39VyDxMafdEZOtzCEn9tlFznUyweHGKs+ZxuHa6jW1RRV2CyWoZMbMO+8YvJM
         PtASY0d6aAbFyTvVlqGlWznrhAOOrd9/DulmKAtb4Np/Bwe6qaPT6GSN53eBeayUB7+P
         KMJFcF/nWjSqYoiR7pRPUqA9TpgbEnz7c8ZQIe7DStKR7/DT/Zar4sc1LlF+Cl6SIQOd
         OPpIYc5yaeGNdohGesCdjRpQHL5JBrp+uWxx0KtwX/qsN6g3ctuESfMj9q7yqCJAw63s
         9ME6ECzM+fTmF7XRPCAhGVsjAC9Bxk9DRfLBqS28q+kd3Bxh1pvEbOSWd+rISoaZNJkq
         nXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747128591; x=1747733391;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g0FbxF4j+yV005ArDJfZEQRtUEXUG2HW1Azh2TjM6qQ=;
        b=WCZEmS2eDxjNu96QWDkL7Va5CnymBJv7qXKVRyB/6N1QxMcvwrzOndsKUOrcMEm3LY
         2T5QnQTtHFVF2K6G1uZMu6IwDDmw7z6gj2H0TK/BcG/UdI/bhEWV+PNBpzEjFcNhXxrn
         Oenx5uuEn7c8PFYel5j6+RwA8ej5Zjr/dKFE6djjPvilwizEYf9O33cChknEgO6w1D2m
         F9SdC6YLAToku0LAcZI8IjArsM1d7XaHKf74QqPSjFv+/4INoUY6Rg50O1R3047WUkOP
         SL5oOevofK7URMmfyq15tMSpetxJwCDivfLqIp7eF0O/NwR6JG4BUiQjopflldSomwl9
         SVrA==
X-Gm-Message-State: AOJu0YygYjqZrUuPE9+THE6pJiZEdSpHOkDJHXNIQO7FL+Gc+ZO9HgbC
	JIQFPy9F3QrZL2I6Vzv9x6nnL4dtnz3e3AwKLjxiZ5AcaZyAPtaH
X-Gm-Gg: ASbGncu2CV0yFwXfFyVtMBcMSFnGu1UYzd2McHr1GF2WXiv/gTA1gSZD5IcOZvNlMHR
	nvVZt0Rlp1FTB+r/eVU7PFZsN9UeUkrQilhtbKnuDdMyTo5utLFKuXhszxMvVUj/pe0EKN1JFWi
	7JVmkLmelOvktxKj358IIW1eNoKqefg7DolSoLBybD7arhC+8inH4ENfaGYCy7//cLGQVNXTLVi
	ksWMm+/BVh89+NRtP6cOVskvF/jyIaycpH8Y6uDnkq/k5XPwBDgiDdcARqdHW93j+cc7E3rDAle
	Y0b7IDQH9jQ/OkmeHSCBcmr9UJlxu2kVDlMJw0THeesZRu+JGTrRikF/fLRcu/hJD2TMxd5J2Jf
	EsVKceBXmywGv5IeB4rWH1HQv4PijBGCo3drc7w==
X-Google-Smtp-Source: AGHT+IFajfHqbu4LbEcFiAzWJeLvYPulEit9SQtbrCnulAq3KRzKom7xG3bcmHEz+/YVp29nrxS5BQ==
X-Received: by 2002:a17:902:ced1:b0:22e:4db0:6b2 with SMTP id d9443c01a7336-22fc8b107f4mr214961565ad.9.1747128590674;
        Tue, 13 May 2025 02:29:50 -0700 (PDT)
Received: from [192.168.1.24] (90-47-60-187.ftth.fr.orangecustomers.net. [90.47.60.187])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc7742e1dsm76849965ad.78.2025.05.13.02.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 02:29:49 -0700 (PDT)
Message-ID: <ef73c998-fa93-4681-a87c-ef9dcd70034f@gmail.com>
Date: Tue, 13 May 2025 11:29:45 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/54] 5.15.183-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250512172015.643809034@linuxfoundation.org>
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
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/12/2025 7:29 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.183 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.183-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

