Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC2D155A4D
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 14:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729003205; cv=none; b=CT+a+M+8dPnXxZy8QOilihW/H3kIkelTH8eKWRH899qnAm9kDwb6faHn6cQrT8+Aqd8cJFNvQVn7JP6pyRlAWwzQAh1FbjM4H2FNHYNlZjtmDIlMUFEkhCoEAeFBBW90EqBN01sXxepNr5cp56cawsCOf1DO8hN5osiZQRofwJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729003205; c=relaxed/simple;
	bh=gEQsPCTYADqg/5dhizFfvZ4cQV1lHlJa0/ecRwJ3WD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ro1MCiZK9x/fX/ADIQPSObLsyJ3Udc4lTi0ld0EMH/35DIxqpV66dj7Qg9PnScRBTJPjqvk9LRye9JMAJ/dMoLF9xQYgE8oyG0RVLFrn9vXPXEeVxPWNuBQrvzUpROh3vJk+UAWKJFy8jrm/W4FK/OLxRliQA3wye+xTP8PFwik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0YYyzVq; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0YYyzVq"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8354851fcabso225869039f.2
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 07:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1729003202; x=1729608002; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d/17tHLWfe/53Rf7b+xc0smi0gst4zLWfVRqbp2qAVs=;
        b=R0YYyzVqCdaDZnQHHz4Cd6sMbDx3FEuMBPv85afEkk0e406Zbudwx9KbA0cgnStXMM
         a9gde7/BhnikVkm5YnyGp/050buKMkFQAxSwKenyFM9m7wwzaJzjbNVUqO6HK06XwziX
         cZho3kIq7K3DLFddbcW6RQ+eLPkYzvRIsoi3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729003202; x=1729608002;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d/17tHLWfe/53Rf7b+xc0smi0gst4zLWfVRqbp2qAVs=;
        b=sPfdZc6zfpvJ5CfS2SRl3I4Z67uU94J7/Yll84+aEYpsg5SewAA29wisa/kQEh7FEp
         D8ZdFhrsFeG9903AhRUeyPei1aonLiDJyVrT5ev4HYi00N+Jaffb62kH9nexmUNxbd54
         w6VfSMsGUcCwtt5eix7Xpthg4SNi6DM7sIOkXj1OO/tfP08wMl/mEmMzNtT+yAuB7URL
         tPVUDsQ2ScH6e6HvaRySxw50JEu/3yHi8FZFudZsoAlD4mYJQaEJYKhSkpdZpghIoRc+
         fsCLaRyyjFRmjY/4U1DM3ssTZn/uEbb8XmU83WeYE0iV4LVytB0981y1NHqLc9a2ozBN
         1SPA==
X-Gm-Message-State: AOJu0YxycinmNswIwC2b812WpvMoxOI2NJ4/6JCkD3meRTMbEBnApZz4
	wFG6Aflcbe23HRaKjOJnsFM7L0IVjHGqyJfz1C8/OIrVRvI5Qxg561L7uLuSKQM=
X-Google-Smtp-Source: AGHT+IEWRc2j6bG7NtrBwrqjdEIVjwyEUnvvDO8Xs+c5+ba5zr4uxhAk5xGhq6A0cTdDDVSpjzHdXw==
X-Received: by 2002:a05:6602:60ca:b0:82c:fd13:271c with SMTP id ca18e2360f4ac-83792cf4b2cmr1388841039f.4.1729003202534;
        Tue, 15 Oct 2024 07:40:02 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbecb38c56sm333771173.97.2024.10.15.07.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 07:40:02 -0700 (PDT)
Message-ID: <dbfea7a1-dda3-4964-91ba-36cb25d8ef50@linuxfoundation.org>
Date: Tue, 15 Oct 2024 08:40:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/213] 6.6.57-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/24 08:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.57 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.57-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
