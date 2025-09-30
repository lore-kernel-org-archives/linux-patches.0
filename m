Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9611F5434
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 17:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759253881; cv=none; b=Bd3IwrcQN5us8lt/XZar5MrgKTZIPkyCWzvyXyp1RTdQ1+4NkmjpM9qDtB3fYrSbTE27OQ11oS5awZRG/aZNkAYXeEubAbPmRWyxBi2raN1AzjzISgBFMFDezl2SWrX05fMbJg7WOcD/H+x2hNrYjyqYepRVdrkSS4pBDh8nrOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759253881; c=relaxed/simple;
	bh=2TC+hXWlv6u2VfdLj+sqgeI1o1n9KDX4csxjWQttT40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UBEIrnGxSEiMcR1cVeLeoh8wPyqBHdyYpMfXvKg/K9auLrBt0YJVHoISFQq31bDVzqRcdUZcWAIwe5vk16I7mkFy+FBllamd1r9pTHR+ikfhG21EngwO/4L6x3l4UejJmINWMsaWfyOETde+pDwM9kEiGMcEzkUXSUSx0oFUtaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RFN6qs+Z; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RFN6qs+Z"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-792f273fbe4so34226026d6.3
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 10:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759253878; x=1759858678; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0/hKAmf18Y2yd5/OgWhquQHdykw3Pq1AdppT9xBph94=;
        b=RFN6qs+Zag7VgmlaqyLh3/HNyUXU3TJMNmPfYXjxn4MlcMSRgY7OIfj+75r0Hi/tx3
         t2b9CcPRMZnhdzrBINSZBi63aYEdcpKZqNo3xexz8jKivl2dUNZJnnVPLMYKVbexTtTU
         EonQ9MHjQfSJmD7MgvGmzYbFCf9AuyXkj8w/nn8rXjU9T6bK5NwqkWETTm7cZRoB/rrT
         BppPzGBTqf3ZFYWmRarS1MoC0d70PZ78W7XD+x8gvZx6MXoJqT6D04TOOkcQOH9+pLmb
         W/1aotn3rZ/rY8dlLmrHi0AlJxrZT2+Wx32ISU4opUVlo1H0yJ7Z8DwpPucUByIs2EWj
         9O+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759253878; x=1759858678;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0/hKAmf18Y2yd5/OgWhquQHdykw3Pq1AdppT9xBph94=;
        b=fx27lnryvC8fEwGhcVLfJ8Z23YLAuj57e7k0GLPTzPO1NHYHFpg39VCpEz7A02cZVp
         I9+5vw2xfDkCtDXgDp1dNzdnVUa7VkQY+kf0K6V2mHiSvsakxkXjB0pSo2f1ABTup4VP
         WDrr0/t56bClgZat2ZBXwOsYbXxWy8R42INcNvksU3ngca3L6+xLTEyYuTk6DdyhfVbd
         P5iYgsKIwae53ffYYbKtl9xh0r3iqs6bqi2jN0ze01DfhxKm4lDF2r+WC22jKl2UViqg
         wtOYWqyUh2LsBx1KHP18QaYJNLvT1j3ULaSFrXcKdGE82NP8zgLxpTjKdA4oooZ+Aih3
         rQPg==
X-Gm-Message-State: AOJu0YzxlKVc/KyuTnZj9epzQ9yq7e/jGNArMfq52BJZ3iQTwiR7BY+O
	PJeHCXwhW2+3/uFTAOVJQS4AUlNB53nvvJwx27BwSLLwJOKWDjz86xuq
X-Gm-Gg: ASbGncsljYaJnSYyaO003EZ6q19ytPoIimV1CyAcg5lDP/S+o0COkUswcbx75gqTV7D
	sVKG5kahCCzGXmsG6A0aeRws5USMglkTcA69T07Xo+KQtbt+PvA8IRlco+QsvOfc94Lp7BQ6XCB
	3Oc1Dgw8xswDmAp8GFpay1xP2/juKu9Mxh9E+dW8RmuP2f6gh3kirAT5RaQfvSso3jlws9qKj6Y
	J4J3ntYP0d7biSTd6PSzX98pZYYbK35IrNfgtRxxcSZrH9th5GJBdVrgcLS4ss1TtUcMwvOJNfK
	2zNJpspWoJaQ+ma5r2IKYQg++Biibn8lj2vQ2XT5xEfBPHHFhTn6QeU6AoCgAk4IpxuQUbfhiHk
	cIVZyZAIZYXLBFn3O/Q5YTtbVHfRjYgcS5vA1mCkzlkGlyMtkYY88Eblw/AUkPv7iXjxCpwA0YL
	l3v3b1/mWC
X-Google-Smtp-Source: AGHT+IGbjSFJAyEmYIrbmrRb0yeJFBW2dGMo2KMlv5+3FIAq4zrRdXA+otMMWuN8ptuBHCZdh1GUfQ==
X-Received: by 2002:a05:6214:1d03:b0:773:b324:c5b2 with SMTP id 6a1803df08f44-873a5574753mr9567246d6.38.1759253878259;
        Tue, 30 Sep 2025 10:37:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-801351c32b2sm99165166d6.4.2025.09.30.10.37.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 10:37:57 -0700 (PDT)
Message-ID: <0d6e467e-1c03-452c-b8c6-a9d22a497ef9@gmail.com>
Date: Tue, 30 Sep 2025 10:37:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/73] 6.1.155-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143820.537407601@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 07:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.155 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.155-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
