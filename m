Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9065829D0F
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 17:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hg3y0MmQ"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6c115026985so4885118b3a.1
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 09:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699292583; x=1699897383; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CXH5ahRPz8knk5h9KfR4IuZwTMLTaHWDUAgFgEvqapQ=;
        b=hg3y0MmQk+4lTE4bhhJa5doCUPjn6JDGHcUJwx8PXqfBCXFGgPTtLDHiX7Y4JaXt2J
         e+HyMmxKyuWmIN6ub1x4qJPN4ddm+r/e6tOvDUh7bfJltdeWckL/UyIMe56GbP9gxSgu
         UqQ12Q/b4csCBC/3JEi6zGMZJFVetkp6YE5uo8uYnb5rhMmSvHFrWGOYMOgZgwoFoHyl
         /eaz0bkGlNaSLO8BsV8hLxIJdVfGPHly6doFk3Cn88gLwUVhxigY8Jei1p/I4uu6Fc4Z
         6tQ45Eli2p+DpUhACfwbbwbTuro3U717xxUqgdvcGZQQh8nz5NLqMHZ2ovpX5Rx/hMjS
         ruKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699292583; x=1699897383;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CXH5ahRPz8knk5h9KfR4IuZwTMLTaHWDUAgFgEvqapQ=;
        b=nH6wNJWDwS4mk09aO6vj7QgavvUgaGMuE73eCobWBq6UN651KRn9SfKfWZDEIQHG3s
         NfwfmQoLmAS+ssvhj2Ks0Dsu/LmewBsytffGbnlxusCN77C7JR3eSTDfRtJ5dHsOfHEI
         noDmVkYDb+QH581Iw9GKpg6dS/C+YsqQsAduVcDPBU/oji20u/N/eC23RE5rzIEtOEAA
         GYpKceeQiX1qgxt9XlKXbJZ+PadbY2r/vI+eEpCY+RZJJtzP78GA6TsGy+ywRdPcm3/n
         ME5onc7S/nEEafdwDTR9UtC9j/NrChhwyEXNtuVEvnn/MY4hLOsNjSosuPXzv6j24d4w
         SCiw==
X-Gm-Message-State: AOJu0YxsC+KOccutx71yqrQBLKxAJfoiVZ2SsU1SnrX1iX/LHCHBwsvQ
	nupFxgQD3MJWTp/xczXmpnY=
X-Google-Smtp-Source: AGHT+IGdwlguaisgUp5xLqOca+yiZGMYX7D1ugesp5ymFRkqq5g+jSkbzdQHAeC4eV9GmySDDqEaYg==
X-Received: by 2002:a05:6a20:ae25:b0:16b:bd0f:ad0d with SMTP id dp37-20020a056a20ae2500b0016bbd0fad0dmr21552292pzb.28.1699292582698;
        Mon, 06 Nov 2023 09:43:02 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 14-20020a17090a01ce00b00273744e6eccsm6319954pjd.12.2023.11.06.09.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 09:43:02 -0800 (PST)
Message-ID: <b2867987-809f-4005-a303-9d8dba8882af@gmail.com>
Date: Mon, 6 Nov 2023 09:42:59 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/128] 5.15.138-rc1 review
Content-Language: en-US
To: Allen Pais <stable.kernel.dev@gmail.com>,
 Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Sasha Levin <sashal@kernel.org>, mizhang@google.com,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
 Darren Kenny <darren.kenny@oracle.com>
References: <20231106130309.112650042@linuxfoundation.org>
 <2665d8bc-111c-45ca-a473-b1c892867e9c@oracle.com>
 <CAJq+SaCqtQwk+eCgXT9jQU33Ufqr+aOaQq+VsXHCqdc1Qp8Vkg@mail.gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAJq+SaCqtQwk+eCgXT9jQU33Ufqr+aOaQq+VsXHCqdc1Qp8Vkg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/6/23 09:08, Allen Pais wrote:
>>
>> On 06/11/23 6:32 pm, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.138 release.
>>> There are 128 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> I am seeing a build failure with perf:
>>
>> tools/perf/util/evlist.c: In function evlist__add_aux_dummy:
>> tools/perf/util/evlist.c:266:31: error: implicit declaration of function
>> evlist__dummy_event; did you mean evlist__add_sb_eventâ€™?
>> [-Werror=implicit-function-declaration]
>>     266 |         struct evsel *evsel = evlist__dummy_event(evlist);
>>         |                               ^~~~~~~~~~~~~~~~~~~
>>         |                               evlist__add_sb_event
>>
>>
>> I think we should drop these three commits:
>>
>> 20a5799cae7dc perf evlist: Avoid frequency mode for the dummy event
>> 7de783c81c7e7 perf tools: Get rid of evlist__add_on_all_cpus()
>> 141ce9207068e perf evlist: Add evlist__add_dummy_on_all_cpus()
>>
>> Backport was requested here:
>> https://lore.kernel.org/stable/CAL715WLTjMGQrhm6wWqFSeL_Oq-HzoQd5CqewvLRLv0Xbnibgw@mail.gmail.com/
>>
> 
> 
>   Just tested perf build, I see the same errors:
> 
> tools/perf/util/evlist.c: In function 'evlist__add_aux_dummy':
> /linux/tools/perf/util/evlist.c:266:24: error: implicit declaration of
> function 'evlist__dummy_event'; did you mean 'evlist__add_sb_event'?
> [-Werror=implicit-function-declaration]
>    struct evsel *evsel = evlist__dummy_event(evlist);
>                          ^~~~~~~~~~~~~~~~~~~
>                          evlist__add_sb_event
> linux/tools/perf/util/evlist.c:266:24: error: initialization makes
> pointer from integer without a cast [-Werror=int-conversion]

Yep, same here (and on 5.10 as well).
-- 
Florian

