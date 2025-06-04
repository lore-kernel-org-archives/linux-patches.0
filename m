Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2333F171A1
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 18:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749061792; cv=none; b=fBWc9jOAhBLT2yTSzz8XHhS4U0ewd2vLnEjHN0l4DcBOFzsl6mM2qvFRlZjjnR8SBwvcfIo1HfyzpyQIjVSKtR0PZDi1AX50cXTx1AlN9MroWDLpt+wsBE6raHvT5NqNcyN9ec6RuJLKlOtjBZ0bIi3+eVXypCJ+jW6wd2tSKSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749061792; c=relaxed/simple;
	bh=PXhhNODjG+cNsHNAcTpDxpcRWqKbXa6CHcvSPuhg5MM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HJnwdvF1+kwHfITGOFHtsHv4j3WdDR/vVcZ/lpLk9WksQ3zK+Z3A/r5YmVu6JkB5D0l2p10lePY9dd4MW+zRNAb1OrqNvUEDrv3/jWwkhrvlTNl7iG/MKbK8zPJBaEb3lIME8w2Pgajx4bwkpuT2PVZaJibKRKzGCB/anZ/nWrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=djDjNIvJ; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="djDjNIvJ"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-306b6ae4fb2so188556a91.3
        for <patches@lists.linux.dev>; Wed, 04 Jun 2025 11:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749061790; x=1749666590; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qBOjMHTgyBfthw0tiIniALs2SFPGVC9Hhjqg9y5VsQU=;
        b=djDjNIvJ3H7P7+UU5w9p2VUAshbkJ/FP9Ksyb9kbRDFp6h+P6afSOdddJHjFZLZkvA
         EhfvNhRip56ksDnIH4C53gG69JRuXV8Oe4v6NWrvckwC/LF0S7JFpTBpAYzQIuJL0Y0G
         0fMpNkdo8GLYZ8OxJvIHugR87jL+mZAWDFyo8wwyC2IIA4I5yFEf2gCbK89q9pmaWMAA
         /DbfyC0k8tLQu+BD/RJpGb96s5iiAwyoGTIISPuNTTAU/OqChjRCKcgtrDdR/dufiYPo
         3Ze4QU/W5wZtL4cP/FbISNB6wAefEIyezn/pIjvS2SSgjqLENZ0+RSxr+4MsucdcE22N
         rUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749061790; x=1749666590;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qBOjMHTgyBfthw0tiIniALs2SFPGVC9Hhjqg9y5VsQU=;
        b=W8co4umWlSFE3Gp6SFDUTjhjgokKxbl8iP/Y3LM+b/XdCQ4mLrBNDo+4ci+R2UNTZ2
         r9uaKetUj/8AOYIdQnvmV0/t55pZ3tA9ThBdVfdji8XFgjr8ybLTO3KKjAlWYWNQpKdO
         NUl/NQNglEPiTNavVSdh8HkxfRCRPmdD/vv2vHtt6G60JwNs/XrqaXJAbsUWVacliTNG
         ABIXeCfgBL/QjmiRlxGnT9okm94zud2c5tT0qN14kMVZZ9afHtifZis1PcAo5Z9kbCMc
         ua/ZCnoeePLKAPX2tv4DLVzKy5n8tmGraivYJMjn8GKyv4G2xv7K/yG73jmp9t+WWYcx
         tC3w==
X-Forwarded-Encrypted: i=1; AJvYcCXW5pKrmaorcJZJyseyFL01joVzuMH/82lCo2N6eH1PLFHxG36I+aMUYMaiToEmMA1XQYU3V0Jg@lists.linux.dev
X-Gm-Message-State: AOJu0YyTWER7uTVmeAMwANXtwTfmMmT1bgir6/urvekRrDCPXesVJtwU
	n64guQsU8VCPdnrA+bY0AhoPyyk5kCKPJNcgrjJiTIaZ5judEEQRWghX9fXcwaJA
X-Gm-Gg: ASbGncth2JXELMp1qb6pGW73FR7uRoZLSGeKzIqP04+UbMVUG3M3YTwjuhjoqRIMFRM
	DOhesd0gYVS8eWDzx3DFsBBOFjH8AvDL1D4EeolFsAL92ACqbKqZNoYUQsxa3o2+bGkxZRdhlqp
	PlCrrJVAFZmSsURY7WDc+xAbd0KyOWQDLZnVijecvvqufHgIzBlPzYZd4bJoYvPRpvQG0+hzc0n
	hz1iVX0Fm0QvQrJMJTu8sJawTGnP8LmhwMG71pZ2NwLxf9AoM6xkNqG1DytkR2BbJKqAl7BiwtX
	j45+8RKqRO6mgaNlcztpiwtTmfKY9WELKIJ96IRxCH5R4wH3BqWujij5mCy2O/i/w63XtEcj5mN
	ez6Y=
X-Google-Smtp-Source: AGHT+IHgXXIILR3WmLPSIeFXhuYxVqOuCyJSD5UAr00UNN9VGJr7ID5l5RzwQwieEltc73vttdrpPg==
X-Received: by 2002:a17:90b:3d07:b0:312:def0:e2dc with SMTP id 98e67ed59e1d1-3130ccf6f89mr5559806a91.7.1749061790274;
        Wed, 04 Jun 2025 11:29:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506cf53a9sm106955545ad.196.2025.06.04.11.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 11:29:49 -0700 (PDT)
Message-ID: <630fc4c2-dacb-45c8-9cca-0b843365b212@gmail.com>
Date: Wed, 4 Jun 2025 11:29:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/270] 5.10.238-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134307.195171844@linuxfoundation.org>
 <4c608184-5a64-4814-a70a-d2395662d437@gmail.com>
 <52e321d9-2695-4677-b8bf-4be99fc0d681@gmail.com>
 <2025060344-kiwi-anagram-fc9e@gregkh>
 <b60e753c-eb13-46af-9365-1b33ae2e7859@gmail.com>
 <2025060412-cursor-navigate-126d@gregkh>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <2025060412-cursor-navigate-126d@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/4/25 01:06, Greg Kroah-Hartman wrote:
> On Tue, Jun 03, 2025 at 09:00:58AM -0700, Florian Fainelli wrote:
>> On 6/3/25 00:58, Greg Kroah-Hartman wrote:
>>> On Mon, Jun 02, 2025 at 09:50:24AM -0700, Florian Fainelli wrote:
>>>> On 6/2/25 09:49, Florian Fainelli wrote:
>>>>> On 6/2/25 06:44, Greg Kroah-Hartman wrote:
>>>>>> This is the start of the stable review cycle for the 5.10.238 release.
>>>>>> There are 270 patches in this series, all will be posted as a response
>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>> let me know.
>>>>>>
>>>>>> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
>>>>>> Anything received after that time might be too late.
>>>>>>
>>>>>> The whole patch series can be found in one patch at:
>>>>>>       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/
>>>>>> patch-5.10.238-rc1.gz
>>>>>> or in the git tree and branch at:
>>>>>>       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
>>>>>> rc.git linux-5.10.y
>>>>>> and the diffstat can be found below.
>>>>>>
>>>>>> thanks,
>>>>>>
>>>>>> greg k-h
>>>>>
>>>>> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on
>>>>> BMIPS_GENERIC:
>>>>>
>>>>> Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
>>>>>
>>>>> Similar build warning as reported for 5.4, due to the same commit:
>>>>>
>>>>> commit b47e6abc7dc5772ecb45383d9956f9fcb7fdf33c
>>>>> Author: Jeongjun Park <aha310510@gmail.com>
>>>>> Date:   Tue Apr 22 20:30:25 2025 +0900
>>>>>
>>>>>        tracing: Fix oob write in trace_seq_to_buffer()
>>>>>
>>>>>        commit f5178c41bb43444a6008150fe6094497135d07cb upstream.
>>>>>
>>>>> In file included from ./include/linux/kernel.h:15,
>>>>>                     from ./include/asm-generic/bug.h:20,
>>>>>                     from ./arch/arm/include/asm/bug.h:60,
>>>>>                     from ./include/linux/bug.h:5,
>>>>>                     from ./include/linux/mmdebug.h:5,
>>>>>                     from ./include/linux/mm.h:9,
>>>>>                     from ./include/linux/ring_buffer.h:5,
>>>>>                     from kernel/trace/trace.c:15:
>>>>> kernel/trace/trace.c: In function 'tracing_splice_read_pipe':
>>>>> ./include/linux/minmax.h:20:35: warning: comparison of distinct pointer
>>>>> types lacks a cast
>>>>>       20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>>>>>          |                                   ^~
>>>>> ./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
>>>>>       26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>>>>>          |                  ^~~~~~~~~~~
>>>>> ./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
>>>>>       36 |         __builtin_choose_expr(__safe_cmp(x, y), \
>>>>>          |                               ^~~~~~~~~~
>>>>> ./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
>>>>>       45 | #define min(x, y)       __careful_cmp(x, y, <)
>>>>>          |                         ^~~~~~~~~~~~~
>>>>> kernel/trace/trace.c:6688:43: note: in expansion of macro 'min'
>>>>>     6688 | min((size_t)trace_seq_used(&iter->seq),
>>>>>          |                                           ^~~
>>>>>
>>>>
>>>> And also this one:
>>>>
>>>> commit e0a3a33cecd3ce2fde1de4ff0e223dc1db484a8d
>>>> Author: Eric Dumazet <edumazet@google.com>
>>>> Date:   Wed Mar 5 13:05:50 2025 +0000
>>>>
>>>>       tcp: bring back NUMA dispersion in inet_ehash_locks_alloc()
>>>>
>>>>       [ Upstream commit f8ece40786c9342249aa0a1b55e148ee23b2a746 ]
>>>>
>>>>
>>>> on ARM64:
>>>>
>>>> In file included from ./include/linux/kernel.h:15,
>>>>                    from ./include/linux/list.h:9,
>>>>                    from ./include/linux/module.h:12,
>>>>                    from net/ipv4/inet_hashtables.c:12:
>>>> net/ipv4/inet_hashtables.c: In function 'inet_ehash_locks_alloc':
>>>> ./include/linux/minmax.h:20:35: warning: comparison of distinct pointer
>>>> types lacks a cast
>>>>      20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>>>>         |                                   ^~
>>>> ./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
>>>>      26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>>>>         |                  ^~~~~~~~~~~
>>>> ./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
>>>>      36 |         __builtin_choose_expr(__safe_cmp(x, y), \
>>>>         |                               ^~~~~~~~~~
>>>> ./include/linux/minmax.h:52:25: note: in expansion of macro '__careful_cmp'
>>>>      52 | #define max(x, y)       __careful_cmp(x, y, >)
>>>>         |                         ^~~~~~~~~~~~~
>>>> net/ipv4/inet_hashtables.c:946:19: note: in expansion of macro 'max'
>>>>     946 |         nblocks = max(nblocks, num_online_nodes() * PAGE_SIZE /
>>>> locksz);
>>>>         |                   ^~~
>>>>
>>>
>>> For both of these, I'll just let them be as they are ok, it's just the
>>> mess of our min/max macro unwinding causes these issues.
>>>
>>> Unless they really bother someone, and in that case, a patch to add the
>>> correct type to the backport to make the noise go away would be greatly
>>> appreciated.
>>
>> Yeah that's a reasonable resolution, I will try to track down the missing
>> patches for minmax.h so we are warning free for the stable kernels.
> 
> I tried in the past, it's non-trivial.  What would be easier is to just
> properly cast the variables in the places where this warning is showing
> up to get rid of that warning.  We've done that in some backports in the
> past as well.
> 
> good luck!

I see now that in 5.4.295-rc1 you have backported:

commit 36d6c6cd65043d553126b934bf1fcb79dcb58499
Author: Pan Taixi <pantaixi@huaweicloud.com>
Date:   Mon May 26 09:37:31 2025 +0800

     tracing: Fix compilation warning on arm32

     commit 2fbdb6d8e03b70668c0876e635506540ae92ab05 upstream.


which takes care of resolving the warning, thanks!
-- 
Florian
