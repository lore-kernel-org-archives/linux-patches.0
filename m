Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CC94594A
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 21:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717710872; cv=none; b=DvLuLtCV+3qAmgcytYLn7aiYSw907FNzKi/mPdJ9MemOzFLQbOci3HKgyQtABqp09yFsdI7JaFxdcwOBD1ndiRkRNd0uaOdXBXbKdgCkI1lLbprKqBHVlyVN41FzTCpOxUlHqJduNnhcpi/EzR/x5PYZJ7EQuY+22mHgQXFNsmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717710872; c=relaxed/simple;
	bh=vf0Ufb1PUxAG9pmi+PJkLABthEmCYjDOH0lbp8JYi5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a/hcgs+6iiqutq1GCiZ+miXuY+2rNhxQEN+/wPy+ZaGbD9qTJXKSyq4qLs2t5fmNBMFyuxTW4li9yKHBgbrzjpbkOssZuq2PXNTSJQi8cqiOnMn4l8vnCt1oasE5tt+KRAnXjMp252SLg8a4E9h55MOQZTQvIXVNkAp+rIkxVDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4Twf/Gs; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4Twf/Gs"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3745eb24ffaso941845ab.1
        for <patches@lists.linux.dev>; Thu, 06 Jun 2024 14:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1717710869; x=1718315669; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L7kNACQKOGLncpm7RzMHslqjx6wYTLSw1aGgkKbpYeo=;
        b=X4Twf/GsaA+0D3DHNHzMJHj6DHKremkQLqPKDKQktfAB6olVvyjZ8SuzKUoqQenMIL
         iahbt7LdeBkZMf88aV3tb89Ko3+qJlB1hFJRJ3imB8S2st8eiQUoUE0bRVCUo4Voxybi
         n1BKxz5A6M29rdhV21UbA2wNGHPrMffkSxd9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717710869; x=1718315669;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L7kNACQKOGLncpm7RzMHslqjx6wYTLSw1aGgkKbpYeo=;
        b=NQhQY4ne+ay0xnsfqLU6w3mK62TQ6ZgeKLNM/V+cBX87PLSz9+qr251398FjP3r8ZT
         qiStG6gGPmqyO6Xu/U7WBTIHVybi1CxGqsqQItS7U+FrnWgYaC+s7oU2vzjknCJ9ewvR
         bTUFrjxBBhfJjihAoboXhT+3QLWqRODgSaNL2W3BOECacZEeqhSXPuiQnUGYK4tZVDH3
         MXWgsgiRPkrtuMVgndQZuv4Jk0kEIORT/0NsJsu0/JnHB/7VmXKzTF6iCZawZwAu5xdW
         y63hiVvDcp8mXn6iR7Frx6T6AqAJCmXhpJb0sYAxWg+XaFJ86pkhNGluUrN8BbqXS4/4
         7WOw==
X-Gm-Message-State: AOJu0YzvDiYqVaItNAjN5vxr5ot1GXhkexHbixifSOXrEt2pWXE/dF7W
	NSA2HUP2q5S6ITUTjiiHBqBMmbyhpyUXc+pEq/OL0DXxDu2nofNKX/G5cB5TGpc=
X-Google-Smtp-Source: AGHT+IFeYU1/9CMMpnp75xeWU6hrcbz7tB1Wpo5gtKz1fbyTfMJyQbcsjrriRgqavCvA+akIdoDifA==
X-Received: by 2002:a05:6e02:1a8d:b0:374:9cfb:ee13 with SMTP id e9e14a558f8ab-37580236023mr8495385ab.0.1717710869435;
        Thu, 06 Jun 2024 14:54:29 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-374bc12e61csm4847025ab.11.2024.06.06.14.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jun 2024 14:54:29 -0700 (PDT)
Message-ID: <19aeb72f-e1fd-476c-b5d3-ecdd22597cce@linuxfoundation.org>
Date: Thu, 6 Jun 2024 15:54:28 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/473] 6.1.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/24 07:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.93 release.
> There are 473 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.93-rc1.gz
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

