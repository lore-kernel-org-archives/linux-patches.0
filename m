Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACDA15B130
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 15:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721834620; cv=none; b=rx2ooxCDvcG3+g+8TMIz1qu63Bqu0ZteR+TvNTImDQ/pB9ApgdvgQoynAMk72tnEk2/AQKVMjWlxom8xPyhOEF0qSZB27l7W5Mu9ni8/vl7WuXOv3Oj53CR70dUMpYR9Rrw44rtgOJ4QLW4WgL/HhKldNkJnIZXeV9e+fXISNgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721834620; c=relaxed/simple;
	bh=CHwhPKFP37wEpm/ioN5s8uvmJdD/vQ3tGPOtk/Tlpfs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jRsbZHOVWLLmmBofeQyujXe+sEWgi3eZhbXYbc1WqRqEU2mdgKJwD47FLRTgw9QWuVHsOX0/skOSbelFWbHv1Udp1H8HCnPptN7drm7drx3BE31K43rqeRPmZkXFkXuY3hiWfsCg9OZFoYBbxtGgaEYux6NT8Uz+yG6SnhfF1uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqGo67QM; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqGo67QM"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-81d05359badso23694539f.3
        for <patches@lists.linux.dev>; Wed, 24 Jul 2024 08:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1721834617; x=1722439417; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W+2nty6cjNc6kUit4UjMRd4RIDNniOKhIQiJ55zs9FY=;
        b=dqGo67QMPSOH50LiYi59nnxEO/n8+cnwoeedE2fbTytv8+KoY/k/+pJevOJqqyDD1l
         vDmRbJJ32Gdtl3thBa5WUhRQ6J3NQwJzgY3DBM2JEevPmkOLqX0g1GHhpXQNKwFIoq/6
         +yelOcDNeJ6b0HJocPz48Or516hgW5DpmBNrk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721834617; x=1722439417;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W+2nty6cjNc6kUit4UjMRd4RIDNniOKhIQiJ55zs9FY=;
        b=uMQvEM5HB33yJlYFZJpGP97A3lMoXcTJAWrUUjcluErelQLyEj49l+hKa2nrMioaqk
         jdMIp5uo/hxLIZj5GEilOGtYSiDyaSF7MKk7G5RvXaSYZHi0fBD1YNXi+9s4GsSmZV7e
         Y5ohUSUsaGMqE31tP2F9jEHs4foQWogZzd8sqhP0m1VJ28EdDmp/yeilZLtIH1Sq1Nrg
         8ogcOuDRNl/3LiMpUc4u7be9trQ3Q9fyqGavXmmLB4k0zWQhmJf/YhODdP32yaF6Nzfg
         gAOgQvi5BqkGj5g+/Q1MApHdItJ+dadn4YEYT33aOR5PMOKxusBjOa4FDCOZfKjI/3u3
         vTJA==
X-Gm-Message-State: AOJu0YykjXroLmx74wFMoOtfvzetPpU2nSWpGNTzhQS3PD1pvRl8Tp2C
	XDk4ttlohwbVsmWguKZ0qVrMtshFGIe99ZEKYIuzlalt8WkkEUUdtnKJ+6KoU7M=
X-Google-Smtp-Source: AGHT+IHNPxpp8b1HKi2Mg5Fq3XRzdS+oQvqg3rS2l/yx6aMy6ymrH4MIQSeggOMeI8AVRwRXP5kH7Q==
X-Received: by 2002:a92:c262:0:b0:381:c5f0:20d5 with SMTP id e9e14a558f8ab-39a21777547mr710255ab.0.1721834617131;
        Wed, 24 Jul 2024 08:23:37 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39a188ff9b3sm6772225ab.66.2024.07.24.08.23.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 08:23:36 -0700 (PDT)
Message-ID: <3915beef-5428-4cc0-a3d5-59cdc1b6b35e@linuxfoundation.org>
Date: Wed, 24 Jul 2024 09:23:35 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/105] 6.1.101-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/24 12:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.101 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 18:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.101-rc1.gz
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

