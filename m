Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D5C175A5
	for <patches@lists.linux.dev>; Thu, 23 May 2024 20:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716495707; cv=none; b=m93HavU2nFry+78lsOwmRdZPWy9DOxtJjA1SlvHRvf5p1aT3oLFnWAa55707+z8LvzS+oPzNPADu3pKyshysUqFKa4KeAbfJ0wZnNla/xHcp+K7G6iINyJFYcqvoPAHC6BAtOe48Jc1ax8ULIqQNu5rWMhUWxZmC55Rsq7bEzP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716495707; c=relaxed/simple;
	bh=xFPhAF+c5QEV3qf+5MftTNugrA1PKs9N2ZFb5mAFR8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Be0zKfGM+ulmBGftPRx/ZuVudR/w8a+k7XbtbyWI96fcPaHYAmYy1ZwClwRLkX6B8dd3cwGdVBSkYRHcgSE9+IBbbDX/gHXiq2aN5Mksp26ZNVrFNIN3rM9KB1lyUW7EMhK3V3mw0OAV1rpTOTXMIQ0d5RqVIfdQHaSkQrzD6RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pwm5uxAN; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pwm5uxAN"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2bf5e177ebdso85908a91.1
        for <patches@lists.linux.dev>; Thu, 23 May 2024 13:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716495705; x=1717100505; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YLMUv+lcr/QWFTV4u1WTHn7mf8KnhpBd9b1FZrkGgZ0=;
        b=Pwm5uxANcXDZb5iGiOIa89X3VghSSyOxyIA2lcpsrgA2wnXDnMYwHRScEt8ho/4TXa
         NFNwPyc1qAUeXA4KY6ducxZA1+AwmKdlcOEWNzXkSYyPcaz1JHegnmZotY6zb0J+Zhr3
         IL+1tF0mrWa9cqQ1QC0PDQahw//GzB5z+u4OKr5SonZ5iuB6XxhEJFXhuEdTSdLrjjNh
         I7GZSIKv8/SSLrJ1g+jMK3FbtZdoVf7DMl1gmxc5J2lDzk0WMIxdhOkfvrUQDTWNMo1O
         143U5zv8gL73DRWTVHxp83hlPfFI2tyEStd6gmdDw4zKL5149fL7wto9EbqmvLPOMGtQ
         01Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716495705; x=1717100505;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YLMUv+lcr/QWFTV4u1WTHn7mf8KnhpBd9b1FZrkGgZ0=;
        b=tPkKsJK83jZmB6DRfkVi09SBrGDdc/BMEvXZSEIjjKwDpBv2Lsh5R1GCRceBz90Slv
         EiddPGPwqPbtqO8POF5B2txsDAjyHQQCyng7n26cUX5ALUGqZwnlPy5afgKcJIohSdtv
         ird9Cg9gOt51L9hreDO4nfa8kO7GdLbv6nFJ+wwO3uaBu0GqWVxIUiZiMk4hnUwbcIfc
         69t2TcPTJ2DzzOfyRqWmRXuDT0IwSJCvjHoPJgxYiO4dF+N+xkVn/zg55gs9PzeR2ATx
         Jk8+dLwYhqFtc87eOpHTEXAxmLU18EG8JHxxB2HIQiAlfQ1BaZR4WycV0TkgQVdtFDzw
         +kKQ==
X-Gm-Message-State: AOJu0YzK9SxFSgn6tTw1XffrYVqVi/PldboD4gCfrwr3T1FfV5VWsjyM
	HeSdeaGAkO7QtDLSyXTL5shEVnKH/53F0cqAyWkVxVUDvyqTMM26
X-Google-Smtp-Source: AGHT+IEP+8/4v7Ac4RENllwAWNIDui9pwuOgSmeJ+NMPaISNVgjis+faohHNev+cfODhvoMJ+MS4yg==
X-Received: by 2002:a17:90a:c082:b0:2b4:329e:e373 with SMTP id 98e67ed59e1d1-2bf5e84a9d7mr284563a91.6.1716495705402;
        Thu, 23 May 2024 13:21:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2bdd9ef2182sm1961359a91.13.2024.05.23.13.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 13:21:44 -0700 (PDT)
Message-ID: <a994f8ce-2c3f-4aa6-b345-bb443b133804@gmail.com>
Date: Thu, 23 May 2024 13:21:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/45] 6.1.92-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130332.496202557@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 06:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.92 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.92-rc1.gz
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

