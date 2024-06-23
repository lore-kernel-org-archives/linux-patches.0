Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3B018133A
	for <patches@lists.linux.dev>; Sun, 23 Jun 2024 14:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719152889; cv=none; b=h4i7hYISF9j6oEBBAtgugWUtmql8SXvsuFZk8UUha4Da0fjr+i3xk0X6i6xp5ou81N1RLaobPj3vF9JCc8pkMR7wMjXjBAKxS/Kzq4WPDPfgmoozOzbLoGizEet8aLFROSDYMst1XD7akzwegmk2j8VUH+foEC4sUpRwqygycZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719152889; c=relaxed/simple;
	bh=uTS0y5tk4q5zjkmZUAian/2KuNlmbhkj5TWIK/NgBTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDpt7TksvWfZtUnzNSiMOuHD541jXxHVQyUjgV2SD4TlDOcGnE1T8POSbqtA15FgLAAsOx3JY168C3mlHYc+ju9J0uNMCF8cCwP8NoH8KzGNk5or8azEaOgzMIRESRxReQQDL5Cb4/+wvZEV0MV4IHdzGNtSS4QU7CE7hihWeK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U2npsrqK; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2npsrqK"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1f4c7b022f8so30990235ad.1
        for <patches@lists.linux.dev>; Sun, 23 Jun 2024 07:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719152887; x=1719757687; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=jqO6Icdxzq7ad8wELujObe1VLZwcjB87wmoeNB6xN1Y=;
        b=U2npsrqKnLPV8R8p3wb0wQxAxilfpwo2e2VJea0mvH/ly+mW6k2jTf5As1yU1SGz9V
         KHw1H4Zfndu7nvN17zyjrsCA9iHDsgi2eCVOwm76oE2THjWKSCh6s5yw4GabmOFXigtp
         KuOCtD6cPKgheknJxIcr7/na7BE3kRN/K2GxcEatMsiwJ5tKzdUEKC2R727f9A4IDrVk
         f7rp96qPrZ4U6t0OllrJdFzck3+7pz8aKWBZ5JEOG699P6zH+dF6n7iBtNLTBXIUp59P
         aUzobVHDqZ4+fUkuOYSSXjiEjq3M3vx5d/OWyyKZtQG+WeyKka5bgzoOcoK8pmOD4sQf
         enzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719152887; x=1719757687;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqO6Icdxzq7ad8wELujObe1VLZwcjB87wmoeNB6xN1Y=;
        b=SmN2Vzon1d9XS4FPKvAKrac7a1b0T51tlt8jax9n5V18DIBbIOi00uSkAY2wGS5drp
         ImfBrdUr2pakGwB5ihO9ZqlG2CzbODPIVKXtGgiYF9qLwZ9xM386647i/a7gF5j5I460
         tBYkvIavvlxOaR+K6+pqPuDqiP2UExjfooxNvE+avzTDunOBBV2D4uS4l+6Oq6gJ5MfT
         f64eKkub426eahnrNJSGBW23yW7uAQX0aOpmm+KKvUGG0vZILKzBuMcwfh9+QvlNckzN
         cjrdvN4slDWdGCc00Z9uE/pvUT4Ux0c89A905pkTpasVSFfzudxaZiD1vxQUdMHrFjF3
         So8Q==
X-Gm-Message-State: AOJu0YxsWtVvGEy8XrvKylIxUYKirUerjwCywdOLW1yedOfgRCn8gK5Z
	Xmn7OfwSx5BBswePWbaUVfi+tH5bkq7OdO3cvIyvMlLnC99IeUAX
X-Google-Smtp-Source: AGHT+IFjDr9GyxsTqtQNjKwUjgnNG16nBwyUcLpr72RPNRsO+MVzjMOQUZQg2+OpvuosWHHKPL+Q8w==
X-Received: by 2002:a17:902:ea08:b0:1f6:5013:7842 with SMTP id d9443c01a7336-1fa23cd95edmr31101595ad.27.1719152887013;
        Sun, 23 Jun 2024 07:28:07 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa2e3d0389sm10487575ad.107.2024.06.23.07.28.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Jun 2024 07:28:06 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <7a496413-0317-48d2-ad78-2ce32f92f12b@roeck-us.net>
Date: Sun, 23 Jun 2024 07:28:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review [parisc64/C3700 boot
 failures]
To: Helge Deller <deller@gmx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, broonie@kernel.org, Oleg Nesterov <oleg@redhat.com>,
 linux-parisc@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240619125556.491243678@linuxfoundation.org>
 <614d86a1-72c4-489b-94f9-fbe553c25f28@roeck-us.net>
 <21d5c00f-a373-4173-84e5-33dbd6305b57@gmx.de>
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
In-Reply-To: <21d5c00f-a373-4173-84e5-33dbd6305b57@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/22/24 08:13, Helge Deller wrote:
> On 6/22/24 16:58, Guenter Roeck wrote:
>> [ Copying parisc maintainers - maybe they can test on real hardware ]
>>
>> On 6/19/24 05:54, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.1.95 release.
>>> There are 217 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
>>> Anything received after that time might be too late.
>>>
>> ...
>>> Oleg Nesterov <oleg@redhat.com>
>>>      zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING
>>>
>>
>> I can not explain it, but this patch causes all my parisc64 (C3700)
>> boot tests to crash. There are lots of memory corruption BUGs such as
>>
>> [    0.000000] =============================================================================
>> [    0.000000] BUG kmalloc-96 (Not tainted): Padding overwritten. 0x0000000043411dd0-0x0000000043411f5f @offset=3536
>>
>> ultimately followed by
>>
>> [    0.462562] Unaligned handler failed, ret = -14
>> ...
>> [    0.469160]  IAOQ[0]: idr_alloc_cyclic+0x48/0x118
>> [    0.469372]  IAOQ[1]: idr_alloc_cyclic+0x54/0x118
>> [    0.469548]  RP(r2): __kernfs_new_node.constprop.0+0x160/0x420
>> [    0.469782] Backtrace:
>> [    0.469928]  [<00000000404af108>] __kernfs_new_node.constprop.0+0x160/0x420
>> [    0.470285]  [<00000000404b0cac>] kernfs_new_node+0xbc/0x118
>> [    0.470523]  [<00000000404b158c>] kernfs_create_empty_dir+0x54/0xf0
>> [    0.470756]  [<00000000404b665c>] sysfs_create_mount_point+0x4c/0xb0
>> [    0.470996]  [<00000000401181cc>] cgroup_init+0x5b4/0x738
>> [    0.471213]  [<0000000040102220>] start_kernel+0x1238/0x1308
>> [    0.471429]  [<0000000040107c90>] start_parisc+0x188/0x1d0
>> ...
>> [    0.474956] Kernel panic - not syncing: Attempted to kill the idle task!
>> SeaBIOS wants SYSTEM RESET.
>>
>> This is with qemu v9.0.1.
> 
> Just to be sure, did you tested the same kernel on physical hardware as well?
> 
> Please note, that 64-bit hppa (C3700) support in qemu was just recently added
> and is still considered experimental.
> So, maybe it's not a bug in the source, but in qemu...?!?
> 

Following up on this for everyone: Helge doesn't see the problem on real hardware.
I can make the problem disappear by any of the following:
- Use gcc 13.3 instead of 12.3
- Disable CONFIG_KUNIT
- Enable CONFIG_PAGE_POISONING (without actually enabling it in the runtime)

Overall, that suggests some kind of heisenbug, most likely in qemu,
unrelated to the commit above.

Thanks, and sorry for the noise.

Guenter

