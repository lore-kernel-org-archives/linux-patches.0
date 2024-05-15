Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4964813F422
	for <patches@lists.linux.dev>; Wed, 15 May 2024 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715785648; cv=none; b=OoRkGLIRDVZjn6t4BwyGEF7i8zekFRUoTyhoH6Rvu5DDrH3blPYA87fUEKMBZ4CknbbHLWqj6ec/kDx7anKIAtwWUZJxd2ZPovagXuPn2Gqu/xg2UlJH7PxzbcH1WaFxRHF91grAqPnXH2IUFw89ZeQxJVy8WEdGZZxThtiB0BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715785648; c=relaxed/simple;
	bh=M/mp7kjcGr8DnRpHH/QucuSBMAtXjGtmEfL1icHFFWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EB1bejcazDS+35bRc1Jm7oNUdaPhunteVa7ZyOQVDlgx3HFkSVx8q5f/DgmRNKqorVRPkPzuE/+j2d/b6SCvkxeBUYXzeM9VrUVHCtfbU6GYBeb7x1JmD8pnoe1FFLH7Wq7S3HtHZSCYS0orN9XY6nJENnMuO5q0ISqwnJWt3d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXK97TqX; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXK97TqX"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7d9d591e660so23693639f.2
        for <patches@lists.linux.dev>; Wed, 15 May 2024 08:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1715785646; x=1716390446; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3toXt9vYdwBFDAxiXSkPst6onSnfmkqqLWL2VMwMaow=;
        b=MXK97TqXHoQ6GherrGJt7tO2DQAtyS2+RNLF4J+LSvdwYkedhcowr69WN0wg9MV69W
         xZUaW1eMSvVd1l1xl6LAtPa2OTK04TUb6DWjpZFdBe4mUilw5dA/XIHSihbaJeZXMRVi
         ja9uMpL91voNtlaTu0vYRZnFDkY7SZUSADHo8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715785646; x=1716390446;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3toXt9vYdwBFDAxiXSkPst6onSnfmkqqLWL2VMwMaow=;
        b=nkQ8UE9GQyqH+SCnZwqYwLwKd7O1J/tuLixU78/u/BMjUDFDR3W65dioNqwkGXbMzO
         usC/S4OnuqecuoyA23Ef98WDFaI2NpY3tEy2sYuPKv1PZ/9edC+HHfRzlpMqp7TeH2v6
         mEedFFu6oL/GzOQReL/yAkDF5jaKX0Ev/+ic9eOS4vMUnzQzUQkeZADSt0ebiFa7JLgD
         zGLjxMjQGeqhLHuiXiJqhz4+6/YTRQw5fjGbi7sLfImPtUXDxTzyvEhNlAWK4GA3WHuD
         HM/oId9141o5U7YaRnhjoe+Bb4F+/mVg92hTt4YMTChJwGkkndZ8ZRHyp9OVjlAZYtT+
         OVVw==
X-Gm-Message-State: AOJu0YyBILbMS86+9Z+zjUnDWbMZuSKnH2IZYFrYzTMnCJvoA+8jaXV7
	tl0G8kbvtPRUzOQ3UzV5o4oi18SI+tK4zxSbgyMDZXhIgdgqpszWvfXWT8rXGxI=
X-Google-Smtp-Source: AGHT+IGvl3dpFu7VxMte1m9bU4eJetyIF8et1w15eYUBYC9PnEP9jff6fpeWugT2rmJoGIQyyzvoog==
X-Received: by 2002:a5e:c748:0:b0:7e1:d865:e700 with SMTP id ca18e2360f4ac-7e1d865e82emr1176690839f.2.1715785646574;
        Wed, 15 May 2024 08:07:26 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e1e2e03bdcsm174171039f.32.2024.05.15.08.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 08:07:24 -0700 (PDT)
Message-ID: <437d33f2-0a91-4675-9e1a-f097b174de7c@linuxfoundation.org>
Date: Wed, 15 May 2024 09:07:23 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/236] 6.1.91-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/24 04:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.91 release.
> There are 236 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.91-rc1.gz
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
