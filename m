Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E81345CAC
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 17:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764955165; cv=none; b=tlX7zmTrhM6sTUM3q9ZCtgiZK3vai1fFSxHZ4eaW1Q1p2cWadkagZFZRDFy+iU2aNAuAyQbO8QPapLfiQ0TcVA0AW6d9+DMuhg07WUJG6Mi4mb1amCePQQUwuU1X5XHdoV+mFuMOG7MRvZQG9nXLNaNUP4/Fp7BZVsUI519+X8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764955165; c=relaxed/simple;
	bh=GUy4lgmzNTqimAcp/167dLFy9s37fVqjG+OaHEDu9GE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kxQympN1BUG4essUOZGPvSukdfF4Q0DoAe4GyBWMTrchy44HWzW2JnKk4H2dfCxm2i6HCsZA2DdyPbnbdXxF2jYsCZ9wbiRbnI4Rf2kqR0ECONpKY5NXkjOUlgemHOvOVqfflApjIq0lMNVn8ab5JngF12aS0OlU0H+zv263uXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TzUaJ+B8; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TzUaJ+B8"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2984dfae0acso43555055ad.0
        for <patches@lists.linux.dev>; Fri, 05 Dec 2025 09:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764955163; x=1765559963; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=JNBw8U9fXF+x4Zv5B932NTv7bbc3u1R8q7X7LGVqL1Q=;
        b=TzUaJ+B8RBwxQl17fOqUfb2LN4CQpiMvlQzP4O0xh05lG8yZ3/+p4DEacSlVy6QOdM
         a/phcETG3jj7NXW3sEdVGLvehJyVARLqMCLVZ3/82gBbUQgL2qB/UOobpanloVwkRs0c
         rJjRnJENj2kE4iylkKy5D4Omxu7Xw2NNIzqLmyKtFIPOYrQAS+3f4Y8tXPJ9a9SmofCx
         qSBCbwaAaNGLkxr7Ez6OPmevHew34ANR7Q5UiWg3G5Uhs59AU9ivpysJxUvDjlX1YCNq
         7eGO4p//Y+v9e++U4vP1STv2M9Nbi4VwrBP3s9Ua4btCEy3mRr7wsaSMNqLA8xQk3u/f
         goEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764955163; x=1765559963;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JNBw8U9fXF+x4Zv5B932NTv7bbc3u1R8q7X7LGVqL1Q=;
        b=uEi30cq3v8AyIlHRfrBHODy/prLoceEK5lolB4t7wl7wnk8Y8SAoilNaj+EIXpEFSk
         x68REVqfKn5d5b06/nbpdXiIiTdvfokN8gZjvFKcdiJ9dqA/XdILgZHy0Bqa4HaD27ss
         cPVuPKUpWOBPKtuXQtkEgPGy+eE20CxVeAnW6FnFerUBGxQr7FSdMOzpOXv/fKQ/1/bw
         +M99AakRzwGOgLjpzksTa3PC1Gw43VsG6wXEqacBJ1LIeUa4kbq0J8WTUmC1LGYnPGvZ
         t3LiSGtRfXrc2Uh3JLQPR197DZatZKm/jMCEffa0jk+lb9qDm0PJ/cecgqG9DEEaq3+l
         evlg==
X-Forwarded-Encrypted: i=1; AJvYcCWk1Mi0W7txd4/gUnNZ2aFvSFGntLRadb6OVfGVQ9MYG7sfgNXg6aRbcIDXj/OjQ5HX4Z3zp36X@lists.linux.dev
X-Gm-Message-State: AOJu0YwrfvH9eDxoB/JJdYC2aV416vFdfsQOcCIYmBy8N7Lp1Gp14gL7
	8lC/kXF6VL6cau0Whr415hm77MrFda8m2ll8o9HU6fXcLbK1EIIVcjCk
X-Gm-Gg: ASbGncuGzFKptEFNt5bE3NFygWaDNjrnaJKZBYcWu/XwQ0LhBBRVyLgySFjYXn3OiPW
	3BI9xOhxon4Pw7ELU8qN885fOQejVKgxDELuPRn9qfFh27s6EBWO4I5h0d9+b5Z6EGR4k0DN7YG
	nhauJdeo+n0hSo9UyUyh7a0PcsQg5Vi3x9+c5yv0LciNhNCkK9xWDhFxrfLi+gW/wVt71dYFbB9
	rMXk4LcWnJOlHqF7jZWTEfrKBhAl+FgB7m9PVTLJakC03SqyN/NyAIiwgAQwRvPLPIkjmR3vaih
	quQ+IgDL0+7iAf3RfoIEYpUCB5wgneT4QPMWK3+aXP/LUS4Zk6ykLoNYrWhyJyNdBsXXhFFjKV3
	NxvXj+6Rkr1f4OHWIzKDTv6XMmA3/8UAQqOZ1eYbmpAf/f2IyHcL4PqW2fCMj71xDtczp7uXyML
	HYLciTbrgId20owe7ApJ7DN4RdyZc6uYGYc0gmrE7RkLhfCcPibg9Nvv0FaKdeubih5ze+rg==
X-Google-Smtp-Source: AGHT+IEGEEOKDcM3oesI1cXALwFuU34StUxDikk7EtYptZyZWAYmttakkvDJIOhwZ3WyHa50FnuXyQ==
X-Received: by 2002:a17:903:124f:b0:27e:ed58:25e5 with SMTP id d9443c01a7336-29da07113e4mr84653075ad.24.1764955162968;
        Fri, 05 Dec 2025 09:19:22 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae99eaa9sm54989465ad.53.2025.12.05.09.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 09:19:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <e107965c-122d-4beb-ad38-9e720306b6cf@roeck-us.net>
Date: Fri, 5 Dec 2025 09:19:20 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/387] 5.15.197-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Nathan Chancellor <nathan@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Dan Carpenter <dan.carpenter@linaro.org>,
 Anders Roxell <anders.roxell@linaro.org>,
 Ben Copeland <benjamin.copeland@linaro.org>
References: <20251204163821.402208337@linuxfoundation.org>
 <CA+G9fYvz4R6SRM0ZZ6xDtnFcHo-RdQkrE3b9WTM0RCgWNiuieQ@mail.gmail.com>
 <2025120553-sulphate-cancel-0f77@gregkh>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <2025120553-sulphate-cancel-0f77@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/25 08:33, Greg Kroah-Hartman wrote:
> On Fri, Dec 05, 2025 at 12:59:37PM +0530, Naresh Kamboju wrote:
>> On Thu, 4 Dec 2025 at 22:14, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> This is the start of the stable review cycle for the 5.15.197 release.
>>> There are 387 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 06 Dec 2025 16:37:24 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc2.gz
>>> or in the git tree and branch at:
>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>>
>> The powerpc allnoconfig failed with gcc-8 but passed with gcc-12.
>>
>> Build regression: powerpc: allnoconfig: gcc-8: Inconsistent kallsyms data
>>
>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>
>> ### Build error Powerpc
>> Inconsistent kallsyms data
>> Try make KALLSYMS_EXTRA_PASS=1 as a workaround
>> make[1]: *** [Makefile:1244: vmlinux] Error 1
>>
>> ### Commit pointing to,
>>    Makefile.compiler: replace cc-ifversion with compiler-specific macros
>>    commit 88b61e3bff93f99712718db785b4aa0c1165f35c upstream.
>>
>> ### Build
>>   - https://storage.tuxsuite.com/public/linaro/lkft/builds/36OCnVeYGpKUCXtxVdz6gezHjcQ/
>>   - https://storage.tuxsuite.com/public/linaro/lkft/builds/36OCnVeYGpKUCXtxVdz6gezHjcQ/config
>>
>> ### Steps to reproduce
>>   - tuxmake --runtime podman --target-arch powerpc --toolchain gcc-8
>> --kconfig allnoconfig
> 
> Odd, this works on 5.10 ok?  What is different about 5.15 that keeps
> this from working?
> 

It is probably just a random error. I used to see this once in a while, though
not recently. Sometimes extra pass(es) are required for kallsyms to stabilize.
Some architectures are more affected than others, and it also depends on the
compiler version since different compiler versions generate different sets of
symbols. In my tests I have KALLSYMS_EXTRA_PASS=1 always enabled for alpha,
arm, and m68k. I used to have it enabled for powerpc as well, but not anymore
(if I recall correctly I stopped to see the problem there when I switched to
gcc 10).

I even submitted a patch to fix the problem several years ago, but it was
rejected.

Guenter

