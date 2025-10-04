Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC71727EFE9
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 16:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759596909; cv=none; b=emLu0wqU6kdFoZk3xUiidk1sdBXbhYhjlwGMOsxLIkiOXIiS6hKOt+BcndawlV0xMdP9VdQQsBcFflnLNnSco17zVB0yrP5Cuc+psWKgZ0PNeTWZRnhuaqfbubySWRI4mEE/Af10C9R6qvzFsAkHrmBBkBfNvckTcYKSN4aS5sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759596909; c=relaxed/simple;
	bh=tsjBUA8ELBDzVXfzKmYIZr3bArGX2DI1so1CZI61+Vo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sIwl+rjo1me1IOfVveQqleHCKYwCrmQ2YdlX0tfxQkgDuNd4kYxrYIcMiKRKfW9jlYpn0MBMZq82/qxhAfGXB/QmN63TzPXruKIG9DuiBYiHZelSosr0/za67JRZMi/S7GK1VjeT9qFNOqWYEy6hfxIGmU9xxe60SEH7VDif6Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0Rs8wFA; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0Rs8wFA"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-9032edd72c1so382877239f.3
        for <patches@lists.linux.dev>; Sat, 04 Oct 2025 09:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1759596906; x=1760201706; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fgjgiZYlZMYzFou6GDp7zcb8froC/z/pnBhyitJ+ZRI=;
        b=O0Rs8wFAaHuAq5YE213poV8KxVdT2cXlmpq3wpGwATjeBEcCN0RHW28uwajHQWlvUL
         RuosgPS+32Hc7ylNerEXAIm/HCb5XFTHxd9wyqb9vKCVHHW9qj1C2uuavH7oczd3c88O
         FIXTu5acpVSCuwaNmPFM7qOC46tQQV2nZ3AwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759596906; x=1760201706;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fgjgiZYlZMYzFou6GDp7zcb8froC/z/pnBhyitJ+ZRI=;
        b=OWvcadmrcsCm20V3pclaGpwW/Y0qB144AoaIPv3nfmIItyzaQLkbSgHTJLaJaoILcx
         RC3ttZIhtjxVg6prAL/axlkQbuu3mofWl+kTHnJK5boptxmcqCPY31Wl7BsCVBUovvkW
         BAJalEr+U+d1EIkS7MYQeCSTFyv5hDshpc91P2eXTf5Pkk1dAuIi8jFPD+8rR5X+DMp3
         kZ7A0Y6GVtaQQQ5etG5EzhPbawU0YgNyiVGvJOzDGZVWWGI1lU5iwCXOGsHUDS9luvWo
         A5y7cVMfY2o1AODLyiQJNQRVIik54GVVpk4aVRybDw425PCcYuo7FLQtC7L5hMX22MYb
         MqBw==
X-Gm-Message-State: AOJu0Yy167WhCi7J7OdB+vEFelBGthF1i4lSXGwlemxwHLA3mxOcRo3Z
	Vr41kV9ajqj3cfzx5xhVD0U6YfqeCB8hDkTR1TOFvUeWxeseemapcFcsOswWfn+z4IQ=
X-Gm-Gg: ASbGncuw92iObutMx9hZqjaeOnOGqH91/jAtda8213eXAzSl5EvgSqOEWy12S+pdAhf
	CeAT5Bz6/8QWzPXBadjVCkS0cJqfYx8AoCR43JDrDtgnNVhgM2xpWEKPC09rSinMqDM099XRKEx
	Y/EOfqn4uKSsgT/n0sCtDkR6k98hfLNCi6a2yo0U083QNc+e0M+y+/nB7XCG4ZuGN93LD5PO9Xi
	4ITXVH5mqQnk570grBVnGw7S2uVGtwZHYQhXZd9Oae8YHxL3KlEHA/eiaNP3n9z0BWxE/YvF9Xp
	U6PHAR+7y6A9208WPBMkIPY25pg3DnvX3KkoQHkOH2CbZrKpe4QZuWA26M0HsbIOmjAO0kt4Z9k
	G3HhNTabLTGp4lu6WCI3yR69pBoTGTuHN4LYr7+avu0HToOnom/ecBpFcRQgghsN1UwcptZAdoX
	kRIPIC
X-Google-Smtp-Source: AGHT+IE6YD3b9wlJCqIM0+EJtLwGyyXpMTh1kGQiDpelqE7028RMdOYvJh94CXHwN6hfIiH86d1R1w==
X-Received: by 2002:a05:6e02:3788:b0:42e:7444:b019 with SMTP id e9e14a558f8ab-42e7adfe854mr95756255ab.32.1759596898253;
        Sat, 04 Oct 2025 09:54:58 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ebc83c5sm3108334173.45.2025.10.04.09.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Oct 2025 09:54:57 -0700 (PDT)
Message-ID: <7455752d-da89-44d0-9016-59c6a9b7b53b@linuxfoundation.org>
Date: Sat, 4 Oct 2025 10:54:56 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 00/14] 6.16.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251003160352.713189598@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/3/25 10:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.11 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
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
