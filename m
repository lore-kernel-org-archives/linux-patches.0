Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3881CAA4
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 16:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722011440; cv=none; b=JTQsmpQe2Gs22NSM1AA/24uxk7KsbUbGpS+ox9DAjShZK+o5v2ReyW0myzrV9KEZ85tE+eJmNhwPCT4Eh9VEN4Rche2Sn4zowGxa4DaBzC8uTtxhU9OSiDEMHLsX4Mid4UUiY0wmcRWAC6Ta/ViNWhivrxcpnQtDEO5SkSBuJME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722011440; c=relaxed/simple;
	bh=gDMA28RchPVIUSPpy2NsLvmc9SSvbe4A8VDvVnJjpjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pSVH0ST2p3I5RRyay0ega4AHFOhpHAYRC7KTIPv1GB6HnXmtAkJebuyBN2yKMVqMLLVr+rjUBEGdOubXJcZ+KmUJWXVgRRERc8o+r4s7HZM9+kX9JfokxK1oaWGeLSKO3MlrF3WMt3VvKLIdqm4L3ZVzag5C8uE9pqtaKvLkn7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkC706BG; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkC706BG"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-81f7faff04dso10208839f.1
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 09:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722011438; x=1722616238; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ClLEQhQ1iUwEnkwU32KsyDoCIxPM7UfxUV/C4tGu5Q=;
        b=SkC706BG+a5Ri8dsg11hzCkwt/Qg/g1D0AVcdkZAgK9PUs6ifxIXfP6hYQKKLijJVG
         lSQyrfnnWALZorAKA+ewm5GPrbVnMwTAVeQvJILCfx6Mo6M/75cShXsUj0h+EpKMaKQQ
         aH1GrSpsm8dCDgvA2SK/oeF87MLnobhKPS3hk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722011438; x=1722616238;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ClLEQhQ1iUwEnkwU32KsyDoCIxPM7UfxUV/C4tGu5Q=;
        b=HtKrw2+f6Z//r7VZEv6SsDqnlwr8EjGaW/gnG+CRVb1h9k6AQ7uQqFjzHIjnQB5Yor
         ywDXdVmCevVWmQXO3stfetEwda28ficjUisg2sDAyiVO0dP9HouCF1AzpHlfcBuXV7Yg
         EH8NjvRHAkLD13Kts7OJx0CyviA27YZIBkps5EeZMZB94Gn/0FV5FBOzyiFAUzgMZCHi
         hwKxDfh48SKecdimaHtJ6AQFQH19DxKW0iHqjwi1Iqyt51qy5bW5WMIPnWqHEjb9y+4Q
         6VZIXH6x8//EKzP64IE64h3Agg9cTa1HbHZRuqUy6uxv1LS9XfrvVLpp7j30PRwQ8AVT
         qjBA==
X-Gm-Message-State: AOJu0Yw8fwz5NdQYcTrBtWL6X8fmLMeecOwP2GyW0NlI9XS1xRZylT8o
	lQhJOxMoICmihLFff0zh0l5oXcmgf2CZWDT7piT/0KlxJTQ0X1HcqTmAKM3idBM=
X-Google-Smtp-Source: AGHT+IGMk/YlWYCQcj9bstzUYlzf1B2Mt+8v4lZOdHBd35dUk3+hk5LwYCW4NHTud/bjyL5DiQEYkw==
X-Received: by 2002:a5d:9943:0:b0:80a:9c66:3842 with SMTP id ca18e2360f4ac-81f7d035a19mr440179939f.3.1722011438283;
        Fri, 26 Jul 2024 09:30:38 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c29fa98dcdsm911843173.49.2024.07.26.09.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 09:30:37 -0700 (PDT)
Message-ID: <190987c6-d755-4c24-be11-1afb6ade852d@linuxfoundation.org>
Date: Fri, 26 Jul 2024 10:30:37 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 00/29] 6.9.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 08:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.12 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
