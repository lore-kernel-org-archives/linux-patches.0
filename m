Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8541BC26
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 19:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709665312; cv=none; b=p1j8EuJFA3/z+sNV0ohPFAlrrkQIZlo6wXnMsBAoRRbAn1T+FGUHPiqH0AcdjHyGmJbJ4KmYE2n1TGsHQF2AKDsHkv5F+GkNQpuid38OQvrYigiYcnz8nZeiweKdGA1FF+5dvwMHuWTwYz9v4119pAKM1Gr9g/wMIRnQN5kOGaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709665312; c=relaxed/simple;
	bh=W+RIx2s7YMjsH6sJS+7De6hX1x7jsNpUAzQ0NlcFJiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aBx+36/YgvpGipdH38TgikW+QBYD5WKNNEw0b+EbGMj6O6BZclzZGwQdrfYPM5CsXrdCmYU3ZH6xTbbh5QcfkaVzignp8jP+kJ50DQXV5qaq3khJlkG64XZ9RRDh+HpVOzK+uZzffpKtRPzzX/ETLk8l6OeOM5k4cS+oTs5G7eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7k+IsMf; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7k+IsMf"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7c84125f416so43158039f.0
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 11:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709665309; x=1710270109; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=phLlY2jti9ivqH/MD/B8hzSvaQLkns3JMxn+/mmfZ+M=;
        b=f7k+IsMfVMBxHq9P03JwfMCyBO6vejO+rhFUCz035TFYQ30FTATHQ8prTnCTHQLq5v
         PxZYznzfHgi2cXGdMeK2lsG9H3D5c2zm4ihpV1rOqmbk5ljRX0mkwY5f3H3iHP0GP+Kt
         Q/bok6s2J6F3HsJEcry9WfgDOTeARvufOwtbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709665309; x=1710270109;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=phLlY2jti9ivqH/MD/B8hzSvaQLkns3JMxn+/mmfZ+M=;
        b=sGvdLSI1wNSvuqwftmK1lm1miEg23WJVGUhLba0yduaFGv2Z4bjyUSpptCd0wzGN/c
         BL6/Eem/froZ/tk/iyhaNxtV3cXrSPsB28TwPYgg3PLfb0bjRdD5ru5vxe5ixOtHeUSf
         vtX9Ad/Zws6tG/DzGUwaE5ijl6+IFPnshwHSuqx+13la+/IY0WbKLTASUvxXWJmTdWvB
         We4LHoZ2Dp826aw/wy5o9zVtshDpqQ6ZYs4w1/+y1rZQIlFi/ZTqocUfBHN1cCU79oxs
         fT3pW2Kb23JoQmGIOaAA2c/X3PVr6VlJTb3id97d00yGH5nCZx0nEKMtwDV48/fygX20
         fEAw==
X-Gm-Message-State: AOJu0YwuKouTexAB1ri30X9H3hH06uJnqmsbOHQ8iX0J2pnxHs40wYuV
	pI8ZUSICaM67EWWZTBQ3GkSVVbdNS2bkNzJbCHixhRUH5h724fjZ9FreAI9UbnU=
X-Google-Smtp-Source: AGHT+IHPMuTBc1rTAxSyEKpsXnbRwfQXwOdorpfvId7aMNK3EeNnLlymF5/PNN18AAz8Vd4mwqm2gA==
X-Received: by 2002:a6b:6b15:0:b0:7c8:4963:5bb4 with SMTP id g21-20020a6b6b15000000b007c849635bb4mr1607918ioc.2.1709665309410;
        Tue, 05 Mar 2024 11:01:49 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id d59-20020a0285c1000000b004748b445684sm3126093jai.21.2024.03.05.11.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:01:49 -0800 (PST)
Message-ID: <d8df9362-d0a0-4994-bd2e-6bccaba95111@linuxfoundation.org>
Date: Tue, 5 Mar 2024 12:01:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/215] 6.1.81-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 14:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.81 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.81-rc1.gz
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

