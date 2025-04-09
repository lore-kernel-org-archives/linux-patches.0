Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C145526FA5D
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 18:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224321; cv=none; b=tr8R55u4bRN6alPkaNDGa41bRUBKYAW0BxBMRzY1PgfXjcseovCcquHRW/8dphS7Paa+04NAgcFE+ZTz25T/Cj1crhcAySpI4LaScU/hzPB2DvvYNXpTXvp8CbRavfQQXWAHFrHXrkbIQO1+RaGoDGXJyQMs0M8YDPlSKHZaRrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224321; c=relaxed/simple;
	bh=DE94AF+o8GAnUH4MVceaHQSwr76zM1gbMHM/bt4QTz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aubHq+KPEPWWMJsmN5N11K/fr2ESZc86RCjedRhbQg7rMPFYQgYYwY2zC6AV8K9s4kOyGmPEZDlapjt52esaFfyGzQD94dngNn80ZvjAvUyXWI4wayeuhfe24DQ8LsSOOPV6hrH3flZF4rZ508X2UAGJzDEGsIlkqxhaC+D231g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGHouplt; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGHouplt"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso206575ab.1
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 11:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1744224319; x=1744829119; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SovPoqcq00HkS54A0arEix/uaJanWscLaN21MAd/PrQ=;
        b=HGHoupltAqmu4RTbm0EelrM7REWwx8/DosOBJOmCtr5fX76FWGvvusDOfp9QEVNbJW
         9fhM6OlDPKZgHZMRY3A+cF2NVcsarB5/GYobhJQZzLE0ZUEgxRlUvLBBr+XuuM+HAT+G
         cLlH6eyAu5jr9RXEIpU1Guou2IlkRrT/PEs3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744224319; x=1744829119;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SovPoqcq00HkS54A0arEix/uaJanWscLaN21MAd/PrQ=;
        b=W1k/R+spZeTxgCu/xhg2Iago/Nb0Vo5kZc9WlQwOld59ZwISFn1dxGl2z1He9a9QHS
         362mfaHeJvqlH9CStUdBxJIvMC09rsBq+XhwmTFJfGxoiEealhBm3fkFwkPB2qrBeuZC
         TcepTXj8P4HURSVKpB3T+fnDooIGwsIVpOb1gwOMwZenDymabXBeB98Zv2jB0a5Lxs1a
         Udlvvj5YccOYOOF6JUQ8o6Y77ix2ZBzRRROy5mGXF9JxoKu9jvKrttvCwAcxfzEZ+qMJ
         yt1nJHYpLkTx/KwysAyiNgVzg6mAwPYu44JaZYiI99orMJ71Kiw9Ssib5qbJaM1VlyMq
         3CtQ==
X-Gm-Message-State: AOJu0Yx+UCTz5apLJ2zwWg4XsDHe+kFg/PU0ByyyTR1PBj7jmfIzwUuy
	nbWjGEFOQwP7K772zfUulbkuJX5RZIlybE/k6vhiSpwRLjUzms2ZdzDEJhzI5xA=
X-Gm-Gg: ASbGnct7D4ax6gvfC2u2EQ0oksVzXiH1+QDHo9+KUkYCUYAVitGh0Dr2Q7O2IG99R4N
	KIKI6TK9gHQeo0GoR0UIPosnfqbqA3E88Zwzrk8NaRAsnZeb98+rpnbVjZeRupRPPI7wZXRmDfP
	+ilUY6qXbPZQireDfDiufjQIC27lM/imuTDPX5vS3H/spot2CEZQKeKIamdwPx14pvjnWztj4LV
	ulWfh8SLnEg0Z+aguXj0ZqcIGIJiulq2Mub7hUA2O6pBOYzcL8PEbq2Q/F9J/0Fzk7n9BO7Yndl
	OwH2QBmKYsSC2qLGon36WII3gYzm9LWnRAbW6OnMmw4tukoqFUCx4ysskcPdDg==
X-Google-Smtp-Source: AGHT+IFt7sGM71TKjQg4Zk+NkDUv8HxSgsY1JlES7yCnZRK+kvYxcZDFPFxB0ZS7tX5AtgSmKJPbcQ==
X-Received: by 2002:a05:6e02:3c86:b0:3d4:36c3:7fe3 with SMTP id e9e14a558f8ab-3d7e46f8e7bmr1712175ab.9.1744224318764;
        Wed, 09 Apr 2025 11:45:18 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d7dc594eb2sm3769065ab.70.2025.04.09.11.45.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 11:45:18 -0700 (PDT)
Message-ID: <4455cd1a-cb95-4a8a-81ad-ff2cfb6c96ac@linuxfoundation.org>
Date: Wed, 9 Apr 2025 12:45:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/500] 6.13.11-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250408154123.083425991@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250408154123.083425991@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 09:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.11 release.
> There are 500 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 15:40:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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
