Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CA4186E46
	for <patches@lists.linux.dev>; Sun, 15 Dec 2024 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734276285; cv=none; b=etDRz5KMxGnj9ViXv9HufxGLilP268wCtALkxoEUPKNWFuHgknZQOhkql+vDFyMyyFCAz+ADgr4A52gZi7EdiXgF3INR2Ef9kbrg8XFj4zrMf66dXdO7NqD7lIPev0n66hdvTXKQgSu9NcDxvvcdNVeqkyhD7NH125Yu/rfqlZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734276285; c=relaxed/simple;
	bh=uJwSVTELTC1sTrqowQm2wbj8CLUErNT/UwouAw0vAQo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jE0Y1HUTvE4oDA57wDjRSnOQS/YGj48oK0sDv/HxOgGhHqF6NzAsLdoxSNMWWFt395/wzcZXsI5qX4NRHfbrPKkFatYNso2xzjaoTK5RTU7W//GHQfCSHgIOGVtto1B1rSXIYWXzsMfV2N2OUBqJAuu041cr+RkSyIiHI3NEk6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xt0GcLIR; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xt0GcLIR"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2165cb60719so24480035ad.0
        for <patches@lists.linux.dev>; Sun, 15 Dec 2024 07:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734276283; x=1734881083; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=l7GkpgTNsSY/87wFOQW4jbUwJHQNpW/KOST5BhXKZpE=;
        b=Xt0GcLIRmScQX0IE6lkPusiNnY5JTWzK0fRjdORw7bc2pGKyxwD0QI2Jo38UWzDspH
         Wv6kpk3yk7CvCYz7aEfmrRfPNi4cfdqU8kGF60FBuhvjHWCRx1v4K/1X6ggh+gekC6os
         VpODl2k0nhwZ3RlfVjqg/6omr705gdQXeK6TzyEearSVL73g5QCKrXDL+Y7m+LOts3bR
         DRPFXxyHoIz0Fw+V2owzRWfGZoQgM+GMEy5QOcfquA9O0HfAdLfwrbvsETCJvFD9Oj8l
         15FYv4WxJAU02tEpypEEQDy48pmQevjq+MtMA3u6DlnwdCo87YCjkrO9fUJJGA4iUVoz
         PeWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734276283; x=1734881083;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7GkpgTNsSY/87wFOQW4jbUwJHQNpW/KOST5BhXKZpE=;
        b=TuUCq6mmxRWzvVzv5LgS3Sv3emrJub9mjL0pt93gST9rvpeB7F7w4Z+C4XpBT35TE4
         zbIYF+z4w4n0FOMd8vYUna9+kWqNcuPMBCmD+V6XGJw7GlVgN4POp3JOA1DQWI6UWPP+
         jS847ByvW1ctAeLBf07N3Nb0EZDauYPKWP47TKBWMGuRU2zEZzkrHGV0AuZDtgpQpGJ9
         QQugGcGogcmXKpYuUpbyo4jOjFvEGwR5u1HovMeIgxiY/lk1PLG6KDFi+Mgh8fC2cnfh
         2Ju3r4jKcBHUS0ZcLuqXBW0ciCC9EThhnmGJqe38sFdw579Q1Q7MCKV/+v/uCjUc7O+a
         WOwg==
X-Gm-Message-State: AOJu0Yyt77VNxxkHmElCaUp6YOTMumIUC6wL1UZ0pUJVoTxD8izDeSvp
	m2KdVddMcd27UUJlxrkfPrNZivO6h/XK8G/PNEkBLxDNBGHiJdTU
X-Gm-Gg: ASbGncs4XE770MVHr+rIvJVYOONn5AvyMLMCvsdProUdc0/f1T9ZZHUajatT7IYOLPV
	ZXW/YKuIwJ4Or0Bpz/qIujpdGW5EBIFVxg7EEsyYlUUSHFhzmI5wJjvT+WZm65F1StJ6xlQprwi
	MOAvwkKYu3PZ8urIfsN8tCgLzgvCU/fB2tOS4djYsPe/+jwv7HdU+aC1i4dCXM0DlysnOSgUZ+x
	MEVBq6DhRnzq3kyi3VsUY+ZYLMlHAJ9407c4NKDz++VIR8RgS1cTJKZzpYvyXKHC+xdfFGtxvb2
	YXQRdplBjFcVv5AznkFSruwCQHyB+w==
X-Google-Smtp-Source: AGHT+IHawsBInKi/8r40Bxr6xWE+mGyOQXeKK3ifPyHgYRS9y5pkqF8bcHuEH078fuYQM4bIWj1bew==
X-Received: by 2002:a17:903:32cf:b0:215:b9a7:5282 with SMTP id d9443c01a7336-218929c3a18mr135670195ad.26.1734276283392;
        Sun, 15 Dec 2024 07:24:43 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1e50250sm26774675ad.122.2024.12.15.07.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Dec 2024 07:24:42 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <436a575b-4ec0-43a2-b4e9-7eb00d9bbbeb@roeck-us.net>
Date: Sun, 15 Dec 2024 07:24:40 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/565] 5.15.174-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
References: <20241212144311.432886635@linuxfoundation.org>
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
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 06:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.174 release.
> There are 565 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 

All parisc builds fail.

In file included from include/linux/pci-dma-compat.h:8,
                  from include/linux/pci.h:2477:
include/linux/dma-mapping.h:546:47: error: macro "cache_line_size" passed 1 arguments, but takes just 0
   546 | static inline int dma_get_cache_alignment(void)
       |                                               ^
arch/parisc/include/asm/cache.h:31: note: macro "cache_line_size" defined here
    31 | #define cache_line_size()       dcache_stride
       |
include/linux/dma-mapping.h:547:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   547 | {

There are also lots of warnings.

./include/linux/slab.h:208: warning: "ARCH_KMALLOC_MINALIGN" redefined
   208 | #define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN

./arch/parisc/include/asm/cache.h:28: note: this is the location of the previous definition
    28 | #define ARCH_KMALLOC_MINALIGN   16      /* ldcw requires 16-byte alignment */

Bisect log attached. Reverting the offending patch fixes the build error and the warnings.

Guenter

---
# bad: [963e654022cc32d72c184b4ab86a76226b3e3b8d] Linux 5.15.174
# good: [0a51d2d4527b43c5e467ffa6897deefeaf499358] Linux 5.15.173
git bisect start 'HEAD' 'v5.15.173'
# good: [16aa78edf6dd33d13320a0802322cade7a9e587b] net: hsr: fix hsr_init_sk() vs network/transport headers.
git bisect good 16aa78edf6dd33d13320a0802322cade7a9e587b
# bad: [c20f91bd939553be347196ecf4ab7b69dff19193] ethtool: Fix wrong mod state in case of verbose and no_mask bitset
git bisect bad c20f91bd939553be347196ecf4ab7b69dff19193
# bad: [f5872a2a84ec889d0a8f264d3ed0936670860479] rpmsg: glink: Propagate TX failures in intentless mode as well
git bisect bad f5872a2a84ec889d0a8f264d3ed0936670860479
# bad: [1d1e618c170643dfb07ebd1f6cab64278bfa06eb] exfat: fix uninit-value in __exfat_get_dentry_set
git bisect bad 1d1e618c170643dfb07ebd1f6cab64278bfa06eb
# bad: [13327d78229f954995a8535b369d4aa7f1d721dc] Revert "drivers: clk: zynqmp: update divider round rate logic"
git bisect bad 13327d78229f954995a8535b369d4aa7f1d721dc
# good: [098480edee1b64b6e811e0bf101b32cd11e71582] misc: apds990x: Fix missing pm_runtime_disable()
git bisect good 098480edee1b64b6e811e0bf101b32cd11e71582
# bad: [dadac97f066a67334268132c1e2d0fd599fbcbec] parisc: fix a possible DMA corruption
git bisect bad dadac97f066a67334268132c1e2d0fd599fbcbec
# good: [3c7355690f375bcfa3639aea7daa801789a85532] ALSA: hda/realtek: Update ALC256 depop procedure
git bisect good 3c7355690f375bcfa3639aea7daa801789a85532
# good: [487b128f07b82294bd0847c2c462dfcf1de9660a] apparmor: fix 'Do simple duplicate message elimination'
git bisect good 487b128f07b82294bd0847c2c462dfcf1de9660a
# first bad commit: [dadac97f066a67334268132c1e2d0fd599fbcbec] parisc: fix a possible DMA corruption

