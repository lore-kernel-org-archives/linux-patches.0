Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3C22D5C95
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 18:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764959474; cv=none; b=XyOFLRxYxVUqKFwL+5I+TY3e4sfPSvDmCBWTHL1Zk+vELu+uTuXHWYKArDpfJAlj/6LNFM1LuG8NHjDysSjckly3Q0cP1S4+eaVgfd7eFxVz7Fsona/LdFrY3FVbhvua+/ApetPXJ8/WO505L2mVkCPBpw2c5kLvigvAkMuK+I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764959474; c=relaxed/simple;
	bh=LCY3koqg2u7jowBM5k33ePRJWePYoAlDRvP/RuvXPhc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jJInMWiX1SlluQISqKBK3TZLqWQ1zdDNyrYIzB2Bl543Kz0bzJx4xHTsfFMYJI9g7p4NUKSODKdAca5Snx+yQNvFXeUNtLY0ElB3MkOte9hMEdbbEMEJSwupCOkPk7Mg0mf3MVZm52l5F4Y+CUy5tJ8eT/2CA1eKDd+ch/Cq2WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SkX7P/5j; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SkX7P/5j"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-343f52d15efso2233588a91.3
        for <patches@lists.linux.dev>; Fri, 05 Dec 2025 10:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764959472; x=1765564272; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=IgRj/IQDtMSmr2ovjaWEc5HS9CyqexEqyPnjpiwmnyo=;
        b=SkX7P/5jhhddY362XfnouigIuJT0L8DHTw9L3V819fFiWk0qLilSEnLqocahHtEhM3
         m/h+FKvFOkQZuYpO+vbz3Q15+uV+hEvXHzwjANVyZo9mr6YkgDGZ/pC9u3PT8dBcVxU1
         qg5xSbHpUN5fggD6VerKCej6Ecz7/pTXaz8PsQ0rxoMs9ABkAcAy+r8D8sTdZnc46I1t
         GAokHCbeGEGIJFUHoII/vXQKB3MeT6RSPeLfRb+k0/B7s9l5Jx9E/xvOXZianK+Qft8a
         TuKxE04nS8kDdqfuXtfZxb1VMrWEcRLc6FJnKHYwltIk5wSrMsJOhnqIZ7R4MY+Eegwi
         ORHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959472; x=1765564272;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IgRj/IQDtMSmr2ovjaWEc5HS9CyqexEqyPnjpiwmnyo=;
        b=QBmEhrwGEe0yzkUBWGRvZqQNlr+RJ4hhHbXLKfTO34Xpz9yWacJvX0ngZDx0LHXa17
         B0zgZkGVt29nOWrw+mrTnWrGkk5NXyu9moImJFMMRRbh8cyYr9cE7hgEM2CD9jBotdl1
         jr7F5aoT5c8UMebIqysFZIyZrWNEwnqCIAfxTk1Jyrb9ckjMKl7kVJskBDYZExOL1EbB
         ih81RUR/MXbaICC0FZqTQItVjJ+JVWSOVW17evdNisXSZd7f9dYChYZTP6AP2fgnpBMK
         rupy9PDCtwrUSZ8aOZDShLcEVSaYIXHy5xiUi8nkIu5ew0knxXoV+bBuern+c09l6qeh
         Bo1w==
X-Forwarded-Encrypted: i=1; AJvYcCUkmQT+goPfAeijcBX4U3QT4YVWniz3ZIYQd87oCyMZsZnWeOFUFbYPu/HSHRzqGs1WxOs7QOfR@lists.linux.dev
X-Gm-Message-State: AOJu0YwFLssfg0wi2Z4gU7d0cJCjWMuWr5OfPxmsogN6v3Fr1M1qLHIX
	KhdH+1Gi7OXkh5cT7K+6Whvcqfinv4QwMECs1Tv9wsm8dQyar+OEtYH3
X-Gm-Gg: ASbGncuMX73TEoKz6ZiQv2pnB++IAZvWhezz57RN5wpINJUbIjWxW0cqxoy0mx6PAGW
	Nwl/QVcKo4HQy0ZwZLqj/pLTasZNVQFVTLGlj+pc15j5bmp46ihiZY89trjg7CKxjM3UoCoUEvW
	qic9A1Stb/PHlVklow0wrJDtq0ylThIRN8Vxh6NXEjeeu5Sylv+hvprIi5Q8GfgetRS9qaA756n
	UgIo/BwGDHOGXefAJJ6Nsydt1tpIA1YbIxFsgc7wnapgb1B7PSoZVyHVlANhuYyK1pm5q1Jea1r
	ko4LmzvipqROT1bnXdoB1HVVqhRD29W7JQtlsojZVB+I7hxHB1beywWrey3ZGIxTdAZSohUL/FS
	xw/FdpLNFIFMbzX3BiAV2QgonOTHIPxBynQs4v/1hj15EDU0ar9V3sScYIr3OjpNvbWZWcWaWmM
	tPqk7Wvzt253O6Oiy2x19GIIIA1eWfpgdkgUokBcUaeo2mnFMQsT8N1eD+JeIsdBIXIULwKA==
X-Google-Smtp-Source: AGHT+IGlyMD+eZf71lYXG/sxk4oLsZRo4oayCLBVN3LTZ61M2cjddDqa6AtbMXtdKuTM2Am+cZqDMA==
X-Received: by 2002:a17:90b:3c0e:b0:340:a5b2:c305 with SMTP id 98e67ed59e1d1-349a24d9203mr38527a91.2.1764959471719;
        Fri, 05 Dec 2025 10:31:11 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3494e84f446sm5348048a91.5.2025.12.05.10.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 10:31:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <ca278e55-1691-45a7-9c67-b810eacb916d@roeck-us.net>
Date: Fri, 5 Dec 2025 10:31:08 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/387] 5.15.197-rc2 review
To: Nathan Chancellor <nathan@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>,
 Anders Roxell <anders.roxell@linaro.org>,
 Ben Copeland <benjamin.copeland@linaro.org>
References: <20251204163821.402208337@linuxfoundation.org>
 <CA+G9fYvz4R6SRM0ZZ6xDtnFcHo-RdQkrE3b9WTM0RCgWNiuieQ@mail.gmail.com>
 <2025120553-sulphate-cancel-0f77@gregkh> <20251205173947.GA2484770@ax162>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20251205173947.GA2484770@ax162>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/25 09:39, Nathan Chancellor wrote:
> On Fri, Dec 05, 2025 at 05:33:19PM +0100, Greg Kroah-Hartman wrote:
>> On Fri, Dec 05, 2025 at 12:59:37PM +0530, Naresh Kamboju wrote:
>>> On Thu, 4 Dec 2025 at 22:14, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> This is the start of the stable review cycle for the 5.15.197 release.
>>>> There are 387 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Sat, 06 Dec 2025 16:37:24 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc2.gz
>>>> or in the git tree and branch at:
>>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>>
>>> The powerpc allnoconfig failed with gcc-8 but passed with gcc-12.
>>>
>>> Build regression: powerpc: allnoconfig: gcc-8: Inconsistent kallsyms data
>>>
>>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>>
>>> ### Build error Powerpc
>>> Inconsistent kallsyms data
>>> Try make KALLSYMS_EXTRA_PASS=1 as a workaround
>>> make[1]: *** [Makefile:1244: vmlinux] Error 1
>>>
>>> ### Commit pointing to,
>>>    Makefile.compiler: replace cc-ifversion with compiler-specific macros
>>>    commit 88b61e3bff93f99712718db785b4aa0c1165f35c upstream.
>>>
>>> ### Build
>>>   - https://storage.tuxsuite.com/public/linaro/lkft/builds/36OCnVeYGpKUCXtxVdz6gezHjcQ/
>>>   - https://storage.tuxsuite.com/public/linaro/lkft/builds/36OCnVeYGpKUCXtxVdz6gezHjcQ/config
>>>
>>> ### Steps to reproduce
>>>   - tuxmake --runtime podman --target-arch powerpc --toolchain gcc-8
>>> --kconfig allnoconfig
>>
>> Odd, this works on 5.10 ok?  What is different about 5.15 that keeps
>> this from working?
> 
> This issue does reproduce for me locally but only with gcc-8 from TuxMake (i.e., a
> version from Debian), not with GCC 8.5.0 from kernel.org.
> 
>    $ git show -s --pretty=kernel
>    869807d760ee ("libbpf: Fix invalid return address register in s390")
> 
>    $ tuxmake -r podman -a powerpc -t gcc-8 -k allnoconfig default
>    ...
>    Inconsistent kallsyms data
>    Try make KALLSYMS_EXTRA_PASS=1 as a workaround
>    ...
> 
> However, reverting the backport of 88b61e3bff93 ("Makefile.compiler:
> replace cc-ifversion with compiler-specific macros") does not resolve
> the issue for me:
> 
>    $ git revert --no-edit c8dad7eb1e6221e0363ee468dc46700bfbad6dd2
>    [detached HEAD 1669da6455e4] Revert "Makefile.compiler: replace cc-ifversion with compiler-specific macros"
>     Date: Fri Dec 5 10:30:10 2025 -0700
>     13 files changed, 30 insertions(+), 37 deletions(-)
> 
>    $ tuxmake -r podman -a powerpc -t gcc-8 -k allnoconfig default
>    ...
>    Inconsistent kallsyms data
>    Try make KALLSYMS_EXTRA_PASS=1 as a workaround
>    ...
> 
> My bisect landed on the backport of 19de03b312d6 ("block: make
> REQ_OP_ZONE_OPEN a write operation") and reverting that actually
> resolves the error.
> 
>    $ git bisect log
>    # bad: [869807d760eeef0e0132eed3f1be6be16d084401] libbpf: Fix invalid return address register in s390
>    # good: [cc5ec87693063acebb60f587e8a019ba9b94ae0e] Linux 5.15.196
>    git bisect start '869807d760eeef0e0132eed3f1be6be16d084401' 'cc5ec87693063acebb60f587e8a019ba9b94ae0e'
>    # bad: [ffd15ced026694355243064968a3b84269e0ee09] ARM: at91: pm: save and restore ACR during PLL disable/enable
>    git bisect bad ffd15ced026694355243064968a3b84269e0ee09
>    # bad: [1ba52b54e5f45e982d61b4eeabbf28d78a5f9e75] drm/amdkfd: return -ENOTTY for unsupported IOCTLs
>    git bisect bad 1ba52b54e5f45e982d61b4eeabbf28d78a5f9e75
>    # good: [8966a057d07281a5e65eaa3225cb072713921b25] Revert "docs/process/howto: Replace C89 with C11"
>    git bisect good 8966a057d07281a5e65eaa3225cb072713921b25
>    # bad: [27df52e05f7dd606e18e869cb4f52ce1fbfe699f] tee: allow a driver to allocate a tee_device without a pool
>    git bisect bad 27df52e05f7dd606e18e869cb4f52ce1fbfe699f
>    # bad: [2b426fa49ef76bbe04671b3a861352b924a01b96] memstick: Add timeout to prevent indefinite waiting
>    git bisect bad 2b426fa49ef76bbe04671b3a861352b924a01b96
>    # bad: [c126c39dc662661531c96acbbf5fc129ed7f535a] soc: qcom: smem: Fix endian-unaware access of num_entries
>    git bisect bad c126c39dc662661531c96acbbf5fc129ed7f535a
>    # good: [c142f0d16766ab7189af4b9128a2c81c56f7a01f] drm/sysfb: Do not dereference NULL pointer in plane reset
>    git bisect good c142f0d16766ab7189af4b9128a2c81c56f7a01f
>    # bad: [02dc541fc61c3e2dabc3574fe46a19f554ea5d8c] soc: aspeed: socinfo: Add AST27xx silicon IDs
>    git bisect bad 02dc541fc61c3e2dabc3574fe46a19f554ea5d8c
>    # bad: [23e0fecb7be5010e96b2948490799ef59ac4bea6] block: make REQ_OP_ZONE_OPEN a write operation
>    git bisect bad 23e0fecb7be5010e96b2948490799ef59ac4bea6
>    # first bad commit: [23e0fecb7be5010e96b2948490799ef59ac4bea6] block: make REQ_OP_ZONE_OPEN a write operation
> 
>    $ git revert --no-edit 23e0fecb7be5010e96b2948490799ef59ac4bea6
>    [detached HEAD ddf3a34910b0] Revert "block: make REQ_OP_ZONE_OPEN a write operation"
>     Date: Fri Dec 5 10:26:26 2025 -0700
>      1 file changed, 5 insertions(+), 5 deletions(-)
> 
>    $ tuxmake -r podman -a powerpc -t gcc-8 -k allnoconfig default
>    ...
>    I: config: PASS in 0:00:01.410526
>    I: default: PASS in 0:00:04.933923
>    ...
> 
> No idea why that commit would cause such an issue... but it does not
> appear to be 88b61e3bff93 so I guess I am off the hook ;)
> 

It doesn't. Problem is that code changes causes symbol addresses to shift,
which causes the output of the kallsyms calculations to change. And each
round of kallsyms data calculation changes it again. Dropping a commit
will solve the problem for one compiler version but create it for others.
There is nothing that can be done about it but to make kallsyms calculation
more robust, but as I said in my other reply my attempt to do that was rejected.

Guenter

