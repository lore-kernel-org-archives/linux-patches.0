Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5688A26E148
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 18:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224259; cv=none; b=RNhphkkDDsP5u2gGjnQVqZxQWva6tFsTw3IpFAsh+8+07k8qG50KrWBoVITru6n6646hUeIDHXvwrv83o8iY3jS3a9Ymx3d07f1YDArwGglxAc/ASXnHqwjVY+MvUpaZZkk8cKT8WiULABR3JhCUgEjniV6q/QDHoU+/xhSPUHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224259; c=relaxed/simple;
	bh=cLRXd2ba2CeeSosufDG2CuR6OG3+lGXoinJjPTZG6jA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G1CslGfRB6GJNVMQi0+3nkqdLZZWcjN71YunWxIbsYFhJYDaihleYPkR2czeZStWwe+MuA/1pohMXVjPOIFuHXvyjQJ4idRuZQ3rcgQiZAHiZUx5sHZ50fLEq9k0pZtgmJAJKDnXozJ89av+/mnASLpsne1ur2npyGJJUsSw+6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZZPF7Dr; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZZPF7Dr"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85e15dc801aso3104939f.2
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 11:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1744224256; x=1744829056; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wXLBtWFo1iG4jl/4yzD55CgxaVLgw5GIoTATgzYBQvE=;
        b=MZZPF7DrwrUwZz9kDHiOWf9ZW15dqA4VsFCpkbL4wQ5qTl2KmONsu9Z/Png8OuFuDd
         RTgPZTUdwW/ZZixnCIOTI2tNizJC3pS+rlJcHR73hyWnrPuHEEA8xcq5DrqymKqYULPJ
         GMXbvIIGyii7WeOTCggPi51UhCwIXiCQAus6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744224256; x=1744829056;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wXLBtWFo1iG4jl/4yzD55CgxaVLgw5GIoTATgzYBQvE=;
        b=XkzDH9H5e17xieemtitALkTZYGo8Ft14Lbvw8lrQdzEMdThKJcg73L4561QPTX6i71
         4gv9NNoQTHNLM8zjaSEmu1695knjOWRL20DoSrm4ymgKRkQkygOhCYcQcxfL8rFAdqQU
         KXROLBwm+nRujlWSecGcVYMU9Dwd3KosipIjdjSdin7rLTOtaIz1qyPO+P6p9RbLNnEJ
         KJ1Ui2nqg99UO1lY5RjYRc/NAkCDRG8C3R7GH5nlRWbwkxQS/OXRMwc0eqUN6DDzSmd7
         Gpvjm01uB/Ghy9jnIsFOJfpcaEt4DvgVHq+pfsGQgU816/8AMdKethUvZ5T1qJFUilOV
         q5jQ==
X-Gm-Message-State: AOJu0Yw5vdCVs+lQE+wImdvs1tsnF8KtQBGcfjANryGcFW7XzVnKsm1U
	z1+Moc9v6JsbUEPCMzgVlHWPuqXxGs2arl3d9uoRCLc9+lAQnmzcaiIp9w/Nm58=
X-Gm-Gg: ASbGncuagY2en0vCN1xweE6YjmREPGeXEgIoNFYC1xnoYSY4+0K5PVshex7iCke59uh
	pstv4u22QiBEo4GDS812yU7s5PoOeuDzHIv4uA5j7KtElZJ7rgEeX3Qn2bjRnroF7mGC0W2962+
	SxgvAJNQzSXdwGituRGyqx2QCbVU8++CoDN++Km6iNoET49eACeYrQVZZwd4jdSeYIQL9r3fxIl
	r9Tr4dOULokjXHYMOlrGYwHT1h7ix0jLkX5e9GCTBLO/KfD9I7CBlNbTr/mCHkh+lsoxrc06dYy
	rASG9ixtS1Q9dhLdoZ6dK/dbkUEStO3PDtfjdW4AQj+rCcQw0FxyVWxnOERlDw==
X-Google-Smtp-Source: AGHT+IGO28kEay463v+HtpsW5QZR5xULtav+EFlWbau8kOYwbqxV37888Qg1KR8L2HGq5JcQPyhIkQ==
X-Received: by 2002:a05:6602:394a:b0:85e:17c5:bb94 with SMTP id ca18e2360f4ac-86161188b7bmr497863839f.1.1744224256359;
        Wed, 09 Apr 2025 11:44:16 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-861656c8808sm28468639f.37.2025.04.09.11.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 11:44:15 -0700 (PDT)
Message-ID: <4f0ac0d1-9c75-4be7-ba3c-3daec2fdc91a@linuxfoundation.org>
Date: Wed, 9 Apr 2025 12:44:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/726] 6.14.2-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250409115934.968141886@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250409115934.968141886@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/25 06:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 726 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.2-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
