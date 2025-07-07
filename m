Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826D0278E63
	for <patches@lists.linux.dev>; Mon,  7 Jul 2025 09:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751879776; cv=none; b=iPjQUfNKQSBA6oF+yLVWYFX57e6fonSMvG/C7jthQizxH9HtwVHdfI3NdMCyVycYEGp5BLU3yLOixUZ8cmfWflB7uRUJkV9H6uxTK73lD6Dzwackn9Q/3B0SXX/o18FzHICk2RV2igHPCtDRSN3SRV77gx60AcalkFEDMjCJBW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751879776; c=relaxed/simple;
	bh=2N0U1EDqI/jQKzqP2h1Jsj1CKcBZm2BCirQSwgH6hIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uj7hvtJjLeUthLv8G3F75N7qg4N1bEgt5bN8YL5AgexnsVFD5nw7DSPOBVr5nJi7BzO3yJeHFewuSeRcwpirZ7B4x7BM1hrUK8tA9FkYX0TEZKO+enlKSDJ/WWv2rTkXnfrGNpCSj/I51srBVXOKE8yMjSh4RmQWfpa/k6q0f1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c2D6l9QQ; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c2D6l9QQ"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3b45edf2303so2666513f8f.2
        for <patches@lists.linux.dev>; Mon, 07 Jul 2025 02:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751879773; x=1752484573; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PSMRH5QDvCqW5KnIuvKRJN2G/mVFdVuXbgUbVefRVkM=;
        b=c2D6l9QQn/Fo6A6bB4CsJrJSedtYcX9WHtypledRi7iCp5TdWX9oBQrFIEVvZ9ibDP
         E/zZXJyKK0NI9UzquSidQVHEYCJdPcmcpYeRZCb+AyzsdAoFCbJo5aCg2JWjhIAn957m
         3hBLehAuGrDEp7fhVnCKj4IxrkGVkDbs7+vgZsas+lFMM5rSvCm6qWDvIuQvkJguop6m
         tndIdvkYU+TVP4rIYjMxlSXorGXEtSBkwOk4H8F5HUWX5LdFHzA2CRXjjxhLamUXKSgM
         AXMd7JuZ9BQTycX0RpCYKj7EpFwqo6dJyk6/B2tiZOgdCHU6gxcISgg7mAP+Z7t7XpAV
         2uRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751879773; x=1752484573;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PSMRH5QDvCqW5KnIuvKRJN2G/mVFdVuXbgUbVefRVkM=;
        b=j4gfeb9dBiS4213UrSB7Diiml9fxfrxKFkoBiD9FcyYAqDvfxYDUZuk+2M1vAC3QbE
         gtvuauJUmXmprTdz4Kv4RB4Ap0r+pmi9h7ToyPQH9inmkMKOiZu8MRAqDcXU3F98OHEn
         jCtoQZDGvUX7rwyAzGv+L3MjLfJ8AWE2ouqjSVgPe/o/l0qlqLm0pnvBJuJnIDBUwUHu
         OzqIWlp5gCwz/FPPI8U6HJ7l2RCgJRkIomSs0Fikq5vYV5fGYOVZGDVUDdAxEfou0Ynq
         rHFCXIFGr6K14TCBQXQ57YeNn/EXKWQrsg34W70ahCRs+Ma6w8NgcgMkdrfHab2d/8hz
         qoAA==
X-Forwarded-Encrypted: i=1; AJvYcCXgkEbfj8puNt9ZIFdi6gGTl20UJFUoEcydgXNwCbVr5DPZJWXJkTFR/lOm1+fDkRaEY5G+b8uC@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8U1IpbKgbAvUbkjmXIKj6GBM8ccxsLGXlOFE5HTYzxGWBFAxv
	Yh/O8ay1ix7g6b2DMmx5czlGHOnjuMnm04fxsv7RbXhOwo1nxP0yohAIjFDtDYEiGHQ=
X-Gm-Gg: ASbGncuP2xAUNWod0eoaIJi30d0d/shxPpItgBQZi6Keq656e0BOpMdDKPMMzF+k9aE
	U/Okfnmqz4M3XmGZJ00SnuleeMlpX+ciimROqrE3ucMly9VpdMRfuLsHy8rXK2xr6iH8ht98/xk
	CjdYHnTBAvRqmDFfhE1OmBS70nApJLluA7vbVAb9qaxGHul3iSARfKVNesnSyjTWtI73hn0SdX/
	jPwbNeVdj1ndGvPT4VSWOCumup0UBvFn7h+JO3o3O6GgdqGvtsGZwsjBzMVksvZtr6FKrN9h+aN
	uGhEAAKiCaC7paHMR0vabeTOy9/sS+LOZ+fVi2XSm/J7+zbMgX64kQWbgfj1MSuLW8o=
X-Google-Smtp-Source: AGHT+IGGCWZfAUj4VNzkhRD8HfhSu3KCxQFzzdO1XpeV+D2rkMvRTzngh9EBKomoGoCaM7fN+nIbCA==
X-Received: by 2002:a5d:6f1c:0:b0:3a5:527b:64c6 with SMTP id ffacd0b85a97d-3b49aa0e8e8mr6353994f8f.1.1751879772702;
        Mon, 07 Jul 2025 02:16:12 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b471b9671asm9687980f8f.53.2025.07.07.02.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jul 2025 02:16:12 -0700 (PDT)
Message-ID: <207d1f3a-60f6-4a8d-8adc-e03e95f198e7@linaro.org>
Date: Mon, 7 Jul 2025 10:16:10 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/139] 6.6.96-rc1 review
To: Leo Yan <leo.yan@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Yeoreum Yun <yeoreum.yun@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Anders Roxell <anders.roxell@linaro.org>,
 Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>
References: <20250703143941.182414597@linuxfoundation.org>
 <CA+G9fYu=JdHJdZo0aO+kK-TBNMv3dy-cLyO7KF4RMB20KyDuAg@mail.gmail.com>
 <CA+G9fYv4UUmNpoJ77q7F5K20XGiNcO+ZfOzYNLQ=h7S3uTEc8g@mail.gmail.com>
 <2025070605-stuffy-pointy-fd64@gregkh>
 <20250707090308.GA2182465@e132581.arm.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250707090308.GA2182465@e132581.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 07/07/2025 10:03 am, Leo Yan wrote:
> On Sun, Jul 06, 2025 at 08:55:32AM +0200, Greg Kroah-Hartman wrote:
> 
> [...]
> 
>>> Bisection results pointing to,
>>>
>>>      coresight: Only check bottom two claim bits
>>>       [ Upstream commit a4e65842e1142aa18ef36113fbd81d614eaefe5a ]
>>>
>>> The following patch needs to be back ported ?
>>>     b36e78b216e6 ("ARM: 9354/1: ptrace: Use bitfield helpers")
>>
>> Thanks, that makes sense, and is easier than me fixing this up by hand
>> like I had tried to in one of the branches :)
>>
>> Now queued up.
> 
> I built for the Arm target in my local environment and confirmed that
> the build failure has been fixed on the linux-6.6.y branch.
> 
> Thanks for reporting and resolving the issue.
> 
> Leo

That commit only fixes it by transitively including the header though. 
I'll send a proper fix to include it in coresight-core.c so it doesn't 
break again in the future.

Thanks
James


