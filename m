Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A19C2E3366
	for <patches@lists.linux.dev>; Thu, 13 Mar 2025 13:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741874370; cv=none; b=EVCBWht9eOVtqy7nIgGxFnIOFvWnIU5IXWkp54JZoM9+6VWpo3IooqPVlv5hs2gTMMUW9ppVv3AT1whzzn90beb/Sg0CSRIoy997UrlAsZfod5GjnEyyBqIqkEUg/m3LFWBDNmgvS9Rse90bAhxO5vXtCQLNyBmUQpGYlTaLOEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741874370; c=relaxed/simple;
	bh=THm6FaQQgLW/8m8yRNpcmIzkqlxy2yVeotJDAywN9dQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dEA134UIS2846jr0XvVG/Bg9njJRVec6ui0UJVKcyczYshwfBh0D0nk9U1I/Af7wW3vor0JqjaYghk0UGVqpmVNnb9pQCTtD8dTxlIF/ReIqbsMgG9Ldxn0msu2zui2SfYWKVMTfchH9uGRFDAayAfQEIs2vpmtf2Z4kQZNlKfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cttVlkvz; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cttVlkvz"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-72a4793d4e2so574513a34.2
        for <patches@lists.linux.dev>; Thu, 13 Mar 2025 06:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741874367; x=1742479167; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5OPl5i71ZdSAzYa7F6yiKwtJ4dNnBEhCh3JI29+eh4I=;
        b=cttVlkvz7hNGOb9Edq6ZBl+bmDIZXKphZvRaKts7KuwmcHPnSOX9EMWy0+lmEXDrsP
         704BipR+AXIpuIsp2l5SCbuMnYzB5PNUESuDI9v1ommefFWW+fYVAuf4vVCpy3ajoxay
         BKgrLayr9dgajPr7/HtXigZIY2Ltefe5X1D20XQz3DLqU3zJu169wzIHwrYIuKupa/CU
         gSkJTvziOlhOMw2HSFALywmii3rm5Z72Y/RAAXdJ0W5blbB6R9RE+EnYk70piZdUcr7R
         4cpu7i9jqKqO7saEmwoeoENvPIhlSZnhADjXVeLwbJZbBE7tZpyheWsVMP8b9ClyUlWO
         ELgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741874367; x=1742479167;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5OPl5i71ZdSAzYa7F6yiKwtJ4dNnBEhCh3JI29+eh4I=;
        b=tn5cuYwNdSbGhRVpbUrztAFYlwGmOiO53XbaRwzVLkP3/9nGms2PnF8AFw/rUc00a4
         p49loqHi/NMgg8UBxVM3CaOFTyidoLIVETZgEJ32L0phSnkylJMgeEdoAlGZ0+R8YCgw
         iUzp7hGsSsXv3KkhdrzoqGi6q90iXpmEtVxwjPfrs+wtPjsw028M3LyAyCDZNnuuM5Ub
         1CZ9lNKLjbvSnpG6jDjbrDQp2bQu1cbtonRJVYcmFgqRgROsHLE6anjf4nJRD7fwSuB1
         5dF8bskEaui+1+Ew6gjnTJL/0xazYLhRUB5rfrLxcHvHygD1ts8zVJlxD6ae6GS9FGLl
         gWRw==
X-Forwarded-Encrypted: i=1; AJvYcCXj//ZOHaUHZCqcM6pwLygce7yYTHc95+1C37iFf6qVPv/ACXJU2lXh2exmfOtWMQOAjlbJtViQ@lists.linux.dev
X-Gm-Message-State: AOJu0YyCL4mSWYpbMlZOeU9ihqB7/N4P2vEHhsBWPFmWDgGe0FG/QYM+
	3gvcjeHVCXqwKQuSZw2E6Lalph8sfTZi0qUOIiXnqv8bptnKjn5X
X-Gm-Gg: ASbGncsznk00txPXVLxvW5ye+J8oFCosHj0dc8MPXzxkoYRkfd760fAiry24ehOZcSL
	WSotgVl/wrCG47bTUwxFgMvJhpODLyoNmzyWh1dm/hDKIzogrujr/1BJ4Z+7BeGy0Jn1zhMB6XR
	Yg1LUBAxYYRwKNhysdAYH2Ii4JwMaWkWZt5qPtGEWCclWTVyUGRJ85lAByOAH4ycmPIddBKm5qW
	PrpB8nRC5WV04XcQk+aOhPMiY3sb71gWXyOsycwzuOXdu3WxzO2TDOhUG8X6VxfTEZXk4WGa4Zl
	MXMYqwhZ5BHB6t/mYOQ5wRkl3dlYyIP3tTo7FlVr2v3KhMbJYHGjAIK/jziH05PgHCvbdPZb7Mh
	wFSRQz64=
X-Google-Smtp-Source: AGHT+IHvFoab+GDvaJG+xkWK0e3xxY4hzqJWEGrTyUuy0qbkjGICwxHCh6DPBxJ+i2yexq/5R3XwHA==
X-Received: by 2002:a05:6830:6e99:b0:72b:8a8b:e02d with SMTP id 46e09a7af769-72b9b319d94mr6962019a34.5.1741874367573;
        Thu, 13 Mar 2025 06:59:27 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72bb269dfbesm213185a34.22.2025.03.13.06.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 06:59:26 -0700 (PDT)
Message-ID: <603b3f10-6ad9-46af-8b31-d11e46f4698a@gmail.com>
Date: Thu, 13 Mar 2025 06:59:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/328] 5.4.291-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250311145714.865727435@linuxfoundation.org>
 <CA+G9fYtG9K8ywO4w2ys=UEuD_r1LgOuZhG4cg62YKAX0qK35cg@mail.gmail.com>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <CA+G9fYtG9K8ywO4w2ys=UEuD_r1LgOuZhG4cg62YKAX0qK35cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 3/13/2025 12:19 AM, Naresh Kamboju wrote:
> On Tue, 11 Mar 2025 at 20:33, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.4.291 release.
>> There are 328 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 13 Mar 2025 14:56:14 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.291-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> NOTE:
> The following build errors noticed on arm, arm64 and x86 builds
> net/ipv4/udp.c: In function 'udp_send_skb':
> include/linux/kernel.h:843:43: warning: comparison of distinct pointer
> types lacks a cast
>    843 |                 (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>        |                                           ^~
>   Link:
>    - ttps://storage.tuxsuite.com/public/linaro/anders/builds/2uDcpdUQnEV7etYkHnVyp963joS/

Yep, this is seen with net/ipv6/udp.c for the same reasons, see my 
comment here:

https://lore.kernel.org/all/0f5c904f-e9e3-405f-a54d-d81d56dc797e@gmail.com/
-- 
Florian

