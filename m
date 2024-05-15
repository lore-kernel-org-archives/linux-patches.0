Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A565DF3B
	for <patches@lists.linux.dev>; Wed, 15 May 2024 15:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715785700; cv=none; b=J5/hGMFHfZkdgPgspfaL+JCX2d7oV7eq7tJMQ0rvDn1QdYkkwZgLlNvkYNxmSXkOSoxzM+EDsGonDw72OUDFxo7rQzaYsJfXEq05BxA/sTWmbOuYxMXKesdstOvY4fQrtv7OVwFxdXv2B3k3BUmVopS9/DeyL0xqhr3nvCMRLK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715785700; c=relaxed/simple;
	bh=gRfOWhIoSyKemrb8DtpuxFtzGN1XUH+ReA+JPh8EG88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pPMwGmKfTvngKILwHSIGhbh8w5Wiq8fBfDhVRfNsAQvEbJwBSWzvvtAWAq6bxqyiF+srcWbXsEzDZz4Av635N63370jaHX/p+K/N6v7PvSHu5mbLz22LapOlHYJwU4kiuk7LFkkCVDcUkhta9mtmpu0fXesS6o0qBmwDwMy3T+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGrdVx+3; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGrdVx+3"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-36c6ea7d384so3405ab.2
        for <patches@lists.linux.dev>; Wed, 15 May 2024 08:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1715785698; x=1716390498; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PBLlj71inZ8mMsFWn7dN44R4dEBX7/1kMetgzAWjhNY=;
        b=KGrdVx+39ehyM4yNW4CCxblyE1mnsUEp44B3YixdZf0TWnNs4TEZgMIuUMC5+tn2I6
         Aq1VJVNyfXlVItiE8imI2DEoIzaD8osIrdBqjg++xRLhzkcXP4Cs10CbEybfUw/2qQuE
         SO2fk3dOAUHm/FLYc7CM+/7ZyO+hn3k5x5twE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715785698; x=1716390498;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PBLlj71inZ8mMsFWn7dN44R4dEBX7/1kMetgzAWjhNY=;
        b=N+0BvUxP45N1omBxW7FlLDp32WxfUYALAkE69imLq0rOb3U2QF7YMayIQgTOFIxm75
         XvO/oOgeHQmsvCm5al588+mvNP9Iy2o+vLktTSA31lX18qs9GOi0XZrtXVswAm+KQurg
         gH5DdyhXptxOrOtxcBXbjDhkgsylxSQ89/TuJSLGww5Xu54COwA9namxBZIUMoClmHns
         w3Ko2Za13h9NYUH52XUhdkzzAwU26yjWANt0nj/fQwFdtnjLTizIz3Gh5v7O9MtqApZh
         crPwHihw8YPO2rwYDYtSasbCiyQAYB3HM1dXPR8WigUnBuKirp+bhXK7hNidWzXLNTS8
         zvDg==
X-Gm-Message-State: AOJu0YzeeGYoryFzNe0G7SXl9EBSAFCgJqCMSLT4gmhEiLtGtanXfu1/
	ZVbGtBByTd9s6vgzhM6xhoMuYQt3yjnKoWrdkYyuH6cXCtfSi9cE5lbcfUPz8oA=
X-Google-Smtp-Source: AGHT+IFoS53qNQlUZHcoRAS86QlHWEiEiVWLsUoMhJOpc31no4AJSKfNUCayuVN6kr8LqkjR11VsYQ==
X-Received: by 2002:a92:d3d1:0:b0:36b:2a68:d7ee with SMTP id e9e14a558f8ab-36cc1444baemr159606765ab.1.1715785698377;
        Wed, 15 May 2024 08:08:18 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-36cb9d3fa8fsm31774145ab.8.2024.05.15.08.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 08:08:17 -0700 (PDT)
Message-ID: <bf443782-3dc7-4c98-839f-bcc7ea95d727@linuxfoundation.org>
Date: Wed, 15 May 2024 09:08:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/168] 5.15.159-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/24 04:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.159 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.159-rc1.gz
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
