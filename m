Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757DD374E41
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 17:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646477; cv=none; b=qYnQAoelntBGhKQWCQAaPBvekzHcTvbmLETbgRar9Y6TdLuzvTigZNqOZxawRQQArxowMXGm/vbPoiGeCQila8mVGJbKaMIf7ZJXZUQ26lkVJxp/ULu0gXOxqNV6B4vwD0etkACY3ObmSsJzSWSg0uvYyQ7o6SvmDlnVZO15Muk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646477; c=relaxed/simple;
	bh=gHkdNKVcIMCx3JF8WFK4Tom5aTnEdnHXdcfVtYRn5lw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ujcXSiLA7EVd0Y24UFd3h+J3TVOOsRVF5a9BBAFo9kLSZJKGMv+6RFv2MgAh5xr7AGzgYHdG0W7U4PH4cs2VskfmL/i5nYgRHgMEaLCdShRRtnLU0eDfRakI4VFmGdrNt/feUmBAZCl2fXBfDGn01R0jv29uGvDPf11m/Ez5LnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBKNyWUz; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBKNyWUz"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-66f747175d8so4126187eaf.0
        for <patches@lists.linux.dev>; Wed, 04 Mar 2026 09:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1772646475; x=1773251275; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rFS329oI199iyk0yECHEQFTEx3H950AE0WIADkJXPNo=;
        b=dBKNyWUzrNqdUCpFqj6RjtKQhe10wIT8KJmHiMclgcrf/wusBgo7Cm/h4ZcP0A1MVK
         7IdyE2Q/PT+bKYi2lnqgdIZBrUIwBgC8wQCzJZ7iknRocXT3csiIsxXFgnFqyhkNqs7E
         sGApHKylBOdHeQ8XwpV/3vLKn7KrfPiKxHjXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772646475; x=1773251275;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rFS329oI199iyk0yECHEQFTEx3H950AE0WIADkJXPNo=;
        b=fUAgXMhD0P53cOg8cHTLv0PsbwwuH2Sk/WBXCANu7vABfGymtdl8E1iKdMN/iKDOC7
         wEzlVj64ZT3l7jK6JeHFEUibO3hmEFT/pERz/TwMHlx67mdYNDRNtaY0kuE38ueKnkXQ
         t8m+C6GoBQvz3sLqH+XoZPq0HUlG/V8jmm868vlareA9AYUZZ/x4mVnSDgUr6M35Jbg6
         93hPGaqov+b8J6fnFOMNjUVCHFZ7RBU2Ic/wfO1KCWdo/U+woe1TyEDvmUyLQi4PRqLT
         F4SrOG7yQO2/pDv4FO6/XePpxrcTIOzsG1Pu+lJTk8aRkGs0RIyGCklq8PC3qr5KFjZl
         wY7w==
X-Forwarded-Encrypted: i=1; AJvYcCX0sEmlprpWdM+zSMPUlXAVrkrpdSlhztNW2exyGHXMpLQpwzaWMesxANWH60snPy6+d7paabtE@lists.linux.dev
X-Gm-Message-State: AOJu0YzhBJWnh9lznNigKWVFwjeOCiAOC6MHpcvSyLupMKPq5szOPJKr
	Jlvf+KpES7zEU44liZj3HL2AwOnSBgxJj8BEuA+hjUHQV2zfXZPFXWDBShALRs//AyQ=
X-Gm-Gg: ATEYQzxl5PFezrmqvgR2y+wSH/vy34GmwK09MOcfArvGocEsoqN9Rdu86RT43E35h3O
	4is5gzwoTl/IDE+dZB8lL6GQqGjLVy7Zkm/ZwPpEQn3D7ltdcmKj12PTC1W9BCyd+wU47cp2F14
	aWrfRIrvi7M16mzWZJsd5rFxFxTkd/QkUvB+y2mJgz4kH/5DICGzb8bjpuitFFLaHk8I/szicPr
	7pDSYJkYzazjm8TQaKTcsI9z2U+gHvlPphyp4aFoFwoNqqkmEmsBL9gBrfA86nXwZUFi1XlGmvl
	pChLHDyOGkAcD/6s5xysHCfWSyTE4c20Bfb28yadtT/uECuVZa31hnwOCPVWB4JsQZu0IyeTiM6
	UuccYJxlnWcRNZgSXtzcEw/zFw+4R6B2zXJ2js0rAQhM2RNf2FPUshp+LVr4e1Dl7Ohk/8n6Wo7
	lU+m3uBE3+nTum+au+Jr1eUBPvfy2Ogj9z54A=
X-Received: by 2002:a05:6820:1888:b0:679:f226:30f2 with SMTP id 006d021491bc7-67b177454e5mr1558379eaf.44.1772646475491;
        Wed, 04 Mar 2026 09:47:55 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41640b99b39sm13607804fac.10.2026.03.04.09.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 09:47:54 -0800 (PST)
Message-ID: <7fb4b6e8-9d43-4a5c-abac-157d9b631cac@linuxfoundation.org>
Date: Wed, 4 Mar 2026 10:47:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
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
References: <20260302160943.2522184-1-sashal@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260302160943.2522184-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/26 09:09, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:42 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.1.y&id2=v6.1.164
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

A bit late - but here it is:

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
