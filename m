Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A504158857
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 19:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761679646; cv=none; b=NvD9w+0Eu1musBbViK1zmnx2jj6MiGZaC56q/gP3ofk9viFZBEJuphz20LLS4tUsNaMSJY83w8UYB7bJDkRlxRxhC+pxoS9r6J4iI1WanH8ecGlx/Cl8SjtHiW6c8HkxohdUoOE54yXyCXRKszEJKTlKZRVeG/5TJAws7rl761s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761679646; c=relaxed/simple;
	bh=EjQDlMKljLoLF1RNLEqNk/sJQiRMv0YG75vPjfuCAbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W17Jbdog11WDHIM+T228cflWZwljiSWBJct8PfJgpuM0RC41dbjq5WUgLKWLNOcTOCQCzIeUjwSCHZ7Hp/5GvWM3fqmFqnFAWocY51h801CcUpHRHBIN21rF0EsOMxYe03VG5onYPgOFn+nA7ppVzBHbIo2iCVeuSLdfeH5i/DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPhqdPtX; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPhqdPtX"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-430cadec5deso62255685ab.1
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 12:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761679643; x=1762284443; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GB2PFiCN2UaCVMnczPZbv8cjpS+ngdtn8TvyTng1lic=;
        b=MPhqdPtXqPeadnEXp6fJtPhmvGnBqeFrUejV7rZfxGUxyY7hYBaQ8A/YUaGn2EcUv+
         H7RVc90jNOqIs9BSqpQc01B0bVYYIL2yucT+mDTUKnEaWe+yE8YArkyx0Qhvd07SB1ub
         uY7RAT2acP9wOS9oqNQqmxk688HA9/M0cp180=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761679643; x=1762284443;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GB2PFiCN2UaCVMnczPZbv8cjpS+ngdtn8TvyTng1lic=;
        b=GHXDV7QdhpdLbgfbnQI8IvEXQzshGwL+1nKbOYsEG6+VLcKyDHWmyBD8Uh4BCLnWDO
         0arT3zp4UmtoApP+GGTrL7S7MwsA5aDLPwJqq2vb1y7BqsQ3Wkr7WzaYShY8h/tzDEVr
         dIR7uHRLJFe7pXkLs1lO1qaSBVdaqQJgpOTta7pnMkRhpJafs74FEYQAmWtjPJtlARYL
         tqKyUucWQ9sJmZMVwlLIHYLABMgkP/3xNOJK1B0JKLyn0vs57tMe4muvCKhbUCqd7/wR
         mWfvnLIKXMGd/zOQEMFodPBZuZSKmOboUXtOqvj66jiLvZ6YRrusmzfDVUbnK1UL36y5
         QX4g==
X-Gm-Message-State: AOJu0YxBVJeZW1JNcNkUvVRd+XmGO9DgNsFmYy8ui2EQgzY2V9RJJlsR
	fmyIbX3dPadfOYxLOFoBUUfk5DTiP/xa9wptle+lH/COsNf/nMCsOjt7zGvHNNT2Bz0=
X-Gm-Gg: ASbGncta/hzo1J26m2Mwo356S0mLtyvmoj3EYelpcZuqMzstyg0/Sy+FYKMszzGaOHU
	9YISnoQJNguYsJXasIAE8wdkeIKxCQcGk7unWkHlADt0m04x3qtuDarqo2kOixmuPgPxmB8HXk2
	EZSqU3k2zCkdZrH/9pOlcfbIu4+3sIl1qoDn52mPcEH2qNHheunpZmPQEI5ZzH4qtX8JZ1vO4AG
	RibiXXmTAMLsIJTDCbFQaSWR1mlQd/M3LUc5DHdCDL+RkmJfSA+TwnotN/HrAPXCMACi8dqzwka
	eXfR4y3hiqn9kCORZYiYZIyzWcw0uRp8rSt3EX+OFRRG/6mrya2i68s6HFz+rGq05sw8QVJ7UPv
	OXyfrZ89sNrO8khCgG7OupSQejXjsaC+tfRT8+NCtm/gQ9EWseVbAc4uWkrxHGPliMoZCfoSJeU
	FH/OSsniR+7J4e
X-Google-Smtp-Source: AGHT+IGXVvv4lpTGzJhlhova0pWyuJ1mMuUD5kivB8hewEmKrt3ll5migY+nbLuVZH69B76ZbpExJg==
X-Received: by 2002:a05:6e02:3c04:b0:430:b6a0:1b6a with SMTP id e9e14a558f8ab-432f9064bbfmr5094085ab.18.1761679643364;
        Tue, 28 Oct 2025 12:27:23 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5aea946de41sm4714939173.40.2025.10.28.12.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 12:27:22 -0700 (PDT)
Message-ID: <91fdefc0-c79d-49fc-a2f1-ecd650ede4d8@linuxfoundation.org>
Date: Tue, 28 Oct 2025 13:27:21 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/123] 5.15.196-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 12:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.196 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.196-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
