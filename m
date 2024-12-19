Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8946B86327
	for <patches@lists.linux.dev>; Thu, 19 Dec 2024 05:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734587821; cv=none; b=lRbBHZJmEID0+CzA7svr2zyV2fmbxEKZ/RvlAnWaE25jQm0znuCdNpm1/3qA7IN+RgS6Z3nui/5/927QmT41KjR6//iuT2VnjYtcawSMnhH6Dxc0QCn6i7gNpKRkOcw2+31cyJqSQmq11Byh4uFoLJB+tHk4NDjHcMJ/1qOq9y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734587821; c=relaxed/simple;
	bh=+7TLl3NtbojDdQ3Ao558ON8VxgFcuQp8jiG0LJ4/niE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r2gYIf6ckAX741zPZnQgJbXfjLST6QWuvUJ8COiVLS+PzF1HC4LO2yxaA7XGX4YrD6W/6mKsvhrmWe15m5ATT8uQ050yc8WkQB4EFBbbsYbc0LzJvmQnR6Tb5JBfKq+VSPZCnaDJK8KDvMiyG2bLQ3tw2p8ilb/V4YO7CzToCx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aj0KAcPC; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aj0KAcPC"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-725ee6f56b4so348191b3a.3
        for <patches@lists.linux.dev>; Wed, 18 Dec 2024 21:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734587819; x=1735192619; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=og3GTYHjEa3/nY4Uaq9FXtli2n8aQSGFJSHAMYqe2MI=;
        b=aj0KAcPCGVpPfv5Iz+e+Siy9lwXG3wpu0GI/1nAvJiqhKDDTz1jiTsjgt1lXnVaM/4
         kNGNQ0swqlCa1J+6JyB4cML5C6IH9BZLopVXn7glb/wfOovqK8oh45Ek3A6+SiAerMzm
         lWNyJU/9ASIC0jCVIk4SrxX3op9ppHaAHMgdaeptLfM94U3uL2BEc782+Xrsqx8N3u5z
         rwwLaVTo+Zs/4q0reGizJkJu4ZCkmoIZLszdof0Vd0WXH2b4BohIg6LgtCDvbGvOO491
         EXtKea+7J7RggbesjS5EiZOdD6BExfeS6z0mnOq5cEL2XbmspdM6E1Yh3UmJAmArmpez
         DWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734587819; x=1735192619;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=og3GTYHjEa3/nY4Uaq9FXtli2n8aQSGFJSHAMYqe2MI=;
        b=KoeXHGnDGOiMyGAOagDB7x/FTYXGmwNzJhWZiSdzg3Ux/eV8KvN7GCdqRNeRuFD4XH
         8EZ34TlsDeudJNIjZvlIEqbOAeXc7SL1gTZ5ZkAfUoh6M2h5xBFhjtBmpQW30Chf+CXn
         iWiglKbN8vEJY4TpGsD8xZOy8VeSKq389H8Y4biqu4dUhZOI1z7xw6eYySpFjYoNAdOh
         yZL+oGs3w4piVo6T9APQ35jxrDhJLvFcKQCA/sNq9tmy231n3jCN1VO6aooK0IehO42T
         ZasInf+H5ya0R/qhQgJqbooGZAF6jnvlOUoZF+NxzLU7L7SIRvn7ojZ9RKXyKLnwrauR
         L07g==
X-Forwarded-Encrypted: i=1; AJvYcCW/aylcrBD2pAGC7OV1n24A1miQ9ZdtrJZAEjHx2wf//YdPAfWL6pDihPXkigADUnKf7xS4JoHt@lists.linux.dev
X-Gm-Message-State: AOJu0YzgmdnZtd/d16PEzbnlEE2GiDy71mgx7Erym0mVeqfkDarIzZhr
	ZSf35AITmgEUMWG2gJ9aJSwQX2Q1pIqadaW4SgV/IswjMeDfwPBY
X-Gm-Gg: ASbGncsCR5+lVbAjBK/WpqErg6+w7nh6epHsHpHgvYmc5cgx2uttj4TGs7TQlZ9Ja9V
	Set39vbv3Ef8FUxL9D9+JCoDWTWu975HyNjdAw/LDVHygeAfZ+oCZT6H4wz8usA9kOLQarFJ7mv
	en0FqXokta6UNzZxRsflvO6Z10jvoa4+oSmDodQRBjZc84ZTCXVXVTqALHqVLtu4MVP2IwHCViu
	zrjY6uOaoLBn/72+G5DCVbsTyOfiery0RCCyU1KKNGGjgZh8Li960lWjUW+I3DDQIJUpBMehl9s
	JIDZ/MMI5iFqplkYmv8004jZRfIe7Q==
X-Google-Smtp-Source: AGHT+IEHVPF3G+cxcMl7m7/CSStSxwulpaTg9IQ8YQ1JtUXmFIPYITE2Wu5dMV86fPCk+uWMWBPfqA==
X-Received: by 2002:a05:6a21:9994:b0:1e1:beea:8898 with SMTP id adf61e73a8af0-1e5b4ab59f4mr8371013637.45.1734587818709;
        Wed, 18 Dec 2024 21:56:58 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad830afasm461860b3a.49.2024.12.18.21.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 21:56:57 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <60f5d471-7c5c-4a1f-a1de-c52e272ca852@roeck-us.net>
Date: Wed, 18 Dec 2024 21:56:56 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
To: Jiri Slaby <jirislaby@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, Juergen Gross <jgross@suse.com>,
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
 Anders Roxell <anders.roxell@linaro.org>
References: <20241217170546.209657098@linuxfoundation.org>
 <CA+G9fYu0_o6PXGo6ROFmGC1L=sAH9R+_ofw0Hhg8fZxrPRBKLg@mail.gmail.com>
 <746e105c-c6b2-48c7-ae89-4deeb97e1866@kernel.org>
 <869c01f2-e069-440b-a81b-fe71e969b72e@roeck-us.net>
 <20241218165444.GL2354@noisy.programming.kicks-ass.net>
 <4a1dfae2-d76c-4b78-a058-fce9d565dab6@kernel.org>
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
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAlVcphcFCRmg06EACgkQyx8mb86fmYFg0RAA
 nzXJzuPkLJaOmSIzPAqqnutACchT/meCOgMEpS5oLf6xn5ySZkl23OxuhpMZTVX+49c9pvBx
 hpvl5bCWFu5qC1jC2eWRYU+aZZE4sxMaAGeWenQJsiG9lP8wkfCJP3ockNu0ZXXAXwIbY1O1
 c+l11zQkZw89zNgWgKobKzrDMBFOYtAh0pAInZ9TSn7oA4Ctejouo5wUugmk8MrDtUVXmEA9
 7f9fgKYSwl/H7dfKKsS1bDOpyJlqhEAH94BHJdK/b1tzwJCFAXFhMlmlbYEk8kWjcxQgDWMu
 GAthQzSuAyhqyZwFcOlMCNbAcTSQawSo3B9yM9mHJne5RrAbVz4TWLnEaX8gA5xK3uCNCeyI
 sqYuzA4OzcMwnnTASvzsGZoYHTFP3DQwf2nzxD6yBGCfwNGIYfS0i8YN8XcBgEcDFMWpOQhT
 Pu3HeztMnF3HXrc0t7e5rDW9zCh3k2PA6D2NV4fews9KDFhLlTfCVzf0PS1dRVVWM+4jVl6l
 HRIAgWp+2/f8dx5vPc4Ycp4IsZN0l1h9uT7qm1KTwz+sSl1zOqKD/BpfGNZfLRRxrXthvvY8
 BltcuZ4+PGFTcRkMytUbMDFMF9Cjd2W9dXD35PEtvj8wnEyzIos8bbgtLrGTv/SYhmPpahJA
 l8hPhYvmAvpOmusUUyB30StsHIU2LLccUPPOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAlVcpi8FCRmg08MACgkQyx8mb86fmYHNRQ/+
 J0OZsBYP4leJvQF8lx9zif+v4ZY/6C9tTcUv/KNAE5leyrD4IKbnV4PnbrVhjq861it/zRQW
 cFpWQszZyWRwNPWUUz7ejmm9lAwPbr8xWT4qMSA43VKQ7ZCeTQJ4TC8kjqtcbw41SjkjrcTG
 wF52zFO4bOWyovVAPncvV9eGA/vtnd3xEZXQiSt91kBSqK28yjxAqK/c3G6i7IX2rg6pzgqh
 hiH3/1qM2M/LSuqAv0Rwrt/k+pZXE+B4Ud42hwmMr0TfhNxG+X7YKvjKC+SjPjqp0CaztQ0H
 nsDLSLElVROxCd9m8CAUuHplgmR3seYCOrT4jriMFBtKNPtj2EE4DNV4s7k0Zy+6iRQ8G8ng
 QjsSqYJx8iAR8JRB7Gm2rQOMv8lSRdjva++GT0VLXtHULdlzg8VjDnFZ3lfz5PWEOeIMk7Rj
 trjv82EZtrhLuLjHRCaG50OOm0hwPSk1J64R8O3HjSLdertmw7eyAYOo4RuWJguYMg5DRnBk
 WkRwrSuCn7UG+qVWZeKEsFKFOkynOs3pVbcbq1pxbhk3TRWCGRU5JolI4ohy/7JV1TVbjiDI
 HP/aVnm6NC8of26P40Pg8EdAhajZnHHjA7FrJXsy3cyIGqvg9os4rNkUWmrCfLLsZDHD8FnU
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <4a1dfae2-d76c-4b78-a058-fce9d565dab6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/18/24 09:48, Jiri Slaby wrote:
> On 18. 12. 24, 17:54, Peter Zijlstra wrote:
>> On Wed, Dec 18, 2024 at 08:53:39AM -0800, Guenter Roeck wrote:
>>
>>> The fix is not yet in mainline, meaning the offending patch now results
>>> in the same build failure there.
> 
> Yes, as I wrote in the aforementioned message :).
> 
>> It's a test, to see if anybody except the build robots actually gives a
>> damn about i386 :-)
> 
> This is not much of a robot -- openSUSE still provides 386. As a port now. I failed to destroy that port in past several attempts :P -- there were still users.
> 

For my part, if I get a few more of the "nobody except the build robots
actually gives a damn" or "why are you testing this or "you should not
be testing this" responses, I _will_ stop testing this and any other
configuration where people make such statements. I am getting tired of it.
If anyone doesn't want something tested, it should be dropped from the
kernel or at least be marked broken or disabled for build tests.

Guenter

