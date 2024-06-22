Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208B71E488
	for <patches@lists.linux.dev>; Sat, 22 Jun 2024 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719068316; cv=none; b=ou8Yf4u9O0fTM0CUNsE1TDlh7fFVKwskZDovrAFx1qwq2CEAiCTevbTfva0B8PhXeV3cB10AkKCm6wSdYCPMwfElWcWNCVedBPuWDYjka8Fz5dRqpWRElwWKz89hzzAfRcQDYzoV5wXxQya7rANAQeleMhnE4OGKwNPqtKXsbCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719068316; c=relaxed/simple;
	bh=MQoKloZEpoKquI1arZ549tKGjKUMWJxM2hFahY1T8MQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AUOrLsq5yrzUz6nQA7DdFiu7DP336nn2hK8CB8aS1Zom3RFn2UNdxGlmLD/uOWj+8xtfX1A623x8iXkjfjDyYO+/b4EHYH1U6u8iUzF+LMLcJTT4+al3kDbh3GSWykiMHUxaDoEys+dMQQZDy7RnjCvKPQQ8y9hyVfyTS6sT6VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EZzNoy7s; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZzNoy7s"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-681ad26f4a5so1853999a12.2
        for <patches@lists.linux.dev>; Sat, 22 Jun 2024 07:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719068314; x=1719673114; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=7AgK+NRrJzSdnlqO628yfSFZnHrjqGjFCisQ7jDYWCc=;
        b=EZzNoy7svjvupimxx+ZigNVRCvnJNqT8UGW0fPPulKarfM1iS5bvltwJIvXTk/CRAu
         4okRCOI2WExZTntNp03/IOOY/MjbdfnYSTOZI2nRC2292FTHMQ2o63Q9OMl7ibfgedqW
         xJsyCPi2H8gcDy9qNhHtTJlNOA0Ga9yRb6uM8jTmU/rKQV2vEUEXTdW+SdKdzHZl1mBu
         MTSpWA94lJtqXKU7fT/LuIVGR15A7bfoLGHyyKSUa9LX1E4pM32ogrQTEpEHe+02JjYK
         UgQHMy6XHgDSHaQzYkvUAxaVXZUpvZkIhtY5nI63B7LqpXaIzMmYRPu+OOgzHlPoK58H
         CUJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719068314; x=1719673114;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7AgK+NRrJzSdnlqO628yfSFZnHrjqGjFCisQ7jDYWCc=;
        b=RvaiDFBqV1+ayQAacXjcuBr9565+6Pse40ImuHVdhqqeI3PScN22vLmqMmRiDzOU9U
         jem5gltMWEYiq9MRaOuHVeVCRAi2oVkBcZsy/gLiV1Qk9+HdsHX2QzespsZ2DVqtjqxd
         pJ2LsKG8M3CyESnw/7pKswOT1qn16DXVCDp2MgJ7Teic1ohYdnH5ME1GQ/u6GfNPg6j4
         iCiOURebEu3smC7V1GcdaDdzI4n3qyQsphykmNTIhf7LhoFqcI3o/kataSW4yZW2DCs5
         a2weeHlP9XSE8bbR2idStcGIkyg41qcZxYsNAO7qn7howdekg1Au5F2IKPwlU2YTNgek
         pY7Q==
X-Gm-Message-State: AOJu0YxytqNHuGjTrzetbyAjh6KvkxCVq5ryQH0tM0Rlp4YDolBkTeIH
	MYTEmU19sjjinDMWFQZsoDQR2O7t/oPJEmrj2Yi0m+hF3AY0QN1s
X-Google-Smtp-Source: AGHT+IGF2n1dVpiBWBJ2Nwnir/oVdjRpuBbP8g5U6FCGd0rTNvV2FQSnPTF61qFjieLTt51XrpVNeA==
X-Received: by 2002:a05:6a21:6d96:b0:1b5:2fbb:2d84 with SMTP id adf61e73a8af0-1bcf7ee908fmr49833637.28.1719068314173;
        Sat, 22 Jun 2024 07:58:34 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70651194b21sm3184619b3a.68.2024.06.22.07.58.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jun 2024 07:58:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <614d86a1-72c4-489b-94f9-fbe553c25f28@roeck-us.net>
Date: Sat, 22 Jun 2024 07:58:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review [parisc64/C3700 boot
 failures]
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, broonie@kernel.org, Oleg Nesterov <oleg@redhat.com>,
 linux-parisc@vger.kernel.org, Helge Deller <deller@gmx.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240619125556.491243678@linuxfoundation.org>
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
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[ Copying parisc maintainers - maybe they can test on real hardware ]

On 6/19/24 05:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.95 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
> 
...
> Oleg Nesterov <oleg@redhat.com>
>      zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING
> 

I can not explain it, but this patch causes all my parisc64 (C3700)
boot tests to crash. There are lots of memory corruption BUGs such as

[    0.000000] =============================================================================
[    0.000000] BUG kmalloc-96 (Not tainted): Padding overwritten. 0x0000000043411dd0-0x0000000043411f5f @offset=3536

ultimately followed by

[    0.462562] Unaligned handler failed, ret = -14
...
[    0.469160]  IAOQ[0]: idr_alloc_cyclic+0x48/0x118
[    0.469372]  IAOQ[1]: idr_alloc_cyclic+0x54/0x118
[    0.469548]  RP(r2): __kernfs_new_node.constprop.0+0x160/0x420
[    0.469782] Backtrace:
[    0.469928]  [<00000000404af108>] __kernfs_new_node.constprop.0+0x160/0x420
[    0.470285]  [<00000000404b0cac>] kernfs_new_node+0xbc/0x118
[    0.470523]  [<00000000404b158c>] kernfs_create_empty_dir+0x54/0xf0
[    0.470756]  [<00000000404b665c>] sysfs_create_mount_point+0x4c/0xb0
[    0.470996]  [<00000000401181cc>] cgroup_init+0x5b4/0x738
[    0.471213]  [<0000000040102220>] start_kernel+0x1238/0x1308
[    0.471429]  [<0000000040107c90>] start_parisc+0x188/0x1d0
...
[    0.474956] Kernel panic - not syncing: Attempted to kill the idle task!
SeaBIOS wants SYSTEM RESET.

This is with qemu v9.0.1.

Reverting this patch fixes the problem (I tried several times to be sure
since I don't see the connection). I don't see the problem in any other
branch. Bisect log is attached for reference.

Guenter

---
# bad: [a6398e37309000e35cedb5cc328a0f8d00d7d7b9] Linux 6.1.95
# good: [eb44d83053d66372327e69145e8d2fa7400a4991] Linux 6.1.94
git bisect start 'HEAD' 'v6.1.94'
# good: [f17443d52d805c9a7fab5e67a4e8b973626fe1cd] cachefiles: resend an open request if the read request's object is closed
git bisect good f17443d52d805c9a7fab5e67a4e8b973626fe1cd
# good: [cc09e1d3519feab823685f4297853d468f44549d] iio: imu: inv_icm42600: delete unneeded update watermark call
git bisect good cc09e1d3519feab823685f4297853d468f44549d
# good: [b7b6bc60edb2132a569899bcd9ca099a0556c6ee] intel_th: pci: Add Granite Rapids SOC support
git bisect good b7b6bc60edb2132a569899bcd9ca099a0556c6ee
# good: [35e395373ecd14b64da7d54f565927a9368dcf20] mptcp: pm: update add_addr counters after connect
git bisect good 35e395373ecd14b64da7d54f565927a9368dcf20
# good: [29d35f0b53d4bd82ebc37c500a8dd73da61318ff] serial: 8250_dw: fall back to poll if there's no interrupt
git bisect good 29d35f0b53d4bd82ebc37c500a8dd73da61318ff
# good: [ea25a4c0de5700928c7fd0aa789eee39a457ba95] misc: microchip: pci1xxxx: Fix a memory leak in the error handling of gp_aux_bus_probe()
git bisect good ea25a4c0de5700928c7fd0aa789eee39a457ba95
# good: [e44999ec0b49dca9a9a2090c5432d893ea4f8d20] i2c: designware: Fix the functionality flags of the slave-only interface
git bisect good e44999ec0b49dca9a9a2090c5432d893ea4f8d20
# bad: [edd2754a62bee8d97b4808a15de024f66a1ddccf] zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING
git bisect bad edd2754a62bee8d97b4808a15de024f66a1ddccf
# first bad commit: [edd2754a62bee8d97b4808a15de024f66a1ddccf] zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING

