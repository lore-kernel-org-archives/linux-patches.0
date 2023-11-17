Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86FC30F9F
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 14:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GkSil/B8"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1f573a9ee2fso1077024fac.0
        for <patches@lists.linux.dev>; Fri, 17 Nov 2023 06:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700233101; x=1700837901; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=/5gqeOk8feLBS0SVWM5fyR+OkggU3UYj4wNoik2oBu4=;
        b=GkSil/B8NI+q5njvd/fcp1rU3FnckIHS8syFYd1uN2F2n1qLsFH10vpWdQYeQBnR/y
         dS9CuoSOLhEthRXTajrsQCHckJqzjTJhCI2NGmy1ISEkdS91ZF/85VaFdaTEmR4FGJmI
         Qj8yuWGPL8UI/Uw2R1aP8SwGTIrvM0bVYUZmaMWvw089x9uyUZ4AtT4AgVHQNGrCC19J
         lxzMzDGJI4htsQq97zK9WPnMn5MmyOAcYjsQ+vyP6QtP9YlMZmZ1f/s8XIMXsSuEEtPB
         toOqrV8+v9rP7Kh4ZlUgIBvaS7rCPTt2U42jIEzHC5qv7xiUjyU0bvHt0pfKKsruBA80
         5S8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700233101; x=1700837901;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/5gqeOk8feLBS0SVWM5fyR+OkggU3UYj4wNoik2oBu4=;
        b=ilBWDA8/hXMKkcKtur7Y8Es6PVJ9yHOyGcnI6+ImauyJcThSCzMoGhThzvutKnVPDw
         Me2Na5ixw/aQEx20Hhw4GjSjbR9iGfeZ/+9uy5ldwJQUp7G0XOyhbykjfXlRpo1mjdqG
         v0O1XPpNCEY7EhpPQ28xz+/P9bs6SnxU+QHW5i0nG693lj3J2MjvMfssaUenHbVheJjU
         Q/tCAhuuBZtwpx92tJxi+xGuFWytgHy3bdXE10r0/dQEE36gGfooV6mkcWF6PWbdJjeR
         ydM9UsEq2MHj8VztFIq7WmEAs6/tbSo1MXd0vI7GGrzyv+/EKe02+5TG7Dfqa4wq8di5
         wQ0A==
X-Gm-Message-State: AOJu0YypH6+ie3GpjMieN9JK1MJosfvkZZR4cmZ2QJZvr0XT/OAYyUnn
	ashfpNQqQTEkT6unSVzc2BE=
X-Google-Smtp-Source: AGHT+IEwCtwmZWJXyTl3ADPNSBhkBIb2qtZRVcopLY1VSTVmkUYxdL+BL3sJYjOcy7GDqfJ533m0Xw==
X-Received: by 2002:a05:6870:e9a6:b0:1e9:e97e:24e5 with SMTP id r38-20020a056870e9a600b001e9e97e24e5mr22886670oao.20.1700233100829;
        Fri, 17 Nov 2023 06:58:20 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m63-20020a625842000000b006bdd1ce6915sm1563104pfb.193.2023.11.17.06.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Nov 2023 06:58:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <1059aa1f-ad92-4022-a2f5-c313561ae742@roeck-us.net>
Date: Fri, 17 Nov 2023 06:58:18 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/191] 5.10.201-rc1 review
Content-Language: en-US
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231115204644.490636297@linuxfoundation.org>
 <b5367845-8d70-4fcf-861a-ff9b8849c9c9@roeck-us.net>
 <CA+G9fYtOMKserwz7w_gpe4bZnEwrd_-zSyndSepFP_jO9X-o1w@mail.gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <CA+G9fYtOMKserwz7w_gpe4bZnEwrd_-zSyndSepFP_jO9X-o1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/16/23 23:41, Naresh Kamboju wrote:
> On Fri, 17 Nov 2023 at 06:43, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On 11/15/23 12:44, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.201 release.
>>> There are 191 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 17 Nov 2023 20:46:03 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>>          total: 159 pass: 155 fail: 4
>> Failed builds:
>>          arm:allmodconfig
>>          arm64:allmodconfig
>>          i386:tools/perf
>>          x86_64:tools/perf
>> Qemu test results:
>>          total: 495 pass: 495 fail: 0
>>
>> with:
>>
>> Building arm64:allmodconfig ... failed
>> --------------
>> Error log:
>> drivers/interconnect/qcom/osm-l3.c:6:10: fatal error: linux/args.h: No such file or directory
>>
>> There is no linux/args.h in v5.10.y.
>>
>> Caused by "interconnect: qcom: osm-l3: Replace custom implementation of COUNT_ARGS()".
>>
>> Also:
>>
>> Building i386:tools/perf ... failed
>>
>> util/evlist.c: In function ‘evlist__add_aux_dummy’:
>> util/evlist.c:269:24: error: implicit declaration of function ‘evlist__dummy_event’; did you mean ‘evsel__is_dummy_event’? [-Werror=implicit-function-declaration]
>>      269 |  struct evsel *evsel = evlist__dummy_event(evlist);
>>          |                        ^~~~~~~~~~~~~~~~~~~
>>          |                        evsel__is_dummy_event
>> util/evlist.c:269:24: error: initialization of ‘struct evsel *’ from ‘int’ makes pointer from integer without a cast
>>
>> There is indeed no 'evlist__dummy_event' function in v5.10.y.
>>
>> This is with v5.10.200-192-g550b7e1fee20. I am a bit puzzled why others
>> don't seem to see those problems.
> 
> Thanks for reporting allmodconfig build failures.
> 
> My apologies.
> The LKFT found allmodconfig failure lately due to infra issues / timeouts,
> the builds have been re-triggered manually.
> 
>          arm:allmodconfig - FAILED
>          arm64:allmodconfig - FAILED
> 
> LKFT have stopped building perf on 5.x and 4.x branches, because we
> reported several perf build issues and were not solved in the past.
> 

Kind of makes (sad) sense; after all, I had stopped building perf on
4.14.y as well for the same reason. I'll do the same for 4.19.y and
for all 5.x branches.

Guenter

