Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537B919CC05
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 15:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726067307; cv=none; b=aKyLAB5b6TIg/a+Cqivb5TuRokZMWDZ5j2X6vV/Ha7m27TBNY+SeExK9ixNehlQ8UbxD0QKvZmXgEf0SbLYjmgi8jOtDXL2jjkUQetXDJLZn3v6FFlW7MrSH8/BekzaJzI1+xk1rrVy7vAXkaBuLNzMS3ziPI4XSwG+tceOVr2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726067307; c=relaxed/simple;
	bh=xBgg5os0gk8trZVZg0H4rW2Gjl3RmKVNVYj5YhM0ylM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mGQ5pxxtF/Edl1D8CQlFSbR6CfAU2eHJl2R/DjdIm+b69LHOZe/1hNMUHbJmhvgiR9DIhRj9eAh7Ip2MdWZU9BE9bpIuJ0JbWgr6BEMChAm7Bl4MGiqEgpm//gDNFa/x/ueHGxBWIF6jLmwGOxIpvrYawH3vSmIOjeUtEgUVFoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoHq5R0n; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoHq5R0n"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-39f4ff22a49so33523615ab.1
        for <patches@lists.linux.dev>; Wed, 11 Sep 2024 08:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1726067304; x=1726672104; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=noal/gvZ7siOQnpRjSqJbDjWmvI+uJ1GjIEsFnwoiAs=;
        b=AoHq5R0nu/0Iq0AmBoiILfu2pEvhkxjYq2tCQwzn4Da3h2mbj7hNjT/Swf4ux7nMnp
         REBIzT84jz25m7dtRI2riS2brx4/QiRCVpAWgS0yvABC322NJM7u5l2v7UJuKWsqjp4t
         FAKQOnjEPLpwr0s3In+uj5or+dO1SPGNtVO74=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726067304; x=1726672104;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=noal/gvZ7siOQnpRjSqJbDjWmvI+uJ1GjIEsFnwoiAs=;
        b=IerwEVpQt5V2nczcO73Pd1KUHMt24lg4eGjvVH57p0NZ6M5lTTfveAdT3YyRD1SoJ2
         jl3VRa9yYVvac1xXNj7Fv9rDOV2P4PehAB9OPyrbrHzi+JJ0Iw5+lwo3qICOkpqKD5b1
         iNV+ATwU8/Dmybfw2jOBoE5HWuLOdAHj5n6hEPwTNABF+yZoUXUtE3j8KUHy/eT4EkeW
         p1ZQvZrY412wn0dxlKsEj2h6/NExmz48Ir011co+A4vPQHzPhWzIKCsJJsdNcs3gufYh
         +VVnjWGgXGpmVFG9SLJPOTO6XlVblxuR0EKEKHD9EzZb182f4/x8CmneyzKIIDkrltEN
         4X0g==
X-Gm-Message-State: AOJu0YwlydCGLaa0yDRGvMQmk1K6vPu9zcl2/325rvY7qTsqPZVihyov
	sm5Et6vjHiXJKYQlZotj0UZnJhEQx+BMksv1jcwpBVH8qtWcsFZrpxxCbOtnvNE=
X-Google-Smtp-Source: AGHT+IFEhnsGpi2hXP15HfwLXqcPm+UCgf3IMU4rdFoNpO8JwtAvbVGOANJoC8YL6NLJ+WDu4n47Yg==
X-Received: by 2002:a05:6e02:16c9:b0:39d:24de:daa0 with SMTP id e9e14a558f8ab-3a052399154mr166079565ab.20.1726067303868;
        Wed, 11 Sep 2024 08:08:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a058fc835asm26384145ab.9.2024.09.11.08.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 08:08:23 -0700 (PDT)
Message-ID: <6a9ec038-c00a-4a1d-85e8-adb1d257dc92@linuxfoundation.org>
Date: Wed, 11 Sep 2024 09:08:22 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/121] 5.4.284-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 03:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.284 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.284-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
