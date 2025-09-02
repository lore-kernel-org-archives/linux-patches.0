Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDCE33EB01
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756833631; cv=none; b=SD8ManN/5nYP53uD2vxqGKBcoPP2mVGvvprA3ds41y4eyPbIGBXEujdZhrb82gdGTK3yHwngi2wouFzmnBfMIklBfhh2xMNcSYupUOcu4Ovx5f5/gPtQU0XN1xqmMhr3hgmO72KOkbkYyc02TvVOwq9Qf+Uw15zsgncW+D9oeGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756833631; c=relaxed/simple;
	bh=aAIA/74ykFG0qSe/yOMdbXjAvsrrRajO6wp0FuGkyIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=smjMseoU2ug8GDLogoVmTesNt6ynWJao4nK4XFMzFui/+6hejwO3jQODrszcsiSTxea/+6NfsgqcsZg0mK+RRcCTSMVLtqFIolUGxmXbwsObo/YPEgDsOnTajpsWYootVthWzmlkCGT3pBAFeiEmUbaq1Q0BVm4xc2F8kRX+J0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dYGMCn/a; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dYGMCn/a"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b340966720so9837101cf.2
        for <patches@lists.linux.dev>; Tue, 02 Sep 2025 10:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756833628; x=1757438428; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9UcAoezJikf05g2UoojgkOql9xoE6wdqt1xJrbbCb4g=;
        b=dYGMCn/aBJ8u6wh3Ym1Od9Dt4EXPF8XlZgJRdqIUBP/w897JHGOrFZRX7ADZYBxPS8
         hvkWOieRW1RY1gmwikqwCvFUz5AhQf075ctRdG/6OshmV5ArrZ1ov3ku84n0iwM6JT1n
         m9zIATyeBmmcGXR0A1xNDqJh9FOXRrw6kDNEMy7cK7F7ULw/KJ/7Asrf/wveg5ZRFD8Y
         suuQwbahuYwXCbp/zuOHgJI/YG5PAgtJ+e7PSEIkKL8f6H9kWjWg2oH/U3wSEIF9vrJK
         KBF1jXXnz/zSVtA9v9SUHh0oFnvrxf9B+aDq/e3aT8PH9n2i8BXOijzJOTt0aXoUZ8GT
         1Lgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756833628; x=1757438428;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9UcAoezJikf05g2UoojgkOql9xoE6wdqt1xJrbbCb4g=;
        b=Vy3yYYSQC+d6xiFPLyC3i8gkszKQfNq9ohG2DwLliDSRNQSvI3ZAO7uhZg9O5+anfr
         ax88DLWt/VrvTRy7mvuCozwCu1Y0mNZhQZ5zgp9l7S1S/gPlxhvtItytYMCLp3E1E6N4
         96IC2L7YhJG0sa/x2Y8S5JIJkVzoTtOL0pinQk43wTIQAcV1VUn40URtxQMEGGDFlMev
         GYWufhgrfwHMV6eTBhEMUJeUT+Y3kAUMawu2YjtL0Q8abNrHaVyy8UzJOQbhkiwd0Kvy
         nbDCb/fronDXSnjfNlpTbseys4xmWCT34FCZotgFyJX22p1KEwcT1txJKh7ZybWT2EPU
         +DfQ==
X-Gm-Message-State: AOJu0YwrH++UWKMKM4LcRHPoG5H687Gq9NdoH/fLFhcg/dzzP99LJLyR
	QoBjudRbRQaAqJaIsXr8HEN16lONLWXWHBrBYZQcxtJbQtTbDH7aIU4x
X-Gm-Gg: ASbGncvv3l1PMfzXaHGXu59+LnkpEsSk/atYPcDmwnO5utSbzw9d1bAUjXzrcmZk5s4
	FgIxgCqe0IBHvPJ1JXVez/yvSm7ZvWwRDy0HSUAZeCZPtA5l24Ld5rruXMDH4b/NZ0ka+1IjOjb
	Ytd5FJp7+u/rPBVG6jIv0KsO9QF5PAPoybsSsuKdUJIpmrlFWIY6WI/gfWOyg7sw696hvdt4aGx
	7V8JKxRP3RvD7hOmwH9dnccvOMpnioLo/YfgsdxoInEJ81j8d5oX5K9hp/YqeL3ttmhzqGfvnV4
	q1D8jqXi7K6vZhV9slt/RX8yRBmV+/KXbyvlXPx6HQ0yY9J4/bb8TZKb8AyI2dK+9dmgWsa80Kl
	6lw4+xbgsaqWC6YBeE6YEkcRqU4zPyNqEHnzxmiasLanDkgNlPd64u94T7h0N
X-Google-Smtp-Source: AGHT+IEYQHz3uH6yvGi4Ms/HZ2DRPyjwin79idavp89EMunKhbND7hmID6a/w+sfeYcDIjyfLR1mWQ==
X-Received: by 2002:a05:622a:a18:b0:4b3:1230:f6e4 with SMTP id d75a77b69052e-4b31da1803bmr131402531cf.54.1756833628275;
        Tue, 02 Sep 2025 10:20:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-80698a04af4sm170640285a.28.2025.09.02.10.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 10:20:27 -0700 (PDT)
Message-ID: <b546967f-d347-473b-bf57-901a63abe292@gmail.com>
Date: Tue, 2 Sep 2025 10:20:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/34] 5.10.242-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250902131926.607219059@linuxfoundation.org>
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
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/25 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.242 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.242-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
