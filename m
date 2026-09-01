Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3B334AAE9
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 16:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281107; cv=none; b=MH0WPu9tbaI2aZMwzYw3KS1bDpELixPIiiUB4+sqecoWy9G6Q2VB30kT+0AquUu8bZAdLdysJGEbWwwqrUQvbOrTakBX7rLg65DaMOaUAYJttmFgaNqtDgKQVMzBtU/NJmm2H/85nY4ZTPPVf7GfRynIeR05174VIDvR9KE3SpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281107; c=relaxed/simple;
	bh=+cWilfnQ/mR+0hb4VBv4GItJT+g95OWow+vJ1CeRz9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lUqIcXHDay2+jUa+1V5gDGrVym/KL8LBgliknnDmTzrXqwDZzdc4LkbzfRZssVRWIITLkR2KSIjdSTlhdFltvWWT0R7MkNn2FLYlg3UosPJsgFCVp2YyJuSrYP1lns6RjTmT4XrNzHmDbYDHhu4q5DnLkeVYcZJCva2SYNkGxTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7R1ST5I; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7R1ST5I"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-46a3a8001cfso45177fac.0
        for <patches@lists.linux.dev>; Tue, 01 Sep 2026 09:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788281105; x=1788885905; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1KdrPp5VH0W2M2cwjXR0uBfZIVa68tdnukc7QI0Ndt0=;
        b=h7R1ST5IdAFJEZt+BWEYTi6fr0u9xxYcYkHAWbPSlM03s91KTj1zWO6gtj5UO2rgUp
         WZC2a7IPBGh9qKsdhel/CJDEV1LX3LLTAjaRcHAV5B79z1mOMgr0nsUwemHu2UOdsixs
         XF0vwmO+9un/UOeXzHLiY8ubhZNBaLrHaMFek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281105; x=1788885905;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1KdrPp5VH0W2M2cwjXR0uBfZIVa68tdnukc7QI0Ndt0=;
        b=RU3T8T2OgIIjBuI6Evqr8oOQNDuEXItCItXbuWImxnnr2rcn4/Io8a/vCOIyc1lM5I
         /sfecgw/DVIJxfxVBYajow/hZZnzQ+/GZKbV9ipsv7DsCntAP6xVFSDinP5vHA/y6iw3
         cmxFgAxhlUI2wpAiRe4zl1OD9vNAfjBJ7m1YaL9zUmCDDZvRobhiaLTfzHTarDebVMmf
         S7OX/MlfnJKU/8QC9ALGec5jd0R3Mz2lIwxRDqTOcLizfNJQGeJSLT4H+pL1GNFcHmDs
         Z/IZlxA9TRxJ0VPyyHsvcLjgNv/mHiFbfk5iFTFdirDDC97D82VHIddClhLk4LFAL/fd
         bMsQ==
X-Gm-Message-State: AFuF++napfWUa2i2Vg3vtmgnL+vMnhs0kPZuI96ZQ+H+CFze6+Q2qcYc
	tdxuTxNp8cXjNzD4vzJAlQ+WSB73I3wkgr1yMwoxHZVx8FXRg+7fXC1BMaYqPjYiNr4=
X-Gm-Gg: AR+sD12y5b9SFKGcdqiRHcO7TNfnWFsy9FyuY2/AZl+58FaE0vt51kKsAsgU/V1nl1Q
	tZZXgSOydhBTaKjzUiHpiJ1v7N6J4rqOIdCXDUPZTkXjY1x50HBh5K7iwZnKoqudEdXJHr9wRHv
	JVEKI8q7bjagqpc8LNOG3KmCBE12O9eex2qHXBtXBJNXm/QVMmEss/Zf6DVQ5rrqO6dwTnA4V2d
	Px6ZY0vkBmYnTGS3flKDPKrwiVEtcu5VXP9qDvGyFj/YYzCb/FEx1naW2dCLfId+2aISMit8vfL
	ABbN+Hzr35Nt55zlHPAN3+M9dpH1G36Qn7rhHGGmB2Ak3OpcLKR3iMGDJq16uzo5xlvxvYagqOm
	IJ+wpdNLGm/2A1GUdZUlxWtdaEg0uvWmpY+zgInlebY5hgOHYVXc7AZIsGEA46FEagIjXK36qN4
	fV1UlXMH2RfIgbr/dZmGoKB15ifiB7POV9rqBLdH7fUT7Gq5n/LR2ZM8834XMBs5GYVXEA
X-Received: by 2002:a05:6870:1652:b0:46a:ed7a:e632 with SMTP id 586e51a60fabf-46aed7aeb61mr10900715fac.14.1788281104747;
        Tue, 01 Sep 2026 09:45:04 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-46f30cb5a17sm189702fac.8.2026.09.01.09.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 09:45:04 -0700 (PDT)
Message-ID: <304db74d-2a7a-4fb2-afd5-e21489619c83@linuxfoundation.org>
Date: Tue, 1 Sep 2026 10:44:56 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/83] 6.18.49-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.49 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.49-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
