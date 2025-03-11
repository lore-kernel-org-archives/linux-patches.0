Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DAB25CC65
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 16:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741711642; cv=none; b=vDyzIqXqAZ4ar7IvcgZuRHcMryYF5y/yjNakz5IqwZpbJpNG3dpO9oLw1Fnfoomf1E/Q6iLj5nXM+ig50gR/27dKNOxuGVSlnpWthTNVzpTualqVHjGESNaqeTjE2KRpFs233lGzyOu1SmHEX5AX0F5qZhhnrJcEy4pq64adhu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741711642; c=relaxed/simple;
	bh=Lr8zNkZl809MOIhPoVDsIbz+X1gMtYCv3KwPHC+qhBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qYClwmyAe7Bj8bgHBRu2RUeWXBUeKj2ZbUN8DU1aI4sDyuUxSlWKTzFaNdChOjCMDWe2zsNLToqmCx1JO/JSr0OQs31wc1fh4IqSnAJ/GGRDjB1/LhYrfOKejKeT3yOXNPB6+SaUa1Y5d61FWxao/4aPeTYawyBpypI8DtWj4Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcNq5j6D; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcNq5j6D"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-85b40c7d608so252884039f.3
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 09:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1741711639; x=1742316439; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ya/SCcQg5pOPa0gL5x/xnC2JbLciEJIK5frt9Hsnh0Q=;
        b=TcNq5j6DWMNSAl4uS7wzUeIXRuxJbmGu0w9RWlwH1ANHmaqbf3/m7UemeVoy+PKzng
         O2y5kLOG8A/OEQ3IzUtBlr1pZxndMPtCJupZX/sR1MftSM8ommAWmBjU9zgJ5jUhGuQN
         uju17u89wfRNs6E9gi5kSQu/3lf6KqESaekCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741711639; x=1742316439;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ya/SCcQg5pOPa0gL5x/xnC2JbLciEJIK5frt9Hsnh0Q=;
        b=nEQlD4zWvA9KNShAVqBOxoVolpOTYJQiocJqhD1YizD39tBlS2sukN05UAhRRFO3LZ
         wFdklWT2WmexulLjsAty4xvqS8k55DjEM+5FohcKTzv6wqb7PmrjYv/DRry+CKpJfLhG
         dhHTXmWeGIqRN/tBLfKNayfC0t7cVygi5uzNdosB4uPgUdjF/dgvvjiwOcixlFhX1s7z
         OvXfTHS3MatRblQSP4jBcZqFPMpdRn48LqQibfYl/9s6tq9e/tlo4jn7nALNbOEw5Vk/
         4ohyzd0J+4OsGSOF8GmohN2WGw8fIMLKxNSWNty3zpB1+cvH/Je212zwtXeuMleblPsB
         4kAA==
X-Gm-Message-State: AOJu0Yx1o8paRzYx1SMVyVbsYq8YKdRSncFI0o0qRTWNUqBs7oPoyetw
	a2EExTGl6Bdh57Bw1ELQI93vqRj2RIDOKRKE5ILqSAps//rPRTdTARCENqWcOxw=
X-Gm-Gg: ASbGncuojqvFCR/grAxkXjJ2x0RYuDhDZ9pZ8rNTRkHUmZVowmBohsFbFtCyQaFQmbS
	LIx4s+lBHjsytYuR8P6a3GPwK2Bp6oRL+BYJjAHy1/UsCTyAkrztA/v8HWIkwnrvqM8GTqLOpO0
	x6c9CRWdosUnTA7iffpF4Wo6jcQIbWXIPL1XqOyX8ngnzwCr2/Deux58I6G+aVE8/S2uNCKXXhE
	L4cj2FlTkgnaDmk3rfa2M7SXGlHjTFop6RAEiSgewJu2up6NCkoV8lO+p5h9anPxk5X3AuosZLq
	jjHXFomZ3J83rH0SaJQ+YcgHqxUjHiOw4vRyWv5NCf0ghA6RSKBI20c=
X-Google-Smtp-Source: AGHT+IEQgCPhuww2FzPObKtYHJfNUKNZ4AwdoQI2ZwzxZCEL5p9J6b7jq21Rn5Xq7Ea+2Z1UlrfUBA==
X-Received: by 2002:a05:6e02:174a:b0:3d3:e296:1c1c with SMTP id e9e14a558f8ab-3d468921f95mr44132895ab.9.1741711639211;
        Tue, 11 Mar 2025 09:47:19 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f209c55460sm2827091173.0.2025.03.11.09.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 09:47:18 -0700 (PDT)
Message-ID: <eee86dd7-68ce-4147-aeb0-e009aeebb80f@linuxfoundation.org>
Date: Tue, 11 Mar 2025 10:47:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/145] 6.6.83-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/25 11:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.83 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.83-rc1.gz
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
