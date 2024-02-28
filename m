Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3395A1E88D
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 16:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709138831; cv=none; b=d5UtBvSyDO9ZVgNeJCXja1erLet9Wd+emo+i2UaygvjgMzrP8TKbw9aowwiYVd243VfpHk0/GqyLrukGK7q9nd+kVQkYvtGqyDJDpavx4lrIdRY48wu2OjEajAGzv2+cvQ0yMhTbliGZ0rzO33rk+7ermG2XlWH/3K2LCPT/6lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709138831; c=relaxed/simple;
	bh=KPcr3OYgCWifWKWVCw+LkHgjmcQMX1AVYds8fD7Ng2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HzknKZQqPGwO90YIYFTGoRcuK1G3Plow/SNOLIvjsO6PBoowjK4WiufvLEPOlc6/DJbPzkCQqqjIybHBDh8Ubi0RjtzEH+Ik9MHwwg8XH3OiRK0E8vAph5wy7hazcEqeZHaHykU6js1F7S86llNNUqbYglFvSDBTqd68awR2mh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODBr2LjD; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODBr2LjD"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7c49c979b5dso114099739f.1
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 08:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709138828; x=1709743628; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gg6+Y4Ou57ZP9qky7zAH6w6hyVIm255CnHs2R3W5bvA=;
        b=ODBr2LjDPJLag/wUSkid0PwC/mHxwn9WIkI/FgDD1YgbIp+iazzq8ATqumRJv024KU
         4yC4INqBq5L+/P3OplcVWezw/j3+s1DLJ9l3S/vjoiIakycDa9+BNtfHjav/LOOYe9S0
         KiGMXvfwQpXsA8vVNsuHXUajDnkQvWWv21NdE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709138828; x=1709743628;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gg6+Y4Ou57ZP9qky7zAH6w6hyVIm255CnHs2R3W5bvA=;
        b=mRtxel7FhVPQzHxHUwDiMFt2XwZWJ8f5jrSPmKalznHNTJuhG8Uh8Dpy7aTAg46L/m
         bD+Xxx01d8jFCeJNiCKXaPuh41+bN06di7fTvx7CjBhtoFo3BOGtJVBSMw/+UfCVxIqb
         qDegK5sVOTKkoeorcCdQV80qFf80fkyLXte1h/+QcGadfFPaDCAjiYhLjUS+ZfOG+zPd
         1BQnxDiikj1VRHMK5bDfDMsK6PYSXssRa5gG5fXTA058RXUCz7kBS+Oy6piGOgmL4HSp
         GxWsWYq/q7RY2WRyUe8EJLlPdvg8kSKvCF6K3jkh23ex3Wp5mk6IraLpPsfDXFUzCfNM
         /7BQ==
X-Gm-Message-State: AOJu0YwiFNUxtTNwo5x35x6klDFVDsdEQN4ufq2DNzWYGr1NfQzVEx8d
	wxfM42hWINSipz7Uti7CSxv8HuHo8mxLge4TB4I5stU4bW/zyy7swYe7hlbqJQ8=
X-Google-Smtp-Source: AGHT+IFyRi8ePLaDpHmfI4NdCrm2iguFd4j4XQ4lNdB8vjhzI30N6HVQfNXNEev9wmy/CVVP0uQLaQ==
X-Received: by 2002:a05:6602:2195:b0:7c7:ce93:f532 with SMTP id b21-20020a056602219500b007c7ce93f532mr7742919iob.1.1709138828341;
        Wed, 28 Feb 2024 08:47:08 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id gj21-20020a0566386a1500b004748cbf37a0sm1376484jab.132.2024.02.28.08.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 08:47:07 -0800 (PST)
Message-ID: <17bdbb9e-5c3b-40cd-a13b-e4cfcb7ea0a1@linuxfoundation.org>
Date: Wed, 28 Feb 2024 09:47:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/245] 5.15.150-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 06:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.150 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.150-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
