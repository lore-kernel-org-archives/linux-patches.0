Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C814118049
	for <patches@lists.linux.dev>; Thu,  2 May 2024 03:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714618938; cv=none; b=omISzdJurWNcMnSsWbomc28iAysE6wieO1ubzgvZvD3R/PTUvAVZ6h0Fgq7BjoVwm9zWozJAM85kS23Cpy2KKA2YhQYCL36HsLLaIL6goRvCqaSKs35FBe67fb3tsuR3D90iFgRYKzstrhmZwUiynNSpEf/Lm1DjqtsblqPXUko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714618938; c=relaxed/simple;
	bh=BrO6sR36R5N0le0PyCco3GLRO439I9ECeSVrhMyd9Lg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eUPW8AnGS/IcccP1Lw332fajnakzJPjHNCEoVj9wV5SphF3yoPy9veFtHwIVnqUmwUgy1KGZv8mF98R2iynmNRRTEnZfAI2VganLcxNj5LhwDAyFCJhCqcJZtJrhLGTIGjvMfHImyRagW0hcPdXVkuEV/+3NByTrvYiGglucr5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/8/scKR; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/8/scKR"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7d9c78d1087so47890339f.2
        for <patches@lists.linux.dev>; Wed, 01 May 2024 20:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1714618936; x=1715223736; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EjNlz/0kd2mNH4T0WxI7TxdTu+LxmeVSYgKdgcdHPyQ=;
        b=F/8/scKR8NL80vvFOrIq/5YgQAM1GwV3vOdbaFmcS/p+/Is/S06NGiacTCU2gxvzyn
         wptO4QJVBGwNG6K5wIygiZjbLG/pzTXR1VG7F12YGi1ix6OFSsCtA3hURzWS/41TztLm
         YNw9Bt4kCHi4oWmcqQoyNUwlZRs9PkLLp1r4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714618936; x=1715223736;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EjNlz/0kd2mNH4T0WxI7TxdTu+LxmeVSYgKdgcdHPyQ=;
        b=HHYNBtmd4tnl8sIJ6KK4Qv2qrVlQoVtyopg89k+XXRMXCa0nzl+PxtBD/7zXUnnzLW
         eEeQwVa7VW5TnX5vtE8WURnCH46++nuI0k3xMGCwhGVQ0jOT+/Enzd7XnqNgnRMwNUZ0
         rSsW3Ysn9zQePUigtQrtYsEyqTaGlzOPgQ3Mwwq/XOFBBbyU5Sdb5iAKEVwRIfE1s5Pa
         Gpr2EURC2xdLUNzgq2fMgGHu1l8i25XPF+9NsMj6pZx7MWJjO7P7zBkVYUYxzWuUjtu+
         JblaXy1lxaKDj12wvI41HXpXyLOyt3ULjPo4GkV9nPKPtS6qkTvVaaKYWOTGDnjnTdjV
         9y7w==
X-Gm-Message-State: AOJu0Yz9nDl6rG+bIW6KTSKEhvbGFSWrtYtaYvoSQqOaj5vstSqdYzME
	HggZJTCM0HZ8SfNgqN3MqC2s/ZwLPWyP/BZY9ZZRO1hUM7eiQeHom5v2a/SiYHk=
X-Google-Smtp-Source: AGHT+IEOuAgdk9W4YMfkruIQU7JI4kuh9SNxi71Q6WgY62QwA9r9Ov3Tyn+mqjPjcs8/YxqfbXwpJQ==
X-Received: by 2002:a05:6e02:13a4:b0:369:f53b:6c2 with SMTP id h4-20020a056e0213a400b00369f53b06c2mr5302970ilo.1.1714618936102;
        Wed, 01 May 2024 20:02:16 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id r5-20020a92cd85000000b0036a3e54b6b1sm11450ilb.13.2024.05.01.20.02.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 May 2024 20:02:15 -0700 (PDT)
Message-ID: <bf2aff2a-d243-4b5c-93eb-3b6ad371b24a@linuxfoundation.org>
Date: Wed, 1 May 2024 21:02:14 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/110] 6.1.90-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 04:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.90 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.90-rc1.gz
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
