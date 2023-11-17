Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAF1DF6E
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wp5LKEky"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-53fa455cd94so1681364a12.2
        for <patches@lists.linux.dev>; Fri, 17 Nov 2023 09:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700240796; x=1700845596; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pOZt18bg9KriBHr8Kwgqk5RCy5/kT06h5qAauPIkHFc=;
        b=Wp5LKEky+3Ki5VfAAN6s+saMbR/vXAc5XRAlKV4kqsNH55fTDgrvvS/CFUuGNszPKk
         /0W75Cd8LV6a8Lo9OaiO65fyYIs8bg0OyqOq3ixxNhEqMU/qmjFrmVlfK7k2+3qcLG6N
         wwIzyekSXh2Tmnl56qPKkqjKcChjiL7bxTqxP6qsPT32zKQ+TtX8aS14f43LIUs+pNTW
         h76u2Tv/lMjmvqIWUYu/P7BRVCgfSX/uK4ZZC/3NJctHpks1i5bW26jungGbtHA0ujyn
         jdSB/AdEoNR90xzPcdNnzLG9bnOOoivodXbzoIcKAdxbMdpbmha5nRGxwVCqC1Ck3Or4
         MNuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700240796; x=1700845596;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pOZt18bg9KriBHr8Kwgqk5RCy5/kT06h5qAauPIkHFc=;
        b=VDJ361dyYd6wp6GAN+oKTzrea2okZeJDCoCHD1nPu6U5YA5Takkopj2UGeDlBfWQ2U
         315kavPzw/HEykAu0eCjD3I7s7/hQy/V+REfY0/2SMoN8MCqX5cF8aCfuDUTfNe4czND
         NfPFqBJ7rUUtU6+F8F8YXH4hMRuG6vxW7goaHrgyHyXFJA+s99T9ffkjNBs5sMj5q0cH
         dyZQ0GwG/08Xf62IGDZmkhTwECQlqpAIAh8JQSKS/5MkQS8p91+pHpO6FiBf28Hu6f34
         DNv9Rnol7JtNkWQhaYoUERF+1ORWAGopE48i1vmO2E1jqkqVoAySaQ28z/vPnypByQFv
         SJ6w==
X-Gm-Message-State: AOJu0YwqvUvof0U4/OkjRgpZS8onFnc7WqkzVBSYkI/7OGJofGshWtvE
	jkZJ0TMYzf01nnD+ClMybtQ=
X-Google-Smtp-Source: AGHT+IG2NPDDzAoCkY6gi1aQ9VRk852pWBM0l9/45ZUgEmn0uG/+frUQQrg7EwY+8YcVLvsJTR0LHA==
X-Received: by 2002:a17:90b:1c05:b0:280:85a:b425 with SMTP id oc5-20020a17090b1c0500b00280085ab425mr48321pjb.49.1700240795600;
        Fri, 17 Nov 2023 09:06:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 4-20020a17090a1a0400b0027ffff956bcsm1721375pjk.47.2023.11.17.09.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Nov 2023 09:06:34 -0800 (PST)
Message-ID: <081febd5-9b95-4a30-bd37-d4dc1947c1eb@gmail.com>
Date: Fri, 17 Nov 2023 09:06:31 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/191] 5.10.201-rc1 review
Content-Language: en-US
To: Guenter Roeck <linux@roeck-us.net>,
 Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231115204644.490636297@linuxfoundation.org>
 <b5367845-8d70-4fcf-861a-ff9b8849c9c9@roeck-us.net>
 <CA+G9fYtOMKserwz7w_gpe4bZnEwrd_-zSyndSepFP_jO9X-o1w@mail.gmail.com>
 <1059aa1f-ad92-4022-a2f5-c313561ae742@roeck-us.net>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <1059aa1f-ad92-4022-a2f5-c313561ae742@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/17/23 06:58, Guenter Roeck wrote:
> On 11/16/23 23:41, Naresh Kamboju wrote:
>> On Fri, 17 Nov 2023 at 06:43, Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>> On 11/15/23 12:44, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.10.201 release.
>>>> There are 191 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Fri, 17 Nov 2023 20:46:03 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>
>>> Build results:
>>>          total: 159 pass: 155 fail: 4
>>> Failed builds:
>>>          arm:allmodconfig
>>>          arm64:allmodconfig
>>>          i386:tools/perf
>>>          x86_64:tools/perf
>>> Qemu test results:
>>>          total: 495 pass: 495 fail: 0
>>>
>>> with:
>>>
>>> Building arm64:allmodconfig ... failed
>>> --------------
>>> Error log:
>>> drivers/interconnect/qcom/osm-l3.c:6:10: fatal error: linux/args.h: 
>>> No such file or directory
>>>
>>> There is no linux/args.h in v5.10.y.
>>>
>>> Caused by "interconnect: qcom: osm-l3: Replace custom implementation 
>>> of COUNT_ARGS()".
>>>
>>> Also:
>>>
>>> Building i386:tools/perf ... failed
>>>
>>> util/evlist.c: In function ‘evlist__add_aux_dummy’:
>>> util/evlist.c:269:24: error: implicit declaration of function 
>>> ‘evlist__dummy_event’; did you mean ‘evsel__is_dummy_event’? 
>>> [-Werror=implicit-function-declaration]
>>>      269 |  struct evsel *evsel = evlist__dummy_event(evlist);
>>>          |                        ^~~~~~~~~~~~~~~~~~~
>>>          |                        evsel__is_dummy_event
>>> util/evlist.c:269:24: error: initialization of ‘struct evsel *’ from 
>>> ‘int’ makes pointer from integer without a cast
>>>
>>> There is indeed no 'evlist__dummy_event' function in v5.10.y.
>>>
>>> This is with v5.10.200-192-g550b7e1fee20. I am a bit puzzled why others
>>> don't seem to see those problems.
>>
>> Thanks for reporting allmodconfig build failures.
>>
>> My apologies.
>> The LKFT found allmodconfig failure lately due to infra issues / 
>> timeouts,
>> the builds have been re-triggered manually.
>>
>>          arm:allmodconfig - FAILED
>>          arm64:allmodconfig - FAILED
>>
>> LKFT have stopped building perf on 5.x and 4.x branches, because we
>> reported several perf build issues and were not solved in the past.
>>
> 
> Kind of makes (sad) sense; after all, I had stopped building perf on
> 4.14.y as well for the same reason. I'll do the same for 4.19.y and
> for all 5.x branches.

FWIW, I will continue to build and test perf for all branches that I can 
easily run on our test rack, which are all of them except 4.14.y and 4.19.y.
-- 
Florian

