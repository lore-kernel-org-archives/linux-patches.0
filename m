Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A0118563E
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 23:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720567670; cv=none; b=mtde9MpDANX7kw6bk7kYp950CDWzYeKOl7eO7TuN8Y7By06Rk4x8RLkZfgBxPrxKVWOcS8vykhg4stGfE7AOdZ0ZibIHocOfGepWqnPFf21aI657dXwKJZRvSmUGHC3N2su5bEDngAnALtiSPObMVYtyMClaD4gYY4J4dPlsTls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720567670; c=relaxed/simple;
	bh=bN308Ak1eVxN7liymrO8Kbq04EbBFuYqeAxmu4CZUMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=USnRltOHb1UVNRTfGCroaQ93rEuWiiqpUxinMc4fclEnRmBVLKXjzJvvqTUev5jrksYr22bZjt2M8Qvme5zBwkD8cIjLgOFTN9m+ZhJIBUyqif9/guSzLg3TAzVWF/8+6kqTGrXsZ8OGx5xHSpceylTUJCuuwEwg3aP+/8tL5rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzWDbFvR; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzWDbFvR"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7f7c41f1bb5so9484639f.3
        for <patches@lists.linux.dev>; Tue, 09 Jul 2024 16:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1720567667; x=1721172467; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hN+zGtG+lpLqh3rj/LWNJow6My9CNxUakZsm7WJINo0=;
        b=FzWDbFvR+RYJ3KYgQEOu+cAWaeO6jBMVkog916RVK4bZFVEomWIPouAlUO3yRtlOl+
         pX+5JEGzFY8AqSTp7KjnVDEe1Z9isNIWRK8l5oMoiZLHCQ6Wgt34TxyZ176inlDHbEp0
         4q8P236j4xqEGjz3QGPJwju1bfvC8r+HCyMgw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720567667; x=1721172467;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hN+zGtG+lpLqh3rj/LWNJow6My9CNxUakZsm7WJINo0=;
        b=GcH24IpiBGhjcGCBkF65v3CBlsq1/GBzYg8Sk8NlouuP1W7i9hSbpP6804LOuxmX54
         gViQiQWZKkK4hB+GDQsmFdGZkHkPjMqAymhGpPdq2aIOMTT62ltbtsDdYNR2rBqz+jVf
         CsSM8GUdFIbxonHqFZXTTXLEbrAeYiP5pMvDyvVs1MzClkCm7BPv4qKX585n2BuPE17s
         Tr3feNPdnEh5ID0COH33Waf8tGX3CKZgyzG///JyavMQlCW1JlKM+LeZwibkEKEbFmC/
         alG3SOodcI5uSTUhIGxXjWFudcW3e8+cn6YWpQJmlBnBV/2b23NrhbHxcvUaMKygqfLh
         6hJA==
X-Gm-Message-State: AOJu0YxC5rCC/UoH6cbUbGgqfpJ3NQ8O6DcxKgbYKSlq4jm+GmRIgITu
	wyceh4erJPA81Aj//M4pLsfv4yRW6c7aHVd9TVQ6L9ONpzOxc6eqhvN9shguUQo=
X-Google-Smtp-Source: AGHT+IHN7zvMXlKF0MCYNFxz8pUQtRkWZuf5jDM2utPMsy5yxujxjODTSAh6OLbkAjkKw5pW4HhEaA==
X-Received: by 2002:a05:6602:3413:b0:7f9:90c5:4107 with SMTP id ca18e2360f4ac-800023b5fdcmr526987939f.1.1720567667085;
        Tue, 09 Jul 2024 16:27:47 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c0b1bf80d7sm742754173.117.2024.07.09.16.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 16:27:46 -0700 (PDT)
Message-ID: <152abde6-1c03-44e9-b793-5a1275361287@linuxfoundation.org>
Date: Tue, 9 Jul 2024 17:27:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/102] 6.1.98-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 05:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.98-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
