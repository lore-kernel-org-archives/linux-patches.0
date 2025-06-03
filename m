Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C32E22D9F3
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 16:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748966464; cv=none; b=koHORVjJ+4Rgt4mhj0JDHLWjaH5dHr3H5jWhnZKtkT9ZqSOocdL3pX1pX8HiRFD8tTcEcUE4cApQygRHDhjPlxk3de7SYLONCAA+Kg3Nt70yCP0FJH7WQUtsP72Fqjev4VKS7JAdkyFPO8T/j0IrF6/EvWDWbpdqJgJSeEzAZR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748966464; c=relaxed/simple;
	bh=ZVoYbU3pUfM0RpcnSPakC4wWN5k+VVWnBDElT6WsJJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bNs4flHCfaveDpad/loD9SBSiwvyEL5sKdX6tmsnqqkyPS3Zs/eIn1SC+BdxL9fml97bzK4Bk0rubcIBMLPpqG8MTOu80bnV1ZMi2yB20vZTQRdNZV65LCHPfwlXQdlpHq3WAtE14ODTOkBJmAJyY3pQf7YnuL90iYvF/TrXzsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YV/kA9A2; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YV/kA9A2"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7425bd5a83aso4439234b3a.0
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 09:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748966462; x=1749571262; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BsXZQ/uyRY+qTVpEgGFJZCGzcexP2bgbyKWMgllZm/A=;
        b=YV/kA9A2xGmhssTdHXgRlz/1VybIG8QE09sg0/DBplo0859AGIlMw7/FG2sCQRtw9M
         SkEqyl1s8PeA4nwExxjDbWSZ/AxstJfji1Mr9bVe3PP/335+tuRwxVPfFCG4WFQSb4WB
         GQyy7HtD/bOviRMmHa1N/5HRt7YDpn+eCInMX8VdPhbX9pQy7PIFQD5ieJUf0ESyzcmc
         gPNg9Jlkis3lM7uZh6b8QuSUX0dYDS29mF+kcUyO3fiaeY0eYW3/D3cqIyQCgFgWP06o
         gU8LsiGMFUd8AW+KkMiVlfo9LnrEQkZeLAf+gyfORNQvLN/rsgDMx1nIxBUWfNMhuU+R
         smzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748966462; x=1749571262;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BsXZQ/uyRY+qTVpEgGFJZCGzcexP2bgbyKWMgllZm/A=;
        b=wXJKAl/UMf4CAuXm6E40KyhBk+Utmhw/ZtgvrGGtDaanpDkwaP3TO8DiCrwnk2PMOp
         kifZHq+E3XJ8hK+pMcTBlcm8n+XP4Tk6a+D55MBYep2kc4mGzMrFIcgUmhKqy1ApPvDa
         5mlxkFXJyUkY4kfu2clnCEE45mCw1/gRiZPptrLuvIwzNw+n13HXb8BlhTP/V4A36SQ4
         LLu9XhH5SCJFFikuUXAIbcHzIsVRyykytrnNHXiRLQ8JJZmByWO5Zr/PlJK5HsghtFcl
         aKJv0k9x/Rf2E7QCU/tCHthBkRB3ifUjFQcLjkjQkWoWiRq3hJIHID3fkd8OyB0H1wQB
         zyaA==
X-Forwarded-Encrypted: i=1; AJvYcCVz/65gzn1NMraI3/FfXfz8Dr8UWtzTyLuizVbnOhfFXjCPsv3cPtrwGcCHwq5r7zKx42FjjMI2@lists.linux.dev
X-Gm-Message-State: AOJu0Yxi1yoNcTFOAsl5qopl2ln2ErYbUzvb3blgjp28hnMeMNkR/1Bj
	3rY1vLcruXc1+lIm2aREt1FTJocnF6oCyTQSWRyN8F9o6BaMISfdFltZJYGAqArx
X-Gm-Gg: ASbGncsCJ5OPg3oiKibMeCoXtclhaNLoswiAjsgyu+T6oO1yWScNfeq5aCXDpyJ6DfK
	Xxak8VG+qMed/Umi+jmdMtIXuCknELZzS5a9fdOmMt6S6lHW3A66RAtT1aaMuEv/0O2a7z93wqp
	oOeDQAVzElf4LkQrdou0LUYJ0ZzpjhcV4RXqTPCLAui5jjJTk6vbUGMKbWIaD9hDpAZJdajREPH
	9bzwNTJ2L5E4Rsi9I+Z1C29PlLLyR31Knhtnn7uLYy6mUnUj6m1ppq5o1m81KOMLUVAFyLuVa+f
	2oMLnSrljloAA6AZfndkATv7bqgVP13yShI6AThFEH6U28o2nug503GdpUc9jXQKnD1w1qjuwj3
	W7Pc=
X-Google-Smtp-Source: AGHT+IEeh8MaQQrJVyQuQPlgts4cAcQISPbKUr8e3jCFPU5I/LAIGT3xID1897d3eJde7cnMp3B/fg==
X-Received: by 2002:a05:6a20:e607:b0:1fe:5921:44f2 with SMTP id adf61e73a8af0-21ba11fb422mr17620215637.20.1748966460631;
        Tue, 03 Jun 2025 09:01:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-747affcf9ffsm9875523b3a.135.2025.06.03.09.00.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 09:01:00 -0700 (PDT)
Message-ID: <b60e753c-eb13-46af-9365-1b33ae2e7859@gmail.com>
Date: Tue, 3 Jun 2025 09:00:58 -0700
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
In-Reply-To: <2025060344-kiwi-anagram-fc9e@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/3/25 00:58, Greg Kroah-Hartman wrote:
> On Mon, Jun 02, 2025 at 09:50:24AM -0700, Florian Fainelli wrote:
>> On 6/2/25 09:49, Florian Fainelli wrote:
>>> On 6/2/25 06:44, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.10.238 release.
>>>> There are 270 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>      https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/
>>>> patch-5.10.238-rc1.gz
>>>> or in the git tree and branch at:
>>>>      git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
>>>> rc.git linux-5.10.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on
>>> BMIPS_GENERIC:
>>>
>>> Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
>>>
>>> Similar build warning as reported for 5.4, due to the same commit:
>>>
>>> commit b47e6abc7dc5772ecb45383d9956f9fcb7fdf33c
>>> Author: Jeongjun Park <aha310510@gmail.com>
>>> Date:   Tue Apr 22 20:30:25 2025 +0900
>>>
>>>       tracing: Fix oob write in trace_seq_to_buffer()
>>>
>>>       commit f5178c41bb43444a6008150fe6094497135d07cb upstream.
>>>
>>> In file included from ./include/linux/kernel.h:15,
>>>                    from ./include/asm-generic/bug.h:20,
>>>                    from ./arch/arm/include/asm/bug.h:60,
>>>                    from ./include/linux/bug.h:5,
>>>                    from ./include/linux/mmdebug.h:5,
>>>                    from ./include/linux/mm.h:9,
>>>                    from ./include/linux/ring_buffer.h:5,
>>>                    from kernel/trace/trace.c:15:
>>> kernel/trace/trace.c: In function 'tracing_splice_read_pipe':
>>> ./include/linux/minmax.h:20:35: warning: comparison of distinct pointer
>>> types lacks a cast
>>>      20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>>>         |                                   ^~
>>> ./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
>>>      26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>>>         |                  ^~~~~~~~~~~
>>> ./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
>>>      36 |         __builtin_choose_expr(__safe_cmp(x, y), \
>>>         |                               ^~~~~~~~~~
>>> ./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
>>>      45 | #define min(x, y)       __careful_cmp(x, y, <)
>>>         |                         ^~~~~~~~~~~~~
>>> kernel/trace/trace.c:6688:43: note: in expansion of macro 'min'
>>>    6688 | min((size_t)trace_seq_used(&iter->seq),
>>>         |                                           ^~~
>>>
>>
>> And also this one:
>>
>> commit e0a3a33cecd3ce2fde1de4ff0e223dc1db484a8d
>> Author: Eric Dumazet <edumazet@google.com>
>> Date:   Wed Mar 5 13:05:50 2025 +0000
>>
>>      tcp: bring back NUMA dispersion in inet_ehash_locks_alloc()
>>
>>      [ Upstream commit f8ece40786c9342249aa0a1b55e148ee23b2a746 ]
>>
>>
>> on ARM64:
>>
>> In file included from ./include/linux/kernel.h:15,
>>                   from ./include/linux/list.h:9,
>>                   from ./include/linux/module.h:12,
>>                   from net/ipv4/inet_hashtables.c:12:
>> net/ipv4/inet_hashtables.c: In function 'inet_ehash_locks_alloc':
>> ./include/linux/minmax.h:20:35: warning: comparison of distinct pointer
>> types lacks a cast
>>     20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>>        |                                   ^~
>> ./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
>>     26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>>        |                  ^~~~~~~~~~~
>> ./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
>>     36 |         __builtin_choose_expr(__safe_cmp(x, y), \
>>        |                               ^~~~~~~~~~
>> ./include/linux/minmax.h:52:25: note: in expansion of macro '__careful_cmp'
>>     52 | #define max(x, y)       __careful_cmp(x, y, >)
>>        |                         ^~~~~~~~~~~~~
>> net/ipv4/inet_hashtables.c:946:19: note: in expansion of macro 'max'
>>    946 |         nblocks = max(nblocks, num_online_nodes() * PAGE_SIZE /
>> locksz);
>>        |                   ^~~
>>
> 
> For both of these, I'll just let them be as they are ok, it's just the
> mess of our min/max macro unwinding causes these issues.
> 
> Unless they really bother someone, and in that case, a patch to add the
> correct type to the backport to make the noise go away would be greatly
> appreciated.

Yeah that's a reasonable resolution, I will try to track down the 
missing patches for minmax.h so we are warning free for the stable kernels.

Thanks
-- 
Florian
