Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37C85F855
	for <patches@lists.linux.dev>; Sat,  3 Feb 2024 17:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706982211; cv=none; b=WR04C3ylRZw7f7ItkCrSOwMPSzE5U+4hDNqDsJRHjbpJiYd1GuUvUvD0jUu9RNYSAm66zltloThVSoj6bUQW91K2ai8nhoeS8Hm40MAhdZxefhAI1inZKmivKLJohrCoxSARM3EWOSpFipqMFOJmV7XLa65BexFloMQGZHxYJ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706982211; c=relaxed/simple;
	bh=uIzfiwIX15lOgikrT9E2oUlcdqQqRjFgc9iTxmtsI4A=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=mbZErcq/xFzQ/dwuJxGwGGx7lDiW2Z9olQXmYMJWdQ/nDN9HmOlhshiZ1drJvRaTEGmBD3NuRR5jGLOOfzCNbLA908UHo5jhbeH8/Ow1krDHjl26EbMB5VXxFhgoooqPXcQsFrSbBCLBFtj/U0KdWaKkqOZ+3/Q+v7Ca6JEhgHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=izSva97x; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="izSva97x"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4c009d2053fso705619e0c.3
        for <patches@lists.linux.dev>; Sat, 03 Feb 2024 09:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706982209; x=1707587009; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wBmQBP573ue+tvywp/qvpcloLt9xEUFFZ8EysucNNWo=;
        b=izSva97xlra1LSsPPgNFMl41dWv8dU/mzj1nF/nE1IR3quibctek4bbP23Q9MXdtDV
         a0xPnY52EPoMOetB2p5AqK9NXB9c2mP5E4IzHXyyebP0bp3X2X2szGk57Ao8Iua4mE9K
         z01J5as6AbnjYTMXNA1JPwfTYg5r1VyL4498mRXvnr3nj7zcG2bVxnMxH3KUx2MxFiKB
         5IPE45QGH4LqIVWpTjFOmYQBLZbWOknZTjfxe6mpAifwu3Y96mLt9kgJqqoKB6Z141Oo
         94YX7KbVokffeuWUOsklTj7opVM2EZYxlIC63v/YTVTtcUqvbbMUij8buCCFMygXDPvC
         u1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706982209; x=1707587009;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wBmQBP573ue+tvywp/qvpcloLt9xEUFFZ8EysucNNWo=;
        b=egFcUiGMaXT5OsDN07n40FoTwcxKxiNDpm7gj1Mh2KIef1O8Wd2WV5rQ9TKErChlZ8
         efOGZh7+5VT/9ZZQVGPY5KqUdUGEjtqwqqpM52pwZN0l/m51XO2xYjcs/NV+imVHYHzp
         b2aRt4VdwXVSlrU4835uAT1AL0KzLmmUrcHahRR6TOBAu3W/3XMQZCun5xh/OCjBDQ9Z
         Wx0PXjLweAap4jH8XyQGV133YuCUUltcIClT3syia79SkwXNofKw+TfzxAFtth6Vtsqo
         41xBdYQ8ZnmE/CP5Q6pTcMljMNWC3YF0McMfc4QxkBkm6t+Lbsy49Y5DaCrV3syLxnYw
         bIBQ==
X-Gm-Message-State: AOJu0YyzGIpqY7Xt1CpLpLRovEdePiwA298ES4HfuDK9DUQr6txSorVL
	EtILs9OZnx4kK5YhYEbVq2fMlBpuzns8gr95FEGPZROc0IFjegbM
X-Google-Smtp-Source: AGHT+IHysS+pjb+ReAPpnIbXjOTqqSlG9ycOVSZE0EUm0/x5KHqLG6upf5KqHxzYpex6/xBuJWFqZQ==
X-Received: by 2002:a05:6102:2252:b0:46c:fb30:8757 with SMTP id e18-20020a056102225200b0046cfb308757mr6126041vsb.10.1706982208685;
        Sat, 03 Feb 2024 09:43:28 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUx9M3heCOxZ4kweSUjywb5Ggp6C9yvpQAUbm+24qI37hZx4UP/PSWlE+3wxFoeCYkr3Me9mvR6uSL2wCjk4nUVj2itFaxObcL1VMT1vZGkoRPEuV8dLAo//9CZkWEoV2dN9IZuFESrr5aGkyqUgh9B/GezGLnFr9IsLSpKAYepVuCR96gA864j0yeMrP0t8hhjd/CWaoT3vrYiX0QFR6oATx4O6Fub38Yvdw8MON+NqCju0HVdUuspOmoiMZM4ByT66kNkfceuGD9Hid89Js1AjiuiIB+HlNDayhlgMe6EFdUXvgs5nRIFhmk2Q6LBAq/VDDpO5EdkcOpruKmpKnpW8EFNhKC33zcpsVKASklLasOLHC+vimIrVAeMDM67DaX2aMZPE7dwOHj6EKgiLPjnGDuh+QEXK5NSHFYA8HkaSiYuh7IsAYoBsWu6Xw57PbdzadvA5nqeIBticRhut/qA12s7H/DOArcDDpp+91tq8giqnvHCpXl74DntjFIKZPPIx7cX4ig+
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id om6-20020a0562143d8600b0068692ea038esm1981335qvb.91.2024.02.03.09.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Feb 2024 09:43:28 -0800 (PST)
Message-ID: <6fb12d16-e508-42b5-ae9a-b61753e88b21@gmail.com>
Date: Sat, 3 Feb 2024 09:43:25 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.7 000/353] 6.7.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240203035403.657508530@linuxfoundation.org>
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
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/2/2024 8:01 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.4 release.
> There are 353 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 05 Feb 2024 03:51:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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

