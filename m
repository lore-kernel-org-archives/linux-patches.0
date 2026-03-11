Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F3F2DF3F2
	for <patches@lists.linux.dev>; Wed, 11 Mar 2026 20:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773262576; cv=none; b=Ltp2P0sGllrj1rzrRgY5OZBEDCi/2IV8VtouRbw+SOljM7hqGizzjkZXJpyv5GHyArr3BUmWAWlgjwZae2jfi8iiuiXe2hrZWA/CK4WzzIWYfKGJvwCL6cZBsTT796/fDJYEQGIKogURrc5hCLhUXaOaCUrfTO9shSNZEklz+go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773262576; c=relaxed/simple;
	bh=WGMNQ69br1zaLeyPFa7fZl2ve9t0B2t356Z8FghtmnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O3v23NRnyMDpleccALe290lVPLvpSxxi8zJUb+OIwC8m7sWnL9/9Kk3kBe8LZIpY7UIgdi0yPJNbWXEtfziywuNEPmOeIP9+kabABi36+y77Mv017UvOZvJlWp99vTZVankV2uiKf5CWfLcFKt/xWqwM1bfS7Y7wP0RbSXhfRsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Setrs3l6; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Setrs3l6"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-40974bf7781so1203776fac.0
        for <patches@lists.linux.dev>; Wed, 11 Mar 2026 13:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1773262574; x=1773867374; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FCmGm57by25NFaSpQsx1PArbJoD15y/mE7q9SJzUR8c=;
        b=Setrs3l626VE6+ng/RgeRigS2ktKz7/v6ol/wwUAFVbkFhqeQqmcjdBTGSieWA6wjf
         wYNM0aY0KG+F4or1lfXALK6+4Xwc8aYrC2yMo4cIh4nonRgN1mTo93E8Ol7T0unOrvay
         BUUcTinKPYarOUoiy+U4LM7uALBEkYaS7xe1U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773262574; x=1773867374;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FCmGm57by25NFaSpQsx1PArbJoD15y/mE7q9SJzUR8c=;
        b=kpEYyDBg9W9ssZM0TkompfNDb3z+/q6XVANfXQfADvFigYI3Rd2wlCrVwE8q6cg1d0
         /QEtK6c1O1eTfhBjCdEe0Qz1O5QSF5Q08jjYceyjG6eSn6wbyTCftCr7ejn36dUiOXMQ
         GR7ILnbQAj6ITXTlwNFF57d8wPlxCGhYYFJloZ+acOgjNfoGfAjbnmi48hWbkVegySKN
         tGgxwGmc92xMaqc9ghLmO3FgZnJXBykoviOzgaIq2NZ1HHY+epp3+7qigoNbmsUhD3y7
         hC4G6ULJaclh2Nsp2Wq/+P3F0e2p1Ozc/wOmcBQsqwRa4+VLZA14qiwOtqKTXf6z6zTd
         ulWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXS55kmvhmXQ6Qz9tiVu2i3eNlG2h+YZm+02yf4gnn7BKzfT7K/UViZsmlUx4QYjWmQ8qwKqhYl@lists.linux.dev
X-Gm-Message-State: AOJu0YyrmiozwPzs9Subt9Ix+HANtnYmoBlMRw5ccstuNCovZnBuwvWV
	ikzcSOwmEcp3ds+b8w7DHZs7mk2FK72kfbkGCvJcpCoSzn40GN+6SgOWL/1yMEDYmX8=
X-Gm-Gg: ATEYQzz/DEW8Y19fvWV4DygL1/6nUyTzA3Fy7/HyO+QvcAl2duFRgJvz7DULrWR9stU
	n1p1aQmmHRxdqxE19cMp6ZXvIrPBamQEbDYlbHK7CLtSITI4WsqvqpknI5PqG9Ixs40w2m9z0MR
	yahSPGU8HH4vCuQq8/SbzVvVJc20PKEsUoHpFhRLEQTh7C/U4yK73sjjc5JfoGDtM6j9RbomRxU
	ycaaiOXSqCPeRz3Z4hwTAy/MJeixCMJfuHKcQ/MeNiqPM4tDPlGgjYQN4PCCiMsiiUpqjbGlK36
	n8Ttf9Dz+VqDpoZTcK6G6T1xZzrLFa2MC5XQnrK5phD1PQSPTI98qUzHKlUPLhL4KYoRFNbJ8kU
	5APu5faS2L2o9byS/IWml5xPNkt1s1g8gZZk6a5/VB1qtrtLnlFD7ql6Vqut1/hIdPt6uzaFaXP
	vSvyOdMRI5E5STM9qMp9f4zYDnp5sPRSLYgUU=
X-Received: by 2002:a05:6870:9d08:b0:408:7ed6:e0a0 with SMTP id 586e51a60fabf-41798ed18camr665776fac.9.1773262573916;
        Wed, 11 Mar 2026 13:56:13 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e2df1ddsm3297417fac.9.2026.03.11.13.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 13:56:13 -0700 (PDT)
Message-ID: <4ddc79fe-7944-4a59-88cd-4800bc2047d7@linuxfoundation.org>
Date: Wed, 11 Mar 2026 14:56:11 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1773140654.git.sashal@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/26 05:05, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.19.7 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Mar 12 11:04:16 AM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/rawdiff/?id=linux-6.19.y&id2=v6.19.6
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
