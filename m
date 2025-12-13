Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1036BFCE
	for <patches@lists.linux.dev>; Sat, 13 Dec 2025 16:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765643493; cv=none; b=Tbp73L3Onh9guP9k+1po+ysmrgKU30JHATOEBYyfbGwNKcOJEnMXAnKsXkju0HMAuxil0SOLx9pxZrKSI2AUFR9KvGtm06A91ekbcVFgV7ZilqHpv2vmJPmrJOJyaDTJXOJXk+dUYWCss93BjHBHeB7mZQ1pZpdS+7PTZEg4N/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765643493; c=relaxed/simple;
	bh=VcIMFNYSu/iw4Td8CtM89chcrvq+DwIdezRkAya6ZlY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OeyMt/PsR9ApCd4H0ODERHbdZnBG8cJP3JeHSL3W6cCqHJ9b/oZpbDNefYxrTfy+BKz3UgY+YVZ4Tw5n3KHGk3L3MmYbchTpJEkI0lxBEm1jKoAG5javEDwFO8bTzNJpz89l9E9UWSvH8JqIVgSXBqyFrDHDdQfYKLqeKyuIzf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jt1Q3uEb; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jt1Q3uEb"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-bdb6f9561f9so1916007a12.3
        for <patches@lists.linux.dev>; Sat, 13 Dec 2025 08:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765643491; x=1766248291; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=YC+xEnBIE6YMPV/nC7GeG2XoJ77JFEf62MbpcVXJSPE=;
        b=Jt1Q3uEbq+r0UPlYcM0hTNDc2j3Sn3JGKoq41rjOyrCcTKXBco2AxzEQIjF5XnBMbR
         Gfz2Y1Nx/SUx6+lAwge/2DwieZhc8C4RBA9LwKTfdaxhc2Xck17qzu0lAeuwk3lnyZ5n
         dcI2yFTkwH9tHe+6u1Z56PjkSU0U5a51Gu9cJhS68smrr31ltcpLzWbiU1WKzpUX98Lp
         oSJvDFH8N2g6ZXxVZr0yFTaE42D6/XgkPqu9nOWGA0imxplRGs6aiEl0zk4jpPmjPsdm
         3WLHAGFDAZ7bdBtiGpnZcMXMrtRgw7CMqw9Ivy5JIS+Fc/VINnultlW/rhIgK/BQ97+W
         k5Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765643491; x=1766248291;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YC+xEnBIE6YMPV/nC7GeG2XoJ77JFEf62MbpcVXJSPE=;
        b=QF/GuPBnfMD/gDAJ9Qbam8OBn1COBywPvyLHr3GVwBoVWraUA10zDy65oZDFM0CWi5
         BtKhKkgHeaAKgM16PPdnUjfgGv6B0/IjBWTj2eVMcgvF13CYbvf4Si/Rw+tEWPFZi6gu
         S6z7Ow7GlNZEosCgbUCN1IYmOHXqAFRcL8x2lYj5MzNkaUHbjy7crGQlHlaQYzRF6PZp
         L0wG4kERSvxWd0U2qKo/h9Jl2iUHp6CmdLHDBfSAieY9cRH/Z3UbUipAICpdRhKGinnI
         p4fUJjJc+FyNRmAWlr0j2gMesAXspOQjS4lNVrX+hXEuJnU99cTU2GaSN1PX0sqlc6vd
         O1pw==
X-Gm-Message-State: AOJu0YwcOT7qoALDeFEsUvt8jt4d31OnOfOYrhCY/tU0z3J4UBeqSSp1
	1AYuqc+WMhi9E1TWgC0yAIzLMUmaHJ75mrKahaNgCFZWsCp7pAbuk3pp
X-Gm-Gg: AY/fxX7cP1tcbjSxMoAQiSEVKsQtTVwjrz8FCTDEfkPKPvIxSyxxxLytYIwod6EdqlC
	Id4nnQt+BdbtGA6Ylx2HgI6yuyF3+4h44ZGI12+PyYkxLOboj5/FMWjNwwRigOTD7ItIpcxsDGc
	UuC+6a2fjtlDkROMwc9npR4v7zxKkLg6bZL00pSvBXVr9BqJbG4dzVFkWcRza4ikK5Ud0AMbUNt
	D/EgffnBhc4eOQmNzzEotG6ts6F34jDq7o/H6+5E155Pr07hAEn+GYIbEGClH7j6FxIuWYQDeJU
	/GsKlbExgRGERj8/grLDTG134vVVZnuu+SgVAjVpXZ483l9ImtM94VbzqHv2qBCkT2hQ3dEbcY9
	e/1PDWrKMtpoWPqAvCYYwbDcSSy8Dne/4/BVgE82U9sjW+OJH7qUqI+ZOrRYSzwqR8PQ01fKqga
	A2IzA8vfOATFutjzSwC8yC6zV3TkDzP0onjfSb1gLnKK+HvYXKD4KPPIsm1DQ=
X-Google-Smtp-Source: AGHT+IEmhUjb0bn9l5sejLQ8WyWRX36n4fd8kPchoVbaI2C9XSS4g5e/5Gzx01/Bcl3r4EWuHbim9Q==
X-Received: by 2002:a05:7300:3211:b0:2a4:3593:969c with SMTP id 5a478bee46e88-2ac322f9751mr5315625eec.25.1765643491097;
        Sat, 13 Dec 2025 08:31:31 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ac191ba0fesm19570193eec.3.2025.12.13.08.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Dec 2025 08:31:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <35e3347a-198f-4143-b094-2d0feb8d6d50@roeck-us.net>
Date: Sat, 13 Dec 2025 08:31:28 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com, Huacai Chen <chenhuacai@kernel.org>
References: <20251210072948.125620687@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAmgrMyQFCSbODQkACgkQyx8mb86fmYGcWRAA
 oRwrk7V8fULqnGGpBIjp7pvR187Yzx+lhMGUHuM5H56TFEqeVwCMLWB2x1YRolYbY4MEFlQg
 VUFcfeW0OknSr1s6wtrtQm0gdkolM8OcCL9ptTHOg1mmXa4YpW8QJiL0AVtbpE9BroeWGl9v
 2TGILPm9mVp+GmMQgkNeCS7Jonq5f5pDUGumAMguWzMFEg+Imt9wr2YA7aGen7KPSqJeQPpj
 onPKhu7O/KJKkuC50ylxizHzmGx+IUSmOZxN950pZUFvVZH9CwhAAl+NYUtcF5ry/uSYG2U7
 DCvpzqOryJRemKN63qt1bjF6cltsXwxjKOw6CvdjJYA3n6xCWLuJ6yk6CAy1Ukh545NhgBAs
 rGGVkl6TUBi0ixL3EF3RWLa9IMDcHN32r7OBhw6vbul8HqyTFZWY2ksTvlTl+qG3zV6AJuzT
 WdXmbcKN+TdhO5XlxVlbZoCm7ViBj1+PvIFQZCnLAhqSd/DJlhaq8fFXx1dCUPgQDcD+wo65
 qulV/NijfU8bzFfEPgYP/3LP+BSAyFs33y/mdP8kbMxSCjnLEhimQMrSSo/To1Gxp5C97fw5
 3m1CaMILGKCmfI1B8iA8zd8ib7t1Rg0qCwcAnvsM36SkrID32GfFbv873bNskJCHAISK3Xkz
 qo7IYZmjk/IJGbsiGzxUhvicwkgKE9r7a1rOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAmgrMyQFCSbODQkACgkQyx8mb86fmYHlgg/9
 H5JeDmB4jsreE9Bn621wZk7NMzxy9STxiVKSh8Mq4pb+IDu1RU2iLyetCY1TiJlcxnE362kj
 njrfAdqyPteHM+LU59NtEbGwrfcXdQoh4XdMuPA5ADetPLma3YiRa3VsVkLwpnR7ilgwQw6u
 dycEaOxQ7LUXCs0JaGVVP25Z2hMkHBwx6BlW6EZLNgzGI2rswSZ7SKcsBd1IRHVf0miwIFYy
 j/UEfAFNW+tbtKPNn3xZTLs3quQN7GdYLh+J0XxITpBZaFOpwEKV+VS36pSLnNl0T5wm0E/y
 scPJ0OVY7ly5Vm1nnoH4licaU5Y1nSkFR/j2douI5P7Cj687WuNMC6CcFd6j72kRfxklOqXw
 zvy+2NEcXyziiLXp84130yxAKXfluax9sZhhrhKT6VrD45S6N3HxJpXQ/RY/EX35neH2/F7B
 RgSloce2+zWfpELyS1qRkCUTt1tlGV2p+y2BPfXzrHn2vxvbhEn1QpQ6t+85FKN8YEhJEygJ
 F0WaMvQMNrk9UAUziVcUkLU52NS9SXqpVg8vgrO0JKx97IXFPcNh0DWsSj/0Y8HO/RDkGXYn
 FDMj7fZSPKyPQPmEHg+W/KzxSSfdgWIHF2QaQ0b2q1wOSec4Rti52ohmNSY+KNIW/zODhugJ
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/25 23:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.62 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Dec 2025 07:29:38 +0000.
> Anything received after that time might be too late.
> 
...
> Huacai Chen <chenhuacai@kernel.org>
>      LoongArch: Mask all interrupts during kexec/kdump
> 

This results in:

Building loongarch:defconfig ... failed
--------------
Error log:
arch/loongarch/kernel/machine_kexec.c: In function 'machine_crash_shutdown':
arch/loongarch/kernel/machine_kexec.c:252:9: error: implicit declaration of function 'machine_kexec_mask_interrupts' [-Wimplicit-function-declaration]
   252 |         machine_kexec_mask_interrupts();

... because  there is no loongarch specific version of machine_kexec_mask_interrupts()
in v6.12.y, and the function was generalized only with commit bad6722e478f5 ("kexec:
Consolidate machine_kexec_mask_interrupts() implementation") in v6.14.

Guenter

