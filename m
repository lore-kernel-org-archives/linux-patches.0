Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2775137BE66
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 16:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776790470; cv=none; b=BEC0WVNZhfQfwrKCORucKVD0BAbt2YA5QyhEYlUJuKdBMzeOOpeSv1HTw8yTuQKG9AxrzG7wjhPeDUq3IuRunIXHbB68Dx0BxLvneg/Y+RKyT+HdxLqDkCzhpNDZb8pLHL/nFY8QxWkwt6X7gd0BOR66mzCNoIR3hRm/Is2T2EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776790470; c=relaxed/simple;
	bh=kqn1+fEG+cfQy6eUAc2OHCPTOcWwUqrth1w+Id8q6kg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gT/YclJ/JYqd1MMI3v45Y3bY6IAp0stUCimo1ADprMHWuIa7yHUEedu4zSEiwdM4cDVi9cqctWuR1p6xgwQCFyxgzQKvlSKeShkYhwbb05kcWb2RH05PUUg1VJ2y+bXLzIV1u5PrEmb+wDxtos+xqdcUNp42J4hdVY3k7lCAqgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6m13K01; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6m13K01"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6948d7ccfbbso814255eaf.1
        for <patches@lists.linux.dev>; Tue, 21 Apr 2026 09:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1776790467; x=1777395267; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P2z/QHvIa+oproeoDjj/whBsGx2yqXPU54nMOYa/a5U=;
        b=A6m13K01/v0zAu6lv3nOrnXzbJgg/a+sdewgPBetkV0LGGf0SDIhm6ksXI8NfOG0C1
         GP8AlDifMym3oEUAtRrLTPUxQO2Q0JNj9MdQUyu/SWhdUMF0jj9+3zmvsSTOj8uejo8M
         bez1tHLIiVRJTrs0yFblS4ZRdcZ0PRfvpxoKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776790467; x=1777395267;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P2z/QHvIa+oproeoDjj/whBsGx2yqXPU54nMOYa/a5U=;
        b=Wh1DAObDXA2xR51d+1XjJiJBR9lfNXdGC0xPJQsF5BkdEhj+62U9VlhzguQ/GD5deA
         PRRJtbJPb+3DqFRvGZV+xb/5ZA0O79NJZUlw+pZFOg05ux3sr9XH9OhO4E6OSFFoZym6
         WGuC6mwU6vzjzN6MrKxJWa/h4VKSrmrPajW1b8V9DALH1gdnzefui8cEwvu5sqcpyNFT
         lpWDHZM2JfSyVt+qJBlxM53C9ePepkXEm6CU205NDi2q0LJD3ciSvH+ya69M7mWGb2nG
         KrOt1iz/fHaBLU4IsJkLhTtcAtpP2ZKYjlOE7v2CsSMTz0448Xt9EoT/OEW4gtRW2wCa
         N6MQ==
X-Gm-Message-State: AOJu0YyXT/j3zPvJ0J86QtFApmHdvszos+fv5hx35utJ373A2kmU6uvl
	PZ9xtj6FUMh/RJmGOl0kHzE4GHGKeo4CWREloU0bVU7lsX0a4VHL8GPqy3PLSb1oYzw/7B7EEqs
	uplz954E=
X-Gm-Gg: AeBDieum0w8FhaFvKB2y5PHN2DNDvW3VOBRFGEjhpu3y3VwQt0tyQH6Lm5QRQepBI4j
	djzQw3c+H+kMgDrpRGWqbkdeQrIAgjpuVJ9ilR1tmOSIA/ZJzs/3mQ7vLEvD6YfmrtZEl+arEe/
	1lWzm2YH10BXxU9OuT8r1ylf0zBPu19N//WKKa04fkTzVZ36XS698dOzl+YTCyBRNpAPxkYmuF8
	tvlUPgrV335Cdjq3UlC8sr7ZhyEafW+lmrBBEuIIl7vnWRZo7/tjgL8f+PGIG+7J+xKowbFhNVY
	N7z29JENmakSOHVI++p2A1sv34uosiGpj12G5ymnyHDgWEIulZpkdfvM3J5yg26Hqje9ZvsP10X
	ei+C61dl8VXehhSicveHjHLD8jlKYogEYT4KcJNYMMm4qIhhhC4BXfgQq1TVSU9UouLxglTSw6f
	SEGTwQBwfDyoQQZA33n1q9rgYLHazY4CKv73htckomoA==
X-Received: by 2002:a05:6820:a29a:20b0:694:8428:dfd2 with SMTP id 006d021491bc7-6948428e0e9mr3577578eaf.43.1776790467137;
        Tue, 21 Apr 2026 09:54:27 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69464eeee56sm9082421eaf.8.2026.04.21.09.54.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 09:54:26 -0700 (PDT)
Message-ID: <d7d09653-73fa-48bc-88e7-eefa5b3bacb8@linuxfoundation.org>
Date: Tue, 21 Apr 2026 10:54:25 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/162] 6.12.83-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 09:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.83 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.83-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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

