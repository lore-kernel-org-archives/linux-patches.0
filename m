Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BBD2AE66
	for <patches@lists.linux.dev>; Mon, 10 Mar 2025 20:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741637460; cv=none; b=o47OZk92L2lNdYUdr41eJfYpVqoK9EzXcyaTfkNa2CHnOsH3KdjpfM3KlKqsOsXaQjfk1/Iii8i1wZtJIVa1ePKn6mlxIfja0s16nKhBlKJb0hr+xltcT6tfwl1+ueIxMxyUcdE4NwEl79APzKsRE5ZaWIeLZsve02BwK2ViX5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741637460; c=relaxed/simple;
	bh=C06OSe92qZNkhxGJUCfWRsA88nGUGD0FjeOnBZu2ZQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hDSAApWMxDA3K2NlF6jLdvvIKqIstR0CbhTfqrU0Q84LQEDbScBH08ixjy/4icyicJYt/TV72ftJWw2HO9HuSUnzTR08aYbZG602680KtvJeMB79su+6DuitRCy+m7zD0ruBrLAw8IjgffqOS1qPqAJK7aBIy1qLLLwleTC2xiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DvoqR/in; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DvoqR/in"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3f6ab1b8fc1so1390256b6e.0
        for <patches@lists.linux.dev>; Mon, 10 Mar 2025 13:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741637458; x=1742242258; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=c5TbDrsGnQlptLNjUMLC35cBuMe6dbso9ql7uhEJozw=;
        b=DvoqR/in6Ujjjx/FKjRr1kr5BKvxJ09KTNfbi8BdskGgXBhToXFBmkQ8yI80n5M64W
         m7MQiL+e/rvuoWSxNOd8D4b/DqOPdBb/YanYA4Xf8ebbRVIG7hNK6R+oycoRZ9j4XpvV
         NUh+q6YUYA0BP6taD2/XLLO9gBDvzYZDu7SbidnTcckOpvqi3sku8JLGwCQAqpOv0HUJ
         QtEUkh4nGPkVo9A8qXXiO0V3kcADjXTU2cmTi2yrv7U5fUpLHxd7ws4hOXy5HU1lte+t
         scjJexE5VIBxvcbuBqMhGiwcr2PTsTKh2V5x7rFt/iOXjyfcxpeyOe3mC4jXfLKPDVnG
         nMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741637458; x=1742242258;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c5TbDrsGnQlptLNjUMLC35cBuMe6dbso9ql7uhEJozw=;
        b=b9OnSvd/npoA4TvWihEnXvNaSZGJNWTNAqB3MOYaQ9EWYtsOA+8Y7Gt7q2g5JOWUtx
         E8kEw+wQYu9IUCfT+3LkYKVQ1DC3wBVgZNKcINdN5oYRXNS9v3xcA7Sz8LqNcSG5oP/8
         Ml35YXyx8KcM2gGr4KXaStOZNczNO5zt1uvlQWfxJkjui4OGpKiPc9wyXBFqSccYlsH7
         P5EiXYllO76OH607WLo4kGlBSAFr6L1ZvFvnXrwACDz62iOt6pYv9A10VYTy5pVVdR7C
         lmwh+74IBLhF4wOq8rFz3bzn0LtsVBXYGsGqWomt1BRgLkFAlNMfC1dFO+JUIrUZq+1J
         Yswg==
X-Gm-Message-State: AOJu0Yz6FTaTo6MjFw62pcab8hAGUxCI62Hhz9E5Sx1qFOWucIBrUCBp
	v0ZBDlLFeVAtYSUqCNQ3Dclu8Le8dqiXEDJN8tidbaE+5pbszVhp
X-Gm-Gg: ASbGncucVAzb0zB+W9uZpojr0rF8W5OJpZIZ0RDFSrevvfIdZ2fBc9MYssKoRgBiDvp
	8HBl0xs2pBckQEWDlRVn8RzrCmIlAvdcCIVNvBR9Y1hqZAOETu1VFqMBCObKvRzz4yndbBNV1C9
	jvOLmANQgkrFF5I0snCirTQAiCPZYOYKQfhOlZODVJgxAO+pJtifhhLiphQp/LPfPGRziVtZ4dT
	L1an9osvWn9UXZ5umKgG7NWPXqElJh60Fuff4mNSQQhDuXpWGrR0qaoX6mT9SITbwav7h1b3T/h
	89UTAT/wsOYxsGMdQutyRwHAIlnTqnR9OnqjFNr6pDhls2PEa9CE/5pImA4D+XMBdlSgWEzr
X-Google-Smtp-Source: AGHT+IF2adSKtfNpM4XnTYxyh6huf8QXX8KaP5AthKLksUKJqP3gmtNc6tq8iaTxguliYCDdyncN6g==
X-Received: by 2002:a05:6808:350b:b0:3f4:7f2:a773 with SMTP id 5614622812f47-3f697b3aad4mr7894485b6e.7.1741637458362;
        Mon, 10 Mar 2025 13:10:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f95edab2fcsm335691b6e.11.2025.03.10.13.10.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 13:10:57 -0700 (PDT)
Message-ID: <d5e3826f-6514-44f7-acde-897a036fbf96@gmail.com>
Date: Mon, 10 Mar 2025 13:10:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/207] 6.13.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250310170447.729440535@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/25 10:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
