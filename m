Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2708D224D1
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 20:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727988881; cv=none; b=aC+OlKsD1VFUzv/v8TLvmzMl8+O+XQHO+qyuydy8/+rfG3gAKdDN9QE6yOca0lWymMOrhNA+fUzxEpiekunN0R4JKRKwCSYo1FXQCXTj+bDf8xCI7CeWEzZe3zQmTaWtRFToY8515/7JTQ3Se5cdvHEc96/ZIZ+c7Q5t50lAHmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727988881; c=relaxed/simple;
	bh=uszalte7XO9gWoLV2ANsEdQbWY4YytMyiL0XukH+s6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SdUSJNPv3vnoEPJ7VjI6ldYIw0Bnqs0ckqpyrQ7f/OyTg/WT27Lp4QBJY2oURD5wnEX7oHphECJGuj2AXsPFw3F56sLYvDO8wJfL47AufMYPyUevTSNZF4mGTXcykWlhtMOEvPjT6P04yEAv8Jjqg8DrinNY3XDQtBJFA3e7EWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6zBPSKO; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6zBPSKO"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a3636ddad6so4781595ab.2
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 13:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1727988877; x=1728593677; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nkVnHAarrjh9pxwlEl/XGXl+U0ORYx7Z9Mfm0whWCFo=;
        b=F6zBPSKOtrTeRBDg/GKEDBIHVmoyWzY5Iohad6cO7Xh3mubnA7FeoazmxqCAxQg/lg
         aonAeal68CZ89wPq37+JPy4gxhSMdjsYRBoV/oPOXr1jrCqt+04n0MoQqnj5K+tlgpEZ
         nGzACiVn2d5AGyPIZHPRmH0jQpoFGgqb+i2VA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727988877; x=1728593677;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nkVnHAarrjh9pxwlEl/XGXl+U0ORYx7Z9Mfm0whWCFo=;
        b=MztzZjhyeJpmEgBbuhCMPCwO1fPAMFc6IKWA9lCgXzlLGoMLrqvh8IqBBCe7slXaBJ
         p4Cw0ZRWmi8QpCjoG4nE/WlGpjGc59dkZl8eJA0MqrpWS/cbtz9la/xWRrBGaYbG9q0t
         OLbO5+uyfzBMx+6GfRdO0g262epMHk7Syvva5GZ96UYZykK9s4BJB+6AfPzXVeB+xFba
         2i0l4bTE43RP0xRZCKBdHfFQm+//wB/DzuE8/3U/2npCmLTBMFgKKwbaJSaPZe7n06eL
         4ouiA5IQMSTgVvF4tRvCY+VRVpSjLhlVy3+GOLB4I15m9xn4hMO8lOGw3AtRdnx3jQOj
         /1hg==
X-Gm-Message-State: AOJu0YwHpdH5+8mNz1AB5n1nJyVsGIfjVXps07gRYbnR5JjUNK2jW9QU
	6iR/Ow7L4xTKxGOBUNIostMH6wQgHHy+rbaq9fVixcrHshz3g7irPX1FVLUiFJY=
X-Google-Smtp-Source: AGHT+IHcHz5/fRhV6oV+9eeZbEYQcbkgMbnmGgramQS2e2MQ5OmtxRdBopTUS/FIudr8SMUKogEV7Q==
X-Received: by 2002:a05:6e02:12e3:b0:3a3:6b5d:7011 with SMTP id e9e14a558f8ab-3a375bb4be3mr4868385ab.19.1727988877212;
        Thu, 03 Oct 2024 13:54:37 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a37196c1dbsm3574965ab.34.2024.10.03.13.54.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2024 13:54:36 -0700 (PDT)
Message-ID: <68a440cc-ee1a-480d-8ee6-25b1e6188ebc@linuxfoundation.org>
Date: Thu, 3 Oct 2024 14:54:35 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/533] 6.6.54-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241003103209.857606770@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241003103209.857606770@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/3/24 04:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.54 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Oct 2024 10:30:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.54-rc2.gz
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

