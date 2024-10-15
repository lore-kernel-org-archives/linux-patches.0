Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667681B21AA
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729013152; cv=none; b=Ywm/DpsEO1xny1xUnsA8ViZajJkRjesX005anVR7dNrK7YpuM/pAYW3zQPoaYMbytoQsbMNkfUJKiESj2AxY+Bck28zcmf5Th+8590+z/qfyjH8SjJa9FtSushw0zCyNkRUTNCjM7LVs+p7FiAT5/SeqOLkrXjJn0U27jiitaVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729013152; c=relaxed/simple;
	bh=LKr6eCiL7zYXhzK7DIIDARWLKtxeLAQBHXgdBh5hlVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hnXKAh6xD1HphQAomefiCPkLOB8eTx0fwDntL56ESco7rzbIian6a586gv7xx4EC+IcvJnP8RSyHhRI9GCqTaO/GK4kwsCM4UA5dLBriwPftTrIRK0lwtV4ZBr2ofBPPyOPv0RS1eLNOWrdrLQEYc+E1crl8A9g9qzFQt6SYWP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lpfazQ50; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lpfazQ50"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4604b48293dso804611cf.0
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 10:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729013150; x=1729617950; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GcQX3JDDWbQMMy3zmo3DJsYBI0G7ZbUEVumODIsy6Vg=;
        b=lpfazQ50e/SUdlcpiLueIGfzyu0DpQJ5gWZol1bo20yRXnKAW+QBAkAiGHs6hgZaTl
         gAIjPL9gNzXNLC9tVDf6uJ20Xsk4PM/BYmunRycGMIreJeUlsc5yG8hncl99NBCFC2IQ
         BJZ3J8vwMRL56XJOnxKIryWtH+jsH8adY2qjwsn1XNW61QN1/J0whSAu7mvYnfAyYOu5
         19a4BtxZUhHTF7izcAe11WhSvDwN7P74M9oF4/bPQoPsS2K/IEudYB/V5bgb9sw7blNr
         tRK2f62D1jZ1ywhLe/tHMt4biqIssoUMcQWVQxiDrFLv8M6drlRHOXahTbcZ7/BTFRv7
         8frw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729013150; x=1729617950;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GcQX3JDDWbQMMy3zmo3DJsYBI0G7ZbUEVumODIsy6Vg=;
        b=erxBZweMYZjswtTdiBAucc4xy4C/6sVK9c7fmJfwTxszuXNwDQ7dyGgLXlBUklXhuW
         ARqQHoxofd8izrmJrWn1VTjU1XTq49oGHVuSiLzDpEs0F1jQ2s2FZlWBsakje38P5SLV
         0misOo/NEZ6PuFxIBz9nnhaS8Dh1yW5xhw0HPqDczRHENhXaGWC7XEatxhiF9pjP/ftG
         mYBdIUthrAktYK2Fp9TIz5iroLCySokJAOo8vR3QuT5IfmCbyiqP1JBSR/OXDZhQFVhE
         UkNUzb/swt9XmP2XhxO33ZJHuoltM79zdjuvnR/ZBCj5mf1sI1WQA75M5KOSiuAvPJ1w
         tCFw==
X-Forwarded-Encrypted: i=1; AJvYcCUKF9rEJ2wXwYrU2jiGtiI4vyO+WdmlDIGmOgeUH4zZaaIZp0uSxKNxJphoF9y15m4O6mrHU0y2@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5Kdw2w9/dEHZhtkausEBIfl2Bslmr9oHRYouTW4GvF5Yw3T6W
	1+UTV5NOJ5b60U8EfmdnSqS5OHM/YO8WXMMEfOQUqerF/LYBKpDZ
X-Google-Smtp-Source: AGHT+IEXtMXDhseytBs9YZS3RYDMOm4+vsvSyB5wGvEdzqO9Cy/WdLwDUeU+Ap6k+599pNFAYoifhg==
X-Received: by 2002:a05:622a:cd:b0:458:27cb:a5e4 with SMTP id d75a77b69052e-4604b237603mr281620371cf.1.1729013150132;
        Tue, 15 Oct 2024 10:25:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4607b36f551sm8659301cf.62.2024.10.15.10.25.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 10:25:48 -0700 (PDT)
Message-ID: <7df2134c-a2fa-4cb8-8d57-e06fb7f62bca@gmail.com>
Date: Tue, 15 Oct 2024 10:25:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/691] 5.15.168-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241015112440.309539031@linuxfoundation.org>
 <43399648-ea75-4717-b155-73541deacaba@gmail.com>
 <2024101515-timothy-overdrawn-b3f7@gregkh>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <2024101515-timothy-overdrawn-b3f7@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/24 10:17, Greg Kroah-Hartman wrote:
> On Tue, Oct 15, 2024 at 10:09:15AM -0700, Florian Fainelli wrote:
>> On 10/15/24 04:19, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.168 release.
>>> There are 691 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.168-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> perf fails to build with:
>>
>>    CC /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/evsel.o
>> util/evsel.c: In function 'evsel__set_count':
>> util/evsel.c:1505:14: error: 'struct perf_counts_values' has no member named
>> 'lost'
>>   1505 |         count->lost   = lost;
>>        |              ^~
>> make[6]: *** [/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:97: /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/evsel.o]
>> Error 1
>>
>> seems like we need to backport upstream
>> 89e3106fa25fb1b626a7123dba870159d453e785 ("libperf: Handle read format in
>> perf_evsel__read()") to add the 'lost' member.
> 
> Is this new?  I can't build perf on any older kernels, but others might
> have better luck...

Yes this is a new build failure, caused by "perf tools: Support reading 
PERF_FORMAT_LOST" AFAICT.
-- 
Florian
