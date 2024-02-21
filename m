Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D16480637
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 15:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708529873; cv=none; b=SA/uRk4g4QBh0xm2obbdusx/Lpwh27brGOPv4HPKwPSnFZ6T1O+5Zj0Ofhl0AmJCxdjiUNOfXK78fOjFQAGBzyA3CYvbz+HidOzAv2Tu9El6Nmd6FhDJ4UaTVOMj2xcGTPEmO+/cXMhjM5yt8RPzkCqw0k1Exq6P9LgYVqwnjEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708529873; c=relaxed/simple;
	bh=GVmjKweFpkvqNGNICWL3z3UdvYBia4a0Ku2Kgy+MvZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bTjcnTBl6qiM6fMX4Z3DeTfg31LiVSGNUKpmpM1EfGnyXH21o6vqBnX1kGKSt1wJzALbC6djg7yVN+b8bCCVasip6utPHc75IUNxs2dd33MqjFKndb6dNTAgGFRwgLFjUwd2GcaatBkeixeCK9uoq6ME2TAxpuO3ffKrWaWjZq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUIiHDwc; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUIiHDwc"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso107273239f.0
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 07:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1708529871; x=1709134671; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jgzt36BlzBXtqVbdNQbmcPDo4k/aD72MiYTSmtpMR84=;
        b=UUIiHDwcunphenoh+CWuJiEi6WZCJAP8QH0CJwUx4niIgz04F2ickUoqXGh0VQ2UvU
         tVLF4sFPbQBussyHxO55aJVr70KAy+93OIpgelzVYTrff4TXR/ipI1OxSlk3dQPD9eOU
         +FaQDwxsfk9Pjf02O8s/lhzHt/2NxBM9jdh/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708529871; x=1709134671;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jgzt36BlzBXtqVbdNQbmcPDo4k/aD72MiYTSmtpMR84=;
        b=eSzrr5nLtLrL2NdBu9iCbZicKqBpzPAevXGzyO+EWvSJqMWPYM3sy4hOVAj4GC2f3y
         Gzo43ci+cgelvPdiBHxcTq9zmngvgTMKa1pkUCNmlfuFiI/p149/s+qiHPB10sWgkOq4
         vYH+eMRMv9YJ1AR5lMIZFJ0ZeMICrzWZ0lsRUb/ZJQ87s2VSYHaoiEd//LaGNZ4wbBF2
         LeebgOtmfBiSBOmdrgUWV8v1tYyzk5q5PYbHWv1hhGwJNxym20EsqFyfzMK0W/frPGDC
         5EKc8LxlPJ4QiUjvIh3YcQblFRhMfj7SNcutRC4ChCqo6UbogpsAi77aVSAZte2Mc8Uh
         5Sgg==
X-Gm-Message-State: AOJu0Yy5ft9zL0mBSr7OenTVQoTq5uPbjTs7aD3OIruKh4XWOuxpElAw
	Ihe+tz4MhKKbid82Eky+t1qk5ETk0JdpzgYORhPnPMXJcHcQbDTlaKx1ZpIvh1c=
X-Google-Smtp-Source: AGHT+IExr/IvF/UtOz3IX45Dm147dWyye0NzXPRZMjCGqlL1L00lNeoZ+bFHxdOc3K9jwHGjAud59A==
X-Received: by 2002:a05:6602:2cd6:b0:7c4:9e06:b9c8 with SMTP id j22-20020a0566022cd600b007c49e06b9c8mr17837772iow.2.1708529871177;
        Wed, 21 Feb 2024 07:37:51 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e3-20020a02a783000000b004743cd55d69sm767784jaj.163.2024.02.21.07.37.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 07:37:50 -0800 (PST)
Message-ID: <63bdded0-e625-4a80-b85f-01032656108f@linuxfoundation.org>
Date: Wed, 21 Feb 2024 08:37:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/331] 6.6.18-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/24 13:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.18 release.
> There are 331 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 Feb 2024 20:55:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.18-rc1.gz
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
