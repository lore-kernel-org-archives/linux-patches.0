Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5637711C
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919361; cv=none; b=N1J8E62LHxArjL87hQDF5bK5EIQmZF0ZzuQXEtjFYUA3fRNRJHdjHav+pSbf2XZozYsacyfBP4SrqL4nlzi/ahSiD+y4bp78qkCZoNJV2kMKYiEvBYrMrPYGg6OwyzQa4tUy+zCMT3Ei3GOEKo0WaUmlFdyIsUaUbkL5eVLBiT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919361; c=relaxed/simple;
	bh=ZTcgaK56+v9pAJfpyBCcK7AMQ31SZcS+ia5+MEWwcGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SIRWYGATWjzziUGi3GfkNfNw65ZF3PsQnJkhtnPvCBtJ0VBKJMVPmoIVU3QItmlSKa+q8MxCgBOSqq3vA10VAigJfrwzp7fmgNbfkL/BIWHeYCzGvQjXehceOKW3jfq/kVRNsghvmsNJSvM8B6pbfpUy8PIBrK6fXO0dDD/VVpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LV0d7xDp; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LV0d7xDp"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7eedf4ae265so2413839f.3
        for <patches@lists.linux.dev>; Thu, 20 Jun 2024 14:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1718919357; x=1719524157; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f9ofIQLYPdOS8TshOJj7rEW8hxg19zcYrASvxB8ul8U=;
        b=LV0d7xDp5cU41l/VwnvlqqyrSVTkuBx9I6aBoaBthrpDqFOvdcZafCgZZ3lEqpy3jN
         H5m4Lti8B6wnqzn6GwAIwWIne5FDwFo5rDAC6KrAuK0WdsYb20XAmm3bShtyRlES4cBj
         3SMYB8ybmrJd/2BDQpE0Mi8WTnFQ/i65JGlX4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718919357; x=1719524157;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f9ofIQLYPdOS8TshOJj7rEW8hxg19zcYrASvxB8ul8U=;
        b=jc8aUBdyTMOhuIJmCIs5aItEUZXqht3k6u28uYYNNcq+HQF9edXIDg61pL+oVFPpsj
         wIhgI6RihsGZnIsCKRZkAEyPt9hf70Z7mLCJ7wsci2GeyEuYzkrBvmnxw47zvi/Q6/YD
         m5vwKiOVHoCTRpqOE1CUylkuUV9jbLzvu3wt+BltHQ92aDiq9gugCV2qOHfN3QBN4AJA
         YIA36AVCyrB3gDtjW57ceDhoe+a4EMQCu02vsctsoaCQV0rPGQcXbgIJCIrWzy9djn7n
         63ZebxUc5yVtOHDmlcAqPSI0XNECopBexALtXI6awVzFLHM46RHxZHBMbwbLwN0ejwD4
         NS/g==
X-Gm-Message-State: AOJu0YyoYwXCIU9ObRmy+Sf39zv/9vNdGSndvxeMhVunFYNXsxelw3wc
	bM6z/QtmN5TLvuUEeK3cRm2tJtmT6OBActGQIlMralO0XE7W6i4O8iDsgk5cUC0=
X-Google-Smtp-Source: AGHT+IHqCribPqhw2Ibl2+02wGY69rP8DtYR7MopXoSYep1ws5H8GQkoWY3heLjFA/IvrIKssmwzyQ==
X-Received: by 2002:a05:6e02:1194:b0:375:a1e3:d66d with SMTP id e9e14a558f8ab-3761d627f10mr55203895ab.1.1718919357283;
        Thu, 20 Jun 2024 14:35:57 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3762f38bafdsm434325ab.62.2024.06.20.14.35.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 14:35:56 -0700 (PDT)
Message-ID: <fae309ae-cd1c-46a8-b6a0-e34e7ba7c44e@linuxfoundation.org>
Date: Thu, 20 Jun 2024 15:35:55 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/267] 6.6.35-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/19/24 06:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.35 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.35-rc1.gz
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
