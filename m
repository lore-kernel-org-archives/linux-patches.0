Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D981EDA0B
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759335459; cv=none; b=Opu3N1tBpOEFmxLTfX4SPPHuBLrNZ18Cn2xm08kHATpNvcFOWb+VA1N24m5c8uChiIo9Yt7Y1WiblcuwdmA3GpxMAJJ9pzxy79tvAZPYw6mqBJkH70SGMktLgN5worjv18wCvbMjf0JWw4PTdV9zjUAXrNJU4v4X95/Xr038Ke0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759335459; c=relaxed/simple;
	bh=42WEIdqkfFBAo1Dv2IyGMKfPr9BeV+nb3loEHQqymqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bfHQnm/9ArlUqGa4Vb2+aqTpMEzwyl4fr/sSlt8sJpZ0+DF3o/GOB+81HQw3piHjhs7/eoKV3kFHNEnemiFekP0As3EqgTW5m46A8UZD57TDDTUwXPY4XZEg7jfkUxWuqO+kJiokOniLDbcwR32Q/B1itTtSByjdSYqQXWftiFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlPbXdJo; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlPbXdJo"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-42d8b15548eso110105ab.2
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 09:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1759335457; x=1759940257; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=te+5NbOWKHS/5qX08a4TSadV7+LggdZYvrui5XC1Ixg=;
        b=hlPbXdJoKAsaaPsW7zyGuHTpp4E/O7a7Xpr55WsVLAEbhH1kiRVWKUQqe0UqFFvAUC
         Tohd+Wp2XLjtgz5D+IrdzU/w6z+YShu2Pob1zn4VYKSJfSAJRqS8CtG5WKq1WVMS/KSD
         gsUFyePvNoeoTR8wR3CBGsolRYyp4JlTbpLdA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759335457; x=1759940257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=te+5NbOWKHS/5qX08a4TSadV7+LggdZYvrui5XC1Ixg=;
        b=PSH+UGsKo0sahyECapEhw6lwjui275Pon1EdCxZw9vQnY8M41WoLCA+lk9AeJrAlHh
         umX75CFVw56CQTmV2bGdXYPMpzUVrMYlKg9XjPP7NmtcqkCVcA1n5nBkfu8EnbwtUHAJ
         fIDuzPkCblLGS0E/lcZWazQcjGksby7JoRSw7B4ElaTCcQwKFzosv3UquK0h3ozMXYpM
         I8fCRKMpMdVZdYDQbTLjSIoLo1z/7CP96BSUzydKTV8fZVEE8Qe7ldZeUS5qNsndwNOc
         o/++Vj9v4GPj3DQa9EVRtrx0lsGSlqv4asqI6ljJkyJABlZPtSKAM42ShMJgJJw6cZ/n
         Ah0A==
X-Gm-Message-State: AOJu0Yxni+H5gpLC3TafGwhPUcDVwFEEkpKoEEIUa4Wo/mDe+MOLtpiC
	7OfPbUTzOh/41pXww6mdBuZXWGWLQEuZ0f44SWnx9tisnJ1Ks6ErGWCqrJWIKlOgRrM=
X-Gm-Gg: ASbGnculZuRBj/infVcrAjDn0jJIydl6qw2/qcbd1s1H/VtlPcQx2zidNUaDXj+oE+T
	YCDhy66Ulbcr9Loxi66eqG2yhF3ZwSynwVt9EQY96D8nwN8ebv3rn2R0CEzs1UkVqOKVpdMdteI
	5jnZCheBwh84rHmE7D9mwOAdyEpCclQ1M1K9mCUGIRaj94N9nBJhSmPGCQS+Y7RH6GW2lGRrE2S
	IbUvCZXQveaydJaKJ2lNQIK2A3M9leb9O2iQwPccIX10CIJ2TNQJb6VQoLw51ep7t6eaOkNeS8i
	zZnF/N5+oHf/9QxEYQqtNXKmKA6GPqa+Uary7Tdwd2A9XaGpiP1xuY2pMeFGkkXuDD/0/DHHkAQ
	C3n97CaXXTVSRJV83o5csSDRG70Yqln/E5eYtzoo1DXJdw5Y6PNKLY18BLIg=
X-Google-Smtp-Source: AGHT+IH0excAHZ+jMnE2ocUE86didFlaIgYk6DkZJGEMwQnc3kqU0Y4RCbD9igEPUrB7EaQwDn6QJQ==
X-Received: by 2002:a05:6e02:1c24:b0:429:792a:a8b1 with SMTP id e9e14a558f8ab-42d8161793bmr59555515ab.15.1759335456959;
        Wed, 01 Oct 2025 09:17:36 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-578cd957c45sm1392409173.34.2025.10.01.09.17.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 09:17:36 -0700 (PDT)
Message-ID: <92cf1715-4295-4ef0-b6fd-0774f4fcbf11@linuxfoundation.org>
Date: Wed, 1 Oct 2025 10:17:35 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/73] 6.1.155-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 08:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.155 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.155-rc1.gz
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
